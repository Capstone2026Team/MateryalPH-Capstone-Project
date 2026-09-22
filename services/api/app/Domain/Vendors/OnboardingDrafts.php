<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Identity\AuthenticationException;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class OnboardingDrafts
{
    /** @param array<string, mixed> $payload */
    public function save(string $organizationId, string $workstream, array $payload, int $actorId, ?int $expectedVersion): void
    {
        DB::transaction(function () use ($organizationId, $workstream, $payload, $actorId, $expectedVersion): void {
            DB::table('vendor_organizations')->where('id', $organizationId)->lockForUpdate()->first();
            $query = DB::table('vendor_onboarding_drafts')->where('vendor_organization_id', $organizationId)->where('workstream', $workstream);
            $row = $query->first();
            $version = (int) ($row->lock_version ?? 0);
            if ($expectedVersion !== null && $expectedVersion !== $version) {
                throw new AuthenticationException('STALE_VERSION', 'This draft changed. Reload before saving.', 409);
            }
            $previous = $row === null ? [] : json_decode(Crypt::decryptString($row->payload_encrypted), true, flags: JSON_THROW_ON_ERROR);
            unset($payload['lock_version'], $payload['organization_lock_version'], $payload['draft_lock_version']);
            foreach ($payload as $key => $value) {
                $previous[$key] = is_array($value) && ! array_is_list($value)
                    ? array_replace(is_array($previous[$key] ?? null) ? $previous[$key] : [], $value)
                    : $value;
            }
            $values = ['payload_encrypted' => Crypt::encryptString(json_encode($previous, JSON_THROW_ON_ERROR)), 'lock_version' => $version + 1, 'updated_by_user_id' => $actorId, 'updated_at' => now()];
            if ($row === null) {
                $query->insert($values + ['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'workstream' => $workstream, 'created_at' => now()]);
            } else {
                $query->where('lock_version', $version)->update($values);
            }
        });
    }
}
