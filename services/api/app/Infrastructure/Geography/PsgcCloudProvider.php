<?php

declare(strict_types=1);

namespace App\Infrastructure\Geography;

use App\Domain\Vendors\PsgcProvider;
use Illuminate\Http\Client\ConnectionException;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Http;
use Illuminate\Validation\ValidationException;

final class PsgcCloudProvider implements PsgcProvider
{
    /** @return list<array<string, mixed>> */
    public function list(string $path): array
    {
        if (! preg_match('~^(regions|provinces|cities-municipalities)(/[0-9]{10}/barangays)?$~D', $path)) {
            throw new \InvalidArgumentException('Unsupported PSGC resource.');
        }

        return Cache::remember('psgc-cloud:v2:'.$path, now()->addHours(6), function () use ($path): array {
            try {
                $response = Http::acceptJson()->connectTimeout(3)->timeout(10)->withOptions(['allow_redirects' => false])
                    ->get('https://psgc.cloud/api/v2/'.$path);
            } catch (ConnectionException) {
                throw ValidationException::withMessages(['address' => 'PSGC locations are temporarily unavailable. Please retry.']);
            }
            $rows = $response->json('data');
            if (! $response->successful() || ! is_array($rows) || ! array_is_list($rows) || count($rows) > 5000) {
                throw ValidationException::withMessages(['address' => 'PSGC locations could not be loaded. Please retry.']);
            }
            foreach ($rows as $row) {
                if (! is_array($row) || ! is_string($row['code'] ?? null) || ! preg_match('/^[0-9]{10}$/D', $row['code']) || ! is_string($row['name'] ?? null) || trim($row['name']) === '') {
                    throw ValidationException::withMessages(['address' => 'The PSGC provider returned invalid reference data. Please retry later.']);
                }
            }

            return $rows;
        });
    }
}
