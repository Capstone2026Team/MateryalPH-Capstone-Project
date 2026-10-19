<?php

declare(strict_types=1);

namespace App\Domain\Projects;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Catalog\ReadyMixedConcrete;
use App\Domain\Enforcement\BuyerCommerceRestriction;
use App\Domain\Finance\Money;
use App\Domain\Geography\BuyerProfiles;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Messaging\ConversationService;
use App\Domain\Messaging\QuotationService;
use App\Domain\Orders\OrderEligibility;
use App\Domain\Orders\OrderNotifier;
use App\Domain\Orders\OrderStates;
use App\Domain\Payments\PaymentMethodPolicy;
use App\Domain\Procurement\DeliveryPreviewService;
use App\Domain\Procurement\ListingPublicFacts;
use Illuminate\Contracts\Encryption\DecryptException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Ramsey\Uuid\Uuid;

/** A Work Package arrangement has equal suppliers. Candidate IDs are only proposal sources, never award dependencies. */
final class ProjectArrangements
{
    public function __construct(private readonly ProjectService $projects, private readonly ProjectEstimateService $estimates, private readonly ProjectProcurementDraft $draft) {}

    /** @return array<string, mixed> */
    public function options(Request $r, string $packageId): array
    {
        $page = $this->estimates->show($r, $packageId);
        if ($page['estimate'] === null) {
            return $page;
        }
        $w = $this->projects->package($r, $packageId);
        $rows = DB::table('compiled_estimate_vendors')->where('compiled_estimate_id', $page['estimate']['id'])
            ->orderByRaw("(snapshot->>'complete')::boolean DESC, (snapshot->>'rank')::int")->get(['id', 'snapshot']);
        $single = $groups = [];
        $facts = $sources = [];
        foreach ($rows as $row) {
            $snapshot = json_decode($row->snapshot, true);
            $facts[$snapshot['vendor_id']] = $snapshot;
            $sources[$snapshot['vendor_id']] = (string) $row->id;
        }
        $seeds = 0;
        foreach ($rows as $row) {
            $raw = json_decode($row->snapshot, true);
            // Bound combination generation; complete one-store options remain paginated, not truncated.
            if (! $raw['complete'] && ++$seeds > 25) {
                continue;
            }
            $view = $this->proposal($r, $w, (string) $row->id);
            $this->collectProposal($single, $groups, $view);
        }
        $ranking = FulfillmentMatchScore::preferences((string) DB::table('projects')->where('id', $w->project_id)->value('buyer_profile_id'));
        foreach (app(ArrangementProposals::class)->generate($r, $w, $facts, $ranking['weights']) as $items) {
            if ($items === []) {
                continue;
            }
            $source = $facts[$items[0]['vendor_id']];
            $source['id'] = $sources[$items[0]['vendor_id']];
            $source['stale'] = $page['estimate']['state'] !== 'ACTIVE';
            $this->collectProposal($single, $groups, $this->render($r, $w, $source, $items, null));
        }
        $items = array_merge(array_values($single), array_values($groups));
        // Reopening an option resumes its edited draft, including explicit removals.
        $drafts = DB::table('project_procurement_arrangements')->where('work_package_version_id', $w->current_version_id)->whereNull('submitted_at')
            ->whereIn('source_candidate_id', $rows->pluck('id')->all())->orderBy('updated_at')->get()->keyBy(static fn (object $a): string => (string) (json_decode($a->preferences, true)['proposal_signature'] ?? $a->id));
        foreach ($items as &$item) {
            $saved = $drafts[self::optionKey($item)] ?? null;
            if ($saved !== null) {
                $item = $this->show($r, $packageId, $saved->id);
            }
        }
        unset($item);
        $resumed = [];
        foreach ($items as $item) {
            $key = self::optionKey($item);
            if (! isset($resumed[$key]) || $item['version'] > $resumed[$key]['version']) {
                $resumed[$key] = $item;
            }
        }
        $items = array_values($resumed);
        usort($items, ArrangementMatchScore::compare(...));
        $singleCount = count(array_filter($items, static fn (array $item): bool => $item['vendor_count'] === 1 && $item['coverage']['lines_fulfilled'] === $item['coverage']['lines_total']));
        $allCount = $singleCount + min(count($items) - $singleCount, 3);
        if ($r->boolean('complete_only')) {
            $items = array_values(array_filter($items, static fn (array $v): bool => $v['coverage']['lines_remaining'] === 0));
        }
        if ($r->boolean('within_budget')) {
            $items = array_values(array_filter($items, static fn (array $v): bool => in_array($v['budget_label'], ['UNDER_BUDGET', 'WITHIN_BUDGET'], true)));
        }
        if ($r->boolean('favorites_only')) {
            $items = array_values(array_filter($items, static fn (array $v): bool => count(array_filter($v['vendors'], static fn (array $g): bool => ! $g['is_favorite'])) === 0));
        }
        if ($r->query('sort') === 'PRICE') {
            $descending = $r->query('direction', 'ASC') === 'DESC';
            usort($items, static fn (array $a, array $b): int => (($a['coverage']['lines_remaining'] > 0) <=> ($b['coverage']['lines_remaining'] > 0)) ?: (($a['total_centavos'] === null) <=> ($b['total_centavos'] === null))
                ?: ($descending ? ($b['total_centavos'] <=> $a['total_centavos']) : ($a['total_centavos'] <=> $b['total_centavos'])) ?: strcmp($a['fingerprint'], $b['fingerprint']));
        }
        $groupCount = 0;
        $items = array_values(array_filter($items, static function (array $item) use (&$groupCount): bool {
            return ($item['vendor_count'] === 1 && $item['coverage']['lines_fulfilled'] === $item['coverage']['lines_total']) || ++$groupCount <= 3;
        }));
        foreach ($items as $index => &$item) {
            $item['rank'] = $r->query('sort', 'BEST_MATCH') === 'BEST_MATCH' && $item['coverage']['lines_fulfilled'] === $item['coverage']['lines_total'] && $item['fms']['score'] !== null && $item['issues'] === [] && $item['total_centavos'] !== null && ! $item['stale'] ? $index + 1 : null;
            if ($item['version'] === 0) {
                $item['proposal_token'] = $this->proposalToken($r, $w, $item);
            }
        }
        unset($item);
        $number = max(1, (int) $r->query('page', 1));

        return ['estimate' => $page['estimate'], 'items' => array_slice($items, ($number - 1) * 25, 25), 'page' => $number,
            'has_more' => count($items) > $number * 25, 'total' => count($items), 'unfiltered_total' => $allCount, 'sort' => $r->query('sort', 'BEST_MATCH')];
    }

    /** @param array<string, array<string, mixed>> $single
     * @param array<string, array<string, mixed>> $groups
     * @param array<string, mixed> $view */
    private function collectProposal(array &$single, array &$groups, array $view): void
    {
        if ($view['vendor_count'] === 0) {
            return;
        }
        if ($view['vendor_count'] === 1 && $view['coverage']['lines_fulfilled'] === $view['coverage']['lines_total']) {
            $key = 'vendor:'.$view['vendors'][0]['vendor_id'];
            if (! isset($single[$key]) || ArrangementMatchScore::compare($view, $single[$key]) < 0) {
                $single[$key] = $view;
            }
        } else {
            $key = self::optionKey($view);
            if (! isset($groups[$key]) || ArrangementMatchScore::compare($view, $groups[$key]) < 0) {
                $groups[$key] = $view;
            }
        }
    }

