<?php

declare(strict_types=1);

namespace App\Domain\Disputes;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderAccess;
use App\Domain\Orders\OrderActor;
use App\Domain\Orders\OrderStates;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Throwable;

/**
 * Filing a structured Refund/Dispute Request. Filing creates a Case ID, the case's evidence and the dispute state —
 * never a refund, never REFUND_PENDING. The masked original payment method is shown for information only; any
 * field that tries to name a different refund destination is rejected. A transaction case may be filed from
 * PROCESSING onward and a post-completion return within seven calendar days after COMPLETED; an order with an
 * active case links the filer to that case instead of opening another.
 */
final class DisputeFilingService
{
    /** Request keys that would redirect money; the form never collects them and the API refuses them. */
    public const DESTINATION_FIELDS = ['refund_destination', 'destination', 'refund_method', 'bank_account', 'account_number', 'account_name', 'card_number', 'ewallet_number', 'wallet_number', 'gcash_number', 'payout_account'];

    public function __construct(
        private readonly OrderAccess $orders,
        private readonly DisputeAccess $access,
        private readonly CatalogAccess $keys,
        private readonly DisputeFiles $files,
        private readonly DisputeTimeline $timeline,
        private readonly DisputeOrderSync $sync,
        private readonly DisputeNotifier $notifier,
        private readonly AuditRecorder $audit,
    ) {}

    /**
     * @param  array{order_id: string, issue_type: string, requested_remedy: string, requested_amount_centavos?: int|null, description: string, affected_line_ids?: list<string>, preferred_contact_channel?: string|null}  $input
     * @param  list<UploadedFile>  $uploads
     */
    public function fileAsBuyer(Request $request, array $input, array $uploads): string
    {
        self::rejectDestination($request);
        $key = $this->keys->requireIdempotencyKey($request);
        $preview = $this->orders->buyerOrder($request, $input['order_id']);
        $stored = $this->files->store($uploads, (string) $preview->id, (int) $request->user()->getKey());
        try {
            return DB::transaction(function () use ($request, $input, $key, $stored): string {
                if ($this->keys->replayed($request, 'DISPUTE_FILE', $key, $input['order_id'])) {
                    return (string) DB::table('dispute_cases')->where('order_id', $input['order_id'])->orderByDesc('created_at')->value('id');
                }
                $order = $this->orders->buyerOrder($request, $input['order_id'], true);
                $id = $this->open($order, 'BUYER', OrderActor::buyer($request), $input, $stored);
                $this->keys->claim($request, 'DISPUTE_FILE', $key, $input['order_id'], 201);
                $this->audit->account($request, 'DISPUTE_FILED', 'DISPUTE_CASE', $id, after: ['order_id' => (string) $order->id, 'issue_type' => $input['issue_type'], 'requested_remedy' => $input['requested_remedy']]);

                return $id;
            });
        } catch (Throwable $exception) {
            $this->files->discard($stored);
            throw $exception;
        }
    }

    /**
     * @param  array{order_id: string, issue_type: string, requested_remedy: string, requested_amount_centavos?: int|null, description: string, affected_line_ids?: list<string>, preferred_contact_channel?: string|null}  $input
     * @param  list<UploadedFile>  $uploads
     */
    public function fileAsVendor(Request $request, array $input, array $uploads): string
    {
        self::rejectDestination($request);
        $scope = $this->access->vendorScope($request);
        $this->access->require($scope, DisputeAccess::RESPOND, 'Filing a case is not available to your role.');
        $key = $this->keys->requireIdempotencyKey($request);
        $orderScope = ['organization_id' => $scope['organization_id'], 'role' => $scope['role'], 'permissions' => $scope['permissions']];
        $preview = $this->orders->vendorOrder($orderScope, $input['order_id']);
        $stored = $this->files->store($uploads, (string) $preview->id, $scope['user_id']);
        try {
            return DB::transaction(function () use ($request, $scope, $orderScope, $input, $key, $stored): string {
                if ($this->keys->replayed($request, 'DISPUTE_FILE_VENDOR', $key, $input['order_id'])) {
                    return (string) DB::table('dispute_cases')->where('order_id', $input['order_id'])->orderByDesc('created_at')->value('id');
                }
                $order = $this->orders->vendorOrder($orderScope, $input['order_id'], true);
                $id = $this->open($order, 'VENDOR', OrderActor::vendor($request, $scope['role']), $input, $stored);
                $this->keys->claim($request, 'DISPUTE_FILE_VENDOR', $key, $input['order_id'], 201);
                $this->audit->account($request, 'DISPUTE_FILED', 'DISPUTE_CASE', $id, after: ['order_id' => (string) $order->id, 'issue_type' => $input['issue_type'], 'requested_remedy' => $input['requested_remedy']]);

                return $id;
            });
        } catch (Throwable $exception) {
            $this->files->discard($stored);
            throw $exception;
        }
    }

