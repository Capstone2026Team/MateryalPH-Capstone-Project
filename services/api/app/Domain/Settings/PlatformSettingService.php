<?php

declare(strict_types=1);

namespace App\Domain\Settings;

use App\Domain\Authorization\RecentAuthentication;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Notifications\NotificationService;
use App\Domain\Operations\AdminAccess;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Versioned non-secret Platform Settings. Every change requires platform_settings.manage, recent re-authentication,
 * the expected current version and a reason; it writes the effective value, an append-only version row holding the
 * previous value, an audit event with before/after and a notice to the other Super Admins. A stale version returns
 * 409 and an invalid value 422 with field errors — the stored value never changes in either case.
 */
final class PlatformSettingService
{
    public function __construct(
        private readonly AdminAccess $access,
        private readonly AuditRecorder $audit,
        private readonly RecentAuthentication $recent,
        private readonly NotificationService $notifications,
    ) {}

    /** @return array{items: list<array<string, mixed>>, fixed: list<array<string, mixed>>, can_manage: bool} */
    public function index(Request $request): array
    {
        $actor = $this->access->require($request, 'platform_settings.view');
        $settings = PlatformSettings::current();
        $rows = DB::table('platform_settings as s')->leftJoin('users as u', 'u.id', '=', 's.updated_by_user_id')->whereIn('s.key', array_keys(PlatformSettingRegistry::definitions()))
            ->get(['s.key', 's.version', 's.updated_at', 'u.name as updated_by'])->keyBy('key');
        $previous = DB::table('platform_setting_versions as v')->whereIn('v.setting_key', array_keys(PlatformSettingRegistry::definitions()))
            ->whereRaw('v.version = (SELECT MAX(x.version) FROM platform_setting_versions x WHERE x.setting_key = v.setting_key)')->get(['v.setting_key', 'v.previous_value', 'v.reason'])->keyBy('setting_key');
        $items = [];
        foreach (PlatformSettingRegistry::definitions() as $key => $definition) {
            $row = $rows->get($key);
            $latest = $previous->get($key);
            $items[] = ['key' => $key, 'group' => $definition['group'], 'label' => $definition['label'], 'description' => $definition['description'], 'validation_rule' => $definition['rule'],
                'applies_to' => $definition['applies_to'], 'value' => $settings->value($key), 'default_value' => $definition['default'], 'version' => $settings->version($key),
                'previous_value' => $latest?->previous_value === null ? null : json_decode((string) $latest->previous_value, true),
                'last_reason' => $latest?->reason, 'updated_at' => $row?->updated_at === null ? null : CarbonImmutable::parse((string) $row->updated_at)->toIso8601String(),
                'updated_by' => $row?->updated_by, 'editable' => in_array('platform_settings.manage', $actor['permissions'], true)];
        }

        return ['items' => $items, 'fixed' => PlatformSettingRegistry::fixed(), 'can_manage' => in_array('platform_settings.manage', $actor['permissions'], true)];
    }

    /** @return list<array<string, mixed>> */
    public function history(Request $request, string $key): array
    {
        $this->access->require($request, 'platform_settings.view');
        if (! PlatformSettingRegistry::exists($key)) {
            throw new AuthenticationException('SETTING_NOT_FOUND', 'This is not an approved Platform Setting.', 404);
        }

        return DB::table('platform_setting_versions as v')->leftJoin('users as u', 'u.id', '=', 'v.changed_by_user_id')->where('v.setting_key', $key)->orderByDesc('v.version')->limit(50)
            ->get(['v.version', 'v.value', 'v.previous_value', 'v.source', 'v.reason', 'v.changed_role', 'v.correlation_id', 'v.effective_from', 'u.name as changed_by'])
            ->map(static fn (object $row): array => ['version' => (int) $row->version, 'value' => json_decode((string) $row->value, true),
                'previous_value' => $row->previous_value === null ? null : json_decode((string) $row->previous_value, true), 'source' => (string) $row->source, 'reason' => (string) $row->reason,
                'changed_by' => $row->changed_by, 'changed_role' => $row->changed_role, 'correlation_id' => $row->correlation_id,
                'effective_from' => CarbonImmutable::parse((string) $row->effective_from)->toIso8601String()])->all();
    }

