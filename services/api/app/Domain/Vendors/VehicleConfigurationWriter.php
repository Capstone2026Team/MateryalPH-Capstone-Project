<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\OutboxPublisher;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

/**
 * The single writer of Vendor vehicle configurations, shared by Store Setup S2 and operational fleet
 * management. Configuration and rate changes append immutable versions, so accepted order snapshots keep
 * the exact vehicle and rate versions they referenced; edits affect future proposals only.
 */
final class VehicleConfigurationWriter
{
    public const MAX_CENTAVOS = 1_000_000_000;

    private const SNAPSHOT_FIELDS = ['vehicle_category', 'vehicle_type', 'custom_type_name', 'name', 'brand', 'image_file_id', 'number_available', 'capacity_kg', 'cargo_length_m', 'cargo_width_m', 'cargo_height_m', 'mixer_capacity_m3', 'heavy_classification', 'active', 'available'];

    /**
     * Collects every per-vehicle field error for the operational fleet form. Foreign or removed vehicle ids
     * are reported as unavailable (404) without disclosing ownership.
     *
     * @param  array<int, mixed>  $vehicles
     * @return array<string, list<string>>
     */
    public function fleetErrors(string $organizationId, array $vehicles): array
    {
        $errors = [];
        $add = static function (int $index, string $field, string $message) use (&$errors): void {
            $errors['vehicles.'.$index.'.'.$field][] = $message;
        };
        foreach (array_values($vehicles) as $index => $vehicle) {
            if (! is_array($vehicle)) {
                $add($index, 'id', 'Each vehicle must be a structured configuration.');

                continue;
            }
            if (isset($vehicle['id'])) {
                $owned = DB::table('vendor_vehicles')->where('id', (string) $vehicle['id'])->where('vendor_organization_id', $organizationId)->whereNull('removed_at')->exists();
                if (! Str::isUuid((string) $vehicle['id']) || ! $owned) {
                    throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The requested vehicle configuration is unavailable.', 404);
                }
                if (! is_int($vehicle['lock_version'] ?? null)) {
                    $add($index, 'lock_version', 'Refresh the vehicle list and try again.');
                }
            }
            if (($vehicle['removed'] ?? false) === true) {
                if (! isset($vehicle['id'])) {
                    $add($index, 'id', 'Only a saved vehicle can be removed.');
                }

                continue;
            }
            try {
                VehicleConfiguration::normalize($vehicle, $index);
            } catch (ValidationException $exception) {
                foreach ($exception->errors() as $field => $messages) {
                    $errors[$field] = array_values(array_merge($errors[$field] ?? [], $messages));
                }
            }
            if (($vehicle['vehicle_category'] ?? null) === null) {
                $add($index, 'vehicle_category', 'Choose a vehicle category.');
            }
            if (trim((string) ($vehicle['name'] ?? '')) === '') {
                $add($index, 'name', 'Enter the vehicle name.');
            }
            if (! $this->positive($vehicle['capacity_kg'] ?? null, 1_000_000)) {
                $add($index, 'capacity_kg', 'Enter the maximum payload in kilograms, above zero.');
            }
            $count = $vehicle['number_available'] ?? null;
            if (! is_int($count) || $count < 1 || $count > 1000) {
                $add($index, 'number_available', 'Enter a whole number of usable vehicles from 1 to 1,000.');
            }
            $image = $vehicle['image_file_id'] ?? null;
            if (! is_string($image) || ! Str::isUuid($image) || ! DB::table('files')->where('id', $image)->where('owner_type', 'VENDOR_ORGANIZATION')->where('owner_id', $organizationId)->where('purpose', 'VEHICLE_IMAGE')->where('scan_state', 'CLEAN')->exists()) {
                $add($index, 'image_file_id', 'Upload a vehicle image that passed the safety check.');
            }
            foreach (['base_fee_centavos' => 'Enter a base fee of zero or more.', 'per_km_centavos' => 'Enter a per-kilometer rate of zero or more.'] as $field => $message) {
                $value = $vehicle[$field] ?? null;
                if (! is_int($value) || $value < 0 || $value > self::MAX_CENTAVOS) {
                    $add($index, $field, $message);
                }
            }
            $distance = $vehicle['maximum_distance_km'] ?? null;
            if (! is_int($distance) || $distance < 1 || $distance > 1000) {
                $add($index, 'maximum_distance_km', 'Enter a maximum delivery distance from 1 to 1,000 km.');
            }
        }

        return $errors;
    }

