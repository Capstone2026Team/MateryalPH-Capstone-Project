<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Catalog\CatalogImportService;
use App\Domain\Catalog\ComparableMappingService;
use App\Domain\Catalog\ListingTaxPolicy;
use App\Domain\Catalog\RentalServicePolicy;
use App\Domain\Catalog\VolumePricing;
use App\Domain\Compliance\QrPayloadParser;
use App\Domain\Compliance\RegisterNormalizer;
use PHPUnit\Framework\Attributes\DataProvider;
use PHPUnit\Framework\TestCase;

final class CatalogComplianceRulesTest extends TestCase
{
    /** FIN-02: included VAT on a VAT_12 payable amount is money(L × 12 / 112), half-up. */
    #[DataProvider('vatCases')]
    public function test_included_vat_is_half_up_and_only_for_vat_12(int $payable, string $category, int $expected): void
    {
        self::assertSame($expected, ListingTaxPolicy::includedVatCentavos($payable, $category));
    }

    /** @return iterable<string, array{int, string, int}> */
    public static function vatCases(): iterable
    {
        yield '₱150.00 VAT_12' => [15000, 'VAT_12', 1607];
        yield '₱1.12 VAT_12' => [112, 'VAT_12', 12];
        yield 'half-up at .5 centavo' => [14, 'VAT_12', 2];
        yield 'zero-rated keeps zero VAT' => [15000, 'VAT_ZERO', 0];
        yield 'exempt keeps zero VAT' => [15000, 'VAT_EXEMPT', 0];
        yield 'non-VAT keeps zero VAT' => [15000, 'NON_VAT', 0];
    }

    public function test_peso_strings_become_integer_centavos_without_floating_point(): void
    {
        self::assertSame(28550, CatalogImportService::centavos('285.50'));
        self::assertSame(145050, CatalogImportService::centavos('1,450.5'));
        self::assertSame(1, CatalogImportService::centavos('0.01'));
        self::assertSame(1000000000, CatalogImportService::centavos('10000000'));
        foreach (['0', '0.00', '-5', '1.234', 'abc', '', '1e3'] as $invalid) {
            self::assertNull(CatalogImportService::centavos($invalid), $invalid);
        }
    }

    public function test_normalized_prices_round_half_up_to_eight_decimals(): void
    {
        self::assertSame('0.33333333', ComparableMappingService::roundHalfUp('0.333333334999', 8));
        self::assertSame('0.33333334', ComparableMappingService::roundHalfUp('0.333333335000', 8));
        self::assertSame('15.00000000', ComparableMappingService::roundHalfUp('15', 8));
    }

    public function test_register_values_normalize_deterministically(): void
    {
        self::assertSame('Q7001', RegisterNormalizer::number(' q-7001 '));
        self::assertSame('ICC20260001', RegisterNormalizer::number('ICC-2026/0001'));
        // Printed labels are kept: a register that prints the prefix as part of the number must still match exactly.
        self::assertSame('ICCNO20260001', RegisterNormalizer::number('ICC No. 2026/0001'));
        self::assertSame('SAMPLE CEMENT CORPORATION', RegisterNormalizer::company('Sample  Cement Corporation.'));
        self::assertSame('A AND B STEEL INC', RegisterNormalizer::company('A & B Steel, Inc.'));
        self::assertSame(['PNS07'], RegisterNormalizer::standards('PNS 07:2018'));
        self::assertSame(['PNS156', 'PNS2085'], RegisterNormalizer::standards('PNS 156:2010; PNS 2085:2011'));
        self::assertSame(['PNSISO4427'], RegisterNormalizer::standards('PNS ISO 4427:2002 Amd. 01:2002'));
        self::assertSame([], RegisterNormalizer::standards(null));
    }

