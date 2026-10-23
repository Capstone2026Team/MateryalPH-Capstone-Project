<?php

declare(strict_types=1);

namespace App\Domain\Demo;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Catalog\MarketplaceDiscoverability;
use App\Domain\Catalog\VendorCatalogService;
use App\Domain\Compliance\ComplianceRegisterImporter;
use App\Domain\Compliance\ProductComplianceService;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\ManageProfilePhoto;
use App\Domain\Vendors\OnboardingRequirementResolver;
use App\Domain\Vendors\StoreActivationGate;
use App\Domain\Vendors\StoreOperatingSchedule;
use App\Domain\Vendors\VehicleConfigurationWriter;
use App\Domain\Vendors\VendorOnboardingService;
use App\Domain\Vendors\XenditAccountVerificationGateway;
use App\Domain\Vendors\XenditProviderUnavailable;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Sleep;
use Illuminate\Support\Str;
use RuntimeException;
use Throwable;

/**
 * Seeds twelve fictional, fully onboarded Tier 2 Vendors for the capstone demonstration: Owner and staff accounts with
 * profile photos and authenticator factors, a verified Store Profile (logo, banner, hours, address), approved
 * verification evidence, an approved TEST tax profile, a Xendit TEST sub-account, delivery configuration (area,
 * vehicle, Fulfillment Staff), accepted agreements, an activated Store, and published catalog listings with photos,
 * prices, volume tiers and counted stock.
 *
 * Every Store, listing and file goes through the same services the Vendor portal uses wherever those services are
 * public (media upload, fleet writer, catalog create/update/variants/media/publish, activation gate, discoverability).
 * Only the evidence an Admin would otherwise review is written directly, as approved SAMPLE documents.
 *
 * The catalog lists real Philippine-market brands with retail prices, up to eight photos per listing and Vendor-typed
 * search tags. A regulated (PS/ICC) listing names a real PS License No. or ICC sticker serial from the DTI-BPS
 * registers; the seeder submits it through the Vendor's register lookup (Manual Entry with the product's packaging
 * photo as the marking photo), so it is verified only when the active register matches and no compliance decision is
 * written directly. When no register snapshot is active, the copies in materials/ are imported and activated first.
 * One store also sells ready-mixed concrete with a transit mixer. Product, banner and vehicle photos come from the
 * git-ignored photos folder (fetch_demo_photos.py); logos, SAMPLE documents and AI-generated staff portraits are
 * committed. Re-running is idempotent: existing Vendors, listings and media are reused and stock confirmations refreshed.
 */
final class DemoVendorMarketplace
{
    public const OWNER_EMAIL_TAG = 'matdemo';

    public const ASSET_DIRECTORY = 'database/demo-assets';

    /** Fictional team members; only their roles and fixed demo names are used. */
    private const STAFF_NAMES = [
        'STORE_STAFF' => ['Mario Reyes', 'Cynthia Lopez', 'Rolando Cruz', 'Grace Tolentino', 'Dennis Alcantara', 'Josephine Rivera', 'Ernesto Flores', 'Marites Soriano', 'Rodel Estrada', 'Liza Manalo', 'Teresita Ramos', 'Arnold Pascual'],
        'FULFILLMENT' => ['Jun Macaraeg', 'Paolo Salazar', 'Noel Abad', 'Ramil Cabrera', 'Arnel Dizon', 'Edwin Mercado', 'Gilbert Tan', 'Rey Sison', 'Alvin Bernal', 'Joey Padilla', 'Ronaldo Javier', 'Efren Galang'],
    ];

    /** Register copies imported only when no snapshot of that kind is active (DTI-BPS lists, as downloaded). */
    private const REGISTER_FILES = [
        'PS_LICENSE' => ['List_of_PS_Licensee_MASTERLIST.csv', 'DTI-BPS List of PS Licensees (materials/List_of_PS_Licensee_MASTERLIST.csv)'],
        'ICC_CERTIFICATE' => ['List_of_ICC_Certificate_Holders.csv', 'DTI-BPS List of ICC Certificate Holders (materials/List_of_ICC_Certificate_Holders.csv)'],
    ];

    private const BASE32 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';

    /**
     * Tables read by the shared eligibility, delivery and activation checks. Seeding fills them in one burst, faster
     * than autovacuum re-analyzes them, so the planner would keep empty-table estimates and nest loops over every row.
     */
    private const PLANNER_TABLES = [
        'vendor_organizations', 'vendor_listings', 'listing_variants', 'inventory_items', 'listing_price_versions', 'products',
        'vendor_tax_profiles', 'vendor_tax_profile_versions', 'store_profiles', 'vendor_memberships', 'users', 'vendor_addresses',
        'vendor_address_versions', 'delivery_service_areas', 'vendor_vehicles', 'vehicle_rate_versions', 'files',
    ];

    /** @var array<string, string> */
    private array $notes = [];

    public function __construct(
        private readonly AccountAccess $access,
        private readonly AuditRecorder $audit,
        private readonly ManageProfilePhoto $photos,
        private readonly OnboardingRequirementResolver $requirements,
        private readonly StoreActivationGate $gate,
        private readonly StoreOperatingSchedule $schedule,
        private readonly VehicleConfigurationWriter $vehicles,
        private readonly VendorOnboardingService $onboarding,
        private readonly VendorCatalogService $catalog,
        private readonly MarketplaceDiscoverability $discoverability,
        private readonly XenditAccountVerificationGateway $xendit,
        private readonly ProductComplianceService $compliance,
        private readonly ComplianceRegisterImporter $registers,
    ) {}

    /**
     * @param  list<string>  $only  Vendor slugs to seed; empty seeds all twelve.
     * @param  'xendit'|'simulate'  $payments  xendit provisions real TEST sub-accounts; simulate is for automated tests only.
     * @return list<array<string, mixed>>
     */
    public function seed(array $only, string $payments, string $password, string $credentialsPath, bool $refreshOnly = false): array
    {
        if (app()->isProduction()) {
            throw new RuntimeException('Demo Vendors cannot be seeded in production.');
        }
        $catalog = $this->blueprint();
        $admin = DB::table('users')->where('account_type', 'ADMIN')->where('account_status', 'ACTIVE')->orderBy('id')->value('id');
        $credentials = $this->loadCredentials($credentialsPath);
        $selected = array_values(array_filter($catalog['vendors'], static fn (array $vendor): bool => $only === [] || in_array($vendor['slug'], $only, true)));
        $registerNotes = $refreshOnly ? [] : $this->ensureComplianceRegisters($selected, $admin === null ? null : (int) $admin);
        $report = [];
        foreach ($selected as $vendor) {
            $this->notes = $registerNotes;
            $registerNotes = [];
            try {
                $report[] = $this->seedVendor($vendor, $payments, $password, $admin === null ? null : (int) $admin, $credentials, $refreshOnly);
            } catch (Throwable $error) {
                $report[] = ['slug' => $vendor['slug'], 'status' => 'FAILED', 'error' => $error::class.': '.Str::limit($error->getMessage(), 300), 'notes' => $this->notes];
            }
            $this->saveCredentials($credentialsPath, $credentials, $password);
            // Statistics only; ANALYZE also counts rows of an enclosing uncommitted transaction.
            DB::statement('ANALYZE '.implode(', ', self::PLANNER_TABLES));
        }
        if ($payments === 'xendit' && ! $refreshOnly) {
            $report = $this->finishWhenSubAccountsGoLive($selected, $report, $password, $admin === null ? null : (int) $admin, $credentials, $credentialsPath);
        }

        return $report;
    }

