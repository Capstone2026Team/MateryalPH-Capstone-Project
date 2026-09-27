<?php

declare(strict_types=1);

namespace App\Domain\Catalog;

use App\Domain\Identity\AuthenticationException;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * The only writer of vendor_listings.status. Every transition is validated
 * against the Vendor Workflow listing states and appended to the immutable
 * listing_status_history. Callers hold the listing row lock.
 */
final class ListingTransitions
{
    public const STATUSES = ['DRAFT', 'PENDING_COMPLIANCE', 'PENDING_ADMIN_REVIEW', 'ACTIVE', 'INACTIVE', 'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED', 'REJECTED'];

    private const ALLOWED = [
        'DRAFT' => ['PENDING_COMPLIANCE', 'PENDING_ADMIN_REVIEW', 'ACTIVE', 'REJECTED'],
        'PENDING_COMPLIANCE' => ['DRAFT', 'PENDING_ADMIN_REVIEW', 'ACTIVE', 'INACTIVE', 'REJECTED'],
        'PENDING_ADMIN_REVIEW' => ['DRAFT', 'PENDING_COMPLIANCE', 'ACTIVE', 'INACTIVE', 'REJECTED'],
        'ACTIVE' => ['INACTIVE', 'PENDING_COMPLIANCE', 'PENDING_ADMIN_REVIEW', 'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED'],
        'INACTIVE' => ['DRAFT', 'ACTIVE', 'PENDING_COMPLIANCE', 'PENDING_ADMIN_REVIEW', 'REJECTED'],
        'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED' => ['ACTIVE', 'INACTIVE', 'PENDING_COMPLIANCE'],
        'REJECTED' => ['DRAFT', 'PENDING_COMPLIANCE', 'PENDING_ADMIN_REVIEW', 'INACTIVE'],
    ];

    public function __construct(private readonly ListingSnapshots $snapshots) {}

    public function transition(object $listing, string $to, string $source, ?int $actorId, ?string $reasonCode = null, ?string $reason = null, ?string $submissionId = null): void
    {
        $from = (string) $listing->status;
        if ($from === $to) {
            return;
        }
        if (! in_array($to, self::ALLOWED[$from] ?? [], true)) {
            throw new AuthenticationException('LISTING_TRANSITION_INVALID', 'This listing cannot move from '.$from.' to '.$to.'.', 409, ['from' => $from, 'to' => $to]);
        }
        $values = ['status' => $to, 'updated_at' => now(), 'lock_version' => DB::raw('lock_version + 1')];
        $publicationVersion = null;
        if ($to === 'ACTIVE') {
            $publicationVersion = (int) $listing->publication_version + 1;
            $values += ['published_at' => now(), 'publication_version' => $publicationVersion];
        }
        DB::table('vendor_listings')->where('id', $listing->id)->update($values);
        DB::table('listing_status_history')->insert(['id' => (string) Str::uuid7(), 'vendor_listing_id' => $listing->id, 'from_status' => $from, 'to_status' => $to, 'actor_user_id' => $actorId, 'reason' => $reason, 'reason_code' => $reasonCode, 'source' => $source, 'compliance_submission_id' => $submissionId, 'publication_version' => $publicationVersion, 'created_at' => now(), 'updated_at' => now()]);
        if ($publicationVersion !== null) {
            $this->snapshots->record((string) $listing->id, $publicationVersion, $actorId);
        }
        $listing->status = $to;
        if ($publicationVersion !== null) {
            $listing->publication_version = $publicationVersion;
        }
    }

    /** Records a new publication version for an ACTIVE listing whose sellable terms changed. */
    public function republish(object $listing, ?int $actorId, string $reasonCode): void
    {
        if ($listing->status !== 'ACTIVE') {
            return;
        }
        $version = (int) $listing->publication_version + 1;
        DB::table('vendor_listings')->where('id', $listing->id)->update(['publication_version' => $version, 'published_at' => now(), 'updated_at' => now()]);
        DB::table('listing_status_history')->insert(['id' => (string) Str::uuid7(), 'vendor_listing_id' => $listing->id, 'from_status' => 'ACTIVE', 'to_status' => 'ACTIVE', 'actor_user_id' => $actorId, 'reason_code' => $reasonCode, 'source' => 'VENDOR', 'publication_version' => $version, 'created_at' => now(), 'updated_at' => now()]);
        $this->snapshots->record((string) $listing->id, $version, $actorId);
        $listing->publication_version = $version;
    }

    /** Publication target for a listing whose non-compliance gate has passed. */
    public static function publicationTarget(object $listing): string
    {
        if (! $listing->regulated) {
            return 'ACTIVE';
        }

        return match ($listing->compliance_status) {
            'VERIFIED' => 'ACTIVE',
            'PENDING_ADMIN_REVIEW' => 'PENDING_ADMIN_REVIEW',
            'REJECTED' => 'REJECTED',
            default => 'PENDING_COMPLIANCE',
        };
    }
}
