<?php

declare(strict_types=1);

namespace App\Domain\Disputes;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Catalog\CatalogFileStore;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\OutboxPublisher;
use App\Models\User;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Symfony\Component\HttpFoundation\StreamedResponse;

/**
 * Vendor case export (CSV of case headers only: no evidence, no amounts beyond the requested remedy, no Buyer
 * contacts). The export is a queued job whose requester is re-authorized when it runs and again on every download,
 * so switching the staff dispute flag off revokes an export that is queued, running or ready. Spreadsheet-formula
 * injection is neutralized in every cell; downloads are audited and the file expires after 24 hours.
 */
final class DisputeExportService
{
    public const TYPE = 'VENDOR_DISPUTE_CASES';

    public function __construct(
        private readonly DisputeAccess $access,
        private readonly AccountAccess $accounts,
        private readonly CatalogFileStore $store,
        private readonly OutboxPublisher $outbox,
        private readonly AuditRecorder $audit,
    ) {}

    /**
     * @param  array{group?: string|null}  $filters
     * @return array<string, mixed>
     */
    public function request(Request $request, array $filters): array
    {
        $scope = $this->access->vendorScope($request);
        $this->access->require($scope, DisputeAccess::EXPORT, 'Case exports are not available to your role.');
        $id = (string) Str::uuid7();
        DB::transaction(function () use ($id, $scope, $filters, $request): void {
            DB::table('data_exports')->insert(['id' => $id, 'requested_by_user_id' => $scope['user_id'], 'export_type' => self::TYPE, 'filters' => json_encode(['group' => $filters['group'] ?? 'ALL'], JSON_THROW_ON_ERROR),
                'reason' => 'Vendor dispute case export', 'file_id' => null, 'state' => 'QUEUED', 'expires_at' => null, 'vendor_organization_id' => $scope['organization_id'],
                'requested_role' => $scope['role'], 'created_at' => now(), 'updated_at' => now()]);
            $this->outbox->publish('DISPUTE_EXPORT_REQUESTED', 'DATA_EXPORT', $id, ['export_id' => $id]);
            $this->audit->account($request, 'DISPUTE_EXPORT_REQUESTED', 'DATA_EXPORT', $id);
        });

        return $this->present(DB::table('data_exports')->where('id', $id)->first());
    }

    /** @return list<array<string, mixed>> */
    public function list(Request $request): array
    {
        $scope = $this->access->vendorScope($request);
        $this->access->require($scope, DisputeAccess::EXPORT, 'Case exports are not available to your role.');

        return DB::table('data_exports')->where('vendor_organization_id', $scope['organization_id'])->where('export_type', self::TYPE)->where('requested_by_user_id', $scope['user_id'])
            ->orderByDesc('created_at')->limit(10)->get()->map(fn (object $row): array => $this->present($row))->values()->all();
    }

    /** Post-commit worker: builds the CSV only if the requester still holds export access right now. */
    public function process(string $exportId): void
    {
        $export = DB::table('data_exports')->where('id', $exportId)->first();
        if ($export === null || $export->state !== 'QUEUED') {
            return;
        }
        if (! $this->stillAllowed($export)) {
            DB::table('data_exports')->where('id', $exportId)->where('state', 'QUEUED')->update(['state' => 'REVOKED', 'revoked_at' => now(), 'revocation_reason' => 'ACCESS_REVOKED', 'updated_at' => now()]);

            return;
        }
        $filters = json_decode((string) $export->filters, true) ?: [];
        $states = DisputeQueries::VENDOR_GROUPS[$filters['group'] ?? 'ALL'] ?? [...DisputeRules::ACTIVE, ...DisputeRules::CONCLUDED];
        $rows = DB::table('dispute_cases as c')->join('orders as o', 'o.id', '=', 'c.order_id')->where('c.vendor_organization_id', $export->vendor_organization_id)->whereIn('c.status', $states)
            ->orderBy('c.created_at')->limit(5000)->get(['c.reference', 'o.reference as order_reference', 'c.status', 'c.issue_type', 'c.requested_remedy', 'c.filed_by_party', 'c.remedy_state', 'c.created_at', 'c.concluded_at']);
        $lines = [['Case ID', 'Order ID', 'Status', 'Issue type', 'Requested remedy', 'Filed by', 'Remedy state', 'Filed (Asia/Manila)', 'Concluded (Asia/Manila)']];
        foreach ($rows as $row) {
            $lines[] = [$row->reference, $row->order_reference, $row->status, $row->issue_type, $row->requested_remedy, $row->filed_by_party, $row->remedy_state,
                self::manila($row->created_at), self::manila($row->concluded_at)];
        }
        $csv = implode("\r\n", array_map(static fn (array $line): string => implode(',', array_map(self::cell(...), $line)), $lines))."\r\n";
        $fileId = (string) Str::uuid7();
        $disk = $this->store->privateDisk();
        $key = 'private/vendor_organization/'.$export->vendor_organization_id.'/exports/'.$fileId.'.csv';
        Storage::disk($disk)->put($key, $csv, ['visibility' => 'private']);
        DB::transaction(function () use ($export, $fileId, $key, $csv, $disk, $rows): void {
            $locked = DB::table('data_exports')->where('id', $export->id)->lockForUpdate()->first();
            if ($locked->state !== 'QUEUED' || ! $this->stillAllowed($locked)) {
                // Revoked while running: the built file is discarded rather than delivered.
                Storage::disk($disk)->delete($key);
                if ($locked->state === 'QUEUED') {
                    DB::table('data_exports')->where('id', $export->id)->update(['state' => 'REVOKED', 'revoked_at' => now(), 'revocation_reason' => 'ACCESS_REVOKED', 'updated_at' => now()]);
                }

                return;
            }
            DB::table('files')->insert(['id' => $fileId, 'owner_type' => 'VENDOR_ORGANIZATION', 'owner_id' => $export->vendor_organization_id, 'purpose' => 'DISPUTE_EXPORT', 'visibility' => 'PRIVATE',
                'content_type' => 'text/csv', 'byte_size' => strlen($csv), 'checksum_sha256' => hash('sha256', $csv), 'scan_state' => 'CLEAN', 'object_key' => $key, 'retention_class' => 'OPERATIONAL_EXPORT',
                'original_name' => 'dispute-cases.csv', 'uploaded_by_user_id' => $export->requested_by_user_id, 'metadata' => json_encode(['source' => 'EXPORT', 'disk' => $disk], JSON_THROW_ON_ERROR),
                'created_at' => now(), 'updated_at' => now()]);
            DB::table('data_exports')->where('id', $export->id)->update(['state' => 'READY', 'file_id' => $fileId, 'row_count' => $rows->count(), 'completed_at' => now(), 'expires_at' => now()->addDay(), 'updated_at' => now()]);
        });
    }

