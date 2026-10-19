<?php

declare(strict_types=1);

namespace App\Domain\Projects;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Geography\BuyerProfiles;
use App\Domain\Geography\RadiusPolicy;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Messaging\QuotationService;
use App\Domain\Operations\OutboxPublisher;
use App\Domain\Orders\OrderStates;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class ProjectService
{
    public function __construct(private readonly BuyerProfiles $buyers, private readonly CatalogAccess $keys, private readonly AuditRecorder $audit) {}

    public function project(Request $request, string $id, bool $lock = false): object
    {
        $query = DB::table('projects')->where('id', $id)->where('buyer_profile_id', $this->buyers->idFor($request));
        $row = ($lock ? $query->lockForUpdate() : $query)->first();
        if ($row === null) {
            throw new AuthenticationException('PROJECT_NOT_FOUND', 'This Project is unavailable.', 404);
        }

        return $row;
    }

    public function package(Request $request, string $id, bool $lock = false): object
    {
        $row = DB::table('work_packages')->where('id', $id)->whereNull('deleted_at')->first();
        if ($row === null) {
            throw new AuthenticationException('WORK_PACKAGE_NOT_FOUND', 'This Work Package is unavailable.', 404);
        }
        $project = $this->project($request, $row->project_id, $lock);
        if ($lock && $project->status !== 'ACTIVE') {
            throw new AuthenticationException('PROJECT_CLOSED', 'This Project is read-only. Its procurement history remains available.', 409);
        }

        return $lock ? DB::table('work_packages')->where('id', $id)->lockForUpdate()->first() : $row;
    }

    public static function version(object $row, int $expected): void
    {
        if ((int) $row->lock_version !== $expected) {
            throw new AuthenticationException('PROJECT_VERSION_CONFLICT', 'This record changed. Review the latest version and try again.', 409);
        }
    }

    /** @return array<string, mixed> */
    public function index(Request $request): array
    {
        $page = DB::table('projects')->where('buyer_profile_id', $this->buyers->idFor($request))->orderByDesc('updated_at')->orderBy('id')->paginate(25);

        return ['items' => array_map(fn (object $p): array => $this->summary($p), $page->items()), 'page' => $page->currentPage(), 'has_more' => $page->hasMorePages()];
    }

    /** @return array<string, mixed> */
    public function show(Request $request, string $id): array
    {
        $project = $this->project($request, $id);
        $packages = DB::table('work_packages')->where('project_id', $id)->whereNull('deleted_at')->orderByDesc('updated_at')->orderBy('id')->paginate(25);

        return $this->summary($project) + ['sites' => DB::table('project_sites')->where('project_id', $id)->where('active', true)->orderBy('id')->get()->map(fn (object $s): array => $this->siteView($s))->all(),
            'packages' => ['items' => array_map(fn (object $w): array => $this->packageSummary($w), $packages->items()), 'page' => $packages->currentPage(), 'has_more' => $packages->hasMorePages()]];
    }

    /** @return array<string, mixed> */
    private function summary(object $p): array
    {
        return ['id' => $p->id, 'name' => $p->name, 'status' => $p->status, 'budget_centavos' => (int) $p->budget_centavos, 'starts_on' => $p->starts_on,
            'ends_on' => $p->ends_on, 'lock_version' => (int) $p->lock_version, 'budget' => app(ProjectBudget::class)->metrics($p)];
    }

    /** @return array<string, mixed> */
    public function packageSummary(object $w): array
    {
        $order = $this->currentPackageOrder($w);
        $status = $w->status;
        $vendorOrders = [];
        if ($w->selected_arrangement_id !== null) {
            $all = DB::table('orders')->where('project_arrangement_id', $w->selected_arrangement_id)->orderBy('created_at')->get();
            $active = $all->reject(static fn (object $o): bool => in_array($o->order_state, OrderStates::CLOSED_BEFORE_FULFILLMENT, true));
            $status = match (true) {
                $active->isNotEmpty() && $active->every(static fn (object $o): bool => $o->order_state === 'COMPLETED') && $this->arrangementComplete($w) => 'COMPLETED',
                $active->contains(static fn (object $o): bool => $o->accepted_at !== null && $o->order_state !== 'AWAITING_PAYMENT') => 'IN_PROGRESS',
                $active->contains('order_state', 'AWAITING_PAYMENT') => 'AWAITING_PAYMENT',
                $active->contains(static fn (object $o): bool => $o->order_state !== 'COMPLETED') => 'VENDOR_SELECTED',
                default => 'ACTIVE',
            };
            $vendorOrders = $all->map(static fn (object $o): array => ['id' => $o->id, 'vendor_id' => $o->vendor_organization_id, 'reference' => $o->reference, 'order_state' => $o->order_state])->all();
        } elseif ($order !== null) {
            $status = match (true) {
                in_array($order->order_state, ['CANCELLED', 'DECLINED', 'EXPIRED'], true) => 'CANCELLED',
                $order->order_state === 'COMPLETED' && $this->missingComplete((string) $w->current_version_id) => 'COMPLETED',
                $order->order_state === 'AWAITING_PAYMENT' => 'AWAITING_PAYMENT',
                $order->accepted_at !== null => 'IN_PROGRESS',
                default => 'VENDOR_SELECTED',
            };
        }

        return ['id' => $w->id, 'project_id' => $w->project_id, 'name' => $w->name, 'status' => $status, 'budget_centavos' => (int) $w->budget_centavos,
            'lock_version' => (int) $w->lock_version, 'current_version_id' => $w->current_version_id, 'selected_vendor_id' => $this->hasActiveSelection($w, $order) ? $w->selected_vendor_organization_id : null, 'order_id' => $order?->id,
            'procurement_candidate_id' => $order !== null && ! in_array($order->order_state, OrderStates::CLOSED_BEFORE_FULFILLMENT, true) ? $order->compiled_estimate_vendor_id : null,
            'selected_arrangement_id' => $w->selected_arrangement_id, 'vendor_orders' => $vendorOrders];
    }

    private function arrangementComplete(object $w): bool
    {
        $buyer = (string) DB::table('projects')->where('id', $w->project_id)->value('buyer_profile_id');
        $purchases = PackageFulfillment::purchases($w, $buyer);
        $completed = DB::table('orders')->where('project_arrangement_id', $w->selected_arrangement_id)->where('order_state', 'COMPLETED')->pluck('id')->all();
        foreach (DB::table('work_package_lines')->where('work_package_version_id', $w->current_version_id)->get() as $line) {
            $quantity = '0';
            foreach ($purchases[$line->id] ?? [] as $purchase) {
                if ($purchase['satisfies_requirement'] && in_array($purchase['order_id'], $completed, true)) {
                    $quantity = bcadd($quantity, $purchase['quantity'], 4);
                }
            }
            $waiver = DB::table('work_package_missing_lines')->where('work_package_version_id', $w->current_version_id)->where('work_package_line_id', $line->id)->whereNotNull('waiver_reason')->value('quantity');
            if (bccomp(bcadd($quantity, (string) ($waiver ?? '0'), 4), (string) $line->quantity, 4) < 0) {
                return false;
            }
        }

        return true;
    }

    /** @return array<string, mixed> */
    public function packageShow(Request $request, string $id): array
    {
        $w = $this->package($request, $id);
        $v = $w->current_version_id === null ? null : DB::table('work_package_versions')->where('id', $w->current_version_id)->first();
        $missing = DB::table('work_package_missing_lines as m')->join('work_package_lines as l', 'l.id', '=', 'm.work_package_line_id')->leftJoin('orders as o', 'o.id', '=', 'm.linked_order_id')->where('m.work_package_version_id', $w->current_version_id)
            ->orderBy('l.line_number')->get(['m.*', 'l.name', 'l.material_id', 'o.order_state as linked_order_state'])->map(static fn (object $m): array => (array) $m)->all();
        // Item-Based orders bought for a missing line (owner decision 2026-10-12); linking still verifies them.
        $buyer = $this->buyers->idFor($request);
        foreach ($missing as &$m) {
            $m['tagged_orders'] = DB::table('orders as o')->join('order_lines as ol', 'ol.order_id', '=', 'o.id')->where(function ($query) use ($m, $w): void {
                $query->where('ol.work_package_line_id', $m['work_package_line_id'])->orWhereExists(function ($allocation) use ($m, $w): void {
                    $allocation->selectRaw('1')->from('project_procurement_draft_items as d')->whereColumn('d.order_id', 'o.id')
                        ->where('d.work_package_version_id', $w->current_version_id)->where('d.work_package_line_id', $m['work_package_line_id']);
                });
            })
                ->where('o.buyer_profile_id', $buyer)->where('o.procurement_type', 'ITEM_BASED')->whereNotIn('o.order_state', OrderStates::CLOSED_BEFORE_FULFILLMENT)
                ->distinct()->orderBy('o.reference')->get(['o.id', 'o.reference', 'o.order_state', 'o.accepted_at'])
                ->map(static fn (object $o): array => ['id' => $o->id, 'reference' => $o->reference, 'order_state' => $o->order_state, 'linkable' => $o->accepted_at !== null])->all();
        }
        unset($m);
        $hasOrder = $this->hasOrder($w);

        return $this->packageSummary($w) + ['version' => $v === null ? null : $this->versionView($v),
            'has_order' => $hasOrder,
            'can_delete' => ! $hasOrder && $this->project($request, $w->project_id)->status === 'ACTIVE',
            'budget' => app(ProjectBudget::class)->metrics($this->project($request, $w->project_id), $w), 'missing_lines' => $missing,
            'project_status' => $this->project($request, $w->project_id)->status,
            'document' => ['status' => 'PHASE_15_PDF_PENDING', 'label' => 'Work Package PDF', 'version_id' => $v?->id, 'content_hash' => $v?->content_hash]];
    }

    /**
     * True while an open order, an open tagged purchase for a missing line or a selected Vendor is tied to the package.
     * Declined, expired and cancelled orders are closed, so they no longer block editing, reactivating or deleting.
     */
    public function hasOrder(object $w): bool
    {
        $versions = DB::table('work_package_versions')->select('id')->where('work_package_id', $w->id);
        $open = static fn ($query) => $query->whereNotIn('o.order_state', OrderStates::CLOSED_BEFORE_FULFILLMENT);

        return $this->hasActiveSelection($w, $this->currentPackageOrder($w))
            || ($w->selected_arrangement_id !== null && DB::table('project_arrangement_vendors as m')->join('quotations as q', 'q.conversation_id', '=', 'm.conversation_id')
                ->where('m.arrangement_id', $w->selected_arrangement_id)->whereNotNull('m.requested_at')->whereIn('q.state', ['DRAFT', 'PUBLISHED', 'VIEWED', 'COUNTERED', 'STOCK_REVALIDATION_REQUIRED'])
                ->where(fn ($q) => $q->whereNotIn('q.state', ['PUBLISHED', 'VIEWED', 'COUNTERED'])->orWhere('q.response_due_at', '>', now()))->exists())
            || DB::table('orders as o')->where('o.work_package_id', $w->id)->where($open)->exists()
            || DB::table('work_package_missing_lines as m')->join('orders as o', 'o.id', '=', 'm.linked_order_id')->whereIn('m.work_package_version_id', $versions)->where($open)->exists()
            || DB::table('order_lines as ol')->join('orders as o', 'o.id', '=', 'ol.order_id')->join('work_package_lines as l', 'l.id', '=', 'ol.work_package_line_id')->whereIn('l.work_package_version_id', $versions)->where($open)->exists();
    }

    private function currentPackageOrder(object $w): ?object
    {
        return DB::table('orders')->where('work_package_id', $w->id)->where('procurement_type', 'PROJECT_BASED')->where('work_package_version_id', $w->current_version_id)
            ->orderByDesc('created_at')->orderByDesc('id')->first();
    }

    /** A closed order's historical Vendor pointer is not an active assignment. */
    private function hasActiveSelection(object $w, ?object $order): bool
    {
        return $w->selected_vendor_organization_id !== null && ! ($order !== null
            && $order->vendor_organization_id === $w->selected_vendor_organization_id
            && in_array($order->order_state, OrderStates::CLOSED_BEFORE_FULFILLMENT, true));
    }

    /** @return array<string, mixed> */
    private function versionView(object $v): array
    {
        // Versions saved before the single Project-Based radius carry their old value; the radius in force is reported, the saved copy stays untouched.
        return ['id' => $v->id, 'content_hash' => $v->content_hash, 'locked_at' => $v->locked_at, 'content' => array_merge(json_decode($v->content, true), ['radius_km' => RadiusPolicy::PROJECT_BASED_KM])];
    }

    /** @param array<string, mixed> $input */
    public function create(Request $request, array $input): string
    {
        $buyer = $this->buyers->idFor($request);
        $id = $this->keys->requireIdempotencyKey($request);

        return DB::transaction(function () use ($request, $input, $buyer, $id): string {
            DB::table('buyer_profiles')->where('id', $buyer)->lockForUpdate()->first();
            if ($this->keys->replayed($request, 'PROJECT_CREATE', $id, $id)) {
                return $id;
            }
            DB::table('projects')->insert(['id' => $id, 'buyer_profile_id' => $buyer, 'name' => $input['name'], 'budget_centavos' => $input['budget_centavos'],
                'starts_on' => $input['starts_on'], 'ends_on' => $input['ends_on'], 'created_at' => now(), 'updated_at' => now()]);
            $this->addSite($request, $id, $input['location_id']);
            $this->record($request, 'PROJECT_CREATED', $id);
            $this->keys->claim($request, 'PROJECT_CREATE', $id, $id, 201);

            return $id;
        });
    }

    /** @param array<string, mixed> $input */
    public function update(Request $request, string $id, array $input): void
    {
        $key = $this->keys->requireIdempotencyKey($request);
        DB::transaction(function () use ($request, $id, $input, $key): void {
            $p = $this->project($request, $id, true);
            if ($this->keys->replayed($request, 'PROJECT_UPDATE', $key, $id)) {
                return;
            }
            self::version($p, $input['lock_version']);
            if ($p->status === 'ARCHIVED' || ($p->status === 'COMPLETED' && ($input['status'] ?? null) !== 'ARCHIVED')) {
                throw new AuthenticationException('PROJECT_CLOSED', 'This Project is read-only. Retain its planning and procurement history.', 409);
            }
            $history = DB::table('orders as o')->join('work_packages as w', 'w.id', '=', 'o.work_package_id')->where('w.project_id', $id)->exists();
            if ($history && array_intersect(array_keys($input), ['name', 'starts_on', 'ends_on', 'location_id', 'budget_centavos']) !== []) {
                throw new AuthenticationException('PROJECT_HISTORY_LOCKED', 'This Project has procurement history. Complete or archive it; retain its planning record.', 409);
            }
            if (isset($input['budget_centavos']) && (int) $input['budget_centavos'] < ProjectBudget::allocated($id)) {
                throw new AuthenticationException('PROJECT_BUDGET_BELOW_ALLOCATED', 'The Project budget cannot be less than the budgets already allocated to Work Packages.', 422,
                    ['allocated_centavos' => ProjectBudget::allocated($id)]);
            }
            $update = array_intersect_key($input, array_flip(['name', 'starts_on', 'ends_on', 'budget_centavos', 'status']));
            if (($input['status'] ?? null) === 'COMPLETED' && DB::table('work_packages')->where('project_id', $id)->get()->contains(fn (object $w): bool => ! in_array($this->packageSummary($w)['status'], ['COMPLETED', 'CANCELLED'], true))) {
                throw new AuthenticationException('PROJECT_INCOMPLETE', 'Complete or cancel all Work Packages first.', 409);
            }
            if (in_array($input['status'] ?? null, ['COMPLETED', 'ARCHIVED'], true)) {
                foreach (DB::table('work_packages')->where('project_id', $id)->whereNull('selected_vendor_organization_id')->whereNull('selected_arrangement_id')->orderBy('id')->lockForUpdate()->get() as $unassigned) {
                    $this->invalidate($unassigned->id);
                }
            }
            DB::table('projects')->where('id', $id)->update($update + ['lock_version' => $p->lock_version + 1, 'updated_at' => now()]);
            if (isset($input['location_id'])) {
                $this->addSite($request, $id, $input['location_id']);
            }
            $this->record($request, 'PROJECT_UPDATED', $id);
            $this->keys->claim($request, 'PROJECT_UPDATE', $key, $id, 200);
        });
    }

    public function addSite(Request $request, string $project, string $location): string
    {
        $point = $this->point($request, $location);
        $existing = DB::table('project_sites')->where('project_id', $project)->where('address_id', $point['address_id'])->value('id');
        if ($existing !== null) {
            return $existing;
        }
        if (DB::table('project_sites')->where('project_id', $project)->count() >= 20) {
            throw new AuthenticationException('SITE_LIMIT_REACHED', 'A Project may have up to 20 sites.', 422);
        }
        $id = (string) Str::uuid7();
        DB::table('project_sites')->insert(['id' => $id, 'project_id' => $project, 'address_id' => $point['address_id'], 'name' => $point['label'], 'discovery_origin' => $point['source'],
            'snapshot' => json_encode($point, JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);

        return $id;
    }

    /** @return array<string, mixed> */
    public function point(Request $request, string $location): array
    {
        $p = DB::table('buyer_locations as b')->join('addresses as a', 'a.id', '=', 'b.address_id')->where('b.id', $location)->where('b.buyer_profile_id', $this->buyers->idFor($request))->whereNull('b.archived_at')
            ->first(['b.id as location_id', 'b.label', 'a.id as address_id', 'a.source', 'a.version as address_version', 'a.latitude', 'a.longitude', 'a.formatted_address']);
        if ($p === null) {
            throw new AuthenticationException('LOCATION_NOT_FOUND', 'Choose one of your saved locations.', 422);
        }

        return (array) $p;
    }

    /** @return array<string, mixed> */
    private function siteView(object $s): array
    {
        return ['id' => $s->id, 'name' => $s->name, 'discovery_origin' => $s->discovery_origin, 'point' => json_decode($s->snapshot, true)];
    }

    /**
     * Creates a Work Package, or edits an existing one in place. The Buyer sees one package: an edit never adds a list entry.
     * Estimates and quotation requests built on the old materials are invalidated. Each saved content is kept internally
     * (Draft saves overwrite their own copy) because estimates, Vendor quotations and the database's immutability
     * protection refer to the exact content they were based on.
     *
     * @param  array<string, mixed>  $input
     */
    public function savePackage(Request $request, string $projectId, ?string $id, array $input): string
    {
        $key = $this->keys->requireIdempotencyKey($request);
        $packageId = $id ?? $key;

        return DB::transaction(function () use ($request, $projectId, $id, $input, $key, $packageId): string {
            $p = $this->project($request, $projectId, true);
            $endpoint = $id === null ? 'PACKAGE_SAVE' : 'PACKAGE_EDIT';
            if ($this->keys->replayed($request, $endpoint, $key, $packageId)) {
                return $packageId;
            }
            if ($p->status !== 'ACTIVE') {
                throw new AuthenticationException('PROJECT_CLOSED', 'Only an Active Project accepts Work Package changes.', 409);
            }
            $w = $id === null ? null : $this->package($request, $id, true);
            $previous = null;
            $status = 'DRAFT';
            if ($w !== null) {
                self::version($w, $input['lock_version']);
                if ($this->hasOrder($w)) {
                    throw new AuthenticationException('WORK_PACKAGE_HAS_ORDER', 'This Work Package has an order, so it cannot be edited. Cancel the order before correcting the package.', 409);
                }
                $currentStatus = $this->packageSummary($w)['status'];
                if (! in_array($currentStatus, ['DRAFT', 'ACTIVE', 'QUOTATION_INQUIRY', 'CANCELLED'], true)) {
                    throw new AuthenticationException('WORK_PACKAGE_LOCKED', 'This Work Package can no longer be edited.', 409);
                }
                // An edited Draft stays a Draft and a Cancelled package stays Cancelled; a compared or quoted package returns to Active.
                $status = match ($currentStatus) {
                    'ACTIVE', 'QUOTATION_INQUIRY' => 'ACTIVE',
                    default => $currentStatus,
                };
                $previous = DB::table('work_package_versions')->where('id', $w->current_version_id)->first();
                $this->invalidate($packageId);
            }
            $site = DB::table('project_sites')->where('id', $input['site_id'])->where('project_id', $projectId)->where('active', true)->first();
            if ($site === null) {
                throw new AuthenticationException('SITE_NOT_FOUND', 'Select a site from this Project.', 422);
            }
            $intended = json_decode($site->snapshot, true);
            $alternate = ($input['heavy_vehicle_restriction'] ?? 'NO') === 'YES' ? $this->point($request, $input['alternate_drop_off_location_id']) : null;
            if ($alternate !== null && $alternate['address_id'] === $intended['address_id']) {
                throw new AuthenticationException('ALTERNATE_DROP_OFF_REQUIRED', 'Choose a distinct alternative vehicle drop-off.', 422);
            }
            if ($status !== 'CANCELLED') {
                ProjectBudget::assertAllocation($p, $id, (int) $input['budget_centavos']);
            }
            // Validated wildcard data can reorder lines that omit a key; restore the Buyer's order.
            $lines = $input['lines'];
            ksort($lines);
            $lines = array_values($lines);
            $ids = array_values(array_filter(array_column($lines, 'material_id')));
            $units = DB::table('units')->whereIn('id', array_column($lines, 'unit_id'))->get()->keyBy('id');
            $materials = DB::table('materials')->whereIn('id', $ids)->where('active', true)->get()->keyBy('id');
            $definitions = SpecificationMatch::definitions($materials->pluck('material_category_id')->map(static fn (mixed $id): string => (string) $id)->all());
            foreach ($lines as $i => &$line) {
                $unit = $units->get($line['unit_id']);
                $unlisted = ($line['material_id'] ?? null) === null;
                $material = $unlisted ? null : $materials->get($line['material_id']);
                // An unlisted material may use any normalized unit; a catalog material only its compatible units.
                $unitAllowed = $unit !== null && ($unlisted || ($material !== null && DB::table('material_compatible_units')->where('material_id', $line['material_id'])->where('unit_id', $line['unit_id'])->exists()));
                if (! $unitAllowed || ($unlisted && trim((string) $line['name']) === '') || bccomp($line['quantity'], bcadd($line['quantity'], '0', (int) $unit->precision), 4) !== 0) {
                    throw new AuthenticationException('INVALID_MATERIAL_LINE', 'Use a known or named material, a normalized unit and supported quantity precision.', 422, ['line' => $i + 1]);
                }
                $line['material_id'] = $unlisted ? null : $line['material_id'];
                $line['name'] = trim((string) $line['name']);
                $line += ['preferred_brand' => null, 'specifications' => [], 'description' => null, 'color' => null];
                if (! $unlisted) {
                    $line['specifications'] = self::catalogSpecifications($line['specifications'], $definitions[(string) $material->material_category_id] ?? [], $i + 1);
                }
                $line['material_kind'] = $unlisted ? 'UNLISTED' : 'CATALOG';
                $line['id'] = (string) Str::uuid7();
                $line['unit_code'] = $unit->code;
            }
            unset($line);
            $content = array_intersect_key($input, array_flip(['name', 'description', 'budget_centavos', 'site_id', 'radius_km', 'fulfillment_method', 'payment_method', 'site_contact', 'access_instructions']));
            $content['radius_km'] = RadiusPolicy::PROJECT_BASED_KM;
            // Retain legacy saved metadata without making it a new procurement choice.
            $legacyPayment = $previous === null ? null : (json_decode($previous->content, true)['payment_method'] ?? null);
            if (! isset($content['payment_method']) && $legacyPayment !== null) {
                $content['payment_method'] = $legacyPayment;
            }
            $content['site'] = $this->siteView($site);
            $content['destination'] = ['type' => $input['fulfillment_method'], 'intended' => $intended, 'heavy_vehicle_restriction' => $input['heavy_vehicle_restriction'] ?? 'NO',
                'alternate_drop_off' => $alternate, 'vehicle_endpoint' => $alternate === null ? 'INTENDED_LOCATION' : 'ALTERNATE_DROP_OFF', 'access_instructions' => $input['access_instructions'] ?? null];
            $content['lines'] = $lines;
            if ($w === null) {
                DB::table('work_packages')->insert(['id' => $packageId, 'project_id' => $projectId, 'name' => $input['name'], 'budget_centavos' => $input['budget_centavos'], 'created_at' => now(), 'updated_at' => now()]);
            }
            $json = json_encode($content, JSON_THROW_ON_ERROR);
            if ($previous !== null && $previous->locked_at === null) {
                // A Draft owns its single unlocked copy, so saving it again overwrites that copy.
                $versionId = (string) $previous->id;
                DB::table('work_package_lines')->where('work_package_version_id', $versionId)->delete();
                DB::table('work_package_versions')->where('id', $versionId)->update(['content_hash' => hash('sha256', $json), 'content' => $json, 'updated_at' => now()]);
            } else {
                $versionId = (string) Str::uuid7();
                DB::table('work_package_versions')->insert(['id' => $versionId, 'work_package_id' => $packageId, 'version' => (int) DB::table('work_package_versions')->where('work_package_id', $packageId)->max('version') + 1,
                    'content_hash' => hash('sha256', $json), 'content' => $json, 'created_by_user_id' => $request->user()->id, 'created_at' => now(), 'updated_at' => now()]);
            }
            foreach ($lines as $i => $line) {
                DB::table('work_package_lines')->insert(['id' => $line['id'], 'work_package_version_id' => $versionId, 'material_id' => $line['material_id'], 'unit_id' => $line['unit_id'],
                    'quantity' => $line['quantity'], 'name' => $line['name'], 'preferred_brand' => $line['preferred_brand'], 'line_number' => $i + 1,
                    'material_kind' => $line['material_kind'], 'description' => $line['description'], 'color' => $line['color'],
                    'specifications' => json_encode($line['specifications'], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
            }
            if ($status !== 'DRAFT') {
                DB::table('work_package_versions')->where('id', $versionId)->update(['locked_at' => now()]);
            }
            DB::table('work_packages')->where('id', $packageId)->update(['name' => $input['name'], 'budget_centavos' => $input['budget_centavos'], 'status' => $status,
                'selected_vendor_organization_id' => null, 'selected_arrangement_id' => null, 'current_version_id' => $versionId, 'lock_version' => (int) ($w->lock_version ?? 0) + 1, 'updated_at' => now()]);
            $this->record($request, $w === null ? 'WORK_PACKAGE_DRAFT_SAVED' : 'WORK_PACKAGE_UPDATED', $packageId);
            if ($previous !== null) {
                $this->audit->account($request, 'WORK_PACKAGE_EDITED', 'WORK_PACKAGE', $packageId,
                    before: ['content_hash' => $previous->content_hash, 'status' => $w->status, 'budget_centavos' => (int) $w->budget_centavos],
                    after: ['content_hash' => hash('sha256', $json), 'status' => $status, 'budget_centavos' => (int) $input['budget_centavos']]);
            }
            $this->keys->claim($request, $endpoint, $key, $packageId, 200);

            return $packageId;
        });
    }

    /**
     * A catalog line states details only by its category's attribute codes so scanning can compare them with
     * product information: numbers are positive and stored in one canonical form ("15.0" → "15"), choices use the
     * category's own spelling, text is trimmed. Empty values are dropped.
     *
     * @param  array<string, mixed>  $values
     * @param  array<string, object>  $definitions
     * @return array<string, string>
     */
    public static function catalogSpecifications(array $values, array $definitions, int $line): array
    {
        $clean = [];
        foreach ($values as $code => $value) {
            $text = trim((string) $value);
            if ($text === '') {
                continue;
            }
            $definition = $definitions[(string) $code] ?? null;
            $normalized = SpecificationMatch::normalize($text);
            $allowed = $definition?->allowed_values === null ? null : json_decode((string) $definition->allowed_values, true);
            $choice = null;
            foreach (is_array($allowed) ? $allowed : [] as $option) {
                if (is_scalar($option) && SpecificationMatch::normalize($option) === $normalized) {
                    $choice = (string) $option;
                }
            }
            $allowed = is_array($allowed) ? $allowed : null;
            $invalid = match (true) {
                $definition === null => 'This detail does not apply to the material’s category.',
                $definition->value_type === 'NUMBER' && (preg_match('/^\d+(\.\d+)?$/', $normalized) !== 1 || bccomp($normalized, '0', 6) <= 0) => $definition->label.' must be a number above zero.',
                $allowed !== null && $choice === null => 'Choose one of the listed values for '.$definition->label.'.',
                default => null,
            };
            if ($invalid !== null) {
                throw new AuthenticationException('INVALID_SPECIFICATION', $invalid, 422, ['line' => $line, 'code' => (string) $code]);
            }
            $clean[(string) $code] = $definition->value_type === 'NUMBER' ? $normalized : (string) ($choice ?? $text);
        }
        ksort($clean);

        return $clean;
    }

    public function activate(Request $request, string $id, int $lock): void
    {
        $key = $this->keys->requireIdempotencyKey($request);
        DB::transaction(function () use ($request, $id, $lock, $key): void {
            $w = $this->package($request, $id, true);
            if ($this->keys->replayed($request, 'PACKAGE_ACTIVATE', $key, $id)) {
                return;
            }
            self::version($w, $lock);
            if ($w->status !== 'DRAFT' || $w->current_version_id === null) {
                throw new AuthenticationException('WORK_PACKAGE_LOCKED', 'Only a complete Draft can be activated.', 409);
            }
            DB::table('work_package_versions')->where('id', $w->current_version_id)->update(['locked_at' => now()]);
            DB::table('work_packages')->where('id', $id)->update(['status' => 'ACTIVE', 'lock_version' => $lock + 1, 'updated_at' => now()]);
            $this->record($request, 'WORK_PACKAGE_ACTIVATED', $id);
            $this->keys->claim($request, 'PACKAGE_ACTIVATE', $key, $id, 200);
        });
    }

    /** A Cancelled package returns to Active in place; no copy is made. The Project budget is checked again because cancelling released it. */
    public function reactivate(Request $request, string $id, int $lock): void
    {
        $key = $this->keys->requireIdempotencyKey($request);
        DB::transaction(function () use ($request, $id, $lock, $key): void {
            $w = $this->package($request, $id, true);
            if ($this->keys->replayed($request, 'PACKAGE_REACTIVATE', $key, $id)) {
                return;
            }
            self::version($w, $lock);
            if ($this->packageSummary($w)['status'] !== 'CANCELLED' || $w->current_version_id === null) {
                throw new AuthenticationException('WORK_PACKAGE_NOT_CANCELLED', 'Only a cancelled Work Package can be reactivated.', 409);
            }
            if ($this->hasOrder($w)) {
                throw new AuthenticationException('WORK_PACKAGE_HAS_ORDER', 'This Work Package has an order, so it cannot be reactivated.', 409);
            }
            ProjectBudget::assertAllocation($this->project($request, $w->project_id, true), $id, (int) $w->budget_centavos);
            $versionId = (string) $w->current_version_id;
            if ($this->currentPackageOrder($w) !== null) {
                // The same Buyer-visible package gets a new internal original so cancelled
                // order gaps, waivers and draft selections stay with their historical order.
                $previous = DB::table('work_package_versions')->where('id', $versionId)->first();
                $content = json_decode($previous->content, true);
                $versionId = (string) Str::uuid7();
                $lineIds = [];
                foreach ($content['lines'] as &$line) {
                    $lineIds[$line['id']] = (string) Str::uuid7();
                    $line['id'] = $lineIds[$line['id']];
                }
                unset($line);
                $json = json_encode($content, JSON_THROW_ON_ERROR);
                DB::table('work_package_versions')->insert(['id' => $versionId, 'work_package_id' => $id,
                    'version' => (int) DB::table('work_package_versions')->where('work_package_id', $id)->max('version') + 1,
                    'content' => $json, 'content_hash' => hash('sha256', $json), 'created_by_user_id' => $request->user()->id, 'created_at' => now(), 'updated_at' => now()]);
                foreach (DB::table('work_package_lines')->where('work_package_version_id', $previous->id)->orderBy('line_number')->get() as $line) {
                    DB::table('work_package_lines')->insert(array_merge((array) $line, ['id' => $lineIds[$line->id], 'work_package_version_id' => $versionId, 'created_at' => now(), 'updated_at' => now()]));
                }
            }
            DB::table('work_package_versions')->where('id', $versionId)->whereNull('locked_at')->update(['locked_at' => now()]);
            $this->invalidate($id);
            DB::table('work_packages')->where('id', $id)->update(['status' => 'ACTIVE', 'selected_vendor_organization_id' => null, 'selected_arrangement_id' => null, 'current_version_id' => $versionId, 'lock_version' => $lock + 1, 'updated_at' => now()]);
            $this->audit->account($request, 'WORK_PACKAGE_REACTIVATED', 'WORK_PACKAGE', $id, before: ['status' => 'CANCELLED', 'version_id' => $w->current_version_id], after: ['status' => 'ACTIVE', 'version_id' => $versionId]);
            $this->record($request, 'WORK_PACKAGE_REACTIVATED', $id);
            $this->keys->claim($request, 'PACKAGE_REACTIVATE', $key, $id, 200);
        });
    }

    public function invalidate(string $id): void
    {
        DB::table('compiled_estimates')->whereIn('work_package_version_id', DB::table('work_package_versions')->select('id')->where('work_package_id', $id))->whereNull('invalidated_at')->update(['invalidated_at' => now(), 'state' => 'INVALIDATED']);
        app(QuotationService::class)->expireForPackage($id);
    }

    public function missingComplete(string $version): bool
    {
        $open = DB::table('work_package_missing_lines as m')->leftJoin('orders as o', 'o.id', '=', 'm.linked_order_id')->where('m.work_package_version_id', $version)->whereNull('m.waived_by_user_id')
            ->where(fn ($q) => $q->whereNull('o.id')->orWhere('o.order_state', '<>', 'COMPLETED'))->get(['m.work_package_line_id', 'm.quantity']);
        if ($open->isEmpty()) {
            return true;
        }
        $package = DB::table('work_packages')->where('current_version_id', $version)->first();
        if ($package === null) {
            return false;
        }
        $buyer = (string) DB::table('projects')->where('id', $package->project_id)->value('buyer_profile_id');
        $purchases = PackageFulfillment::purchases($package, $buyer);
        $completed = DB::table('orders')->where('buyer_profile_id', $buyer)->where('work_package_id', $package->id)->where('order_state', 'COMPLETED')->pluck('id')->all();
        foreach ($open as $line) {
            $supplied = '0';
            foreach ($purchases[(string) $line->work_package_line_id] ?? [] as $purchase) {
                if ($purchase['satisfies_requirement'] && in_array($purchase['order_id'], $completed, true)) {
                    $supplied = bcadd($supplied, $purchase['quantity'], 4);
                }
            }
            if (bccomp($supplied, (string) $line->quantity, 4) < 0) {
                return false;
            }
        }

        return true;
    }

    /** @param array<string, mixed> $input */
    public function resolveMissing(Request $request, string $id, string $lineId, array $input): void
    {
        DB::transaction(function () use ($request, $id, $lineId, $input): void {
            $w = $this->package($request, $id, true);
            self::version($w, $input['lock_version']);
            $order = $w->selected_arrangement_id === null ? $this->currentPackageOrder($w) : DB::table('orders')->where('project_arrangement_id', $w->selected_arrangement_id)->whereNotIn('order_state', OrderStates::CLOSED_BEFORE_FULFILLMENT)->orderBy('id')->first();
            if ($order === null || in_array($order->order_state, OrderStates::CLOSED_BEFORE_FULFILLMENT, true)) {
                throw new AuthenticationException('MISSING_LINE_INACTIVE', 'Missing materials belong to an active Vendor request. Reactivate the Work Package and compare Vendors again.', 409);
            }
            if ($w->selected_arrangement_id !== null) {
                app(ProjectInquiryService::class)->acceptedMissing($w, []);
            }
            $m = DB::table('work_package_missing_lines')->where('work_package_version_id', $w->current_version_id)->where(function ($q) use ($w, $lineId): void {
                $q->where('id', $lineId);
                if ($w->selected_arrangement_id !== null) {
                    $q->orWhere('work_package_line_id', $lineId);
                }
            })->lockForUpdate()->first();
            $oldOrderState = $m?->linked_order_id === null ? null : DB::table('orders')->where('id', $m->linked_order_id)->value('order_state');
            if ($m === null || ($m->linked_order_id !== null && ! in_array($oldOrderState, OrderStates::CLOSED_BEFORE_FULFILLMENT, true)) || $m->waived_by_user_id !== null) {
                throw new AuthenticationException('MISSING_LINE_CONFLICT', 'This missing line changed. Refresh the package.', 409);
            }
            $update = [];
            if (isset($input['order_id'])) {
                $o = DB::table('orders')->where('id', $input['order_id'])->where('buyer_profile_id', $this->buyers->idFor($request))->where('procurement_type', 'ITEM_BASED')->lockForUpdate()->first();
                if ($o === null || $o->accepted_at === null || in_array($o->order_state, OrderStates::CLOSED_BEFORE_FULFILLMENT, true) || ($o->work_package_id !== null && $o->work_package_id !== $id)) {
                    throw new AuthenticationException('ORDER_NOT_ELIGIBLE', 'Link your accepted Item-Based order for these missing materials.', 422);
                }
                $acceptedSnapshot = DB::table('order_snapshots')->where('order_id', $o->id)->where('version', $o->current_snapshot_version)->value('snapshot');
                $confirmed = [];
                $quoted = [];
                foreach ((json_decode($acceptedSnapshot ?? '{}', true)['lines'] ?? []) as $confirmedLine) {
                    if (isset($confirmedLine['order_line_id'])) {
                        $confirmed[$confirmedLine['order_line_id']] = $confirmedLine['confirmed_quantity'];
                    } elseif (isset($confirmedLine['variant_id'])) {
                        $quoted[$confirmedLine['variant_id']] = $confirmedLine['quantity'];
                    }
                }
                $required = DB::table('work_package_lines')->where('id', $m->work_package_line_id)->first();
                if ($required->material_id === null) {
                    throw new AuthenticationException('UNLISTED_LINE_WAIVER_ONLY', 'An unlisted material cannot be verified against an order. Record a waiver reason that names your separate purchase.', 422);
                }
                $supplied = '0';
                $requiredSpecs = json_decode($required->specifications ?? '{}', true);
                $items = DB::table('order_lines as ol')->join('vendor_listings as l', 'l.id', '=', 'ol.vendor_listing_id')->join('products as p', 'p.id', '=', 'l.product_id')
                    ->where('ol.order_id', $o->id)->where('p.material_id', $required->material_id)->where('ol.unit_id', $required->unit_id)->get(['ol.id', 'ol.listing_variant_id', 'ol.quantity', 'ol.snapshot', 'p.brand', 'l.technical_attributes']);
                foreach ($items as $item) {
                    $snapshot = json_decode($item->snapshot, true);
                    $specs = $snapshot['specifications'] ?? json_decode($item->technical_attributes ?? '{}', true);
                    if (($required->preferred_brand === null || ($snapshot['brand'] ?? $item->brand) === $required->preferred_brand) && SpecificationMatch::satisfies($requiredSpecs, $specs)) {
                        $supplied = bcadd($supplied, $confirmed[$item->id] ?? $quoted[$item->listing_variant_id] ?? '0', 4);
                    }
                }
                $allocated = DB::table('work_package_missing_lines as m')->join('work_package_lines as l', 'l.id', '=', 'm.work_package_line_id')->where('m.linked_order_id', $o->id)->where('l.material_id', $required->material_id)->where('l.unit_id', $required->unit_id)->sum('m.quantity');
                if (bccomp(bcsub($supplied, (string) $allocated, 4), $m->quantity, 4) < 0) {
                    throw new AuthenticationException('MISSING_LINE_NOT_FULFILLED', 'The linked order must cover the missing normalized material quantity.', 422);
                }
                DB::table('orders')->where('id', $o->id)->update(['work_package_id' => $id, 'work_package_version_id' => $w->current_version_id]);
                app(ProjectBudget::class)->guard($request, $w, (int) $o->commercial_total_centavos, $input, $o->id);
                $update['linked_order_id'] = $o->id;
            } else {
                $update = ['linked_order_id' => null, 'waived_by_user_id' => $request->user()->id, 'waiver_reason' => $input['reason']];
            }
            DB::table('work_package_missing_lines')->where('id', $m->id)->update($update + ['updated_at' => now()]);
            DB::table('work_packages')->where('id', $id)->update(['lock_version' => $w->lock_version + 1]);
            if ($w->selected_arrangement_id !== null) {
                DB::table('project_procurement_arrangements')->where('id', $w->selected_arrangement_id)->increment('lock_version');
            }
            $this->audit->account($request, 'WORK_PACKAGE_MISSING_LINE_RESOLUTION', 'WORK_PACKAGE_MISSING_LINE', $m->id,
                ['linked_order_id' => $m->linked_order_id, 'waived_by_user_id' => $m->waived_by_user_id], $update, reason: $input['reason'] ?? null);
            $this->record($request, 'WORK_PACKAGE_MISSING_LINE_RESOLVED', $id);
        });
    }

    public function record(Request $request, string $event, string $id): void
    {
        $this->audit->account($request, $event, 'PROJECT_PROCUREMENT', $id);
        app(OutboxPublisher::class)->publish($event, 'PROJECT_PROCUREMENT', $id, ['actor_user_id' => (string) $request->user()->id]);
    }
}
