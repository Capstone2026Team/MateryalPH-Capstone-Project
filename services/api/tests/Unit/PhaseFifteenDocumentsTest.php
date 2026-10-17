<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Notifications\NotificationPolicy;
use App\Domain\Reporting\DocumentRenderer;
use App\Domain\Reporting\TaxCalendar;
use PHPUnit\Framework\TestCase;

final class PhaseFifteenDocumentsTest extends TestCase
{
    public function test_calendar_quarters_months_and_annual_dates_are_not_fiscal_threshold_years(): void
    {
        self::assertSame('2027-01-31', TaxCalendar::period('1601-EQ', '2026-10-01')['nominal_due']);
        self::assertSame('2026-04-20', TaxCalendar::period('2307', '2026-01-01')['nominal_due']);
        self::assertSame('2026-03-10', TaxCalendar::period('0619-E', '2026-02-01')['nominal_due']);
        self::assertSame('2027-03-01', TaxCalendar::period('1604-E', '2026-01-01')['nominal_due']);
        self::assertSame('2028-02-29', TaxCalendar::period('0619-E', '2028-02-01')['end']);
        $this->expectException(AuthenticationException::class);
        TaxCalendar::period('0619-E', '2026-03-01');
    }

    public function test_atcs_preserve_entity_and_payee_class_and_require_historical_review(): void
    {
        self::assertSame('WI820', TaxCalendar::atc('DEMO_PLATFORM_WITHHOLDER', 'INDIVIDUAL', '2026-10-01'));
        self::assertSame('WC820', TaxCalendar::atc('DEMO_PLATFORM_WITHHOLDER', 'CORPORATION', '2026-10-01'));
        self::assertSame('WI830', TaxCalendar::atc('DEMO_PROVIDER_WITHHOLDER', 'INDIVIDUAL', '2026-10-01'));
        self::assertSame('WC830', TaxCalendar::atc('DEMO_PROVIDER_WITHHOLDER', 'CORPORATION', '2026-10-01'));
        self::assertNull(TaxCalendar::atc('SPOOFED_ISSUER', 'INDIVIDUAL', '2026-10-01'));
        self::assertNull(TaxCalendar::atc('DEMO_PLATFORM_WITHHOLDER', 'INDIVIDUAL', '2024-01-01'));
    }

    public function test_csv_formula_neutralization_and_required_notice_classes(): void
    {
        foreach (['=HYPERLINK("x")', '  +1', "\t@SUM(1)", '-1', "\r=1"] as $value) {
            self::assertStringStartsWith("'", DocumentRenderer::cell($value));
        }
        self::assertSame('Plain material', DocumentRenderer::cell('Plain material'));
        foreach (['SECURITY', 'LEGAL', 'SUSPENSION', 'PAYMENT', 'REFUND', 'DISPUTES', 'FINANCE_MANDATORY', 'FUTURE_REQUIRED_CLASS'] as $category) {
            self::assertTrue(NotificationPolicy::mandatory($category));
        }
        self::assertFalse(NotificationPolicy::mandatory('MARKETING'));
    }
}
