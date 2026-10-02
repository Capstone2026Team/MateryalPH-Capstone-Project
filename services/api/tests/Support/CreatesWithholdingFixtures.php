<?php

declare(strict_types=1);

namespace Tests\Support;

use App\Domain\Finance\RemittanceAssessmentService;
use App\Domain\Finance\TaxpayerContext;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * FIN-04A fixtures: canonical remittance groups with an exact G, seeded accumulators, synthetic Admin-reviewed
 * relief evidence (a sample file record, never a real declaration) and declared outside-platform totals.
 */
trait CreatesWithholdingFixtures
{
    /** Assesses one canonical group whose components make G exactly $gross. Returns the assessment row. */
    protected function assessGroup(string $organizationId, string $orderId, string $groupKey, int $gross): object
    {
        $snapshot = (string) DB::table('financial_snapshots')->where('order_id', $orderId)->orderByDesc('version')->value('id');
        $id = app(RemittanceAssessmentService::class)->assess([
            'environment' => 'TEST', 'organization_id' => $organizationId, 'order_id' => $orderId, 'financial_snapshot_id' => $snapshot, 'payment_id' => null,
            'group_key' => $groupKey, 'instant' => CarbonImmutable::now(), 'evidence_origin' => 'SIMULATED',
            'collected' => $gross, 'refunds' => 0, 'delivery' => 0, 'vat' => 0, 'provider_charge' => 0, 'principal' => $gross, 'basis' => ['fixture' => $groupKey],
        ], (string) Str::uuid7());

        return DB::table('remittance_assessments')->where('id', $id)->first();
    }

    /** @return array<string, mixed> */
    protected function taxpayer(string $organizationId): array
    {
        return app(TaxpayerContext::class)->forOrganization($organizationId, CarbonImmutable::now());
    }

    protected function seedAccumulator(string $organizationId, int $accumulated, string $status, string $reason = 'RELIEF_EVIDENCED', ?int $year = null, int $external = 0, string $overlap = 'NONE'): string
    {
        $context = $this->taxpayer($organizationId);
        $year ??= (int) $context['taxable_year'];
        $start = CarbonImmutable::create($year, 1, 1, 0, 0, 0, 'Asia/Manila');
        $id = (string) Str::uuid7();
        DB::table('vendor_withholding_accumulators')->insert(['id' => $id, 'environment' => 'TEST', 'taxpayer_key' => $context['taxpayer_key'], 'organization_id' => $organizationId,
            'taxable_year' => $year, 'year_start_at' => $start, 'year_end_at' => $start->addYear(), 'threshold_centavos' => 50000000, 'g_accumulated_centavos' => $accumulated,
            'g_external_declared_centavos' => $external, 'g_external_overlap_centavos' => 0, 'external_overlap_state' => $overlap, 'withholding_status' => $status, 'status_reason_code' => $reason,
            'crossed_at' => $status === 'SUBJECT_THRESHOLD_BREACHED' ? $start->addMonths(6) : null, 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);

        return $id;
    }

    /** Records an Admin-approved, in-period relief declaration for this taxable year (synthetic sample file). */
    protected function grantRelief(string $organizationId, ?int $reviewerId = null): string
    {
        $version = DB::table('vendor_tax_profiles as p')->join('vendor_tax_profile_versions as v', 'v.id', '=', 'p.current_version_id')->where('p.vendor_organization_id', $organizationId)->first(['v.id', 'v.tax_details']);
        $details = json_decode((string) ($version->tax_details ?? '{}'), true) ?: [];
        $year = (int) $this->taxpayer($organizationId)['taxable_year'];
        DB::table('vendor_tax_profile_versions')->where('id', $version->id)->update(['tax_details' => json_encode(['tax_relief_claimed' => true, 'declaration_year' => $year] + $details, JSON_THROW_ON_ERROR), 'taxable_year' => $year]);

        return $this->declaration($organizationId, 'APPROVED', $reviewerId);
    }

    protected function declaration(string $organizationId, string $reviewState, ?int $reviewerId = null): string
    {
        $versionId = (string) DB::table('vendor_tax_profiles')->where('vendor_organization_id', $organizationId)->value('current_version_id');
        $fileId = (string) Str::uuid7();
        DB::table('files')->insert(['id' => $fileId, 'owner_type' => 'VENDOR_ORGANIZATION', 'owner_id' => $organizationId, 'purpose' => 'VENDOR_TAX_EVIDENCE', 'visibility' => 'PRIVATE',
            'content_type' => 'application/pdf', 'byte_size' => 1024, 'checksum_sha256' => hash('sha256', $fileId), 'scan_state' => 'CLEAN', 'object_key' => 'private/sample/'.$fileId.'.pdf',
            'retention_class' => 'TAX_EVIDENCE', 'created_at' => now(), 'updated_at' => now()]);
        $id = (string) Str::uuid7();
        DB::table('tax_evidence')->insert(['id' => $id, 'vendor_tax_profile_version_id' => $versionId, 'file_id' => $fileId, 'evidence_type' => 'TAX_RELIEF_DECLARATION', 'origin' => 'VENDOR_UPLOAD',
            'document_hash' => hash('sha256', $id), 'review_state' => $reviewState, 'reviewed_by_user_id' => $reviewState === 'APPROVED' ? $reviewerId : null,
            'reviewed_at' => $reviewState === 'APPROVED' ? now()->subDay() : null, 'created_at' => now(), 'updated_at' => now()]);

        return $id;
    }

    /** @param array<string, mixed> $values */
    protected function taxDetails(string $organizationId, array $values): void
    {
        $version = DB::table('vendor_tax_profiles as p')->join('vendor_tax_profile_versions as v', 'v.id', '=', 'p.current_version_id')->where('p.vendor_organization_id', $organizationId)->first(['v.id', 'v.tax_details']);
        $details = json_decode((string) ($version->tax_details ?? '{}'), true) ?: [];
        DB::table('vendor_tax_profile_versions')->where('id', $version->id)->update(['tax_details' => json_encode($values + $details, JSON_THROW_ON_ERROR)]);
    }

    protected function accumulatorFor(string $organizationId, ?int $year = null): object
    {
        $context = $this->taxpayer($organizationId);

        return DB::table('vendor_withholding_accumulators')->where('environment', 'TEST')->where('taxpayer_key', $context['taxpayer_key'])->where('taxable_year', $year ?? $context['taxable_year'])->first();
    }
}