    /**
     * Eligibility and the read-only facts the filing form shows. Never includes another refund destination.
     *
     * @return array<string, mixed>
     */
    public function eligibility(object $order, string $party): array
    {
        $active = DB::table('dispute_cases')->where('order_id', $order->id)->whereIn('status', DisputeRules::ACTIVE)->first(['id', 'reference']);
        $deadline = self::postCompletionDeadline($order);
        [$available, $reason] = match (true) {
            $active !== null => [false, 'This order already has an active case ('.$active->reference.'). Add evidence or messages there instead of filing again.'],
            $order->order_state === OrderStates::CANCELLATION_REQUESTED => [false, 'A cancellation request is open on this order. Wait for its decision, then file a case if the issue remains.'],
            in_array($order->order_state, DisputeRules::FILEABLE_ORDER_STATES, true) || $order->order_state === 'DISPUTED' => [true, 'You can file a transaction case for this order.'],
            $order->order_state === OrderStates::COMPLETED && $deadline !== null && $deadline->isFuture() => [true, 'You can file a return or dispute until the seven-day post-completion deadline.'],
            $order->order_state === OrderStates::COMPLETED => [false, 'The seven-day return and dispute window after completion has ended. Non-waivable statutory rights remain; safety, fraud and abuse reports use the support channel.'],
            default => [false, 'A transaction case can be filed once the order is being prepared (Processing) or later.'],
        };
        $lines = [];
        $snapshot = DB::table('financial_snapshots')->where('order_id', $order->id)->orderByDesc('version')->value('id');
        foreach (DB::table('order_lines as l')->leftJoin('financial_snapshot_lines as s', fn ($join) => $join->on('s.order_line_id', '=', 'l.id')->where('s.financial_snapshot_id', '=', $snapshot))
            ->where('l.order_id', $order->id)->orderBy('l.line_number')->get(['l.id', 'l.snapshot', 'l.quantity', 's.ordinary_payable_centavos', 's.refund_allocated_centavos']) as $line) {
            $snap = json_decode((string) $line->snapshot, true) ?: [];
            $lines[] = ['order_line_id' => (string) $line->id, 'display_name' => (string) ($snap['display_name'] ?? 'Line'), 'variant_label' => $snap['variant_label'] ?? null,
                'quantity' => (string) $line->quantity, 'line_total_centavos' => (int) ($line->ordinary_payable_centavos ?? 0),
                'refundable_centavos' => max(0, (int) ($line->ordinary_payable_centavos ?? 0) - (int) ($line->refund_allocated_centavos ?? 0))];
        }

        return [
            'available' => $available, 'reason' => $reason, 'active_case_id' => $active === null ? null : (string) $active->id,
            'case_kind' => $order->order_state === OrderStates::COMPLETED ? 'POST_COMPLETION_RETURN' : 'TRANSACTION',
            'post_completion_deadline' => $deadline?->toIso8601String(),
            'issue_types' => DisputeRules::issuesFor($party), 'requested_remedies' => DisputeRules::remediesFor($party), 'lines' => $lines,
            'original_payment_method' => self::maskedMethod($order),
            'refund_destination_notice' => 'Any refund returns to the original payment method shown here. MateryalPH never asks for another card, e-wallet or bank account.',
            'filing_creates_refund' => false,
        ];
    }

