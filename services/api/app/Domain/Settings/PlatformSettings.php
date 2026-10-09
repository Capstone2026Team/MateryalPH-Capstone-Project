<?php

declare(strict_types=1);

namespace App\Domain\Settings;

use Illuminate\Support\Facades\DB;
use Throwable;

/**
 * Effective Platform Settings for domain rules. A stored value is used only while it still passes its registry
 * validation; otherwise the approved default applies, so a corrupted row can never relax a rule. Values are read
 * once per request or job (scoped binding) and forgotten after a change. Consumers apply them to new records only:
 * stored deadlines, snapshots and badge history keep the values they were created with.
 */
final class PlatformSettings
{
    /** @var array<string, array{value: mixed, version: int}>|null */
    private ?array $loaded = null;

    public static function current(): self
    {
        return app(self::class);
    }

    public function value(string $key): mixed
    {
        return $this->entry($key)['value'];
    }

    public function version(string $key): int
    {
        return $this->entry($key)['version'];
    }

    public function int(string $key): int
    {
        return (int) $this->value($key);
    }

    public function field(string $key, string $field): mixed
    {
        $value = $this->value($key);

        return is_array($value) ? $value[$field] : null;
    }

    public function flag(string $feature): bool
    {
        return (bool) ($this->field('features.flags', $feature) ?? true);
    }

    public function uploadKb(string $purpose): int
    {
        return (int) ($this->field('uploads.limits_kb', $purpose) ?? PlatformSettingRegistry::UPLOAD_CEILINGS_KB[$purpose]);
    }

    /** @return array<string, mixed> every effective value, for cross-setting validation */
    public function all(): array
    {
        $values = [];
        foreach (array_keys(PlatformSettingRegistry::definitions()) as $key) {
            $values[$key] = $this->value($key);
        }

        return $values;
    }

    public function forget(): void
    {
        $this->loaded = null;
    }

    /** @return array{value: mixed, version: int} */
    private function entry(string $key): array
    {
        if ($this->loaded === null) {
            $this->loaded = [];
            try {
                $rows = DB::table('platform_settings')->whereIn('key', array_keys(PlatformSettingRegistry::definitions()))->get(['key', 'value', 'version']);
            } catch (Throwable) {
                $rows = collect();
            }
            $decoded = [];
            foreach ($rows as $row) {
                $decoded[(string) $row->key] = ['value' => json_decode((string) $row->value, true), 'version' => (int) $row->version];
            }
            $defaults = [];
            foreach (PlatformSettingRegistry::definitions() as $settingKey => $definition) {
                $defaults[$settingKey] = $definition['default'];
            }
            $context = array_map(static fn (array $row): mixed => $row['value'], $decoded) + $defaults;
            foreach ($defaults as $settingKey => $default) {
                $stored = $decoded[$settingKey] ?? null;
                $valid = $stored !== null && PlatformSettingRegistry::errors($settingKey, $stored['value'], $context) === [];
                $this->loaded[$settingKey] = $valid ? $stored : ['value' => $default, 'version' => 0];
            }
        }

        return $this->loaded[$key] ?? ['value' => PlatformSettingRegistry::defaultValue($key), 'version' => 0];
    }
}
