<?php

declare(strict_types=1);

namespace App\Domain\Disputes;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderRefundTimeline;
use App\Support\PortalDateRange;
use Carbon\CarbonImmutable;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;

/**
 * Read models for the Buyer, Vendor and Admin case surfaces. The timeline is one chronological list built only from
 * the append-only events, each with actor party, role, display name, exact instant and its evidence opened through
 * five-minute signed URLs. Deadlines are exact instants plus Asia/Manila labels for a countdown. Available actions
 * are computed from the server state and the caller's current permissions. Parties never see private contacts,
 * exact Vendor inventory, Buyer coordinates, Vendor commission, withholding or other protected finance; Fulfillment
 * Staff see only the case header and fulfillment evidence of an assigned order.
 */
final class DisputeQueries
{
    public const PER_PAGE = 20;

    public const VENDOR_GROUPS = [
        'ACTIVE' => DisputeRules::ACTIVE,
        'NEEDS_RESPONSE' => [DisputeRules::OPEN_AWAITING_RESPONSE, DisputeRules::MUTUAL_RESOLUTION, DisputeRules::AWAITING_CLARIFICATION],
        'ADMIN_REVIEW' => [DisputeRules::ESCALATED_ADMIN_REVIEW, DisputeRules::AWAITING_CLARIFICATION, DisputeRules::APPEAL_OPEN],
        'DECIDED' => [DisputeRules::DECIDED],
        'CONCLUDED' => DisputeRules::CONCLUDED,
    ];

    public function __construct(private readonly DisputeAccess $access, private readonly DisputeFiles $files) {}

    public function activeCount(Request $request): int
    {
        $query = DB::table('dispute_cases')->whereIn('status', DisputeRules::ACTIVE);
        if ($request->user()->account_type === 'BUYER') {
            return $query->where('buyer_profile_id', $this->access->buyerProfileId($request))->count();
        }
        $scope = $this->access->vendorScope($request, true);
        $query->where('vendor_organization_id', $scope['organization_id']);
        if (! DisputeAccess::allows($scope, DisputeAccess::PORTAL)) {
            $query->whereIn('order_id', DB::table('order_fulfillment_assignments')->select('order_id')->where('user_id', $scope['user_id'])->whereNull('ended_at'));
        }

        return $query->count();
    }

    /** @return array{items: list<array<string, mixed>>, meta: array<string, mixed>} */
    public function buyerList(Request $request, int $page): array
    {
        $query = DB::table('dispute_cases')->where('buyer_profile_id', $this->access->buyerProfileId($request));

        return $this->page($query, $page, 'BUYER');
    }

    /** @return array<string, mixed> */
    public function buyerDetail(Request $request, string $caseId): array
    {
        $case = $this->access->buyerCase($request, $caseId);

        return $this->detail($case, 'BUYER', ['role' => 'BUYER', 'permissions' => [], 'user_id' => (int) $request->user()->getKey()]);
    }

    /**
     * @param  array{group?: string, q?: string, page?: int}  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function vendorList(Request $request, array $filters): array
    {
        $scope = $this->access->vendorScope($request, true);
        $query = DB::table('dispute_cases')->where('vendor_organization_id', $scope['organization_id']);
        if (! DisputeAccess::allows($scope, DisputeAccess::PORTAL)) {
            $query->whereIn('order_id', DB::table('order_fulfillment_assignments')->select('order_id')->where('user_id', $scope['user_id'])->whereNull('ended_at'))->whereIn('status', DisputeRules::ACTIVE);
        }
        PortalDateRange::apply($query, 'created_at', $filters);
        $group = $filters['group'] ?? 'ACTIVE';
        if ($group !== 'ALL' && isset(self::VENDOR_GROUPS[$group])) {
            $query->whereIn('status', self::VENDOR_GROUPS[$group]);
        }
        $term = trim((string) ($filters['q'] ?? ''));
        if ($term !== '') {
            $like = '%'.str_replace(['\\', '%', '_'], ['\\\\', '\\%', '\\_'], mb_strtolower($term)).'%';
            $query->where(fn (Builder $match) => $match->whereRaw('lower(reference) like ?', [$like])->orWhereIn('order_id', DB::table('orders')->select('id')->whereRaw('lower(reference) like ?', [$like])));
        }
        $base = DB::table('dispute_cases')->where('vendor_organization_id', $scope['organization_id']);
        $counts = [];
        foreach (self::VENDOR_GROUPS as $key => $states) {
            $counts[$key] = (clone $base)->whereIn('status', $states)->count();
        }

        return $this->page($query, (int) ($filters['page'] ?? 1), 'VENDOR', ['group' => $group, 'counts' => $counts]);
    }

    /** @return array<string, mixed> */
    public function vendorDetail(Request $request, string $caseId): array
    {
        $scope = $this->access->vendorScope($request, true);

        return $this->detail($this->access->vendorCase($scope, $caseId), 'VENDOR', $scope);
    }

