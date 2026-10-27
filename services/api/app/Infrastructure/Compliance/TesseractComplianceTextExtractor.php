<?php

declare(strict_types=1);

namespace App\Infrastructure\Compliance;

use App\Domain\Catalog\ImageContentValidator;
use App\Domain\Compliance\ComplianceTextExtractor;
use App\Domain\Compliance\MarkingTextParser;
use Illuminate\Contracts\Config\Repository;
use Illuminate\Process\Factory;
use RuntimeException;
use Throwable;

/** Local OCR: no provider upload, shell interpolation, raw-text persistence or approval. */
final class TesseractComplianceTextExtractor implements ComplianceTextExtractor
{
    private const MAX_OUTPUT_BYTES = 1_048_576;

    public function __construct(private readonly Repository $config, private readonly Factory $processes, private readonly MarkingTextParser $parser) {}

    public function provider(): string
    {
        return 'TESSERACT';
    }

    public function available(): bool
    {
        try {
            $result = $this->processes->newPendingProcess()->timeout(3)->run([$this->binary(), '--list-langs']);

            return $result->successful() && (bool) preg_match('/^eng\s*$/m', $result->output());
        } catch (Throwable) {
            return false;
        }
    }

    public function extract(string $path, string $contentType, ?string $markingType = null): array
    {
        if (! $this->available()) {
            return $this->empty('UNAVAILABLE');
        }
        $imagePaths = [];
        try {
            if (! in_array($contentType, ['image/jpeg', 'image/png', 'image/webp'], true)) {
                return $this->empty('FAILED');
            }
            // Keep full-image reads for packaging photos. On standard PS/ICC artwork the small
            // licence/serial sits below the logo/QR: enlarge that region independently as well.
            $texts = [];
            $confidences = [];
            $deadline = microtime(true) + max(1, min(30, (int) $this->config->get('materyalph.compliance_ocr.timeout_seconds', 15)));
            $passes = [['11', false, 0.0], ['6', true, 0.0], ['6', false, 0.65], ['7', true, 0.84]];
            foreach ($passes as [$mode, $contrast, $top]) {
                $remaining = (int) ceil($deadline - microtime(true));
                if ($remaining < 1) {
                    break;
                }
                $imagePath = $this->prepareImage($path, $contrast, $top);
                if ($imagePath !== null) {
                    $imagePaths[] = $imagePath;
                } elseif ($top > 0) {
                    continue;
                }
                try {
                    $output = $this->recognize($imagePath ?? $path, $mode, $remaining);
                } catch (Throwable) {
                    // A failed optional pass must not discard a number read by another pass.
                    continue;
                }
                if ($output === null) {
                    continue;
                }
                [$text, $confidence] = $this->readTsv($output);
                $texts[] = $text;
                if ($confidence !== null) {
                    $confidences[] = $confidence;
                }
            }
            $read = $this->parser->read(implode("\n", $texts), $markingType);

            return $read['suggestions'] === [] && $read['candidates'] === [] ? $this->empty('FAILED') : [
                'status' => 'EXTRACTED', 'confidence' => $confidences === [] ? null : round(array_sum($confidences) / count($confidences), 4),
                'suggestions' => $read['suggestions'], 'candidates' => $read['candidates'],
            ];
        } catch (Throwable) {
            // Engine errors and timeouts retain safe evidence and allow manual confirmation.
            return $this->empty('FAILED');
        } finally {
            foreach ($imagePaths as $imagePath) {
                @unlink($imagePath);
            }
        }
    }

    private function recognize(string $imagePath, string $pageSegmentation, int $timeout): ?string
    {
        $bytes = 0;
        $result = $this->processes->newPendingProcess()->env(['OMP_THREAD_LIMIT' => '1'])
            ->timeout($timeout)
            ->run([$this->binary(), $imagePath, 'stdout', '-l', 'eng', '--psm', $pageSegmentation, 'tsv'], static function (string $type, string $output) use (&$bytes): void {
                $bytes += strlen($output);
                if ($bytes > self::MAX_OUTPUT_BYTES) {
                    throw new RuntimeException('OCR output limit exceeded.');
                }
            });

        return ! $result->successful() || strlen($result->output()) > self::MAX_OUTPUT_BYTES ? null : $result->output();
    }

