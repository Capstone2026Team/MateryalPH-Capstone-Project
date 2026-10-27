<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Compliance\MarkingTextParser;
use PHPUnit\Framework\TestCase;

final class MarkingTextParserTest extends TestCase
{
    public function test_ps_labels_propose_only_supported_printed_fields(): void
    {
        self::assertSame([
            'marking_type' => 'PS_MARK',
            'manufacturer_name' => 'Sample Cement Corporation', 'manufacturer_address' => 'Test City',
            'country_of_manufacture' => 'Philippines', 'brand' => 'BrandCo', 'batch_number' => 'B-42', 'certificate_number' => 'Q-1234',
        ], (new MarkingTextParser)->parse("PS QUALITY MARK\nPS License No.: Q-1234\nManufacturer: Sample Cement Corporation\nManufacturer Address: Test City\nMade in: Philippines\nBrand: BrandCo\nLot No: B-42\nPNS 07:2018\nUnrelated text: ignored"));
    }

    public function test_icc_certificate_label_is_kept_apart_from_the_sticker_serial(): void
    {
        self::assertSame([
            'marking_type' => 'ICC_STICKER', 'importer_name' => 'Sample Importer Inc.', 'importer_address' => 'Manila',
            'icc_certificate_number' => 'ICC-2026-1234', 'certificate_number' => 'A500000001',
        ], (new MarkingTextParser)->parse("ICC\nICC Certificate No.\nICC-2026-1234\nImported by: Sample Importer Inc.\nImporter Address: Manila\nSerial Number: A500000001"));
    }

    public function test_conflicting_numbers_and_mark_types_are_not_guessed(): void
    {
        self::assertSame([], (new MarkingTextParser)->parse("PS MARK\nLicense No: Q-1234\nICC\nCertificate No: ICC-5678"));
        $read = (new MarkingTextParser)->read("PS MARK\nLicense No. Q-1234\nLicense No. Q-5678", 'PS_MARK');
        self::assertArrayNotHasKey('certificate_number', $read['suggestions']);
        self::assertSame(['Q1234', 'Q5678'], $read['candidates']);
    }

    public function test_missing_values_never_consume_the_next_label_or_a_standard_number(): void
    {
        self::assertSame(['marking_type' => 'PS_MARK', 'brand' => 'BrandCo'], (new MarkingTextParser)->parse("PS MARK\nManufacturer:\nBrand: BrandCo\nLicense No:\nPNS 07 2018"));
    }

    public function test_a_serial_without_its_letter_is_not_proposed(): void
    {
        self::assertSame(['marking_type' => 'ICC_STICKER'], (new MarkingTextParser)->parse("ICC\nSerial No: 123456789\n2018\nPNS 07:2018"));
        self::assertSame([], (new MarkingTextParser)->parse('Unlabelled packaging text 1234'));
    }

    public function test_standard_marking_number_lines_allow_ocr_spaces_without_reading_standards_or_placeholder_artwork(): void
    {
        $parser = new MarkingTextParser;
        self::assertSame('Q-6378', $parser->parse("CERTIFIED\nProduct Safety\nLicense No. Q - 6 3 7 8", 'PS_MARK')['certificate_number']);
        self::assertSame('A500000001', $parser->parse("ICC\nA 500 000 001", 'ICC_STICKER')['certificate_number']);
        self::assertArrayNotHasKey('certificate_number', $parser->parse("CERTIFIED\nProduct Quality\nLicense No. Q-XXXX\nPNS 136:2000", 'PS_MARK'));
        self::assertArrayNotHasKey('certificate_number', $parser->parse('ICC 2018-2020', 'ICC_STICKER'));
    }

    /** Text that Tesseract actually produced for the official PS Mark and ICC sticker artwork. */
    public function test_misread_labels_and_look_alike_characters_still_yield_the_number(): void
    {
        $parser = new MarkingTextParser;
        $ps = $parser->read("PS Marks\nCERTIFIED\nProduct Quality\nLicensa Mo, Q-3850", 'PS_MARK');
        self::assertSame('Q-3850', $ps['suggestions']['certificate_number']);
        self::assertSame('PS_MARK', $ps['suggestions']['marking_type']);
        self::assertSame('Q-0894', $parser->parse("CERTIFIED\nProduct Safety\nLienselio. Q-O894", 'PS_MARK')['certificate_number']);
        // "A500000001" read as "AS000000G1": every look-alike reading is a candidate for the register to confirm.
        $icc = $parser->read("ICC Stickers\nbne = auere\nAS000000G1°C\n2021-present", 'ICC_STICKER');
        self::assertSame('A500000061', $icc['suggestions']['certificate_number']);
        self::assertSame(['A500000061', 'A500000001'], $icc['candidates']);
        // Without the Vendor's marking type, the selected reading follows the detected marking.
        self::assertSame('ICC_STICKER', $parser->parse("ICC\nB012717015")['marking_type']);
        self::assertSame('B012717015', $parser->parse("ICC\nB012717015")['certificate_number']);
    }
}