    public function download(Request $request, string $exportId): StreamedResponse
    {
        $scope = $this->access->vendorScope($request);
        $this->access->require($scope, DisputeAccess::EXPORT, 'Case exports are not available to your role.');
        $export = DB::table('data_exports')->where('id', DisputeAccess::uuid($exportId))->where('vendor_organization_id', $scope['organization_id'])->where('export_type', self::TYPE)
            ->where('requested_by_user_id', $scope['user_id'])->first();
        if ($export === null || $export->state !== 'READY' || $export->file_id === null || ($export->expires_at !== null && CarbonImmutable::parse((string) $export->expires_at)->isPast())) {
            throw new AuthenticationException('EXPORT_NOT_AVAILABLE', 'This export is not available. Request a new one.', 404);
        }
        $file = DB::table('files')->where('id', $export->file_id)->first();
        $metadata = json_decode((string) ($file->metadata ?? '{}'), true) ?: [];
        $stream = Storage::disk(is_string($metadata['disk'] ?? null) ? $metadata['disk'] : $this->store->privateDisk())->readStream((string) $file->object_key);
        if (! is_resource($stream)) {
            throw new AuthenticationException('FILE_UNAVAILABLE', 'The export is temporarily unavailable.', 503);
        }
        $this->audit->account($request, 'DISPUTE_EXPORT_DOWNLOADED', 'DATA_EXPORT', (string) $export->id, after: ['sha256' => (string) $file->checksum_sha256]);

        return response()->streamDownload(static function () use ($stream): void {
            fpassthru($stream);
            fclose($stream);
        }, 'dispute-cases.csv', ['Content-Type' => 'text/csv; charset=UTF-8', 'Cache-Control' => 'private, no-store', 'X-Content-Type-Options' => 'nosniff']);
    }

    private function stillAllowed(object $export): bool
    {
        $user = User::query()->find($export->requested_by_user_id);
        if (! $user instanceof User) {
            return false;
        }
        try {
            $scope = $this->accounts->resolve($user);
        } catch (AuthenticationException) {
            return false;
        }

        return $scope['organization_id'] === $export->vendor_organization_id && in_array(DisputeAccess::EXPORT, $scope['permissions'], true);
    }

    /** @return array<string, mixed> */
    private function present(object $row): array
    {
        return ['id' => (string) $row->id, 'state' => (string) $row->state, 'row_count' => $row->row_count === null ? null : (int) $row->row_count,
            'requested_at' => CarbonImmutable::parse((string) $row->created_at)->toIso8601String(), 'completed_at' => $row->completed_at === null ? null : CarbonImmutable::parse((string) $row->completed_at)->toIso8601String(),
            'expires_at' => $row->expires_at === null ? null : CarbonImmutable::parse((string) $row->expires_at)->toIso8601String(), 'revocation_reason' => $row->revocation_reason];
    }

    private static function cell(mixed $value): string
    {
        $text = (string) ($value ?? '');
        if ($text !== '' && in_array($text[0], ['=', '+', '-', '@', "\t", "\r"], true)) {
            $text = "'".$text;
        }

        return '"'.str_replace('"', '""', $text).'"';
    }

    private static function manila(mixed $value): string
    {
        return $value === null ? '' : CarbonImmutable::parse((string) $value)->setTimezone(DisputeRules::TIMEZONE)->format('Y-m-d H:i');
    }
}
