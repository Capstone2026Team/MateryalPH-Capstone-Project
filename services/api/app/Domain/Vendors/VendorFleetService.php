<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Catalog\CatalogFileStore;
use App\Domain\Catalog\ImageContentValidator;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Inventory\InventoryAccess;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\URL;

/**
 * Operational fleet management over the Store Setup vehicle records (no duplicate vehicle tables).
 * Owner and Store Manager add, edit, disable, mark unavailable and remove future-use configurations as
 * repeatable row sets with per-vehicle validation and optimistic versions. Fulfillment Staff read only the
 * confirmed vehicle on their assigned orders; every other role is denied. Changes never alter accepted
 * delivery snapshots.
 */
final class VendorFleetService
{
    public const MAX_VEHICLES = 50;

    public function __construct(
        private readonly InventoryAccess $access,
        private readonly VehicleConfigurationWriter $writer,
        private readonly OnboardingRequirementResolver $requirements,
        private readonly CatalogFileStore $files,
        private readonly ImageContentValidator $images,
        private readonly AuditRecorder $audit,
        private readonly DeliveryRecommendationService $recommendations,
    ) {}

    /** @return array{items: list<array<string, mixed>>, meta: array<string, mixed>} */
    public function list(Request $request): array
    {
        $scope = $this->access->scope($request);
        if (in_array(InventoryAccess::VEHICLES_MANAGE, $scope['permissions'], true)) {
            return $this->present($scope['organization_id']);
        }
        if (in_array(InventoryAccess::VEHICLES_ASSIGNED, $scope['permissions'], true)) {
            // Fulfillment assignment arrives with order fulfillment; until then no confirmed vehicle is assigned.
            return ['items' => [], 'meta' => ['scope' => 'ASSIGNED_ONLY', 'delivery' => null, 'permissions' => ['can_manage' => false], 'limits' => ['max_vehicles' => self::MAX_VEHICLES]]];
        }
        throw new AuthenticationException('PERMISSION_DENIED', 'Vehicle configuration is not available to your role.', 403);
    }

    /**
     * @param  list<array<string, mixed>>  $vehicles
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function save(Request $request, array $vehicles): array
    {
        $organizationId = $this->access->organizationFor($request, [InventoryAccess::VEHICLES_MANAGE]);
        DB::transaction(function () use ($request, $organizationId, $vehicles): void {
            DB::table('vendor_organizations')->where('id', $organizationId)->lockForUpdate()->first(['id']);
            $existing = DB::table('vendor_vehicles')->where('vendor_organization_id', $organizationId)->whereNull('removed_at')->count();
            $new = count(array_filter($vehicles, static fn (array $vehicle): bool => ! isset($vehicle['id'])));
            if ($existing + $new > self::MAX_VEHICLES) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['vehicles' => ['A store can keep up to '.self::MAX_VEHICLES.' vehicle configurations.']]);
            }
            $errors = $this->writer->fleetErrors($organizationId, $vehicles);
            if ($errors !== []) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted vehicle fields and try again.', 422, $errors);
            }
            $before = $this->present($organizationId)['items'];
            $ids = $this->writer->save($organizationId, $vehicles, (int) $request->user()->getKey(), true);
            $this->requirements->synchronize($organizationId);
            $this->audit->account($request, 'VENDOR_FLEET_UPDATED', 'VENDOR_ORGANIZATION', $organizationId, before: ['vehicle_ids' => array_column($before, 'id')], after: ['changed_vehicle_ids' => $ids]);
        });

        return $this->present($organizationId);
    }

    /** @return array<string, mixed> */
    public function uploadImage(Request $request, UploadedFile $file): array
    {
        $organizationId = $this->access->organizationFor($request, [InventoryAccess::VEHICLES_MANAGE]);
        $image = $this->images->validate($file, (int) config('materyalph.files.max_media_kb', 20480), 'vehicle image');
        $fileId = $this->files->store($file, 'VENDOR_ORGANIZATION', $organizationId, 'VEHICLE_IMAGE', (int) $request->user()->getKey(), $image['mime']);
        $this->audit->account($request, 'VENDOR_VEHICLE_IMAGE_UPLOADED', 'FILE', $fileId);

        return ['file_id' => $fileId, 'status' => 'READY'] + $this->signedUrl($fileId);
    }

    /** @return array{url: string, expires_at: string} */
    public function imageUrl(Request $request, string $fileId): array
    {
        $organizationId = $this->access->organizationFor($request, [InventoryAccess::VEHICLES_MANAGE]);
        $this->authorizedImage($organizationId, $fileId);

        return $this->signedUrl($fileId);
    }

