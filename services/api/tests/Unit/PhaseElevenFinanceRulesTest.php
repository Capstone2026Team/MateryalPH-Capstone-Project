<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Finance\CommissionService;
use App\Domain\Finance\FinancialCalculator;
use App\Domain\Finance\Money;
use App\Domain\Finance\WithholdingThresholdEngine as Engine;
use App\Domain\Payments\ProcessingFeeCalculator;
use App\Domain\Payments\ProviderAmount;
use PHPUnit\Framework\Attributes\DataProvider;
use PHPUnit\Framework\TestCase;

/**
 * FIN-06 worked demo amounts and the FIN-04A pure fixtures, in exact centavos (pesos × 100). Database-backed
 * fixtures (locking, rollover, concurrency) live in the feature suites.
 */
final class PhaseElevenFinanceRulesTest extends TestCase
{
    /** G = C − R − D_r − V_r − P; W = money(G × 0.005); cash = C − R − P − W; commission never deducted. */
    public function test_fin06_full_online_non_vat(): void
    {
        $gross = 1060000 - 0 - 50000 - 0 - 10000;
        self::assertSame(1000000, $gross);
        $w = Engine::decide(Engine::SUBJECT_STANDARD, 'NO_DECLARATION', 0, $gross, Engine::DEFAULT_THRESHOLD_CENTAVOS, false)['withheld_centavos'];
        self::assertSame(5000, $w);
        self::assertSame(1045000, Engine::expectedVendorCash(1060000, 0, 10000, $w));
        self::assertSame(20000, Money::commission(1000000));
    }

    public function test_fin06_full_online_vat_inclusive(): void
    {
        $commercial = FinancialCalculator::commercial([['line_id' => 'a', 'quantity' => '1', 'unit_price_centavos' => 1120000, 'tax_category' => 'VAT_12']], 0, 50000);
        self::assertSame([1120000, 120000, 1000000], [$commercial['materials_payable_centavos'], $commercial['materials_vat_centavos'], $commercial['materials_exclusive_centavos']]);
        $gross = 1180000 - 0 - 50000 - 120000 - 10000;
        self::assertSame(1000000, $gross);
        $w = Engine::decide(Engine::SUBJECT_STANDARD, 'NO_DECLARATION', 0, $gross, Engine::DEFAULT_THRESHOLD_CENTAVOS, false)['withheld_centavos'];
        self::assertSame(5000, $w);
        self::assertSame(1165000, Engine::expectedVendorCash(1180000, 0, 10000, $w));
        self::assertSame(20000, Money::commission($commercial['materials_exclusive_centavos']));
    }

    public function test_fin06_threshold_relief_exactly_at_limit_and_crossing_and_missing_declaration(): void
    {
        $atLimit = Engine::decide(Engine::RELIEF_ACTIVE, 'RELIEF_EVIDENCED', 49000000, 1000000, Engine::DEFAULT_THRESHOLD_CENTAVOS, true);
        self::assertSame([50000000, Engine::RELIEF_ACTIVE, 0], [$atLimit['g_after_centavos'], $atLimit['status_after'], $atLimit['withheld_centavos']]);

        $crossing = Engine::decide(Engine::RELIEF_ACTIVE, 'RELIEF_EVIDENCED', 49900000, 200000, Engine::DEFAULT_THRESHOLD_CENTAVOS, true);
        self::assertSame([50100000, Engine::SUBJECT_THRESHOLD_BREACHED, 1000], [$crossing['g_after_centavos'], $crossing['status_after'], $crossing['withheld_centavos']],
            'W = ₱10 on the whole ₱2,000, never ₱5 on the ₱1,000 excess.');

        $missing = Engine::decide(Engine::SUBJECT_STANDARD, 'NO_DECLARATION', 0, 200000, Engine::DEFAULT_THRESHOLD_CENTAVOS, false);
        self::assertSame([Engine::SUBJECT_STANDARD, 1000], [$missing['status_after'], $missing['withheld_centavos']]);
    }