    /**
     * @param  array{issue_type: string, requested_remedy: string, requested_amount_centavos?: int|null, description: string, affected_line_ids?: list<string>, preferred_contact_channel?: string|null}  $input
     * @param  list<string>  $fileIds
     */
    private function open(object $order, string $party, OrderActor $actor, array $input, array $fileIds): string
    {
        $eligibility = $this->eligibility($order, $party);
        if (! $eligibility['available']) {
            $code = $eligibility['active_case_id'] !== null ? 'DISPUTE_ALREADY_OPEN' : ($order->order_state === OrderStates::CANCELLATION_REQUESTED ? 'CANCELLATION_PENDING' : 'DISPUTE_NOT_AVAILABLE');
            throw new AuthenticationException($code, $eligibility['reason'], 409, $eligibility['active_case_id'] === null ? [] : ['case_id' => $eligibility['active_case_id']]);
        }
        if (! in_array($input['issue_type'], DisputeRules::issuesFor($party), true) || ! in_array($input['requested_remedy'], DisputeRules::remediesFor($party), true)) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Choose an issue type and remedy available for this case.', 422, ['issue_type' => ['Choose a listed issue type and remedy.']]);
        }
        $known = array_column($eligibility['lines'], 'order_line_id');
        $affected = array_values(array_unique(array_filter($input['affected_line_ids'] ?? [], static fn (string $id): bool => in_array($id, $known, true))));
        if ($party === 'BUYER' && $affected === []) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Select the affected lines.', 422, ['affected_line_ids' => ['Select at least one affected line.']]);
        }
        $amount = $input['requested_amount_centavos'] ?? null;
        if ($input['requested_remedy'] === 'PARTIAL_REFUND') {
            $cap = array_sum(array_map(static fn (array $line): int => in_array($line['order_line_id'], $affected, true) ? $line['refundable_centavos'] : 0, $eligibility['lines']));
            if ($amount === null || $amount <= 0 || $amount > $cap) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Enter a partial amount above zero and no more than the affected lines.', 422,
                    ['requested_amount_centavos' => ['Enter up to ₱'.number_format($cap / 100, 2).' for the selected lines.']]);
            }
        } else {
            $amount = null;
        }
        $lines = array_values(array_filter($eligibility['lines'], static fn (array $line): bool => in_array($line['order_line_id'], $affected, true)));
        $id = (string) Str::uuid7();
        $flag = (bool) DB::table('vendor_organizations')->where('id', $order->vendor_organization_id)->value('staff_disputes_enabled');
        $owner = DB::table('vendor_memberships')->where('vendor_organization_id', $order->vendor_organization_id)->where('role', 'OWNER')->where('status', 'ACTIVE')->value('user_id');
        $vendorHandler = $party === 'VENDOR' ? $actor->userId : ($flag ? null : $owner);
        DB::table('dispute_cases')->insert([
            'id' => $id, 'reference' => self::reference(), 'order_id' => $order->id, 'status' => DisputeRules::OPEN_AWAITING_RESPONSE, 'issue_type' => $input['issue_type'],
            'requested_remedy' => $input['requested_remedy'], 'response_due_at' => now()->addHours(DisputeRules::deadline('response_hours')), 'vendor_organization_id' => $order->vendor_organization_id,
            'buyer_profile_id' => $order->buyer_profile_id, 'environment' => 'TEST', 'case_kind' => $eligibility['case_kind'], 'filed_by_party' => $party, 'filed_by_user_id' => $actor->userId,
            'filed_by_role' => $actor->role, 'responding_party' => DisputeRules::otherParty($party), 'order_state_at_filing' => $order->order_state,
            'description' => mb_substr(trim($input['description']), 0, 4000), 'requested_amount_centavos' => $amount, 'affected_lines' => json_encode($lines, JSON_THROW_ON_ERROR),
            'masked_payment_method' => mb_substr((string) $eligibility['original_payment_method']['label'], 0, 120), 'preferred_contact_channel' => $input['preferred_contact_channel'] ?? 'IN_APP',
            'vendor_handler_user_id' => $vendorHandler, 'vendor_handler_role' => $vendorHandler === null ? null : ($party === 'VENDOR' ? $actor->role : 'OWNER'),
            'created_at' => now(), 'updated_at' => now(),
        ]);
        DB::table('dispute_parties')->insert([
            ['id' => (string) Str::uuid7(), 'dispute_case_id' => $id, 'actor_user_id' => null, 'state' => $party === 'BUYER' ? 'FILER' : 'RESPONDENT', 'payload' => null, 'party' => 'BUYER',
                'buyer_profile_id' => $order->buyer_profile_id, 'vendor_organization_id' => null, 'created_at' => now(), 'updated_at' => now()],
            ['id' => (string) Str::uuid7(), 'dispute_case_id' => $id, 'actor_user_id' => null, 'state' => $party === 'VENDOR' ? 'FILER' : 'RESPONDENT', 'payload' => null, 'party' => 'VENDOR',
                'buyer_profile_id' => null, 'vendor_organization_id' => $order->vendor_organization_id, 'created_at' => now(), 'updated_at' => now()],
        ]);
        $case = DB::table('dispute_cases')->where('id', $id)->lockForUpdate()->first();
        $event = $this->timeline->append($case, 'CASE_FILED', $actor, $party, (string) $case->description, ['issue_type' => $input['issue_type'], 'requested_remedy' => $input['requested_remedy'],
            'requested_amount_centavos' => $amount, 'affected_line_ids' => $affected, 'case_kind' => $eligibility['case_kind']]);
        $this->timeline->evidence($case, $event, $party, $actor, 'ORIGINAL', $fileIds);
        $this->sync->opened($order, $case, $actor);
        $due = CarbonImmutable::parse((string) $case->response_due_at)->setTimezone(DisputeRules::TIMEZONE)->format('M j, Y g:i A');
        if ($party === 'BUYER') {
            $this->notifier->vendor($case, 'New case '.$case->reference.' on order '.$order->reference, 'The Buyer filed a case ('.strtolower(str_replace('_', ' ', $input['issue_type'])).'). Respond by '.$due.' (Asia/Manila) or it escalates to Admin review.');
            $this->notifier->buyer($case, 'Case '.$case->reference.' filed', 'Your case was filed. The Vendor has until '.$due.' (Asia/Manila) to respond. Filing does not start a refund; a refund is created only if the case concludes with one.');
        } else {
            $this->notifier->buyer($case, 'The Vendor filed case '.$case->reference, 'The Vendor filed a case on order '.$order->reference.'. Respond by '.$due.' (Asia/Manila) or it escalates to Admin review.');
            $this->notifier->vendor($case, 'Case '.$case->reference.' filed', 'Your case was filed. The Buyer has until '.$due.' (Asia/Manila) to respond.');
        }

        return $id;
    }

    /** @return array{label: string, channel: ?string, physical: bool} */
    public static function maskedMethod(object $order): array
    {
        $payment = DB::table('payments as p')->leftJoin('payment_channel_fee_versions as v', 'v.id', '=', 'p.channel_fee_version_id')->where('p.order_id', $order->id)->where('p.state', 'PAID')
            ->whereIn('p.purpose', ['FULL_ORDER_PAYMENT', 'NRPC_ASSURANCE_PAYMENT', 'ORDER_BALANCE_PAYMENT'])->orderBy('p.paid_at')->first(['v.display_name', 'p.channel_code']);
        if ($payment !== null) {
            return ['label' => ($payment->display_name ?? 'Online payment').' — original payment method', 'channel' => $payment->channel_code, 'physical' => $order->payment_method !== 'ONLINE'];
        }

        return ['label' => $order->payment_method === 'COD' ? 'Cash on Delivery — paid to the Vendor directly' : ($order->payment_method === 'IN_STORE' ? 'In-Store Payment — paid to the Vendor directly' : 'No captured online payment'),
            'channel' => null, 'physical' => $order->payment_method !== 'ONLINE'];
    }

    public static function postCompletionDeadline(object $order): ?CarbonImmutable
    {
        return $order->order_state === OrderStates::COMPLETED && $order->closed_at !== null ? CarbonImmutable::parse((string) $order->closed_at)->addDays(DisputeRules::deadline('post_completion_filing_days')) : null;
    }

    public static function rejectDestination(Request $request): void
    {
        foreach (self::DESTINATION_FIELDS as $field) {
            if ($request->has($field)) {
                throw new AuthenticationException('REFUND_DESTINATION_NOT_ACCEPTED', 'Refunds return only to the original payment method. MateryalPH never collects a different refund destination.', 422, [$field => ['This field is not accepted.']]);
            }
        }
    }

    private static function reference(): string
    {
        return 'CASE-'.CarbonImmutable::now(DisputeRules::TIMEZONE)->format('ymd').'-'.Str::upper(Str::random(6));
    }
}