    /**
     * Saves vehicle configurations. Store Setup keeps its first-error contract; the fleet path validates with
     * fleetErrors() first and passes each saved vehicle's expected lock_version.
     *
     * @param  array<int, mixed>  $vehicles
     * @return list<string> Saved vehicle ids in request order.
     */
    public function save(string $organizationId, array $vehicles, ?int $actorId, bool $checkVersions = false): array
    {
        $deliveryDistance = DB::table('delivery_service_areas')->where('vendor_organization_id', $organizationId)->where('active', true)->value('maximum_distance_km');
        $saved = [];
        foreach ($vehicles as $index => $vehicle) {
            if (! is_array($vehicle)) {
                throw new AuthenticationException('VEHICLE_CONFIGURATION_INVALID', 'Each vehicle must be a structured configuration.', 422);
            }
            $hasId = isset($vehicle['id']) && trim((string) $vehicle['id']) !== '';
            $id = $hasId ? (string) $vehicle['id'] : (string) Str::uuid7();
            $existing = $hasId ? DB::table('vendor_vehicles')->where('id', $id)->lockForUpdate()->first() : null;
            if ($hasId && ($existing === null || (string) $existing->vendor_organization_id !== $organizationId || $existing->removed_at !== null)) {
                throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The requested vehicle configuration is unavailable.', 404);
            }
            if ($checkVersions && $existing !== null && (int) ($vehicle['lock_version'] ?? -1) !== (int) $existing->lock_version) {
                throw new AuthenticationException('STALE_VERSION', 'Vehicle '.($index + 1).' changed since you opened it. Review the current configuration and save again.', 409, ['vehicle_id' => $id, 'index' => $index]);
            }
            if ($existing !== null && ($vehicle['removed'] ?? false) === true) {
                DB::table('vendor_vehicles')->where('id', $id)->update(['active' => false, 'removed_at' => now(), 'updated_by_user_id' => $actorId, 'lock_version' => (int) $existing->lock_version + 1, 'updated_at' => now()]);
                $this->version($id, $actorId);
                $saved[] = $id;

                continue;
            }
            if ($existing !== null && ($vehicle['active'] ?? true) === false && ! $checkVersions) {
                DB::table('vendor_vehicles')->where('id', $id)->update(['active' => false, 'updated_by_user_id' => $actorId, 'lock_version' => (int) $existing->lock_version + 1, 'updated_at' => now()]);
                $this->version($id, $actorId);
                $saved[] = $id;

                continue;
            }
            $configuration = VehicleConfiguration::normalize($vehicle, $index);
            $vehicleType = trim((string) ($vehicle['vehicle_type'] ?? ''));
            $name = trim((string) ($vehicle['name'] ?? ''));
            $capacity = $vehicle['capacity_kg'] ?? null;
            $numberAvailable = $vehicle['number_available'] ?? null;
            if ($vehicleType === '' || $name === '' || ! is_numeric($capacity) || ! is_finite((float) $capacity) || (float) $capacity <= 0 || ! is_numeric($numberAvailable) || ! is_finite((float) $numberAvailable) || floor((float) $numberAvailable) !== (float) $numberAvailable || (int) $numberAvailable < 1) {
                throw new AuthenticationException('VEHICLE_CONFIGURATION_INVALID', 'Provide a vehicle type, name, positive capacity, and at least one available vehicle.', 422);
            }
            $dimensions = [];
            foreach (['cargo_length_m', 'cargo_width_m', 'cargo_height_m'] as $dimension) {
                $value = $vehicleType === 'CONCRETE_MIXER' ? null : ($vehicle[$dimension] ?? null);
                if ($value === null || $value === '') {
                    $dimensions[$dimension] = null;

                    continue;
                }
                if (! is_numeric($value) || ! is_finite((float) $value) || (float) $value <= 0 || (float) $value > 1000) {
                    throw ValidationException::withMessages(["vehicles.$index.$dimension" => 'Enter a cargo dimension greater than 0 and up to 1,000 meters.']);
                }
                $dimensions[$dimension] = (float) $value;
            }
            $values = ['vehicle_type' => $vehicleType, 'name' => $name, 'capacity_kg' => (float) $capacity, 'number_available' => (int) $numberAvailable, 'cargo_length_m' => $dimensions['cargo_length_m'], 'cargo_width_m' => $dimensions['cargo_width_m'], 'cargo_height_m' => $dimensions['cargo_height_m'], 'heavy_classification' => isset($vehicle['heavy_classification']) ? trim((string) $vehicle['heavy_classification']) : null, 'active' => true, 'lock_version' => ($existing === null ? 0 : (int) $existing->lock_version) + 1, 'updated_by_user_id' => $actorId, 'updated_at' => now()];
            $values = array_merge($values, $configuration);
            $values['active'] = $vehicle['active'] ?? ($existing->active ?? true);
            $values['available'] = array_key_exists('available', $vehicle) ? (bool) $vehicle['available'] : (bool) ($existing->available ?? true);
            if (array_key_exists('image_file_id', $vehicle)) {
                $imageId = $vehicle['image_file_id'];
                if ($imageId !== null && ! DB::table('files')->where('id', $imageId)->where('owner_type', 'VENDOR_ORGANIZATION')->where('owner_id', $organizationId)->where('purpose', 'VEHICLE_IMAGE')->where('scan_state', 'CLEAN')->exists()) {
                    throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The vehicle image is unavailable.', 404);
                }
                $values['image_file_id'] = $imageId;
            }
            if ($existing === null) {
                DB::table('vendor_vehicles')->insert($values + ['id' => $id, 'vendor_organization_id' => $organizationId, 'configuration_version' => 0, 'created_at' => now()]);
            } else {
                DB::table('vendor_vehicles')->where('id', $id)->update($values);
            }
            $this->version($id, $actorId);

            $rateKeys = ['base_fee_centavos', 'per_km_centavos', 'maximum_distance_km'];
            if (count(array_intersect($rateKeys, array_keys($vehicle))) > 0) {
                $this->saveRate($id, $vehicle, $deliveryDistance, $actorId);
            }
            $saved[] = $id;
        }

        if ($saved !== []) {
            app(OutboxPublisher::class)->publish('VENDOR_FLEET_CHANGED', 'VENDOR_ORGANIZATION', $organizationId, ['vendor_organization_id' => $organizationId]);
        }

        return $saved;
    }

