<?php

declare(strict_types=1);

namespace App\Domain\Compliance;

use App\Domain\Identity\AuthenticationException;
use Generator;
use XMLReader;
use ZipArchive;

/**
 * Streams the rows of a register file: CSV, or the first worksheet of an XLSX
 * workbook as DTI-BPS distributes its lists. Cells are returned as text by
 * column position; formulas, styles and other sheets are ignored. Archive and
 * XML sizes are bounded before anything is expanded.
 */
final class RegisterSpreadsheet
{
    public const XLSX_MIME = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

    private const MAX_EXPANDED_BYTES = 157_286_400;

    private const MAX_SHARED_STRINGS_BYTES = 52_428_800;

    /** @return 'csv'|'xlsx' */
    public static function format(string $path, string $extension): string
    {
        $mime = (new \finfo(FILEINFO_MIME_TYPE))->file($path);
        $extension = strtolower($extension);
        if ($extension === 'csv' && in_array($mime, ['text/csv', 'text/plain', 'application/csv'], true)) {
            return 'csv';
        }
        if ($extension === 'xlsx' && in_array($mime, [self::XLSX_MIME, 'application/zip', 'application/octet-stream'], true)) {
            return 'xlsx';
        }
        throw new AuthenticationException('FILE_VALIDATION_FAILED', 'Upload the register as an Excel workbook (.xlsx) or CSV file.', 422);
    }

    /** @return Generator<int, list<string>> One list of cell texts per row, keyed by 1-based row number. */
    public static function rows(string $path, string $format): Generator
    {
        return $format === 'xlsx' ? self::xlsxRows($path) : self::csvRows($path);
    }

    /** @return Generator<int, list<string>> */
    private static function csvRows(string $path): Generator
    {
        $handle = fopen($path, 'rb');
        if ($handle === false) {
            throw new AuthenticationException('FILE_VALIDATION_FAILED', 'The register file could not be read.', 422);
        }
        try {
            $line = 0;
            while (($cells = fgetcsv($handle, 0, ',', '"', '')) !== false) {
                $line++;
                if ($line === 1 && isset($cells[0])) {
                    $cells[0] = (string) preg_replace('/^\xEF\xBB\xBF/', '', (string) $cells[0]);
                }
                yield $line => array_map(static fn ($cell): string => (string) $cell, $cells);
            }
        } finally {
            fclose($handle);
        }
    }

    /** @return Generator<int, list<string>> */
    private static function xlsxRows(string $path): Generator
    {
        $zip = new ZipArchive;
        if ($zip->open($path, ZipArchive::RDONLY) !== true) {
            throw new AuthenticationException('FILE_VALIDATION_FAILED', 'The workbook could not be opened. Save it again as .xlsx or CSV.', 422);
        }
        try {
            $expanded = 0;
            for ($index = 0; $index < $zip->numFiles; $index++) {
                $expanded += (int) ($zip->statIndex($index)['size'] ?? 0);
            }
            $sheet = self::firstSheet($zip);
            if ($expanded > self::MAX_EXPANDED_BYTES || $sheet === null) {
                throw new AuthenticationException('FILE_VALIDATION_FAILED', 'The workbook is too large or has no worksheet. Save the register sheet alone as .xlsx or CSV.', 422);
            }
            $strings = self::sharedStrings($zip);
            $reader = XMLReader::XML((string) $zip->getFromName($sheet), null, LIBXML_NONET | LIBXML_COMPACT);
            if (! $reader instanceof XMLReader) {
                throw new AuthenticationException('FILE_VALIDATION_FAILED', 'The worksheet could not be read.', 422);
            }
            $rowNumber = 0;
            $cells = [];
            $column = 0;
            $type = '';
            $value = '';
            $inValue = false;
            while ($reader->read()) {
                if ($reader->nodeType === XMLReader::ELEMENT && $reader->localName === 'row') {
                    $rowNumber = (int) ($reader->getAttribute('r') ?? $rowNumber + 1);
                    $cells = [];
                    if ($reader->isEmptyElement) {
                        yield $rowNumber => [];
                    }
                } elseif ($reader->nodeType === XMLReader::ELEMENT && $reader->localName === 'c') {
                    $column = self::columnIndex((string) $reader->getAttribute('r'), count($cells));
                    $type = (string) $reader->getAttribute('t');
                    $value = '';
                    if ($reader->isEmptyElement) {
                        $cells[$column] = '';
                    }
                } elseif ($reader->nodeType === XMLReader::ELEMENT && ($reader->localName === 'v' || $reader->localName === 't')) {
                    $inValue = true;
                } elseif ($inValue && ($reader->nodeType === XMLReader::TEXT || $reader->nodeType === XMLReader::CDATA || $reader->nodeType === XMLReader::SIGNIFICANT_WHITESPACE)) {
                    $value .= $reader->value;
                } elseif ($reader->nodeType === XMLReader::END_ELEMENT && ($reader->localName === 'v' || $reader->localName === 't')) {
                    $inValue = false;
                } elseif ($reader->nodeType === XMLReader::END_ELEMENT && $reader->localName === 'c') {
                    $cells[$column] = $type === 's' ? ($strings[(int) $value] ?? '') : ($type === 'b' ? ($value === '1' ? 'TRUE' : 'FALSE') : $value);
                } elseif ($reader->nodeType === XMLReader::END_ELEMENT && $reader->localName === 'row') {
                    $row = $cells === [] ? [] : array_replace(array_fill(0, max(array_keys($cells)) + 1, ''), $cells);
                    yield $rowNumber => array_values($row);
                }
            }
            $reader->close();
        } finally {
            $zip->close();
        }
    }

