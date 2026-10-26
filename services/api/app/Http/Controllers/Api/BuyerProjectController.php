<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Catalog\EligibleOfferQuery;
use App\Domain\Catalog\MaterialSearch;
use App\Domain\Catalog\QuantityPolicy;
use App\Domain\Geography\BuyerProfiles;
use App\Domain\Geography\RadiusPolicy;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Projects\FulfillmentMatchScore;
use App\Domain\Projects\ProjectArrangements;
use App\Domain\Projects\ProjectEstimateService;
use App\Domain\Projects\ProjectInquiryService;
use App\Domain\Projects\ProjectProcurementDraft;
use App\Domain\Projects\ProjectService;
use App\Domain\Projects\SpecificationMatch;
use App\Domain\Projects\WorkPackageAlternatives;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use App\Http\Requests\Projects\WorkPackageRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

final class BuyerProjectController extends Controller
{
    public function __construct(private readonly ProjectService $projects) {}

    public function index(Request $r): JsonResponse
    {
        $this->page($r);

        return ApiResponse::success($this->projects->index($r));
    }

    public function show(Request $r, string $projectId): JsonResponse
    {
        $this->page($r);

        return ApiResponse::success($this->projects->show($r, $projectId));
    }

    public function packageShow(Request $r, string $packageId): JsonResponse
    {
        $this->page($r);

        return ApiResponse::success($this->projects->packageShow($r, $packageId));
    }

    public function create(Request $r): JsonResponse
    {
        $input = $r->validate(['name' => ['required', 'string', 'max:150'], 'budget_centavos' => ['required', 'integer', 'between:0,100000000000'], 'starts_on' => ['required', 'date_format:Y-m-d'],
            'ends_on' => ['required', 'date_format:Y-m-d', 'after_or_equal:starts_on'], 'location_id' => ['required', 'uuid']]);

        return ApiResponse::success($this->projects->show($r, $this->projects->create($r, $input)), [], 201);
    }

    public function update(Request $r, string $projectId): JsonResponse
    {
        $input = $r->validate(['lock_version' => ['required', 'integer', 'min:1'], 'name' => ['sometimes', 'string', 'max:150'], 'budget_centavos' => ['sometimes', 'integer', 'between:0,100000000000'],
            'starts_on' => ['sometimes', 'date_format:Y-m-d'], 'ends_on' => ['sometimes', 'date_format:Y-m-d'], 'location_id' => ['sometimes', 'uuid'], 'status' => ['sometimes', 'in:ACTIVE,COMPLETED,ARCHIVED']]);
        $p = $this->projects->project($r, $projectId);
        if (($input['ends_on'] ?? $p->ends_on) < ($input['starts_on'] ?? $p->starts_on)) {
            throw new AuthenticationException('VALIDATION_FAILED', 'The end date must be on or after the start date.', 422);
        }
        $this->projects->update($r, $projectId, $input);

        return ApiResponse::success($this->projects->show($r, $projectId));
    }

    public function savePackage(WorkPackageRequest $r, string $projectId): JsonResponse
    {
        return ApiResponse::success($this->projects->packageShow($r, $this->projects->savePackage($r, $projectId, null, $r->validated())), [], 201);
    }

    public function editPackage(WorkPackageRequest $r, string $packageId): JsonResponse
    {
        $input = $r->validated();
        if (! isset($input['lock_version'])) {
            throw new AuthenticationException('VERSION_REQUIRED', 'Provide the current version.', 422);
        }
        $w = $this->projects->package($r, $packageId);
        $this->projects->savePackage($r, $w->project_id, $packageId, $input);

        return ApiResponse::success($this->projects->packageShow($r, $packageId));
    }

    public function activate(Request $r, string $packageId): JsonResponse
    {
        $input = $r->validate(['lock_version' => ['required', 'integer', 'min:1']]);
        $this->projects->activate($r, $packageId, $input['lock_version']);

        return ApiResponse::success($this->projects->packageShow($r, $packageId));
    }