    /**
     * Xendit moves a new OWNED TEST sub-account from REGISTERED to LIVE a few minutes after creation, so the first pass
     * leaves those Stores blocked on payment_connection. Poll each waiting account (bounded by
     * materyalph.demo.xendit_live_wait_seconds) and finish its Store in this same run once Xendit reports LIVE.
     *
     * @param  list<array<string, mixed>>  $selected
     * @param  list<array<string, mixed>>  $report
     * @param  array<string, mixed>  $credentials
     * @return list<array<string, mixed>>
     */
    private function finishWhenSubAccountsGoLive(array $selected, array $report, string $password, ?int $adminId, array &$credentials, string $credentialsPath): array
    {
        $waiting = [];
        foreach ($report as $index => $row) {
            $account = isset($row['organization_id']) ? DB::table('vendor_payment_accounts')->where('vendor_organization_id', $row['organization_id'])->first(['connection_status', 'provider_account_id']) : null;
            if ($row['status'] !== 'OK' && $account?->connection_status === 'PENDING' && is_string($account->provider_account_id)) {
                $waiting[$index] = $account->provider_account_id;
            }
        }
        $vendors = array_column($selected, null, 'slug');
        $deadline = now()->addSeconds(max(0, (int) config('materyalph.demo.xendit_live_wait_seconds', 600)));
        while ($waiting !== [] && now()->lt($deadline)) {
            Sleep::for(20)->seconds();
            foreach ($waiting as $index => $providerAccountId) {
                try {
                    $live = $this->xendit->reconcile($providerAccountId)['status'] === 'LIVE';
                } catch (XenditProviderUnavailable) {
                    continue;
                }
                if (! $live) {
                    continue;
                }
                unset($waiting[$index]);
                $vendor = $vendors[$report[$index]['slug']];
                $this->notes = [];
                try {
                    $report[$index] = $this->seedVendor($vendor, 'xendit', $password, $adminId, $credentials, false);
                } catch (Throwable $error) {
                    $report[$index] = ['slug' => $vendor['slug'], 'status' => 'FAILED', 'error' => $error::class.': '.Str::limit($error->getMessage(), 300), 'notes' => $this->notes];
                }
                $this->saveCredentials($credentialsPath, $credentials, $password);
            }
        }

        return $report;
    }

    /** @return array<string, mixed> */
    public function blueprint(): array
    {
        return json_decode((string) file_get_contents(base_path(self::ASSET_DIRECTORY.'/vendors.json')), true, flags: JSON_THROW_ON_ERROR);
    }

    /**
     * @param  array<string, mixed>  $v
     * @param  array<string, mixed>  $credentials
     * @return array<string, mixed>
     */
    private function seedVendor(array $v, string $payments, string $password, ?int $adminId, array &$credentials, bool $refreshOnly): array
    {
        $ownerEmail = $this->email($v['n']);
        $existing = DB::table('users')->where('email', $ownerEmail)->first(['id']);
        $organizationId = $existing === null ? null : DB::table('vendor_memberships')->where('user_id', $existing->id)->where('role', 'OWNER')->value('vendor_organization_id');

        if ($organizationId === null) {
            $organizationId = $this->createAccountsAndOrganization($v, $password, $credentials);
        }
        $organizationId = (string) $organizationId;
        $owner = User::query()->findOrFail((int) DB::table('vendor_memberships')->where('vendor_organization_id', $organizationId)->where('role', 'OWNER')->value('user_id'));
        $request = $this->requestFor($owner);

        if (! $refreshOnly) {
            $this->ensureProfilePhotos($v, $organizationId);
            $this->ensureStoreProfile($v, $organizationId, $request);
            $this->ensureDelivery($v, $organizationId, $owner, $request);
            $this->ensureTrustRecords($v, $organizationId, $owner, $adminId);
            $this->requirements->synchronize($organizationId);
            $this->ensurePayment($v, $organizationId, $owner, $payments);
            $this->approveVerification($organizationId, $owner, $adminId);
            $this->requirements->synchronize($organizationId);
            $this->activate($organizationId, $owner, $adminId);
            $this->publishCatalog($v, $organizationId, $owner);
        }
        $this->refreshStock($organizationId);
        $this->discoverability->evaluate($organizationId, $adminId, 'SYSTEM');

        $organization = DB::table('vendor_organizations')->where('id', $organizationId)->first(['store_name', 'store_verification_status', 'store_setup_status', 'store_activation_status', 'marketplace_discoverability_status', 'marketplace_discoverability_reason']);
        $readiness = $this->gate->evaluate($organizationId);

        return [
            'slug' => $v['slug'], 'store' => $organization->store_name, 'organization_id' => $organizationId, 'owner_email' => $ownerEmail,
            'verification' => $organization->store_verification_status, 'setup' => $organization->store_setup_status, 'activation' => $organization->store_activation_status,
            'discoverability' => $organization->marketplace_discoverability_status.($organization->marketplace_discoverability_reason === null ? '' : ' ('.$organization->marketplace_discoverability_reason.')'),
            'gate_ready' => $readiness['ready'], 'gate_blockers' => array_column($readiness['blockers'], 'key'),
            'active_listings' => $active = DB::table('vendor_listings')->where('vendor_organization_id', $organizationId)->where('status', 'ACTIVE')->count(),
            'status' => $organization->store_activation_status === 'ACTIVE' && $active === count($v['products']) && ! isset($this->notes['payment']) ? 'OK' : 'INCOMPLETE', 'notes' => $this->notes,
        ];
    }

    private function email(int $n): string
    {
        $base = (string) config('materyalph.demo.email_base', '');
        if ($base === '' || ! str_contains($base, '@')) {
            return sprintf('%s%02d@demo.materyalph.invalid', self::OWNER_EMAIL_TAG, $n);
        }
        [$local, $domain] = explode('@', $base, 2);

        return sprintf('%s+%s%02d@%s', $local, self::OWNER_EMAIL_TAG, $n, $domain);
    }

    private function taggedEmail(int $n, string $suffix): string
    {
        $base = (string) config('materyalph.demo.email_base', '');
        if ($base === '' || ! str_contains($base, '@')) {
            return sprintf('%s%02d.%s@demo.materyalph.invalid', self::OWNER_EMAIL_TAG, $n, $suffix);
        }
        [$local, $domain] = explode('@', $base, 2);

        return sprintf('%s+%s%02d%s@%s', $local, self::OWNER_EMAIL_TAG, $n, $suffix, $domain);
    }

    // ---------------------------------------------------------------------------------------------------------
    // Accounts and organization
    // ---------------------------------------------------------------------------------------------------------

