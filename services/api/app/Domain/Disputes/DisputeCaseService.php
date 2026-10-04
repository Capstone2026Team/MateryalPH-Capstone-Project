<?php

declare(strict_types=1);

namespace App\Domain\Disputes;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderActor;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Throwable;

/**
 * Buyer and Vendor actions on a case, each in one transaction that locks the order and then the case:
 *
 *   respond         the responding party answers within 48 hours; a response opens 72 hours of mutual resolution,
 *                   a request for Admin review escalates at once
 *   propose/answer  either party proposes a remedy; the other party's acceptance is the recorded agreement, which
 *                   executes like a final decision (a Vendor refund offer or acceptance is Owner-only — the
 *                   voluntary financial refund authority)
 *   escalate        either party may ask for Admin review during mutual resolution
 *   evidence        labeled supplemental evidence and case messages; the original complaint is never edited
 *   clarification   the requested party answers within 24 hours
 *   appeal          one appeal per case within five business days, with new evidence or a material process error
 *   replacement     the Vendor records the replacement; the Buyer confirms receipt
 *
 * Store Staff and Customer Service act only while the Owner's staff dispute flag is on; Fulfillment Staff only add
 * fulfillment evidence to an assigned order's case.
 */
final class DisputeCaseService
{
    public function __construct(
        private readonly DisputeAccess $access,
        private readonly CatalogAccess $keys,
        private readonly DisputeFiles $files,
        private readonly DisputeTimeline $timeline,
        private readonly DisputeOrderSync $sync,
        private readonly DisputeRemedyService $remedies,
        private readonly DisputeRefundPlanner $planner,
        private readonly DisputeNotifier $notifier,
        private readonly AuditRecorder $audit,
    ) {}