    public function reactivate(Request $r, string $packageId): JsonResponse
    {
        $input = $r->validate(['lock_version' => ['required', 'integer', 'min:1']]);
        $this->projects->reactivate($r, $packageId, $input['lock_version']);

        return ApiResponse::success($this->projects->packageShow($r, $packageId));
    }

    public function estimates(Request $r, string $packageId, ProjectEstimateService $estimates): JsonResponse
    {
        $this->page($r);
        $r->validate(['sort' => ['sometimes', 'in:BEST_MATCH,BUDGET_FIT,RATING,PRICE'], 'direction' => ['sometimes', 'in:ASC,DESC'], 'favorites_only' => ['sometimes', 'in:0,1,true,false'],
            'complete_only' => ['sometimes', 'in:0,1,true,false'], 'within_budget' => ['sometimes', 'in:0,1,true,false']]);

        return ApiResponse::success($estimates->show($r, $packageId, null, ['sort' => (string) $r->query('sort', 'BEST_MATCH'), 'direction' => $r->query('direction'),
            'favorites_only' => $r->boolean('favorites_only'), 'complete_only' => $r->boolean('complete_only'), 'within_budget' => $r->boolean('within_budget')]));
    }

    public function arrangementOptions(Request $r, string $packageId, ProjectArrangements $arrangements): JsonResponse
    {
        $this->page($r);
        $r->validate(['sort' => ['sometimes', 'in:BEST_MATCH,PRICE'], 'direction' => ['sometimes', 'in:ASC,DESC'],
            'favorites_only' => ['sometimes', 'in:0,1,true,false'], 'complete_only' => ['sometimes', 'in:0,1,true,false'], 'within_budget' => ['sometimes', 'in:0,1,true,false']]);

        return ApiResponse::success($arrangements->options($r, $packageId));
    }

    public function createArrangement(Request $r, string $packageId, ProjectArrangements $arrangements): JsonResponse
    {
        $input = $r->validate(['source_candidate_id' => ['required', 'uuid'], 'proposal_token' => ['sometimes', 'string', 'max:200000']]);

        return ApiResponse::success($arrangements->create($r, $packageId, $input['source_candidate_id'], $input['proposal_token'] ?? null), [], 201);
    }

    public function arrangementShow(Request $r, string $packageId, string $arrangementId, ProjectArrangements $arrangements): JsonResponse
    {
        return ApiResponse::success($arrangements->show($r, $packageId, $arrangementId));
    }

    public function editArrangement(Request $r, string $packageId, string $arrangementId, ProjectArrangements $arrangements): JsonResponse
    {
        $input = $r->validate(['version' => ['required', 'integer', 'min:1'], 'vendor_id' => ['sometimes', 'uuid'], 'line_id' => ['required_without:fulfillment_method', 'uuid'],
            'fulfillment_method' => ['sometimes', 'in:DELIVERY,PICKUP'], 'method' => ['sometimes', 'in:DELIVERY,PICKUP'], 'option_id' => ['sometimes', 'string', 'max:200'],
            'item_id' => ['required_if:remove,true', 'required_if:replace_item,true', 'uuid'], 'remove' => ['sometimes', 'boolean'], 'replace_item' => ['sometimes', 'boolean'],
            'variant_id' => ['required_without_all:fulfillment_method,option_id,item_id', 'uuid'], 'price_version_id' => ['required_with:variant_id', 'uuid']]);
        if ((isset($input['fulfillment_method']) || isset($input['option_id'])) && ! isset($input['vendor_id'])) {
            throw new AuthenticationException('VENDOR_REQUIRED', 'Choose a supplier from this arrangement.', 422);
        }

        return ApiResponse::success($arrangements->edit($r, $packageId, $arrangementId, $input));
    }

    public function submitArrangement(Request $r, string $packageId, string $arrangementId, ProjectArrangements $arrangements): JsonResponse
    {
        $input = $r->validate(['version' => ['required', 'integer', 'min:1'], 'fingerprint' => ['required', 'string', 'size:64'],
            'payments' => ['required', 'array', 'min:1', 'max:100'], 'payments.*.vendor_id' => ['required', 'uuid', 'distinct'], 'payments.*.payment_method' => ['required', 'in:ONLINE,CASH_ON_DELIVERY,IN_STORE'],
            'acknowledged' => ['required', 'accepted'], 'note' => ['nullable', 'string', 'max:2000'], 'budget_override_reason' => ['nullable', 'string', 'min:10', 'max:2000']]);

        return ApiResponse::success($arrangements->submit($r, $packageId, $arrangementId, $input), [], 201);
    }