    /**
     * @param  array{status?: string, page?: int}  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function adminQueue(Request $request, array $filters): array
    {
        $this->access->admin($request, DisputeAccess::ADMIN_VIEW);
        $query = DB::table('dispute_cases');
        PortalDateRange::apply($query, 'created_at', $filters);
        $status = $filters['status'] ?? 'NEEDS_ADMIN';
        $query->whereIn('status', match ($status) {
            'NEEDS_ADMIN' => [DisputeRules::ESCALATED_ADMIN_REVIEW, DisputeRules::AWAITING_CLARIFICATION, DisputeRules::APPEAL_OPEN],
            'WITH_PARTIES' => [DisputeRules::OPEN_AWAITING_RESPONSE, DisputeRules::MUTUAL_RESOLUTION],
            'REMEDY_TRACKING' => [DisputeRules::DECIDED],
            'CONCLUDED' => DisputeRules::CONCLUDED,
            default => [...DisputeRules::ACTIVE, ...DisputeRules::CONCLUDED],
        });
        $base = DB::table('dispute_cases');
        $counts = ['NEEDS_ADMIN' => (clone $base)->whereIn('status', [DisputeRules::ESCALATED_ADMIN_REVIEW, DisputeRules::AWAITING_CLARIFICATION, DisputeRules::APPEAL_OPEN])->count(),
            'WITH_PARTIES' => (clone $base)->whereIn('status', [DisputeRules::OPEN_AWAITING_RESPONSE, DisputeRules::MUTUAL_RESOLUTION])->count(),
            'REMEDY_TRACKING' => (clone $base)->where('status', DisputeRules::DECIDED)->count(), 'CONCLUDED' => (clone $base)->whereIn('status', DisputeRules::CONCLUDED)->count()];

        return $this->page($query, (int) ($filters['page'] ?? 1), 'ADMIN', ['status' => $status, 'counts' => $counts]);
    }

    /** @return array<string, mixed> */
    public function adminDetail(Request $request, string $caseId): array
    {
        $admin = $this->access->admin($request, DisputeAccess::ADMIN_VIEW);
        $case = DB::table('dispute_cases')->where('id', DisputeAccess::uuid($caseId))->first();
        if ($case === null) {
            throw new AuthenticationException('DISPUTE_NOT_FOUND', 'This case is unavailable.', 404);
        }

        return $this->detail($case, 'ADMIN', $admin);
    }

