<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use App\Domain\Authorization\RecentAuthentication;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\AdminAccess;
use App\Domain\Vendors\VendorAuthorityService;
use Carbon\CarbonImmutable;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/** Commercial rates are append-only policies; they never change a frozen order or a statutory tax rate. */
final class CommissionPolicyService
{
    public function __construct(
        private readonly AdminAccess $admins,
        private readonly RecentAuthentication $recent,
        private readonly AuditRecorder $audit,
        private readonly FinanceNotifier $notifier,
    ) {}

    public static function policies(): Builder
    {
        return DB::table('fee_policy_versions')->where('environment', FinancialSnapshotService::ENVIRONMENT)->where('code', FinancialSnapshotService::FEE_POLICY_CODE);
    }

    public static function current(): ?object
    {
        return self::policies()->where('effective_from', '<=', now())->where(fn (Builder $q) => $q->whereNull('effective_until')->orWhere('effective_until', '>', now()))->orderByDesc('effective_from')->orderByDesc('version')->first();
    }

    public static function next(): ?object
    {
        return self::policies()->where('effective_from', '>', now())->orderBy('effective_from')->orderByDesc('version')->first();
    }

    public static function percent(int $basisPoints): string
    {
        return intdiv($basisPoints, 100).'.'.str_pad((string) ($basisPoints % 100), 2, '0', STR_PAD_LEFT).'%';
    }

    /** @return array<string, mixed>|null */
    public static function present(?object $row): ?array
    {
        return $row === null ? null : ['id' => (string) $row->id, 'version' => (int) $row->version, 'commission_basis_points' => (int) $row->commission_basis_points,
            'rate_label' => self::percent((int) $row->commission_basis_points), 'effective_from' => CarbonImmutable::parse((string) $row->effective_from)->toIso8601String(),
            'agreement_version_id' => $row->agreement_version_id, 'reason' => $row->reason, 'status' => CarbonImmutable::parse((string) $row->effective_from)->isFuture() ? 'SCHEDULED' : (self::current()?->id === $row->id ? 'CURRENT' : 'PREVIOUS')];
    }

    /** @return array{data: array<string, mixed>, meta: array<string, mixed>} */
    public function index(Request $request, int $page): array
    {
        $actor = $this->admins->require($request, 'finance.view');
        $query = self::policies();
        $total = $query->count();

        return ['data' => ['current' => self::present(self::current()), 'next' => self::present(self::next()), 'latest_version' => (int) self::policies()->max('version'),
            'can_manage' => in_array('platform_settings.manage', $actor['permissions'], true),
            'versions' => $query->orderByDesc('version')->forPage($page, 20)->get()->map(fn (object $row): ?array => self::present($row))->all()],
            'meta' => ['page' => $page, 'per_page' => 20, 'total' => $total, 'has_more' => $page * 20 < $total]];
    }