    public function arrangementInquiry(Request $r, string $packageId, string $arrangementId, string $vendorId, ProjectArrangements $arrangements): JsonResponse
    {
        $input = $r->validate(['version' => ['required', 'integer', 'min:1']]);

        return ApiResponse::success($arrangements->inquire($r, $packageId, $arrangementId, $vendorId, $input['version']));
    }

    public function alternatives(Request $r, string $packageId, string $lineId, WorkPackageAlternatives $alternatives): JsonResponse
    {
        $input = $r->validate(['page' => ['sometimes', 'integer', 'between:1,1000'], 'exclude_vendor_id' => ['sometimes', 'nullable', 'uuid'], 'candidate_id' => ['sometimes', 'nullable', 'uuid'],
            'fulfillment_method' => ['sometimes', 'in:PICKUP,DELIVERY'], 'arrangement_id' => ['sometimes', 'uuid'], 'replace' => ['sometimes', 'in:0,1,true,false'], 'specification_choices' => ['sometimes', 'string', 'json', 'max:15000']]);
        $choices = Validator::make(['selections' => json_decode($input['specification_choices'] ?? '[]', true)], self::SELECTION_RULES)->validate();

        return ApiResponse::success($alternatives->list($r, $packageId, $lineId, $input['exclude_vendor_id'] ?? null, (int) ($input['page'] ?? 1), $input['candidate_id'] ?? null,
            ProjectInquiryService::selections($choices), $input['fulfillment_method'] ?? null, $input['arrangement_id'] ?? null, $r->boolean('replace')));
    }

    public function compile(Request $r, string $packageId, ProjectEstimateService $estimates): JsonResponse
    {
        $input = $r->validate(['lock_version' => ['required', 'integer', 'min:1'], 'radius_km' => ['sometimes', 'integer', 'in:'.RadiusPolicy::PROJECT_BASED_KM]]);

        return ApiResponse::success($estimates->compile($r, $packageId, $input['lock_version']));
    }

    public function inquire(Request $r, string $packageId, ProjectInquiryService $inquiries): JsonResponse
    {
        $input = $r->validate(['lock_version' => ['required', 'integer', 'min:1'], 'candidate_id' => ['required', 'uuid']] + self::SELECTION_RULES);

        return ApiResponse::success(['id' => $inquiries->inquire($r, $packageId, $input)], [], 201);
    }

    public function select(Request $r, string $packageId, ProjectInquiryService $inquiries): JsonResponse
    {
        $input = $r->validate(['lock_version' => ['required', 'integer', 'min:1'], 'candidate_id' => ['required', 'uuid'], 'payment_method' => ['required', 'in:ONLINE,CASH_ON_DELIVERY,IN_STORE'], 'note' => ['nullable', 'string', 'max:2000'], 'budget_override_reason' => ['nullable', 'string', 'min:10', 'max:2000']] + self::SELECTION_RULES);

        return ApiResponse::success(['id' => $inquiries->select($r, $packageId, $input)], [], 201);
    }

    public function route(Request $r, string $packageId, string $candidateId, ProjectEstimateService $estimates): JsonResponse
    {
        return ApiResponse::success($estimates->route($r, $packageId, $candidateId));
    }

    public function preferences(Request $r): JsonResponse
    {
        return ApiResponse::success(FulfillmentMatchScore::preferences(app(BuyerProfiles::class)->idFor($r)));
    }

    public function savePreferences(Request $r): JsonResponse
    {
        $input = $r->validate(['version' => ['required', 'integer', 'min:0'], 'weights' => ['required', 'array']]);
        $weights = FulfillmentMatchScore::validate($input['weights']);

        return $this->writePreferences($r, $input['version'], $weights);
    }

