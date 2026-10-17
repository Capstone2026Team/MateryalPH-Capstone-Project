<?php

declare(strict_types=1);

namespace App\Domain\Enforcement;

use App\Domain\Authorization\RecentAuthentication;
use App\Domain\Catalog\MarketplaceDiscoverability;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\TokenSessionService;
use App\Domain\Notifications\NotificationService;
use App\Domain\Operations\AdminAccess;
use App\Domain\Vendors\StoreActivationGate;
use App\Models\AuthSession;
use App\Support\PortalDateRange;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Buyer and Vendor enforcement under the graduated model approved by the project owner on 2026-10-09.
 *
 * Warning: recorded and effective at once. Temporary Restriction: a Vendor store becomes RESTRICTED (no new orders or
 * quotations, outside discovery) or a Buyer is blocked from new orders, inquiries and acceptances; it lifts itself when
 * its duration ends. Suspension: the Vendor store becomes SUSPENDED, or the Buyer account becomes SUSPENDED with every
 * session revoked, until a reasoned lift. Permanent Ban: Super Admin only, with recent re-authentication.
 *
 * Dispute decisions refer sanctions here (REFERRED); User Management Staff apply or decline them, or record a direct
 * action. Every change requires the documented permission and a reason, stores before/after subject state, writes an
 * append-only event and an audit event with the correlation ID, and notifies the subject. Existing orders receive a
 * recorded continuation plan; refunds always proceed. Store reactivation after a lift returns to READY so the Owner
 * re-runs the activation gate: an Admin never activates a store directly.
 */
final class EnforcementService
{
    public const ACTIONS = ['WARNING', 'TEMPORARY_RESTRICTION', 'SUSPENSION', 'PERMANENT_BAN'];

    public const PLANS = ['CONTINUE', 'MONITORED_FULFILLMENT', 'CANCELLATION_REVIEW', 'REPLACEMENT', 'REFUND', 'NO_OPEN_ORDERS'];

    private const HOLD_CODES = ['TEMPORARY_RESTRICTION' => 'ENFORCEMENT_RESTRICTION', 'SUSPENSION' => 'ENFORCEMENT_SUSPENSION', 'PERMANENT_BAN' => 'ENFORCEMENT_BAN'];

    private const TERMINAL_ORDER_STATES = ['COMPLETED', 'CANCELLED', 'DECLINED', 'EXPIRED'];

    private const PER_PAGE = 25;

    public function __construct(
        private readonly AdminAccess $access,
        private readonly AuditRecorder $audit,
        private readonly RecentAuthentication $recent,
        private readonly NotificationService $notifications,
        private readonly TokenSessionService $sessions,
    ) {}

    /**
     * @param  array<string, mixed>  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function queue(Request $request, array $filters): array
    {
        $this->access->require($request, 'enforcement.view');
        $query = DB::table('enforcement_actions as e')->leftJoin('dispute_cases as c', 'c.id', '=', 'e.dispute_case_id')
            ->when($filters['state'] ?? null, fn ($q, string $state) => $q->where('e.state', $state))
            ->when($filters['subject_type'] ?? null, fn ($q, string $type) => $q->where('e.subject_type', $type))
            ->when($filters['action'] ?? null, fn ($q, string $action) => $q->where('e.action', $action))
            ->when($filters['source'] ?? null, fn ($q, string $source) => $q->where('e.source', $source))
            ->when($filters['subject_id'] ?? null, fn ($q, string $id) => $q->where('e.subject_id', $id));
        PortalDateRange::apply($query, 'e.created_at', $filters);
        $total = (clone $query)->count();
        $page = max(1, min(1000, (int) ($filters['page'] ?? 1)));
        // Oldest referral first: pending account decisions must not age silently.
        $rows = $query->orderByRaw("CASE e.state WHEN 'REFERRED' THEN 0 WHEN 'APPLIED' THEN 1 ELSE 2 END")->orderBy('e.created_at')->orderBy('e.id')
            ->offset(($page - 1) * self::PER_PAGE)->limit(self::PER_PAGE)->get(['e.*', 'c.reference as case_reference']);

        return ['items' => $rows->map(fn (object $row): array => $this->summary($row))->all(),
            'meta' => ['page' => $page, 'per_page' => self::PER_PAGE, 'total' => $total, 'has_more' => $page * self::PER_PAGE < $total]];
    }

    /** @return array<string, mixed> */
    public function detail(Request $request, string $actionId): array
    {
        $actor = $this->access->require($request, 'enforcement.view');
        $row = $this->find($actionId);

        return $this->summary($row) + [
            'scope' => (string) $row->scope, 'restoration_condition' => $row->restoration_condition, 'continuation_note' => $row->continuation_note,
            'prior_subject_state' => $row->prior_subject_state === null ? null : json_decode((string) $row->prior_subject_state, true),
            'subject_review' => $this->review((string) $row->subject_type, (string) $row->subject_id),
            'events' => DB::table('enforcement_events as v')->leftJoin('users as u', 'u.id', '=', 'v.actor_user_id')->where('v.enforcement_action_id', $row->id)->orderBy('v.occurred_at')->orderBy('v.id')
                ->get(['v.event', 'v.from_state', 'v.to_state', 'v.before', 'v.after', 'v.reason', 'v.actor_role', 'v.correlation_id', 'v.occurred_at', 'u.name as actor_name'])
                ->map(static fn (object $event): array => ['event' => (string) $event->event, 'from_state' => $event->from_state, 'to_state' => (string) $event->to_state,
                    'before' => $event->before === null ? null : json_decode((string) $event->before, true), 'after' => $event->after === null ? null : json_decode((string) $event->after, true),
                    'reason' => (string) $event->reason, 'actor' => $event->actor_name ?? 'System rule', 'actor_role' => (string) $event->actor_role,
                    'correlation_id' => (string) $event->correlation_id, 'occurred_at' => CarbonImmutable::parse((string) $event->occurred_at)->toIso8601String()])->all(),
            'allowed_actions' => $this->allowedActions($row, $actor['permissions']),
        ];
    }

