<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Catalog\MarketplaceDiscoverability;
use App\Domain\Operations\OutboxPublisher;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class VendorExpiryService
{
    public function __construct(private readonly OutboxPublisher $outbox) {}

    public function scan(): int
    {
        $count = 0;
        $versions = DB::table('business_documents as d')
            ->join('business_document_versions as v', 'v.id', '=', 'd.current_version_id')
            ->whereNotNull('v.id')
            ->get(['d.id as document_id', 'd.vendor_organization_id', 'd.onboarding_step_id', 'd.requirement_key', 'd.current_version_id', 'd.status', 'v.version', 'v.id as version_id']);

        foreach ($versions as $version) {
            $review = DB::table('business_document_reviews')->where('business_document_version_id', $version->version_id)->orderByDesc('reviewed_at')->first();
            if ($review === null || $review->decision !== 'APPROVED' || $review->expiration_kind !== 'DATE' || $review->verified_expiration_date === null) {
                continue;
            }
            $expiresAt = (string) $review->verified_expiration_date;
            $days = now()->startOfDay()->diffInDays(Carbon::parse($expiresAt)->startOfDay(), false);
            $kind = $days < 0 ? 'EXPIRED' : ($days <= 1 ? 'EXPIRING_1' : ($days <= 7 ? 'EXPIRING_7' : ($days <= 30 ? 'EXPIRING_30' : null)));
            if ($kind === null) {
                continue;
            }
            $inserted = DB::transaction(function () use ($version, $review, $kind, $days): bool {
                $noticeId = (string) Str::uuid7();
                $created = DB::table('vendor_document_expiry_notices')->insertOrIgnore([
                    'id' => $noticeId, 'business_document_version_id' => $version->version_id, 'notice_kind' => $kind, 'sent_at' => now(), 'created_at' => now(), 'updated_at' => now(),
                ]);
                if ($created === 0) {
                    return false;
                }
                $organizationId = (string) $version->vendor_organization_id;
                $expired = $days < 0;
                if ($expired) {
                    DB::table('business_documents')->where('id', $version->document_id)->update(['status' => 'EXPIRED', 'lock_version' => DB::raw('lock_version + 1'), 'updated_at' => now()]);
                    if ($version->onboarding_step_id !== null) {
                        DB::table('vendor_onboarding_steps')->where('id', $version->onboarding_step_id)->update(['status' => 'EXPIRED', 'last_reason' => 'The approved evidence expired on '.$review->verified_expiration_date.'.', 'updated_at' => now()]);
                    }
                    $organization = DB::table('vendor_organizations')->where('id', $organizationId)->lockForUpdate()->first();
                    if ($organization !== null) {
                        $organizationUpdate = ['store_verification_status' => 'EXPIRED', 'lock_version' => DB::raw('lock_version + 1'), 'updated_at' => now()];
                        if (in_array($organization->store_activation_status, ['ACTIVE', 'READY'], true)) {
                            $organizationUpdate += ['store_activation_status' => 'RESTRICTED', 'activation_hold_code' => 'DOCUMENT_EXPIRED', 'activation_hold_reason' => 'Required evidence expired and must be replaced.'];
                        }
                        DB::table('vendor_organizations')->where('id', $organizationId)->update($organizationUpdate);
                    }
                    if ($organization !== null && in_array($organization->store_activation_status, ['ACTIVE', 'READY'], true)) {
                        DB::table('vendor_activation_history')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'state_before' => $organization->store_activation_status, 'state_after' => 'RESTRICTED', 'result' => 'RESTRICTED', 'reason' => 'Required evidence expired.', 'blockers' => json_encode([['key' => $version->requirement_key, 'reason' => 'Evidence expired.']], JSON_THROW_ON_ERROR), 'readiness_snapshot' => json_encode(['status' => 'NOT_READY'], JSON_THROW_ON_ERROR), 'actor_user_id' => null, 'source' => 'SYSTEM', 'recorded_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
                    }
                    app(MarketplaceDiscoverability::class)->evaluate($organizationId);
                }
                $owner = DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->where('m.vendor_organization_id', $organizationId)->where('m.role', 'OWNER')->where('m.status', 'ACTIVE')->first(['u.id', 'u.email']);
                if ($owner !== null) {
                    $message = $expired ? 'Required Vendor evidence has expired. Replace it before Store Activation can continue.' : 'Required Vendor evidence will expire on '.$review->verified_expiration_date.'. Review the document before it expires.';
                    DB::table('notifications')->insert(['id' => (string) Str::uuid7(), 'user_id' => $owner->id, 'category' => 'VENDOR_VERIFICATION', 'title' => $expired ? 'Vendor evidence expired' : 'Vendor evidence expiration reminder', 'body' => $message, 'resource_type' => 'VENDOR_ORGANIZATION', 'resource_id' => $organizationId, 'created_at' => now(), 'updated_at' => now()]);
                    $this->outbox->publish('VENDOR_ONBOARDING_NOTICE', 'VENDOR_ORGANIZATION', $organizationId, ['recipient' => $owner->email, 'message' => $message]);
                }

                return true;
            });
            if ($inserted) {
                $count++;
            }
        }

        return $count;
    }
}