    public function resetPreferences(Request $r): JsonResponse
    {
        $input = $r->validate(['version' => ['required', 'integer', 'min:0']]);

        return $this->writePreferences($r, $input['version'], null);
    }

    /** @param array<string, int>|null $weights */
    private function writePreferences(Request $r, int $version, ?array $weights): JsonResponse
    {
        $buyer = app(BuyerProfiles::class)->idFor($r);
        DB::transaction(function () use ($r, $buyer, $version, $weights): void {
            DB::table('buyer_profiles')->where('id', $buyer)->lockForUpdate()->first();
            $row = DB::table('buyer_ranking_preferences')->where('buyer_profile_id', $buyer)->where('procurement_type', 'PROJECT_BASED')->lockForUpdate()->first();
            if ((int) ($row->version ?? 0) !== $version) {
                throw new AuthenticationException('PREFERENCE_VERSION_CONFLICT', 'Review the latest Project-Based weights.', 409);
            }
            $effective = $weights ?? FulfillmentMatchScore::preferences($buyer)['default_weights'];
            DB::table('buyer_ranking_preferences')->updateOrInsert(['buyer_profile_id' => $buyer, 'procurement_type' => 'PROJECT_BASED'],
                ['id' => $row->id ?? (string) Str::uuid7(), 'weights' => json_encode($effective, JSON_THROW_ON_ERROR), 'is_personalized' => $weights !== null,
                    'version' => $version + 1, 'updated_by_user_id' => $r->user()->id, 'created_at' => $row->created_at ?? now(), 'updated_at' => now()]);
            $this->projects->record($r, 'PROJECT_RANKING_PREFERENCES_UPDATED', $buyer);
        });

        return $this->preferences($r);
    }

    public function missing(Request $r, string $packageId, string $lineId): JsonResponse
    {
        $input = $r->validate(['lock_version' => ['required', 'integer', 'min:1'], 'order_id' => ['nullable', 'uuid'], 'reason' => ['required_without:order_id', 'nullable', 'string', 'min:10', 'max:2000'], 'budget_override_reason' => ['nullable', 'string', 'min:10', 'max:2000']]);
        $this->projects->resolveMissing($r, $packageId, $lineId, $input);

        return ApiResponse::success($this->projects->packageShow($r, $packageId));
    }

    public function importPreview(Request $r): JsonResponse
    {
        app(BuyerProfiles::class)->idFor($r);
        $input = $r->validate(['csv' => ['required', 'string', 'max:100000']]);
        $stream = fopen('php://temp', 'r+');
        fwrite($stream, $input['csv']);
        rewind($stream);
        $header = fgetcsv($stream, escape: '');
        if ($header !== ['material_code', 'name', 'unit_code', 'quantity', 'preferred_brand', 'specifications']) {
            fclose($stream);
            throw new AuthenticationException('CSV_HEADER_INVALID', 'Use material_code,name,unit_code,quantity,preferred_brand,specifications. Specifications must be a JSON object.', 422);
        }
        $lines = [];
        $errors = [];
        $number = 1;
        while (($row = fgetcsv($stream, escape: '')) !== false) {
            $number++;
            if ($number > 101 || count($row) !== 6) {
                $errors[] = ['row' => $number, 'message' => 'Use six columns and at most 100 lines.'];
                break;
            }
            $material = DB::table('materials')->where('code', $row[0])->value('id');
            $unit = DB::table('units')->where('code', $row[2])->first();
            $specs = json_decode($row[5], true);
            if ($material === null || $unit === null || trim($row[1]) === '' || ! preg_match('/^\d{1,7}(\.\d{1,4})?$/', $row[3]) || bccomp($row[3], '0', 4) <= 0 || bccomp($row[3], '1000000', 4) > 0 || ! is_array($specs)
                || bccomp($row[3], bcadd($row[3], '0', (int) $unit->precision), 4) !== 0) {
                $errors[] = ['row' => $number, 'message' => 'Check material code, name, normalized unit, positive quantity and specification JSON.'];

                continue;
            }
            if (! str_starts_with(trim($row[5]), '{') || count($specs) > 30 || count(array_filter($specs, 'is_string')) !== count($specs)
                || ! DB::table('material_compatible_units')->where('material_id', $material)->where('unit_id', $unit->id)->exists()) {
                $errors[] = ['row' => $number, 'message' => 'Use compatible units and a specification object containing at most 30 text values.'];

                continue;
            }
            $lines[] = ['material_id' => $material, 'name' => $row[1], 'unit_id' => $unit->id, 'quantity' => $row[3], 'preferred_brand' => trim($row[4]) === '' ? null : $row[4], 'specifications' => (object) $specs];
        }
        fclose($stream);

        return ApiResponse::success(['lines' => $lines, 'validation_errors' => $errors, 'valid' => $errors === [] && $lines !== []]);
    }