    /**
     * Account-review summary for a direct action: account and store state, open orders, case and no-show history and
     * prior sanctions. No contact details, coordinates, documents or payment data.
     *
     * @return array<string, mixed>
     */
    public function subject(Request $request, string $type, string $id): array
    {
        $this->access->require($request, 'enforcement.view');
        if (! in_array($type, ['BUYER', 'VENDOR_ORGANIZATION'], true) || ! Str::isUuid($id)) {
            throw new AuthenticationException('SUBJECT_NOT_FOUND', 'This account is unavailable.', 404);
        }

        return $this->review($type, $id) + ['sanctions' => DB::table('enforcement_actions as e')->leftJoin('dispute_cases as c', 'c.id', '=', 'e.dispute_case_id')
            ->where('e.subject_type', $type)->where('e.subject_id', $id)->orderByDesc('e.created_at')->limit(50)->get(['e.*', 'c.reference as case_reference'])
            ->map(fn (object $row): array => $this->summary($row))->all()];
    }

    /**
     * Minimal identity lookup for a direct action: a Vendor by store name, or a Buyer by exact account email.
     *
     * @return list<array<string, mixed>>
     */
    public function search(Request $request, string $type, string $term): array
    {
        $this->access->require($request, 'enforcement.view');
        $term = trim($term);
        if (mb_strlen($term) < 3) {
            return [];
        }
        if ($type === 'VENDOR_ORGANIZATION') {
            return DB::table('vendor_organizations')->whereRaw('store_name ILIKE ?', ['%'.addcslashes($term, '%_\\').'%'])->orderBy('store_name')->limit(10)
                ->get(['id', 'store_name', 'store_activation_status'])->map(static fn (object $row): array => ['type' => 'VENDOR_ORGANIZATION', 'id' => (string) $row->id,
                    'display_name' => (string) $row->store_name, 'status' => (string) $row->store_activation_status])->all();
        }
        if ($type === 'BUYER') {
            // Exact email match only: partial searches would enumerate personal data.
            return DB::table('buyer_profiles as b')->join('users as u', 'u.id', '=', 'b.user_id')->whereRaw('LOWER(u.email) = ?', [mb_strtolower($term)])->limit(1)
                ->get(['b.id', 'u.name', 'u.public_id', 'u.account_status'])->map(static fn (object $row): array => ['type' => 'BUYER', 'id' => (string) $row->id,
                    'display_name' => self::buyerName((string) $row->name, (string) $row->public_id), 'status' => (string) $row->account_status])->all();
        }

        return [];
    }

