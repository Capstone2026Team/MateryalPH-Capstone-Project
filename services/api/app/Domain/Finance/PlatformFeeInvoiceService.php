<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Catalog\CatalogFileStore;
use App\Domain\Notifications\NotificationPolicy;
use App\Mail\PlatformFeeInvoiceMail;
use App\Models\User;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use RuntimeException;

/** One immutable, clearly labeled TEST service invoice per issued commission statement. */
final class PlatformFeeInvoiceService
{
    public const TEMPLATE = 'PLATFORM_FEE_INVOICE';

    public function capture(string $statementId): void
    {
        if (DB::transactionLevel() < 1) {
            throw new \LogicException('Invoice capture requires the statement issue transaction.');
        }
        $statement = DB::table('fee_statements')->where('id', $statementId)->first();
        if ($statement === null || $statement->issued_at === null || $statement->environment !== 'TEST' || $statement->issued_invoice_snapshot !== null) {
            throw new RuntimeException('The statement is not ready for TEST invoice capture.');
        }
        $snapshot = [
            'version' => 1, 'environment' => 'TEST', 'issuer' => 'MateryalPH (DEMO platform issuer)',
            'heading' => (string) $statement->invoice_heading, 'message' => (string) $statement->invoice_message,
            'invoice_number' => 'SAMPLE-PFI-'.Str::after((string) $statement->statement_reference, 'SAMPLE-STMT-'),
            'statement_reference' => (string) $statement->statement_reference,
            'statement_version' => (int) $statement->version,
            'billing_name' => (string) DB::table('vendor_organizations')->where('id', $statement->vendor_organization_id)->value('store_name'),
            'issued_on' => (string) $statement->issued_on, 'due_on' => (string) $statement->due_on,
            'period_start' => (string) $statement->period_start, 'period_end' => (string) $statement->period_end,
            'charges_centavos' => (int) $statement->charges_centavos, 'credits_centavos' => (int) $statement->credits_centavos,
            'total_centavos' => max(0, (int) $statement->charges_centavos - (int) $statement->credits_centavos),
            'lines' => DB::table('fee_statement_lines as l')->leftJoin('fee_assessments as f', 'f.id', '=', 'l.fee_assessment_id')->leftJoin('orders as o', 'o.id', '=', 'f.order_id')
                ->where('l.fee_statement_id', $statementId)->orderBy('l.created_at')->orderBy('l.id')->get(['l.id', 'l.line_type', 'l.description', 'l.amount_centavos', 'o.reference', 'f.commission_basis_points', 'f.commission_basis_centavos'])
                ->map(static fn (object $line): array => ['id' => (string) $line->id, 'type' => (string) $line->line_type, 'description' => (string) $line->description,
                    'order_reference' => $line->reference, 'rate_basis_points' => $line->commission_basis_points === null ? null : (int) $line->commission_basis_points,
                    'basis_centavos' => $line->commission_basis_centavos === null ? null : (int) $line->commission_basis_centavos,
                    'amount_centavos' => (int) $line->amount_centavos])->all(),
        ];
        // Canonical JSON survives PostgreSQL JSONB key ordering when the worker verifies the snapshot.
        $json = self::canonical($snapshot);
        DB::table('fee_statements')->where('id', $statementId)->update(['issued_invoice_snapshot' => $json, 'issued_invoice_hash' => hash('sha256', $json)]);
    }

