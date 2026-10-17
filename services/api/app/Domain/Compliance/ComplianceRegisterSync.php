<?php

declare(strict_types=1);

namespace App\Domain\Compliance;

use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Monthly refresh of a DTI-BPS register from an authorized feed. An unchanged
 * file creates nothing. A changed file becomes a DRAFT snapshot like an Admin
 * import; it is activated automatically only when configured and when it is not
 * much smaller than the active snapshot (a truncated download must never replace
 * a complete register).
 */
final class ComplianceRegisterSync
{
    public const MIN_ROW_RATIO = 0.9;

    public function __construct(private readonly ComplianceRegisterSource $source, private readonly ComplianceRegisterImporter $importer) {}

    /** @return array{register_kind: string, outcome: string, register_id: ?string, row_count: ?int} */
    public function sync(string $kind, bool $autoActivate): array
    {
        if (! $this->source->configured($kind)) {
            return ['register_kind' => $kind, 'outcome' => 'NOT_CONFIGURED', 'register_id' => null, 'row_count' => null];
        }
        $download = $this->source->fetch($kind);
        try {
            $hash = (string) hash_file('sha256', $download['path']);
            $same = DB::table('compliance_reference_registers')->where('register_kind', $kind)->whereIn('status', ['DRAFT', 'ACTIVE'])->where('content_hash', $hash)->value('id');
            if ($same !== null) {
                return ['register_kind' => $kind, 'outcome' => 'UNCHANGED', 'register_id' => (string) $same, 'row_count' => null];
            }
            $file = new UploadedFile($download['path'], 'register-'.Str::lower($kind).'.'.$download['extension'], null, null, true);
            $result = $this->importer->import($file, $kind, $download['source_reference'], now('Asia/Manila')->toDateString(), null, 'FEED');
            $this->audit('COMPLIANCE_REGISTER_IMPORTED', $result['id'], ['register_kind' => $kind, 'rows' => $result['row_count'], 'rejected_rows' => $result['rejected_row_count'], 'channel' => 'FEED']);
            $activeRows = (int) DB::table('compliance_reference_registers')->where('register_kind', $kind)->where('status', 'ACTIVE')->value('row_count');
            if (! $autoActivate || $result['row_count'] < (int) ceil($activeRows * self::MIN_ROW_RATIO)) {
                return ['register_kind' => $kind, 'outcome' => 'DRAFT_CREATED', 'register_id' => $result['id'], 'row_count' => $result['row_count']];
            }
            $this->importer->activate($result['id'], null);
            $this->audit('COMPLIANCE_REGISTER_ACTIVATED', $result['id'], ['register_kind' => $kind, 'snapshot_date' => $result['snapshot_date'], 'channel' => 'FEED']);

            return ['register_kind' => $kind, 'outcome' => 'ACTIVATED', 'register_id' => $result['id'], 'row_count' => $result['row_count']];
        } catch (AuthenticationException $exception) {
            return ['register_kind' => $kind, 'outcome' => 'REJECTED_'.$exception->errorCode, 'register_id' => null, 'row_count' => null];
        } finally {
            @unlink($download['path']);
        }
    }

    /** @param array<string, mixed> $after */
    private function audit(string $action, string $registerId, array $after): void
    {
        DB::table('audit_logs')->insert(['id' => (string) Str::uuid7(), 'actor_user_id' => null, 'actor_role' => 'SYSTEM', 'action' => $action, 'resource_type' => 'COMPLIANCE_REFERENCE_REGISTER',
            'resource_id' => $registerId, 'after' => json_encode($after, JSON_THROW_ON_ERROR), 'correlation_id' => 'scheduler', 'succeeded' => true, 'created_at' => now(), 'updated_at' => now()]);
    }
}