    /**
     * Records a direct action (source DIRECT). A Warning is effective at once; other sanctions are applied at once by
     * the authorized User Management actor.
     *
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function record(Request $request, array $input): array
    {
        $actor = $this->access->require($request, 'enforcement.view', 'enforcement.apply');
        $action = (string) $input['action'];
        $type = (string) $input['subject_type'];
        $subjectId = (string) $input['subject_id'];
        if (! in_array($action, self::ACTIONS, true) || ! in_array($type, ['BUYER', 'VENDOR_ORGANIZATION'], true)) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Choose a supported subject and action.', 422);
        }
        if ($action === 'PERMANENT_BAN') {
            $this->access->require($request, 'enforcement.ban');
            $this->recent->require($request);
        }
        $reason = AdminAccess::reason($input['reason'] ?? null);
        $this->subjectRow($type, $subjectId);
        $duration = $action === 'TEMPORARY_RESTRICTION' ? (int) ($input['duration_days'] ?? 0) : null;
        if ($action === 'TEMPORARY_RESTRICTION' && ($duration < 1 || $duration > 365)) {
            throw new AuthenticationException('VALIDATION_FAILED', 'A Temporary Restriction needs a duration of 1 to 365 days.', 422, ['fields' => ['duration_days' => ['Enter 1 to 365 days.']]]);
        }
        $restoration = trim((string) ($input['restoration_condition'] ?? ''));
        if (in_array($action, ['TEMPORARY_RESTRICTION', 'SUSPENSION'], true) && mb_strlen($restoration) < 10) {
            throw new AuthenticationException('VALIDATION_FAILED', 'State the restoration condition for this sanction.', 422, ['fields' => ['restoration_condition' => ['A restoration condition of at least 10 characters is required.']]]);
        }
        $correlation = AdminAccess::correlation($request);

        // One transaction: a direct sanction whose application fails (plan, ban, version) leaves no orphan referral.
        return DB::transaction(function () use ($request, $actor, $action, $type, $subjectId, $reason, $duration, $restoration, $input, $correlation): array {
            $id = (string) Str::uuid7();
            DB::table('enforcement_actions')->insert(['id' => $id, 'subject_type' => $type, 'subject_id' => $subjectId, 'action' => $action,
                'state' => $action === 'WARNING' ? 'EFFECTIVE' : 'REFERRED', 'reason' => $reason, 'scope' => mb_substr(trim((string) ($input['scope'] ?? 'Marketplace activity')), 0, 160) ?: 'Marketplace activity',
                'duration_days' => $duration, 'restoration_condition' => $restoration === '' ? null : mb_substr($restoration, 0, 2000), 'effective_at' => $action === 'WARNING' ? now() : null,
                'issued_by_user_id' => $actor['user_id'], 'issued_role' => $actor['role'], 'environment' => 'TEST', 'source' => 'DIRECT', 'correlation_id' => $correlation,
                'created_at' => now(), 'updated_at' => now()]);
            $this->event($id, 'RECORDED', null, $action === 'WARNING' ? 'EFFECTIVE' : 'REFERRED', null, ['action' => $action], $reason, $actor, $correlation);
            if ($action === 'WARNING') {
                $this->audit->account($request, 'ENFORCEMENT_WARNING_RECORDED', 'ENFORCEMENT_ACTION', $id, [], ['subject_type' => $type, 'action' => $action], reason: $reason);
                $this->notifySubject($type, $subjectId, 'Account warning', 'A warning was recorded on your account: '.$reason, $id);

                return $this->detail($request, $id);
            }

            return $this->apply($request, $id, ['continuation_plan' => $input['continuation_plan'] ?? null, 'continuation_note' => $input['continuation_note'] ?? null,
                'lock_version' => 1, 'reason' => $reason], true);
        });
    }

    /**
     * Applies a referred sanction. A stronger or equal sanction supersedes the subject's currently applied one inside
     * the same transaction; a Permanent Ban can only be lifted, never superseded.
     *
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function apply(Request $request, string $actionId, array $input, bool $alreadyReauthenticated = false): array
    {
        $actor = $this->access->require($request, 'enforcement.view', 'enforcement.apply');
        $reason = AdminAccess::reason($input['reason'] ?? null);
        $plan = (string) ($input['continuation_plan'] ?? '');
        $correlation = AdminAccess::correlation($request);
        $preview = $this->find($actionId);
        if ($preview->action === 'PERMANENT_BAN') {
            $this->access->require($request, 'enforcement.ban');
            if (! $alreadyReauthenticated) {
                $this->recent->require($request);
            }
        }
        $result = DB::transaction(function () use ($actionId, $input, $reason, $plan, $actor, $correlation): array {
            $row = DB::table('enforcement_actions')->where('id', $actionId)->lockForUpdate()->first();
            if ($row === null) {
                throw new AuthenticationException('ENFORCEMENT_NOT_FOUND', 'This enforcement case is unavailable.', 404);
            }
            if ((int) ($input['lock_version'] ?? 0) !== (int) $row->lock_version) {
                throw new AuthenticationException('ENFORCEMENT_VERSION_CONFLICT', 'This case changed after you opened it. Refresh to review the current state.', 409);
            }
            if ($row->state !== 'REFERRED' || $row->action === 'WARNING') {
                throw new AuthenticationException('ENFORCEMENT_NOT_PENDING', 'Only a referred sanction can be applied.', 409);
            }
            $open = $this->openOrders((string) $row->subject_type, (string) $row->subject_id);
            if (! in_array($plan, self::PLANS, true) || ($open > 0 && $plan === 'NO_OPEN_ORDERS') || ($open === 0 && $plan !== 'NO_OPEN_ORDERS' && $plan !== 'CONTINUE')) {
                throw new AuthenticationException('CONTINUATION_PLAN_REQUIRED', $open > 0 ? 'Choose an explicit plan for the '.$open.' open order(s).' : 'Record that the subject has no open orders.', 422,
                    ['open_orders' => $open, 'fields' => ['continuation_plan' => ['Choose a continuation plan for existing orders.']]]);
            }
            $this->lockSubject((string) $row->subject_type, (string) $row->subject_id);
            $current = DB::table('enforcement_actions')->where('subject_type', $row->subject_type)->where('subject_id', $row->subject_id)->where('state', 'APPLIED')
                ->where('action', '<>', 'WARNING')->lockForUpdate()->first();
            if ($current !== null) {
                if ($current->action === 'PERMANENT_BAN') {
                    throw new AuthenticationException('SUBJECT_BANNED', 'The subject is permanently banned; a Super Admin must lift the ban first.', 409);
                }
                $this->liftLocked($current, 'Superseded by '.strtolower(str_replace('_', ' ', (string) $row->action)).': '.$reason, $actor, $correlation, 'SUPERSEDED');
            }
            $before = $this->subjectState((string) $row->subject_type, (string) $row->subject_id);
            $expires = $row->action === 'TEMPORARY_RESTRICTION' ? CarbonImmutable::now()->addDays((int) $row->duration_days) : null;
            $this->impose((string) $row->subject_type, (string) $row->subject_id, (string) $row->action, $reason, $actor);
            DB::table('enforcement_actions')->where('id', $row->id)->update(['state' => 'APPLIED', 'continuation_plan' => $plan, 'continuation_note' => mb_substr(trim((string) ($input['continuation_note'] ?? '')), 0, 2000) ?: null,
                'prior_subject_state' => json_encode($before, JSON_THROW_ON_ERROR), 'applied_at' => now(), 'applied_by_user_id' => $actor['user_id'], 'applied_role' => $actor['role'],
                'expires_at' => $expires, 'effective_at' => now(), 'correlation_id' => $correlation, 'lock_version' => (int) $row->lock_version + 1, 'updated_at' => now()]);
            $after = $this->subjectState((string) $row->subject_type, (string) $row->subject_id);
            $this->event((string) $row->id, 'APPLIED', 'REFERRED', 'APPLIED', $before, $after + ['continuation_plan' => $plan, 'expires_at' => $expires?->toIso8601String()], $reason, $actor, $correlation);

            return ['row' => $row, 'before' => $before, 'after' => $after, 'expires' => $expires, 'open' => $open];
        });
        $row = $result['row'];
        if ($row->subject_type === 'VENDOR_ORGANIZATION') {
            app(MarketplaceDiscoverability::class)->evaluate((string) $row->subject_id, $actor['user_id'], 'ADMIN');
        }
        $this->audit->account($request, 'ENFORCEMENT_APPLIED', 'ENFORCEMENT_ACTION', (string) $row->id, $result['before'], $result['after'] + ['action' => $row->action, 'continuation_plan' => $plan], reason: $reason);
        $label = self::label((string) $row->action);
        $until = $result['expires'] === null ? '' : ' until '.$result['expires']->setTimezone('Asia/Manila')->format('M j, Y g:i A').' (Asia/Manila)';
        $this->notifySubject((string) $row->subject_type, (string) $row->subject_id, $label.' applied', $label.' was applied to your '.($row->subject_type === 'BUYER' ? 'account' : 'store').$until.'. Reason: '.$reason
            .($row->restoration_condition === null ? '' : ' Restoration condition: '.$row->restoration_condition).' Existing orders follow the recorded plan and refunds continue.', (string) $row->id);
        if ($result['open'] > 0 && $plan !== 'CONTINUE') {
            $this->notifyOperations((string) $row->id, $label.' needs an order plan', $result['open'].' open order(s) of the subject follow the plan '.strtolower(str_replace('_', ' ', $plan)).'.');
        }

        return $this->detail($request, (string) $row->id);
    }

    /** @return array<string, mixed> */
    public function decline(Request $request, string $actionId, int $lockVersion, mixed $reasonInput): array
    {
        $actor = $this->access->require($request, 'enforcement.view', 'enforcement.apply');
        $reason = AdminAccess::reason($reasonInput);
        $correlation = AdminAccess::correlation($request);
        DB::transaction(function () use ($actionId, $lockVersion, $reason, $actor, $correlation): void {
            $row = DB::table('enforcement_actions')->where('id', $actionId)->lockForUpdate()->first();
            if ($row === null) {
                throw new AuthenticationException('ENFORCEMENT_NOT_FOUND', 'This enforcement case is unavailable.', 404);
            }
            if ($lockVersion !== (int) $row->lock_version) {
                throw new AuthenticationException('ENFORCEMENT_VERSION_CONFLICT', 'This case changed after you opened it. Refresh to review the current state.', 409);
            }
            if ($row->state !== 'REFERRED') {
                throw new AuthenticationException('ENFORCEMENT_NOT_PENDING', 'Only a referred sanction can be declined.', 409);
            }
            DB::table('enforcement_actions')->where('id', $row->id)->update(['state' => 'DECLINED', 'correlation_id' => $correlation, 'lock_version' => (int) $row->lock_version + 1, 'updated_at' => now()]);
            $this->event((string) $row->id, 'DECLINED', 'REFERRED', 'DECLINED', null, null, $reason, $actor, $correlation);
        });
        $this->audit->account($request, 'ENFORCEMENT_DECLINED', 'ENFORCEMENT_ACTION', $actionId, ['state' => 'REFERRED'], ['state' => 'DECLINED'], reason: $reason);
        $row = $this->find($actionId);
        $this->notifySubject((string) $row->subject_type, (string) $row->subject_id, 'Account review outcome', 'After review, the recommended '.strtolower(self::label((string) $row->action)).' was not applied.', $actionId);

        return $this->detail($request, $actionId);
    }

