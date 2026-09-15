<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Identity\AuditRecorder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class PublicMediaRecovery
{
    public function __construct(private readonly PublicMediaProvider $provider, private readonly AuditRecorder $audit) {}

    public function begin(Request $request, string $organization, string $objectKey): string
    {
        $id = (string) Str::uuid7();
        DB::table('vendor_public_media_recoveries')->insert(['id' => $id, 'vendor_organization_id' => $organization, 'object_key' => $objectKey, 'state' => 'PLANNED', 'created_at' => now(), 'updated_at' => now()]);
        $this->audit->account($request, 'VENDOR_STORE_MEDIA_UPLOAD_PLANNED', 'PUBLIC_MEDIA_RECOVERY', $id, after: ['organization_id' => $organization]);

        return $id;
    }

    /** @param array{asset_id: string, format: string} $asset */
    public function uploaded(string $id, array $asset): void
    {
        DB::table('vendor_public_media_recoveries')->where('id', $id)->where('state', 'PLANNED')->update(['state' => 'UPLOAD_CONFIRMED', 'provider_asset_id' => $asset['asset_id'], 'provider_format' => $asset['format'], 'updated_at' => now()]);
    }

    public function linked(string $id, string $media): void
    {
        DB::table('vendor_public_media_recoveries')->where('id', $id)->where('state', 'UPLOAD_CONFIRMED')->update(['state' => 'LINKED', 'store_media_id' => $media, 'last_error' => null, 'updated_at' => now()]);
    }

    public function markUnconfirmed(string $id): void
    {
        DB::table('vendor_public_media_recoveries')->where('id', $id)->where('state', 'PLANNED')->update(['state' => 'UPLOAD_UNCONFIRMED', 'last_error' => 'UPLOAD_OUTCOME_UNCONFIRMED', 'updated_at' => now()]);
    }

    public function requireCleanup(string $id, string $error): void
    {
        DB::table('vendor_public_media_recoveries')->where('id', $id)->whereNotIn('state', ['LINKED', 'CLEANED'])->update(['state' => 'CLEANUP_REQUIRED', 'last_error' => $error, 'updated_at' => now()]);
    }

    /** @param list<string> $mediaIds */
    public function scheduleLinkedCleanup(Request $request, array $mediaIds): void
    {
        if ($mediaIds === []) {
            return;
        }
        $recoveries = DB::table('vendor_public_media_recoveries')
            ->whereIn('store_media_id', $mediaIds)
            ->where('state', 'LINKED')
            ->get(['id', 'vendor_organization_id']);
        foreach ($recoveries as $recovery) {
            DB::table('vendor_public_media_recoveries')->where('id', $recovery->id)->where('state', 'LINKED')->update([
                'state' => 'CLEANUP_REQUIRED',
                'last_error' => 'MEDIA_REPLACED_OR_REMOVED',
                'updated_at' => now(),
            ]);
            $this->audit->account($request, 'VENDOR_STORE_MEDIA_CLEANUP_SCHEDULED', 'PUBLIC_MEDIA_RECOVERY', $recovery->id, after: ['organization_id' => $recovery->vendor_organization_id]);
        }
    }

    public function cleanup(Request $request, string $id): bool
    {
        $row = DB::table('vendor_public_media_recoveries')->where('id', $id)->first();
        if ($row === null || in_array($row->state, ['LINKED', 'CLEANED'], true)) {
            return true;
        }
        DB::table('vendor_public_media_recoveries')->where('id', $id)->increment('cleanup_attempts');
        try {
            $this->provider->remove($row->object_key);
        } catch (\Throwable) {
            DB::table('vendor_public_media_recoveries')->where('id', $id)->update(['state' => 'CLEANUP_REQUIRED', 'last_error' => 'PROVIDER_CLEANUP_UNCONFIRMED', 'updated_at' => now()]);
            $this->audit->account($request, 'VENDOR_STORE_MEDIA_CLEANUP_UNCONFIRMED', 'PUBLIC_MEDIA_RECOVERY', $id, after: ['organization_id' => $row->vendor_organization_id], succeeded: false);

            return false;
        }
        DB::table('vendor_public_media_recoveries')->where('id', $id)->update(['state' => 'CLEANED', 'last_error' => null, 'recovered_at' => now(), 'updated_at' => now()]);
        $this->audit->account($request, 'VENDOR_STORE_MEDIA_CLEANED', 'PUBLIC_MEDIA_RECOVERY', $id, after: ['organization_id' => $row->vendor_organization_id]);

        return true;
    }
}
