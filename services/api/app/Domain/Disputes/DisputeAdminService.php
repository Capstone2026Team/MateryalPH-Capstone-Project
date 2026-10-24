<?php

declare(strict_types=1);

namespace App\Domain\Disputes;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderActor;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Throwable;

/**
 * Order and Dispute Staff (and Super Admin) review: take the case, escalate a safety or compliance matter directly,
 * request 24-hour clarification, decide with a remedy, a reason and a conflict check, review the one appeal, and
 * confirm a replacement the Buyer did not acknowledge. A decision is a new immutable version; an appeal decision
 * supersedes without erasing the original. An award executes at once only when marked immediately enforceable;
 * otherwise the sweep executes it when the five-business-day appeal window lapses unappealed.
 *
 * Conflict check: the decider confirms no personal or financial interest; the server additionally refuses an
 * Order and Dispute Staff appeal reviewer who made the appealed decision (a Super Admin is exempt) and any Admin
 * who is also a party's account.
 */
final class DisputeAdminService
{
    public function __construct(
        private readonly DisputeAccess $access,
        private readonly CatalogAccess $keys,
        private readonly DisputeTimeline $timeline,
        private readonly DisputeOrderSync $sync,
        private readonly DisputeCaseService $cases,
        private readonly DisputeRemedyService $remedies,
        private readonly DisputeRefundPlanner $planner,
        private readonly DisputeNotifier $notifier,
        private readonly AuditRecorder $audit,
    ) {}

    public function assign(Request $request, string $caseId): void
    {
        $this->act($request, $caseId, 'ADMIN_DISPUTE_ASSIGN', function (object $order, object $case, OrderActor $actor): void {
            if (! in_array($case->status, DisputeRules::ACTIVE, true)) {
                throw new AuthenticationException('DISPUTE_CONCLUDED', 'This case has concluded.', 409);
            }
            DB::table('dispute_cases')->where('id', $case->id)->update(['assigned_admin_user_id' => $actor->userId, 'updated_at' => now()]);
            $this->timeline->append($case, 'HANDLER_ASSIGNED', $actor, 'ADMIN', null, ['admin_role' => $actor->role]);
        });
    }

    public function escalate(Request $request, string $caseId, string $reason): void
    {
        $this->act($request, $caseId, 'ADMIN_DISPUTE_ESCALATE', function (object $order, object $case, OrderActor $actor) use ($reason): void {
            if (! in_array($case->status, [DisputeRules::OPEN_AWAITING_RESPONSE, DisputeRules::MUTUAL_RESOLUTION], true) || $case->agreement_reached_at !== null) {
                throw new AuthenticationException('DISPUTE_STATE_CONFLICT', 'Only a case still with the parties can be escalated.', 409, ['status' => $case->status]);
            }
            $this->cases->escalateCase($order, $case, $actor, 'DIRECT_SAFETY_OR_COMPLIANCE', $reason);
        });
    }

