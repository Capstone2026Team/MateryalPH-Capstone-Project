<?php

declare(strict_types=1);

namespace App\Domain\Messaging;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Catalog\EligibleOfferQuery;
use App\Domain\Catalog\ReadyMixedConcrete;
use App\Domain\Enforcement\BuyerCommerceRestriction;
use App\Domain\Geography\BuyerProfiles;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Notifications\NotificationService;
use App\Domain\Notifications\PushNotification;
use App\Models\User;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

/**
 * Free Site Inspection / Estimate for ready-mixed concrete (approved by the project owner on 2026-10-16). A Buyer who
 * does not know the required volume asks the store to inspect the site instead. The request lives in the Buyer's
 * Item-Based store conversation, whose delivery destination becomes the inspected site, so the Vendor's later
 * quotation for the measured volume uses that site and the existing quotation acceptance, NRPC and payment rules.
 * The inspection is free and creates no order, hold, reservation or charge. One request is open per conversation.
 *
 * REQUESTED → SCHEDULED (rescheduling allowed) → COMPLETED with the measured volume; REQUESTED or SCHEDULED →
 * DECLINED by the store or CANCELLED by the Buyer. Every change bumps lock_version; a stale version gets 409.
 */
final class SiteInspectionService
{
    public const OPEN = ['REQUESTED', 'SCHEDULED'];

    public const MAX_PREFERRED_DAYS = 60;

    private const VOLUME_PATTERN = '/^\d{1,6}(\.\d{1,3})?$/';

    public function __construct(private readonly ConversationAccess $access, private readonly ConversationService $conversations, private readonly BuyerProfiles $buyers,
        private readonly CatalogAccess $idempotency, private readonly AuditRecorder $audit, private readonly NotificationService $notifications) {}