    /**
     * @param  array<string, mixed>  $meta
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    private function page(Builder $query, int $page, string $audience, array $meta = []): array
    {
        $page = max(1, $page);
        $total = (clone $query)->count();
        $rows = $query->orderByRaw("CASE WHEN status IN ('RESOLVED','CLOSED_INCONCLUSIVE') THEN 1 ELSE 0 END")->orderByDesc('updated_at')->orderByDesc('id')
            ->offset(($page - 1) * self::PER_PAGE)->limit(self::PER_PAGE)->get();

        return ['items' => $rows->map(fn (object $case): array => $this->summary($case, $audience))->values()->all(),
            'meta' => $meta + ['page' => $page, 'per_page' => self::PER_PAGE, 'total' => $total, 'has_more' => $page * self::PER_PAGE < $total]];
    }

    /** @return array<string, mixed> */
    private function summary(object $case, string $audience): array
    {
        $order = DB::table('orders')->where('id', $case->order_id)->first(['reference', 'refund_state']);
        $deadline = self::nextDeadline($case);

        return [
            'id' => (string) $case->id, 'reference' => (string) $case->reference, 'order_id' => (string) $case->order_id, 'order_reference' => (string) ($order->reference ?? ''),
            'status' => (string) $case->status, 'case_kind' => (string) $case->case_kind, 'issue_type' => (string) $case->issue_type, 'requested_remedy' => (string) $case->requested_remedy,
            'requested_amount_centavos' => $case->requested_amount_centavos === null ? null : (int) $case->requested_amount_centavos,
            'filed_by_party' => (string) $case->filed_by_party, 'responsible_party' => self::responsibleParty($case), 'next_deadline' => $deadline,
            'refund_state' => (string) ($order->refund_state ?? 'NOT_REQUESTED'), 'remedy_state' => (string) $case->remedy_state,
            'appeal_available' => $case->status === DisputeRules::DECIDED && $case->appeal_due_at !== null && CarbonImmutable::parse((string) $case->appeal_due_at)->isFuture()
                && ! DB::table('dispute_appeals')->where('dispute_case_id', $case->id)->exists() && DB::table('dispute_decisions')->where('id', $case->current_decision_id)->value('kind') === 'ADMIN_DECISION',
            'vendor_name' => (string) (DB::table('store_profiles')->where('vendor_organization_id', $case->vendor_organization_id)->value('public_store_name') ?? 'Store'),
            'buyer_name' => $audience === 'BUYER' ? null : self::buyerName((string) $case->buyer_profile_id),
            'assigned_to_admin' => $case->assigned_admin_user_id !== null, 'decisions' => DB::table('dispute_decisions')->where('dispute_case_id', $case->id)->count(),
            'filed_at' => self::iso($case->created_at), 'updated_at' => self::iso($case->updated_at),
        ];
    }

