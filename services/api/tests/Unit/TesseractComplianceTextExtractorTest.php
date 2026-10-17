<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Compliance\MarkingTextParser;
use App\Infrastructure\Compliance\TesseractComplianceTextExtractor;
use Illuminate\Config\Repository;
use Illuminate\Process\Factory;
use Illuminate\Process\PendingProcess;
use PHPUnit\Framework\TestCase;
use RuntimeException;

final class TesseractComplianceTextExtractorTest extends TestCase
{
    private string $imagePath;

    protected function setUp(): void
    {
        parent::setUp();
        $this->imagePath = (string) tempnam(sys_get_temp_dir(), 'ocr-test-');
        $image = imagecreatetruecolor(800, 180);
        imagefill($image, 0, 0, imagecolorallocate($image, 255, 255, 255));
        imagepng($image, $this->imagePath);
        imagedestroy($image);
    }

    protected function tearDown(): void
    {
        @unlink($this->imagePath);
        parent::tearDown();
    }

    public function test_tsv_produces_suggestions_and_bounded_recognition_confidence(): void
    {
        $processes = new Factory;
        $processes->fake(['*--list-langs*' => $processes->result("List of available languages (1):\neng\n"), '*' => $processes->result($this->tsv(['PS MARK', 'License No: Q-1234', 'Manufacturer: Sample Cement Corporation']))]);
        $result = $this->extractor($processes)->extract($this->imagePath, 'image/png');
        self::assertSame('EXTRACTED', $result['status']);
        self::assertSame(0.9, $result['confidence']);
        self::assertSame('Q-1234', $result['suggestions']['certificate_number']);
        self::assertArrayNotHasKey('raw_text', $result);
        $processes->assertRan(function (PendingProcess $process): bool {
            if (! is_array($process->command) || ! in_array('tsv', $process->command, true)) {
                return false;
            }
            self::assertSame(15, $process->timeout);
            self::assertSame(['OMP_THREAD_LIMIT' => '1'], $process->environment);
            self::assertFileDoesNotExist($process->command[1]);

            return true;
        });
    }

    public function test_missing_engine_or_english_data_is_unavailable(): void
    {
        $processes = new Factory;
        $processes->fake(['*' => $processes->result("List of available languages (1):\nosd\n")]);
        $extractor = $this->extractor($processes);
        self::assertFalse($extractor->available());
        self::assertSame(['status' => 'UNAVAILABLE', 'confidence' => null, 'suggestions' => [], 'candidates' => []], $extractor->extract($this->imagePath, 'image/png'));
        $processes->assertNotRan(fn (PendingProcess $process): bool => is_array($process->command) && in_array('tsv', $process->command, true));
    }

    public function test_a_limited_php_memory_budget_reads_the_validated_original_without_deleting_it(): void
    {
        $processes = new Factory;
        $processes->fake(['*--list-langs*' => $processes->result("eng\n"), '*' => $processes->result($this->tsv(['ICC', 'ICC Certificate No: ICC-2026-1234']))]);
        $extractor = $this->extractor($processes);
        $previous = (string) ini_get('memory_limit');
        try {
            ini_set('memory_limit', (string) (memory_get_usage(true) + 16_777_216));
            self::assertSame('EXTRACTED', $extractor->extract($this->imagePath, 'image/png')['status']);
            self::assertFileExists($this->imagePath);
            $processes->assertRan(fn (PendingProcess $process): bool => is_array($process->command) && ($process->command[1] ?? null) === $this->imagePath);
        } finally {
            ini_set('memory_limit', $previous);
        }
    }

    public function test_unreadable_output_engine_failure_and_timeout_allow_manual_entry(): void
    {
        foreach (['empty', 'exit', 'timeout', 'oversized'] as $failure) {
            $processes = new Factory;
            $processes->fake(['*--list-langs*' => $processes->result("eng\n"), '*' => function () use ($processes, $failure) {
                if ($failure === 'timeout') {
                    throw new RuntimeException('Private engine error must not escape.');
                }

                return $processes->result($failure === 'oversized' ? str_repeat('x', 1_048_577) : '', 'Private diagnostic', $failure === 'exit' ? 1 : 0);
            }]);
            self::assertSame(['status' => 'FAILED', 'confidence' => null, 'suggestions' => [], 'candidates' => []], $this->extractor($processes)->extract($this->imagePath, 'image/png'));
        }
    }

    public function test_installed_engine_reads_synthetic_ps_and_icc_photos(): void
    {
        $extractor = $this->extractor(new Factory);
        if (! $extractor->available()) {
            self::markTestSkipped('Local Tesseract and English data are not installed.');
        }
        // Fixed synthetic fixtures use the project's Inter font; no FreeType runtime dependency.
        // Synthetic copies of the official artwork: a PS Mark with its licence line and an ICC sticker serial under its QR code.
        foreach (['ps-mark' => ['PS_MARK', 'Q-1234'], 'icc-sticker' => ['ICC_STICKER', 'A500000001']] as $fixture => [$type, $number]) {
            copy(__DIR__.'/../Fixtures/compliance-'.$fixture.'.png', $this->imagePath);
            $result = $extractor->extract($this->imagePath, 'image/png', $type);
            self::assertSame('EXTRACTED', $result['status']);
            self::assertContains(str_replace('-', '', $number), $result['candidates']);
        }
    }

    private function extractor(Factory $processes): TesseractComplianceTextExtractor
    {
        return new TesseractComplianceTextExtractor(new Repository(['materyalph' => ['compliance_ocr' => ['binary' => 'tesseract', 'timeout_seconds' => 15]]]), $processes, new MarkingTextParser);
    }

    /** @param list<string> $lines */
    private function tsv(array $lines): string
    {
        $rows = ["level\tpage_num\tblock_num\tpar_num\tline_num\tword_num\tleft\ttop\twidth\theight\tconf\ttext"];
        foreach ($lines as $index => $line) {
            foreach (explode(' ', $line) as $word => $text) {
                $rows[] = implode("\t", [5, 1, 1, 1, $index + 1, $word + 1, 0, 0, 10, 10, 90, $text]);
            }
        }

        return implode("\n", $rows);
    }
}
