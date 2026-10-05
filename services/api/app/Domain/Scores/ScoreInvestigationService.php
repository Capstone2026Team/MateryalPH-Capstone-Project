<?php

declare(strict_types=1);

namespace App\Domain\Scores;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Reviews\ReviewAccess;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Admin investigation of incorrect or fraudulent score sources. A confirmed correction is a reversible exclusion of
 * one order (FRAUD, DUPLICATE, TEST or INVALID_SOURCE) that removes every review and metric event of that order from
 * later snapshots; badge display may be suppressed only for a documented fraud or compliance case with a case
 * reference. Both are audited and reversible by a recorded revocation/lift. Nothing here sets a score or awards a badge.
 */
final class ScoreInvestigationService
{
    public const INVESTIGATE = 'scores.investigate';

    public const EXCLUSION_REASONS = ['FRAUD', 'DUPLICATE', 'TEST', 'INVALID_SOURCE'];

    public const SUPPRESSION_REASONS = ['FRAUD', 'COMPLIANCE'];

    public function __construct(private readonly ReviewAccess $access, private readonly CatalogAccess $keys, private readonly AuditRecorder $audit) {}

    /** @param array{order_id: string, reason_code: string, note: string} $input */
    public function exclude(Request $request, string $vendorId, array $input): void
    {
        $scope = $this->access->admin($request, self::INVESTIGATE);
        $this->once($request, 'SCORE_EXCLUDE', $vendorId, function () use ($request, $vendorId, $input, $scope): void {
            $order = DB::table('orders')->where('id', ReviewAccess::uuid($input['order_id']))->where('vendor_organization_id', ReviewAccess::uuid($vendorId))->lockForUpdate()->first();
            if ($order === null) {
                throw new AuthenticationException('ORDER_NOT_FOUND', 'Choose an order of this Vendor.', 404);
            }
            if (DB::table('score_exclusions')->where('order_id', $order->id)->whereNull('revoked_at')->exists()) {
                throw new AuthenticationException('SCORE_EXCLUSION_EXISTS', 'This order is already excluded from scores.', 409);
            }
            $id = (string) Str::uuid7();
            DB::table('score_exclusions')->insert(['id' => $id, 'order_id' => $order->id, 'vendor_organization_id' => $order->vendor_organization_id, 'reason_code' => $input['reason_code'], 'note' => $input['note'],
                'created_by_user_id' => $request->user()->getKey(), 'created_role' => $scope['role'], 'correlation_id' => (string) $request->attributes->get('correlation_id'), 'created_at' => now(), 'updated_at' => now()]);
            $this->audit->account($request, 'SCORE_SOURCE_EXCLUDED', 'ORDER', (string) $order->id, after: ['exclusion_id' => $id, 'reason_code' => $input['reason_code']], reason: $input['note']);
        });
    }

    public function revokeExclusion(Request $request, string $exclusionId, string $reason): void
    {
        $this->access->admin($request, self::INVESTIGATE);
        $this->once($request, 'SCORE_EXCLUSION_REVOKE', $exclusionId, function () use ($request, $exclusionId, $reason): void {
            $exclusion = DB::table('score_exclusions')->where('id', ReviewAccess::uuid($exclusionId))->lockForUpdate()->first();
            if ($exclusion === null) {
                throw new AuthenticationException('SCORE_EXCLUSION_NOT_FOUND', 'This exclusion is unavailable.', 404);
            }
            if ($exclusion->revoked_at !== null) {
                throw new AuthenticationException('SCORE_EXCLUSION_REVOKED', 'This exclusion was already reversed.', 409);
            }
            DB::table('score_exclusions')->where('id', $exclusion->id)->update(['revoked_at' => now(), 'revoked_by_user_id' => $request->user()->getKey(), 'revoke_reason' => $reason, 'updated_at' => now()]);
            $this->audit->account($request, 'SCORE_SOURCE_RESTORED', 'ORDER', (string) $exclusion->order_id, ['exclusion_id' => $exclusion->id], ['revoked' => true], reason: $reason);
        });
    }

    /** @param array{badge_code: string, reason_code: string, case_reference: string, note: string} $input */
    public function suppress(Request $request, string $vendorId, array $input): void
    {
        $scope = $this->access->admin($request, self::INVESTIGATE);
        $this->once($request, 'BADGE_SUPPRESS', $vendorId, function () use ($request, $vendorId, $input, $scope): void {
            $organization = DB::table('vendor_organizations')->where('id', ReviewAccess::uuid($vendorId))->lockForUpdate()->first(['id']);
            $badge = DB::table('badge_definitions')->where('code', $input['badge_code'])->whereIn('code', BadgeService::STORED)->first(['id']);
            if ($organization === null || $badge === null) {
                throw new AuthenticationException('BADGE_NOT_FOUND', 'Choose a Vendor and an automatic badge.', 404);
            }
            if (DB::table('badge_suppressions')->where('vendor_organization_id', $organization->id)->where('badge_definition_id', $badge->id)->whereNull('lifted_at')->exists()) {
                throw new AuthenticationException('BADGE_ALREADY_SUPPRESSED', 'This badge is already suppressed for this Vendor.', 409);
            }
            $id = (string) Str::uuid7();
            DB::table('badge_suppressions')->insert(['id' => $id, 'vendor_organization_id' => $organization->id, 'badge_definition_id' => $badge->id, 'reason_code' => $input['reason_code'],
                'case_reference' => $input['case_reference'], 'note' => $input['note'], 'created_by_user_id' => $request->user()->getKey(), 'created_role' => $scope['role'],
                'correlation_id' => (string) $request->attributes->get('correlation_id'), 'created_at' => now(), 'updated_at' => now()]);
            $this->audit->account($request, 'BADGE_SUPPRESSED', 'VENDOR_ORGANIZATION', (string) $organization->id, after: ['suppression_id' => $id, 'badge' => $input['badge_code'], 'case_reference' => $input['case_reference']], reason: $input['note']);
        });
    }

    public function lift(Request $request, string $suppressionId, string $reason): void
    {
        $this->access->admin($request, self::INVESTIGATE);
        $this->once($request, 'BADGE_SUPPRESSION_LIFT', $suppressionId, function () use ($request, $suppressionId, $reason): void {
            $suppression = DB::table('badge_suppressions')->where('id', ReviewAccess::uuid($suppressionId))->lockForUpdate()->first();
            if ($suppression === null) {
                throw new AuthenticationException('BADGE_SUPPRESSION_NOT_FOUND', 'This suppression is unavailable.', 404);
            }
            if ($suppression->lifted_at !== null) {
                throw new AuthenticationException('BADGE_SUPPRESSION_LIFTED', 'This suppression was already lifted.', 409);
            }
            DB::table('badge_suppressions')->where('id', $suppression->id)->update(['lifted_at' => now(), 'lifted_by_user_id' => $request->user()->getKey(), 'lift_reason' => $reason, 'updated_at' => now()]);
            $this->audit->account($request, 'BADGE_SUPPRESSION_LIFTED', 'VENDOR_ORGANIZATION', (string) $suppression->vendor_organization_id, ['suppression_id' => $suppression->id], ['lifted' => true], reason: $reason);
        });
    }

    private function once(Request $request, string $endpoint, string $scopeId, callable $action): void
    {
        $key = $this->keys->requireIdempotencyKey($request);
        DB::transaction(function () use ($request, $endpoint, $scopeId, $key, $action): void {
            if ($this->keys->replayed($request, $endpoint, $key, $scopeId)) {
                return;
            }
            $action();
            $this->keys->claim($request, $endpoint, $key, $scopeId, 200);
        });
    }
}
