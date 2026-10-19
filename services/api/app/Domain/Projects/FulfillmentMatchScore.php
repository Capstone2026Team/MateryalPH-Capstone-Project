<?php

declare(strict_types=1);

namespace App\Domain\Projects;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Procurement\SearchRelevanceScore;
use Illuminate\Support\Facades\DB;

final class FulfillmentMatchScore
{
    public const DEFAULTS = ['material_match' => 40, 'budget_fit' => 25, 'distance' => 20, 'vps' => 15];

    public const VERSION = 'fms.normalized-weighted-sum.v2';

    /** @param array<string, mixed> $weights
     * @return array<string, int> */
    public static function validate(array $weights): array
    {
        if (array_diff(array_keys($weights), array_keys(self::DEFAULTS)) !== [] || count($weights) !== 4) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Provide exactly the four Project-Based ranking criteria.', 422);
        }
        foreach (self::DEFAULTS as $key => $default) {
            if (! isset($weights[$key]) || ! is_int($weights[$key]) || $weights[$key] < 0 || $weights[$key] > 100) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Use whole weights between 0 and 100.', 422);
            }
        }
        if (array_sum($weights) === 0) {
            throw new AuthenticationException('WEIGHTS_ALL_ZERO', 'Enable at least one ranking criterion by setting its weight above zero.', 422);
        }

        return array_replace(self::DEFAULTS, $weights);
    }

    /** @return array<string, mixed> */
    public static function preferences(string $buyer): array
    {
        $setting = DB::table('platform_settings')->where('key', 'ranking.fms.default_weights')->first();
        $defaults = $setting === null ? self::DEFAULTS : self::validate(json_decode($setting->value, true));
        $row = DB::table('buyer_ranking_preferences')->where('buyer_profile_id', $buyer)->where('procurement_type', 'PROJECT_BASED')->first();

        $personalized = $row !== null && (bool) $row->is_personalized;

        return ['weights' => $personalized ? self::validate(json_decode($row->weights, true)) : $defaults, 'default_weights' => $defaults,
            'personalized' => $personalized, 'version' => (int) ($row->version ?? 0), 'defaults_version' => (int) ($setting->version ?? 0), 'algorithm_version' => self::VERSION];
    }

    /** @param array<string, int> $weights
     * @return array<string, mixed> */
    public static function calculate(string $matched, string $required, ?int $cost, int $budget, int $distance, int $radius, ?string $vps, array $weights): array
    {
        self::validate($weights);
        $match = bccomp($required, '0', 8) <= 0 ? '0' : bcmul(bcdiv($matched, $required, 8), '100', 8);
        $fit = $cost === null ? null : ($cost <= $budget ? '100' : ($budget === 0 ? '0' : bcsub('100', bcmul(bcdiv((string) ($cost - $budget), (string) $budget, 8), '500', 8), 8)));
        $components = ['material_match' => self::clamp($match), 'budget_fit' => $fit === null ? null : self::clamp($fit),
            'distance' => SearchRelevanceScore::distance($distance, $radius * 1000), 'vps' => SearchRelevanceScore::vps($vps)];

        return self::fromComponents($components, $weights);
    }

    /** @param array<string, string|null> $components
     * @param array<string, int> $weights
     * @return array<string, mixed> */
    public static function fromComponents(array $components, array $weights, string $version = self::VERSION): array
    {
        self::validate($weights);
        $total = '0';
        $weightTotal = (string) array_sum($weights);
        foreach ($weights as $key => $weight) {
            if ($components[$key] === null && $weight > 0) {
                return ['score' => null, 'components' => $components, 'weights' => $weights, 'algorithm_version' => $version, 'status' => $key === 'budget_fit' ? 'COST_REVIEW_REQUIRED' : 'DATA_REVIEW_REQUIRED'];
            }
            $total = bcadd($total, bcmul($components[$key] ?? '0', (string) $weight, 8), 8);
        }

        return ['score' => bcadd(bcdiv($total, $weightTotal, 8), '0.005', 2), 'components' => $components, 'weights' => $weights, 'algorithm_version' => $version, 'status' => 'CALCULATED'];
    }

    private static function clamp(string $value): string
    {
        return bccomp($value, '0', 8) < 0 ? '0' : (bccomp($value, '100', 8) > 0 ? '100' : $value);
    }
}