    public function close(Request $r, string $packageId): JsonResponse
    {
        $input = $r->validate(['lock_version' => ['required', 'integer', 'min:1']]);
        DB::transaction(function () use ($r, $packageId, $input): void {
            $w = $this->projects->package($r, $packageId, true);
            ProjectService::version($w, $input['lock_version']);
            if ($w->selected_vendor_organization_id !== null) {
                throw new AuthenticationException('ORDER_CANCELLATION_REQUIRED', 'Use the linked order cancellation rules before correcting this package.', 409);
            }
            $this->projects->invalidate($packageId);
            DB::table('work_packages')->where('id', $packageId)->update(['status' => 'CANCELLED', 'lock_version' => $w->lock_version + 1]);
            $this->projects->record($r, 'WORK_PACKAGE_CANCELLED', $packageId);
        });

        return ApiResponse::success($this->projects->packageShow($r, $packageId));
    }

    private function page(Request $r): void
    {
        $r->validate(['page' => ['sometimes', 'integer', 'between:1,10000']]);
    }

    public function materials(Request $r): JsonResponse
    {
        app(BuyerProfiles::class)->idFor($r);
        $input = $r->validate(['query' => ['required', 'string', 'min:2', 'max:100']]);
        $matches = app(MaterialSearch::class)->search($input['query']);
        $attributes = DB::table('technical_attribute_definitions')->whereIn('material_category_id', array_column($matches, 'category_id'))->orderBy('sort_order')->orderBy('code')
            ->get(['material_category_id', 'code', 'label', 'value_type', 'allowed_values', 'unit_code'])->groupBy('material_category_id');
        $offered = $this->offeredValues(array_column($matches, 'id'));
        foreach ($matches as &$match) {
            $match['compatible_units'] = DB::table('material_compatible_units as m')->join('units as u', 'u.id', '=', 'm.unit_id')->where('m.material_id', $match['id'])->orderBy('u.code')->get(['u.id', 'u.code', 'u.name', 'u.dimension', 'u.precision'])->map(QuantityPolicy::present(...))->all();
            // Category technical details the Buyer may state; matching compares them by code.
            $match['attributes'] = ($attributes->get($match['category_id']) ?? collect())->map(static fn (object $a): array => ['code' => $a->code, 'label' => $a->label, 'value_type' => $a->value_type,
                'allowed_values' => $a->allowed_values === null ? null : json_decode($a->allowed_values, true), 'unit_code' => $a->unit_code,
                'offered_values' => $offered[$match['id']][$a->code] ?? []])->values()->all();
        }
        unset($match);

        // Every normalized unit, for a material the Buyer names that is not listed.
        return ApiResponse::success(['items' => $matches, 'units' => DB::table('units')->orderBy('code')->get(['id', 'code', 'name', 'dimension', 'precision'])->map(QuantityPolicy::present(...))->all()]);
    }

