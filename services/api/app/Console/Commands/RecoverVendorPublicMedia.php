<?php

declare(strict_types=1);

namespace App\Console\Commands;

use App\Domain\Vendors\PublicMediaRecovery;
use Illuminate\Console\Command;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class RecoverVendorPublicMedia extends Command
{
    protected $signature = 'materyalph:vendor-media-recover';

    protected $description = 'Retry safe cleanup for unlinked Cloudinary Vendor store media';

    public function handle(PublicMediaRecovery $recovery): int
    {
        DB::table('vendor_public_media_recoveries')->whereIn('state', ['PLANNED', 'UPLOAD_UNCONFIRMED', 'UPLOAD_CONFIRMED', 'CLEANUP_REQUIRED'])->where('updated_at', '<=', now()->subMinutes(5))->orderBy('id')->chunkById(100, function ($rows) use ($recovery): void {
            foreach ($rows as $row) {
                $request = Request::create('/scheduled/vendor-media-recovery');
                $request->attributes->set('correlation_id', (string) Str::uuid7());
                $request->attributes->set('account_scope', ['role' => 'SYSTEM', 'organization_id' => $row->vendor_organization_id]);
                $recovery->cleanup($request, $row->id);
            }
        });
        $this->info('Vendor public-media recovery completed.');

        return self::SUCCESS;
    }
}
