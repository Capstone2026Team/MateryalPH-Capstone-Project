<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Agreements\AccountAgreements;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;

final class VendorSetup
{
    public function __construct(private readonly OnboardingAccess $access, private readonly AuditRecorder $audit, private readonly ActivationReadiness $readiness, private readonly TestConnectionProvider $provider, private readonly AccountAgreements $agreements) {}

    /** @return array<string, mixed> */
    public function read(Request $request, string $organization): array
    {
        $org = $this->access->vendor($request, $organization);
        $store = DB::table('store_profiles')->where('vendor_organization_id', $organization)->first(['id', 'description', 'public_email', 'public_phone', 'pickup_enabled', 'delivery_enabled', 'cod_enabled', 'in_store_payment_enabled', 'payment_methods', 'refund_configuration']);
        $payment = DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organization)->first(['environment', 'status', 'provider_status', 'connection_error', 'evidence_origin', 'checked_at']);
        $vehicles = DB::table('vendor_vehicles as vehicle')->where('vehicle.vendor_organization_id', $organization)->where('vehicle.active', true)->orderBy('vehicle.id')->get(['vehicle.*'])->map(function (object $vehicle): object {
            $rate = DB::table('vehicle_rate_versions')->where('vendor_vehicle_id', $vehicle->id)->orderByDesc('version')->first(['base_fee_centavos', 'per_km_centavos', 'maximum_distance_km']);
            $vehicle->base_fee_centavos = $rate->base_fee_centavos;
            $vehicle->per_km_centavos = $rate->per_km_centavos;
            $vehicle->maximum_distance_km = $rate->maximum_distance_km;

            return $vehicle;
        })->all();