    /** @return array<string, mixed> */
    public function lift(Request $request, string $actionId, int $lockVersion, mixed $reasonInput): array
    {
        $actor = $this->access->require($request, 'enforcement.view', 'enforcement.apply');
        $reason = AdminAccess::reason($reasonInput);
        $correlation = AdminAccess::correlation($request);
        if ($this->find($actionId)->action === 'PERMANENT_BAN') {
            $this->access->require($request, 'enforcement.ban');
            $this->recent->require($request);
        }
        $states = DB::transaction(function () use ($actionId, $lockVersion, $reason, $actor, $correlation): array {
            $row = DB::table('enforcement_actions')->where('id', $actionId)->lockForUpdate()->first();
            if ($row === null) {
                throw new AuthenticationException('ENFORCEMENT_NOT_FOUND', 'This enforcement case is unavailable.', 404);
            }
            if ($lockVersion !== (int) $row->lock_version) {
                throw new AuthenticationException('ENFORCEMENT_VERSION_CONFLICT', 'This case changed after you opened it. Refresh to review the current state.', 409);
            }
            if ($row->state !== 'APPLIED') {
                throw new AuthenticationException('ENFORCEMENT_NOT_APPLIED', 'Only an applied sanction can be lifted.', 409);
            }
            $this->lockSubject((string) $row->subject_type, (string) $row->subject_id);

            return $this->liftLocked($row, $reason, $actor, $correlation, 'LIFTED');
        });
        $row = $this->find($actionId);
        if ($row->subject_type === 'VENDOR_ORGANIZATION') {
            app(MarketplaceDiscoverability::class)->evaluate((string) $row->subject_id, $actor['user_id'], 'ADMIN');
        }
        $this->audit->account($request, 'ENFORCEMENT_LIFTED', 'ENFORCEMENT_ACTION', $actionId, $states['before'], $states['after'], reason: $reason);
        $this->notifySubject((string) $row->subject_type, (string) $row->subject_id, self::label((string) $row->action).' lifted', self::label((string) $row->action).' was lifted. Reason: '.$reason
            .($row->subject_type === 'VENDOR_ORGANIZATION' ? ' Request Store Activation again; the activation checklist is re-evaluated.' : ''), $actionId);

        return $this->detail($request, $actionId);
    }

