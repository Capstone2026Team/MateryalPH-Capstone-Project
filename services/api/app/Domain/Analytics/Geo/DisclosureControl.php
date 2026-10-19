<?php

declare(strict_types=1);

namespace App\Domain\Analytics\Geo;

use App\Domain\Settings\PlatformSettings;

/**
 * Small-cell disclosure control for person-derived geographic cells (approved by the project owner on 2026-10-09):
 * a cell built from 1 to k−1 distinct Buyers or users is suppressed and its value stays counted in the parent area's
 * total, with the reason shown. When exactly one child of a visible parent is suppressed, the smallest remaining
 * non-zero sibling is also suppressed so the hidden value cannot be recovered by subtraction. Empty cells (0 persons)
 * reveal nothing personal and are shown as zero. Public storefront Vendor counts are never passed through here.
 */
final readonly class DisclosureControl
{
    public const PRIMARY = 'SMALL_CELL';

    public const COMPLEMENTARY = 'COMPLEMENTARY';

    public function __construct(public int $minimumPersons) {}

    public static function current(): self
    {
        return new self(max(1, PlatformSettings::current()->int('analytics.disclosure_min_persons')));
    }

    public function suppressed(int $persons): bool
    {
        return $persons > 0 && $persons < $this->minimumPersons;
    }

    /**
     * @param  array<string, int>  $personsByCode  distinct persons per sibling cell
     * @return array<string, string|null> reason code per sibling, null when shown
     */
    public function siblings(array $personsByCode): array
    {
        $reasons = [];
        $primary = 0;
        foreach ($personsByCode as $code => $persons) {
            $hidden = $this->suppressed($persons);
            $reasons[$code] = $hidden ? self::PRIMARY : null;
            $primary += $hidden ? 1 : 0;
        }
        if ($primary === 1) {
            $candidates = array_filter($personsByCode, fn (int $persons, string|int $code): bool => $reasons[$code] === null && $persons > 0, ARRAY_FILTER_USE_BOTH);
            if ($candidates !== []) {
                asort($candidates);
                $reasons[(string) array_key_first($candidates)] = self::COMPLEMENTARY;
            }
        }

        return $reasons;
    }

    public function message(?string $reason, string $parentName): ?string
    {
        return match ($reason) {
            self::PRIMARY => sprintf('Suppressed: fewer than %d distinct Buyers or users. The value is counted in the %s total.', $this->minimumPersons, $parentName),
            self::COMPLEMENTARY => sprintf('Suppressed to protect another small area. The value is counted in the %s total.', $parentName),
            default => null,
        };
    }
}