    /** Re-checks current authority when a signed image link is opened. */
    public function authorizedImage(string $organizationId, string $fileId): object
    {
        $file = DB::table('files')->where('id', $fileId)->where('owner_type', 'VENDOR_ORGANIZATION')->where('owner_id', $organizationId)->where('purpose', 'VEHICLE_IMAGE')->where('scan_state', 'CLEAN')->first();
        if ($file === null) {
            throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The vehicle image is unavailable.', 404);
        }

        return $file;
    }

    /** @return array{items: list<array<string, mixed>>, meta: array<string, mixed>} */
    private function present(string $organizationId): array
    {
        $area = DB::table('delivery_service_areas')->where('vendor_organization_id', $organizationId)->first(['maximum_distance_km', 'active']);
        $method = DB::table('store_profiles')->where('vendor_organization_id', $organizationId)->value('fulfillment_method');
        $deliveryEnabled = in_array($method, ['VENDOR_DELIVERY', 'BOTH'], true) && $area !== null && (bool) $area->active;
        $vehicles = DB::table('vendor_vehicles')->where('vendor_organization_id', $organizationId)->whereNull('removed_at')->orderBy('created_at')->orderBy('id')->limit(self::MAX_VEHICLES)->get();
        $rates = DB::table('vehicle_rate_versions')->whereIn('vendor_vehicle_id', $vehicles->pluck('id')->all())->orderByDesc('version')->get()->groupBy('vendor_vehicle_id');
        $eligible = array_column($this->recommendations->eligibleVehicles($organizationId), 'id');

        return ['items' => $vehicles->map(function (object $vehicle) use ($rates, $eligible, $deliveryEnabled): array {
            $rate = $rates->get($vehicle->id)?->first();
            $row = (array) $vehicle;
            $reasons = [];
            if (! $deliveryEnabled) {
                $reasons[] = 'DELIVERY_NOT_ENABLED';
            }
            $incomplete = DeliveryRecommendationService::incompleteReason($row);
            if ($incomplete !== null) {
                $reasons[] = $incomplete;
            }
            if ($vehicle->image_file_id === null) {
                $reasons[] = 'IMAGE_MISSING';
            }
            if ($rate === null) {
                $reasons[] = 'RATE_MISSING';
            }

            return [
                'id' => $vehicle->id, 'lock_version' => (int) $vehicle->lock_version, 'configuration_version' => (int) $vehicle->configuration_version,
                'vehicle_category' => $vehicle->vehicle_category, 'vehicle_type' => $vehicle->vehicle_type, 'custom_type_name' => $vehicle->custom_type_name,
                'name' => $vehicle->name, 'brand' => $vehicle->brand, 'image_file_id' => $vehicle->image_file_id,
                'number_available' => (int) $vehicle->number_available, 'capacity_kg' => (float) $vehicle->capacity_kg,
                'cargo_length_m' => $vehicle->cargo_length_m === null ? null : (float) $vehicle->cargo_length_m,
                'cargo_width_m' => $vehicle->cargo_width_m === null ? null : (float) $vehicle->cargo_width_m,
                'cargo_height_m' => $vehicle->cargo_height_m === null ? null : (float) $vehicle->cargo_height_m,
                'mixer_capacity_m3' => $vehicle->mixer_capacity_m3 === null ? null : (float) $vehicle->mixer_capacity_m3,
                'heavy_classification' => $vehicle->heavy_classification, 'active' => (bool) $vehicle->active, 'available' => (bool) $vehicle->available,
                'rate_version' => $rate === null ? null : (int) $rate->version,
                'base_fee_centavos' => $rate === null ? null : (int) $rate->base_fee_centavos, 'per_km_centavos' => $rate === null ? null : (int) $rate->per_km_centavos,
                'maximum_distance_km' => $rate === null ? null : (int) $rate->maximum_distance_km,
                'eligibility' => ['eligible' => in_array($vehicle->id, $eligible, true), 'reasons' => array_values(array_unique($reasons))],
                'updated_at' => $vehicle->updated_at,
            ];
        })->all(), 'meta' => [
            'scope' => 'ORGANIZATION',
            'delivery' => ['fulfillment_method' => $method, 'delivery_enabled' => $deliveryEnabled, 'service_radius_km' => $area?->maximum_distance_km === null ? null : (int) $area->maximum_distance_km],
            'permissions' => ['can_manage' => true], 'limits' => ['max_vehicles' => self::MAX_VEHICLES],
            'advisory' => ['calculation_version' => DeliveryRecommendationService::CALCULATION_VERSION, 'fee_rounding' => DeliveryRecommendationService::FEE_ROUNDING, 'dimensional_formulas' => DeliveryRecommendationService::DIMENSIONAL_FORMULAS],
        ]];
    }

    /** @return array{url: string, expires_at: string} */
    private function signedUrl(string $fileId): array
    {
        $expires = now()->addMinutes(5);

        return ['url' => URL::temporarySignedRoute('fleet.file-content', $expires, ['fileId' => $fileId]), 'expires_at' => $expires->toIso8601String()];
    }
}