    /**
     * @param  array{role: string, permissions: list<string>, user_id: int}  $scope
     * @return array<string, mixed>
     */
    private function detail(object $case, string $audience, array $scope): array
    {
        $limited = $audience === 'VENDOR' && ! DisputeAccess::allows($scope, DisputeAccess::PORTAL);
        $order = DB::table('orders')->where('id', $case->order_id)->first();
        $base = $this->summary($case, $audience) + [
            'description' => $limited ? null : (string) $case->description,
            'affected_lines' => json_decode((string) ($case->affected_lines ?? '[]'), true) ?: [],
            'original_payment_method' => $limited ? null : ['label' => (string) $case->masked_payment_method, 'physical' => $order->payment_method !== 'ONLINE',
                'notice' => 'Any refund returns to this original payment method. MateryalPH never collects a different refund destination.'],
            'preferred_contact_channel' => $audience === 'VENDOR' ? null : (string) $case->preferred_contact_channel,
            'order' => ['id' => (string) $order->id, 'reference' => (string) $order->reference, 'order_state' => (string) $order->order_state, 'dispute_state' => (string) $order->dispute_state,
                'refund_state' => (string) $order->refund_state, 'payment_method' => (string) $order->payment_method],
            'deadlines' => self::deadlines($case), 'server_time' => now()->toIso8601String(), 'timezone' => DisputeRules::TIMEZONE,
            'handler' => ['vendor' => $case->vendor_handler_user_id === null ? null : ['display_name' => self::userName((int) $case->vendor_handler_user_id), 'role' => (string) $case->vendor_handler_role],
                'admin_assigned' => $case->assigned_admin_user_id !== null, 'admin_is_me' => $audience === 'ADMIN' && (int) $case->assigned_admin_user_id === $scope['user_id']],
            'lock_version' => (int) $case->lock_version,
        ];
        $timeline = $this->timeline($case, $audience, $limited);
        if ($limited) {
            return array_replace($base, ['timeline' => $timeline, 'proposals' => [], 'clarifications' => [], 'decisions' => [], 'appeal' => null, 'remedies' => [], 'refunds' => [],
                'available_actions' => in_array($case->status, DisputeRules::ACTIVE, true) ? ['ADD_FULFILLMENT_EVIDENCE'] : [], 'limited_view' => true]);
        }
        $party = $audience === 'ADMIN' ? null : $audience;
        $decisions = DB::table('dispute_decisions')->where('dispute_case_id', $case->id)->orderBy('version')->get();
        $appeal = DB::table('dispute_appeals')->where('dispute_case_id', $case->id)->first();
        $remedies = DB::table('dispute_remedies')->where('dispute_case_id', $case->id)->whereNotNull('kind')->orderBy('created_at')->get();
        $refundTimeline = app(OrderRefundTimeline::class)->present($order, $audience !== 'BUYER', '');
        $caseRefundIds = DB::table('refunds')->where('dispute_case_id', $case->id)->pluck('id')->map(fn ($id): string => (string) $id)->all();
        $proposals = DB::table('dispute_resolution_proposals')->where('dispute_case_id', $case->id)->orderBy('created_at')->get();
        $clarifications = DB::table('dispute_clarifications')->where('dispute_case_id', $case->id)->whereNotNull('requested_party')->orderBy('created_at')->get();

        // Detail fields replace summary fields: decisions is a list here, a count in queues.
        $detail = array_replace($base, [
            'timeline' => $timeline,
            'proposals' => $proposals->map(fn (object $row): array => ['id' => (string) $row->id, 'proposed_by_party' => (string) $row->proposed_by_party, 'remedy' => (string) $row->remedy,
                'amount_centavos' => $row->amount_centavos === null ? null : (int) $row->amount_centavos, 'terms' => (string) $row->terms, 'state' => (string) $row->state,
                'proposed_at' => self::iso($row->created_at), 'answered_at' => self::iso($row->answered_at),
                'can_answer' => $party !== null && $row->state === 'PROPOSED' && $row->proposed_by_party !== $party && $case->status === DisputeRules::MUTUAL_RESOLUTION && $this->canAct($party, $scope)
                    && (! in_array($row->remedy, ['FULL_REFUND', 'PARTIAL_REFUND'], true) || $party === 'BUYER' || DisputeAccess::allows($scope, DisputeAccess::REFUND_OFFER))])->values()->all(),
            'clarifications' => $clarifications->map(fn (object $row): array => ['id' => (string) $row->id, 'requested_party' => (string) $row->requested_party, 'question' => (string) $row->question,
                'due_at' => self::iso($row->due_at), 'state' => (string) $row->state, 'response' => $row->response, 'responded_at' => self::iso($row->responded_at),
                'can_answer' => $party !== null && $row->requested_party === $party && $row->state === 'OPEN' && CarbonImmutable::parse((string) $row->due_at)->isFuture() && $this->canAct($party, $scope)])->values()->all(),
            'decisions' => $decisions->map(fn (object $row): array => ['id' => (string) $row->id, 'version' => (int) $row->version, 'kind' => (string) $row->kind, 'outcome' => (string) $row->outcome,
                'appeal_result' => $row->appeal_result, 'awarded_centavos' => (int) $row->awarded_centavos, 'reason' => $row->reason, 'evidence_limitation' => $row->evidence_limitation,
                'enforceable' => (bool) $row->enforceable, 'decided_at' => self::iso($row->created_at), 'appeal_due_at' => self::iso($row->appeal_due_at),
                'supersedes_decision_id' => $row->supersedes_decision_id, 'decider_role' => $row->kind === 'MUTUAL_AGREEMENT' ? 'BOTH_PARTIES' : (string) $row->actor_role,
                'decider_name' => $audience === 'ADMIN' && $row->actor_user_id !== null ? self::userName((int) $row->actor_user_id) : null,
                'sanctions' => $audience === 'ADMIN' ? (json_decode((string) ($row->sanctions ?? '{}'), true) ?: null) : null,
                'current' => (string) $row->id === (string) $case->current_decision_id])->values()->all(),
            'appeal' => $appeal === null ? null : ['id' => (string) $appeal->id, 'appellant_party' => (string) $appeal->appellant_party, 'grounds' => (string) $appeal->grounds,
                'statement' => (string) $appeal->statement, 'state' => (string) $appeal->state, 'filed_at' => self::iso($appeal->created_at), 'decided_at' => self::iso($appeal->decided_at),
                'appealed_decision_id' => (string) $appeal->appealed_decision_id, 'result_decision_id' => $appeal->result_decision_id],
            'remedies' => $remedies->filter(static fn (object $row): bool => $row->kind !== 'FEE_CREDIT_REVIEW' || $audience === 'ADMIN')->map(fn (object $row): array => [
                'id' => (string) $row->id, 'kind' => (string) $row->kind, 'state' => (string) $row->state, 'amount_centavos' => (int) $row->amount_centavos, 'note' => $row->note,
                'recorded' => $row->recorded_by_user_id !== null, 'completed_at' => self::iso($row->completed_at), 'decision_id' => $row->dispute_decision_id,
                'evidence' => $row->evidence_file_id === null ? null : $this->evidenceLink($audience, $case, (string) $row->evidence_file_id),
                'can_record' => $party === 'VENDOR' && $row->kind === 'REPLACEMENT' && $row->state === 'PENDING' && $row->recorded_by_user_id === null && $this->canAct('VENDOR', $scope),
                'can_confirm' => (($party === 'BUYER') || ($audience === 'ADMIN' && in_array(DisputeAccess::ADMIN_DECIDE, $scope['permissions'], true))) && $row->kind === 'REPLACEMENT'
                    && $row->state === 'PENDING' && $row->recorded_by_user_id !== null])->values()->all(),
            'refunds' => array_values(array_filter($refundTimeline['refunds'], static fn (array $refund): bool => in_array($refund['id'], $caseRefundIds, true))),
            'reimbursements' => array_values(array_filter($refundTimeline['reimbursements'], static fn (array $row): bool => DB::table('physical_reimbursements')->where('id', $row['id'])->whereNotNull('dispute_decision_id')->exists())),
            'limited_view' => false,
        ]);
        $detail['available_actions'] = $this->actions($case, $audience, $scope, $detail);
        if ($audience === 'ADMIN') {
            $detail['admin'] = $this->adminContext($case, $order, $scope, $decisions);
        } elseif ($audience === 'VENDOR') {
            $detail['permissions'] = ['can_respond' => DisputeAccess::allows($scope, DisputeAccess::RESPOND), 'can_offer_refund' => DisputeAccess::allows($scope, DisputeAccess::REFUND_OFFER)];
        }

        return $detail;
    }