    public function test_fin06_direct_cod_and_mixed_cod_nrpc(): void
    {
        $commercial = FinancialCalculator::commercial([['line_id' => 'a', 'quantity' => '1', 'unit_price_centavos' => 1000000, 'tax_category' => 'NON_VAT']], 0, 50000);
        $direct = FinancialCalculator::paymentMatrix($commercial, 'CASH_ON_DELIVERY', null);
        self::assertSame([null, 0, 1050000, 'NOT_APPLICABLE'], [$direct['purpose'], $direct['online_principal_centavos'], $direct['physical_balance_centavos'], $direct['processing_fee']['status']]);
        self::assertSame(20000, Money::commission($commercial['materials_exclusive_centavos']), 'One completion fee; no platform CWT event for direct cash.');

        $withNrpc = FinancialCalculator::commercial([['line_id' => 'a', 'quantity' => '1', 'unit_price_centavos' => 1000000, 'tax_category' => 'NON_VAT']], 0, 50000, ['amount_centavos' => 100000, 'allocations' => ['a' => 100000]]);
        $mixed = FinancialCalculator::paymentMatrix($withNrpc, 'CASH_ON_DELIVERY', 2000);
        self::assertSame(['NRPC_ASSURANCE_PAYMENT', 102000, 950000], [$mixed['purpose'], $mixed['amount_due_online_centavos'], $mixed['physical_balance_centavos']],
            'The ₱20 fee is not credited as material principal: the balance drops by ₱1,000 only.');
        $gross = 102000 - 0 - 0 - 0 - 2000;
        $w = Engine::decide(Engine::SUBJECT_STANDARD, 'NO_DECLARATION', 0, $gross, Engine::DEFAULT_THRESHOLD_CENTAVOS, false)['withheld_centavos'];
        self::assertSame([100000, 500, 99500], [$gross, $w, Engine::expectedVendorCash(102000, 0, 2000, $w)]);
        self::assertSame(20000, Money::commission($withNrpc['materials_exclusive_centavos']), 'NRPC is counted once inside one completion fee.');
    }

    public function test_fin06_partial_return_credit_and_vat_registered_platform_fee(): void
    {
        self::assertSame(['target_centavos' => 16000, 'credit_centavos' => 4000], CommissionService::creditTarget(1000000, 20000, 0, 200000));
        self::assertSame(['target_centavos' => 0, 'credit_centavos' => 16000], CommissionService::creditTarget(1000000, 20000, 4000, 1000000), 'The final reversal consumes every remaining fee centavo.');
        self::assertSame(['fee_centavos' => 20000, 'vat_centavos' => 2143, 'revenue_centavos' => 17857], CommissionService::feeVat(20000, 'DEMO_VAT_12'));
        self::assertSame(['fee_centavos' => 20000, 'vat_centavos' => 0, 'revenue_centavos' => 20000], CommissionService::feeVat(20000, 'DEMO_NONVAT'));
    }

    /** @return iterable<string, array{0: string, 1: int, 2: int, 3: bool, 4: int, 5: string, 6: int}> */
    public static function fin04aFixtures(): iterable
    {
        yield '1 within relief' => [Engine::RELIEF_ACTIVE, 49000000, 100000, true, 49100000, Engine::RELIEF_ACTIVE, 0];
        yield '2 exactly at the limit is not a breach' => [Engine::RELIEF_ACTIVE, 49900000, 100000, true, 50000000, Engine::RELIEF_ACTIVE, 0];
        yield '3 one centavo over breaches the whole amount' => [Engine::RELIEF_ACTIVE, 49900000, 100001, true, 50000001, Engine::SUBJECT_THRESHOLD_BREACHED, 500];
        yield '4 whole crossing remittance, not the excess' => [Engine::RELIEF_ACTIVE, 49900000, 200000, true, 50100000, Engine::SUBJECT_THRESHOLD_BREACHED, 1000];
        yield '5 breached stays breached' => [Engine::SUBJECT_THRESHOLD_BREACHED, 50000001, 50000, true, 50050001, Engine::SUBJECT_THRESHOLD_BREACHED, 250];
        yield '7 no declaration is subject far below the limit' => [Engine::SUBJECT_STANDARD, 0, 200000, false, 200000, Engine::SUBJECT_STANDARD, 1000];
        yield '10 prior-year breach carries' => [Engine::SUBJECT_PRIOR_YEAR, 0, 100000, true, 100000, Engine::SUBJECT_PRIOR_YEAR, 500];
        yield '11 external declaration breaches on the first remittance' => [Engine::RELIEF_ACTIVE, 60000000, 100000, true, 60100000, Engine::SUBJECT_THRESHOLD_BREACHED, 500];
        yield '12 unresolved overlap is assessed at standard' => [Engine::UNDER_REVIEW, 60000000, 100000, true, 60100000, Engine::UNDER_REVIEW, 500];
    }

