<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use Illuminate\Validation\ValidationException;

final class PsgcDirectory
{
    public function __construct(private readonly PsgcProvider $provider) {}

    /** @return list<array<string, mixed>> */
    private function cities(): array
    {
        return $this->provider->list('cities-municipalities');
    }

    /** @return list<array<string, mixed>> */
    private function groups(): array
    {
        $provinces = $this->provider->list('provinces');
        $codes = array_column($provinces, 'code');
        $independentRegions = [];
        foreach ($this->cities() as $city) {
            if (! in_array(substr($city['code'], 0, 5).'00000', $codes, true)) {
                $independentRegions[] = substr($city['code'], 0, 2).'00000000';
            }
        }

        return array_merge(array_map(fn (array $row): array => $row + ['level' => 'PROVINCE'], $provinces),
            array_map(fn (array $row): array => $row + ['level' => 'REGION'], array_values(array_filter($this->provider->list('regions'), fn (array $row): bool => in_array($row['code'], $independentRegions, true)))));
    }

    /** @return list<array<string, mixed>> */
    private function children(string $parent): array
    {
        $group = $this->find($this->groups(), $parent);
        if ($group === null) {
            return [];
        }
        $provinceCodes = array_column($this->provider->list('provinces'), 'code');

        return array_values(array_filter($this->cities(), fn (array $city): bool => $group['level'] === 'PROVINCE'
            ? substr($city['code'], 0, 5) === substr($parent, 0, 5)
            : substr($city['code'], 0, 2) === substr($parent, 0, 2) && ! in_array(substr($city['code'], 0, 5).'00000', $provinceCodes, true)));
    }

    /** @return array<string, mixed> */
    public function search(string $level, ?string $parent, string $query, int $page): array
    {
        $rows = match ($level) {
            'PROVINCE' => $this->groups(),
            'CITY' => $this->children($parent ?? ''),
            default => $this->find($this->cities(), $parent ?? '') ? $this->provider->list('cities-municipalities/'.$parent.'/barangays') : [],
        };
        $rows = array_values(array_filter($rows, fn (array $row): bool => str_contains(mb_strtolower($row['name']), mb_strtolower($query))));
        usort($rows, fn (array $a, array $b): int => strcasecmp($a['name'], $b['name']) ?: strcmp($a['code'], $b['code']));

        return ['items' => array_map(fn (array $row): array => ['code' => $row['code'], 'name' => $row['name'], 'level' => $row['level'] ?? $level], array_slice($rows, ($page - 1) * 25, 25)),
            'page' => $page, 'has_more' => count($rows) > $page * 25, 'version_id' => 'psgc-cloud-v2'];
    }

    /** @param array<string, mixed> $input
     * @return array<string, mixed>
     */
    public function validateAddress(array $input): array
    {
        $group = $this->find($this->groups(), (string) ($input['province_code'] ?? ''));
        $city = $this->find($this->children((string) ($input['province_code'] ?? '')), (string) ($input['city_code'] ?? ''));
        $barangay = $city ? $this->find($this->provider->list('cities-municipalities/'.$city['code'].'/barangays'), (string) ($input['psgc_code'] ?? '')) : null;
        if (! $group || ! $city || ! $barangay) {
            throw ValidationException::withMessages(['address.psgc_code' => 'Select a valid province or region, city/municipality, and barangay from the PSGC suggestions.']);
        }

        return ['province' => $group['name'], 'city_municipality' => $city['name'], 'barangay' => $barangay['name'],
            'province_code' => $group['code'], 'city_code' => $city['code'], 'psgc_code' => $barangay['code'], 'psgc_source' => 'PSGC_CLOUD_V2'];
    }

    /** Match only unique names; ambiguous or missing results remain unselected.
     * @param  array<string, mixed>  $address
     * @return array<string, mixed>
     */
    public function match(array $address): array
    {
        $cities = array_values(array_filter($this->cities(), fn (array $city): bool => $this->normalize($city['name']) === $this->normalize((string) ($address['city_municipality'] ?? ''))));
        if (count($cities) > 1) {
            $cities = array_values(array_filter($cities, fn (array $city): bool => $this->normalize((string) ($city['province'] ?? '')) === $this->normalize((string) ($address['province'] ?? ''))));
        }
        if (count($cities) !== 1) {
            return [];
        }
        $city = $cities[0];
        $provinceCode = substr($city['code'], 0, 5).'00000';
        $group = $this->find($this->groups(), $provinceCode) ?? $this->find($this->groups(), substr($city['code'], 0, 2).'00000000');
        if (! $group) {
            return [];
        }
        $result = ['province' => $group['name'], 'province_code' => $group['code'], 'city_municipality' => $city['name'], 'city_code' => $city['code']];
        $barangays = array_values(array_filter($this->provider->list('cities-municipalities/'.$city['code'].'/barangays'), fn (array $row): bool => $this->normalize($row['name']) === $this->normalize((string) ($address['barangay'] ?? ''))));
        if (count($barangays) === 1) {
            $result += ['barangay' => $barangays[0]['name'], 'psgc_code' => $barangays[0]['code']];
        }

        return $result;
    }

    private function normalize(string $name): string
    {
        return trim((string) preg_replace('/\s+/', ' ', preg_replace('/\b(city of|city|municipality of|barangay|brgy\.?)\b/i', '', mb_strtolower($name)) ?? ''));
    }

    /** @param list<array<string, mixed>> $rows
     * @return array<string, mixed>|null
     */
    private function find(array $rows, string $code): ?array
    {
        foreach ($rows as $row) {
            if ($row['code'] === $code) {
                return $row;
            }
        }

        return null;
    }
}