    /** @param array<string, mixed> $view */
    private function proposalToken(Request $r, object $w, array $view): string
    {
        $items = [];
        foreach ($view['vendors'] as $vendor) {
            foreach ($vendor['items'] as $item) {
                $items[] = ['line_id' => $item['line_id'], 'variant_id' => $item['variant_id'], 'quantity' => $item['quantity'],
                    'method' => $vendor['fulfillment_method'], 'price_version_id' => $item['source_price_version_id'], 'publication_version' => $item['publication_version']];
            }
        }

        return Crypt::encryptString(json_encode(['buyer_user_id' => (string) $r->user()->getKey(), 'package_id' => $w->id, 'version_id' => $w->current_version_id,
            'candidate_id' => $view['source_candidate_id'], 'fingerprint' => $view['fingerprint'], 'items' => $items], JSON_THROW_ON_ERROR));
    }

    /** Rehydrate only this Buyer's server-issued allocation and recheck current catalog facts.
     * @return array<string, mixed> */
    private function fromToken(Request $r, object $w, string $candidateId, string $token): array
    {
        try {
            $proposal = json_decode(Crypt::decryptString($token), true, 512, JSON_THROW_ON_ERROR);
        } catch (DecryptException|\JsonException) {
            throw new AuthenticationException('PROJECT_PROPOSAL_INVALID', 'Choose a current quotation option from this Work Package.', 422);
        }
        if ($proposal['buyer_user_id'] !== (string) $r->user()->getKey() || $proposal['package_id'] !== $w->id || $proposal['version_id'] !== $w->current_version_id || $proposal['candidate_id'] !== $candidateId) {
            throw new AuthenticationException('PROJECT_PROPOSAL_INVALID', 'This quotation option belongs to another Work Package or Buyer.', 409);
        }
        $source = $this->estimates->candidate($r, (string) $w->id, $candidateId)['snapshot'];
        $source['id'] = $candidateId;
        $requirements = DB::table('work_package_lines')->where('work_package_version_id', $w->current_version_id)->get()->keyBy('id');
        $items = $used = [];
        foreach ($proposal['items'] as $selection) {
            $line = $requirements[$selection['line_id']] ?? null;
            $item = $this->draft->offer($w, $selection['variant_id'], $selection['method']);
            $this->assertVendor($item['vendor_id']);
            $used[$item['variant_id']] = bcadd($used[$item['variant_id']] ?? '0', $selection['quantity'], 4);
            if ($line === null || $line->material_id !== $item['material_id'] || $line->unit_id !== $item['unit_id']
                || $item['source_price_version_id'] !== $selection['price_version_id'] || $item['publication_version'] !== $selection['publication_version']
                || bccomp($used[$item['variant_id']], $item['_available'], 4) > 0
                || ($line->preferred_brand !== null && $line->preferred_brand !== $item['brand'])
                || ! SpecificationMatch::satisfies(json_decode($line->specifications ?? '{}', true), $item['offered_specifications'])) {
                throw new AuthenticationException('PROJECT_ARRANGEMENT_CHANGED', 'This offer changed. Refresh Quotation options and review current materials and delivery.', 409);
            }
            unset($item['_available']);
            $quantity = $selection['quantity'];
            $items[] = $item + ['draft_item_id' => (string) Str::uuid7(), 'stage' => 'DRAFT', 'line_id' => $line->id, 'quantity' => $quantity,
                'coverage_quantity' => $quantity, 'line_total_centavos' => Money::lineAmount($quantity, $item['unit_price_centavos']), 'satisfies_requirement' => true];
        }
        $view = $this->render($r, $w, $source, $items, null);
        if (! hash_equals($view['fingerprint'], $proposal['fingerprint'])) {
            throw new AuthenticationException('PROJECT_ARRANGEMENT_CHANGED', 'Materials or delivery costs changed. Refresh Quotation options before choosing this arrangement.', 409);
        }

        return $view;
    }

    /** @return array<string, mixed> */
    private function proposal(Request $r, object $w, string $candidateId): array
    {
        $source = $this->estimates->comparison($r, (string) $w->id, $candidateId);
        $items = [];
        $remaining = array_column($source['lines'], 'missing_quantity', 'line_id');
        foreach ($source['lines'] as $line) {
            foreach ($line['allocations'] as $allocation) {
                try {
                    $offer = $this->draft->offer($w, $allocation['variant_id'], $source['fulfillment_method']);
                } catch (AuthenticationException) {
                    continue;
                }
                unset($offer['_available']);
                $items[] = array_merge($line, $allocation, $offer, ['draft_item_id' => (string) Str::uuid7(), 'stage' => 'DRAFT', 'vendor_id' => $source['vendor_id'],
                    'display_name' => $allocation['description'], 'quantity' => $allocation['matched_quantity'], 'coverage_quantity' => $allocation['matched_quantity'],
                    'line_total_centavos' => $allocation['amount_centavos'], 'satisfies_requirement' => true, 'fulfillment_method' => $source['fulfillment_method']]);
            }
        }
        foreach ($source['draft_groups'] as $group) {
            foreach ($group['items'] as $item) {
                $needed = $remaining[$item['line_id']] ?? '0';
                $item['quantity'] = bccomp($needed, $item['quantity'], 4) < 0 ? $needed : $item['quantity'];
                if (bccomp($item['quantity'], '0', 4) <= 0) {
                    continue;
                }
                $remaining[$item['line_id']] = bcsub($needed, $item['quantity'], 4);
                $item['line_total_centavos'] = Money::lineAmount($item['quantity'], $item['unit_price_centavos']);
                $item['coverage_quantity'] = bccomp($item['coverage_quantity'] ?? $item['quantity'], $item['quantity'], 4) > 0 ? $item['quantity'] : ($item['coverage_quantity'] ?? $item['quantity']);
                $items[] = $item;
            }
        }
        $eligible = DB::table('store_profiles')->whereIn('vendor_organization_id', array_column($items, 'vendor_id'))->where('bulk_capability', true)->pluck('vendor_organization_id')->all();
        $items = array_values(array_filter($items, static fn (array $i): bool => in_array($i['vendor_id'], $eligible, true)));

        return $this->render($r, $w, $source, $items, null);
    }