    public function mail(User $owner, object $notice): ?PlatformFeeInvoiceMail
    {
        if ($owner->account_type !== 'VENDOR' || ! app(NotificationPolicy::class)->allows($owner, $notice)) {
            return null;
        }

        $organizationId = app(AccountAccess::class)->resolve($owner)['organization_id'];

        return Cache::lock('platform-fee-invoice:'.$notice->resource_id, 120)->block(5, function () use ($owner, $notice, $organizationId): ?PlatformFeeInvoiceMail {
            $statement = DB::table('fee_statements')->where('id', $notice->resource_id)->where('vendor_organization_id', $organizationId)->where('environment', 'TEST')->whereNotNull('issued_at')->first();
            if ($statement === null || $statement->issued_invoice_snapshot === null) {
                throw new RuntimeException('The issued platform invoice snapshot is unavailable.');
            }
            $snapshot = json_decode((string) $statement->issued_invoice_snapshot, true, flags: JSON_THROW_ON_ERROR);
            if (! hash_equals((string) $statement->issued_invoice_hash, hash('sha256', self::canonical($snapshot)))) {
                throw new RuntimeException('The issued platform invoice snapshot failed its integrity check.');
            }
            $record = DB::table('invoice_records')->where('fee_statement_id', $statement->id)->where('invoice_type', 'PLATFORM_SERVICE_INVOICE')->whereNull('amends_invoice_record_id')->first();
            if ($record === null) {
                $bytes = app(PlatformFeeInvoiceRenderer::class)->render($snapshot);
                $disk = app(CatalogFileStore::class)->privateDisk();
                $fileId = (string) Str::uuid7();
                $key = 'private/platform-invoices/'.app()->environment().'/'.$statement->id.'/'.$fileId.'.pdf';
                // Rendering and storage take place outside database locks.
                if (! Storage::disk($disk)->put($key, $bytes, ['visibility' => 'private'])) {
                    throw new RuntimeException('Platform invoice storage is unavailable.');
                }
                $record = DB::transaction(function () use ($statement, $snapshot, $bytes, $disk, $key, $fileId): object {
                    DB::table('fee_statements')->where('id', $statement->id)->lockForUpdate()->first();
                    $existing = DB::table('invoice_records')->where('fee_statement_id', $statement->id)->where('invoice_type', 'PLATFORM_SERVICE_INVOICE')->whereNull('amends_invoice_record_id')->first();
                    if ($existing !== null) {
                        return $existing;
                    }
                    $hash = hash('sha256', $bytes);
                    DB::table('files')->insert(['id' => $fileId, 'owner_type' => 'FEE_STATEMENT', 'owner_id' => $statement->id, 'purpose' => 'PLATFORM_SERVICE_INVOICE',
                        'visibility' => 'PRIVATE', 'content_type' => 'application/pdf', 'byte_size' => strlen($bytes), 'checksum_sha256' => $hash,
                        'scan_state' => 'CLEAN', 'object_key' => $key, 'retention_class' => 'FINANCIAL_HISTORY', 'original_name' => self::filename($snapshot),
                        'metadata' => json_encode(['source' => 'GENERATED_SNAPSHOT', 'disk' => $disk], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
                    $id = (string) Str::uuid7();
                    DB::table('invoice_records')->insert(['id' => $id, 'vendor_organization_id' => $statement->vendor_organization_id, 'fee_statement_id' => $statement->id,
                        'environment' => 'TEST', 'invoice_type' => 'PLATFORM_SERVICE_INVOICE', 'document_origin' => 'PLATFORM_SAMPLE', 'issuer' => $snapshot['issuer'],
                        'payee_name' => $snapshot['billing_name'], 'invoice_number_display' => $snapshot['invoice_number'], 'invoice_number_hash' => hash('sha256', $snapshot['invoice_number']),
                        'issued_on' => $snapshot['issued_on'], 'amount_centavos' => $snapshot['total_centavos'], 'file_id' => $fileId, 'content_hash' => $hash,
                        'commercial_snapshot' => (string) $statement->issued_invoice_snapshot, 'source_system' => 'PLATFORM_SAMPLE', 'invoicing_method' => 'PDF', 'created_at' => now(), 'updated_at' => now()]);

                    return DB::table('invoice_records')->where('id', $id)->first();
                });
            }
            $file = DB::table('files')->where('id', $record->file_id)->where('owner_type', 'FEE_STATEMENT')->where('owner_id', $statement->id)
                ->where('visibility', 'PRIVATE')->where('scan_state', 'CLEAN')->where('content_type', 'application/pdf')->first();
            if ($file === null) {
                throw new RuntimeException('The platform invoice attachment is unavailable.');
            }
            $disk = json_decode((string) $file->metadata, true, flags: JSON_THROW_ON_ERROR)['disk'];
            $bytes = Storage::disk($disk)->get((string) $file->object_key);
            if (strlen($bytes) !== (int) $file->byte_size || ! hash_equals((string) $record->content_hash, hash('sha256', $bytes))
                || ! hash_equals((string) $file->checksum_sha256, hash('sha256', $bytes)) || ! str_starts_with($bytes, '%PDF-')) {
                throw new RuntimeException('The platform invoice attachment failed its integrity check.');
            }

            $currentOwner = User::query()->find($owner->getKey());

            return $currentOwner instanceof User && app(NotificationPolicy::class)->allows($currentOwner, $notice) ? new PlatformFeeInvoiceMail($snapshot, $bytes, self::filename($snapshot)) : null;
        });
    }

    /** @param array<string, mixed> $snapshot */
    private static function filename(array $snapshot): string
    {
        return Str::slug((string) $snapshot['invoice_number']).'.pdf';
    }

    /** @param array<mixed> $value */
    private static function canonical(array $value): string
    {
        return json_encode(self::sorted($value), JSON_THROW_ON_ERROR | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    }

    /** @param array<mixed> $data
     * @return array<mixed> */
    private static function sorted(array $data): array
    {
        if (! array_is_list($data)) {
            ksort($data);
        }
        foreach ($data as &$item) {
            if (is_array($item)) {
                $item = self::sorted($item);
            }
        }

        return $data;
    }
}