    /** @return list<array<string, mixed>> */
    private function timeline(object $case, string $audience, bool $fulfillmentOnly): array
    {
        $evidence = DB::table('dispute_evidence as e')->join('files as f', 'f.id', '=', 'e.file_id')->where('e.dispute_case_id', $case->id)
            ->when($fulfillmentOnly, fn ($query) => $query->where('e.label', 'FULFILLMENT'))
            ->orderBy('e.created_at')->get(['e.dispute_event_id', 'e.file_id', 'e.label', 'e.description', 'f.content_type', 'f.original_name', 'f.byte_size'])->groupBy('dispute_event_id');
        $events = DB::table('dispute_events')->where('dispute_case_id', $case->id)->orderBy('sequence')->get();
        if ($fulfillmentOnly) {
            $events = $events->filter(static fn (object $event): bool => in_array($event->event_type, ['CASE_FILED', 'EVIDENCE_ADDED', 'ESCALATED', 'CASE_RESOLVED', 'CASE_CLOSED_INCONCLUSIVE'], true));
        }

        return $events->map(function (object $event) use ($evidence, $audience, $case, $fulfillmentOnly): array {
            $payload = json_decode((string) ($event->payload ?? '{}'), true) ?: [];
            if ($fulfillmentOnly) {
                $payload = [];
            }
            unset($payload['evidence_limitation_internal']);

            return [
                'id' => (string) $event->id, 'sequence' => (int) $event->sequence, 'type' => (string) $event->event_type, 'at' => self::iso($event->occurred_at),
                'actor' => ['party' => (string) $event->actor_party, 'role' => $event->actor_role, 'display_name' => self::actorName($event, $audience)],
                'body' => $fulfillmentOnly && $event->event_type === 'CASE_FILED' ? null : $event->body, 'details' => $payload,
                'evidence' => ($evidence->get($event->id) ?? collect())->map(fn (object $file): array => ['file_id' => (string) $file->file_id, 'label' => (string) $file->label,
                    'description' => $file->description, 'content_type' => (string) $file->content_type, 'name' => (string) ($file->original_name ?? 'Evidence'), 'byte_size' => (int) $file->byte_size]
                    + $this->evidenceLink($audience, $case, (string) $file->file_id))->values()->all(),
            ];
        })->values()->all();
    }