    /**
     * @param  array<string, mixed>  $input
     * @return array{id: string, conversation_id: string}
     */
    public function request(Request $request, array $input): array
    {
        $buyer = $this->buyers->idFor($request);
        BuyerCommerceRestriction::assertAllowed($buyer);
        $key = $this->idempotency->requireIdempotencyKey($request);
        $today = CarbonImmutable::now('Asia/Manila')->startOfDay();
        Validator::make($input, ['preferred_date' => ['required', 'date_format:Y-m-d', 'after_or_equal:'.$today->toDateString(), 'before_or_equal:'.$today->addDays(self::MAX_PREFERRED_DAYS)->toDateString()]],
            ['preferred_date.after_or_equal' => 'Choose today or a later date.', 'preferred_date.before_or_equal' => 'Choose a date within '.self::MAX_PREFERRED_DAYS.' days.'])->validate();

        return DB::transaction(function () use ($request, $input, $buyer, $key): array {
            DB::table('buyer_profiles')->where('id', $buyer)->lockForUpdate()->first();
            if ($this->idempotency->replayed($request, 'SITE_INSPECTION_REQUEST', $key, (string) $input['listing_id'])) {
                $existing = DB::table('site_inspection_requests')->where('id', $key)->where('buyer_profile_id', $buyer)->first(['id', 'conversation_id']);
                if ($existing !== null) {
                    return ['id' => (string) $existing->id, 'conversation_id' => (string) $existing->conversation_id];
                }
            }
            $listing = DB::table('vendor_listings')->where('id', $input['listing_id'])->first(['id', 'vendor_organization_id', 'display_name']);
            $eligible = $listing !== null && ReadyMixedConcrete::listing((string) $listing->id)
                && app(EligibleOfferQuery::class)->variants()->where('l.id', $listing->id)->exists();
            if (! $eligible) {
                throw new AuthenticationException('SITE_INSPECTION_UNAVAILABLE', 'A free site inspection is available only for ready-mixed concrete the store currently offers.', 422);
            }
            $variant = null;
            if (isset($input['listing_variant_id'])) {
                $variant = DB::table('listing_variants')->where('id', $input['listing_variant_id'])->where('vendor_listing_id', $listing->id)->where('active', true)->first(['id', 'label']);
                if ($variant === null) {
                    throw new AuthenticationException('PRODUCT_UNAVAILABLE', 'Select an available strength class from this product.', 422);
                }
            }
            $site = DB::table('buyer_locations as b')->join('addresses as a', 'a.id', '=', 'b.address_id')->where('b.id', $input['location_id'])->where('b.buyer_profile_id', $buyer)
                ->whereNull('b.archived_at')->whereNotNull('a.location')->first(['b.id', 'b.label', 'b.location_kind', 'a.formatted_address']);
            if ($site === null) {
                throw new AuthenticationException('LOCATION_NOT_FOUND', 'Choose one of your saved locations as the site to inspect.', 422, ['location_id' => ['Choose one of your saved locations.']]);
            }
            $vendorId = (string) $listing->vendor_organization_id;
            $conversationId = $this->conversations->itemConversation($request, $buyer, $vendorId);
            $conversation = $this->access->require($request->user(), $conversationId, true);
            if (DB::table('site_inspection_requests')->where('conversation_id', $conversationId)->whereIn('status', self::OPEN)->exists()) {
                throw new AuthenticationException('SITE_INSPECTION_ALREADY_OPEN', 'You already have an open site inspection request with this store. Follow it in Messages.', 409, ['conversation_id' => $conversationId]);
            }
            // The inspected site becomes the delivery destination the store's quotation will use.
            $this->conversations->destination($request, $conversationId, array_intersect_key($input, array_flip(['heavy_vehicle_restriction', 'alternate_drop_off_location_id', 'access_instructions']))
                + ['location_id' => $site->id, 'heavy_vehicle_restriction' => 'NO', 'lock_version' => (int) $conversation->lock_version]);
            $notes = trim((string) ($input['notes'] ?? ''));
            $publicSite = ['location_id' => (string) $site->id, 'label' => $site->label, 'kind' => (string) $site->location_kind, 'formatted_address' => $site->formatted_address];
            DB::table('site_inspection_requests')->insert([
                'id' => $key, 'conversation_id' => $conversationId, 'buyer_profile_id' => $buyer, 'vendor_organization_id' => $vendorId,
                'vendor_listing_id' => $listing->id, 'listing_variant_id' => $variant?->id, 'buyer_location_id' => $site->id,
                'site' => json_encode($publicSite, JSON_THROW_ON_ERROR), 'preferred_date' => $input['preferred_date'],
                'buyer_notes_encrypted' => $notes === '' ? null : Crypt::encryptString($notes), 'status' => 'REQUESTED',
                'requested_by_user_id' => $request->user()->getKey(), 'requested_at' => now(), 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now(),
            ]);
            $product = (string) $listing->display_name.($variant?->label ? ' · '.$variant->label : '');
            $this->conversations->append(DB::table('conversations')->where('id', $conversationId)->first(), $request->user(),
                'Free site inspection requested for '.$product.'. Site: '.($site->label ?: 'Saved location').'. Preferred date: '.CarbonImmutable::parse((string) $input['preferred_date'])->format('M j, Y').'.');
            $this->notifyVendor($vendorId, $conversationId, $key, 'Site inspection requested', 'A Buyer asked for a free site inspection to estimate the concrete volume for '.$product.'.');
            $this->audit->account($request, 'SITE_INSPECTION_REQUESTED', 'SITE_INSPECTION', $key, after: ['conversation_id' => $conversationId, 'listing_id' => $listing->id, 'preferred_date' => $input['preferred_date']]);
            $this->idempotency->claim($request, 'SITE_INSPECTION_REQUEST', $key, (string) $input['listing_id'], 201);

            return ['id' => $key, 'conversation_id' => $conversationId];
        });
    }

