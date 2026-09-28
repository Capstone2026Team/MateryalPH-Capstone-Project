<?php

declare(strict_types=1);

namespace App\Domain\Geography;

use App\Domain\Identity\AuthenticationException;

/**
 * Reads the official PSA PSGC publication after it is exported from Excel to CSV. Header names are matched
 * case-insensitively: a code column ("10-digit PSGC", "PSGC" or "Code"), "Name" and "Geographic Level".
 */
final class PsgcCsvSource implements PsgcImportSource
{
    public const MAX_BYTES = 20 * 1024 * 1024;

    public const MAX_ROWS = 60000;

    public function __construct(private readonly string $path) {}

    public function kind(): string
    {
        return 'PSA_CSV';
    }

    public function rows(): array
    {
        if (! is_file($this->path) || ! is_readable($this->path) || (int) filesize($this->path) === 0 || (int) filesize($this->path) > self::MAX_BYTES) {
            throw new AuthenticationException('PSGC_SOURCE_INVALID', 'Provide a readable PSGC CSV no larger than 20 MB.', 422);
        }
        $handle = fopen($this->path, 'rb');
        if ($handle === false) {
            throw new AuthenticationException('PSGC_SOURCE_INVALID', 'The PSGC CSV could not be opened.', 422);
        }
        try {
            $header = fgetcsv($handle, escape: '\\');
            if (! is_array($header)) {
                throw new AuthenticationException('PSGC_SOURCE_INVALID', 'The PSGC CSV has no header row.', 422);
            }
            $columns = $this->columns($header);
            $rows = [];
            $line = 1;
            while (($record = fgetcsv($handle, escape: '\\')) !== false) {
                $line++;
                if ($record === [null] || implode('', array_map('strval', $record)) === '') {
                    continue;
                }
                if (count($rows) >= self::MAX_ROWS) {
                    throw new AuthenticationException('PSGC_SOURCE_INVALID', 'The PSGC CSV exceeds the supported row count.', 422);
                }
                $code = PsgcNames::code((string) ($record[$columns['code']] ?? ''));
                $name = trim((string) ($record[$columns['name']] ?? ''));
                if ($code === null || $name === '' || mb_strlen($name) > 255) {
                    throw new AuthenticationException('PSGC_SOURCE_INVALID', 'Line '.$line.' needs a 10-digit PSGC code and a name.', 422, ['line' => $line]);
                }
                $rows[] = ['code' => $code, 'name' => $name, 'level' => PsgcNames::level((string) ($record[$columns['level']] ?? ''))];
            }

            return $rows;
        } finally {
            fclose($handle);
        }
    }

    /**
     * @param  list<string|null>  $header
     * @return array{code: int, name: int, level: int}
     */
    private function columns(array $header): array
    {
        $normalized = array_map(static fn (?string $value): string => mb_strtolower(trim((string) preg_replace('/^\xEF\xBB\xBF/', '', (string) $value))), $header);
        $find = static function (array $candidates) use ($normalized): ?int {
            foreach ($candidates as $candidate) {
                $index = array_search($candidate, $normalized, true);
                if ($index !== false) {
                    return (int) $index;
                }
            }

            return null;
        };
        $code = $find(['10-digit psgc', 'psgc', 'psgc code', 'code']);
        $name = $find(['name']);
        $level = $find(['geographic level', 'level', 'type']);
        if ($code === null || $name === null || $level === null) {
            throw new AuthenticationException('PSGC_SOURCE_INVALID', 'The PSGC CSV needs code, Name and Geographic Level columns.', 422);
        }

        return ['code' => $code, 'name' => $name, 'level' => $level];
    }
}