    /** @return array{url: string, expires_at: string} */
    private function evidenceLink(string $audience, object $case, string $fileId): array
    {
        return $this->files->link($audience, (string) $case->id, $fileId);
    }

    /**
     * @param  array{role: string, permissions: list<string>, user_id: int}  $scope
     * @param  array<string, mixed>  $detail
     * @return list<string>
     */
    private function actions(object $case, string $audience, array $scope, array $detail): array
    {
        $active = in_array($case->status, DisputeRules::ACTIVE, true);
        if ($audience === 'ADMIN') {
            $decide = in_array(DisputeAccess::ADMIN_DECIDE, $scope['permissions'], true);

            return array_values(array_filter([
                $decide && $active && (int) $case->assigned_admin_user_id !== $scope['user_id'] ? 'ASSIGN_TO_ME' : null,
                $decide && in_array($case->status, [DisputeRules::OPEN_AWAITING_RESPONSE, DisputeRules::MUTUAL_RESOLUTION], true) && $case->agreement_reached_at === null ? 'ESCALATE' : null,
                $decide && in_array($case->status, DisputeRules::UNDER_ADMIN_REVIEW, true) ? 'REQUEST_CLARIFICATION' : null,
                $decide && in_array($case->status, DisputeRules::UNDER_ADMIN_REVIEW, true) ? 'DECIDE' : null,
                $decide && $case->status === DisputeRules::APPEAL_OPEN ? 'DECIDE_APPEAL' : null,
            ]));
        }
        $party = $audience;
        $can = $this->canAct($party, $scope);
        $openProposal = array_filter($detail['proposals'], static fn (array $row): bool => $row['can_answer']);
        $clarification = array_filter($detail['clarifications'], static fn (array $row): bool => $row['can_answer']);
        $remedy = array_filter($detail['remedies'], static fn (array $row): bool => $row['can_record'] || ($party === 'BUYER' && $row['can_confirm']));

        return array_values(array_filter([
            $can && $case->status === DisputeRules::OPEN_AWAITING_RESPONSE && $case->responding_party === $party && CarbonImmutable::parse((string) $case->response_due_at)->isFuture() ? 'RESPOND' : null,
            $can && $case->status === DisputeRules::MUTUAL_RESOLUTION && $case->agreement_reached_at === null ? 'PROPOSE' : null,
            $openProposal !== [] ? 'ANSWER_PROPOSAL' : null,
            $can && $case->agreement_reached_at === null && ($case->status === DisputeRules::MUTUAL_RESOLUTION || ($case->status === DisputeRules::OPEN_AWAITING_RESPONSE && $case->responding_party === $party)) ? 'ESCALATE' : null,
            $can && $active ? 'ADD_EVIDENCE' : null,
            $can && $active ? 'MESSAGE' : null,
            $clarification !== [] ? 'ANSWER_CLARIFICATION' : null,
            $can && $detail['appeal_available'] ? 'APPEAL' : null,
            $remedy !== [] && $party === 'VENDOR' ? 'RECORD_REPLACEMENT' : null,
            $remedy !== [] && $party === 'BUYER' ? 'CONFIRM_REPLACEMENT' : null,
        ]));
    }