    /** Lifts Temporary Restrictions whose duration has ended (system rule, attributed to the scheduler). */
    public function sweep(): int
    {
        $lifted = 0;
        foreach (DB::table('enforcement_actions')->where('state', 'APPLIED')->where('action', 'TEMPORARY_RESTRICTION')->where('expires_at', '<=', now())->orderBy('expires_at')->limit(200)->pluck('id') as $id) {
            $done = DB::transaction(function () use ($id): ?object {
                $row = DB::table('enforcement_actions')->where('id', $id)->lockForUpdate()->first();
                if ($row === null || $row->state !== 'APPLIED' || CarbonImmutable::parse((string) $row->expires_at)->isFuture()) {
                    return null;
                }
                $this->lockSubject((string) $row->subject_type, (string) $row->subject_id);
                $this->liftLocked($row, 'The restriction duration ended.', ['user_id' => null, 'role' => 'SYSTEM:materyalph:enforcement-sweep'], (string) Str::uuid7(), 'EXPIRED');

                return $row;
            });
            if ($done !== null) {
                $lifted++;
                if ($done->subject_type === 'VENDOR_ORGANIZATION') {
                    app(MarketplaceDiscoverability::class)->evaluate((string) $done->subject_id, null, 'SYSTEM');
                }
                $this->notifySubject((string) $done->subject_type, (string) $done->subject_id, 'Temporary Restriction ended', 'Your Temporary Restriction ended on schedule.'
                    .($done->subject_type === 'VENDOR_ORGANIZATION' ? ' Request Store Activation again; the activation checklist is re-evaluated.' : ''), (string) $done->id);
            }
        }

        return $lifted;
    }

    /** @return array<string, int> referred and applied counts for the operations home */
    public static function counts(): array
    {
        return ['referred' => DB::table('enforcement_actions')->where('state', 'REFERRED')->count(),
            'applied' => DB::table('enforcement_actions')->where('state', 'APPLIED')->where('action', '<>', 'WARNING')->count()];
    }

    /**
     * @param  array{user_id: int|null, role: string}  $actor
     * @return array{before: array<string, mixed>, after: array<string, mixed>}
     */
    private function liftLocked(object $row, string $reason, array $actor, string $correlation, string $event): array
    {
        $before = $this->subjectState((string) $row->subject_type, (string) $row->subject_id);
        $this->restore((string) $row->subject_type, (string) $row->subject_id, (string) $row->action, json_decode((string) ($row->prior_subject_state ?? '{}'), true) ?: [], $reason, $actor);
        DB::table('enforcement_actions')->where('id', $row->id)->update(['state' => 'LIFTED', 'lifted_at' => now(), 'lifted_by_user_id' => $actor['user_id'], 'lift_reason' => mb_substr($reason, 0, 2000),
            'correlation_id' => $correlation, 'lock_version' => (int) $row->lock_version + 1, 'updated_at' => now()]);
        $after = $this->subjectState((string) $row->subject_type, (string) $row->subject_id);
        $this->event((string) $row->id, $event, 'APPLIED', 'LIFTED', $before, $after, $reason, $actor, $correlation);

        return ['before' => $before, 'after' => $after];
    }