    /**
     * Owner request 2026-10-16: values the material's currently eligible, in-stock products are listed with, per
     * detail, so the Buyer can state details that match product information. Public listing facts only; at most
     * twelve per detail, numbers in ascending order.
     *
     * @param  list<string>  $materialIds
     * @return array<string, array<string, list<string>>>
     */
    private function offeredValues(array $materialIds): array
    {
        if ($materialIds === []) {
            return [];
        }
        $seen = [];
        $rows = app(EligibleOfferQuery::class)->variants()->join('products as p', 'p.id', '=', 'l.product_id')->whereIn('p.material_id', $materialIds)
            ->whereRaw('i.quantity_on_hand - i.hard_reserved_quantity > 0')->limit(2000)->get(['p.material_id', 'l.technical_attributes', 'v.attributes']);
        foreach ($rows as $row) {
            foreach (SpecificationMatch::offered($row->technical_attributes, $row->attributes) as $code => $value) {
                $normalized = SpecificationMatch::normalize($value);
                if ($normalized !== '') {
                    $seen[(string) $row->material_id][(string) $code][$normalized] ??= self::isNumber($normalized) ? $normalized : trim((string) $value);
                }
            }
        }
        $result = [];
        foreach ($seen as $material => $codes) {
            foreach ($codes as $code => $values) {
                $values = array_values($values);
                usort($values, static fn (string $a, string $b): int => self::isNumber($a) && self::isNumber($b) ? bccomp($a, $b, 6) : strnatcasecmp($a, $b));
                $result[$material][$code] = array_slice($values, 0, 12);
            }
        }

        return $result;
    }

    private static function isNumber(string $value): bool
    {
        return preg_match('/^\d+(\.\d+)?$/', $value) === 1;
    }

    public function selectionPreview(Request $r, string $packageId, string $candidateId, ProjectEstimateService $estimates): JsonResponse
    {
        $input = $r->validate(self::SELECTION_RULES);

        return ApiResponse::success($estimates->selectionPreview($r, $packageId, $candidateId, ProjectInquiryService::selections($input), $input['fulfillment_method'] ?? null));
    }

    public function saveDraftItem(Request $r, string $packageId, string $candidateId, string $lineId, string $variantId, ProjectProcurementDraft $draft): JsonResponse
    {
        $input = $r->validate(['lock_version' => ['required', 'integer', 'min:1'], 'price_version_id' => ['required', 'uuid']] + self::SELECTION_RULES);
        $draft->change($r, $packageId, $candidateId, $lineId, $variantId, $input, false);

        return ApiResponse::success(['id' => $variantId]);
    }

    public function removeDraftItem(Request $r, string $packageId, string $candidateId, string $lineId, string $variantId, ProjectProcurementDraft $draft): JsonResponse
    {
        $input = $r->validate(['lock_version' => ['required', 'integer', 'min:1']]);
        $draft->change($r, $packageId, $candidateId, $lineId, $variantId, $input, true);

        return ApiResponse::success(['id' => $variantId]);
    }

    public function requestDraftSupplier(Request $r, string $packageId, string $candidateId, string $vendorId, ProjectProcurementDraft $draft): JsonResponse
    {
        $input = $r->validate(['lock_version' => ['required', 'integer', 'min:1'], 'payment_method' => ['required', 'in:ONLINE,CASH_ON_DELIVERY,IN_STORE'],
            'draft_fingerprint' => ['required', 'string', 'size:64'], 'budget_override_reason' => ['nullable', 'string', 'min:10', 'max:2000']]);

        return ApiResponse::success(['id' => $draft->submit($r, $packageId, $candidateId, $vendorId, $input)], [], 201);
    }

    /** One specification option per Work Package line, and the Delivery or Pickup choice for a Vendor offering both. */
    private const SELECTION_RULES = ['selections' => ['sometimes', 'array', 'max:100'], 'selections.*.line_id' => ['required', 'uuid', 'distinct'], 'selections.*.option_id' => ['required', 'string', 'regex:/^[0-9a-f]{16}$/'],
        'fulfillment_method' => ['sometimes', 'in:PICKUP,DELIVERY']];

