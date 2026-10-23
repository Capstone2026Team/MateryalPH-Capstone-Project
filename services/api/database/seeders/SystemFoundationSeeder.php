<?php

declare(strict_types=1);

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Laravel\Passport\ClientRepository;
use RuntimeException;

final class SystemFoundationSeeder extends Seeder
{
    /**
     * Fixed start of the version-1 commission and DEMO tax rules. A seed-time date would move with every reseed,
     * rewriting when an approved version took effect; existing versions are therefore never updated here.
     */
    private const FOUNDATION_EFFECTIVE_FROM = '2026-01-01 00:00:00+08:00';

    public function run(): void
    {
        $this->agreements();
        $this->roles();
        $this->financePolicies();
        $this->taxRules();
        $this->passportClient();
    }

    private function agreements(): void
    {
        foreach ([
            ['TERMS_OF_SERVICE', 'ALL', 'MateryalPH Capstone Terms of Service', '/legal/terms-of-service', 2, true],
            ['PRIVACY_NOTICE', 'ALL', 'MateryalPH Capstone Privacy Notice', '/legal/privacy-notice', 2, true],
            ['VENDOR_CODE_OF_CONDUCT', 'VENDOR', 'Vendor Code of Conduct — Capstone/Test', '/legal/vendor-code-of-conduct', 2, true],
            ['VENDOR_COMMISSION_TEST', 'VENDOR', 'Vendor Commission Terms — TEST/DEMO', '/legal/vendor-commission-test', 1, true],
            // Accepted per order through the NRPC disclosure, never as an account-level agreement.
            ['NRPC_TERMS', 'ORDER_NRPC', 'Non-Recoverable Preparation Cost Terms — CAPSTONE/TEST', '/legal/nrpc-terms', 2, false],
        ] as [$code, $audience, $title, $uri, $version, $requiresReacceptance]) {
            $path = resource_path('agreements/'.$code.'/'.$version.'.md');
            $content = is_file($path) ? file_get_contents($path) : false;
            if (! is_string($content)) {
                throw new RuntimeException('Required seeded agreement content is unavailable: '.$code);
            }

            $documentId = DB::table('agreement_documents')->where('code', $code)->value('id') ?? (string) Str::uuid7();
            DB::table('agreement_documents')->updateOrInsert(
                ['code' => $code],
                ['id' => $documentId, 'audience' => $audience, 'title' => $title, 'created_at' => now(), 'updated_at' => now()],
            );
            $hash = hash('sha256', $content);
            $existing = DB::table('agreement_versions')->where('agreement_document_id', $documentId)->where('version', $version)->first();
            if ($existing !== null && (! hash_equals($existing->content_hash, $hash) || $existing->content_uri !== $uri)) {
                throw new RuntimeException('Refusing to overwrite an existing agreement version: '.$code.' v'.$version);
            }
            if ($existing === null) {
                DB::table('agreement_versions')->insert([
                    'id' => (string) Str::uuid7(),
                    'agreement_document_id' => $documentId,
                    'version' => $version,
                    'content_hash' => $hash,
                    'content_uri' => $uri,
                    'effective_at' => '2026-09-14 00:00:00+00',
                    'retired_at' => null,
                    'requires_reacceptance' => $requiresReacceptance,
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
            }
            DB::table('agreement_versions')
                ->where('agreement_document_id', $documentId)
                ->where('version', '<', $version)
                ->whereNull('retired_at')
                ->update(['retired_at' => '2026-09-14 00:00:00+00', 'updated_at' => now()]);
        }
    }

    private function roles(): void
    {
        foreach ([
            ['ADMIN_SUPERADMIN', 'ADMIN', 'Superadmin'],
            ['ADMIN_OPERATIONS', 'ADMIN', 'Operations Admin'],
            ['ADMIN_COMPLIANCE', 'ADMIN', 'Compliance Admin'],
            ['ADMIN_VENDOR_VERIFICATION', 'ADMIN', 'Vendor Verification Admin'],
            ['ADMIN_FINANCE', 'ADMIN', 'Finance Admin'],
            ['ADMIN_DISPUTE', 'ADMIN', 'Dispute Admin'],
        ] as [$code, $platform, $name]) {
            DB::table('platform_roles')->updateOrInsert(
                ['code' => $code],
                [
                    'id' => DB::table('platform_roles')->where('code', $code)->value('id') ?? (string) Str::uuid7(),
                    'platform' => $platform,
                    'name' => $name,
                    'system_role' => true,
                    'created_at' => now(),
                    'updated_at' => now(),
                ],
            );
        }
    }

    private function financePolicies(): void
    {
        foreach (['TEST', 'DEMO'] as $environment) {
            if (DB::table('fee_policy_versions')->where('environment', $environment)->where('code', 'MONTHLY_VENDOR_COMMISSION')->where('version', 1)->exists()) {
                continue;
            }
            DB::table('fee_policy_versions')->insert([
                'id' => (string) Str::uuid7(),
                'environment' => $environment,
                'code' => 'MONTHLY_VENDOR_COMMISSION',
                'version' => 1,
                'commission_basis_points' => 200,
                'basis' => 'MATERIALS_AFTER_DISCOUNT_EXCLUDING_VAT',
                'cadence' => 'MONTHLY',
                'effective_from' => self::FOUNDATION_EFFECTIVE_FROM,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }

    private function passportClient(): void
    {
        $hasPersonalClient = DB::table('oauth_clients')->get(['grant_types'])->contains(
            fn (object $client): bool => in_array('personal_access', json_decode($client->grant_types, true) ?? [], true),
        );
        if (! $hasPersonalClient) {
            app(ClientRepository::class)->createPersonalAccessGrantClient('MateryalPH first-party clients', 'users');
        }
    }

    private function taxRules(): void
    {
        foreach ([
            ['DEMO_PLATFORM_WITHHOLDER', ['responsibility' => 'PLATFORM', 'rate_basis_points' => 50, 'label' => 'DEMO platform withholding scenario']],
            ['DEMO_PROVIDER_WITHHOLDER', ['responsibility' => 'PROVIDER', 'rate_basis_points' => 50, 'label' => 'DEMO provider withholding scenario']],
        ] as [$code, $rules]) {
            if (DB::table('tax_rule_versions')->where('environment', 'DEMO')->where('code', $code)->where('version', 1)->exists()) {
                continue;
            }
            DB::table('tax_rule_versions')->insert([
                'id' => (string) Str::uuid7(),
                'environment' => 'DEMO',
                'code' => $code,
                'version' => 1,
                'source_type' => 'APPROVED_FIXTURE',
                'source_reference' => 'MateryalPH Phase 3 DEMO fixture',
                'rules' => json_encode($rules, JSON_THROW_ON_ERROR),
                'effective_from' => self::FOUNDATION_EFFECTIVE_FROM,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}