    /** @param array{user_id: int|null, role: string} $actor */
    private function impose(string $type, string $subjectId, string $action, string $reason, array $actor): void
    {
        if ($type === 'VENDOR_ORGANIZATION') {
            $organization = DB::table('vendor_organizations')->where('id', $subjectId)->first();
            $status = $action === 'TEMPORARY_RESTRICTION' ? 'RESTRICTED' : 'SUSPENDED';
            $update = ['store_activation_status' => $status, 'lock_version' => (int) $organization->lock_version + 1, 'updated_at' => now()];
            // Never overwrite a different existing hold: it keeps blocking under its own rule until resolved there.
            if ($organization->activation_hold_code === null || str_starts_with((string) $organization->activation_hold_code, 'ENFORCEMENT_')) {
                $update += ['activation_hold_code' => self::HOLD_CODES[$action], 'activation_hold_reason' => mb_substr($reason, 0, 2000)];
            }
            DB::table('vendor_organizations')->where('id', $subjectId)->update($update);
            $this->activationHistory($subjectId, (string) $organization->store_activation_status, $status, $status === 'RESTRICTED' ? 'RESTRICTED' : 'SUSPENDED', $reason, $actor);

            return;
        }
        if ($action === 'TEMPORARY_RESTRICTION') {
            return; // Enforced by BuyerCommerceRestriction on every new-commerce entry point.
        }
        $userId = DB::table('buyer_profiles')->where('id', $subjectId)->value('user_id');
        // A self-deleted Buyer stays DELETED; a sanction neither changes nor later restores that final status.
        DB::table('users')->where('id', $userId)->where('account_status', '!=', 'DELETED')->update(['account_status' => $action === 'PERMANENT_BAN' ? 'DEACTIVATED' : 'SUSPENDED', 'lock_version' => DB::raw('lock_version + 1'), 'updated_at' => now()]);
        foreach (AuthSession::query()->where('user_id', $userId)->whereNull('revoked_at')->orderBy('id')->lockForUpdate()->get() as $session) {
            $this->sessions->revoke($session, 'ACCOUNT_ENFORCEMENT');
        }
    }

    /**
     * @param  array<string, mixed>  $prior
     * @param  array{user_id: int|null, role: string}  $actor
     */
    private function restore(string $type, string $subjectId, string $action, array $prior, string $reason, array $actor): void
    {
        if ($type === 'VENDOR_ORGANIZATION') {
            $organization = DB::table('vendor_organizations')->where('id', $subjectId)->first();
            $update = ['updated_at' => now(), 'lock_version' => (int) $organization->lock_version + 1];
            if (str_starts_with((string) $organization->activation_hold_code, 'ENFORCEMENT_')) {
                $update += ['activation_hold_code' => null, 'activation_hold_reason' => null];
            }
            DB::table('vendor_organizations')->where('id', $subjectId)->update($update + ['store_activation_status' => 'NOT_READY']);
            // The gate decides readiness; READY only lets the Owner request activation again. An Admin never activates.
            $readiness = app(StoreActivationGate::class)->evaluate($subjectId);
            $status = $readiness['ready'] ? 'READY' : 'NOT_READY';
            DB::table('vendor_organizations')->where('id', $subjectId)->update(['store_activation_status' => $status, 'updated_at' => now()]);
            $this->activationHistory($subjectId, (string) $organization->store_activation_status, $status, 'RESTORED', $reason, $actor, $readiness);

            return;
        }
        if ($action === 'TEMPORARY_RESTRICTION') {
            return;
        }
        $userId = DB::table('buyer_profiles')->where('id', $subjectId)->value('user_id');
        $priorStatus = (string) ($prior['account_status'] ?? 'ACTIVE');
        DB::table('users')->where('id', $userId)->where('account_status', '!=', 'DELETED')->update(['account_status' => in_array($priorStatus, ['SUSPENDED', 'DEACTIVATED'], true) ? 'ACTIVE' : $priorStatus,
            'lock_version' => DB::raw('lock_version + 1'), 'updated_at' => now()]);
    }

    /**
     * @param  array{user_id: int|null, role: string}  $actor
     * @param  array<string, mixed>|null  $readiness
     */
    private function activationHistory(string $organizationId, string $before, string $after, string $result, string $reason, array $actor, ?array $readiness = null): void
    {
        $readiness ??= app(StoreActivationGate::class)->evaluate($organizationId);
        DB::table('vendor_activation_history')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'state_before' => $before, 'state_after' => $after,
            'result' => $result, 'reason' => $reason, 'blockers' => json_encode($readiness['blockers'], JSON_THROW_ON_ERROR), 'readiness_snapshot' => json_encode($readiness, JSON_THROW_ON_ERROR),
            'actor_user_id' => $actor['user_id'], 'source' => $actor['user_id'] === null ? 'SYSTEM' : 'ADMIN', 'rule_version' => StoreActivationGate::RULE_VERSION,
            'recorded_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
    }

    /** @return array<string, mixed> */
    private function subjectState(string $type, string $subjectId): array
    {
        if ($type === 'VENDOR_ORGANIZATION') {
            $row = DB::table('vendor_organizations')->where('id', $subjectId)->first(['store_activation_status', 'activation_hold_code', 'marketplace_discoverability_status']);

            return ['store_activation_status' => $row?->store_activation_status, 'activation_hold_code' => $row?->activation_hold_code, 'discoverability' => $row?->marketplace_discoverability_status];
        }
        $user = DB::table('buyer_profiles as b')->join('users as u', 'u.id', '=', 'b.user_id')->where('b.id', $subjectId)->first(['u.account_status']);

        return ['account_status' => $user?->account_status, 'commerce_restricted_until' => BuyerCommerceRestriction::activeUntil($subjectId)?->toIso8601String()];
    }

    private function lockSubject(string $type, string $subjectId): void
    {
        if ($type === 'VENDOR_ORGANIZATION') {
            DB::table('vendor_organizations')->where('id', $subjectId)->lockForUpdate()->first();
        } else {
            $userId = DB::table('buyer_profiles')->where('id', $subjectId)->lockForUpdate()->value('user_id');
            DB::table('users')->where('id', $userId)->lockForUpdate()->first();
        }
    }

