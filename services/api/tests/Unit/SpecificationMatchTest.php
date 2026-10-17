<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Projects\SpecificationMatch;
use PHPUnit\Framework\TestCase;

final class SpecificationMatchTest extends TestCase
{
    public function test_numbers_compare_by_value_and_text_without_case_or_extra_spaces(): void
    {
        self::assertSame(['15', '15', '0.5', '0', '12.25'], array_map(SpecificationMatch::normalize(...), ['15', '015.00', '0.50', '000', '+12.250']));
        self::assertSame('grade 230', SpecificationMatch::normalize('  Grade   230 '));
        self::assertSame('15 mm', SpecificationMatch::normalize('15 mm'));
    }

    public function test_every_stated_detail_must_be_offered_and_open_details_never_exclude(): void
    {
        $offered = ['diameter_mm' => '12.0', 'grade' => 'Grade 230', 'length_m' => '6'];
        self::assertTrue(SpecificationMatch::satisfies([], $offered));
        self::assertTrue(SpecificationMatch::satisfies(['diameter_mm' => '12', 'grade' => 'grade 230'], $offered));
        self::assertFalse(SpecificationMatch::satisfies(['diameter_mm' => '10'], $offered));
        self::assertFalse(SpecificationMatch::satisfies(['color' => 'red'], $offered));
        self::assertTrue(SpecificationMatch::satisfies(['length_m' => ''], $offered));
    }

    public function test_options_group_equal_details_and_labels_and_details_are_labelled_in_category_order(): void
    {
        self::assertSame(SpecificationMatch::optionId(['diameter_mm' => '12.0'], '12 mm'), SpecificationMatch::optionId(['diameter_mm' => '12'], '12  MM'));
        self::assertNotSame(SpecificationMatch::optionId(['diameter_mm' => '12'], null), SpecificationMatch::optionId(['diameter_mm' => '16'], null));
        self::assertNotSame(SpecificationMatch::optionId([], '6 m'), SpecificationMatch::optionId([], '12 m'));
        self::assertMatchesRegularExpression('/^[0-9a-f]{16}$/', SpecificationMatch::optionId([], null));

        $known = ['grade' => (object) ['label' => 'Steel grade', 'unit_code' => null], 'diameter_mm' => (object) ['label' => 'Nominal diameter', 'unit_code' => 'mm']];
        self::assertSame([
            ['code' => 'grade', 'label' => 'Steel grade', 'value' => 'Grade 230', 'unit_code' => null],
            ['code' => 'diameter_mm', 'label' => 'Nominal diameter', 'value' => '12', 'unit_code' => 'mm'],
            ['code' => 'coating', 'label' => 'Coating', 'value' => 'Epoxy', 'unit_code' => null],
        ], SpecificationMatch::labelled(['coating' => 'Epoxy', 'diameter_mm' => '12', 'grade' => 'Grade 230', 'note' => ' '], $known));
    }
}