    private static function firstSheet(ZipArchive $zip): ?string
    {
        $workbook = $zip->getFromName('xl/workbook.xml');
        $relations = $zip->getFromName('xl/_rels/workbook.xml.rels');
        if (! is_string($workbook) || ! is_string($relations)) {
            return null;
        }
        if (preg_match('/<(?:\w+:)?sheet\b[^>]*\br:id="([^"]+)"/', $workbook, $sheet) !== 1
            || preg_match('/<Relationship\b[^>]*\bId="'.preg_quote($sheet[1], '/').'"[^>]*\bTarget="([^"]+)"/', $relations, $target) !== 1
            && preg_match('/<Relationship\b[^>]*\bTarget="([^"]+)"[^>]*\bId="'.preg_quote($sheet[1], '/').'"/', $relations, $target) !== 1) {
            return null;
        }
        $name = ltrim(str_starts_with($target[1], '/') ? $target[1] : 'xl/'.$target[1], '/');

        return str_contains($name, '..') || $zip->locateName($name) === false ? null : $name;
    }

    /** @return list<string> */
    private static function sharedStrings(ZipArchive $zip): array
    {
        $stat = $zip->statName('xl/sharedStrings.xml');
        if ($stat === false) {
            return [];
        }
        if ((int) $stat['size'] > self::MAX_SHARED_STRINGS_BYTES) {
            throw new AuthenticationException('FILE_VALIDATION_FAILED', 'The workbook text is too large. Save the register sheet alone as .xlsx or CSV.', 422);
        }
        $reader = XMLReader::XML((string) $zip->getFromName('xl/sharedStrings.xml'), null, LIBXML_NONET | LIBXML_COMPACT);
        if (! $reader instanceof XMLReader) {
            return [];
        }
        $strings = [];
        $current = null;
        $inText = false;
        $inPhonetic = false;
        while ($reader->read()) {
            if ($reader->nodeType === XMLReader::ELEMENT && $reader->localName === 'si') {
                $current = '';
                if ($reader->isEmptyElement) {
                    $strings[] = '';
                    $current = null;
                }
            } elseif ($reader->nodeType === XMLReader::ELEMENT && $reader->localName === 'rPh') {
                $inPhonetic = ! $reader->isEmptyElement;
            } elseif ($reader->nodeType === XMLReader::END_ELEMENT && $reader->localName === 'rPh') {
                $inPhonetic = false;
            } elseif ($reader->nodeType === XMLReader::ELEMENT && $reader->localName === 't' && ! $reader->isEmptyElement) {
                $inText = ! $inPhonetic;
            } elseif ($inText && ($reader->nodeType === XMLReader::TEXT || $reader->nodeType === XMLReader::SIGNIFICANT_WHITESPACE || $reader->nodeType === XMLReader::CDATA)) {
                $current .= $reader->value;
            } elseif ($reader->nodeType === XMLReader::END_ELEMENT && $reader->localName === 't') {
                $inText = false;
            } elseif ($reader->nodeType === XMLReader::END_ELEMENT && $reader->localName === 'si' && $current !== null) {
                $strings[] = $current;
                $current = null;
            }
        }
        $reader->close();

        return $strings;
    }

    private static function columnIndex(string $reference, int $fallback): int
    {
        if (preg_match('/^([A-Z]{1,3})\d*$/', strtoupper($reference), $letters) !== 1) {
            return $fallback;
        }
        $index = 0;
        foreach (str_split($letters[1]) as $letter) {
            $index = $index * 26 + (ord($letter) - 64);
        }

        return $index - 1;
    }
}