    private function subjectRow(string $type, string $subjectId): object
    {
        $row = ! Str::isUuid($subjectId) ? null : ($type === 'VENDOR_ORGANIZATION' ? DB::table('vendor_organizations')->where('id', $subjectId)->first(['id'])
            : DB::table('buyer_profiles')->where('id', $subjectId)->first(['id']));
        if ($row === null) {
            throw new AuthenticationException('SUBJECT_NOT_FOUND', 'This account is unavailable.', 404);
        }

        return $row;
    }

    private function openOrders(string $type, string $subjectId): int
    {
        return DB::table('orders')->where($type === 'BUYER' ? 'buyer_profile_id' : 'vendor_organization_id', $subjectId)->whereNotIn('order_state', self::TERMINAL_ORDER_STATES)->count();
    }

    /** @return array<string, mixed> */
    private function review(string $type, string $id): array
    {
        if ($type === 'VENDOR_ORGANIZATION') {
            $organization = DB::table('vendor_organizations')->where('id', $id)->first();
            if ($organization === null) {
                throw new AuthenticationException('SUBJECT_NOT_FOUND', 'This account is unavailable.', 404);
            }

            return ['subject_type' => $type, 'subject_id' => $id, 'display_name' => (string) $organization->store_name, 'account_status' => (string) $organization->account_status,
                'store_activation_status' => (string) $organization->store_activation_status, 'discoverability' => (string) $organization->marketplace_discoverability_status,
                'activation_hold_code' => $organization->activation_hold_code, 'open_orders' => $this->openOrders($type, $id),
                'orders_total' => DB::table('orders')->where('vendor_organization_id', $id)->count(),
                'disputes_total' => DB::table('dispute_cases')->where('vendor_organization_id', $id)->count(),
                'disputes_open' => DB::table('dispute_cases')->where('vendor_organization_id', $id)->whereNotIn('status', ['RESOLVED', 'CLOSED_INCONCLUSIVE'])->count(),
                'vendor_cancellations_90_days' => DB::table('nfr_events')->where('vendor_organization_id', $id)->where('occurred_at', '>=', now()->subDays(90))->count(),
                'review_flags_open' => DB::table('review_flags as f')->join('reviews as r', 'r.id', '=', 'f.review_id')->where('r.vendor_organization_id', $id)->where('f.state', 'OPEN')->count(),
                'commerce_restricted_until' => null];
        }
        $buyer = DB::table('buyer_profiles as b')->join('users as u', 'u.id', '=', 'b.user_id')->where('b.id', $id)->first(['b.id', 'b.user_id', 'b.buyer_type', 'b.created_at', 'u.name', 'u.email', 'u.public_id', 'u.account_status']);
        if ($buyer === null) {
            throw new AuthenticationException('SUBJECT_NOT_FOUND', 'This account is unavailable.', 404);
        }

        return ['subject_type' => $type, 'subject_id' => $id, 'display_name' => self::buyerName((string) $buyer->name, (string) $buyer->public_id), 'masked_email' => self::maskEmail((string) $buyer->email),
            'account_status' => (string) $buyer->account_status, 'buyer_type' => (string) $buyer->buyer_type, 'member_since' => CarbonImmutable::parse((string) $buyer->created_at)->toIso8601String(),
            'open_orders' => $this->openOrders($type, $id), 'orders_total' => DB::table('orders')->where('buyer_profile_id', $id)->count(),
            'disputes_total' => DB::table('dispute_cases')->where('buyer_profile_id', $id)->count(),
            'disputes_open' => DB::table('dispute_cases')->where('buyer_profile_id', $id)->whereNotIn('status', ['RESOLVED', 'CLOSED_INCONCLUSIVE'])->count(),
            'pickup_no_show_reports' => DB::table('dispute_cases')->where('buyer_profile_id', $id)->where('issue_type', 'PICKUP_NO_SHOW')->count(),
            'review_flags_open' => DB::table('review_flags')->where('reporter_user_id', $buyer->user_id)->where('state', 'OPEN')->count(),
            'commerce_restricted_until' => BuyerCommerceRestriction::activeUntil($id)?->toIso8601String()];
    }

    /** @return array<string, mixed> */
    private function summary(object $row): array
    {
        $name = $row->subject_type === 'VENDOR_ORGANIZATION' ? (string) (DB::table('vendor_organizations')->where('id', $row->subject_id)->value('store_name') ?? 'Vendor')
            : (($buyer = DB::table('buyer_profiles as b')->join('users as u', 'u.id', '=', 'b.user_id')->where('b.id', $row->subject_id)->first(['u.name', 'u.public_id'])) === null ? 'Buyer' : self::buyerName((string) $buyer->name, (string) $buyer->public_id));

        return ['id' => (string) $row->id, 'subject_type' => (string) $row->subject_type, 'subject_id' => (string) $row->subject_id, 'subject_name' => $name,
            'action' => (string) $row->action, 'action_label' => self::label((string) $row->action), 'state' => (string) $row->state, 'source' => (string) $row->source,
            'case_id' => $row->dispute_case_id, 'case_reference' => $row->case_reference ?? null, 'reason' => (string) $row->reason, 'duration_days' => $row->duration_days === null ? null : (int) $row->duration_days,
            'continuation_plan' => $row->continuation_plan, 'issued_role' => $row->issued_role, 'applied_role' => $row->applied_role,
            'created_at' => CarbonImmutable::parse((string) $row->created_at)->toIso8601String(), 'applied_at' => self::iso($row->applied_at), 'expires_at' => self::iso($row->expires_at),
            'lifted_at' => self::iso($row->lifted_at), 'lift_reason' => $row->lift_reason, 'lock_version' => (int) $row->lock_version];
    }