    /** @return array<string, mixed> */
    public function create(Request $r, string $packageId, string $candidateId, ?string $token = null): array
    {
        $this->commerce($r);
        $keys = app(CatalogAccess::class);
        $id = $keys->requireIdempotencyKey($r);
        $w = $this->projects->package($r, $packageId);
        if ($keys->replayed($r, 'PROJECT_ARRANGEMENT_CREATE', $id, $packageId)) {
            return $this->show($r, $packageId, $id);
        }
        $this->estimates->candidate($r, $packageId, $candidateId);
        $proposal = $token === null ? $this->proposal($r, $w, $candidateId) : $this->fromToken($r, $w, $candidateId, $token);
        DB::transaction(function () use ($r, $w, $candidateId, $proposal, $keys, $id): void {
            $current = $this->projects->package($r, (string) $w->id, true);
            if ($keys->replayed($r, 'PROJECT_ARRANGEMENT_CREATE', $id, (string) $w->id)) {
                return;
            }
            if ($current->current_version_id !== $w->current_version_id || $current->selected_vendor_organization_id !== null || $current->selected_arrangement_id !== null
                || ! in_array($current->status, ['ACTIVE', 'QUOTATION_INQUIRY'], true)) {
                throw new AuthenticationException('WORK_PACKAGE_LOCKED', 'Review the current Work Package before choosing another arrangement.', 409);
            }
            DB::table('project_procurement_arrangements')->insert(['id' => $id, 'work_package_version_id' => $w->current_version_id, 'source_candidate_id' => $candidateId,
                'preferences' => json_encode(['excluded' => [], 'choices' => [], 'proposal_signature' => self::optionKey($proposal)], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
            foreach ($proposal['vendors'] as $vendor) {
                $member = $this->member($id, $vendor['vendor_id'], $vendor['fulfillment_method']);
                foreach ($vendor['items'] as $item) {
                    $this->insertItem($id, $member, $item);
                }
            }
            $this->projects->record($r, 'PROJECT_ARRANGEMENT_CREATED', $id);
            $keys->claim($r, 'PROJECT_ARRANGEMENT_CREATE', $id, (string) $w->id, 201);
        });

        return $this->show($r, $packageId, $id);
    }

    /** @return array{0: object, 1: object} */
    private function owned(Request $r, string $packageId, string $id, bool $lock = false): array
    {
        $w = $this->projects->package($r, $packageId, $lock);
        $q = DB::table('project_procurement_arrangements')->where('id', $id)->where('work_package_version_id', $w->current_version_id);
        $a = ($lock ? $q->lockForUpdate() : $q)->first();
        if ($a === null) {
            throw new AuthenticationException('PROJECT_ARRANGEMENT_NOT_FOUND', 'This arrangement is not part of the current Work Package.', 404);
        }

        return [$w, $a];
    }

    /** @return array<string, mixed> */
    public function show(Request $r, string $packageId, string $id): array
    {
        [$w, $a] = $this->owned($r, $packageId, $id);
        $candidate = $this->estimates->candidate($r, $packageId, $a->source_candidate_id, false);
        $source = $candidate['snapshot'];
        $source['stale'] = $a->submitted_at === null && $w->selected_arrangement_id === null && ($candidate['estimate']->invalidated_at !== null || now()->greaterThanOrEqualTo($candidate['estimate']->expires_at));
        $source['id'] = $a->source_candidate_id;
        $members = DB::table('project_arrangement_vendors')->where('arrangement_id', $id)->get()->keyBy('id');
        $items = [];
        $stock = [];
        $quotedMembers = [];
        foreach ($members as $member) {
            if ($member->order_id !== null || $member->conversation_id === null || $this->failed($member)) {
                continue;
            }
            $quotation = DB::table('quotations')->where('conversation_id', $member->conversation_id)->whereNotNull('current_version_id')->first();
            if ($quotation !== null) {
                $quotedMembers[$member->id] = true;
                array_push($items, ...$this->quotedItems($w, $member, $quotation));
            }
        }
        foreach (DB::table('project_arrangement_items')->where('arrangement_id', $id)->whereNull('removed_at')->orderBy('id')->get() as $row) {
            $m = $members[$row->arrangement_vendor_id];
            $order = $m->order_id === null ? null : DB::table('orders')->where('id', $m->order_id)->first();
            if ($order !== null || isset($quotedMembers[$m->id]) || $this->failed($m)) {
                continue;
            }
            $item = array_merge(json_decode($row->snapshot, true), ['draft_item_id' => $row->id, 'stage' => 'DRAFT', 'order_id' => null,
                'order_reference' => null, 'quantity' => (string) $row->quantity, 'fulfillment_method' => $m->fulfillment_method]);
            try {
                $live = $this->draft->offer($w, $item['variant_id'], $m->fulfillment_method);
                $stock[$item['variant_id']] ??= $live['_available'];
                $item['coverage_quantity'] = bccomp($stock[$item['variant_id']], $item['quantity'], 4) >= 0 ? $item['quantity'] : $stock[$item['variant_id']];
                $stock[$item['variant_id']] = bcsub($stock[$item['variant_id']], $item['coverage_quantity'], 4);
                $item['image'] = $live['image'];
            } catch (AuthenticationException) {
                $item['coverage_quantity'] = '0';
            }
            $items[] = $item;
        }
        $buyer = (string) DB::table('projects')->where('id', $w->project_id)->value('buyer_profile_id');
        $orders = $members->pluck('order_id')->filter()->all();
        foreach (PackageFulfillment::purchases($w, $buyer) as $purchases) {
            foreach ($purchases as $purchase) {
                if ($purchase['stage'] !== 'ORDERED' || ! in_array($purchase['order_id'], $orders, true)) {
                    continue;
                }
                $record = DB::table('order_lines')->where('order_id', $purchase['order_id'])->where('listing_variant_id', $purchase['variant_id'])->first();
                $snapshot = json_decode($record->snapshot, true);
                $method = DB::table('orders')->where('id', $purchase['order_id'])->value('fulfillment_method');
                $items[] = array_merge($snapshot, $purchase, ['draft_item_id' => $record->id, 'coverage_quantity' => $purchase['quantity'], 'fulfillment_method' => $method, 'preserve_commercial_amount' => true]);
            }
        }

        return $this->render($r, $w, $source, ProjectProcurementDraft::priceItems($items), $a);
    }

    /** Render the latest immutable issued terms without accepting them.
     * @return list<array<string, mixed>> */
    private function quotedItems(object $w, object $member, object $quotation): array
    {
        $version = DB::table('quotation_versions')->where('id', $quotation->current_version_id)->first();
        $terms = json_decode($version->content, true);
        $requirements = DB::table('work_package_lines')->where('work_package_version_id', $w->current_version_id)->get()->keyBy('id');
        $images = app(ListingPublicFacts::class)->images(array_column($terms['lines'], 'listing_id'));
        $priced = array_column($terms['commercial']['lines'], 'payable_centavos', 'line_id');
        $items = [];
        foreach ($terms['lines'] as $line) {
            $weights = [];
            foreach ($line['work_package_allocations'] as $allocation) {
                $weights[$allocation['line_id']] = (int) bcmul($allocation['quantity'], '10000', 0);
            }
            $amounts = Money::allocate($priced[$line['variant_id']], $weights);
            foreach ($line['work_package_allocations'] as $allocation) {
                $required = $requirements[$allocation['line_id']];
                $offered = $line['offered_specifications'] ?? $line['specifications'];
                $items[] = array_merge($line, ['draft_item_id' => $version->id, 'line_id' => $required->id, 'vendor_id' => $member->vendor_organization_id,
                    'display_name' => $line['description'], 'stage' => 'QUOTED', 'quantity' => $allocation['quantity'], 'coverage_quantity' => $allocation['quantity'],
                    'image' => $images[$line['listing_id']][0] ?? null, 'specifications' => SpecificationMatch::labelled($offered, []), 'offered_specifications' => $offered,
                    'fulfillment_method' => $terms['fulfillment_method'], 'line_total_centavos' => $amounts[$required->id], 'preserve_commercial_amount' => true,
                    'satisfies_requirement' => $required->material_id === $line['material_id'] && $required->unit_id === $line['unit_id']
                        && ($required->preferred_brand === null || $required->preferred_brand === $line['brand']) && SpecificationMatch::satisfies(json_decode($required->specifications ?? '{}', true), $offered)]);
            }
        }

        return $items;
    }

    /** @param array<string, mixed> $source
     * @param list<array<string, mixed>> $items
     * @return array<string, mixed> */
    private function render(Request $r, object $w, array $source, array $items, ?object $a): array
    {
        $items = ProjectProcurementDraft::priceItems($items);
        $content = json_decode((string) DB::table('work_package_versions')->where('id', $w->current_version_id)->value('content'), true);
        $preferences = $a === null ? ['choices' => []] : json_decode($a->preferences, true);
        $members = $a === null ? collect() : DB::table('project_arrangement_vendors')->where('arrangement_id', $a->id)->get()->keyBy('vendor_organization_id');
        $methods = [];
        foreach ($members as $m) {
            $methods[$m->vendor_organization_id] = $m->fulfillment_method;
        }
        foreach ($items as $item) {
            if ($item['stage'] === 'QUOTED') {
                $methods[$item['vendor_id']] = $item['fulfillment_method'];
            }
        }
        $groups = $this->draft->groups($w, $source, $items, $methods, false);
        $candidates = DB::table('compiled_estimate_vendors as v')->join('compiled_estimates as e', 'e.id', '=', 'v.compiled_estimate_id')->where('e.work_package_version_id', $w->current_version_id)->orderBy('e.created_at')
            ->get(['v.id', 'v.vendor_organization_id', 'v.snapshot'])->keyBy('vendor_organization_id');
        $favorites = app(ListingPublicFacts::class)->favoriteOrganizations((string) DB::table('projects')->where('id', $w->project_id)->value('buyer_profile_id'));
        $materialTotal = $deliveryTotal = $projectedTotal = 0;
        $known = true;
        $allIssues = [];
        foreach ($groups as &$g) {
            $m = $members[$g['vendor_id']] ?? null;
            $c = $candidates[$g['vendor_id']] ?? null;
            $details = $c === null ? [] : json_decode($c->snapshot, true);
            $g += ['id' => $m->id ?? $g['vendor_id'], 'candidate_id' => $c?->id, 'latitude' => $details['latitude'] ?? null, 'longitude' => $details['longitude'] ?? null,
                'distance_meters' => $details['distance_meters'] ?? null, 'score_label' => $details['score_label'] ?? 'New Vendor', 'vps' => $details['vps'] ?? null,
                'fms' => $details['fms'] ?? null, 'is_favorite' => isset($favorites[$g['vendor_id']]), 'order_id' => $m?->order_id, 'conversation_id' => $m?->conversation_id, 'choice_lines' => []];
            $assigned = array_column($g['items'], 'line_id');
            foreach ($details['lines'] ?? [] as $line) {
                if ($line['selection_required'] && in_array($line['line_id'], $assigned, true) && ! isset($preferences['choices'][$g['vendor_id']][$line['line_id']])) {
                    $g['choice_lines'][] = $line;
                    $g['issues'][] = 'Choose the material specifications before submitting this supplier request.';
                }
            }
            $g['quotation_state'] = null;
            $g['quotation_version_id'] = null;
            $g['accepted'] = false;
            $g['order_state'] = $m?->order_id === null ? null : DB::table('orders')->where('id', $m->order_id)->value('order_state');
            if ($m?->conversation_id !== null) {
                $quotation = DB::table('quotations')->where('conversation_id', $m->conversation_id)->orderByDesc('created_at')->first();
                $g['quotation_state'] = $quotation?->state;
                $g['quotation_version_id'] = $quotation?->current_version_id;
                if ($quotation?->current_version_id !== null) {
                    $issued = DB::table('quotation_versions')->where('id', $quotation->current_version_id)->first();
                    $terms = json_decode((string) $issued->content, true);
                    $g['quotation_version'] = (int) $issued->version;
                    $g['quotation_total_centavos'] = $terms['commercial']['commercial_total_centavos'];
                    if ($g['order_id'] === null) {
                        $g['materials_centavos'] = $terms['commercial']['materials_payable_centavos'];
                        $g['delivery_centavos'] = $terms['commercial']['delivery_centavos'];
                        $g['projected_total_centavos'] = $terms['commercial']['commercial_total_centavos'];
                        $g['fulfillment_method'] = $terms['fulfillment_method'];
                        $g['fulfillment_options'] = [$terms['fulfillment_method']];
                        $g['payment_methods'] = app(PaymentMethodPolicy::class)->options($g['vendor_id'], $terms['fulfillment_method']);
                        $g['choice_lines'] = [];
                        $g['issues'] = [];
                        $g['delivery'] = $terms['delivery'] === null ? DeliveryPreviewService::notApplicable()
                            : ['status' => 'VENDOR_CONFIRMED', 'confirmed_offer' => $terms['delivery'], 'issues' => [], 'estimate' => null];
                    }
                }
            }
            if ($g['order_id'] !== null) {
                $order = DB::table('orders')->where('id', $g['order_id'])->first();
                $submitted = json_decode((string) DB::table('order_snapshots')->where('order_id', $order->id)->where('kind', 'SUBMITTED')->orderBy('version')->value('snapshot'), true);
                $g['materials_centavos'] = (int) $order->materials_centavos;
                $g['accepted'] = $order->accepted_at !== null;
                $g['order_lock_version'] = (int) $order->lock_version;
                $g['payment_method'] = $order->payment_method;
                $g['fulfillment_method'] = $order->fulfillment_method;
                $g['fulfillment_options'] = [$order->fulfillment_method];
                $g['delivery_centavos'] = $order->delivery_centavos === null ? ($submitted['system_estimate']['delivery_centavos'] ?? null) : (int) $order->delivery_centavos;
                if (isset($submitted['system_estimate']['delivery'])) {
                    $g['delivery'] = $submitted['system_estimate']['delivery'];
                }
                $g['projected_total_centavos'] = $order->accepted_at === null ? ($g['delivery_centavos'] === null ? null : $g['materials_centavos'] + $g['delivery_centavos']) : (int) $order->commercial_total_centavos;
                $g['issues'] = [];
                $delivery = DB::table('order_delivery_snapshots')->where('order_id', $order->id)->orderByDesc('created_at')->value('snapshot');
                if ($delivery !== null) {
                    $g['delivery'] = ['status' => 'VENDOR_CONFIRMED', 'confirmed_offer' => json_decode($delivery, true), 'issues' => [], 'estimate' => null];
                }
            }
            $g['requested'] = $m?->requested_at !== null;
            $materialTotal += $g['materials_centavos'];
            $known = $known && $g['delivery_centavos'] !== null;
            $deliveryTotal += $g['delivery_centavos'] ?? 0;
            $projectedTotal += $g['projected_total_centavos'] ?? 0;
            $allIssues = array_merge($allIssues, $g['issues']);
        }
        unset($g);
        usort($groups, static fn (array $a, array $b): int => strcmp($a['store_name'], $b['store_name']) ?: strcmp($a['vendor_id'], $b['vendor_id']));
        $items = array_merge([], ...array_column($groups, 'items'));
        $requirements = [];
        $purchases = [];
        foreach ($content['lines'] as $line) {
            $requirements[] = ['line_id' => $line['id'], 'name' => $line['name'], 'unit_code' => $line['unit_code'], 'quantity' => $line['quantity'], 'matched_quantity' => '0', 'missing_quantity' => $line['quantity']];
            $selected = array_values(array_filter($items, static fn (array $i): bool => $i['line_id'] === $line['id']));
            $quantity = array_reduce($selected, static fn (string $sum, array $i): string => bcadd($sum, $i['quantity'], 4), '0');
            $specifications = [];
            foreach ($selected as $item) {
                if ($item['satisfies_requirement']) {
                    $specifications[json_encode(SpecificationMatch::normalizeAll($item['offered_specifications'] ?? []), JSON_THROW_ON_ERROR)] = true;
                }
            }
            $issue = bccomp($quantity, $line['quantity'], 4) > 0 ? $line['name'].': selected quantity exceeds the requirement.'
                : (count($specifications) > 1 ? $line['name'].': selected products have different specifications. Choose compatible products before submitting.' : null);
            if ($issue !== null) {
                $allIssues[] = $issue;
                foreach ($groups as &$g) {
                    if (in_array($line['id'], array_column($g['items'], 'line_id'), true)) {
                        $g['issues'][] = $issue;
                    }
                }
                unset($g);
            }
        }
        foreach ($items as $item) {
            $purchases[$item['line_id']][] = $item;
        }
        $coverage = PackageFulfillment::summarize($requirements, $purchases, 0, 0);
        $coverage['lines_remaining'] = $coverage['lines_total'] - $coverage['lines_fulfilled'];
        $coverage['lines_waived'] = 0;
        $waivers = $a === null || $w->selected_arrangement_id !== $a->id ? collect() : DB::table('work_package_missing_lines')->where('work_package_version_id', $w->current_version_id)->whereNotNull('waived_by_user_id')->get()->keyBy('work_package_line_id');
        foreach ($coverage['lines'] as &$line) {
            $waived = (string) ($waivers[$line['line_id']]->quantity ?? '0');
            $line['waived_quantity'] = bccomp($waived, $line['remaining_quantity'], 4) <= 0 ? $waived : $line['remaining_quantity'];
            $line['remaining_quantity'] = bcsub($line['remaining_quantity'], $line['waived_quantity'], 4);
            if (bccomp($line['waived_quantity'], '0', 4) > 0 && bccomp($line['remaining_quantity'], '0', 4) === 0) {
                $coverage['lines_remaining']--;
                $coverage['lines_waived']++;
            }
        }
        unset($line);
        $total = $known ? $projectedTotal : null;
        $budget = app(ProjectBudget::class)->metrics($this->projects->project($r, (string) $w->project_id), $w);
        $uncommitted = array_reduce($groups, static fn (int $sum, array $g): int => $sum + ($g['accepted'] ? 0 : ($g['projected_total_centavos'] ?? $g['materials_centavos'])), 0);
        $previous = [];
        foreach ($members as $m) {
            if ($this->failed($m)) {
                $quote = $m->conversation_id === null ? null : DB::table('quotations')->where('conversation_id', $m->conversation_id)->orderByDesc('created_at')->first();
                $previous[] = ['vendor_id' => $m->vendor_organization_id, 'order_id' => $m->order_id, 'conversation_id' => $m->conversation_id,
                    'order_state' => $m->order_id === null ? (in_array($quote?->state, ['PUBLISHED', 'VIEWED', 'COUNTERED'], true) ? 'EXPIRED' : $quote?->state) : DB::table('orders')->where('id', $m->order_id)->value('order_state')];
            } elseif ($m->order_id !== null) {
                $order = DB::table('orders')->where('id', $m->order_id)->first();
                if (in_array($order->order_state, OrderStates::CLOSED_BEFORE_FULFILLMENT, true)) {
                    $previous[] = ['vendor_id' => $m->vendor_organization_id, 'order_id' => $m->order_id, 'order_state' => $order->order_state];
                }
            }
        }

        $ranking = FulfillmentMatchScore::preferences((string) DB::table('projects')->where('id', $w->project_id)->value('buyer_profile_id'));

        return ['id' => $a->id ?? (string) Uuid::uuid5(Uuid::NAMESPACE_OID, self::optionKey(['vendors' => $groups])), 'source_candidate_id' => $a->source_candidate_id ?? $source['id'], 'version' => (int) ($a->lock_version ?? 0),
            'work_package_version_id' => $w->current_version_id, 'vendors' => $groups, 'vendor_count' => count($groups), 'coverage' => $coverage,
            'fms' => ArrangementMatchScore::calculate($coverage, $groups, $total, (int) $w->budget_centavos, $ranking['weights']),
            'materials_centavos' => $materialTotal, 'delivery_centavos' => $known ? $deliveryTotal : null, 'total_centavos' => $total,
            'budget_label' => $total === null ? 'COST_REVIEW_REQUIRED' : ProjectBudget::buckets((int) $w->budget_centavos, $budget['committed_centavos'] + $uncommitted, 0, 0)['label'],
            'fingerprint' => hash('sha256', self::fingerprint($items).json_encode(array_map(static fn (array $g): array => [$g['vendor_id'], $g['fulfillment_method'], $g['materials_centavos'], $g['delivery_centavos'], $g['projected_total_centavos'], $g['quotation_version_id'], $g['order_lock_version'] ?? null], $groups), JSON_THROW_ON_ERROR)),
            'issues' => array_values(array_unique($allIssues)), 'previous_vendors' => $previous,
            'submitted' => $a?->submitted_at !== null, 'stale' => $source['stale'] ?? false];
    }

    /** @param array<string, mixed> $view */
    private static function optionKey(array $view): string
    {
        $items = [];
        foreach ($view['vendors'] as $vendor) {
            foreach ($vendor['items'] as $item) {
                $items[] = [$vendor['vendor_id'], $item['line_id'], $item['variant_id'], bcadd($item['quantity'], '0', 4)];
            }
        }
        sort($items);

        return hash('sha256', json_encode($items, JSON_THROW_ON_ERROR));
    }

    /** @param list<array<string, mixed>> $items */
    private static function fingerprint(array $items): string
    {
        $values = array_map(static fn (array $i): array => [$i['vendor_id'], $i['line_id'], $i['variant_id'], bcadd($i['quantity'], '0', 4), $i['unit_price_centavos'], $i['fulfillment_method']], $items);
        sort($values);

        return hash('sha256', json_encode($values, JSON_THROW_ON_ERROR));
    }

    private function member(string $id, string $vendor, string $method): string
    {
        $existing = DB::table('project_arrangement_vendors')->where('arrangement_id', $id)->where('vendor_organization_id', $vendor)->value('id');
        if ($existing !== null) {
            $m = DB::table('project_arrangement_vendors')->where('id', $existing)->first();
            if ($this->failed($m)) {
                DB::table('project_arrangement_items')->where('arrangement_vendor_id', $existing)->whereNull('removed_at')->update(['removed_at' => now(), 'updated_at' => now()]);
                DB::table('project_arrangement_vendors')->where('id', $existing)->update(['order_id' => null, 'conversation_id' => null, 'requested_at' => null, 'fulfillment_method' => $method, 'updated_at' => now()]);
            }

            return (string) $existing;
        }
        $member = (string) Str::uuid7();
        DB::table('project_arrangement_vendors')->insert(['id' => $member, 'arrangement_id' => $id, 'vendor_organization_id' => $vendor,
            'fulfillment_method' => $method, 'created_at' => now(), 'updated_at' => now()]);

        return $member;
    }

    /** @param array<string, mixed> $item */
    private function insertItem(string $id, string $member, array $item): void
    {
        if (($item['load']['material_kind'] ?? null) === ReadyMixedConcrete::MATERIAL_CODE) {
            DB::table('project_arrangement_vendors')->where('id', $member)->update(['fulfillment_method' => 'DELIVERY', 'updated_at' => now()]);
        }
        unset($item['_available'], $item['allocations'], $item['options']);
        DB::table('project_arrangement_items')->insert(['id' => (string) Str::uuid7(), 'arrangement_id' => $id, 'arrangement_vendor_id' => $member,
            'work_package_line_id' => $item['line_id'], 'listing_variant_id' => $item['variant_id'], 'quantity' => $item['quantity'],
            'snapshot' => json_encode($item, JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
    }

    /** @return array<string, mixed>|null */
    private static function find(mixed $rows, string $key, mixed $value): ?array
    {
        foreach (is_array($rows) ? $rows : [] as $row) {
            if (is_array($row) && ($row[$key] ?? null) === $value) {
                return $row;
            }
        }

        return null;
    }

    private function commerce(Request $r): void
    {
        BuyerCommerceRestriction::assertAllowed(app(BuyerProfiles::class)->idFor($r));
    }

    /** @param array<string, mixed> $input
     * @return array<string, mixed> */
    public function edit(Request $r, string $packageId, string $id, array $input): array
    {
        $this->commerce($r);
        [$w, $a] = $this->owned($r, $packageId, $id);
        $view = $this->show($r, $packageId, $id);
        $line = DB::table('work_package_lines')->where('work_package_version_id', $w->current_version_id)->where('id', $input['line_id'] ?? null)->first();
        $newItems = null;
        if (isset($input['option_id'])) {
            $member = self::find($view['vendors'], 'vendor_id', $input['vendor_id']);
            if ($member === null || $member['candidate_id'] === null) {
                throw new AuthenticationException('SPECIFICATION_OPTION_INVALID', 'Choose a current supplier specification option.', 422);
            }
            $snapshot = $this->estimates->withSelections($r, $packageId, $member['candidate_id'], [$input['line_id'] => $input['option_id']]);
            $selected = self::find($snapshot['lines'], 'line_id', $input['line_id']);
            $newItems = [];
            foreach ($selected['allocations'] as $allocation) {
                $newItems[] = array_merge($selected, $allocation, ['line_id' => $input['line_id'], 'vendor_id' => $input['vendor_id'], 'display_name' => $allocation['description'],
                    'quantity' => $allocation['matched_quantity'], 'line_total_centavos' => $allocation['amount_centavos'], 'satisfies_requirement' => true, 'fulfillment_method' => $member['fulfillment_method']]);
            }
        }
        DB::transaction(function () use ($r, $packageId, $id, $input, $view, $line, $newItems): void {
            [$current, $arrangement] = $this->owned($r, $packageId, $id, true);
            $this->assertEditable($r, $current, $arrangement, (int) $input['version']);
            $preferences = json_decode($arrangement->preferences, true);
            if (isset($input['fulfillment_method'])) {
                $member = DB::table('project_arrangement_vendors')->where('arrangement_id', $id)->where('vendor_organization_id', $input['vendor_id'])->first();
                $this->assertMemberEditable($member);
                $group = self::find($view['vendors'], 'vendor_id', $input['vendor_id']);
                if ($group === null || ! in_array($input['fulfillment_method'], $group['fulfillment_options'], true)) {
                    throw new AuthenticationException('FULFILLMENT_NOT_OFFERED', 'Choose an available method for all products from this supplier.', 422);
                }
                DB::table('project_arrangement_vendors')->where('id', $member->id)->update(['fulfillment_method' => $input['fulfillment_method'], 'updated_at' => now()]);
            } elseif ($line === null) {
                throw new AuthenticationException('WORK_PACKAGE_LINE_NOT_FOUND', 'Choose a material from this Work Package.', 404);
            } elseif ($newItems !== null) {
                $this->retireLine($id, $input['line_id'], $input['vendor_id']);
                $otherQuantity = '0';
                foreach ($view['vendors'] as $other) {
                    if ($other['vendor_id'] !== $input['vendor_id']) {
                        foreach ($other['items'] as $item) {
                            if ($item['line_id'] === $line->id) {
                                $otherQuantity = bcadd($otherQuantity, $item['quantity'], 4);
                            }
                        }
                    }
                }
                $remaining = bcsub((string) $line->quantity, $otherQuantity, 4);
                foreach ($newItems as $item) {
                    $item['quantity'] = bccomp($remaining, $item['quantity'], 4) < 0 ? $remaining : $item['quantity'];
                    if (bccomp($item['quantity'], '0', 4) <= 0) {
                        continue;
                    }
                    $item['line_total_centavos'] = Money::lineAmount($item['quantity'], $item['unit_price_centavos']);
                    $remaining = bcsub($remaining, $item['quantity'], 4);
                    $member = $this->member($id, $item['vendor_id'], $item['fulfillment_method']);
                    $this->insertItem($id, $member, $item);
                }
                $preferences['choices'][$input['vendor_id']][$input['line_id']] = $input['option_id'];
            } elseif (($input['remove'] ?? false) === true) {
                $row = DB::table('project_arrangement_items')->where('arrangement_id', $id)->where('id', $input['item_id'])->where('work_package_line_id', $line->id)->whereNull('removed_at')->first();
                if ($row === null) {
                    throw new AuthenticationException('PROJECT_DRAFT_CHANGED', 'Refresh the selected material before removing it.', 409);
                }
                $this->assertMemberEditable(DB::table('project_arrangement_vendors')->where('id', $row->arrangement_vendor_id)->first());
                DB::table('project_arrangement_items')->where('id', $row->id)->update(['removed_at' => now(), 'updated_at' => now()]);
                $preferences['excluded'][$line->id] = true;
            } else {
                $method = $input['method'] ?? 'PICKUP';
                $item = $this->draft->offer($current, $input['variant_id'], $method);
                $this->assertVendor($item['vendor_id']);
                if ($item['material_id'] !== $line->material_id || $item['unit_id'] !== $line->unit_id || $item['source_price_version_id'] !== $input['price_version_id']) {
                    throw new AuthenticationException('ALTERNATIVE_NOT_COMPATIBLE', 'Refresh an offer for the same material and unit.', 409);
                }
                $memberId = $this->member($id, $item['vendor_id'], $item['fulfillment_method']);
                $this->assertMemberEditable(DB::table('project_arrangement_vendors')->where('id', $memberId)->first());
                $needed = (string) (self::find($view['coverage']['lines'], 'line_id', $line->id)['remaining_quantity'] ?? '0');
                if ($input['replace_item'] ?? false) {
                    $old = DB::table('project_arrangement_items')->where('arrangement_id', $id)->where('id', $input['item_id'] ?? null)->where('work_package_line_id', $line->id)->whereNull('removed_at')->first();
                    if ($old === null) {
                        throw new AuthenticationException('PROJECT_DRAFT_CHANGED', 'Choose the material selection to replace.', 409);
                    }
                    $this->assertMemberEditable(DB::table('project_arrangement_vendors')->where('id', $old->arrangement_vendor_id)->first());
                    DB::table('project_arrangement_items')->where('id', $old->id)->update(['removed_at' => now(), 'updated_at' => now()]);
                    $needed = bcadd($needed, (string) $old->quantity, 4);
                }
                $allocated = '0';
                foreach (DB::table('project_arrangement_items as i')->join('project_arrangement_vendors as m', 'm.id', '=', 'i.arrangement_vendor_id')->leftJoin('orders as o', 'o.id', '=', 'm.order_id')
                    ->where('i.arrangement_id', $id)->where('i.listing_variant_id', $item['variant_id'])->whereNull('i.removed_at')->where(fn ($q) => $q->whereNull('o.id')->orWhereNotIn('o.order_state', OrderStates::CLOSED_BEFORE_FULFILLMENT))->get(['i.quantity']) as $old) {
                    $allocated = bcadd($allocated, (string) $old->quantity, 4);
                }
                $available = bcsub($item['_available'], $allocated, 4);
                $quantity = bcadd(bccomp($needed, $available, 4) <= 0 ? $needed : $available, '0', $item['unit_precision']);
                if (bccomp($quantity, '0', 4) <= 0) {
                    throw new AuthenticationException('QUANTITY_ALREADY_COVERED', 'Remove a selection to change supplier, or refresh availability.', 409);
                }
                $duplicate = DB::table('project_arrangement_items')->where('arrangement_id', $id)->where('work_package_line_id', $line->id)->where('listing_variant_id', $item['variant_id'])->whereNull('removed_at')->first();
                if ($duplicate !== null) {
                    $oldMember = DB::table('project_arrangement_vendors')->where('id', $duplicate->arrangement_vendor_id)->first();
                    if ($oldMember->order_id === null || ! in_array(DB::table('orders')->where('id', $oldMember->order_id)->value('order_state'), OrderStates::CLOSED_BEFORE_FULFILLMENT, true)) {
                        throw new AuthenticationException('QUANTITY_ALREADY_SELECTED', 'This product is already selected for this requirement. Remove it before choosing it again.', 409);
                    }
                    DB::table('project_arrangement_items')->where('id', $duplicate->id)->update(['removed_at' => now(), 'updated_at' => now()]);
                }
                $item += ['line_id' => (string) $line->id, 'quantity' => $quantity, 'line_total_centavos' => Money::lineAmount($quantity, $item['unit_price_centavos']),
                    'satisfies_requirement' => ($line->preferred_brand === null || $line->preferred_brand === $item['brand']) && SpecificationMatch::satisfies(json_decode($line->specifications ?? '{}', true), $item['offered_specifications'])];
                $this->insertItem($id, $memberId, $item);
                $preferences['choices'][$item['vendor_id']][$line->id] = 'PRODUCT:'.$item['variant_id'];
            }
            DB::table('project_procurement_arrangements')->where('id', $id)->update(['preferences' => json_encode($preferences, JSON_THROW_ON_ERROR), 'lock_version' => $arrangement->lock_version + 1, 'updated_at' => now()]);
            $this->projects->record($r, 'PROJECT_ARRANGEMENT_UPDATED', $id);
        });

        return $this->show($r, $packageId, $id);
    }

    private function assertEditable(Request $r, object $w, object $a, int $version): void
    {
        if ($this->projects->project($r, $w->project_id)->status !== 'ACTIVE' || in_array($w->status, ['DRAFT', 'CANCELLED', 'COMPLETED'], true)
            || ($w->selected_arrangement_id === null && $w->selected_vendor_organization_id !== null)
            || ($w->selected_arrangement_id !== null && $w->selected_arrangement_id !== $a->id) || (int) $a->lock_version !== $version) {
            throw new AuthenticationException('PROJECT_ARRANGEMENT_CHANGED', 'Refresh the Work Package arrangement before continuing.', 409);
        }
    }

    private function assertMemberEditable(?object $m): void
    {
        if ($m === null || ($m->order_id !== null && ! in_array(DB::table('orders')->where('id', $m->order_id)->value('order_state'), OrderStates::CLOSED_BEFORE_FULFILLMENT, true))
            || ($m->conversation_id !== null && DB::table('quotations')->where('conversation_id', $m->conversation_id)->whereIn('state', ['DRAFT', 'PUBLISHED', 'VIEWED', 'COUNTERED', 'ACCEPTED', 'STOCK_REVALIDATION_REQUIRED'])->exists())) {
            throw new AuthenticationException('PROJECT_MEMBER_LOCKED', 'This supplier already has a request or published terms. Use its quotation or order revision and cancellation flow.', 409);
        }
    }

    private function failed(object $m): bool
    {
        if ($m->order_id !== null) {
            return in_array(DB::table('orders')->where('id', $m->order_id)->value('order_state'), OrderStates::CLOSED_BEFORE_FULFILLMENT, true);
        }

        if ($m->conversation_id === null) {
            return false;
        }
        $quotation = DB::table('quotations')->where('conversation_id', $m->conversation_id)->first();

        return $quotation !== null && (in_array($quotation->state, ['REJECTED', 'WITHDRAWN', 'EXPIRED'], true)
            || (in_array($quotation->state, ['PUBLISHED', 'VIEWED', 'COUNTERED'], true) && $quotation->response_due_at !== null && now()->greaterThanOrEqualTo($quotation->response_due_at)));
    }

    private function retireLine(string $id, string $line, string $vendor): void
    {
        $rows = DB::table('project_arrangement_items')->where('arrangement_id', $id)->where('work_package_line_id', $line)->whereNull('removed_at')
            ->whereIn('arrangement_vendor_id', DB::table('project_arrangement_vendors')->select('id')->where('arrangement_id', $id)->where('vendor_organization_id', $vendor))->get();
        foreach ($rows as $row) {
            $this->assertMemberEditable(DB::table('project_arrangement_vendors')->where('id', $row->arrangement_vendor_id)->first());
        }
        DB::table('project_arrangement_items')->whereIn('id', $rows->pluck('id')->all())->update(['removed_at' => now(), 'updated_at' => now()]);
    }

    private function assertVendor(string $vendor): void
    {
        if (! DB::table('store_profiles')->where('vendor_organization_id', $vendor)->where('bulk_capability', true)->where('vacation_mode', false)->exists()
            || ! app(OrderEligibility::class)->onlinePaymentReady($vendor)) {
            throw new AuthenticationException('PROJECT_VENDOR_INELIGIBLE', 'Choose a currently eligible Project-Based supplier.', 409);
        }
    }

    /** @param array<string, mixed> $input
     * @return array<string, mixed> */
    public function submit(Request $r, string $packageId, string $id, array $input): array
    {
        $this->commerce($r);
        [$w] = $this->owned($r, $packageId, $id);
        $keys = app(CatalogAccess::class);
        $key = $keys->requireIdempotencyKey($r);
        if ($keys->replayed($r, 'PROJECT_ARRANGEMENT_SUBMIT', $key, $id)) {
            return $this->show($r, $packageId, $id);
        }
        $view = $this->show($r, $packageId, $id); // Route work is outside all locks.
        DB::transaction(function () use ($r, $packageId, $id, $input, $keys, $key, $view): void {
            $initial = $this->projects->package($r, $packageId);
            DB::table('projects')->where('id', $initial->project_id)->lockForUpdate()->first();
            [$w, $a] = $this->owned($r, $packageId, $id, true);
            if ($keys->replayed($r, 'PROJECT_ARRANGEMENT_SUBMIT', $key, $id)) {
                return;
            }
            $this->assertEditable($r, $w, $a, (int) $input['version']);
            if ($view['stale'] || ! hash_equals($view['fingerprint'], $input['fingerprint']) || $view['vendors'] === [] || $view['issues'] !== []) {
                throw new AuthenticationException('PROJECT_ARRANGEMENT_CHANGED', 'Review current materials, specifications and delivery before submitting.', 409);
            }
            $methods = array_column($input['payments'], 'payment_method', 'vendor_id');
            $vendors = array_column($view['vendors'], 'vendor_id');
            sort($vendors);
            DB::table('vendor_organizations')->whereIn('id', $vendors)->orderBy('id')->lockForUpdate()->get(['id']);
            $amount = 0;
            foreach ($view['vendors'] as $g) {
                if (($g['order_id'] !== null && (int) DB::table('orders')->where('id', $g['order_id'])->value('lock_version') !== $g['order_lock_version'])
                    || ($g['conversation_id'] !== null && DB::table('quotations')->where('conversation_id', $g['conversation_id'])->value('current_version_id') !== $g['quotation_version_id'])) {
                    throw new AuthenticationException('PROJECT_ARRANGEMENT_CHANGED', 'A supplier confirmation or quotation changed. Review its current terms before submitting.', 409);
                }
                if (! $g['accepted']) {
                    $amount += $g['projected_total_centavos'] ?? $g['materials_centavos'];
                }
                if ($g['requested'] && ($g['order_state'] === null || ! in_array($g['order_state'], OrderStates::CLOSED_BEFORE_FULFILLMENT, true))) {
                    continue;
                }
                $this->assertVendor($g['vendor_id']);
                if (! isset($methods[$g['vendor_id']])) {
                    throw new AuthenticationException('PAYMENT_METHOD_REQUIRED', 'Choose a supported payment method for every supplier.', 422);
                }
                app(PaymentMethodPolicy::class)->assertAllowed($g['vendor_id'], $g['fulfillment_method'], $methods[$g['vendor_id']]);
                foreach ($g['items'] as $item) {
                    $live = $this->draft->offer($w, $item['variant_id'], $g['fulfillment_method']);
                    $quantity = array_reduce(array_filter($g['items'], static fn (array $i): bool => $i['variant_id'] === $item['variant_id']), static fn (string $sum, array $i): string => bcadd($sum, $i['quantity'], 4), '0');
                    if ($live['source_price_version_id'] !== $item['source_price_version_id'] || $live['publication_version'] !== $item['publication_version'] || bccomp($live['_available'], $quantity, 4) < 0) {
                        throw new AuthenticationException('PROJECT_ARRANGEMENT_CHANGED', 'Price, product details or availability changed. Review the supplier again.', 409);
                    }
                }
            }
            app(ProjectBudget::class)->guard($r, $w, $amount, $input);
            foreach ($view['vendors'] as $g) {
                $m = DB::table('project_arrangement_vendors')->where('arrangement_id', $id)->where('vendor_organization_id', $g['vendor_id'])->first();
                if ($m->requested_at !== null && ($m->order_id === null || ! in_array(DB::table('orders')->where('id', $m->order_id)->value('order_state'), OrderStates::CLOSED_BEFORE_FULFILLMENT, true))) {
                    continue;
                }
                $quote = $m->conversation_id === null ? null : DB::table('quotations')->where('conversation_id', $m->conversation_id)->whereIn('state', ['DRAFT', 'PUBLISHED', 'VIEWED', 'COUNTERED', 'STOCK_REVALIDATION_REQUIRED'])->first();
                $orderId = null;
                if ($quote === null) {
                    $s = $this->supplierSnapshot($w, $g, $methods[$g['vendor_id']]);
                    $orderId = (string) Str::uuid7();
                    $order = app(ProjectInquiryService::class)->createRequest($r, $w, $s, $input, $orderId, $g['candidate_id'], $id, $m->id);
                    app(OrderNotifier::class)->vendor($order, 'Project group request '.$order->reference, 'Review your assigned Work Package materials and confirm availability, final terms and delivery.');
                }
                DB::table('project_arrangement_vendors')->where('id', $m->id)->update(['order_id' => $orderId, 'requested_at' => now(), 'updated_at' => now()]);
            }
            DB::table('project_procurement_arrangements')->where('id', $id)->update(['submitted_at' => $a->submitted_at ?? now(), 'lock_version' => $a->lock_version + 1, 'updated_at' => now()]);
            DB::table('work_packages')->where('id', $w->id)->update(['selected_arrangement_id' => $id, 'selected_vendor_organization_id' => count($view['vendors']) === 1 ? $view['vendors'][0]['vendor_id'] : null,
                'status' => 'VENDOR_SELECTED', 'lock_version' => $w->lock_version + 1, 'updated_at' => now()]);
            app(ProjectInquiryService::class)->acceptedMissing(DB::table('work_packages')->where('id', $w->id)->first(), []);
            $this->projects->record($r, 'PROJECT_ARRANGEMENT_SUBMITTED', $id);
            app(QuotationService::class)->expireForPackage((string) $w->id, null, $id);
            $keys->claim($r, 'PROJECT_ARRANGEMENT_SUBMIT', $key, $id, 201);
        });

        return $this->show($r, $packageId, $id);
    }

    /** @param array<string, mixed> $g
     * @return array<string, mixed> */
    public function supplierSnapshot(object $w, array $g, string $payment = 'ONLINE'): array
    {
        $content = json_decode((string) DB::table('work_package_versions')->where('id', $w->current_version_id)->value('content'), true);
        $lines = [];
        foreach ($g['items'] as $item) {
            $requirement = self::find($content['lines'], 'id', $item['line_id']);
            $lines[] = array_merge($item, ['name' => $item['display_name'], 'matched_quantity' => $item['quantity'], 'amount_centavos' => $item['line_total_centavos'],
                'included_vat_centavos' => Money::includedVat($item['line_total_centavos'], $item['tax_category']), 'specifications' => $requirement['specifications']]);
        }

        return ['vendor_id' => $g['vendor_id'], 'lines' => $lines, 'fulfillment_method' => $g['fulfillment_method'], 'payment_method' => $payment,
            'destination' => ProjectEstimateService::concrete($content, $g['fulfillment_method'])['destination'], 'materials_centavos' => $g['materials_centavos'],
            'projected_total_centavos' => $g['projected_total_centavos'], 'delivery_centavos' => $g['delivery_centavos'], 'delivery' => $g['delivery']];
    }

    /** @return array<string, mixed> */
    public function inquire(Request $r, string $packageId, string $id, string $vendorId, int $version): array
    {
        $this->commerce($r);
        [$w] = $this->owned($r, $packageId, $id);
        $view = $this->show($r, $packageId, $id);
        $g = self::find($view['vendors'], 'vendor_id', $vendorId);
        if ($view['stale'] || $g === null || $g['issues'] !== []) {
            throw new AuthenticationException('PROJECT_ARRANGEMENT_CHANGED', 'Review the supplier allocation before opening its quotation inquiry.', 409);
        }
        DB::transaction(function () use ($r, $packageId, $id, $vendorId, $version, $g): void {
            [$w, $a] = $this->owned($r, $packageId, $id, true);
            $this->assertEditable($r, $w, $a, $version);
            $member = DB::table('project_arrangement_vendors')->where('arrangement_id', $id)->where('vendor_organization_id', $vendorId)->first();
            if ($member->conversation_id !== null) {
                return;
            }
            if ($member->order_id !== null) {
                throw new AuthenticationException('PROJECT_MEMBER_HAS_ORDER', 'Continue in this supplier order and its fulfillment messages.', 409);
            }
            $this->assertVendor($vendorId);
            $v = DB::table('work_package_versions')->where('id', $w->current_version_id)->first();
            $content = json_decode($v->content, true);
            $s = $this->supplierSnapshot($w, $g);
            $duplicate = ProjectInquiryService::duplicate($s);
            $conversation = (string) Str::uuid7();
            $reference = ['version_id' => $v->id, 'version' => (int) $v->version, 'content_hash' => $v->content_hash, 'work_package' => $content, 'system_estimate' => $s,
                'working_duplicate' => $duplicate, 'destination' => $s['destination'], 'lines' => $content['lines'], 'arrangement_id' => $id, 'arrangement_vendor_id' => $member->id,
                'vendor_allocations' => array_map(static fn (array $i): array => ['line_id' => $i['line_id'], 'variant_id' => $i['variant_id'], 'material_id' => $i['material_id'], 'name' => $i['display_name'],
                    'quantity' => $i['quantity'], 'unit_id' => $i['unit_id'], 'unit_code' => $i['unit_code'], 'specifications' => $i['offered_specifications']], $g['items'])];
            app(ConversationService::class)->createProject($r, $conversation, $vendorId, $packageId, $reference);
            DB::table('quotations')->insert(['id' => (string) Str::uuid7(), 'conversation_id' => $conversation, 'buyer_profile_id' => DB::table('projects')->where('id', $w->project_id)->value('buyer_profile_id'),
                'vendor_organization_id' => $vendorId, 'procurement_type' => 'PROJECT_BASED', 'work_package_id' => $packageId, 'state' => 'DRAFT', 'draft' => json_encode($duplicate, JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
            DB::table('project_arrangement_vendors')->where('id', $member->id)->update(['conversation_id' => $conversation, 'updated_at' => now()]);
            $this->projects->record($r, 'PROJECT_ARRANGEMENT_INQUIRY_CREATED', $id);
        });

        return $this->show($r, $packageId, $id);
    }
}
