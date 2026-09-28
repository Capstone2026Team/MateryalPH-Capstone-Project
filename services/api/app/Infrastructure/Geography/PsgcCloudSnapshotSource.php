<?php

declare(strict_types=1);

namespace App\Infrastructure\Geography;

use App\Domain\Geography\PsgcImportSource;
use App\Domain\Geography\PsgcNames;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Client\ConnectionException;
use Illuminate\Support\Facades\Http;

/**
 * One-time snapshot of the psgc.cloud mirror of the PSA PSGC: regions, provinces and every city,
 * municipality, sub-municipality and special geographic area. Barangays are not bulk-listed by this source;
 * use the PSA CSV import when barangay codes are required. The snapshot becomes a DRAFT version.
 */
final class PsgcCloudSnapshotSource implements PsgcImportSource
{
    private const BASE_URL = 'https://psgc.cloud/api/v2/';

    public function kind(): string
    {
        return 'PSGC_CLOUD_SNAPSHOT';
    }

    public function rows(): array
    {
        $rows = [];
        foreach (['regions' => 'REGION', 'provinces' => 'PROVINCE', 'cities-municipalities' => null] as $path => $level) {
            foreach ($this->fetch($path) as $row) {
                $code = PsgcNames::code((string) ($row['code'] ?? ''));
                $name = trim((string) ($row['name'] ?? ''));
                if ($code === null || $name === '') {
                    throw new AuthenticationException('PSGC_SOURCE_INVALID', 'The PSGC snapshot returned an invalid row.', 502);
                }
                $rows[] = ['code' => $code, 'name' => $name, 'level' => $level ?? PsgcNames::level((string) ($row['type'] ?? ''))];
            }
        }

        return $rows;
    }

    /** @return list<array<string, mixed>> */
    private function fetch(string $path): array
    {
        try {
            $response = Http::acceptJson()->connectTimeout(5)->timeout(30)->withOptions(['allow_redirects' => false])->get(self::BASE_URL.$path);
        } catch (ConnectionException) {
            throw new AuthenticationException('PSGC_SOURCE_UNAVAILABLE', 'The PSGC snapshot source is unavailable. Retry later or import the PSA CSV.', 503);
        }
        $data = $response->json('data');
        if (! $response->successful() || ! is_array($data) || ! array_is_list($data) || count($data) > 10000) {
            throw new AuthenticationException('PSGC_SOURCE_UNAVAILABLE', 'The PSGC snapshot source returned an unexpected response.', 502);
        }

        return array_values(array_filter($data, 'is_array'));
    }
}
