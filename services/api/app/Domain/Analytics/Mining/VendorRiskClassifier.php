<?php

declare(strict_types=1);

namespace App\Domain\Analytics\Mining;

use App\Domain\Scores\ScoreRules;

/**
 * A fixed decision tree that sorts a Vendor into a dashboard status class. Every branch uses only thresholds the System
 * Workflow already publishes (OHS penalty bands, VPS below 3.00, OHS below 2.50, the sample gates); it invents none and
 * learns none. The class is a display indicator: it never changes a published score, a badge, discovery or any sanction,
 * which remain with the Score rules and an Admin's reasoned decision.
 *
 *   VPS and OHS both unpublished ............ BUILDING_TRACK_RECORD  ("New Vendor — Building Track Record")
 *   VPS < 3.00  or  OHS < 2.50 .............. BELOW_WATCH_LEVEL      (the workflow's automated-warning condition)
 *   any OHS metric outside its no-penalty band WATCH
 *   otherwise ............................... HEALTHY
 */
final class VendorRiskClassifier
{
    public const BUILDING = 'BUILDING_TRACK_RECORD';

    public const BELOW = 'BELOW_WATCH_LEVEL';

    public const WATCH = 'WATCH';

    public const HEALTHY = 'HEALTHY';

    public const VPS_WATCH = '3.00';

    public const OHS_WATCH = '2.50';

    public const METRICS = ['NFR', 'LSR', 'RR', 'ODR'];

    /**
     * @param  array{vps: ?string, ohs: ?string, rates: array<string, string>|null}  $vendor  published values only; null = unpublished
     * @return array{class: string, label: string, path: list<string>, bands: array<string, string>}
     */
    public static function classify(array $vendor): array
    {
        $bands = [];
        foreach (self::METRICS as $metric) {
            $rate = $vendor['rates'][$metric] ?? null;
            if ($rate !== null) {
                $bands[$metric] = ScoreRules::band($metric, $rate);
            }
        }
        $path = [];
        if ($vendor['vps'] === null && $vendor['ohs'] === null) {
            $path[] = 'Neither VPS nor OHS is published yet.';

            return ['class' => self::BUILDING, 'label' => ScoreRules::NEW_VENDOR_LABEL, 'path' => $path, 'bands' => $bands];
        }
        if ($vendor['vps'] !== null && bccomp($vendor['vps'], self::VPS_WATCH, 2) < 0) {
            $path[] = 'Published VPS is below '.self::VPS_WATCH.'.';
        }
        if ($vendor['ohs'] !== null && bccomp($vendor['ohs'], self::OHS_WATCH, 2) < 0) {
            $path[] = 'Published OHS is below '.self::OHS_WATCH.'.';
        }
        if ($path !== []) {
            return ['class' => self::BELOW, 'label' => 'Below workflow watch level', 'path' => $path, 'bands' => $bands];
        }
        $outside = array_keys(array_filter($bands, static fn (string $band): bool => $band !== 'NONE'));
        if ($outside !== []) {
            return ['class' => self::WATCH, 'label' => 'Watch', 'path' => ['Outside the no-penalty band: '.implode(', ', $outside).'.'], 'bands' => $bands];
        }

        return ['class' => self::HEALTHY, 'label' => 'Healthy', 'path' => ['Published scores are at or above the watch levels and no OHS metric carries a penalty.'], 'bands' => $bands];
    }
}