    /**
     * Store-side decision: schedule (or reschedule), decline, or complete with the measured volume.
     *
     * @param  array<string, mixed>  $input
     */
    public function decide(Request $request, string $conversationId, string $inspectionId, string $action, array $input): void
    {
        DB::transaction(function () use ($request, $conversationId, $inspectionId, $action, $input): void {
            $c = $this->access->require($request->user(), $conversationId, true);
            $this->access->requireSales($request->user(), $c);
            $inspection = $this->locked($c, $inspectionId, (int) $input['lock_version']);
            $label = $this->productLabel($inspection);
            $update = ['decided_by_user_id' => $request->user()->getKey(), 'lock_version' => (int) $inspection->lock_version + 1, 'updated_at' => now()];
            switch ($action) {
                case 'schedule':
                    $this->requireStatus($inspection, self::OPEN);
                    $when = CarbonImmutable::parse((string) $input['scheduled_for']);
                    if ($when->lessThanOrEqualTo(now())) {
                        throw new AuthenticationException('VALIDATION_FAILED', 'Choose a future inspection time.', 422, ['scheduled_for' => ['Choose a future inspection time.']]);
                    }
                    $update += ['status' => 'SCHEDULED', 'scheduled_for' => $when->utc(), 'vendor_note' => $this->note($input['note'] ?? null)];
                    $message = 'Site inspection for '.$label.' scheduled for '.$when->setTimezone('Asia/Manila')->format('M j, Y g:i A').' (Philippine time).';
                    break;
                case 'decline':
                    $this->requireStatus($inspection, self::OPEN);
                    $update += ['status' => 'DECLINED', 'vendor_note' => $this->note($input['reason'] ?? null), 'closed_at' => now()];
                    $message = 'The store declined the site inspection for '.$label.': '.$update['vendor_note'];
                    break;
                default:
                    $this->requireStatus($inspection, ['SCHEDULED']);
                    $volume = trim((string) ($input['measured_volume_m3'] ?? ''));
                    if (preg_match(self::VOLUME_PATTERN, $volume) !== 1 || bccomp($volume, '0', 3) <= 0) {
                        throw new AuthenticationException('VALIDATION_FAILED', 'Enter the measured volume in cubic meters.', 422, ['measured_volume_m3' => ['Enter a volume above zero with up to 3 decimal places.']]);
                    }
                    $update += ['status' => 'COMPLETED', 'measured_volume_m3' => $volume, 'vendor_note' => $this->note($input['note'] ?? null), 'closed_at' => now()];
                    $message = 'Site inspected for '.$label.'. Estimated volume: '.rtrim(rtrim(bcadd($volume, '0', 3), '0'), '.').' m³. The store will send a quotation for this volume.';
            }
            DB::table('site_inspection_requests')->where('id', $inspection->id)->update($update);
            $this->conversations->append($c, $request->user(), $message);
            $this->notifyBuyer($c, (string) $inspection->id, 'Site inspection update', $message);
            $this->audit->account($request, 'SITE_INSPECTION_'.$update['status'], 'SITE_INSPECTION', (string) $inspection->id,
                before: ['status' => $inspection->status], after: array_intersect_key($update, array_flip(['status', 'scheduled_for', 'measured_volume_m3'])));
        });
    }

    public function cancel(Request $request, string $conversationId, string $inspectionId, int $lockVersion): void
    {
        DB::transaction(function () use ($request, $conversationId, $inspectionId, $lockVersion): void {
            $c = $this->access->require($request->user(), $conversationId, true);
            if ($request->user()->account_type !== 'BUYER') {
                throw new AuthenticationException('PERMISSION_DENIED', 'Only the Buyer can cancel this request.', 403);
            }
            $inspection = $this->locked($c, $inspectionId, $lockVersion);
            $this->requireStatus($inspection, self::OPEN);
            DB::table('site_inspection_requests')->where('id', $inspection->id)->update(['status' => 'CANCELLED', 'closed_at' => now(), 'lock_version' => $lockVersion + 1, 'updated_at' => now()]);
            $message = 'The Buyer cancelled the site inspection request for '.$this->productLabel($inspection).'.';
            $this->conversations->append($c, $request->user(), $message);
            $this->notifyVendor((string) $c->vendor_organization_id, (string) $c->id, (string) $inspection->id.':cancelled', 'Site inspection cancelled', $message);
            $this->audit->account($request, 'SITE_INSPECTION_CANCELLED', 'SITE_INSPECTION', (string) $inspection->id, before: ['status' => $inspection->status], after: ['status' => 'CANCELLED']);
        });
    }