    /**
     * @param  array{role: string, permissions: list<string>, user_id: int}  $scope
     * @param  Collection<int, \stdClass>  $decisions
     * @return array<string, mixed>
     */
    private function adminContext(object $case, object $order, array $scope, $decisions): array
    {
        $appeal = DB::table('dispute_appeals')->where('dispute_case_id', $case->id)->where('state', 'OPEN')->first();
        $appealed = $appeal === null ? null : $decisions->firstWhere('id', $appeal->appealed_decision_id);
        $planner = app(DisputeRefundPlanner::class);
        try {
            $full = $planner->plan($order, $case, 'FULL_REFUND', null, []);
            $refundable = ['online_centavos' => (int) $full['online_refund_total_centavos'], 'cash_centavos' => (int) $full['cash_reimbursement_centavos']];
        } catch (AuthenticationException) {
            $refundable = ['online_centavos' => 0, 'cash_centavos' => 0];
        }

        return [
            'outcomes' => DisputeRules::OUTCOMES, 'sanctions' => DisputeRules::SANCTIONS, 'metric_events' => DisputeRules::METRIC_EVENTS, 'refundable' => $refundable,
            'already_awarded_centavos' => DisputeRefundPlanner::awardedSoFar((string) $case->id),
            'appeal_reviewer_conflict' => DisputeRules::appealReviewerConflict($appealed, $scope['user_id'], $scope['role']),
            'unanswered_clarification' => DB::table('dispute_clarifications')->where('dispute_case_id', $case->id)->whereIn('state', ['OPEN', 'EXPIRED'])->exists(),
            'buyer' => ['display_name' => self::buyerName((string) $case->buyer_profile_id), 'prior_cases' => DB::table('dispute_cases')->where('buyer_profile_id', $case->buyer_profile_id)->where('id', '<>', $case->id)->count()],
            'vendor' => ['display_name' => (string) (DB::table('store_profiles')->where('vendor_organization_id', $case->vendor_organization_id)->value('public_store_name') ?? 'Store'),
                'prior_cases' => DB::table('dispute_cases')->where('vendor_organization_id', $case->vendor_organization_id)->where('id', '<>', $case->id)->count()],
            'order_timeline' => DB::table('order_status_history')->where('order_id', $order->id)->orderBy('created_at')->orderBy('id')->limit(100)
                ->get(['state_family', 'from_state', 'to_state', 'actor_role', 'reason_code', 'created_at'])->map(static fn (object $row): array => ['family' => (string) $row->state_family,
                    'from_state' => $row->from_state, 'to_state' => (string) $row->to_state, 'actor_role' => $row->actor_role, 'reason_code' => $row->reason_code, 'at' => self::iso($row->created_at)])->all(),
            'enforcement' => DB::table('enforcement_actions')->where('dispute_case_id', $case->id)->orderBy('created_at')->get(['subject_type', 'action', 'state', 'reason', 'created_at'])
                ->map(static fn (object $row): array => ['subject_type' => (string) $row->subject_type, 'action' => (string) $row->action, 'state' => (string) $row->state, 'reason' => (string) $row->reason,
                    'recorded_at' => self::iso($row->created_at)])->all(),
        ];
    }