    /**
     * @param  list<string>  $permissions
     * @return list<string>
     */
    private function allowedActions(object $row, array $permissions): array
    {
        if (! in_array('enforcement.apply', $permissions, true)) {
            return [];
        }
        $ban = $row->action === 'PERMANENT_BAN';
        if ($ban && ! in_array('enforcement.ban', $permissions, true)) {
            return [];
        }

        return match ($row->state) {
            'REFERRED' => ['APPLY', 'DECLINE'],
            'APPLIED' => ['LIFT'],
            default => [],
        };
    }

    private function find(string $actionId): object
    {
        $row = Str::isUuid($actionId) ? DB::table('enforcement_actions as e')->leftJoin('dispute_cases as c', 'c.id', '=', 'e.dispute_case_id')->where('e.id', $actionId)->first(['e.*', 'c.reference as case_reference']) : null;
        if ($row === null) {
            throw new AuthenticationException('ENFORCEMENT_NOT_FOUND', 'This enforcement case is unavailable.', 404);
        }

        return $row;
    }

    /**
     * @param  array<string, mixed>|null  $before
     * @param  array<string, mixed>|null  $after
     * @param  array{user_id: int|null, role: string}  $actor
     */
    private function event(string $actionId, string $event, ?string $from, string $to, ?array $before, ?array $after, string $reason, array $actor, string $correlation): void
    {
        DB::table('enforcement_events')->insert(['id' => (string) Str::uuid7(), 'enforcement_action_id' => $actionId, 'event' => $event, 'from_state' => $from, 'to_state' => $to,
            'before' => $before === null ? null : json_encode($before, JSON_THROW_ON_ERROR), 'after' => $after === null ? null : json_encode($after, JSON_THROW_ON_ERROR),
            'reason' => mb_substr($reason, 0, 2000), 'actor_user_id' => $actor['user_id'], 'actor_role' => $actor['role'], 'correlation_id' => $correlation, 'occurred_at' => now()]);
    }

    private function notifySubject(string $type, string $subjectId, string $title, string $body, string $actionId): void
    {
        if ($type === 'VENDOR_ORGANIZATION') {
            foreach (DB::table('vendor_memberships')->where('vendor_organization_id', $subjectId)->where('role', 'OWNER')->where('status', 'ACTIVE')->pluck('user_id') as $userId) {
                $this->notifications->record((int) $userId, 'SUSPENSION', $title, $body, 'VENDOR_ORGANIZATION', $subjectId, 'enforcement:'.$actionId.':'.$title, $subjectId);
            }

            return;
        }
        $user = DB::table('buyer_profiles as b')->join('users as u', 'u.id', '=', 'b.user_id')->where('b.id', $subjectId)->first(['u.id', 'u.public_id']);
        if ($user !== null) {
            $this->notifications->record((int) $user->id, 'SUSPENSION', $title, $body, 'ACCOUNT', (string) $user->public_id, 'enforcement:'.$actionId.':'.$title);
        }
    }

    private function notifyOperations(string $actionId, string $title, string $body): void
    {
        $users = DB::table('admin_memberships as m')->join('platform_roles as r', 'r.id', '=', 'm.platform_role_id')->where('m.status', 'ACTIVE')
            ->whereIn('r.code', ['ADMIN_ORDER_DISPUTE', 'ADMIN_SUPERADMIN'])->pluck('m.user_id');
        foreach ($users as $userId) {
            $this->notifications->record((int) $userId, 'ADMIN_OPERATIONS', $title, $body, 'ENFORCEMENT_ACTION', $actionId, 'enforcement-plan:'.$actionId);
        }
    }

    public static function label(string $action): string
    {
        return match ($action) {
            'WARNING' => 'Warning',
            'TEMPORARY_RESTRICTION' => 'Temporary Restriction',
            'SUSPENSION' => 'Suspension',
            default => 'Permanent Ban',
        };
    }

    public static function buyerName(string $name, string $publicId): string
    {
        $parts = preg_split('/\s+/', trim($name)) ?: [];
        $first = $parts[0] ?? 'Buyer';
        $last = count($parts) > 1 ? mb_substr((string) end($parts), 0, 1).'.' : '';

        return trim($first.' '.$last).' · Buyer …'.substr(str_replace('-', '', $publicId), -6);
    }

    public static function maskEmail(string $email): string
    {
        [$local, $domain] = array_pad(explode('@', $email, 2), 2, '');

        return mb_substr($local, 0, 1).'•••@'.$domain;
    }

    private static function iso(mixed $value): ?string
    {
        return $value === null ? null : CarbonImmutable::parse((string) $value)->toIso8601String();
    }
}