    #[DataProvider('fin04aFixtures')]
    public function test_fin04a_fixture(string $before, int $gBefore, int $group, bool $relief, int $gAfter, string $after, int $withheld): void
    {
        $decision = Engine::decide($before, 'X', $gBefore, $group, Engine::DEFAULT_THRESHOLD_CENTAVOS, $relief);
        self::assertSame([$gAfter, $after, $withheld], [$decision['g_after_centavos'], $decision['status_after'], $decision['withheld_centavos']]);
    }

    public function test_external_breach_reason_and_sticky_relief_loss(): void
    {
        self::assertSame('EXTERNAL_BREACH_REPORTED', Engine::decide(Engine::RELIEF_ACTIVE, 'RELIEF_EVIDENCED', 60000000, 100000, Engine::DEFAULT_THRESHOLD_CENTAVOS, true)['reason_code']);
        self::assertSame('THRESHOLD_CROSSED', Engine::decide(Engine::RELIEF_ACTIVE, 'RELIEF_EVIDENCED', 49900000, 100001, Engine::DEFAULT_THRESHOLD_CENTAVOS, true)['reason_code']);
        $expired = Engine::decide(Engine::RELIEF_ACTIVE, 'RELIEF_EVIDENCED', 1000, 200000, Engine::DEFAULT_THRESHOLD_CENTAVOS, false);
        self::assertSame([Engine::SUBJECT_STANDARD, 1000], [$expired['status_after'], $expired['withheld_centavos']], 'An out-of-period relief basis is not relief.');
        self::assertSame(Engine::SUBJECT_STANDARD, Engine::decide(Engine::SUBJECT_STANDARD, 'NO_DECLARATION', 0, 100, Engine::DEFAULT_THRESHOLD_CENTAVOS, true)['status_after'],
            'A document alone never restores relief inside the year.');
    }

    /** @return iterable<string, array{0: int, 1: array{rate_ppm: int, fixed_centavos: int, fee_vat_basis_points: int, rate_includes_vat: bool}}> */
    public static function feeCases(): iterable
    {
        $gcash = ['rate_ppm' => 23000, 'fixed_centavos' => 0, 'fee_vat_basis_points' => 1200, 'rate_includes_vat' => false];
        $card = ['rate_ppm' => 32000, 'fixed_centavos' => 1000, 'fee_vat_basis_points' => 1200, 'rate_includes_vat' => false];
        foreach ([1, 99, 10000, 1000000, 1050000, 123456789] as $principal) {
            yield 'gcash '.$principal => [$principal, $gcash];
            yield 'card '.$principal => [$principal, $card];
        }
    }

    #[DataProvider('feeCases')]
    public function test_processing_fee_gross_up_covers_exactly_the_provider_charge_on_the_fee_inclusive_total(int $principal, array $quote): void
    {
        $result = ProcessingFeeCalculator::grossUp($principal, $quote);
        self::assertSame($result['fee_centavos'], ProcessingFeeCalculator::charge($principal + $result['fee_centavos'], $quote)['charge_centavos']);
        self::assertSame($principal + $result['fee_centavos'], $result['total_centavos']);
        self::assertGreaterThanOrEqual(ProcessingFeeCalculator::charge($principal, $quote)['charge_centavos'], $result['fee_centavos'], 'No undercharge from multiplying only the principal.');
    }

    public function test_provider_amounts_round_trip_without_float_drift(): void
    {
        self::assertSame(10600, ProviderAmount::toCentavos(106));
        self::assertSame(10601, ProviderAmount::toCentavos(106.01));
        self::assertSame(1, ProviderAmount::toCentavos('0.01'));
        self::assertNull(ProviderAmount::toCentavos(1.001));
        self::assertNull(ProviderAmount::toCentavos(-1));
        self::assertSame(106.01, ProviderAmount::toProvider(10601));
        self::assertSame(106, ProviderAmount::toProvider(10600));
    }
}