    /** @param array{role: string, permissions: list<string>} $scope */
    private function canAct(string $party, array $scope): bool
    {
        return $party === 'BUYER' || DisputeAccess::allows($scope, DisputeAccess::RESPOND);
    }

    /** @return list<array{kind: string, at: string, responsible_party: string, label: string}> */
    public static function deadlines(object $case): array
    {
        $rows = [];
        $add = static function (string $kind, mixed $at, string $party) use (&$rows): void {
            if ($at === null) {
                return;
            }
            $instant = CarbonImmutable::parse((string) $at);
            $rows[] = ['kind' => $kind, 'at' => $instant->toIso8601String(), 'responsible_party' => $party, 'label' => $instant->setTimezone(DisputeRules::TIMEZONE)->format('M j, Y g:i A').' (Asia/Manila)'];
        };
        if ($case->status === DisputeRules::OPEN_AWAITING_RESPONSE) {
            $add('RESPONSE', $case->response_due_at, (string) $case->responding_party);
        } elseif ($case->status === DisputeRules::MUTUAL_RESOLUTION && $case->agreement_reached_at === null) {
            $add('MUTUAL_RESOLUTION', $case->mutual_resolution_due_at, 'BOTH');
        } elseif ($case->status === DisputeRules::AWAITING_CLARIFICATION) {
            $add('CLARIFICATION', $case->clarification_due_at, 'REQUESTED_PARTY');
        } elseif ($case->status === DisputeRules::DECIDED && ! DB::table('dispute_appeals')->where('dispute_case_id', $case->id)->exists()
            && $case->appeal_due_at !== null && CarbonImmutable::parse((string) $case->appeal_due_at)->isFuture()) {
            $add('APPEAL', $case->appeal_due_at, 'EITHER');
        }

        return $rows;
    }

    /** @return array{kind: string, at: string, responsible_party: string, label: string}|null */
    private static function nextDeadline(object $case): ?array
    {
        $deadlines = self::deadlines($case);

        return $deadlines[0] ?? null;
    }

    private static function responsibleParty(object $case): string
    {
        return match ($case->status) {
            DisputeRules::OPEN_AWAITING_RESPONSE => (string) $case->responding_party,
            DisputeRules::MUTUAL_RESOLUTION => $case->agreement_reached_at === null ? 'BOTH' : ($case->remedy_state === 'PENDING' ? 'VENDOR' : 'NONE'),
            DisputeRules::ESCALATED_ADMIN_REVIEW, DisputeRules::APPEAL_OPEN => 'ADMIN',
            DisputeRules::AWAITING_CLARIFICATION => 'REQUESTED_PARTY',
            DisputeRules::DECIDED => $case->remedy_state === 'PENDING' || $case->remedy_state === 'FAILED' ? 'VENDOR' : 'NONE',
            default => 'NONE',
        };
    }

    private static function actorName(object $event, string $audience): string
    {
        return match ($event->actor_party) {
            'SYSTEM' => 'MateryalPH',
            'ADMIN' => $audience === 'ADMIN' && $event->actor_user_id !== null ? self::userName((int) $event->actor_user_id) : 'MateryalPH Order and Dispute Staff',
            'BUYER' => $event->actor_user_id === null ? 'Buyer' : self::userName((int) $event->actor_user_id),
            default => $event->actor_user_id === null ? 'Store' : self::userName((int) $event->actor_user_id),
        };
    }

    private static function userName(int $userId): string
    {
        $name = DB::table('user_profiles')->where('user_id', $userId)->value('full_name') ?? DB::table('users')->where('id', $userId)->value('name');

        return is_string($name) && trim($name) !== '' ? trim($name) : 'Team member';
    }

    private static function buyerName(string $buyerProfileId): string
    {
        $userId = DB::table('buyer_profiles')->where('id', $buyerProfileId)->value('user_id');

        return $userId === null ? 'Buyer' : self::userName((int) $userId);
    }

    private static function iso(mixed $value): ?string
    {
        return $value === null ? null : CarbonImmutable::parse((string) $value)->toIso8601String();
    }
}