    /**
     * The conversation's recent inspection requests with the actions the viewer may take. Notes are shown only to
     * the Buyer and the store's sales roles; fulfillment threads never carry inspections.
     *
     * @return list<array<string, mixed>>
     */
    public function forConversation(User $viewer, object $c): array
    {
        if ($c->purpose !== 'SALES' || $c->context_type !== 'ITEM_BASED') {
            return [];
        }
        $buyer = $viewer->account_type === 'BUYER';
        $sales = ! $buyer && in_array($this->access->role($viewer), ConversationAccess::SALES_ROLES, true);
        $rows = DB::table('site_inspection_requests as s')->join('vendor_listings as l', 'l.id', '=', 's.vendor_listing_id')->leftJoin('listing_variants as v', 'v.id', '=', 's.listing_variant_id')
            ->where('s.conversation_id', $c->id)->orderByDesc('s.requested_at')->orderByDesc('s.id')->limit(10)
            ->get(['s.*', 'l.display_name', 'v.label as variant_label']);

        return $rows->map(static function (object $row) use ($buyer, $sales): array {
            $open = in_array($row->status, self::OPEN, true);

            return [
                'id' => (string) $row->id, 'status' => (string) $row->status, 'lock_version' => (int) $row->lock_version,
                'listing' => ['id' => (string) $row->vendor_listing_id, 'display_name' => (string) $row->display_name],
                'variant' => $row->listing_variant_id === null ? null : ['id' => (string) $row->listing_variant_id, 'label' => $row->variant_label],
                'site' => json_decode((string) $row->site, true), 'preferred_date' => (string) $row->preferred_date,
                'buyer_notes' => ($buyer || $sales) && $row->buyer_notes_encrypted !== null ? Crypt::decryptString((string) $row->buyer_notes_encrypted) : null,
                'scheduled_for' => $row->scheduled_for === null ? null : CarbonImmutable::parse((string) $row->scheduled_for)->toIso8601String(),
                'vendor_note' => $row->vendor_note, 'measured_volume_m3' => $row->measured_volume_m3 === null ? null : bcadd((string) $row->measured_volume_m3, '0', 3),
                'requested_at' => CarbonImmutable::parse((string) $row->requested_at)->toIso8601String(),
                'closed_at' => $row->closed_at === null ? null : CarbonImmutable::parse((string) $row->closed_at)->toIso8601String(),
                'free' => true,
                'actions' => ['cancel' => $buyer && $open, 'schedule' => $sales && $open, 'decline' => $sales && $open, 'complete' => $sales && $row->status === 'SCHEDULED'],
            ];
        })->all();
    }

    private function locked(object $c, string $inspectionId, int $lockVersion): object
    {
        $inspection = DB::table('site_inspection_requests')->where('id', $inspectionId)->where('conversation_id', $c->id)->lockForUpdate()->first();
        if ($inspection === null) {
            throw new AuthenticationException('RESOURCE_NOT_FOUND', 'This site inspection request is unavailable.', 404);
        }
        if ((int) $inspection->lock_version !== $lockVersion) {
            throw new AuthenticationException('SITE_INSPECTION_VERSION_CONFLICT', 'This site inspection changed. Refresh the conversation and try again.', 409, ['current_lock_version' => (int) $inspection->lock_version]);
        }

        return $inspection;
    }

    /** @param list<string> $allowed */
    private function requireStatus(object $inspection, array $allowed): void
    {
        if (! in_array($inspection->status, $allowed, true)) {
            throw new AuthenticationException('SITE_INSPECTION_CLOSED', $inspection->status === 'REQUESTED' ? 'Schedule the inspection before recording the measured volume.' : 'This site inspection is already '.strtolower((string) $inspection->status).'.', 409);
        }
    }

    private function note(mixed $value): ?string
    {
        $note = trim((string) ($value ?? ''));

        return $note === '' ? null : mb_substr($note, 0, 1000);
    }

    private function productLabel(object $inspection): string
    {
        $listing = (string) DB::table('vendor_listings')->where('id', $inspection->vendor_listing_id)->value('display_name');
        $variant = $inspection->listing_variant_id === null ? null : DB::table('listing_variants')->where('id', $inspection->listing_variant_id)->value('label');

        return $listing.(is_string($variant) && $variant !== '' ? ' · '.$variant : '');
    }

    private function notifyVendor(string $vendorId, string $conversationId, string $eventId, string $title, string $body): void
    {
        $recipients = DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->where('m.vendor_organization_id', $vendorId)
            ->where('m.status', 'ACTIVE')->whereNull('m.deleted_at')->whereIn('m.role', ['OWNER', 'STORE_MANAGER'])->where('u.account_status', 'ACTIVE')->orderBy('u.id')->pluck('u.id');
        foreach ($recipients as $userId) {
            $this->notifications->record((int) $userId, 'MESSAGES', $title, PushNotification::preview($body), 'CONVERSATION', $conversationId, 'site-inspection:'.$eventId.':'.$userId, $vendorId);
        }
    }

    private function notifyBuyer(object $c, string $inspectionId, string $title, string $body): void
    {
        $userId = DB::table('buyer_profiles')->where('id', $c->buyer_profile_id)->value('user_id');
        if ($userId !== null) {
            $this->notifications->record((int) $userId, 'MESSAGES', $title, PushNotification::preview($body), 'CONVERSATION', (string) $c->id,
                'site-inspection:'.$inspectionId.':'.hash('sha256', $body), (string) $c->vendor_organization_id);
        }
    }
}