    /**
     * @param  array<string, mixed>  $v
     * @param  array<string, mixed>  $credentials
     */
    private function createAccountsAndOrganization(array $v, string $password, array &$credentials): string
    {
        $organizationId = (string) Str::uuid7();
        $parts = preg_split('/\s+/', trim((string) $v['owner'])) ?: [];
        $surname = (string) array_pop($parts);
        $given = implode(' ', $parts);

        DB::transaction(function () use ($v, $organizationId, $password, $surname, $given, &$credentials): void {
            $owner = $this->createUser((string) $v['owner'], $this->email($v['n']), $v['mobile'], $password);
            $credentials['vendors'][$v['slug']]['store'] = $v['store_name'];
            $credentials['vendors'][$v['slug']]['accounts'][] = ['role' => 'OWNER', 'email' => $owner['email'], 'totp_secret' => $owner['totp_secret']];

            DB::table('vendor_organizations')->insert([
                'id' => $organizationId, 'legal_name' => $v['store_name'], 'store_name' => $v['store_name'], 'account_status' => 'ACTIVE',
                'business_type' => $v['business_type'], 'registered_name' => $v['store_name'], 'legal_business_name' => $v['store_name'],
                'date_established' => now()->subYears(3)->toDateString(), 'store_email' => mb_strtolower($this->email($v['n'])), 'store_email_verified_at' => now(), 'store_phone' => $v['mobile'],
                'store_verification_status' => 'NOT_STARTED', 'store_setup_status' => 'NOT_STARTED', 'store_activation_status' => 'NOT_READY', 'marketplace_discoverability_status' => 'NOT_DISCOVERABLE',
                'onboarding_welcome_dismissed_at' => now(), 'individual_registered_surname' => $surname, 'individual_registered_first_name' => $given, 'legal_identity_same_as_owner' => true,
                'identity_id_type' => 'PASSPORT', 'identity_id_number_encrypted' => Crypt::encryptString(sprintf('DEMO%07d', $v['n'])), 'identity_id_number_last4' => substr(sprintf('%07d', $v['n']), -4),
                'staff_disputes_enabled' => true, 'created_at' => now(), 'updated_at' => now(),
            ]);
            DB::table('vendor_memberships')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'user_id' => $owner['id'], 'role' => 'OWNER', 'status' => 'ACTIVE', 'can_manage_staff' => false, 'activated_at' => now(), 'created_at' => now(), 'updated_at' => now()]);

            $roles = ['STORE_STAFF'];
            if ($v['delivery'] !== null) {
                $roles[] = 'FULFILLMENT';
            }
            foreach ($roles as $role) {
                $name = self::STAFF_NAMES[$role][($v['n'] - 1) % count(self::STAFF_NAMES[$role])];
                $account = $this->createUser($name, $this->taggedEmail($v['n'], $role === 'FULFILLMENT' ? 'ful' : 'stf'), '+639170000'.sprintf('%03d', 200 + $v['n'] + ($role === 'FULFILLMENT' ? 20 : 0)), $password);
                DB::table('vendor_memberships')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'user_id' => $account['id'], 'role' => $role, 'status' => 'ACTIVE', 'can_manage_staff' => false, 'activated_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
                $credentials['vendors'][$v['slug']]['accounts'][] = ['role' => $role, 'email' => $account['email'], 'totp_secret' => $account['totp_secret']];
            }
        });
        $this->notes['accounts'] = 'created';

        return $organizationId;
    }

    /** @return array{id: int, email: string, totp_secret: string} */
    private function createUser(string $name, string $email, string $mobile, string $password): array
    {
        $user = (new User)->forceFill(['name' => $name, 'email' => mb_strtolower($email), 'password' => Hash::make($password), 'account_type' => 'VENDOR', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        $user->save();
        DB::table('user_profiles')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'full_name' => $name, 'mobile_e164' => $mobile, 'locale' => 'en', 'created_at' => now(), 'updated_at' => now()]);
        $secret = '';
        for ($i = 0; $i < 32; $i++) {
            $secret .= self::BASE32[random_int(0, 31)];
        }
        DB::table('totp_factors')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'encrypted_secret' => Crypt::encryptString($secret), 'confirmed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);

        return ['id' => (int) $user->getKey(), 'email' => (string) $user->email, 'totp_secret' => $secret];
    }

    /** @param array<string, mixed> $v */
    private function ensureProfilePhotos(array $v, string $organizationId): void
    {
        $members = DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->where('m.vendor_organization_id', $organizationId)->whereNull('m.deleted_at')->get(['u.id', 'm.role', 'u.profile_photo_key']);
        foreach ($members as $member) {
            if ($member->profile_photo_key !== null) {
                continue;
            }
            $user = User::query()->findOrFail($member->id);
            $request = $this->requestFor($user);
            $asset = $this->asset($v['slug'], match ($member->role) {
                'OWNER' => 'owner.jpg',
                'FULFILLMENT' => 'fulfillment.jpg',
                default => 'staff.jpg',
            });
            $this->photos->upload($request, $this->upload($asset, 'profile.jpg', 'image/jpeg'), (int) $user->lock_version);
        }
    }

    // ---------------------------------------------------------------------------------------------------------
    // Store Profile, hours, address, media
    // ---------------------------------------------------------------------------------------------------------

    /** @param array<string, mixed> $v */
    private function ensureStoreProfile(array $v, string $organizationId, Request $request): void
    {
        $profile = DB::table('store_profiles')->where('vendor_organization_id', $organizationId)->first();
        if ($profile === null) {
            $profileId = (string) Str::uuid7();
            DB::table('store_profiles')->insert([
                'id' => $profileId, 'vendor_organization_id' => $organizationId, 'public_store_name' => $v['store_name'], 'description' => $v['description'].' (Fictional demonstration store.)',
                'bulk_capability' => (bool) $v['bulk'], 'fulfillment_method' => $v['fulfillment'], 'public_email' => mb_strtolower($this->email($v['n'])), 'public_phone' => $v['mobile'],
                'status' => 'COMPLETED', 'version' => 1, 'lock_version' => 1, 'vendor_delivery_enabled' => $v['delivery'] !== null, 'created_at' => now(), 'updated_at' => now(),
            ]);
        } else {
            $profileId = (string) $profile->id;
        }
        $days = [];
        foreach (range(1, 7) as $day) {
            $closed = in_array($day, $v['hours']['closed_days'], true);
            $days[] = ['day_of_week' => $day, 'status' => $closed ? 'CLOSED' : 'OPEN', 'opens_at' => $closed ? null : $v['hours']['open'], 'closes_at' => $closed ? null : $v['hours']['close']];
        }
        $this->schedule->replaceWeekly($profileId, $days);

        if (! DB::table('vendor_classifications')->where('vendor_organization_id', $organizationId)->exists()) {
            DB::table('vendor_classifications')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'supplier_type' => $v['supplier_type'], 'niches' => json_encode($v['niches'], JSON_THROW_ON_ERROR), 'custom_labels' => '[]', 'version' => 1, 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);
        }
        $this->ensureAddress($v, $organizationId);

        $profile = DB::table('store_profiles')->where('id', $profileId)->first(['logo_file_id', 'banner_file_id']);
        if ($profile->logo_file_id === null) {
            $this->onboarding->uploadMedia($request, $this->upload($this->asset($v['slug'], 'logo.png'), 'demo-'.$v['slug'].'-logo.png', 'image/png'), 'LOGO', $v['store_name'].' logo');
        }
        if ($profile->banner_file_id === null) {
            $this->onboarding->uploadMedia($request, $this->upload($this->photo('vendors/'.$v['slug'].'/banner.jpg'), 'demo-'.$v['slug'].'-banner.jpg', 'image/jpeg'), 'BANNER', $v['store_name'].' banner');
        }
    }

    /** @param array<string, mixed> $v */
    private function ensureAddress(array $v, string $organizationId): void
    {
        $addressId = DB::table('vendor_addresses')->where('vendor_organization_id', $organizationId)->value('id');
        if ($addressId !== null && DB::table('vendor_addresses')->where('id', $addressId)->whereNotNull('current_version_id')->exists()) {
            $this->ensureBusinessAddress($organizationId);

            return;
        }
        $a = $v['address'];
        $addressId ??= (string) Str::uuid7();
        $versionId = (string) Str::uuid7();
        $city = DB::table('psgc_areas as c')->join('psgc_versions as pv', 'pv.id', '=', 'c.psgc_version_id')->where('pv.status', 'ACTIVE')->where('c.code', $a['psgc_city'])->first(['c.id', 'c.name']);
        $barangay = $city === null ? null : DB::table('psgc_areas')->where('parent_id', $city->id)->where('level', 'BARANGAY')->where('name', $a['barangay'])->first(['code', 'name']);
        if ($barangay === null) {
            $this->notes['address'] = 'PSGC barangay "'.$a['barangay'].'" not found under '.$a['city'].'; saved without PSGC codes (import the PSGC reference data and re-seed for geographic analytics roll-ups).';
        }
        $region = $barangay === null ? null : '1300000000';
        if (! DB::table('vendor_addresses')->where('id', $addressId)->exists()) {
            DB::table('vendor_addresses')->insert(['id' => $addressId, 'vendor_organization_id' => $organizationId, 'created_at' => now(), 'updated_at' => now()]);
        }
        $formatted = sprintf('%s, %s, %s %s, Metro Manila, Philippines', $a['street'], $a['barangay'], $a['city'], $a['postal']);
        DB::statement('INSERT INTO vendor_address_versions (id, vendor_address_id, version, street, barangay, city_municipality, province, postal_code, psgc_code, psgc_source, province_code, city_code, formatted_address, country_code, latitude, longitude, source, location, created_at)
            VALUES (?, ?, 1, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ST_SetSRID(ST_MakePoint(?::float8, ?::float8), 4326)::geography, now())', [
            $versionId, $addressId, $a['street'], $a['barangay'], $a['city'], 'National Capital Region (NCR)', $a['postal'], $barangay?->code, $barangay === null ? null : 'PSGC_CLOUD_V2', $region, $barangay === null ? null : $a['psgc_city'], $formatted, 'PH',
            round((float) $a['lat'], 7), round((float) $a['lng'], 7), 'MAP', round((float) $a['lng'], 7), round((float) $a['lat'], 7),
        ]);
        DB::table('vendor_addresses')->where('id', $addressId)->update(['current_version_id' => $versionId, 'updated_at' => now()]);
        $this->ensureBusinessAddress($organizationId);
    }

    /**
     * The portal saves the store address twice: as the Store's address version and as the current "Registered business
     * address" (addresses), which the Admin verification queue reads for its region and city. Mirror that here.
     */
    private function ensureBusinessAddress(string $organizationId): void
    {
        if (DB::table('addresses')->where('owner_type', 'VENDOR_ORGANIZATION')->where('owner_id', $organizationId)->where('is_current', true)->exists()) {
            return;
        }
        $store = DB::table('vendor_addresses as a')->join('vendor_address_versions as v', 'v.id', '=', 'a.current_version_id')->where('a.vendor_organization_id', $organizationId)
            ->first(['v.street', 'v.barangay', 'v.city_municipality', 'v.province', 'v.postal_code', 'v.psgc_code', 'v.psgc_source', 'v.province_code', 'v.city_code', 'v.formatted_address', 'v.latitude', 'v.longitude', 'v.source']);
        if ($store === null) {
            return;
        }
        $id = (string) Str::uuid7();
        DB::table('addresses')->insert(['id' => $id, 'owner_type' => 'VENDOR_ORGANIZATION', 'owner_id' => $organizationId, 'label' => 'Registered business address', 'street' => $store->street, 'barangay' => $store->barangay,
            'city_municipality' => $store->city_municipality, 'province' => $store->province, 'postal_code' => $store->postal_code, 'formatted_address' => $store->formatted_address, 'latitude' => $store->latitude, 'longitude' => $store->longitude,
            'psgc_code' => $store->psgc_code, 'psgc_source' => $store->psgc_source, 'province_code' => $store->province_code, 'city_code' => $store->city_code, 'source' => $store->source, 'review_state' => 'PENDING_REVIEW', 'verified' => false,
            'version' => 1, 'is_current' => true, 'created_at' => now(), 'updated_at' => now()]);
        DB::statement('UPDATE addresses SET location = ST_SetSRID(ST_MakePoint(?, ?), 4326)::geography, geography_wkt = ? WHERE id = ?', [(float) $store->longitude, (float) $store->latitude, 'POINT('.$store->longitude.' '.$store->latitude.')', $id]);
    }

    // ---------------------------------------------------------------------------------------------------------
    // Delivery configuration
    // ---------------------------------------------------------------------------------------------------------

    /** @param array<string, mixed> $v */
    private function ensureDelivery(array $v, string $organizationId, User $owner, Request $request): void
    {
        DB::table('vendor_payment_settings')->updateOrInsert(['vendor_organization_id' => $organizationId], ['id' => DB::table('vendor_payment_settings')->where('vendor_organization_id', $organizationId)->value('id') ?? (string) Str::uuid7(), 'cod_enabled' => true, 'in_store_enabled' => true, 'lock_version' => 1, 'updated_by_user_id' => $owner->getKey(), 'created_at' => now(), 'updated_at' => now()]);
        if ($v['delivery'] === null) {
            return;
        }
        $d = $v['delivery'];
        if (! DB::table('delivery_service_areas')->where('vendor_organization_id', $organizationId)->exists()) {
            DB::table('delivery_service_areas')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'area_type' => 'RADIUS', 'maximum_distance_km' => $d['max_km'], 'coverage_notes' => 'Delivery within '.$d['max_km'].' km of the store.', 'active' => true, 'version' => 1, 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);
        }
        if (DB::table('vendor_vehicles')->where('vendor_organization_id', $organizationId)->whereNull('removed_at')->exists()) {
            return;
        }
        $rows = [];
        foreach ($d['vehicles'] ?? [$d['vehicle'] + ['photo' => 'vehicle']] as $vehicle) {
            $image = $this->onboarding->uploadMedia($request, $this->upload($this->photo('vendors/'.$v['slug'].'/'.$vehicle['photo'].'.jpg'), 'demo-'.$v['slug'].'-'.$vehicle['photo'].'.jpg', 'image/jpeg'), 'VEHICLE_IMAGE', $vehicle['name']);
            $mixer = $vehicle['type'] === 'CONCRETE_MIXER';
            $rows[] = [
                'vehicle_category' => $vehicle['category'], 'vehicle_type' => $vehicle['type'], 'name' => $vehicle['name'], 'brand' => $vehicle['brand'], 'capacity_kg' => $vehicle['capacity_kg'], 'number_available' => $vehicle['n'],
                'heavy_classification' => $vehicle['heavy'], 'image_file_id' => $image['file_id'],
                'base_fee_centavos' => $vehicle['base'], 'per_km_centavos' => $vehicle['per_km'], 'maximum_distance_km' => $d['max_km'], 'active' => true, 'available' => true,
            ] + ($mixer
                // A Concrete Mixer Truck carries Mixer Capacity (m³) instead of cargo dimensions, and the Vendor's own mobilization basis.
                ? ['mixer_capacity_m3' => $vehicle['mixer_m3'], 'mobilization_fee_centavos' => $vehicle['mobilization'][0], 'mobilization_basis' => $vehicle['mobilization'][1]]
                : ['cargo_length_m' => $vehicle['dim'][0], 'cargo_width_m' => $vehicle['dim'][1], 'cargo_height_m' => $vehicle['dim'][2]]);
        }
        $this->vehicles->save($organizationId, $rows, (int) $owner->getKey());
    }

    // ---------------------------------------------------------------------------------------------------------
    // Agreements, tax profile, approved evidence
    // ---------------------------------------------------------------------------------------------------------

    /** @param array<string, mixed> $v */
    private function ensureTrustRecords(array $v, string $organizationId, User $owner, ?int $adminId): void
    {
        foreach (['TERMS_OF_SERVICE', 'VENDOR_CODE_OF_CONDUCT', 'VENDOR_COMMISSION_TEST'] as $code) {
            $versionId = $this->agreementVersion($code);
            if (! DB::table('agreement_acceptances')->where('user_id', $owner->getKey())->where('agreement_version_id', $versionId)->where('vendor_organization_id', $organizationId)->exists()) {
                DB::table('agreement_acceptances')->insert(['id' => (string) Str::uuid7(), 'user_id' => $owner->getKey(), 'agreement_version_id' => $versionId, 'vendor_organization_id' => $organizationId, 'source' => 'ACCOUNT_SETTINGS', 'accepted_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
            }
        }
        $privacy = $this->agreementVersion('PRIVACY_NOTICE');
        if (! DB::table('privacy_acknowledgments')->where('vendor_organization_id', $organizationId)->where('user_id', $owner->getKey())->where('agreement_version_id', $privacy)->exists()) {
            DB::table('privacy_acknowledgments')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'user_id' => $owner->getKey(), 'agreement_version_id' => $privacy, 'acknowledged_at' => now()]);
        }
        $this->ensureTaxProfile($v, $organizationId, $owner, $adminId);
        // Requirement rows must exist before evidence is attached to them.
        $this->requirements->synchronize($organizationId);
        $documents = [
            'business_registration' => ['DTI_BUSINESS_NAME_REGISTRATION', 'doc-registration.jpg', sprintf('DEMO-DTI-%04d', $v['n']), 'NO_EXPIRATION'],
            'lgu_permit' => ['lgu_permit', 'doc-lgu-permit.jpg', sprintf('DEMO-LGU-%04d', $v['n']), 'DATE'],
            'bir_cor' => ['bir_cor', 'doc-bir-cor.jpg', sprintf('DEMO-BIR-%04d', $v['n']), 'NO_EXPIRATION'],
            'identity_evidence' => ['GOVERNMENT_ID', 'doc-identity.jpg', sprintf('DEMO-ID-%06d', $v['n']), 'DATE'],
        ];
        foreach ($documents as $key => [$type, $file, $number, $expiration]) {
            $this->ensureDocument($v, $organizationId, $owner, $adminId, $key, $type, $file, $number, $expiration);
        }
    }

    private function agreementVersion(string $code): string
    {
        $id = DB::table('agreement_versions as v')->join('agreement_documents as d', 'd.id', '=', 'v.agreement_document_id')->where('d.code', $code)->whereNull('v.retired_at')->where('v.effective_at', '<=', now())->orderByDesc('v.version')->value('v.id');
        if ($id === null) {
            throw new RuntimeException('The published agreement '.$code.' is unavailable.');
        }

        return (string) $id;
    }

    /** @param array<string, mixed> $v */
    private function ensureTaxProfile(array $v, string $organizationId, User $owner, ?int $adminId): void
    {
        $profile = DB::table('vendor_tax_profiles')->where('vendor_organization_id', $organizationId)->first();
        if ($profile?->current_version_id !== null && $profile->status === 'APPROVED') {
            return;
        }
        $profileId = $profile === null ? (string) Str::uuid7() : (string) $profile->id;
        if ($profile === null) {
            DB::table('vendor_tax_profiles')->insert(['id' => $profileId, 'vendor_organization_id' => $organizationId, 'environment' => 'TEST', 'status' => 'INCOMPLETE', 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);
        }
        $core = $this->coreTin($v['n']);
        $key = 'TEST|'.$core;
        $keyHash = hash_hmac('sha256', $key, (string) config('app.key'));
        $details = ['vat_declared' => $v['vat'] === 'VAT', 'business_type' => $v['business_type'], 'registered_identity' => $v['store_name'], 'withholding_scenario' => 'DEMO_PLATFORM_WITHHOLDER', 'tax_relief_claimed' => false];
        $content = json_encode(['key_hash' => $keyHash, 'tin' => $core.'000', 'details' => $details], JSON_THROW_ON_ERROR);
        $versionId = (string) Str::uuid7();
        DB::table('vendor_tax_profile_versions')->insert([
            'id' => $versionId, 'vendor_tax_profile_id' => $profileId, 'version' => 1, 'representative_version_id' => null, 'taxpayer_key_hash' => $keyHash, 'taxpayer_key_encrypted' => Crypt::encryptString($key),
            'entity_class' => 'INDIVIDUAL', 'registration_category' => 'OTHER', 'vat_category' => $v['vat'], 'tin_encrypted' => Crypt::encryptString($core.'000'), 'tin_hash' => hash_hmac('sha256', $core, (string) config('app.key')),
            'declaration_claim' => false, 'taxable_year' => null, 'bir_cor_reference' => sprintf('DEMO-BIR-%04d', $v['n']), 'vat_verified_category' => $v['vat'], 'fiscal_year_start_month' => 1, 'effective_from' => now(),
            'submitted_by_user_id' => $owner->getKey(), 'approved_by_user_id' => $adminId, 'approved_at' => $adminId === null ? null : now(), 'content_hash' => hash('sha256', $content), 'taxpayer_key_last4' => substr($key, -4), 'tin_last4' => substr($core, -4),
            'tax_details' => json_encode($details, JSON_THROW_ON_ERROR), 'drafted_by_user_id' => $owner->getKey(), 'owner_attested_at' => now(), 'owner_attested_by_user_id' => $owner->getKey(), 'created_at' => now(), 'updated_at' => now(),
        ]);
        $rule = DB::table('tax_rule_versions')->where('environment', 'DEMO')->where('code', 'DEMO_PLATFORM_WITHHOLDER')->where('version', 1)->first(['id', 'rules']);
        if ($rule === null) {
            throw new RuntimeException('The approved DEMO withholding fixture is unavailable.');
        }
        $rules = is_string($rule->rules) ? (json_decode($rule->rules, true) ?: []) : (array) $rule->rules;
        DB::table('withholding_assignments')->insert(['id' => (string) Str::uuid7(), 'vendor_tax_profile_version_id' => $versionId, 'tax_rule_version_id' => $rule->id, 'atc_code' => null, 'rate_basis_points' => (int) ($rules['rate_basis_points'] ?? 50),
            'effective_from' => now(), 'effective_until' => null, 'reason' => 'DEMO fixture selected for the demo Vendor; not evidence of LIVE withholding responsibility.', 'created_at' => now(), 'updated_at' => now()]);
        DB::table('vendor_tax_profiles')->where('id', $profileId)->update(['current_version_id' => $versionId, 'status' => 'APPROVED', 'attested_at' => now(), 'attested_by_user_id' => $owner->getKey(), 'updated_at' => now()]);
    }

    /** Fictional, obviously fake nine-digit taxpayer core (never a real TIN). */
    private function coreTin(int $n): string
    {
        return '999'.sprintf('%03d', $n).'999';
    }

    /** @param array<string, mixed> $v */
    private function ensureDocument(array $v, string $organizationId, User $owner, ?int $adminId, string $key, string $type, string $assetName, string $number, string $expiration): void
    {
        if (DB::table('vendor_documents')->where('vendor_organization_id', $organizationId)->where('requirement_key', $key)->exists()) {
            return;
        }
        $requirement = DB::table('vendor_onboarding_requirements')->where('vendor_organization_id', $organizationId)->where('requirement_key', $key)->where('is_current', true)->first(['id', 'status']);
        if ($requirement === null || $requirement->status === 'NOT_APPLICABLE') {
            return;
        }
        $bytes = (string) file_get_contents($this->asset($v['slug'], $assetName));
        $disk = (string) config('materyalph.files.disk', 'local');
        $fileId = (string) Str::uuid7();
        $objectKey = 'private/vendors/'.$organizationId.'/onboarding/'.$fileId.'.jpg';
        if (! Storage::disk($disk)->put($objectKey, $bytes, 'private')) {
            throw new RuntimeException('The sample evidence could not be stored.');
        }
        $hash = hash('sha256', $bytes);
        DB::transaction(function () use ($organizationId, $owner, $adminId, $key, $type, $number, $expiration, $requirement, $bytes, $disk, $fileId, $objectKey, $hash, $v): void {
            DB::table('files')->insert(['id' => $fileId, 'owner_type' => 'VENDOR_ORGANIZATION', 'owner_id' => $organizationId, 'purpose' => 'BUSINESS_DOCUMENT', 'visibility' => 'PRIVATE', 'content_type' => 'image/jpeg', 'byte_size' => strlen($bytes), 'checksum_sha256' => $hash,
                'scan_state' => 'CLEAN', 'object_key' => $objectKey, 'retention_class' => 'VENDOR_ONBOARDING', 'original_name' => 'demo-'.$v['slug'].'-'.$key.'.jpg', 'uploaded_by_user_id' => $owner->getKey(),
                'metadata' => json_encode(['disk' => $disk, 'source' => 'VENDOR_ONBOARDING', 'purpose' => 'BUSINESS_DOCUMENT', 'demo' => true], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
            $documentId = (string) Str::uuid7();
            $versionId = (string) Str::uuid7();
            DB::table('vendor_documents')->insert(['id' => $documentId, 'vendor_organization_id' => $organizationId, 'onboarding_step_id' => $requirement->id, 'requirement_key' => $key, 'document_type' => $type, 'status' => 'SUBMITTED', 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);
            DB::table('vendor_document_versions')->insert(['id' => $versionId, 'business_document_id' => $documentId, 'file_id' => $fileId, 'version' => 1, 'uploaded_by_user_id' => $owner->getKey(), 'content_hash' => $hash, 'mime_type' => 'image/jpeg', 'byte_size' => strlen($bytes),
                'content_validation_state' => 'VALID', 'scan_state' => 'CLEAN', 'vendor_metadata' => json_encode(['source' => 'DEMO_SEED', 'expiration_status' => 'NOT_APPLICABLE'], JSON_THROW_ON_ERROR), 'submitted_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
            DB::table('vendor_documents')->where('id', $documentId)->update(['review_submitted' => true, 'current_version_id' => $versionId, 'status' => 'APPROVED', 'lock_version' => 2, 'updated_at' => now()]);
            if ($adminId !== null) {
                DB::table('business_document_reviews')->insert(['id' => (string) Str::uuid7(), 'business_document_version_id' => $versionId, 'reviewer_user_id' => $adminId, 'decision' => 'APPROVED', 'reason' => 'approve (demo seed)', 'verified_document_number' => $number,
                    'verified_issue_date' => now()->subYear()->toDateString(), 'expiration_kind' => $expiration, 'verified_expiration_date' => $expiration === 'DATE' ? now()->addYears(2)->toDateString() : null,
                    'evidence_source' => null, 'remarks' => 'Fictional sample document approved for the capstone demonstration.', 'reviewed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
            }
        });
    }

    // ---------------------------------------------------------------------------------------------------------
    // Payment connection
    // ---------------------------------------------------------------------------------------------------------

    /** @param array<string, mixed> $v */
    private function ensurePayment(array $v, string $organizationId, User $owner, string $payments): void
    {
        $account = DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organizationId)->first();
        if ($account?->connection_status === 'CONNECTED_TEST' && $account->provider_status === 'LIVE') {
            return;
        }
        if ($payments === 'simulate') {
            $values = ['provider' => 'XENDIT', 'environment' => 'TEST', 'provider_account_id' => 'demo_sim_'.Str::lower(Str::random(16)), 'provider_associated_at' => now(), 'onboarding_requested_at' => now(), 'provider_created_at' => now(), 'provider_api_version' => 'XENDIT_ACCOUNTS_V2',
                'connection_status' => 'CONNECTED_TEST', 'provider_status' => 'LIVE', 'capabilities' => json_encode(['test_account_provisioned' => true, 'simulated' => true], JSON_THROW_ON_ERROR), 'last_reconciled_at' => now(), 'lock_version' => 1, 'updated_at' => now()];
            $account === null ? DB::table('vendor_payment_accounts')->insert($values + ['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'created_at' => now()]) : DB::table('vendor_payment_accounts')->where('id', $account->id)->update($values);
            $this->notes['payment_mode'] = 'simulated (automated tests only; not a Xendit account)';

            return;
        }
        $storeEmail = (string) DB::table('vendor_organizations')->where('id', $organizationId)->value('store_email');
        if ($account === null) {
            DB::table('vendor_payment_accounts')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'provider' => 'XENDIT', 'environment' => 'TEST', 'connection_status' => 'CONNECTING', 'onboarding_requested_at' => now(), 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);
        } elseif ($account->provider_associated_at === null && $account->onboarding_requested_at !== null) {
            $this->notes['payment'] = 'UNCERTAIN: an earlier Xendit request has no confirmed result; check the Xendit dashboard before retrying (no duplicate account was created).';

            return;
        } elseif ($account->provider_associated_at === null) {
            DB::table('vendor_payment_accounts')->where('id', $account->id)->update(['connection_status' => 'CONNECTING', 'onboarding_requested_at' => now(), 'updated_at' => now()]);
        }
        $account = DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organizationId)->first();
        if ($account->provider_associated_at === null) {
            try {
                $result = $this->xendit->initiate($storeEmail, (string) $v['store_name']);
            } catch (XenditProviderUnavailable $error) {
                $definite = $error->creationRejected;
                DB::table('vendor_payment_accounts')->where('id', $account->id)->update(['connection_status' => $definite ? 'CONNECTION_FAILED' : 'CONNECTING', 'onboarding_requested_at' => $definite ? null : $account->onboarding_requested_at, 'last_error_code' => $error->providerErrorCode ?? 'PROVIDER_UNAVAILABLE', 'updated_at' => now()]);
                $this->notes['payment'] = ($definite ? 'Xendit rejected creation (HTTP '.($error->providerHttpStatus ?? '?').', '.($error->providerErrorCode ?? 'unknown').')' : 'Xendit result unconfirmed; not retried').'. Re-run the command to retry.';

                return;
            }
            DB::table('vendor_payment_accounts')->where('id', $account->id)->update(['provider_account_id' => $result['provider_account_id'], 'provider_associated_at' => now(), 'provider_status' => $result['status'], 'connection_status' => 'PENDING',
                'provider_created_at' => $result['provider_created_at'], 'provider_api_version' => 'XENDIT_ACCOUNTS_V2', 'last_reconciled_at' => now(), 'capabilities' => json_encode(['test_account_provisioned' => false], JSON_THROW_ON_ERROR), 'last_error_code' => null, 'lock_version' => (int) $account->lock_version + 1, 'updated_at' => now()]);
            $account = DB::table('vendor_payment_accounts')->where('id', $account->id)->first();
        }
        try {
            $reconciled = $this->xendit->reconcile((string) $account->provider_account_id);
        } catch (XenditProviderUnavailable) {
            $this->notes['payment'] = 'Xendit account created but reconciliation is unavailable; re-run the command to reconcile.';

            return;
        }
        $live = $reconciled['status'] === 'LIVE';
        DB::table('vendor_payment_accounts')->where('id', $account->id)->update(['connection_status' => $live ? 'CONNECTED_TEST' : 'PENDING', 'provider_status' => $reconciled['status'], 'capabilities' => json_encode(['test_account_provisioned' => $live], JSON_THROW_ON_ERROR),
            'invitation_url_encrypted' => null, 'last_reconciled_at' => now(), 'last_error_code' => null, 'lock_version' => (int) $account->lock_version + 1, 'updated_at' => now()]);
        if (! $live) {
            $this->notes['payment'] = 'Xendit sub-account is '.$reconciled['status'].', not LIVE yet; re-run the command to reconcile.';
        }
    }

    // ---------------------------------------------------------------------------------------------------------
    // Approval and activation
    // ---------------------------------------------------------------------------------------------------------

    private function approveVerification(string $organizationId, User $owner, ?int $adminId): void
    {
        $now = now();
        $rows = DB::table('vendor_onboarding_requirements')->where('vendor_organization_id', $organizationId)->where('is_current', true)->where('section', 'STORE_VERIFICATION')
            ->where('level', '!=', 'OPTIONAL')->whereNotIn('status', ['NOT_APPLICABLE', 'COMPLETED'])->get(['id', 'lock_version']);
        foreach ($rows as $row) {
            DB::table('vendor_onboarding_requirements')->where('id', $row->id)->update(['status' => 'APPROVED', 'submitted_by_user_id' => $owner->getKey(), 'submitted_at' => $now, 'reviewed_by_user_id' => $adminId, 'reviewed_at' => $now, 'blocking' => false, 'blocking_reason' => null, 'lock_version' => (int) $row->lock_version + 1, 'updated_at' => $now]);
        }
        DB::table('vendor_organizations')->where('id', $organizationId)->update(['store_verification_status' => 'APPROVED', 'updated_at' => $now]);
    }

    private function activate(string $organizationId, User $owner, ?int $adminId): void
    {
        $setupOpen = DB::table('vendor_onboarding_requirements')->where('vendor_organization_id', $organizationId)->where('is_current', true)->where('section', 'STORE_SETUP')->where('level', '!=', 'OPTIONAL')
            ->whereNotIn('status', ['COMPLETED', 'NOT_APPLICABLE'])->pluck('requirement_key')->all();
        if ($setupOpen === []) {
            DB::table('vendor_organizations')->where('id', $organizationId)->update(['store_setup_status' => 'COMPLETED', 'updated_at' => now()]);
        } else {
            $this->notes['setup'] = 'open: '.implode(', ', $setupOpen);
        }
        $organization = DB::table('vendor_organizations')->where('id', $organizationId)->first(['store_activation_status', 'lock_version']);
        if ($organization->store_activation_status === 'ACTIVE') {
            return;
        }
        $readiness = $this->gate->evaluate($organizationId);
        if (! $readiness['ready']) {
            $this->notes['activation'] = 'blocked: '.implode(', ', array_column($readiness['blockers'], 'key'));

            return;
        }
        DB::table('vendor_organizations')->where('id', $organizationId)->update(['store_activation_status' => 'ACTIVE', 'lock_version' => (int) $organization->lock_version + 1, 'updated_at' => now()]);
        DB::table('vendor_activation_history')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'state_before' => $organization->store_activation_status, 'state_after' => 'ACTIVE', 'result' => 'ACTIVATED', 'reason' => null,
            'blockers' => '[]', 'readiness_snapshot' => json_encode($readiness, JSON_THROW_ON_ERROR), 'actor_user_id' => $owner->getKey(), 'source' => 'VENDOR', 'recorded_at' => now(), 'rule_version' => StoreActivationGate::RULE_VERSION, 'created_at' => now(), 'updated_at' => now()]);
        $this->audit->account($this->requestFor($owner), 'VENDOR_ACTIVATED', 'VENDOR_ORGANIZATION', $organizationId, after: ['status' => 'ACTIVE', 'source' => 'DEMO_SEED']);
    }

    // ---------------------------------------------------------------------------------------------------------
    // Catalog
    // ---------------------------------------------------------------------------------------------------------

    /** @param array<string, mixed> $v */
    private function publishCatalog(array $v, string $organizationId, User $owner): void
    {
        if (DB::table('vendor_organizations')->where('id', $organizationId)->value('store_activation_status') !== 'ACTIVE') {
            $this->notes['catalog'] = 'skipped: the Store is not active yet';

            return;
        }
        $units = DB::table('units')->pluck('id', 'code')->all();
        $categories = DB::table('material_categories')->pluck('id', 'name')->all();
        $tags = DB::table('material_tags')->pluck('id', 'name')->all();
        $materials = DB::table('materials')->get(['id', 'code', 'material_category_id', 'regulated'])->keyBy('code');
        $failures = [];
        foreach ($v['products'] as $product) {
            try {
                $this->publishProduct($v, $organizationId, $owner, $product, $units, $categories, $tags, $materials);
            } catch (Throwable $error) {
                $detail = $error instanceof AuthenticationException ? json_encode($error->details, JSON_UNESCAPED_SLASHES) : '';
                $failures[] = $product['sku'].': '.Str::limit($error->getMessage().' '.$detail, 400);
            }
        }
        if ($failures !== []) {
            $this->notes['catalog'] = implode(' | ', $failures);
        }
    }

    /**
     * @param  array<string, mixed>  $v
     * @param  array<string, mixed>  $p
     * @param  array<string, string>  $units
     * @param  array<string, string>  $categories
     * @param  array<string, string>  $tags
     * @param  Collection<int|string, \stdClass>  $materials
     */
    private function publishProduct(array $v, string $organizationId, User $owner, array $p, array $units, array $categories, array $tags, $materials): void
    {
        $listingId = DB::table('vendor_listings')->where('vendor_organization_id', $organizationId)->whereNull('removed_at')->where('vendor_sku', $p['sku'])->value('id');
        if ($listingId !== null && DB::table('vendor_listings')->where('id', $listingId)->value('status') === 'ACTIVE') {
            return;
        }
        $request = $this->requestFor($owner);
        if ($listingId === null) {
            $listingId = (string) $this->catalog->create($this->withKey($request), ['display_name' => $p['name'], 'vendor_sku' => $p['sku']])['id'];
        }
        $classification = ['material_category_id' => $categories[$p['cat']] ?? throw new RuntimeException('Unknown category '.$p['cat'])];
        if ($p['mat'] !== null) {
            $material = $materials[$p['mat']] ?? throw new RuntimeException('Unknown material '.$p['mat']);
            if ($material->regulated && ! isset($p['compliance'])) {
                throw new RuntimeException('Regulated material '.$p['mat'].' needs a PS License No. or ICC sticker serial (compliance block) from the DTI-BPS registers.');
            }
            $classification = ['material_id' => (string) $material->id, 'material_category_id' => (string) $material->material_category_id, 'material_match' => 'EXACT'];
        } else {
            $classification += ['material_id' => null, 'other_label' => $p['label']];
        }
        // A regulated listing names its manufacturer (from the DTI-BPS register record) before its marking is submitted.
        $maker = isset($p['maker']) ? ['manufacturer' => $p['maker']['name'], 'manufacturer_address' => $p['maker']['address'], 'country_of_manufacture' => $p['maker']['country']] : [];
        $this->catalog->update($request, (string) $listingId, $classification + $maker + [
            'lock_version' => $this->lock((string) $listingId), 'description' => $p['desc'], 'brand' => $p['brand'], 'technical_attributes' => $p['attr'],
            'tag_ids' => array_map(fn (string $tag): string => $tags[$tag] ?? throw new RuntimeException('Unknown tag '.$tag), $p['tags']),
            'custom_tags' => $p['custom_tags'] ?? [],
        ]);

        $vat = $v['vat'] === 'VAT' ? 'VAT_12' : 'NON_VAT';
        $rows = [];
        foreach ($p['v'] as $variant) {
            $row = ['sku' => $variant['sku'], 'label' => $variant['label'], 'unit_id' => $units[$variant['unit']] ?? throw new RuntimeException('Unknown unit '.$variant['unit']), 'pack_quantity' => (string) $variant['pack'],
                'price_centavos' => (int) round($variant['php'] * 100), 'tax_category' => $vat, 'weight_kg' => $variant['kg'], 'length_cm' => $variant['dim'][0], 'width_cm' => $variant['dim'][1], 'height_cm' => $variant['dim'][2],
                'quantity_on_hand' => (string) $variant['stock'], 'attributes' => $variant['attr'] ?? []];
            if (isset($variant['tiers'])) {
                $row['volume_tiers'] = array_map(static fn (array $tier): array => ['minimum_quantity' => (string) $tier[0], 'price_centavos' => (int) round($tier[1] * 100)], $variant['tiers']);
            }
            $rows[] = $row;
        }
        if (! DB::table('listing_variants')->where('vendor_listing_id', $listingId)->exists()) {
            $this->catalog->saveVariants($request, (string) $listingId, ['lock_version' => $this->lock((string) $listingId), 'variants' => $rows]);
        }
        if (! DB::table('listing_media')->where('vendor_listing_id', $listingId)->where('status', 'READY')->exists()) {
            foreach (array_slice($this->productPhotos($v['slug'], $p['sku']), 0, VendorCatalogService::MAX_MEDIA) as $n => $path) {
                $this->catalog->uploadMedia($request, (string) $listingId, $this->upload($path, basename($path), 'image/jpeg'), $n === 0 ? $p['name'] : $p['name'].', photo '.($n + 1), null);
            }
        }
        if (isset($p['compliance'])) {
            $this->verifyCompliance($v, $p, (string) $listingId, $owner);
        }
        $this->catalog->publish($this->withKey($request), (string) $listingId, $this->lock((string) $listingId));
    }

    /**
     * Submits the product's PS License No. or ICC sticker serial exactly as a Vendor would through Manual Entry: the
     * marking photo is uploaded as evidence, then Review and Confirm runs in AUTOMATIC mode. Only a current register
     * match verifies it; anything else fails here (COMPLIANCE_REGISTER_NOT_MATCHED) and is reported, never forced.
     *
     * @param  array<string, mixed>  $v
     * @param  array<string, mixed>  $p
     */
    private function verifyCompliance(array $v, array $p, string $listingId, User $owner): void
    {
        $status = DB::table('vendor_listings')->where('id', $listingId)->value('compliance_status');
        if ($status === 'VERIFIED') {
            return;
        }
        $marking = (string) $p['compliance']['marking'];
        $photos = $this->productPhotos($v['slug'], $p['sku']);
        $photo = $photos[((int) ($p['compliance']['photo'] ?? 1)) - 1] ?? $photos[0];
        $evidence = $this->compliance->uploadEvidence($this->requestFor($owner), $listingId, 'MANUAL', $this->upload($photo, 'marking-'.basename($photo), 'image/jpeg'), null, $marking);
        $this->compliance->submit($this->withKey($this->requestFor($owner)), $listingId, [
            'listing_lock_version' => $this->lock($listingId), 'path' => 'MANUAL', 'review_mode' => 'AUTOMATIC', 'evidence_ids' => [$evidence['evidence_id']],
            'marking_type' => $marking, 'certificate_number' => (string) $p['compliance']['number'], 'confirmed' => true,
        ]);
    }

    /**
     * Regulated listings need an active DTI-BPS register snapshot to match against. When the selected Vendors list any
     * and no snapshot of that kind is active, the register copy in materials/ is imported and activated as the first
     * Admin would through Product Compliance; an existing active snapshot is never replaced.
     *
     * @param  list<array<string, mixed>>  $vendors
     * @return array<string, string>
     */
    private function ensureComplianceRegisters(array $vendors, ?int $adminId): array
    {
        $needed = [];
        foreach ($vendors as $vendor) {
            foreach ($vendor['products'] as $product) {
                if (isset($product['compliance'])) {
                    $needed[$product['compliance']['marking'] === 'ICC_STICKER' ? 'ICC_CERTIFICATE' : 'PS_LICENSE'] = true;
                }
            }
        }
        $notes = [];
        foreach (array_keys($needed) as $kind) {
            if (DB::table('compliance_reference_registers')->where('register_kind', $kind)->where('status', 'ACTIVE')->exists()) {
                continue;
            }
            [$file, $reference] = self::REGISTER_FILES[$kind];
            $path = $this->registerDirectory().'/'.$file;
            if ($adminId === null || ! is_file($path)) {
                $notes['register_'.$kind] = 'No active '.$kind.' register and '.($adminId === null ? 'no active Admin to import it' : 'materials/'.$file.' is missing').'; regulated listings stay unverified.';

                continue;
            }
            $snapshot = $this->registers->import($this->upload($path, $file, 'text/csv'), $kind, $reference, now('Asia/Manila')->toDateString(), $adminId);
            $this->registers->activate($snapshot['id'], $adminId);
            $notes['register_'.$kind] = 'imported and activated materials/'.$file.' ('.$snapshot['row_count'].' rows)';
        }

        return $notes;
    }

    private function registerDirectory(): string
    {
        $configured = (string) config('materyalph.demo.register_directory', '');

        return $configured !== '' ? $configured : dirname(base_path(), 2).'/materials';
    }

    private function lock(string $listingId): int
    {
        return (int) DB::table('vendor_listings')->where('id', $listingId)->value('lock_version');
    }

    /** Keeps Marketplace eligibility honest: a demo that sat for days would otherwise hide every listing as stale stock. */
    private function refreshStock(string $organizationId): void
    {
        DB::table('inventory_items')->whereIn('listing_variant_id', DB::table('listing_variants as v')->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')->where('l.vendor_organization_id', $organizationId)->select('v.id'))
            ->update(['confirmed_at' => now(), 'updated_at' => now()]);
        DB::table('vendor_listings')->where('vendor_organization_id', $organizationId)->where('status', 'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED')->update(['status' => 'ACTIVE', 'updated_at' => now()]);
    }

    // ---------------------------------------------------------------------------------------------------------
    // Helpers
    // ---------------------------------------------------------------------------------------------------------

    private function requestFor(User $user): Request
    {
        $user->refresh();
        $request = Request::create('/api/v1/demo-seed', 'POST');
        $request->setUserResolver(fn () => $user);
        $request->attributes->set('account_scope', $this->access->resolve($user));
        $request->attributes->set('correlation_id', (string) Str::uuid());

        return $request;
    }

    private function withKey(Request $request): Request
    {
        $request->headers->set('Idempotency-Key', (string) Str::uuid());

        return $request;
    }

    private function asset(string $slug, string $name): string
    {
        $path = base_path(self::ASSET_DIRECTORY.'/vendors/'.$slug.'/'.$name);
        if (! is_file($path)) {
            throw new RuntimeException('Demo asset missing: '.$slug.'/'.$name.'. Run tools/demo-assets/generate_demo_vendor_assets.py.');
        }

        return $path;
    }

    /** Third-party photos live in a git-ignored folder filled by tools/demo-assets/fetch_demo_photos.py. */
    private function photoDirectory(): string
    {
        $configured = (string) config('materyalph.demo.photo_directory', '');

        return $configured !== '' ? $configured : base_path(self::ASSET_DIRECTORY.'/photos');
    }

    private function photo(string $relative): string
    {
        $path = $this->photoDirectory().'/'.$relative;
        if (! is_file($path)) {
            throw new RuntimeException('Demo photo missing: '.$relative.'. Run py tools/demo-assets/fetch_demo_photos.py first.');
        }

        return $path;
    }

    /** @return list<string> Listing photos in display order: <SKU>-1.jpg, <SKU>-2.jpg, ... */
    private function productPhotos(string $slug, string $sku): array
    {
        $paths = [];
        for ($n = 1; is_file($path = $this->photoDirectory().'/products/'.$slug.'/'.$sku.'-'.$n.'.jpg'); $n++) {
            $paths[] = $path;
        }
        if ($paths === []) {
            throw new RuntimeException('Demo product photo missing: products/'.$slug.'/'.$sku.'-1.jpg. Run py tools/demo-assets/fetch_demo_photos.py first.');
        }

        return $paths;
    }

    private function upload(string $path, string $name, string $mime): UploadedFile
    {
        return new UploadedFile($path, $name, $mime, null, true);
    }

    /** @return array<string, mixed> */
    private function loadCredentials(string $path): array
    {
        if (is_file($path)) {
            $decoded = json_decode((string) file_get_contents($path), true);
            if (is_array($decoded)) {
                return $decoded;
            }
        }

        return ['vendors' => []];
    }

    /** @param array<string, mixed> $credentials */
    private function saveCredentials(string $path, array $credentials, string $password): void
    {
        $credentials['note'] = 'Demo Vendor sign-in details for the capstone demonstration. Fictional stores; TEST environment only. Do not commit or share.';
        $credentials['password'] = $password;
        $credentials['generated_at'] = now()->toIso8601String();
        if (! is_dir(dirname($path))) {
            mkdir(dirname($path), 0775, true);
        }
        file_put_contents($path, json_encode($credentials, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_THROW_ON_ERROR));
    }
}
