<?php

declare(strict_types=1);

namespace App\Domain\Projects;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Finance\Money;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Messaging\ConversationService;
use App\Domain\Messaging\QuotationService;
use App\Domain\Orders\OrderActor;
use App\Domain\Orders\OrderCommercial;
use App\Domain\Orders\OrderNotifier;
use App\Domain\Orders\OrderTransitionService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class ProjectInquiryService
{
    public function __construct(private readonly ProjectService $projects, private readonly ProjectEstimateService $estimates, private readonly CatalogAccess $keys) {}

    /** @param array<string, mixed> $snapshot
     * @return array<string, mixed> */
    public static function duplicate(array $snapshot): array
    {
        $lines = [];
        foreach (self::aggregateLines($snapshot['lines']) as $l) {
            if ($l['variant_id'] === null || bccomp($l['matched_quantity'], '0', 4) <= 0) {
                continue;
            }
            if (isset($lines[$l['variant_id']])) {
                $lines[$l['variant_id']]['quantity'] = bcadd($lines[$l['variant_id']]['quantity'], $l['matched_quantity'], 4);
            } else {
                $lines[$l['variant_id']] = ['variant_id' => $l['variant_id'], 'quantity' => $l['matched_quantity'], 'unit_price_centavos' => $l['unit_price_centavos'], 'description' => $l['name'], 'specifications' => $l['specifications']];
            }
        }

        return ['lines' => array_values($lines), 'fulfillment_method' => $snapshot['fulfillment_method'], 'payment_method' => $snapshot['payment_method'], 'fulfillment_date' => null, 'deadline_hours' => 24];
    }

    /** @param array<string, mixed> $input */
    public function inquire(Request $request, string $id, array $input): string
    {
        $key = $this->keys->requireIdempotencyKey($request);

        return DB::transaction(function () use ($request, $id, $input, $key): string {
            $w = $this->projects->package($request, $id, true);
            if ($this->keys->replayed($request, 'PROJECT_INQUIRE', $key, $id)) {
                $body = DB::table('idempotency_records')->where('actor_user_id', $request->user()->id)->where('endpoint', 'PROJECT_INQUIRE')->where('idempotency_key', $key)->value('response_body');

                return json_decode($body ?? '{}', true)['id'] ?? $key;
            }
            ProjectService::version($w, $input['lock_version']);
            $candidate = $this->estimates->candidate($request, $id, $input['candidate_id']);
            $this->unassigned($w);
            $existing = DB::table('conversations')->where('context_type', 'PROJECT_BASED')->where('context_id', $id)->where('vendor_organization_id', $candidate['snapshot']['vendor_id'])
                ->whereRaw("locked_reference->>'version_id' = ?", [$w->current_version_id])->value('id');
            if ($existing !== null) {
                $this->keys->claim($request, 'PROJECT_INQUIRE', $key, $id, 201);
                DB::table('idempotency_records')->where('actor_user_id', $request->user()->id)->where('endpoint', 'PROJECT_INQUIRE')->where('idempotency_key', $key)->update(['response_body' => json_encode(['id' => $existing], JSON_THROW_ON_ERROR)]);

                return $existing;
            }
            $v = DB::table('work_package_versions')->where('id', $w->current_version_id)->first();
            $content = json_decode($v->content, true);
            $duplicate = self::duplicate($candidate['snapshot']);
            $reference = ['version_id' => $v->id, 'version' => (int) $v->version, 'content_hash' => $v->content_hash, 'work_package' => $content, 'system_estimate' => $candidate['snapshot'],
                'working_duplicate' => $duplicate, 'destination' => $content['destination'], 'lines' => $content['lines']];
            app(ConversationService::class)->createProject($request, $key, $candidate['snapshot']['vendor_id'], $id, $reference);
            DB::table('quotations')->insert(['id' => (string) Str::uuid7(), 'conversation_id' => $key, 'buyer_profile_id' => DB::table('projects')->where('id', $w->project_id)->value('buyer_profile_id'),
                'vendor_organization_id' => $candidate['snapshot']['vendor_id'], 'procurement_type' => 'PROJECT_BASED', 'work_package_id' => $id, 'state' => 'DRAFT',
                'draft' => json_encode($duplicate, JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
            DB::table('work_packages')->where('id', $id)->update(['status' => 'QUOTATION_INQUIRY', 'lock_version' => $w->lock_version + 1, 'updated_at' => now()]);
            $this->projects->record($request, 'PROJECT_VENDOR_INQUIRY_CREATED', $id);
            $this->keys->claim($request, 'PROJECT_INQUIRE', $key, $id, 201);

            return $key;
        });
    }

    /** @param array<string, mixed> $input */
    public function select(Request $request, string $id, array $input): string
    {
        $key = $this->keys->requireIdempotencyKey($request);

        return DB::transaction(function () use ($request, $id, $input, $key): string {
            $w = $this->projects->package($request, $id, true);
            if ($this->keys->replayed($request, 'PROJECT_SELECT', $key, $id)) {
                return $key;
            }
            ProjectService::version($w, $input['lock_version']);
            $this->unassigned($w);
            $candidate = $this->estimates->candidate($request, $id, $input['candidate_id']);
            $s = $candidate['snapshot'];
            // Capability updates acquire the same organization lock; accepted history is never revalidated.
            DB::table('vendor_organizations')->where('id', $s['vendor_id'])->lockForUpdate()->first();
            $this->estimates->assertFresh($s);
            if ($s['delivery']['status'] === 'BLOCKED') {
                throw new AuthenticationException('FULFILLMENT_REVIEW_REQUIRED', 'Resolve the delivery endpoint or coverage before selection.', 422);
            }
            $actor = OrderActor::buyer($request);
            $buyer = DB::table('projects')->where('id', $w->project_id)->value('buyer_profile_id');
            DB::table('orders')->insert(['id' => $key, 'reference' => 'ORD-'.now('Asia/Manila')->format('Y').'-'.Str::upper(Str::random(10)), 'buyer_profile_id' => $buyer,
                'vendor_organization_id' => $s['vendor_id'], 'work_package_id' => $id, 'work_package_version_id' => $w->current_version_id, 'compiled_estimate_vendor_id' => $input['candidate_id'],
                'procurement_type' => 'PROJECT_BASED', 'order_state' => 'AWAITING_VENDOR_CONFIRMATION', 'payment_state' => 'NOT_REQUIRED', 'fulfillment_method' => $s['fulfillment_method'], 'payment_method' => $s['payment_method'],
                'materials_centavos' => $s['materials_centavos'], 'delivery_centavos' => $s['fulfillment_method'] === 'PICKUP' ? 0 : null, 'commercial_total_centavos' => $s['materials_centavos'],
                'project_note' => $input['note'] ?? null, 'destination' => json_encode($s['destination'], JSON_THROW_ON_ERROR), 'submitted_at' => now(), 'vendor_response_due_at' => now()->addHours(24), 'created_at' => now(), 'updated_at' => now()]);
            if (! empty($s['destination']['access_instructions'])) {
                DB::table('orders')->where('id', $key)->update(['access_instructions_encrypted' => Crypt::encryptString($s['destination']['access_instructions'])]);
            }
            $lineNumber = 0;
            foreach (self::aggregateLines($s['lines']) as $l) {
                if ($l['variant_id'] === null || bccomp($l['matched_quantity'], '0', 4) <= 0) {
                    continue;
                }
                DB::table('order_lines')->insert(['id' => (string) Str::uuid7(), 'order_id' => $key, 'line_number' => ++$lineNumber, 'listing_variant_id' => $l['variant_id'], 'vendor_listing_id' => $l['listing_id'],
                    'unit_id' => $l['unit_id'], 'quantity' => $l['matched_quantity'], 'unit_price_centavos' => $l['unit_price_centavos'], 'payable_centavos' => $l['amount_centavos'], 'included_vat_centavos' => $l['included_vat_centavos'],
                    'tax_category' => $l['tax_category'], 'listing_price_version_id' => $l['source_price_version_id'], 'snapshot' => json_encode($l + ['display_name' => $l['name']], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
            }
            $order = DB::table('orders')->where('id', $key)->first();
            $commercial = app(OrderCommercial::class);
            $money = $commercial->compute($commercial->lines($key), [], 0, $order->delivery_centavos);
            $commercial->record($order, 'SUBMITTED', ['work_package_version_id' => $w->current_version_id, 'system_estimate' => $s, 'note' => $input['note'] ?? null,
                'note_response_required' => false, 'fulfillment_method' => $s['fulfillment_method'], 'payment_method' => $s['payment_method']], $money, $actor);
            app(ProjectBudget::class)->guard($request, $w, $s['projected_total_centavos'] ?? $s['materials_centavos'], $input, $key);
            app(OrderTransitionService::class)->opened($order, $actor);
            $this->missing($w, $s['missing_lines']);
            app(QuotationService::class)->expireForPackage($id);
            DB::table('work_packages')->where('id', $id)->update(['status' => 'VENDOR_SELECTED', 'selected_vendor_organization_id' => $s['vendor_id'], 'lock_version' => $w->lock_version + 1, 'updated_at' => now()]);
            app(OrderNotifier::class)->vendor($order, 'Project package request '.$order->reference, 'Manually confirm availability, final amount, fulfillment date and delivery within 24 hours. The Buyer note is informational and needs no response.');
            $this->projects->record($request, 'PROJECT_VENDOR_SELECTED', $id);
            $this->keys->claim($request, 'PROJECT_SELECT', $key, $id, 201);

            return $key;
        });
    }

    private function unassigned(object $w): void
    {
        if ($w->selected_vendor_organization_id !== null || ! in_array($w->status, ['ACTIVE', 'QUOTATION_INQUIRY'], true)) {
            throw new AuthenticationException('WORK_PACKAGE_ALREADY_ASSIGNED', 'This Work Package already has a selected Vendor or is closed.', 409);
        }
    }

    /** A stock row occurs only once in a package order, even if several requirements use it.
     * @param list<array<string, mixed>> $lines
     * @return list<array<string, mixed>> */
    public static function aggregateLines(array $lines): array
    {
        $result = [];
        $flattened = [];
        foreach ($lines as $line) {
            if (isset($line['allocations'])) {
                foreach ($line['allocations'] as $allocation) {
                    $flattened[] = array_merge($line, $allocation);
                }
            } else {
                $flattened[] = $line;
            }
        }
        foreach ($flattened as $line) {
            unset($line['allocations']);
            if ($line['variant_id'] === null || bccomp($line['matched_quantity'], '0', 4) <= 0) {
                continue;
            }
            $id = $line['variant_id'];
            if (isset($result[$id])) {
                $result[$id]['matched_quantity'] = bcadd($result[$id]['matched_quantity'], $line['matched_quantity'], 4);
                $result[$id]['work_package_line_ids'][] = $line['line_id'];
                $result[$id]['amount_centavos'] = Money::lineAmount($result[$id]['matched_quantity'], $line['unit_price_centavos']);
                $result[$id]['included_vat_centavos'] = Money::includedVat($result[$id]['amount_centavos'], $line['tax_category']);
            } else {
                $result[$id] = $line + ['work_package_line_ids' => [$line['line_id']]];
            }
        }

        return array_values($result);
    }

    /** Reconcile the accepted proposal against the locked original without rewriting that original.
     * @param list<array<string, mixed>> $supplied */
    public function acceptedMissing(object $w, array $supplied): void
    {
        if ($w->current_version_id === null) {
            return;
        }
        $version = DB::table('work_package_versions')->where('id', $w->current_version_id)->first();
        $original = json_decode($version->content, true);
        foreach ($original['lines'] as $required) {
            $needed = $required['quantity'];
            foreach ($supplied as &$line) {
                if (($line['material_id'] ?? null) !== $required['material_id'] || $line['unit_id'] !== $required['unit_id']
                    || ($required['preferred_brand'] !== null && ($line['brand'] ?? null) !== $required['preferred_brand'])
                    || array_diff_assoc($required['specifications'], $line['specifications'] ?? []) !== []) {
                    continue;
                }
                $take = bccomp($needed, $line['quantity'], 4) <= 0 ? $needed : $line['quantity'];
                $needed = bcsub($needed, $take, 4);
                $line['quantity'] = bcsub($line['quantity'], $take, 4);
            }
            unset($line);
            if (bccomp($needed, '0', 4) > 0) {
                DB::table('work_package_missing_lines')->updateOrInsert(['work_package_version_id' => $w->current_version_id, 'work_package_line_id' => $required['id']],
                    ['id' => DB::table('work_package_missing_lines')->where('work_package_line_id', $required['id'])->value('id') ?? (string) Str::uuid7(), 'quantity' => $needed, 'created_at' => now(), 'updated_at' => now()]);
            } else {
                DB::table('work_package_missing_lines')->where('work_package_version_id', $w->current_version_id)->where('work_package_line_id', $required['id'])->whereNull('linked_order_id')->whereNull('waived_by_user_id')->delete();
            }
        }
    }

    /** @param list<array<string, mixed>> $missing */
    public function missing(object $w, array $missing): void
    {
        foreach ($missing as $m) {
            DB::table('work_package_missing_lines')->insertOrIgnore(['id' => (string) Str::uuid7(), 'work_package_version_id' => $w->current_version_id,
                'work_package_line_id' => $m['line_id'], 'quantity' => $m['quantity'], 'created_at' => now(), 'updated_at' => now()]);
        }
    }
}