    /**
     * @param  array{value: mixed, expected_version: int, reason: string}  $input
     * @return array<string, mixed>
     */
    public function update(Request $request, string $key, array $input): array
    {
        $actor = $this->access->require($request, 'platform_settings.view', 'platform_settings.manage');
        if (! PlatformSettingRegistry::exists($key)) {
            throw new AuthenticationException('SETTING_NOT_FOUND', 'This is not an approved Platform Setting.', 404);
        }
        $this->recent->require($request);
        $reason = AdminAccess::reason($input['reason']);
        $correlation = AdminAccess::correlation($request);
        $settings = PlatformSettings::current();
        $settings->forget();
        $result = DB::transaction(function () use ($key, $input, $reason, $correlation, $actor, $settings): array {
            $row = DB::table('platform_settings')->where('key', $key)->lockForUpdate()->first();
            $current = $row === null ? 0 : (int) $row->version;
            if ((int) $input['expected_version'] !== $current) {
                throw new AuthenticationException('SETTING_VERSION_CONFLICT', 'This setting changed after you opened it. Refresh to review the current version.', 409, ['current_version' => $current]);
            }
            $context = $settings->all();
            $value = $input['value'];
            $errors = PlatformSettingRegistry::errors($key, $value, [$key => $value] + $context);
            if ($errors !== []) {
                throw new AuthenticationException('SETTING_INVALID', 'The value does not meet this setting\'s validation rule.', 422, ['fields' => $errors]);
            }
            $before = $row === null ? PlatformSettingRegistry::defaultValue($key) : json_decode((string) $row->value, true);
            if ($before == $value) {
                throw new AuthenticationException('SETTING_UNCHANGED', 'The new value is the same as the current value.', 422);
            }
            $version = $current + 1;
            $json = json_encode($value, JSON_THROW_ON_ERROR);
            if ($row === null) {
                DB::table('platform_settings')->insert(['id' => (string) Str::uuid7(), 'key' => $key, 'value' => $json, 'version' => $version, 'updated_by_user_id' => $actor['user_id'], 'created_at' => now(), 'updated_at' => now()]);
            } else {
                DB::table('platform_settings')->where('id', $row->id)->update(['value' => $json, 'version' => $version, 'updated_by_user_id' => $actor['user_id'], 'updated_at' => now()]);
            }
            DB::table('platform_setting_versions')->insert(['id' => (string) Str::uuid7(), 'setting_key' => $key, 'version' => $version, 'value' => $json,
                'previous_value' => json_encode($before, JSON_THROW_ON_ERROR), 'source' => 'ADMIN', 'reason' => $reason, 'changed_by_user_id' => $actor['user_id'],
                'changed_role' => $actor['role'], 'correlation_id' => $correlation, 'effective_from' => now(), 'created_at' => now()]);

            return ['before' => $before, 'value' => $value, 'version' => $version];
        });
        $settings->forget();
        $this->audit->account($request, 'PLATFORM_SETTING_CHANGED', 'PLATFORM_SETTING', null, ['key' => $key, 'value' => $result['before']], ['key' => $key, 'value' => $result['value'], 'version' => $result['version']], reason: $reason);
        $label = PlatformSettingRegistry::definitions()[$key]['label'];
        foreach ($this->superAdmins() as $userId) {
            if ($userId === $actor['user_id']) {
                continue;
            }
            $this->notifications->record($userId, 'ADMIN_OPERATIONS', 'Platform setting changed', $label.' moved to version '.$result['version'].'. Reason: '.$reason,
                'PLATFORM_SETTING', null, 'platform-setting:'.$key.':'.$result['version']);
        }

        return collect($this->index($request)['items'])->firstWhere('key', $key) ?? [];
    }

    /** @return list<int> */
    private function superAdmins(): array
    {
        return DB::table('admin_memberships as m')->join('platform_roles as r', 'r.id', '=', 'm.platform_role_id')->join('users as u', 'u.id', '=', 'm.user_id')
            ->where('r.code', 'ADMIN_SUPERADMIN')->where('m.status', 'ACTIVE')->where('u.account_status', 'ACTIVE')->pluck('u.id')->map(static fn (mixed $id): int => (int) $id)->all();
    }
}