    private function binary(): string
    {
        return (string) $this->config->get('materyalph.compliance_ocr.binary', 'tesseract');
    }

    private function prepareImage(string $path, bool $contrast, float $top = 0): ?string
    {
        $dimensions = @getimagesize($path);
        if ($dimensions === false || $dimensions[0] < 1 || $dimensions[1] < 1 || $dimensions[0] * $dimensions[1] > ImageContentValidator::MAX_PIXELS) {
            throw new RuntimeException('OCR image dimensions are invalid.');
        }
        $sourceY = (int) floor($dimensions[1] * $top);
        $sourceHeight = $dimensions[1] - $sourceY;
        $longest = max($dimensions[0], $sourceHeight);
        $scale = min(2600, max(1600, $longest)) / $longest;
        $width = max(1, (int) round($dimensions[0] * $scale));
        $height = max(1, (int) round($sourceHeight * $scale));
        $memoryLimit = ini_parse_quantity((string) ini_get('memory_limit'));
        $imageBudget = ($dimensions[0] * $dimensions[1] + $width * $height) * 5 + 16_777_216;
        if ($memoryLimit > 0 && memory_get_usage(true) + $imageBudget > $memoryLimit) {
            // Let the bounded native process read the already validated image without another GD allocation.
            return null;
        }
        $source = @imagecreatefromstring((string) file_get_contents($path));
        if ($source === false) {
            throw new RuntimeException('OCR image could not be decoded.');
        }
        $prepared = null;
        $temporary = false;
        try {
            $prepared = imagecreatetruecolor($width + 24, $height + 24);
            imagefill($prepared, 0, 0, imagecolorallocate($prepared, 255, 255, 255));
            imagecopyresampled($prepared, $source, 12, 12, 0, $sourceY, $width, $height, imagesx($source), $sourceHeight);
            imagefilter($prepared, IMG_FILTER_GRAYSCALE);
            if ($contrast) {
                // Holographic ICC stickers and embossed PS marks read better with flattened glare.
                imagefilter($prepared, IMG_FILTER_CONTRAST, -40);
            }
            $temporary = tempnam(sys_get_temp_dir(), 'compliance-ocr-');
            if ($temporary === false || ! imagepng($prepared, $temporary)) {
                throw new RuntimeException('OCR temporary image is unavailable.');
            }

            return $temporary;
        } catch (Throwable $exception) {
            if ($temporary !== false) {
                @unlink($temporary);
            }
            throw $exception;
        } finally {
            imagedestroy($source);
            if ($prepared !== null) {
                imagedestroy($prepared);
            }
        }
    }

    /** @return array{string, ?float} */
    private function readTsv(string $tsv): array
    {
        $lines = [];
        $confidences = [];
        foreach (explode("\n", $tsv) as $row) {
            $columns = explode("\t", rtrim($row, "\r"), 12);
            if (count($columns) !== 12 || $columns[0] !== '5' || trim($columns[11]) === '' || ! is_numeric($columns[10])) {
                continue;
            }
            $confidence = (float) $columns[10];
            if ($confidence < 0 || $confidence > 100) {
                continue;
            }
            $line = implode(':', array_slice($columns, 1, 4));
            $lines[$line][] = trim($columns[11]);
            $confidences[] = $confidence / 100;
        }

        return [implode("\n", array_map(static fn (array $words): string => implode(' ', $words), $lines)), $confidences === [] ? null : round(array_sum($confidences) / count($confidences), 4)];
    }

    /** @return array{status: string, confidence: null, suggestions: array<string, string>, candidates: list<string>} */
    private function empty(string $status): array
    {
        return ['status' => $status, 'confidence' => null, 'suggestions' => [], 'candidates' => []];
    }
}