    public function test_qr_payloads_are_untrusted_suggestions(): void
    {
        $parser = new QrPayloadParser;
        self::assertSame('UNAVAILABLE', $parser->parse(null)['status']);
        $ps = $parser->parse('PS License No. Q-1234; Manufacturer: Sample Cement Corporation');
        self::assertSame(['status' => 'EXTRACTED', 'confidence' => 0.6], ['status' => $ps['status'], 'confidence' => $ps['confidence']]);
        self::assertSame(['marking_type' => 'PS_MARK', 'certificate_number' => 'Q-1234', 'manufacturer_name' => 'Sample Cement Corporation'], $ps['suggestions']);
        $icc = $parser->parse('https://bps.dti.gov.ph/verify?ref=1 ICC Certificate No: ICC-2026-0001 importer=Import Co');
        self::assertSame('ICC_STICKER', $icc['suggestions']['marking_type']);
        self::assertSame('ICC-2026-0001', $icc['suggestions']['certificate_number']);
        self::assertSame('Import Co', $icc['suggestions']['importer_name']);
        self::assertSame('FAILED', $parser->parse("\x00\x01random")['status']);
        self::assertLessThanOrEqual(QrPayloadParser::MAX_LENGTH, mb_strlen((string) ($parser->parse(str_repeat('A', 5000))['suggestions']['verification_reference'] ?? '')));
    }

    public function test_rental_services_are_detected_without_blocking_equipment_for_sale(): void
    {
        $policy = new RentalServicePolicy;
        foreach (['Backhoe for rent', 'Equipment rental', 'Scaffolding rentals', 'Crane hire', 'Vehicle leasing', 'EquipmentRental'] as $label) {
            self::assertTrue($policy->describesRental($label), $label);
        }
        foreach (['Concrete mixer', 'Construction equipment', 'Power tools', 'Currents meter', 'Parental guard'] as $label) {
            self::assertFalse($policy->describesRental($label), $label);
        }
    }

    public function test_the_highest_reached_volume_tier_sets_the_unit_price(): void
    {
        $tiers = [['minimum_quantity' => '100.0000', 'amount_centavos' => 25000], ['minimum_quantity' => '50.0000', 'amount_centavos' => 26000]];
        self::assertSame(27500, VolumePricing::unitPriceCentavos(27500, $tiers, '49.9999'));
        self::assertSame(26000, VolumePricing::unitPriceCentavos(27500, $tiers, '50'));
        self::assertSame(26000, VolumePricing::unitPriceCentavos(27500, $tiers, '99.5'));
        self::assertSame(25000, VolumePricing::unitPriceCentavos(27500, $tiers, '100'));
        self::assertSame(25000, VolumePricing::unitPriceCentavos(27500, $tiers, '1000'));
        self::assertSame(27500, VolumePricing::unitPriceCentavos(27500, [], '1000'));
    }

    public function test_volume_tiers_must_start_above_one_unit_and_step_down_below_the_ordinary_price(): void
    {
        self::assertSame([], VolumePricing::errors([['minimum_quantity' => '50', 'price_centavos' => 26000], ['minimum_quantity' => '100.5', 'price_centavos' => 25000]], 27500));
        $errors = VolumePricing::errors([
            ['minimum_quantity' => '1', 'price_centavos' => 26000],
            ['minimum_quantity' => '40', 'price_centavos' => 27500],
            ['minimum_quantity' => '30', 'price_centavos' => 24000],
            ['minimum_quantity' => '60.12345', 'price_centavos' => 0],
        ], 27500);
        self::assertSame(['Enter a minimum quantity greater than 1, with up to four decimals.'], $errors['0.minimum_quantity']);
        self::assertSame(['A tier price must be lower than the ordinary price.'], $errors['1.price_centavos']);
        self::assertSame(['Each tier needs a higher minimum quantity than the tier before it.'], $errors['2.minimum_quantity']);
        self::assertSame(['Enter a minimum quantity greater than 1, with up to four decimals.'], $errors['3.minimum_quantity']);
        self::assertSame(['Enter a tier price greater than zero.'], $errors['3.price_centavos']);
        self::assertArrayHasKey('tiers', VolumePricing::errors(array_fill(0, 6, ['minimum_quantity' => '2', 'price_centavos' => 1]), 27500));
        self::assertSame('50.0000', VolumePricing::normalizeQuantity('50'));
    }
}