    /** @param array{commission_basis_points: int, expected_version: int, effective_from?: ?string, reason: string} $input
     * @return array<string, mixed>
     */
    public function publish(Request $request, array $input): array
    {
        $actor = $this->admins->require($request, 'finance.view', 'platform_settings.manage');
        $this->recent->require($request);
        $reason = AdminAccess::reason($input['reason']);

        return $this->admins->idempotent($request, 'COMMISSION_POLICY_PUBLISH', function () use ($request, $input, $actor, $reason): array {
            // One permanent document row serializes publishing, including concurrent first versions.
            $document = DB::table('agreement_documents')->where('code', 'VENDOR_COMMISSION_TEST')->lockForUpdate()->first();
            if ($document === null) {
                throw new AuthenticationException('AGREEMENT_CONTENT_UNAVAILABLE', 'Commission terms must be installed before publishing a rate.', 503);
            }
            $latest = self::policies()->orderByDesc('version')->first();
            $latestVersion = $latest === null ? 0 : (int) $latest->version;
            if ($latestVersion !== $input['expected_version']) {
                throw new AuthenticationException('COMMISSION_POLICY_VERSION_CONFLICT', 'The commission policy changed. Reload before publishing.', 409);
            }
            $effective = isset($input['effective_from']) ? CarbonImmutable::parse($input['effective_from'])->utc() : CarbonImmutable::now();
            if ($effective->isPast() && isset($input['effective_from'])) {
                throw new AuthenticationException('COMMISSION_POLICY_EFFECTIVE_DATE_INVALID', 'Choose a future effective date or apply the rate now.', 422);
            }
            if ($latest !== null && $effective->lessThan(CarbonImmutable::parse((string) $latest->effective_from))) {
                throw new AuthenticationException('COMMISSION_POLICY_SCHEDULE_CONFLICT', 'The effective date must follow the latest scheduled policy.', 409);
            }
            if ($latest !== null && (int) $latest->commission_basis_points === $input['commission_basis_points']) {
                throw new AuthenticationException('COMMISSION_POLICY_UNCHANGED', 'Enter a different commission percentage.', 422);
            }
            $rate = self::percent($input['commission_basis_points']);
            $agreementVersion = (int) DB::table('agreement_versions')->where('agreement_document_id', $document->id)->max('version') + 1;
            $agreementId = (string) Str::uuid7();
            $content = "# Vendor Commission Terms — TEST/DEMO\n\nDEMO — No real funds or BIR filing.\n\nThe Vendor-paid commission is {$rate} of completed, non-refunded materials value after discounts and excluding included materials VAT. This version takes effect on ".$effective->setTimezone('Asia/Manila')->format('Y-m-d H:i').' Asia/Manila.'."\n\nThe fee is earned only on completion and billed monthly for Online, COD and In-Store orders. Delivery, Buyer processing fees, VAT and cancelled sales do not earn commission. An NRPC deposit is not a second commission basis. Amounts round half-up to centavos.\n\nPublished quotations and accepted orders retain their original fee policy, including later returns and credits. Statements are drafted on the first, reviewed by the third and due on the fifteenth, or twelve days after late issue. Credits reduce unpaid debt first; any collected excess is refundable through the original platform-fee payment.\n\nOnly the Vendor Owner or approved Owner-linked signatory may accept. Review and accept this version from Commission Terms in Finance or Store Verification before new transactions use it. MateryalPH has no wallet or escrow and does not deduct this fee from Buyer payments. Existing dispute, refund, withholding and payment protections continue to apply.\n";
            DB::table('agreement_versions')->insert(['id' => $agreementId, 'agreement_document_id' => $document->id, 'version' => $agreementVersion,
                'content_uri' => 'database:commission/'.$agreementVersion, 'content_hash' => hash('sha256', $content), 'published_content' => $content,
                'effective_at' => $effective, 'requires_reacceptance' => true, 'created_at' => now(), 'updated_at' => now()]);
            $id = (string) Str::uuid7();
            DB::table('fee_policy_versions')->insert(['id' => $id, 'code' => FinancialSnapshotService::FEE_POLICY_CODE, 'environment' => FinancialSnapshotService::ENVIRONMENT,
                'version' => $latestVersion + 1, 'commission_basis_points' => $input['commission_basis_points'], 'basis' => 'MATERIALS_AFTER_DISCOUNT_EXCLUDING_VAT',
                'cadence' => 'MONTHLY', 'effective_from' => $effective, 'approved_by_user_id' => $actor['user_id'], 'approved_at' => now(),
                'agreement_version_id' => $agreementId, 'reason' => $reason, 'created_at' => now(), 'updated_at' => now()]);
            $policy = self::present(self::policies()->where('id', $id)->first()) ?? [];
            $this->audit->account($request, 'COMMISSION_POLICY_PUBLISHED', 'FEE_POLICY_VERSION', $id,
                $latest === null ? [] : ['version' => (int) $latest->version, 'commission_basis_points' => (int) $latest->commission_basis_points], $policy, reason: $reason);
            DB::table('vendor_organizations')->where('account_status', 'ACTIVE')->orderBy('id')->select('id')->chunkById(100, function ($organizations) use ($rate, $effective): void {
                foreach ($organizations as $organization) {
                    $this->notifier->owner((string) $organization->id, 'Commission rate update', 'The new commission rate is '.$rate.', effective '.$effective->setTimezone('Asia/Manila')->format('M j, Y g:i A').' (Asia/Manila). Review the versioned Commission Terms in Finance. Earlier transactions keep their saved rate.', true, 'VENDOR_ORGANIZATION', (string) $organization->id);
                }
            });

            return $policy;
        })['result'];
    }

    public static function assertAccepted(object $policy, string $organizationId): void
    {
        if ($policy->agreement_version_id === null) {
            return;
        }
        $ownerId = DB::table('agreement_acceptances as a')->join('vendor_memberships as m', 'm.user_id', '=', 'a.user_id')
            ->where('a.vendor_organization_id', $organizationId)->where('m.vendor_organization_id', $organizationId)->where('m.role', 'OWNER')->where('m.status', 'ACTIVE')->whereNull('m.deleted_at')
            ->where('a.agreement_version_id', $policy->agreement_version_id)->value('m.user_id');
        $authority = app(VendorAuthorityService::class);
        if ($ownerId === null || ($authority->required($organizationId) && ! $authority->hasCurrentApproval($organizationId, 'COMMISSION_AGREEMENT', (int) $ownerId))) {
            throw new AuthenticationException('COMMISSION_TERMS_ACCEPTANCE_REQUIRED', 'The Vendor Owner must accept the current Commission Terms in Finance or Store Verification before creating new commercial transactions.', 409);
        }
    }
}
