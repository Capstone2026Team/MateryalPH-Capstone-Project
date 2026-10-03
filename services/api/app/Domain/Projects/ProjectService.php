<?php

declare(strict_types=1);

namespace App\Domain\Projects;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Geography\BuyerProfiles;
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
        $row = DB::table('work_packages')->where('id', $id)->first();
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
        $packages = DB::table('work_packages')->where('project_id', $id)->orderByDesc('updated_at')->orderBy('id')->paginate(25);

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
        $order = DB::table('orders')->where('work_package_id', $w->id)->where('procurement_type', 'PROJECT_BASED')->where('work_package_version_id', $w->current_version_id)->orderByDesc('created_at')->first();
        $status = $w->status;
        if ($order !== null) {
            $status = match (true) {
                in_array($order->order_state, ['CANCELLED', 'DECLINED', 'EXPIRED'], true) => 'CANCELLED',
                $order->order_state === 'COMPLETED' && $this->missingComplete((string) $w->current_version_id) => 'COMPLETED',
                $order->order_state === 'AWAITING_PAYMENT' => 'AWAITING_PAYMENT',
                $order->accepted_at !== null => 'IN_PROGRESS',
                default => 'VENDOR_SELECTED',
            };
        }

        return ['id' => $w->id, 'project_id' => $w->project_id, 'name' => $w->name, 'status' => $status, 'budget_centavos' => (int) $w->budget_centavos,
            'lock_version' => (int) $w->lock_version, 'current_version_id' => $w->current_version_id, 'selected_vendor_id' => $w->selected_vendor_organization_id, 'order_id' => $order?->id];
    }

    /** @return array<string, mixed> */
    public function packageShow(Request $request, string $id): array
    {
        $w = $this->package($request, $id);
        $v = $w->current_version_id === null ? null : DB::table('work_package_versions')->where('id', $w->current_version_id)->first();
        $versions = DB::table('work_package_versions')->where('work_package_id', $id)->orderByDesc('version')->paginate(25);
        $missing = DB::table('work_package_missing_lines as m')->join('work_package_lines as l', 'l.id', '=', 'm.work_package_line_id')->leftJoin('orders as o', 'o.id', '=', 'm.linked_order_id')->where('m.work_package_version_id', $w->current_version_id)
            ->orderBy('l.line_number')->get(['m.*', 'l.name', 'o.order_state as linked_order_state'])->map(static fn (object $m): array => (array) $m)->all();

        return $this->packageSummary($w) + ['version' => $v === null ? null : $this->versionView($v),
            'versions' => ['items' => array_map(fn (object $v): array => $this->versionView($v), $versions->items()), 'page' => $versions->currentPage(), 'has_more' => $versions->hasMorePages()],
            'budget' => app(ProjectBudget::class)->metrics($this->project($request, $w->project_id), $w), 'missing_lines' => $missing,
            'project_status' => $this->project($request, $w->project_id)->status,
            'document' => ['status' => 'PHASE_15_PDF_PENDING', 'label' => 'Work Package PDF', 'version_id' => $v?->id, 'content_hash' => $v?->content_hash]];
    }

    /** @return array<string, mixed> */
    private function versionView(object $v): array
    {
        return ['id' => $v->id, 'version' => (int) $v->version, 'content_hash' => $v->content_hash, 'locked_at' => $v->locked_at, 'content' => json_decode($v->content, true)];
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
            $update = array_intersect_key($input, array_flip(['name', 'starts_on', 'ends_on', 'budget_centavos', 'status']));
            if (($input['status'] ?? null) === 'COMPLETED' && DB::table('work_packages')->where('project_id', $id)->get()->contains(fn (object $w): bool => ! in_array($this->packageSummary($w)['status'], ['COMPLETED', 'CANCELLED'], true))) {
                throw new AuthenticationException('PROJECT_INCOMPLETE', 'Complete or cancel all Work Packages first.', 409);
            }
            if (in_array($input['status'] ?? null, ['COMPLETED', 'ARCHIVED'], true)) {
                foreach (DB::table('work_packages')->where('project_id', $id)->whereNull('selected_vendor_organization_id')->orderBy('id')->lockForUpdate()->get() as $unassigned) {
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

    /** @param array<string, mixed> $input */
    public function savePackage(Request $request, string $projectId, ?string $id, array $input, bool $newVersion = false): string
    {
        $key = $this->keys->requireIdempotencyKey($request);
        $packageId = $id ?? $key;

        return DB::transaction(function () use ($request, $projectId, $id, $input, $newVersion, $key, $packageId): string {
            $p = $this->project($request, $projectId, true);
            $endpoint = $newVersion ? 'PACKAGE_VERSION' : 'PACKAGE_SAVE';
            if ($this->keys->replayed($request, $endpoint, $key, $packageId)) {
                return $packageId;
            }
            if ($p->status !== 'ACTIVE') {
                throw new AuthenticationException('PROJECT_CLOSED', 'Only an Active Project accepts new Work Packages.', 409);
            }
            $w = $id === null ? null : $this->package($request, $id, true);
            if ($w !== null) {
                self::version($w, $input['lock_version']);
                $status = $this->packageSummary($w)['status'];
                if ((! $newVersion && $status !== 'DRAFT') || ($newVersion && ! in_array($status, ['ACTIVE', 'QUOTATION_INQUIRY', 'CANCELLED', 'DRAFT'], true))) {
                    throw new AuthenticationException('WORK_PACKAGE_LOCKED', 'Use an explicit new version before selection. After selection, cancel the order before correcting the package.', 409);
                }
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
            $lines = $input['lines'];
            $ids = array_column($lines, 'material_id');
            $units = DB::table('units')->whereIn('id', array_column($lines, 'unit_id'))->get()->keyBy('id');
            $materials = DB::table('materials')->whereIn('id', $ids)->get()->keyBy('id');
            foreach ($lines as $i => &$line) {
                $unit = $units->get($line['unit_id']);
                $material = $materials->get($line['material_id']);
                if ($unit === null || $material === null || ! DB::table('material_compatible_units')->where('material_id', $line['material_id'])->where('unit_id', $line['unit_id'])->exists() || bccomp($line['quantity'], bcadd($line['quantity'], '0', (int) $unit->precision), 4) !== 0) {
                    throw new AuthenticationException('INVALID_MATERIAL_LINE', 'Use a known material, normalized unit and supported quantity precision.', 422, ['line' => $i + 1]);
                }
                $line += ['name' => $material->name, 'preferred_brand' => null, 'specifications' => []];
                $line['id'] = (string) Str::uuid7();
                $line['unit_code'] = $unit->code;
            }
            unset($line);
            $content = array_intersect_key($input, array_flip(['name', 'description', 'budget_centavos', 'site_id', 'radius_km', 'fulfillment_method', 'payment_method', 'site_contact', 'access_instructions']));
            $content['site'] = $this->siteView($site);
            $content['destination'] = ['type' => $input['fulfillment_method'], 'intended' => $intended, 'heavy_vehicle_restriction' => $input['heavy_vehicle_restriction'] ?? 'NO',
                'alternate_drop_off' => $alternate, 'vehicle_endpoint' => $alternate === null ? 'INTENDED_LOCATION' : 'ALTERNATE_DROP_OFF', 'access_instructions' => $input['access_instructions'] ?? null];
            $content['lines'] = $lines;
            $versionId = (string) Str::uuid7();
            if ($w === null) {
                DB::table('work_packages')->insert(['id' => $packageId, 'project_id' => $projectId, 'name' => $input['name'], 'budget_centavos' => $input['budget_centavos'], 'created_at' => now(), 'updated_at' => now()]);
            }
            $json = json_encode($content, JSON_THROW_ON_ERROR);
            DB::table('work_package_versions')->insert(['id' => $versionId, 'work_package_id' => $packageId, 'version' => (int) DB::table('work_package_versions')->where('work_package_id', $packageId)->max('version') + 1,
                'content_hash' => hash('sha256', $json), 'content' => $json, 'created_by_user_id' => $request->user()->id, 'created_at' => now(), 'updated_at' => now()]);
            foreach ($lines as $i => $line) {
                DB::table('work_package_lines')->insert(['id' => $line['id'], 'work_package_version_id' => $versionId, 'material_id' => $line['material_id'], 'unit_id' => $line['unit_id'],
                    'quantity' => $line['quantity'], 'name' => $line['name'], 'preferred_brand' => $line['preferred_brand'], 'line_number' => $i + 1,
                    'specifications' => json_encode($line['specifications'], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
            }
            DB::table('work_packages')->where('id', $packageId)->update(['name' => $input['name'], 'budget_centavos' => $input['budget_centavos'], 'status' => 'DRAFT',
                'selected_vendor_organization_id' => null, 'current_version_id' => $versionId, 'lock_version' => (int) ($w->lock_version ?? 0) + 1, 'updated_at' => now()]);
            $this->record($request, $newVersion ? 'WORK_PACKAGE_VERSION_CREATED' : 'WORK_PACKAGE_DRAFT_SAVED', $packageId);
            $this->keys->claim($request, $endpoint, $key, $packageId, 200);

            return $packageId;
        });
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

    public function invalidate(string $id): void
    {
        DB::table('compiled_estimates')->whereIn('work_package_version_id', DB::table('work_package_versions')->select('id')->where('work_package_id', $id))->whereNull('invalidated_at')->update(['invalidated_at' => now(), 'state' => 'INVALIDATED']);
        app(QuotationService::class)->expireForPackage($id);
    }

    public function missingComplete(string $version): bool
    {
        return ! DB::table('work_package_missing_lines as m')->leftJoin('orders as o', 'o.id', '=', 'm.linked_order_id')->where('m.work_package_version_id', $version)->whereNull('m.waived_by_user_id')
            ->where(fn ($q) => $q->whereNull('o.id')->orWhere('o.order_state', '<>', 'COMPLETED'))->exists();
    }

    /** @param array<string, mixed> $input */
    public function resolveMissing(Request $request, string $id, string $lineId, array $input): void
    {
        DB::transaction(function () use ($request, $id, $lineId, $input): void {
            $w = $this->package($request, $id, true);
            self::version($w, $input['lock_version']);
            $m = DB::table('work_package_missing_lines')->where('id', $lineId)->where('work_package_version_id', $w->current_version_id)->lockForUpdate()->first();
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
                $supplied = '0';
                $requiredSpecs = json_decode($required->specifications ?? '{}', true);
                $items = DB::table('order_lines as ol')->join('vendor_listings as l', 'l.id', '=', 'ol.vendor_listing_id')->join('products as p', 'p.id', '=', 'l.product_id')
                    ->where('ol.order_id', $o->id)->where('p.material_id', $required->material_id)->where('ol.unit_id', $required->unit_id)->get(['ol.id', 'ol.listing_variant_id', 'ol.quantity', 'ol.snapshot', 'p.brand', 'l.technical_attributes']);
                foreach ($items as $item) {
                    $snapshot = json_decode($item->snapshot, true);
                    $specs = $snapshot['specifications'] ?? json_decode($item->technical_attributes ?? '{}', true);
                    if (($required->preferred_brand === null || ($snapshot['brand'] ?? $item->brand) === $required->preferred_brand) && array_diff_assoc($requiredSpecs, $specs) === []) {
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
            DB::table('work_package_missing_lines')->where('id', $lineId)->update($update + ['updated_at' => now()]);
            DB::table('work_packages')->where('id', $id)->update(['lock_version' => $w->lock_version + 1]);
            $this->audit->account($request, 'WORK_PACKAGE_MISSING_LINE_RESOLUTION', 'WORK_PACKAGE_MISSING_LINE', $lineId,
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