    /** @param array<string, mixed> $vehicle */
    private function saveRate(string $vehicleId, array $vehicle, mixed $deliveryDistance, ?int $actorId): void
    {
        $centavos = static function (mixed $value): ?int {
            if (is_int($value)) {
                return $value >= 0 ? $value : null;
            }
            if ((! is_string($value) && ! is_float($value)) || ! is_numeric($value) || ! is_finite((float) $value) || floor((float) $value) !== (float) $value || (float) $value < 0) {
                return null;
            }

            return (int) $value;
        };
        $currentRate = DB::table('vehicle_rate_versions')->where('vendor_vehicle_id', $vehicleId)->orderByDesc('version')->lockForUpdate()->first();
        $baseFee = $centavos(array_key_exists('base_fee_centavos', $vehicle) ? $vehicle['base_fee_centavos'] : ($currentRate === null ? null : $currentRate->base_fee_centavos));
        $perKm = $centavos(array_key_exists('per_km_centavos', $vehicle) ? $vehicle['per_km_centavos'] : ($currentRate === null ? null : $currentRate->per_km_centavos));
        $maximumDistance = array_key_exists('maximum_distance_km', $vehicle) ? $vehicle['maximum_distance_km'] : ($currentRate === null ? $deliveryDistance : ($currentRate->maximum_distance_km ?? $deliveryDistance));
        if ($baseFee === null || $perKm === null || ! is_numeric($maximumDistance) || ! is_finite((float) $maximumDistance) || floor((float) $maximumDistance) !== (float) $maximumDistance || (int) $maximumDistance < 1 || (int) $maximumDistance > 1000) {
            throw new AuthenticationException('VEHICLE_RATE_INCOMPLETE', 'Provide non-negative base and per-kilometer fees and a delivery distance between 1 and 1000 km.', 422);
        }
        if ($currentRate === null || (int) $currentRate->base_fee_centavos !== $baseFee || (int) $currentRate->per_km_centavos !== $perKm || (int) $currentRate->maximum_distance_km !== (int) $maximumDistance) {
            DB::table('vehicle_rate_versions')->insert(['id' => (string) Str::uuid7(), 'vendor_vehicle_id' => $vehicleId, 'version' => ($currentRate === null ? 0 : (int) $currentRate->version) + 1, 'base_fee_centavos' => $baseFee, 'per_km_centavos' => $perKm, 'maximum_distance_km' => (int) $maximumDistance, 'effective_at' => now(), 'created_by_user_id' => $actorId, 'created_at' => now(), 'updated_at' => now()]);
        }
    }

    /** Appends an immutable configuration version when the saved configuration differs from the latest one. */
    private function version(string $vehicleId, ?int $actorId): void
    {
        $vehicle = DB::table('vendor_vehicles')->where('id', $vehicleId)->first();
        $configuration = [];
        foreach (self::SNAPSHOT_FIELDS as $field) {
            $value = $vehicle->{$field};
            $configuration[$field] = match (true) {
                in_array($field, ['active', 'available'], true) => (bool) $value,
                in_array($field, ['capacity_kg', 'cargo_length_m', 'cargo_width_m', 'cargo_height_m', 'mixer_capacity_m3'], true) => $value === null ? null : (string) $value,
                $field === 'number_available' => (int) $value,
                default => $value,
            };
        }
        $configuration['removed'] = $vehicle->removed_at !== null;
        $json = json_encode($configuration, JSON_THROW_ON_ERROR);
        $hash = hash('sha256', $json);
        $latest = DB::table('vendor_vehicle_versions')->where('vendor_vehicle_id', $vehicleId)->orderByDesc('version')->first(['version', 'content_hash']);
        if ($latest !== null && $latest->content_hash === $hash) {
            return;
        }
        $version = ($latest === null ? 0 : (int) $latest->version) + 1;
        DB::table('vendor_vehicle_versions')->insert(['id' => (string) Str::uuid7(), 'vendor_vehicle_id' => $vehicleId, 'version' => $version, 'configuration' => $json, 'content_hash' => $hash, 'created_by_user_id' => $actorId, 'created_at' => now()]);
        DB::table('vendor_vehicles')->where('id', $vehicleId)->update(['configuration_version' => $version]);
    }

    private function positive(mixed $value, float $max): bool
    {
        return (is_int($value) || is_float($value) || (is_string($value) && is_numeric($value))) && is_finite((float) $value) && (float) $value > 0 && (float) $value <= $max;
    }
}