    public function budgetEstimate(Request $r, string $projectId, ProjectEstimateService $estimates): JsonResponse
    {
        $input = $r->validate(['site_id' => ['required', 'uuid'], 'radius_km' => ['sometimes', 'integer', 'in:'.RadiusPolicy::PROJECT_BASED_KM], 'fulfillment_method' => ['required', 'in:PICKUP,DELIVERY,BOTH'],
            'heavy_vehicle_restriction' => ['sometimes', 'in:NO,YES,UNANSWERED'], 'alternate_drop_off_location_id' => ['sometimes', 'nullable', 'uuid'],
            'lines' => ['required', 'array', 'min:1', 'max:100'], 'lines.*.material_id' => ['nullable', 'uuid'], 'lines.*.unit_id' => ['required', 'uuid'],
            'lines.*.quantity' => ['required', 'regex:/^\d{1,7}(\.\d{1,4})?$/', 'numeric', 'gt:0', 'max:1000000'], 'lines.*.preferred_brand' => ['nullable', 'string', 'max:100'],
            'lines.*.specifications' => ['present', 'array', 'max:30'], 'lines.*.specifications.*' => ['string', 'max:200']]);

        return ApiResponse::success($estimates->budgetEstimate($r, $projectId, $input));
    }

    public function deletePackage(Request $r, string $packageId): JsonResponse
    {
        $input = $r->validate(['lock_version' => ['required', 'integer', 'min:1']]);
        DB::transaction(function () use ($r, $packageId, $input): void {
            $w = $this->projects->package($r, $packageId, true);
            ProjectService::version($w, $input['lock_version']);
            if ($this->projects->hasOrder($w)) {
                throw new AuthenticationException('WORK_PACKAGE_HAS_ORDER', 'This Work Package has an order, so it cannot be deleted. Its records stay available.', 409);
            }
            $retained = $w->status !== 'DRAFT' || DB::table('orders')->where('work_package_id', $w->id)->exists()
                || DB::table('work_package_versions')->where('work_package_id', $w->id)->whereNotNull('locked_at')->exists()
                || DB::table('work_package_version_deletions')->whereIn('work_package_version_id', DB::table('work_package_versions')->select('id')->where('work_package_id', $w->id))->exists();
            if ($retained) {
                // Saved originals, estimates and quotations are commercial records: close them and hide the package instead of removing it.
                $this->projects->invalidate($packageId);
                DB::table('work_packages')->where('id', $w->id)->update(['status' => 'CANCELLED', 'selected_vendor_organization_id' => null, 'deleted_at' => now(), 'lock_version' => $w->lock_version + 1, 'updated_at' => now()]);
                $this->projects->record($r, 'WORK_PACKAGE_DELETED', $packageId);

                return;
            }
            DB::table('work_packages')->where('id', $w->id)->update(['current_version_id' => null]);
            DB::table('project_procurement_draft_exclusions')->whereIn('work_package_version_id', DB::table('work_package_versions')->select('id')->where('work_package_id', $w->id))->delete();
            DB::table('work_package_lines')->whereIn('work_package_version_id', DB::table('work_package_versions')->select('id')->where('work_package_id', $w->id))->delete();
            DB::table('work_package_versions')->where('work_package_id', $w->id)->delete();
            DB::table('work_packages')->where('id', $w->id)->delete();
            $this->projects->record($r, 'WORK_PACKAGE_DRAFT_DELETED', $packageId);
        });

        return ApiResponse::success();
    }

    public function deleteProject(Request $r, string $projectId): JsonResponse
    {
        $input = $r->validate(['lock_version' => ['required', 'integer', 'min:1']]);
        DB::transaction(function () use ($r, $projectId, $input): void {
            $p = $this->projects->project($r, $projectId, true);
            ProjectService::version($p, $input['lock_version']);
            if ($p->status !== 'ACTIVE') {
                throw new AuthenticationException('PROJECT_CLOSED', 'This Project is read-only. Retain its history.', 409);
            }
            if (DB::table('work_packages')->where('project_id', $projectId)->exists()) {
                throw new AuthenticationException('PROJECT_HISTORY_RETAINED', 'Remove editable drafts first. Projects with locked history can be archived.', 409);
            }
            DB::table('project_sites')->where('project_id', $projectId)->delete();
            DB::table('projects')->where('id', $projectId)->delete();
            $this->projects->record($r, 'PROJECT_DELETED', $projectId);
        });

        return ApiResponse::success();
    }
}