    /**
     * @param  array{position: string, body: string, amount_centavos?: int|null}  $input
     * @param  list<UploadedFile>  $uploads
     */
    public function respond(Request $request, string $party, string $caseId, array $input, array $uploads): void
    {
        $this->act($request, $party, $caseId, 'DISPUTE_RESPOND', $uploads, function (object $order, object $case, OrderActor $actor, array $scope, array $fileIds) use ($party, $input): void {
            if ($case->responding_party !== $party) {
                throw new AuthenticationException('DISPUTE_ACTION_NOT_ALLOWED', 'Only the other party responds to this case.', 403);
            }
            if ($case->status !== DisputeRules::OPEN_AWAITING_RESPONSE) {
                throw new AuthenticationException('DISPUTE_STATE_CONFLICT', 'This case is no longer waiting for a response.', 409, ['status' => $case->status]);
            }
            if (CarbonImmutable::parse((string) $case->response_due_at)->isPast()) {
                // The scheduled sweep escalates it; a late response is refused rather than silently accepted.
                throw new AuthenticationException('RESPONSE_WINDOW_CLOSED', 'The 48-hour response window has ended and the case goes to Admin review. You can still add evidence.', 409);
            }
            if (! in_array($input['position'], DisputeRules::RESPONSE_POSITIONS, true)) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Choose a response.', 422, ['position' => ['Choose a listed response.']]);
            }
            $proposal = $this->responseProposal($case, $input);
            if ($party === 'VENDOR' && $proposal !== null && in_array($proposal['remedy'], ['FULL_REFUND', 'PARTIAL_REFUND'], true)) {
                $this->access->require($scope, DisputeAccess::REFUND_OFFER, 'Only the store Owner can offer or accept a voluntary refund. Offer a replacement or ask the Owner.');
            }
            if ($input['position'] === 'REJECT_WITH_EVIDENCE' && $fileIds === []) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Attach the evidence for a rejection.', 422, ['files' => ['Attach at least one file.']]);
            }
            $event = $this->timeline->append($case, 'RESPONSE_SUBMITTED', $actor, $party, $input['body'], ['position' => $input['position']]);
            DB::table('dispute_responses')->insert(['id' => (string) Str::uuid7(), 'dispute_case_id' => $case->id, 'actor_user_id' => $actor->userId, 'state' => 'SUBMITTED',
                'payload' => json_encode(['amount_centavos' => $input['amount_centavos'] ?? null], JSON_THROW_ON_ERROR), 'party' => $party, 'actor_role' => $actor->role,
                'position' => $input['position'], 'body' => mb_substr(trim($input['body']), 0, 4000), 'dispute_event_id' => $event, 'created_at' => now(), 'updated_at' => now()]);
            $this->timeline->evidence($case, $event, $party, $actor, 'RESPONSE', $fileIds);
            $this->claimHandler($case, $party, $actor);
            if ($input['position'] === 'REQUEST_ADMIN_REVIEW') {
                DB::table('dispute_cases')->where('id', $case->id)->update(['responded_at' => now(), 'updated_at' => now()]);
                $this->escalateCase($order, DB::table('dispute_cases')->where('id', $case->id)->first(), $actor, 'RESPONDENT_REQUEST', 'The responding party asked for Admin review.');

                return;
            }
            $due = now()->addHours(DisputeRules::MUTUAL_RESOLUTION_HOURS);
            DB::table('dispute_cases')->where('id', $case->id)->update(['status' => DisputeRules::MUTUAL_RESOLUTION, 'responded_at' => now(), 'mutual_resolution_due_at' => $due,
                'lock_version' => (int) $case->lock_version + 1, 'updated_at' => now()]);
            $case = DB::table('dispute_cases')->where('id', $case->id)->first();
            $this->sync->mirror($order, DisputeRules::MUTUAL_RESOLUTION, $actor, 'DISPUTE_RESPONDED');
            if ($proposal !== null) {
                $this->insertProposal($case, $party, $actor, $proposal['remedy'], $proposal['amount'], $proposal['terms']);
            }
            $when = $due->setTimezone(DisputeRules::TIMEZONE)->format('M j, Y g:i A');
            $other = DisputeRules::otherParty($party);
            $text = 'A response was submitted on case '.$case->reference.'. The parties have until '.$when.' (Asia/Manila) to agree; otherwise the case goes to Admin review.';
            $other === 'BUYER' ? $this->notifier->buyer($case, 'Response on case '.$case->reference, $text) : $this->notifier->vendor($case, 'Response on case '.$case->reference, $text);
        });
    }

    /** @param array{remedy: string, amount_centavos?: int|null, terms: string} $input */
    public function propose(Request $request, string $party, string $caseId, array $input): void
    {
        $this->act($request, $party, $caseId, 'DISPUTE_PROPOSE', [], function (object $order, object $case, OrderActor $actor, array $scope) use ($party, $input): void {
            $this->requireMutualWindow($order, $case, $actor);
            if (! in_array($input['remedy'], DisputeRules::PROPOSAL_REMEDIES, true)) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Choose a remedy to propose.', 422, ['remedy' => ['Choose a listed remedy.']]);
            }
            if ($party === 'VENDOR' && in_array($input['remedy'], ['FULL_REFUND', 'PARTIAL_REFUND'], true)) {
                $this->access->require($scope, DisputeAccess::REFUND_OFFER, 'Only the store Owner can offer a voluntary refund.');
            }
            $amount = $input['remedy'] === 'PARTIAL_REFUND' ? (int) ($input['amount_centavos'] ?? 0) : null;
            $this->validateAward($order, $case, $input['remedy'], $amount);
            DB::table('dispute_resolution_proposals')->where('dispute_case_id', $case->id)->where('proposed_by_party', $party)->where('state', 'PROPOSED')
                ->update(['state' => 'SUPERSEDED', 'updated_at' => now()]);
            $this->insertProposal($case, $party, $actor, $input['remedy'], $amount, $input['terms']);
            $this->claimHandler($case, $party, $actor);
            $text = 'A resolution was proposed on case '.$case->reference.'. Review and accept or reject it before the mutual-resolution deadline.';
            $party === 'BUYER' ? $this->notifier->vendor($case, 'Resolution proposed — case '.$case->reference, $text) : $this->notifier->buyer($case, 'Resolution proposed — case '.$case->reference, $text);
        });
    }

    public function answerProposal(Request $request, string $party, string $caseId, string $proposalId, bool $accept): void
    {
        $this->act($request, $party, $caseId, $accept ? 'DISPUTE_PROPOSAL_ACCEPT' : 'DISPUTE_PROPOSAL_REJECT', [], function (object $order, object $case, OrderActor $actor, array $scope) use ($party, $proposalId, $accept): void {
            $this->requireMutualWindow($order, $case, $actor);
            $proposal = DB::table('dispute_resolution_proposals')->where('id', DisputeAccess::uuid($proposalId))->where('dispute_case_id', $case->id)->lockForUpdate()->first();
            if ($proposal === null || $proposal->state !== 'PROPOSED') {
                throw new AuthenticationException('PROPOSAL_NOT_OPEN', 'This proposal is no longer open.', 409);
            }
            if ($proposal->proposed_by_party === $party) {
                throw new AuthenticationException('DISPUTE_ACTION_NOT_ALLOWED', 'The other party answers your proposal.', 403);
            }
            if ($accept && $party === 'VENDOR' && in_array($proposal->remedy, ['FULL_REFUND', 'PARTIAL_REFUND'], true)) {
                $this->access->require($scope, DisputeAccess::REFUND_OFFER, 'Only the store Owner can accept a refund agreement.');
            }
            DB::table('dispute_resolution_proposals')->where('id', $proposal->id)->update(['state' => $accept ? 'ACCEPTED' : 'REJECTED', 'answered_by_user_id' => $actor->userId,
                'answered_by_role' => $actor->role, 'answered_at' => now(), 'lock_version' => (int) $proposal->lock_version + 1, 'updated_at' => now()]);
            $this->timeline->append($case, $accept ? 'PROPOSAL_ACCEPTED' : 'PROPOSAL_REJECTED', $actor, $party, null, ['proposal_id' => (string) $proposal->id, 'remedy' => (string) $proposal->remedy]);
            $this->claimHandler($case, $party, $actor);
            if (! $accept) {
                $text = 'The proposal on case '.$case->reference.' was rejected. You can propose another remedy or ask for Admin review.';
                $party === 'BUYER' ? $this->notifier->vendor($case, 'Proposal rejected — case '.$case->reference, $text) : $this->notifier->buyer($case, 'Proposal rejected — case '.$case->reference, $text);

                return;
            }
            $this->agree($order, $case, $proposal, $actor, $party);
        });
    }

    public function escalate(Request $request, string $party, string $caseId, string $reason): void
    {
        $this->act($request, $party, $caseId, 'DISPUTE_ESCALATE', [], function (object $order, object $case, OrderActor $actor) use ($party, $reason): void {
            $allowed = $case->status === DisputeRules::MUTUAL_RESOLUTION || ($case->status === DisputeRules::OPEN_AWAITING_RESPONSE && $case->responding_party === $party);
            if (! $allowed || $case->agreement_reached_at !== null) {
                throw new AuthenticationException('DISPUTE_STATE_CONFLICT', 'Admin review can be requested while the parties are responding or trying to agree.', 409, ['status' => $case->status]);
            }
            $this->claimHandler($case, $party, $actor);
            $this->escalateCase($order, $case, $actor, 'PARTY_REQUEST', $reason);
        });
    }

    /** @param list<UploadedFile> $uploads */
    public function addEvidence(Request $request, string $party, string $caseId, ?string $description, array $uploads): void
    {
        if ($uploads === []) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Attach at least one file.', 422, ['files' => ['Attach at least one file.']]);
        }
        $this->act($request, $party, $caseId, 'DISPUTE_EVIDENCE', $uploads, function (object $order, object $case, OrderActor $actor, array $scope, array $fileIds) use ($party, $description): void {
            $this->requireActive($case);
            $fulfillment = $party === 'VENDOR' && $scope['role'] === 'FULFILLMENT';
            $event = $this->timeline->append($case, 'EVIDENCE_ADDED', $actor, $party, $description, ['label' => $fulfillment ? 'FULFILLMENT' : 'SUPPLEMENTAL', 'files' => count($fileIds)]);
            $this->timeline->evidence($case, $event, $party, $actor, $fulfillment ? 'FULFILLMENT' : 'SUPPLEMENTAL', $fileIds, $description);
        }, true);
    }

    public function message(Request $request, string $party, string $caseId, string $body): void
    {
        $this->act($request, $party, $caseId, 'DISPUTE_MESSAGE', [], function (object $order, object $case, OrderActor $actor) use ($party, $body): void {
            $this->requireActive($case);
            $this->timeline->append($case, 'MESSAGE', $actor, $party, $body);
            $this->claimHandler($case, $party, $actor);
            $text = 'New message on case '.$case->reference.'.';
            $party === 'BUYER' ? $this->notifier->vendor($case, $text, 'Open the case to read and reply.') : $this->notifier->buyer($case, $text, 'Open the case to read and reply.');
        });
    }

    /** @param list<UploadedFile> $uploads */
    public function answerClarification(Request $request, string $party, string $caseId, string $clarificationId, string $response, array $uploads): void
    {
        $this->act($request, $party, $caseId, 'DISPUTE_CLARIFY', $uploads, function (object $order, object $case, OrderActor $actor, array $scope, array $fileIds) use ($party, $clarificationId, $response): void {
            $row = DB::table('dispute_clarifications')->where('id', DisputeAccess::uuid($clarificationId))->where('dispute_case_id', $case->id)->lockForUpdate()->first();
            if ($row === null || $row->requested_party !== $party) {
                throw new AuthenticationException('CLARIFICATION_NOT_FOUND', 'This clarification request is unavailable.', 404);
            }
            if ($row->state !== 'OPEN' || CarbonImmutable::parse((string) $row->due_at)->isPast()) {
                throw new AuthenticationException('CLARIFICATION_CLOSED', 'This clarification request is closed. You can still add supplemental evidence.', 409);
            }
            DB::table('dispute_clarifications')->where('id', $row->id)->update(['state' => 'ANSWERED', 'response' => mb_substr(trim($response), 0, 4000), 'responded_by_user_id' => $actor->userId,
                'responded_role' => $actor->role, 'responded_at' => now(), 'lock_version' => (int) $row->lock_version + 1, 'updated_at' => now()]);
            $event = $this->timeline->append($case, 'CLARIFICATION_ANSWERED', $actor, $party, $response, ['clarification_id' => (string) $row->id]);
            $this->timeline->evidence($case, $event, $party, $actor, 'CLARIFICATION', $fileIds);
            $this->claimHandler($case, $party, $actor);
            $this->returnToReviewWhenAnswered($order, $case, $actor);
            $this->notifier->admin($case, 'Clarification answered — case '.$case->reference, 'A party answered your clarification request.');
        });
    }

    /** @param list<UploadedFile> $uploads */
    public function appeal(Request $request, string $party, string $caseId, string $grounds, string $statement, array $uploads): void
    {
        $this->act($request, $party, $caseId, 'DISPUTE_APPEAL', $uploads, function (object $order, object $case, OrderActor $actor, array $scope, array $fileIds) use ($party, $grounds, $statement): void {
            $decision = $case->current_decision_id === null ? null : DB::table('dispute_decisions')->where('id', $case->current_decision_id)->first();
            if ($case->status !== DisputeRules::DECIDED || $decision === null || $decision->kind !== 'ADMIN_DECISION') {
                throw new AuthenticationException('APPEAL_NOT_AVAILABLE', 'An appeal is available only against an Admin decision.', 409);
            }
            if (DB::table('dispute_appeals')->where('dispute_case_id', $case->id)->exists()) {
                throw new AuthenticationException('APPEAL_ALREADY_FILED', 'This case already used its one appeal.', 409);
            }
            if ($case->appeal_due_at === null || CarbonImmutable::parse((string) $case->appeal_due_at)->isPast()) {
                throw new AuthenticationException('APPEAL_WINDOW_CLOSED', 'The five-business-day appeal window has ended.', 409);
            }
            if (! in_array($grounds, DisputeRules::APPEAL_GROUNDS, true)) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Choose the grounds for the appeal.', 422, ['grounds' => ['Choose new evidence or a material process error.']]);
            }
            if ($grounds === 'NEW_EVIDENCE' && $fileIds === []) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Attach the new evidence.', 422, ['files' => ['Attach the new, relevant evidence.']]);
            }
            $event = $this->timeline->append($case, 'APPEAL_FILED', $actor, $party, $statement, ['grounds' => $grounds, 'decision_id' => (string) $decision->id, 'decision_version' => (int) $decision->version]);
            $this->timeline->evidence($case, $event, $party, $actor, 'APPEAL', $fileIds);
            DB::table('dispute_appeals')->insert(['id' => (string) Str::uuid7(), 'dispute_case_id' => $case->id, 'actor_user_id' => $actor->userId, 'state' => 'OPEN', 'payload' => null,
                'appealed_decision_id' => $decision->id, 'appellant_party' => $party, 'appellant_role' => $actor->role, 'grounds' => $grounds,
                'statement' => mb_substr(trim($statement), 0, 4000), 'created_at' => now(), 'updated_at' => now()]);
            DB::table('dispute_cases')->where('id', $case->id)->update(['status' => DisputeRules::APPEAL_OPEN, 'lock_version' => (int) $case->lock_version + 1, 'updated_at' => now()]);
            $this->sync->mirror($order, DisputeRules::APPEAL_OPEN, $actor, 'DISPUTE_APPEALED');
            $text = 'An appeal was filed on case '.$case->reference.'. The original decision stays on record while a reviewer who did not make it reviews the appeal.';
            $this->notifier->buyer($case, 'Appeal filed — case '.$case->reference, $text);
            $this->notifier->vendor($case, 'Appeal filed — case '.$case->reference, $text);
        });
    }

    /** @param list<UploadedFile> $uploads */
    public function recordReplacement(Request $request, string $caseId, string $remedyId, string $note, array $uploads): void
    {
        $this->act($request, 'VENDOR', $caseId, 'DISPUTE_REPLACEMENT_RECORD', $uploads, function (object $order, object $case, OrderActor $actor, array $scope, array $fileIds) use ($remedyId, $note): void {
            $remedy = $this->pendingRemedy($case, $remedyId, 'REPLACEMENT');
            if ($remedy->recorded_by_user_id !== null) {
                throw new AuthenticationException('REMEDY_ALREADY_RECORDED', 'The replacement is already recorded and waiting for the Buyer.', 409);
            }
            DB::table('dispute_remedies')->where('id', $remedy->id)->update(['note' => mb_substr(trim($note), 0, 500), 'evidence_file_id' => $fileIds[0] ?? null, 'recorded_by_user_id' => $actor->userId,
                'recorded_role' => $actor->role, 'lock_version' => (int) $remedy->lock_version + 1, 'updated_at' => now()]);
            $event = $this->timeline->append($case, 'REMEDY_UPDATED', $actor, 'VENDOR', $note, ['remedy_id' => (string) $remedy->id, 'kind' => 'REPLACEMENT']);
            $this->timeline->evidence($case, $event, 'VENDOR', $actor, 'REMEDY', $fileIds);
            $this->notifier->buyer($case, 'Replacement recorded — case '.$case->reference, 'The Vendor recorded the replacement. Confirm on the case once you have received it.');
        });
    }

    public function confirmReplacement(Request $request, string $caseId, string $remedyId): void
    {
        $this->act($request, 'BUYER', $caseId, 'DISPUTE_REPLACEMENT_CONFIRM', [], function (object $order, object $case, OrderActor $actor) use ($remedyId): void {
            $remedy = $this->pendingRemedy($case, $remedyId, 'REPLACEMENT');
            if ($remedy->recorded_by_user_id === null) {
                throw new AuthenticationException('REMEDY_NOT_READY', 'You can confirm after the Vendor records the replacement.', 409);
            }
            DB::table('dispute_remedies')->where('id', $remedy->id)->update(['state' => 'COMPLETED', 'completed_at' => now(), 'lock_version' => (int) $remedy->lock_version + 1, 'updated_at' => now()]);
            $this->timeline->append($case, 'REMEDY_COMPLETED', $actor, 'BUYER', 'The Buyer confirmed receiving the replacement.', ['remedy_id' => (string) $remedy->id, 'kind' => 'REPLACEMENT']);
            $this->remedies->evaluate($order, $this->remedies->refreshRemedyState(DB::table('dispute_cases')->where('id', $case->id)->first()), $actor);
            $this->notifier->vendor($case, 'Replacement confirmed — case '.$case->reference, 'The Buyer confirmed receiving the replacement.');
        });
    }

    /**
     * Escalates a locked case to Admin review and mirrors the order. Shared with the sweep and Admin actions.
     */
    public function escalateCase(object $order, object $case, OrderActor $actor, string $reasonCode, string $reason): void
    {
        DB::table('dispute_resolution_proposals')->where('dispute_case_id', $case->id)->where('state', 'PROPOSED')->update(['state' => 'EXPIRED', 'updated_at' => now()]);
        DB::table('dispute_cases')->where('id', $case->id)->update(['status' => DisputeRules::ESCALATED_ADMIN_REVIEW, 'escalated_at' => now(), 'escalation_reason' => $reasonCode,
            'mutual_resolution_due_at' => null, 'lock_version' => (int) $case->lock_version + 1, 'updated_at' => now()]);
        $this->sync->mirror($order, DisputeRules::ESCALATED_ADMIN_REVIEW, $actor, 'DISPUTE_ESCALATED');
        $case = DB::table('dispute_cases')->where('id', $case->id)->first();
        $this->timeline->append($case, 'ESCALATED', $actor, DisputeRemedyService::party($actor), $reason, ['reason_code' => $reasonCode]);
        $text = 'Case '.$case->reference.' is now with MateryalPH Admin review. You may be asked for clarification; keep adding evidence on the case.';
        $this->notifier->buyer($case, 'Case '.$case->reference.' escalated', $text);
        $this->notifier->vendor($case, 'Case '.$case->reference.' escalated', $text);
    }

    /** Back to Admin review once no clarification of the round is still open. The caller holds the locks. */
    public function returnToReviewWhenAnswered(object $order, object $case, OrderActor $actor): void
    {
        if ($case->status !== DisputeRules::AWAITING_CLARIFICATION || DB::table('dispute_clarifications')->where('dispute_case_id', $case->id)->where('state', 'OPEN')->exists()) {
            return;
        }
        DB::table('dispute_cases')->where('id', $case->id)->update(['status' => DisputeRules::ESCALATED_ADMIN_REVIEW, 'clarification_due_at' => null, 'updated_at' => now()]);
        $this->sync->mirror($order, DisputeRules::ESCALATED_ADMIN_REVIEW, $actor, 'DISPUTE_CLARIFIED');
    }

    /**
     * Locks the order, then the case, authorizes the party and runs one idempotent action.
     *
     * @param  list<UploadedFile>  $uploads
     * @param  callable(object, object, OrderActor, array{organization_id?: string, role: string, permissions: list<string>, user_id: int}, list<string>): void  $action
     */
    private function act(Request $request, string $party, string $caseId, string $endpoint, array $uploads, callable $action, bool $allowFulfillmentEvidence = false): void
    {
        $key = $this->keys->requireIdempotencyKey($request);
        if ($party === 'BUYER') {
            $peek = $this->access->buyerCase($request, $caseId);
            $scope = ['role' => 'BUYER', 'permissions' => [], 'user_id' => (int) $request->user()->getKey()];
        } else {
            $scope = $this->access->vendorScope($request, $allowFulfillmentEvidence);
            if (! DisputeAccess::allows($scope, DisputeAccess::RESPOND) && ! ($allowFulfillmentEvidence && DisputeAccess::allows($scope, DisputeAccess::FULFILLMENT_EVIDENCE))) {
                throw new AuthenticationException('PERMISSION_DENIED', 'Case actions are not available to your role.', 403);
            }
            $peek = $this->access->vendorCase($scope, $caseId);
        }
        $stored = $this->files->store($uploads, (string) $peek->order_id, (int) $request->user()->getKey());
        try {
            DB::transaction(function () use ($request, $party, $caseId, $endpoint, $key, $scope, $stored, $action, $peek): void {
                if ($this->keys->replayed($request, $endpoint, $key, $caseId)) {
                    return;
                }
                $order = DB::table('orders')->where('id', $peek->order_id)->lockForUpdate()->first();
                $case = $party === 'BUYER' ? $this->access->buyerCase($request, $caseId, true) : $this->access->vendorCase($scope, $caseId, true);
                $actor = $party === 'BUYER' ? OrderActor::buyer($request) : OrderActor::vendor($request, $scope['role']);
                $action($order, $case, $actor, $scope, $stored);
                $this->keys->claim($request, $endpoint, $key, $caseId, 200);
                $this->audit->account($request, $endpoint, 'DISPUTE_CASE', (string) $case->id, after: ['party' => $party]);
            });
        } catch (Throwable $exception) {
            $this->files->discard($stored);
            throw $exception;
        }
    }

    private function agree(object $order, object $case, object $proposal, OrderActor $actor, string $party): void
    {
        $version = (int) DB::table('dispute_decisions')->where('dispute_case_id', $case->id)->max('version') + 1;
        $outcome = $proposal->remedy;
        $amount = $outcome === 'PARTIAL_REFUND' ? (int) $proposal->amount_centavos : 0;
        $affected = array_column(json_decode((string) ($case->affected_lines ?? '[]'), true) ?: [], 'order_line_id');
        if ($outcome === 'FULL_REFUND') {
            $amount = (int) $this->planner->plan($order, $case, 'FULL_REFUND', null, $affected)['awarded_centavos'];
        }
        $decisionId = (string) Str::uuid7();
        DB::table('dispute_decisions')->insert(['id' => $decisionId, 'dispute_case_id' => $case->id, 'actor_user_id' => $actor->userId, 'state' => 'FINAL', 'payload' => null,
            'awarded_centavos' => $amount, 'enforceable' => true, 'version' => $version, 'kind' => 'MUTUAL_AGREEMENT', 'outcome' => $outcome, 'reason' => (string) $proposal->terms,
            'actor_role' => $actor->role, 'allocation' => json_encode(['affected_line_ids' => $affected], JSON_THROW_ON_ERROR), 'conflict_check_confirmed' => false,
            'dispute_proposal_id' => $proposal->id, 'correlation_id' => mb_substr($actor->correlationId, 0, 64), 'created_at' => now(), 'updated_at' => now()]);
        DB::table('dispute_cases')->where('id', $case->id)->update(['agreement_reached_at' => now(), 'mutual_resolution_due_at' => null, 'current_decision_id' => $decisionId,
            'lock_version' => (int) $case->lock_version + 1, 'updated_at' => now()]);
        DB::table('dispute_resolution_proposals')->where('dispute_case_id', $case->id)->where('state', 'PROPOSED')->update(['state' => 'SUPERSEDED', 'updated_at' => now()]);
        $case = DB::table('dispute_cases')->where('id', $case->id)->first();
        $this->timeline->append($case, 'AGREEMENT_RECORDED', $actor, $party, 'Both parties accepted: '.$proposal->terms, ['decision_id' => $decisionId, 'version' => $version, 'outcome' => $outcome, 'awarded_centavos' => $amount]);
        $text = 'Both parties agreed on case '.$case->reference.'. The agreed remedy is now carried out; the case resolves once it is complete.';
        $this->notifier->buyer($case, 'Agreement recorded — case '.$case->reference, $text);
        $this->notifier->vendor($case, 'Agreement recorded — case '.$case->reference, $text);
        $this->remedies->execute($order, $case, DB::table('dispute_decisions')->where('id', $decisionId)->first(), $actor);
    }

    /**
     * @param  array{position: string, body: string, amount_centavos?: int|null}  $input
     * @return array{remedy: string, amount: ?int, terms: string}|null
     */
    private function responseProposal(object $case, array $input): ?array
    {
        return match ($input['position']) {
            'OFFER_REPLACEMENT' => ['remedy' => 'REPLACEMENT', 'amount' => null, 'terms' => $input['body']],
            'OFFER_REFUND' => ['remedy' => ($input['amount_centavos'] ?? null) === null ? 'FULL_REFUND' : 'PARTIAL_REFUND', 'amount' => $input['amount_centavos'] ?? null, 'terms' => $input['body']],
            'ACCEPT_REQUEST' => match ($case->requested_remedy) {
                'REPLACEMENT' => ['remedy' => 'REPLACEMENT', 'amount' => null, 'terms' => $input['body']],
                'FULL_REFUND', 'RETURN_AND_REFUND' => ['remedy' => 'FULL_REFUND', 'amount' => null, 'terms' => $input['body']],
                'PARTIAL_REFUND' => ['remedy' => 'PARTIAL_REFUND', 'amount' => (int) $case->requested_amount_centavos, 'terms' => $input['body']],
                default => ['remedy' => 'NO_FURTHER_ACTION', 'amount' => null, 'terms' => $input['body']],
            },
            default => null,
        };
    }

    private function insertProposal(object $case, string $party, OrderActor $actor, string $remedy, ?int $amount, string $terms): void
    {
        $id = (string) Str::uuid7();
        DB::table('dispute_resolution_proposals')->insert(['id' => $id, 'dispute_case_id' => $case->id, 'proposed_by_party' => $party, 'proposed_by_user_id' => $actor->userId,
            'proposed_by_role' => $actor->role, 'remedy' => $remedy, 'amount_centavos' => $remedy === 'PARTIAL_REFUND' ? $amount : null, 'terms' => mb_substr(trim($terms), 0, 2000),
            'state' => 'PROPOSED', 'created_at' => now(), 'updated_at' => now()]);
        $this->timeline->append($case, 'PROPOSAL_MADE', $actor, $party, $terms, ['proposal_id' => $id, 'remedy' => $remedy, 'amount_centavos' => $remedy === 'PARTIAL_REFUND' ? $amount : null]);
    }

    private function validateAward(object $order, object $case, string $remedy, ?int $amount): void
    {
        if (! in_array($remedy, ['FULL_REFUND', 'PARTIAL_REFUND'], true)) {
            return;
        }
        $affected = array_column(json_decode((string) ($case->affected_lines ?? '[]'), true) ?: [], 'order_line_id');
        $this->planner->plan($order, $case, $remedy, $amount, $affected);
    }

    private function requireMutualWindow(object $order, object $case, OrderActor $actor): void
    {
        if ($case->status !== DisputeRules::MUTUAL_RESOLUTION || $case->agreement_reached_at !== null) {
            throw new AuthenticationException('DISPUTE_STATE_CONFLICT', 'Proposals are available only during mutual resolution.', 409, ['status' => $case->status]);
        }
        if ($case->mutual_resolution_due_at !== null && CarbonImmutable::parse((string) $case->mutual_resolution_due_at)->isPast()) {
            throw new AuthenticationException('MUTUAL_RESOLUTION_CLOSED', 'The 72-hour mutual-resolution period has ended and the case goes to Admin review.', 409);
        }
    }

    private function requireActive(object $case): void
    {
        if (! in_array($case->status, DisputeRules::ACTIVE, true)) {
            throw new AuthenticationException('DISPUTE_CONCLUDED', 'This case has concluded and is read-only.', 409);
        }
    }

    private function pendingRemedy(object $case, string $remedyId, string $kind): object
    {
        $remedy = DB::table('dispute_remedies')->where('id', DisputeAccess::uuid($remedyId))->where('dispute_case_id', $case->id)->where('kind', $kind)->lockForUpdate()->first();
        if ($remedy === null) {
            throw new AuthenticationException('REMEDY_NOT_FOUND', 'This remedy is unavailable.', 404);
        }
        if ($remedy->state !== 'PENDING') {
            throw new AuthenticationException('REMEDY_NOT_PENDING', 'This remedy is already complete.', 409);
        }

        return $remedy;
    }

    /** The first Vendor user to act becomes the case handler; prior attribution is never rewritten. */
    private function claimHandler(object $case, string $party, OrderActor $actor): void
    {
        if ($party !== 'VENDOR' || $case->vendor_handler_user_id !== null || $actor->role === 'FULFILLMENT') {
            return;
        }
        DB::table('dispute_cases')->where('id', $case->id)->whereNull('vendor_handler_user_id')->update(['vendor_handler_user_id' => $actor->userId, 'vendor_handler_role' => $actor->role, 'updated_at' => now()]);
        $this->timeline->append($case, 'HANDLER_ASSIGNED', $actor, 'VENDOR', null, ['role' => $actor->role]);
    }
}
