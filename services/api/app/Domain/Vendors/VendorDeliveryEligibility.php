<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Identity\AuthenticationException;
use Illuminate\Database\Query\Builder;
use Illuminate\Support\Facades\DB;

/** Current delivery capability for new procurement; never changes accepted obligations or assignments. */
final class VendorDeliveryEligibility
{
    public function staff(string $organizationId): Builder
    {
        return DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')
            ->where('m.vendor_organization_id', $organizationId)->where('m.role', 'FULFILLMENT')
            ->where('m.status', 'ACTIVE')->whereNull('m.deleted_at')->where('u.account_status', 'ACTIVE');
    }

    public function activeObligations(string $organizationId): int
    {
        return DB::table('orders')->where('vendor_organization_id', $organizationId)->where('fulfillment_method', 'DELIVERY')
            ->whereNotIn('order_state', ['COMPLETED', 'CANCELLED', 'DECLINED', 'EXPIRED'])
            ->whereNotIn('fulfillment_state', ['DELIVERED', 'COMPLETED'])->count();
    }

    /** @return array<string, mixed> */
    public function snapshot(string $organizationId): array
    {
        $profile = DB::table('store_profiles')->where('vendor_organization_id', $organizationId)->first();
        $staff = $this->staff($organizationId)->exists();
        $vehicle = app(DeliveryRecommendationService::class)->configuredVehiclesQuery($organizationId)->exists();
        $location = $this->locations()->where('a.vendor_organization_id', $organizationId)->exists();
        $settings = $this->areas()->where('d.vendor_organization_id', $organizationId)->exists();
        $ready = $staff && $vehicle && $location && $settings;
        $selected = in_array($profile?->fulfillment_method, ['VENDOR_DELIVERY', 'BOTH'], true);

        return ['fulfillment_method' => $profile?->fulfillment_method, 'staff_ready' => $staff, 'vehicle_ready' => $vehicle, 'pickup_location_ready' => $location,
            'service_settings_ready' => $settings, 'ready' => $ready,
            'enabled' => $selected && (bool) ($profile->vendor_delivery_enabled ?? false),
            'available' => $selected && (bool) ($profile->vendor_delivery_enabled ?? false) && $ready,
            'active_delivery_obligations' => $this->activeObligations($organizationId)];
    }

    public function assertReady(string $organizationId): void
    {
        $state = $this->snapshot($organizationId);
        $missing = array_filter([
            'fulfillment_staff' => ! $state['staff_ready'] ? 'Create at least one active Fulfillment Staff account in Team Accounts.' : null,
            'delivery_vehicle' => ! $state['vehicle_ready'] ? 'Register at least one active, available, complete delivery vehicle in Vehicles.' : null,
            'pickup_location' => ! $state['pickup_location_ready'] ? 'Save a valid store pickup location in Store Verification.' : null,
            'delivery_settings' => ! $state['service_settings_ready'] ? 'Configure an active delivery service distance.' : null,
        ]);
        if ($missing !== []) {
            throw new AuthenticationException('VENDOR_DELIVERY_SETUP_REQUIRED', 'Complete Vendor Delivery Setup before activating vendor-managed delivery.', 422, $missing);
        }
    }

    public function assertMethodChange(string $organizationId, string $method): void
    {
        if ($method === 'SELF_PICKUP' && $this->activeObligations($organizationId) > 0) {
            throw new AuthenticationException('ACTIVE_DELIVERY_OBLIGATIONS', 'Complete existing delivery obligations before switching to Self-Pickup Only. You can pause new deliveries while continuing existing orders.', 409);
        }
    }

    public function available(string $organizationId): bool
    {
        return $this->availableOrganizations()->where('delivery_profile.vendor_organization_id', $organizationId)->exists();
    }

    /** Correlated live eligibility, shared by paginated discovery/search and direct checkout validation. */
    public function availableOrganizations(): Builder
    {
        return DB::table('store_profiles as delivery_profile')->select('delivery_profile.vendor_organization_id')
            ->whereIn('delivery_profile.fulfillment_method', ['VENDOR_DELIVERY', 'BOTH'])->where('delivery_profile.vendor_delivery_enabled', true)
            ->whereExists(fn (Builder $query) => $query->selectRaw('1')->from('vendor_memberships as delivery_member')
                ->join('users as delivery_user', 'delivery_user.id', '=', 'delivery_member.user_id')
                ->whereColumn('delivery_member.vendor_organization_id', 'delivery_profile.vendor_organization_id')
                ->where('delivery_member.role', 'FULFILLMENT')->where('delivery_member.status', 'ACTIVE')->whereNull('delivery_member.deleted_at')
                ->where('delivery_user.account_status', 'ACTIVE'))
            ->whereExists($this->locations()->selectRaw('1')->whereColumn('a.vendor_organization_id', 'delivery_profile.vendor_organization_id'))
            ->whereExists($this->areas()->selectRaw('1')->whereColumn('d.vendor_organization_id', 'delivery_profile.vendor_organization_id'))
            ->whereExists(app(DeliveryRecommendationService::class)->configuredVehiclesQuery()->selectRaw('1')->whereColumn('v.vendor_organization_id', 'delivery_profile.vendor_organization_id'));
    }

    /** Organizations that can deliver ready-mixed concrete now: Site Delivery available and a complete, available mixer. */
    public function mixerOrganizations(): Builder
    {
        return $this->availableOrganizations()->whereExists(app(DeliveryRecommendationService::class)->configuredVehiclesQuery()->selectRaw('1')
            ->where('v.vehicle_type', 'CONCRETE_MIXER')->whereColumn('v.vendor_organization_id', 'delivery_profile.vendor_organization_id'));
    }

    private function locations(): Builder
    {
        return DB::table('vendor_addresses as a')->join('vendor_address_versions as av', 'av.id', '=', 'a.current_version_id')->whereNotNull('av.location');
    }

    private function areas(): Builder
    {
        return DB::table('delivery_service_areas as d')->where('d.active', true)->where('d.maximum_distance_km', '>', 0);
    }
}