        return ['lock_version' => $org->lock_version, 'bulk_order_capable' => (bool) $org->bulk_order_capable, 'store' => $store, 'hours' => $store === null ? [] : DB::table('operating_hours')->where('store_profile_id', $store->id)->orderBy('weekday')->get(['weekday', 'opens_at', 'closes_at', 'closed'])->all(), 'delivery_vehicles' => $vehicles, 'payment' => $payment, 'withholding_demo_scenario' => $org->withholding_demo_scenario, 'production_withholding_assignment' => 'UNCONFIRMED', 'environment' => 'TEST'];
    }

    /** @param array<string, mixed> $input
     * @return array<string, mixed>
     */
    public function store(Request $request, string $organization, array $input): array
    {
        $this->access->vendor($request, $organization);
        $organizationRow = DB::table('vendor_organizations')->where('id', $organization)->firstOrFail();
        if ($organizationRow->submitted_at === null) {
            throw new AuthenticationException('STORE_VERIFICATION_SUBMISSION_REQUIRED', 'Submit Store Verification before proceeding to Store Setup.', 409);
        }
        $data = Validator::make($input, [
            'lock_version' => ['required', 'integer', 'min:1'], 'description' => ['required', 'string', 'max:3000'],
            'public_email' => ['required_without:public_phone', 'nullable', 'email:rfc', 'max:254'], 'public_phone' => ['required_without:public_email', 'nullable', 'regex:/^\+?[0-9 ()-]{7,20}$/'],
            'bulk_order_capable' => ['required', 'boolean'],
            'fulfillment' => ['required', Rule::in(['SELF_PICKUP', 'VENDOR_DELIVERY', 'BOTH'])],
            'cod_enabled' => ['required', 'boolean'], 'in_store_payment_enabled' => ['required', 'boolean'], 'online_payment_enabled' => ['required', 'accepted'],
            'refund_configuration' => ['required', 'array:online_refund_supported,physical_reimbursement_supported'],
            'refund_configuration.online_refund_supported' => ['required', 'boolean'],
            'refund_configuration.physical_reimbursement_supported' => ['required', 'boolean'],
            'hours' => ['required', 'array', 'size:7'], 'hours.*' => ['array:weekday,opens_at,closes_at,closed'],
            'hours.*.weekday' => ['required', 'integer', 'between:0,6', 'distinct'], 'hours.*.closed' => ['required', 'boolean'],
            'hours.*.opens_at' => ['nullable', 'date_format:H:i'], 'hours.*.closes_at' => ['nullable', 'date_format:H:i'],
            'delivery_vehicles' => [Rule::requiredIf(in_array($input['fulfillment'] ?? null, ['VENDOR_DELIVERY', 'BOTH'], true)), 'array', 'max:20'],
            'delivery_vehicles.*' => ['array:vehicle_type,vehicle_subtype,custom_vehicle_type,name,number_available,capacity_kg,cargo_length_m,cargo_width_m,cargo_height_m,heavy_vehicle_classification,base_fee_centavos,per_km_centavos,maximum_distance_km'],
            'delivery_vehicles.*.vehicle_type' => ['required', Rule::in(['MOTORCYCLE', 'PICKUP', 'VAN', 'TRUCK', 'CUSTOM'])],
            'delivery_vehicles.*.vehicle_subtype' => ['nullable', Rule::in(['OPEN_TRUCK', 'FLATBED_TRUCK', 'WING_VAN'])],
            'delivery_vehicles.*.custom_vehicle_type' => ['required_if:delivery_vehicles.*.vehicle_type,CUSTOM', 'nullable', 'string', 'max:100'],
            'delivery_vehicles.*.name' => ['required', 'string', 'max:120'],
            'delivery_vehicles.*.number_available' => ['required', 'integer', 'min:1', 'max:999'],
            'delivery_vehicles.*.capacity_kg' => ['required', 'numeric', 'gt:0'],
            'delivery_vehicles.*.cargo_length_m' => ['required', 'numeric', 'gt:0'],
            'delivery_vehicles.*.cargo_width_m' => ['required', 'numeric', 'gt:0'],
            'delivery_vehicles.*.cargo_height_m' => ['required', 'numeric', 'gt:0'],
            'delivery_vehicles.*.heavy_vehicle_classification' => ['required', 'string', 'max:64'],
            'delivery_vehicles.*.base_fee_centavos' => ['required', 'integer', 'min:0'],
            'delivery_vehicles.*.per_km_centavos' => ['required', 'integer', 'min:0'],
            'delivery_vehicles.*.maximum_distance_km' => ['required', 'integer', 'min:1', 'max:1000'],
        ])->validate();
        $pickup = $data['fulfillment'] !== 'VENDOR_DELIVERY';
        $delivery = $data['fulfillment'] !== 'SELF_PICKUP';
        if (($data['cod_enabled'] && ! $delivery) || ($data['in_store_payment_enabled'] && ! $pickup)) {
            throw new AuthenticationException('FULFILLMENT_CONFLICT', 'Physical payment capability must match fulfillment.', 422);
        }
        foreach ($data['hours'] as $hours) {
            if (! $hours['closed'] && (empty($hours['opens_at']) || empty($hours['closes_at']) || $hours['opens_at'] >= $hours['closes_at'])) {
                throw new AuthenticationException('OPERATING_HOURS_INVALID', 'Each open day needs opening and later closing times.', 422);
            }
        }

        return DB::transaction(function () use ($request, $organization, $data, $pickup, $delivery): array {
            $org = DB::table('vendor_organizations')->where('id', $organization)->lockForUpdate()->firstOrFail();
            $this->access->version($org, $data['lock_version']);
            $store = DB::table('store_profiles')->where('vendor_organization_id', $organization)->first();
            $id = $store->id ?? (string) Str::uuid7();
            DB::table('store_profiles')->updateOrInsert(['vendor_organization_id' => $organization], ['id' => $id, 'description' => $data['description'], 'public_email' => $data['public_email'] ?? null, 'public_phone' => $data['public_phone'] ?? null, 'pickup_enabled' => $pickup, 'delivery_enabled' => $delivery, 'cod_enabled' => $data['cod_enabled'], 'in_store_payment_enabled' => $data['in_store_payment_enabled'], 'payment_methods' => json_encode(['online_xendit' => true, 'cash_on_delivery' => $data['cod_enabled'], 'in_store_payment' => $data['in_store_payment_enabled']], JSON_THROW_ON_ERROR), 'refund_configuration' => json_encode($data['refund_configuration'], JSON_THROW_ON_ERROR), 'created_at' => $store->created_at ?? now(), 'updated_at' => now()]);
            foreach ($data['hours'] as $hours) {
                $existing = DB::table('operating_hours')->where('store_profile_id', $id)->where('weekday', $hours['weekday'])->first();
                DB::table('operating_hours')->updateOrInsert(['store_profile_id' => $id, 'weekday' => $hours['weekday']], ['id' => $existing->id ?? (string) Str::uuid7(), 'opens_at' => $hours['closed'] ? null : $hours['opens_at'], 'closes_at' => $hours['closed'] ? null : $hours['closes_at'], 'closed' => $hours['closed'], 'created_at' => $existing->created_at ?? now(), 'updated_at' => now()]);
            }
            DB::table('vendor_vehicles')->where('vendor_organization_id', $organization)->where('active', true)->update(['active' => false, 'updated_at' => now()]);
            foreach ($delivery ? $data['delivery_vehicles'] : [] as $vehicle) {
                $vehicleId = (string) Str::uuid7();
                DB::table('vendor_vehicles')->insert([
                    'id' => $vehicleId,
                    'vendor_organization_id' => $organization,
                    'vehicle_type' => $vehicle['vehicle_type'],
                    'vehicle_subtype' => $vehicle['vehicle_subtype'] ?? null,
                    'custom_vehicle_type' => $vehicle['custom_vehicle_type'] ?? null,
                    'name' => $vehicle['name'],
                    'capacity_kg' => $vehicle['capacity_kg'],
                    'number_available' => $vehicle['number_available'],
                    'cargo_length_m' => $vehicle['cargo_length_m'],
                    'cargo_width_m' => $vehicle['cargo_width_m'],
                    'cargo_height_m' => $vehicle['cargo_height_m'],
                    'heavy_vehicle_classification' => $vehicle['heavy_vehicle_classification'],
                    'active' => true,
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
                DB::table('vehicle_rate_versions')->insert([
                    'id' => (string) Str::uuid7(),
                    'vendor_vehicle_id' => $vehicleId,
                    'version' => 1,
                    'base_fee_centavos' => $vehicle['base_fee_centavos'],
                    'per_km_centavos' => $vehicle['per_km_centavos'],
                    'maximum_distance_km' => $vehicle['maximum_distance_km'],
                    'effective_at' => now(),
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
            }
            DB::table('vendor_organizations')->where('id', $organization)->update(['bulk_order_capable' => $data['bulk_order_capable'], 'bulk_capability_recorded' => true, 'store_setup_status' => 'IN_PROGRESS', 'updated_at' => now()]);
            DB::table('vendor_organizations')->where('id', $organization)->increment('lock_version');
            $this->audit->account($request, 'VENDOR_PUBLIC_STORE_UPDATED', 'VENDOR_ORGANIZATION', $organization, after: ['fulfillment' => $data['fulfillment']]);
            $this->readiness->reconcile($request, $organization);

            return $this->read($request, $organization);
        });
    }

    /** @param array<string, mixed> $input
     * @return array<string, mixed>
     */
    public function payment(Request $request, string $organization, array $input): array
    {
        $this->access->vendor($request, $organization, 'payments.configure', true);
        $this->requireVerificationSubmission($organization);
        $data = Validator::make($input, ['lock_version' => ['required', 'integer', 'min:1'], 'withholding_demo_scenario' => ['required', Rule::in(['DEMO_PLATFORM_WITHHOLDER', 'DEMO_PROVIDER_WITHHOLDER'])]])->validate();
        if (config('finance.live_commerce_enabled') || ! in_array(config('finance.mode'), ['TEST', 'DEMO'], true)) {
            throw new AuthenticationException('TEST_ONLY', 'This connection supports TEST simulation only.', 422);
        }

        if (! $this->provider instanceof SimulatedXenditConnection) {
            app(CreateXenditTestAccount::class)->handle($request, $organization, $data['lock_version'], $data['withholding_demo_scenario']);

            return $this->read($request, $organization);
        }

        return DB::transaction(function () use ($request, $organization, $data): array {
            $org = DB::table('vendor_organizations')->where('id', $organization)->lockForUpdate()->firstOrFail();
            $this->access->version($org, $data['lock_version']);
            $existing = DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organization)->first();
            if ($existing !== null && $existing->environment !== 'TEST') {
                throw new AuthenticationException('ENVIRONMENT_CONFLICT', 'TEST cannot overwrite another environment connection.', 409);
            }
            $result = $this->provider->connect($organization);
            DB::table('vendor_payment_accounts')->updateOrInsert(['vendor_organization_id' => $organization], ['id' => $existing->id ?? (string) Str::uuid7(), 'environment' => 'TEST', 'provider' => 'XENDIT', 'provider_account_reference' => $result['provider_account_reference'], 'status' => $result['status'], 'capabilities' => json_encode($result['capabilities'], JSON_THROW_ON_ERROR), 'evidence_origin' => $result['evidence_origin'], 'checked_at' => now(), 'created_at' => $existing->created_at ?? now(), 'updated_at' => now()]);
            DB::table('vendor_organizations')->where('id', $organization)->update(['withholding_demo_scenario' => $data['withholding_demo_scenario'], 'lock_version' => $org->lock_version + 1, 'updated_at' => now()]);
            $this->audit->account($request, 'VENDOR_TEST_CONNECTION_CHANGED', 'VENDOR_ORGANIZATION', $organization, after: ['status' => $result['status'], 'evidence_origin' => $result['evidence_origin']]);
            $this->readiness->reconcile($request, $organization);

            return $this->read($request, $organization);
        });
    }

    /** @return array<string, mixed> */
    public function commission(Request $request, string $organization, ?string $versionId = null): array
    {
        $this->access->vendor($request, $organization, 'finance.attest', $versionId !== null);
        $this->requireVerificationSubmission($organization);
        $agreement = collect($this->agreements->current($request))->firstWhere('code', 'VENDOR_COMMISSION_TEST');
        if ($versionId !== null) {
            if ($agreement === null || $agreement['id'] !== $versionId) {
                throw new AuthenticationException('AGREEMENT_VERSION_CONFLICT', 'The approved current commission Terms are unavailable. Reload before accepting.', 409);
            }
            $this->agreements->accept($request, [$versionId]);
            $this->readiness->reconcile($request, $organization);
            $agreement = collect($this->agreements->current($request))->firstWhere('code', 'VENDOR_COMMISSION_TEST');
        }

        return ['agreement' => $agreement, 'commission_basis_points' => 200, 'basis' => 'MATERIALS_AFTER_DISCOUNT_EXCLUDING_VAT', 'cadence' => 'MONTHLY', 'environment' => 'TEST', 'content_available' => $agreement['content_available'] ?? false];
    }

    private function requireVerificationSubmission(string $organization): void
    {
        if (DB::table('vendor_organizations')->where('id', $organization)->whereNotNull('submitted_at')->doesntExist()) {
            throw new AuthenticationException('STORE_VERIFICATION_SUBMISSION_REQUIRED', 'Submit Store Verification before proceeding to Store Setup.', 409);
        }
    }
}
