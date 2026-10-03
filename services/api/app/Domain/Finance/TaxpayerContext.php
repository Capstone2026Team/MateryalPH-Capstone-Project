<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use App\Domain\Identity\AuthenticationException;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;

/**
 * Resolves a Vendor's effective tax identity for one remittance instant: the keyed taxpayer hash (never a raw
 * TIN), the taxable-year boundary from the recorded fiscal-year start month (Asia/Manila), the DEMO withholding
 * scenario, the declared outside-platform total and overlap answer, the declared prior-year position, and any
 * Admin-reviewed in-period relief evidence. An uploaded declaration alone is a claim, never relief.
 */
final class TaxpayerContext
{
    public const SCENARIOS = ['DEMO_PLATFORM_WITHHOLDER', 'DEMO_PROVIDER_WITHHOLDER'];

    /** @return array<string, mixed> */
    public function forOrganization(string $organizationId, CarbonImmutable $instant): array
    {
        $version = DB::table('vendor_tax_profiles as p')->join('vendor_tax_profile_versions as v', 'v.id', '=', 'p.current_version_id')
            ->where('p.vendor_organization_id', $organizationId)->first(['p.id as profile_id', 'v.id as version_id', 'v.taxpayer_key_hash', 'v.fiscal_year_start_month', 'v.tax_details', 'v.taxpayer_key_last4', 'v.tin_last4', 'v.vat_category', 'v.vat_verified_category', 'v.entity_class']);
        if ($version === null || ! is_string($version->taxpayer_key_hash) || trim($version->taxpayer_key_hash) === '') {
            throw new AuthenticationException('TAX_PROFILE_UNAVAILABLE', 'The Vendor Tax Profile has no validated taxpayer identity.', 409);
        }
        $details = is_string($version->tax_details) ? (json_decode($version->tax_details, true) ?: []) : [];
        $startMonth = max(1, min(12, (int) ($version->fiscal_year_start_month ?? 1)));
        [$year, $start, $end] = self::taxableYear($instant, $startMonth);
        $scenario = strtoupper((string) ($details['withholding_scenario'] ?? config('finance.withholding_scenario') ?? 'DEMO_PLATFORM_WITHHOLDER'));
        $externalPeriod = isset($details['outside_platform_period']) ? (string) $details['outside_platform_period'] : null;
        $externalApplies = $externalPeriod === null || $externalPeriod === '' || str_contains($externalPeriod, (string) $year);

        return [
            'profile_id' => (string) $version->profile_id, 'version_id' => (string) $version->version_id, 'taxpayer_key' => (string) $version->taxpayer_key_hash,
            'taxpayer_key_last4' => $version->taxpayer_key_last4, 'tin_last4' => $version->tin_last4, 'vat_category' => $version->vat_verified_category ?? $version->vat_category,
            'entity_class' => $version->entity_class, 'fiscal_year_start_month' => $startMonth, 'taxable_year' => $year, 'year_start_at' => $start, 'year_end_at' => $end,
            'scenario' => in_array($scenario, self::SCENARIOS, true) ? $scenario : 'DEMO_PLATFORM_WITHHOLDER',
            'external_declared_centavos' => $externalApplies ? max(0, (int) ($details['outside_platform_amount_centavos'] ?? 0)) : 0,
            'external_overlap_unresolved' => $externalApplies && (int) ($details['outside_platform_amount_centavos'] ?? 0) > 0 && (bool) ($details['outside_platform_overlap'] ?? false),
            'declared_prior_year_centavos' => isset($details['prior_year_amount_centavos']) ? max(0, (int) $details['prior_year_amount_centavos']) : null,
            'relief_claimed' => (bool) ($details['tax_relief_claimed'] ?? $details['declaration'] ?? false),
        ];
    }

    /** @return array{0: int, 1: CarbonImmutable, 2: CarbonImmutable} taxable-year label (its starting year), start, end */
    public static function taxableYear(CarbonImmutable $instant, int $startMonth): array
    {
        $local = $instant->setTimezone('Asia/Manila');
        $year = $local->month >= $startMonth ? $local->year : $local->year - 1;
        $start = CarbonImmutable::create($year, $startMonth, 1, 0, 0, 0, 'Asia/Manila');

        return [$year, $start, $start->addYear()];
    }

    /**
     * The Admin-reviewed relief declaration that covers this taxable year and instant, or null. Only an APPROVED
     * TAX_RELIEF_DECLARATION reviewed no later than the instant counts; a claim, an upload or an expired period
     * never does.
     */
    public function reliefBasis(string $organizationId, int $taxableYear, CarbonImmutable $instant, bool $claimed): ?string
    {
        if (! $claimed) {
            return null;
        }
        $date = $instant->setTimezone('Asia/Manila')->toDateString();
        $rows = DB::table('tax_evidence as e')->join('vendor_tax_profile_versions as v', 'v.id', '=', 'e.vendor_tax_profile_version_id')
            ->join('vendor_tax_profiles as p', 'p.id', '=', 'v.vendor_tax_profile_id')->where('p.vendor_organization_id', $organizationId)
            ->where('e.evidence_type', 'TAX_RELIEF_DECLARATION')->where('e.review_state', 'APPROVED')->whereNotNull('e.reviewed_at')->where('e.reviewed_at', '<=', $instant)
            ->where(fn ($query) => $query->whereNull('e.valid_from')->orWhere('e.valid_from', '<=', $date))
            ->where(fn ($query) => $query->whereNull('e.valid_until')->orWhere('e.valid_until', '>=', $date))
            ->orderByDesc('e.reviewed_at')->get(['e.id', 'v.taxable_year', 'v.tax_details', 'e.valid_from', 'e.valid_until']);
        foreach ($rows as $row) {
            $details = is_string($row->tax_details) ? (json_decode($row->tax_details, true) ?: []) : [];
            $declaredYear = $row->taxable_year ?? ($details['declaration_year'] ?? null);
            if ($declaredYear === null || (int) $declaredYear === $taxableYear) {
                return (string) $row->id;
            }
        }

        return null;
    }
}