    /** @param list<string> $parties */
    public function requestClarification(Request $request, string $caseId, array $parties, string $question): void
    {
        $this->act($request, $caseId, 'ADMIN_DISPUTE_CLARIFY', function (object $order, object $case, OrderActor $actor) use ($parties, $question): void {
            if (! in_array($case->status, DisputeRules::UNDER_ADMIN_REVIEW, true)) {
                throw new AuthenticationException('DISPUTE_STATE_CONFLICT', 'Clarification is requested during Admin review.', 409, ['status' => $case->status]);
            }
            $parties = array_values(array_unique(array_intersect($parties, ['BUYER', 'VENDOR'])));
            if ($parties === []) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Choose who must answer.', 422, ['parties' => ['Choose the Buyer, the Vendor or both.']]);
            }
            $due = now()->addHours(DisputeRules::deadline('clarification_hours'));
            $group = (string) Str::uuid7();
            foreach ($parties as $party) {
                if (DB::table('dispute_clarifications')->where('dispute_case_id', $case->id)->where('requested_party', $party)->where('state', 'OPEN')->exists()) {
                    throw new AuthenticationException('CLARIFICATION_ALREADY_OPEN', 'A clarification request to this party is still open.', 409);
                }
                DB::table('dispute_clarifications')->insert(['id' => (string) Str::uuid7(), 'dispute_case_id' => $case->id, 'actor_user_id' => $actor->userId, 'state' => 'OPEN', 'payload' => null,
                    'request_group_id' => $group, 'requested_party' => $party, 'question' => mb_substr(trim($question), 0, 2000), 'due_at' => $due, 'created_at' => now(), 'updated_at' => now()]);
            }
            DB::table('dispute_cases')->where('id', $case->id)->update(['status' => DisputeRules::AWAITING_CLARIFICATION, 'clarification_due_at' => $due,
                'assigned_admin_user_id' => $case->assigned_admin_user_id ?? $actor->userId, 'lock_version' => (int) $case->lock_version + 1, 'updated_at' => now()]);
            $this->sync->mirror($order, DisputeRules::AWAITING_CLARIFICATION, $actor, 'DISPUTE_CLARIFICATION_REQUESTED');
            $this->timeline->append($case, 'CLARIFICATION_REQUESTED', $actor, 'ADMIN', $question, ['parties' => $parties, 'due_at' => $due->toIso8601String()]);
            $text = 'MateryalPH asked a question on case '.$case->reference.'. Answer by '.$due->setTimezone(DisputeRules::TIMEZONE)->format('M j, Y g:i A').' (Asia/Manila).';
            if (in_array('BUYER', $parties, true)) {
                $this->notifier->buyer($case, 'Clarification requested — case '.$case->reference, $text);
            }
            if (in_array('VENDOR', $parties, true)) {
                $this->notifier->vendor($case, 'Clarification requested — case '.$case->reference, $text);
            }
        });
    }

    /**
     * @param  array{outcome: string, reason: string, amount_centavos?: int|null, affected_line_ids?: list<string>, enforceable: bool, conflict_check_confirmed: bool, evidence_limitation?: string|null,
     *               sanctions?: list<array{subject: string, action: string, reason: string, scope?: string|null, duration_days?: int|null, restoration_condition?: string|null}>, metric_event?: string|null, lock_version: int}  $input
     */
    public function decide(Request $request, string $caseId, array $input): void
    {
        $this->act($request, $caseId, 'ADMIN_DISPUTE_DECIDE', function (object $order, object $case, OrderActor $actor) use ($input): void {
            if (! in_array($case->status, DisputeRules::UNDER_ADMIN_REVIEW, true)) {
                throw new AuthenticationException('DISPUTE_STATE_CONFLICT', 'A decision is issued during Admin review.', 409, ['status' => $case->status]);
            }
            $this->staleCheck($case, $input['lock_version']);
            $this->conflictCheck($case, $actor, $input['conflict_check_confirmed'], null);
            $unanswered = DB::table('dispute_clarifications')->where('dispute_case_id', $case->id)->whereIn('state', ['OPEN', 'EXPIRED'])->exists();
            if ($unanswered && trim((string) ($input['evidence_limitation'] ?? '')) === '') {
                throw new AuthenticationException('VALIDATION_FAILED', 'Record the evidence limitation: a clarification was not answered.', 422,
                    ['evidence_limitation' => ['An unanswered clarification does not prove fault. Record how it limits the evidence.']]);
            }
            DB::table('dispute_clarifications')->where('dispute_case_id', $case->id)->where('state', 'OPEN')->update(['state' => 'EXPIRED', 'updated_at' => now()]);
            $appealDue = DisputeRules::addBusinessDays(CarbonImmutable::now(), DisputeRules::deadline('appeal_business_days'));
            $decision = $this->insertDecision($order, $case, $actor, 'ADMIN_DECISION', $input, null, null, $appealDue);
            DB::table('dispute_cases')->where('id', $case->id)->update(['status' => DisputeRules::DECIDED, 'decided_at' => now(), 'appeal_due_at' => $appealDue, 'clarification_due_at' => null,
                'current_decision_id' => $decision->id, 'assigned_admin_user_id' => $case->assigned_admin_user_id ?? $actor->userId, 'lock_version' => (int) $case->lock_version + 1, 'updated_at' => now()]);
            $case = DB::table('dispute_cases')->where('id', $case->id)->first();
            $order = $this->sync->mirror($order, DisputeRules::DECIDED, $actor, 'DISPUTE_DECIDED');
            $this->timeline->append($case, 'DECISION_ISSUED', $actor, 'ADMIN', $input['reason'], ['decision_id' => (string) $decision->id, 'version' => (int) $decision->version,
                'outcome' => $input['outcome'], 'awarded_centavos' => (int) $decision->awarded_centavos, 'enforceable' => $input['enforceable'], 'appeal_due_at' => $appealDue->toIso8601String(),
                'evidence_limitation' => $input['evidence_limitation'] ?? null]);
            $when = $appealDue->setTimezone(DisputeRules::TIMEZONE)->format('M j, Y g:i A');
            $text = 'A decision was issued on case '.$case->reference.': '.self::outcomeText($input['outcome']).'. Either party may file one appeal with new evidence or a material process error until '.$when.' (Asia/Manila).';
            $this->notifier->buyer($case, 'Decision on case '.$case->reference, $text);
            $this->notifier->vendor($case, 'Decision on case '.$case->reference, $text);
            if ($input['enforceable']) {
                $this->remedies->execute($order, $case, $decision, $actor);
            }
        });
    }

    /**
     * @param  array{result: string, outcome?: string|null, reason: string, amount_centavos?: int|null, affected_line_ids?: list<string>, conflict_check_confirmed: bool,
     *               sanctions?: list<array{subject: string, action: string, reason: string, scope?: string|null, duration_days?: int|null, restoration_condition?: string|null}>, metric_event?: string|null, lock_version: int}  $input
     */
    public function decideAppeal(Request $request, string $caseId, array $input): void
    {
        $this->act($request, $caseId, 'ADMIN_DISPUTE_APPEAL_DECIDE', function (object $order, object $case, OrderActor $actor) use ($input): void {
            if ($case->status !== DisputeRules::APPEAL_OPEN) {
                throw new AuthenticationException('DISPUTE_STATE_CONFLICT', 'No appeal is open on this case.', 409, ['status' => $case->status]);
            }
            $this->staleCheck($case, $input['lock_version']);
            $appeal = DB::table('dispute_appeals')->where('dispute_case_id', $case->id)->where('state', 'OPEN')->lockForUpdate()->first();
            $original = DB::table('dispute_decisions')->where('id', $appeal->appealed_decision_id)->first();
            $this->conflictCheck($case, $actor, $input['conflict_check_confirmed'], $original);
            if (! in_array($input['result'], ['AFFIRMED', 'MODIFIED', 'REVERSED'], true)) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Choose Affirmed, Modified or Reversed.', 422, ['result' => ['Choose the appeal result.']]);
            }
            $values = $input;
            if ($input['result'] === 'AFFIRMED') {
                $allocation = json_decode((string) ($original->allocation ?? '{}'), true) ?: [];
                $values['outcome'] = (string) $original->outcome;
                $values['amount_centavos'] = $original->outcome === 'PARTIAL_REFUND' ? (int) $original->awarded_centavos : null;
                $values['affected_line_ids'] = array_values(array_map('strval', $allocation['affected_line_ids'] ?? []));
            } elseif (($input['outcome'] ?? null) === null || ($input['result'] === 'REVERSED' && $input['outcome'] === $original->outcome)) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Choose the remedy that replaces the original decision.', 422, ['outcome' => ['Choose the remedy for this appeal result.']]);
            }
            $decision = $this->insertDecision($order, $case, $actor, 'APPEAL_DECISION', $values + ['enforceable' => true], $input['result'], (string) $original->id);
            DB::table('dispute_appeals')->where('id', $appeal->id)->update(['state' => 'DECIDED', 'result_decision_id' => $decision->id, 'decided_at' => now(), 'updated_at' => now()]);
            DB::table('dispute_cases')->where('id', $case->id)->update(['status' => DisputeRules::DECIDED, 'decided_at' => now(), 'current_decision_id' => $decision->id,
                'lock_version' => (int) $case->lock_version + 1, 'updated_at' => now()]);
            $case = DB::table('dispute_cases')->where('id', $case->id)->first();
            $order = $this->sync->mirror($order, DisputeRules::DECIDED, $actor, 'DISPUTE_APPEAL_DECIDED');
            $this->timeline->append($case, 'APPEAL_DECIDED', $actor, 'ADMIN', $input['reason'], ['decision_id' => (string) $decision->id, 'version' => (int) $decision->version,
                'result' => $input['result'], 'outcome' => (string) $decision->outcome, 'supersedes_decision_id' => (string) $original->id, 'awarded_centavos' => (int) $decision->awarded_centavos]);
            $text = 'The appeal on case '.$case->reference.' was decided: '.strtolower($input['result']).'. The appeal decision is final and the original decision stays on record.';
            $this->notifier->buyer($case, 'Appeal decided — case '.$case->reference, $text);
            $this->notifier->vendor($case, 'Appeal decided — case '.$case->reference, $text);
            $this->remedies->execute($order, $case, $decision, $actor);
        });
    }

    public function confirmRemedy(Request $request, string $caseId, string $remedyId, string $reason): void
    {
        $this->act($request, $caseId, 'ADMIN_DISPUTE_REMEDY_CONFIRM', function (object $order, object $case, OrderActor $actor) use ($remedyId, $reason): void {
            $remedy = DB::table('dispute_remedies')->where('id', DisputeAccess::uuid($remedyId))->where('dispute_case_id', $case->id)->where('kind', 'REPLACEMENT')->lockForUpdate()->first();
            if ($remedy === null || $remedy->state !== 'PENDING' || $remedy->recorded_by_user_id === null) {
                throw new AuthenticationException('REMEDY_NOT_READY', 'Only a replacement the Vendor recorded can be confirmed by review.', 409);
            }
            DB::table('dispute_remedies')->where('id', $remedy->id)->update(['state' => 'COMPLETED', 'completed_at' => now(), 'note' => mb_substr('Confirmed by Admin review: '.trim($reason), 0, 500),
                'lock_version' => (int) $remedy->lock_version + 1, 'updated_at' => now()]);
            $this->timeline->append($case, 'REMEDY_COMPLETED', $actor, 'ADMIN', $reason, ['remedy_id' => (string) $remedy->id, 'kind' => 'REPLACEMENT']);
            $this->remedies->evaluate($order, $this->remedies->refreshRemedyState(DB::table('dispute_cases')->where('id', $case->id)->first()), $actor);
        });
    }

    /**
     * Timers: unanswered cases escalate after 48 hours, unagreed ones after 72 hours, an unanswered clarification
     * expires after 24 hours, and an unappealed decision becomes final (and executes) after five business days.
     *
     * @return array<string, int>
     */
    public function sweep(int $limit = 100): array
    {
        $counts = ['escalated' => 0, 'clarifications_expired' => 0, 'finalized' => 0];
        $now = CarbonImmutable::now();
        $due = DB::table('dispute_cases')->where(fn ($query) => $query
            ->where(fn ($open) => $open->where('status', DisputeRules::OPEN_AWAITING_RESPONSE)->where('response_due_at', '<=', $now))
            ->orWhere(fn ($mutual) => $mutual->where('status', DisputeRules::MUTUAL_RESOLUTION)->whereNull('agreement_reached_at')->where('mutual_resolution_due_at', '<=', $now))
            ->orWhere(fn ($clarify) => $clarify->where('status', DisputeRules::AWAITING_CLARIFICATION)->where('clarification_due_at', '<=', $now))
            ->orWhere(fn ($decided) => $decided->where('status', DisputeRules::DECIDED)->where('appeal_due_at', '<=', $now)))
            ->orderBy('updated_at')->limit($limit)->get(['id', 'order_id']);
        foreach ($due as $row) {
            try {
                $result = DB::transaction(function () use ($row, $now): ?string {
                    $order = DB::table('orders')->where('id', $row->order_id)->lockForUpdate()->first();
                    $case = DB::table('dispute_cases')->where('id', $row->id)->lockForUpdate()->first();
                    $actor = OrderActor::system();

                    return match (true) {
                        $case->status === DisputeRules::OPEN_AWAITING_RESPONSE && CarbonImmutable::parse((string) $case->response_due_at)->lessThanOrEqualTo($now) => $this->sweepEscalate($order, $case, $actor, 'NO_RESPONSE', 'The 48-hour response window ended without a response.'),
                        $case->status === DisputeRules::MUTUAL_RESOLUTION && $case->agreement_reached_at === null && CarbonImmutable::parse((string) $case->mutual_resolution_due_at)->lessThanOrEqualTo($now) => $this->sweepEscalate($order, $case, $actor, 'NO_AGREEMENT', 'The 72-hour mutual-resolution period ended without an agreement.'),
                        $case->status === DisputeRules::AWAITING_CLARIFICATION => $this->expireClarifications($order, $case, $actor, $now),
                        $case->status === DisputeRules::DECIDED => $this->finalize($order, $case, $actor),
                        default => null,
                    };
                });
                if ($result !== null) {
                    $counts[$result]++;
                }
            } catch (Throwable $exception) {
                report($exception);
            }
        }

        return $counts;
    }

    private function sweepEscalate(object $order, object $case, OrderActor $actor, string $code, string $reason): string
    {
        $this->cases->escalateCase($order, $case, $actor, $code, $reason);

        return 'escalated';
    }

    private function expireClarifications(object $order, object $case, OrderActor $actor, CarbonImmutable $now): ?string
    {
        $expired = DB::table('dispute_clarifications')->where('dispute_case_id', $case->id)->where('state', 'OPEN')->where('due_at', '<=', $now)->get(['id', 'requested_party']);
        foreach ($expired as $row) {
            DB::table('dispute_clarifications')->where('id', $row->id)->update(['state' => 'EXPIRED', 'updated_at' => now()]);
            $this->timeline->append($case, 'CLARIFICATION_EXPIRED', $actor, 'SYSTEM', 'The '.strtolower((string) $row->requested_party).' did not answer within 24 hours. This alone does not prove fault; the decision uses the available evidence.',
                ['clarification_id' => (string) $row->id, 'party' => (string) $row->requested_party]);
        }
        $this->cases->returnToReviewWhenAnswered($order, DB::table('dispute_cases')->where('id', $case->id)->first(), $actor);

        return $expired->isEmpty() ? null : 'clarifications_expired';
    }

    private function finalize(object $order, object $case, OrderActor $actor): ?string
    {
        $decision = DB::table('dispute_decisions')->where('id', $case->current_decision_id)->first();
        if ($decision === null) {
            return null;
        }
        $result = $this->remedies->execute($order, $case, $decision, $actor);

        return $result['case']->status !== DisputeRules::DECIDED ? 'finalized' : null;
    }

    /**
     * @param  array<string, mixed>  $input
     */
    private function insertDecision(object $order, object $case, OrderActor $actor, string $kind, array $input, ?string $appealResult, ?string $supersedes, ?CarbonImmutable $appealDue = null): object
    {
        $outcome = (string) $input['outcome'];
        if (! in_array($outcome, DisputeRules::OUTCOMES, true) || $outcome === 'NO_FURTHER_ACTION') {
            throw new AuthenticationException('VALIDATION_FAILED', 'Choose the remedy for this decision.', 422, ['outcome' => ['Choose a listed outcome.']]);
        }
        if (mb_strlen(trim((string) $input['reason'])) < 20) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Explain the decision.', 422, ['reason' => ['Give the reason in at least 20 characters.']]);
        }
        $affected = array_values(array_map('strval', (array) ($input['affected_line_ids'] ?? [])));
        if ($affected === []) {
            $affected = array_column(json_decode((string) ($case->affected_lines ?? '[]'), true) ?: [], 'order_line_id');
        }
        $awarded = 0;
        if (in_array($outcome, DisputeRules::MONEY_OUTCOMES, true)) {
            // Validates the award against the original lines and what is still refundable before it is recorded.
            $plan = $this->planner->plan($order, $case, $outcome, $outcome === 'PARTIAL_REFUND' ? (int) ($input['amount_centavos'] ?? 0) : null, $affected);
            $awarded = $outcome === 'PARTIAL_REFUND' ? (int) $input['amount_centavos'] : (int) $plan['awarded_centavos'] + (int) $plan['already_awarded_centavos'];
        }
        $sanctions = $this->sanctions($input['sanctions'] ?? [], $input['metric_event'] ?? null);
        $id = (string) Str::uuid7();
        $version = (int) DB::table('dispute_decisions')->where('dispute_case_id', $case->id)->max('version') + 1;
        DB::table('dispute_decisions')->insert(['id' => $id, 'dispute_case_id' => $case->id, 'actor_user_id' => $actor->userId, 'state' => 'ISSUED', 'payload' => null,
            'awarded_centavos' => $awarded, 'enforceable' => (bool) $input['enforceable'], 'version' => $version, 'kind' => $kind, 'outcome' => $outcome, 'appeal_result' => $appealResult,
            'reason' => mb_substr(trim((string) $input['reason']), 0, 4000), 'evidence_limitation' => isset($input['evidence_limitation']) ? mb_substr(trim((string) $input['evidence_limitation']), 0, 2000) : null,
            'actor_role' => $actor->role, 'sanctions' => json_encode($sanctions, JSON_THROW_ON_ERROR), 'allocation' => json_encode(['affected_line_ids' => $affected], JSON_THROW_ON_ERROR),
            'conflict_check_confirmed' => true, 'supersedes_decision_id' => $supersedes, 'appeal_due_at' => $appealDue,
            'correlation_id' => mb_substr($actor->correlationId, 0, 64), 'created_at' => now(), 'updated_at' => now()]);

        return DB::table('dispute_decisions')->where('id', $id)->first();
    }

    /**
     * @param  array<int, mixed>  $sanctions
     * @return array{actions: list<array<string, mixed>>, metric_event: ?string}
     */
    private function sanctions(array $sanctions, mixed $metric): array
    {
        $actions = [];
        foreach ($sanctions as $sanction) {
            if (! is_array($sanction) || ! in_array($sanction['action'] ?? null, DisputeRules::SANCTIONS, true) || ! in_array($sanction['subject'] ?? null, ['BUYER', 'VENDOR'], true)
                || mb_strlen(trim((string) ($sanction['reason'] ?? ''))) < 10) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Each sanction needs a subject, an action and a reason.', 422, ['sanctions' => ['Give each sanction a subject, an action and a reason of at least 10 characters.']]);
            }
            if ($sanction['action'] === 'TEMPORARY_RESTRICTION' && (int) ($sanction['duration_days'] ?? 0) <= 0) {
                throw new AuthenticationException('VALIDATION_FAILED', 'A temporary restriction needs a duration.', 422, ['sanctions' => ['Enter the restriction duration in days.']]);
            }
            if (in_array($sanction['action'], ['TEMPORARY_RESTRICTION', 'SUSPENSION'], true) && trim((string) ($sanction['restoration_condition'] ?? '')) === '') {
                throw new AuthenticationException('VALIDATION_FAILED', 'State the restoration condition.', 422, ['sanctions' => ['State what restores normal access.']]);
            }
            $actions[] = ['subject' => $sanction['subject'], 'action' => $sanction['action'], 'reason' => trim((string) $sanction['reason']), 'scope' => $sanction['scope'] ?? 'Marketplace activity',
                'duration_days' => isset($sanction['duration_days']) ? (int) $sanction['duration_days'] : null, 'restoration_condition' => $sanction['restoration_condition'] ?? null];
        }
        if ($metric !== null && ! in_array($metric, DisputeRules::METRIC_EVENTS, true)) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Choose a listed metric event.', 422, ['metric_event' => ['Choose a confirmed metric event.']]);
        }

        return ['actions' => $actions, 'metric_event' => is_string($metric) ? $metric : null];
    }

    private function conflictCheck(object $case, OrderActor $actor, bool $confirmed, ?object $appealed): void
    {
        if (! $confirmed) {
            throw new AuthenticationException('CONFLICT_CHECK_REQUIRED', 'Confirm the conflict-of-interest check before deciding.', 422, ['conflict_check_confirmed' => ['Confirm you have no personal or financial interest in this case.']]);
        }
        if (DisputeRules::appealReviewerConflict($appealed, $actor->userId, $actor->role)) {
            throw new AuthenticationException('CONFLICT_OF_INTEREST', 'You made the appealed decision. Another Order and Dispute Staff member or a Super Admin must review this appeal.', 409);
        }
        $buyerUser = DB::table('buyer_profiles')->where('id', $case->buyer_profile_id)->value('user_id');
        $member = DB::table('vendor_memberships')->where('vendor_organization_id', $case->vendor_organization_id)->where('user_id', $actor->userId)->exists();
        if ((int) $buyerUser === $actor->userId || $member) {
            throw new AuthenticationException('CONFLICT_OF_INTEREST', 'You are connected to a party of this case and cannot decide it.', 409);
        }
    }

    private function staleCheck(object $case, int $version): void
    {
        if ((int) $case->lock_version !== $version) {
            throw new AuthenticationException('RESOURCE_VERSION_CONFLICT', 'This case changed while you were reviewing it. Refresh and review the latest timeline before deciding.', 409);
        }
    }

    /** @param callable(object, object, OrderActor): void $action */
    private function act(Request $request, string $caseId, string $endpoint, callable $action): void
    {
        $admin = $this->access->admin($request, DisputeAccess::ADMIN_DECIDE);
        $key = $this->keys->requireIdempotencyKey($request);
        $peek = DB::table('dispute_cases')->where('id', DisputeAccess::uuid($caseId))->first();
        if ($peek === null) {
            throw new AuthenticationException('DISPUTE_NOT_FOUND', 'This case is unavailable.', 404);
        }
        DB::transaction(function () use ($request, $caseId, $endpoint, $key, $admin, $action, $peek): void {
            if ($this->keys->replayed($request, $endpoint, $key, $caseId)) {
                return;
            }
            $order = DB::table('orders')->where('id', $peek->order_id)->lockForUpdate()->first();
            $case = DB::table('dispute_cases')->where('id', $peek->id)->lockForUpdate()->first();
            $action($order, $case, DisputeAccess::adminActor($request, $admin));
            $this->keys->claim($request, $endpoint, $key, $caseId, 200);
            $this->audit->account($request, $endpoint, 'DISPUTE_CASE', (string) $case->id);
        });
    }

    public static function outcomeText(string $outcome): string
    {
        return match ($outcome) {
            'DISMISSED' => 'dismissed', 'REPLACEMENT' => 'replacement', 'FULL_REFUND' => 'full refund', 'PARTIAL_REFUND' => 'partial refund',
            'INCONCLUSIVE' => 'inconclusive, with monitoring', default => strtolower(str_replace('_', ' ', $outcome)),
        };
    }
}
