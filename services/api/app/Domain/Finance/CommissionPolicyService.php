<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use App\Domain\Authorization\RecentAuthentication;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\AdminAccess;
use App\Domain\Vendors\VendorAuthorityService;
use App\Mail\CommissionPolicyMail;
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
        private readonly CommissionEmails $emails,
    ) {}

    public static function policies(): Builder
    {
        return DB::table('fee_policy_versions')->where('environment', FinancialSnapshotService::ENVIRONMENT)->where('code', FinancialSnapshotService::FEE_POLICY_CODE);
    }

    public static function current(): ?object
    {
        return self::effectivePolicies()->where('effective_from', '<=', CarbonImmutable::now('Asia/Manila')->utc())->where(fn (Builder $q) => $q->whereNull('effective_until')->orWhere('effective_until', '>', now()))->orderByDesc('effective_from')->orderByDesc('version')->first();
    }

    public static function next(): ?object
    {
        return self::effectivePolicies()->where('effective_from', '>', now())->orderBy('effective_from')->orderByDesc('version')->first();
    }

    private static function effectivePolicies(): Builder
    {
        return self::policies()->whereNotExists(fn (Builder $query) => $query->selectRaw('1')->from('commission_policy_revisions as r')->whereColumn('r.policy_id', 'fee_policy_versions.id'));
    }

    public static function percent(int $basisPoints): string
    {
        return intdiv($basisPoints, 100).'.'.str_pad((string) ($basisPoints % 100), 2, '0', STR_PAD_LEFT).'%';
    }

    /** @return array<string, mixed>|null */
    public static function present(?object $row, bool $admin = false): ?array
    {
        if ($row === null) {
            return null;
        }
        $terms = DB::table('agreement_versions')->where('id', $row->agreement_version_id)->first();
        $revision = DB::table('commission_policy_revisions')->where('policy_id', $row->id)->first();
        $result = ['id' => (string) $row->id, 'version' => (int) $row->version, 'commission_basis_points' => (int) $row->commission_basis_points,
            'rate_label' => self::percent((int) $row->commission_basis_points), 'effective_from' => CarbonImmutable::parse((string) $row->effective_from)->toIso8601String(),
            'agreement_version_id' => $row->agreement_version_id, 'terms_version' => $terms === null ? null : (int) $terms->version,
            'terms_content' => $terms?->published_content, 'vendor_message' => $row->vendor_message,
            'notice_hours' => $row->notice_hours === null ? null : (int) $row->notice_hours,
            'status' => $revision !== null ? ($revision->kind === 'CANCELLED' ? 'CANCELLED' : 'SUPERSEDED') : (CarbonImmutable::parse((string) $row->effective_from)->isFuture() ? 'SCHEDULED' : (self::current()?->id === $row->id ? 'CURRENT' : 'PREVIOUS'))];

        return $admin ? $result + ['reason' => $row->reason, 'notice_override_reason' => $row->notice_override_reason,
            'published_by' => $row->approved_by_user_id === null ? 'System' : (DB::table('users')->where('id', $row->approved_by_user_id)->value('name') ?? 'Admin'),
            'delivery' => app(CommissionEmails::class)->summary('POLICY', (string) $row->id)] : $result;
    }

    /**
     * Public projection contains no Admin reason, staff contact or delivery information.
     *
     * @return array<string, mixed>
     */
    public function publicPolicy(?string $id = null): array
    {
        return ['current' => self::present(self::current()), 'next' => self::present(self::next()),
            'selected' => $id === null ? null : self::present(self::policies()->where('id', $id)->first())];
    }

    /**
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function preview(Request $request, array $input): array
    {
        $this->admins->require($request, 'finance.view', 'platform_settings.manage');
        $effective = isset($input['effective_from']) ? CarbonImmutable::parse($input['effective_from'])->utc() : CarbonImmutable::now();
        $active = self::current();
        $basisPoints = (bool) ($input['cancel_scheduled'] ?? false) ? (int) $active->commission_basis_points : (int) $input['commission_basis_points'];
        $hours = max(0, (int) floor(CarbonImmutable::now()->diffInHours($effective, false)));
        $start = CarbonImmutable::now('Asia/Manila')->startOfMonth()->subMonths(3);
        $end = $start->addMonths(3);
        $volume = (int) DB::table('fee_assessments')->whereNotNull('earned_at')->where('earned_at', '>=', $start->utc())->where('earned_at', '<', $end->utc())->sum('commission_basis_centavos');
        $monthly = intdiv($volume + 1, 3);
        $policy = ['id' => 'preview', 'version' => (int) self::policies()->max('version') + 1, 'rate_label' => self::percent($basisPoints), 'commission_basis_points' => $basisPoints,
            'effective_from' => $effective->toIso8601String(), 'notice_hours' => $hours, 'vendor_message' => $input['vendor_message'] ?? null,
            'terms_version' => (int) DB::table('agreement_versions as v')->join('agreement_documents as d', 'd.id', '=', 'v.agreement_document_id')->where('d.code', 'VENDOR_COMMISSION_TEST')->max('v.version') + 1];
        $type = (bool) ($input['cancel_scheduled'] ?? false) ? 'RATE_CANCELLED' : (isset($input['supersedes_policy_id']) ? 'RATE_CORRECTED' : 'RATE_PUBLISHED');
        $oldRate = isset($input['supersedes_policy_id']) ? self::next()?->commission_basis_points : $active->commission_basis_points;
        $mail = new CommissionPolicyMail($policy, (int) $oldRate, $type);

        return ['vendor_count' => $this->emails->eligible()->count(), 'notice_hours' => $hours,
            'notice_required' => (int) config('finance.commission_min_notice_days', 30) > 0 && $basisPoints > (int) $active->commission_basis_points && $effective->lessThan(CarbonImmutable::now()->addDays((int) config('finance.commission_min_notice_days', 30))),
            'example_commission_centavos' => Money::commission(1000000, $basisPoints), 'monthly_basis_centavos' => $monthly,
            'estimated_monthly_change_centavos' => Money::commission($monthly, $basisPoints) - Money::commission($monthly, (int) $active->commission_basis_points),
            'volume_period' => $start->toDateString().' to '.$end->subDay()->toDateString(),
            'current_terms' => self::present($active)['terms_content'], 'new_terms' => app(CommissionTermsTemplate::class)->render($basisPoints, $effective),
            'email_subject' => $mail->envelope()->subject, 'email_html' => $mail->render()];
    }

    /** @return array{data: array<string, mixed>, meta: array<string, mixed>} */
    public function index(Request $request, int $page): array
    {
        $actor = $this->admins->require($request, 'finance.view');
        $query = self::policies();
        $total = $query->count();

        return ['data' => ['current' => self::present(self::current(), true), 'next' => self::present(self::next(), true), 'latest_version' => (int) self::policies()->max('version'),
            'can_manage' => in_array('platform_settings.manage', $actor['permissions'], true),
            'can_export' => in_array('finance.export', $actor['permissions'], true),
            'min_notice_days' => (int) config('finance.commission_min_notice_days', 30), 'eligible_vendor_count' => $this->emails->eligible()->count(),
            'versions' => $query->orderByDesc('version')->forPage($page, 20)->get()->map(fn (object $row): ?array => self::present($row, true))->all()],
            'meta' => ['page' => $page, 'per_page' => 20, 'total' => $total, 'has_more' => $page * 20 < $total]];
    }

    /** @param array<string, mixed> $input
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
            $scheduled = self::next();
            $target = $input['supersedes_policy_id'] ?? null;
            $cancel = (bool) ($input['cancel_scheduled'] ?? false);
            if (! $cancel && isset($input['effective_from']) && CarbonImmutable::parse($input['effective_from'])->isPast()) {
                throw new AuthenticationException('COMMISSION_POLICY_EFFECTIVE_DATE_INVALID', 'Choose a future effective date or apply the rate now.', 422);
            }
            if (($target !== null && $scheduled?->id !== $target) || ($cancel && $target === null) || ($scheduled !== null && $target === null)) {
                throw new AuthenticationException('COMMISSION_POLICY_SCHEDULE_CONFLICT', 'Reload and explicitly edit or cancel the scheduled change before publishing another.', 409);
            }
            $active = self::current();
            $basisPoints = $cancel ? (int) $active->commission_basis_points : (int) $input['commission_basis_points'];
            $effective = ! $cancel && isset($input['effective_from']) ? CarbonImmutable::parse($input['effective_from'])->utc() : CarbonImmutable::now();
            if ($effective->isPast() && isset($input['effective_from'])) {
                throw new AuthenticationException('COMMISSION_POLICY_EFFECTIVE_DATE_INVALID', 'Choose a future effective date or apply the rate now.', 422);
            }
            if ($target === null && $active !== null && (int) $active->commission_basis_points === $basisPoints) {
                throw new AuthenticationException('COMMISSION_POLICY_UNCHANGED', 'Enter a different commission percentage.', 422);
            }
            $noticeHours = max(0, (int) floor(CarbonImmutable::now()->diffInHours($effective, false)));
            $override = (bool) ($input['notice_override'] ?? false);
            $overrideReason = $override ? AdminAccess::reason((string) ($input['notice_override_reason'] ?? '')) : null;
            if (! $cancel && (int) config('finance.commission_min_notice_days', 30) > 0 && $basisPoints > (int) ($active->commission_basis_points ?? 200) && $effective->lessThan(CarbonImmutable::now()->addDays((int) config('finance.commission_min_notice_days', 30))) && ! $override) {
                throw new AuthenticationException('COMMISSION_NOTICE_REQUIRED', 'Rate increases require at least '.config('finance.commission_min_notice_days', 30).' days of notice, or an explicit override with a reason.', 422);
            }
            $agreementId = app(CommissionTermsTemplate::class)->create((string) $document->id, $basisPoints, $effective);
            $id = (string) Str::uuid7();
            DB::table('fee_policy_versions')->insert(['id' => $id, 'code' => FinancialSnapshotService::FEE_POLICY_CODE, 'environment' => FinancialSnapshotService::ENVIRONMENT,
                'version' => $latestVersion + 1, 'commission_basis_points' => $basisPoints, 'basis' => 'MATERIALS_AFTER_DISCOUNT_EXCLUDING_VAT',
                'cadence' => 'MONTHLY', 'effective_from' => $effective, 'approved_by_user_id' => $actor['user_id'], 'approved_at' => now(),
                'agreement_version_id' => $agreementId, 'reason' => $reason, 'vendor_message' => $input['vendor_message'] ?? null,
                'notice_hours' => $noticeHours, 'notice_override_reason' => $overrideReason, 'created_at' => now(), 'updated_at' => now()]);
            if ($target !== null) {
                DB::table('commission_policy_revisions')->insert(['id' => (string) Str::uuid7(), 'policy_id' => $target, 'replacement_policy_id' => $id,
                    'kind' => $cancel ? 'CANCELLED' : 'SUPERSEDED', 'created_by_user_id' => $actor['user_id'], 'reason' => $reason, 'created_at' => now()]);
            }
            $this->emails->policy($id, (int) (($target !== null ? $scheduled : $active)->commission_basis_points ?? 200), $cancel ? 'RATE_CANCELLED' : ($target === null ? 'RATE_PUBLISHED' : 'RATE_CORRECTED'));
            $policy = self::present(self::policies()->where('id', $id)->first(), true) ?? [];
            $this->audit->account($request, 'COMMISSION_POLICY_PUBLISHED', 'FEE_POLICY_VERSION', $id,
                $latest === null ? [] : ['version' => (int) $latest->version, 'commission_basis_points' => (int) $latest->commission_basis_points], $policy, reason: $reason);

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
            ->whereIn('a.agreement_version_id', array_filter([$policy->agreement_version_id, $policy->legacy_agreement_version_id ?? null]))->value('m.user_id');
        $authority = app(VendorAuthorityService::class);
        if ($ownerId === null || ($authority->required($organizationId) && ! $authority->hasCurrentApproval($organizationId, 'COMMISSION_AGREEMENT', (int) $ownerId))) {
            throw new AuthenticationException('COMMISSION_TERMS_ACCEPTANCE_REQUIRED', 'The Vendor Owner must accept the current Commission Terms in Finance or Store Verification before creating new commercial transactions.', 409);
        }
    }
}
