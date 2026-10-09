<?php

declare(strict_types=1);

namespace App\Domain\Analytics;

use App\Domain\Settings\PlatformSettings;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * MAT-06 dataset isolation. The daily job captures the TEST marketplace into its own dataset; seeded demonstration
 * history lives only in the DEMO environment and is never written by the capture job. Which history the analytics
 * surfaces read is a non-secret platform setting (the DEMO seed command selects DEMO); every response carries the
 * dataset label so simulated history is always marked. A history generation counter invalidates cached history on
 * every publication or correction.
 */
final class AnalyticsDataset
{
    public const KIND = 'MATERIAL_PRICE_DAILY';

    public const CAPTURE_ENVIRONMENT = 'TEST';

    public const CAPTURE_DATASET = 'marketplace-test';

    public const DEMO_ENVIRONMENT = 'DEMO';

    public const DEMO_DATASET = 'demo-materials-analytics';

    public const SETTING_KEY = 'materials_analytics.history_dataset';

    public const ALGORITHM_VERSION = 'mat04.equal-vendor-mean.v1';

    private const GENERATION_KEY = 'mat04:history-generation';

    /** @return array{environment: string, dataset_id: string, label: string, kind: string} */
    public static function active(): array
    {
        $value = DB::table('platform_settings')->where('key', self::SETTING_KEY)->value('value');
        $setting = is_string($value) ? (json_decode($value, true) ?: []) : [];
        $environment = ($setting['environment'] ?? null) === self::DEMO_ENVIRONMENT ? self::DEMO_ENVIRONMENT : self::CAPTURE_ENVIRONMENT;

        return [
            'environment' => $environment,
            'dataset_id' => $environment === self::DEMO_ENVIRONMENT ? self::DEMO_DATASET : self::CAPTURE_DATASET,
            'label' => $environment === self::DEMO_ENVIRONMENT ? 'DEMO — Simulated Marketplace Data' : 'TEST — Recorded Test Marketplace Prices',
            'kind' => $environment,
        ];
    }

    public static function select(string $environment, ?int $userId = null): void
    {
        $value = json_encode(['environment' => $environment === self::DEMO_ENVIRONMENT ? self::DEMO_ENVIRONMENT : self::CAPTURE_ENVIRONMENT], JSON_THROW_ON_ERROR);
        $current = DB::table('platform_settings')->where('key', self::SETTING_KEY)->first();
        if ($current === null) {
            DB::table('platform_settings')->insert(['id' => (string) Str::uuid7(), 'key' => self::SETTING_KEY, 'value' => $value, 'version' => 1, 'updated_by_user_id' => $userId, 'created_at' => now(), 'updated_at' => now()]);
        } else {
            DB::table('platform_settings')->where('id', $current->id)->update(['value' => $value, 'version' => (int) $current->version + 1, 'updated_by_user_id' => $userId, 'updated_at' => now()]);
        }
        self::bump();
    }

    public static function generation(): int
    {
        return (int) Cache::get(self::GENERATION_KEY, 1);
    }

    public static function bump(): void
    {
        if (! Cache::add(self::GENERATION_KEY, 2)) {
            Cache::increment(self::GENERATION_KEY);
        }
    }

    public static function enabled(): bool
    {
        // The environment kill switch and the versioned Platform Setting feature flag must both allow it.
        return (bool) config('finance.materials_analytics_enabled', true) && PlatformSettings::current()->flag('materials_analytics');
    }
}
