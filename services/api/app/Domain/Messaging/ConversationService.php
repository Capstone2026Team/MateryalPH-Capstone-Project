<?php

declare(strict_types=1);

namespace App\Domain\Messaging;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Catalog\CatalogAccess;
use App\Domain\Geography\BuyerProfiles;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\OutboxPublisher;
use App\Domain\Vendors\NewProcurementAvailability;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class ConversationService
{
    public function __construct(private readonly ConversationAccess $access, private readonly BuyerProfiles $buyers,
        private readonly CatalogAccess $idempotency, private readonly OutboxPublisher $outbox, private readonly AuditRecorder $audit) {}

    /**
     * @param array<string, mixed> $input */
    public function create(Request $request, array $input): string
    {
        $buyer = $this->buyers->idFor($request);
        $key = $this->idempotency->requireIdempotencyKey($request);

        return DB::transaction(function () use ($request, $input, $buyer, $key): string {
            DB::table('buyer_profiles')->where('id', $buyer)->lockForUpdate()->first();
            // A stable UUID supplied as the request key also identifies the thread on a lost response.
            if ($this->idempotency->replayed($request, 'CONVERSATION_CREATE', $key, $key)) {
                return $key;
            }
            app(NewProcurementAvailability::class)->assertAvailable($input['vendor_id']);
            $reference = [];
            if (isset($input['listing_variant_id'])) {
                $variant = DB::table('listing_variants as v')->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')
                    ->where('v.id', $input['listing_variant_id'])->where('l.vendor_organization_id', $input['vendor_id'])->where('l.status', 'ACTIVE')->where('v.active', true)
                    ->first(['v.id', 'v.unit_id', 'v.label', 'l.display_name']);
                if ($variant === null) {
                    throw new AuthenticationException('PRODUCT_UNAVAILABLE', 'Select an available product from this store.', 422);
                }
                $reference = (array) $variant;
            }
            // Phase 10 owns creation of validated Work Package inquiries, through this same engine.
            if (($input['context_type'] ?? 'ITEM_BASED') !== 'ITEM_BASED') {
                throw new AuthenticationException('PROJECT_INQUIRY_UNAVAILABLE', 'Project inquiries become available with Work Package procurement.', 409);
            }
            if (isset($input['location_id'])) {
                $point = DB::table('buyer_locations as b')->join('addresses as a', 'a.id', '=', 'b.address_id')->where('b.id', $input['location_id'])
                    ->where('b.buyer_profile_id', $buyer)->whereNull('b.archived_at')->first(['b.id as location_id', 'b.label', 'a.id as address_id', 'a.latitude', 'a.longitude', 'a.formatted_address']);
                if ($point === null) {
                    throw new AuthenticationException('LOCATION_NOT_FOUND', 'Choose your saved delivery location.', 422);
                }
                $restriction = $input['heavy_vehicle_restriction'] ?? 'UNANSWERED';
                $alternate = null;
                if ($restriction === 'YES') {
                    $alternate = DB::table('buyer_locations as b')->join('addresses as a', 'a.id', '=', 'b.address_id')->where('b.id', $input['alternate_drop_off_location_id'])
                        ->where('b.buyer_profile_id', $buyer)->whereNull('b.archived_at')->first(['b.id as location_id', 'b.label', 'a.id as address_id', 'a.latitude', 'a.longitude', 'a.formatted_address']);
                    if ($alternate === null) {
                        throw new AuthenticationException('LOCATION_NOT_FOUND', 'Choose your saved alternative vehicle drop-off.', 422);
                    }
                }
                $reference['destination'] = ['type' => 'DELIVERY', 'intended' => (array) $point, 'heavy_vehicle_restriction' => $restriction, 'alternate_drop_off' => $alternate === null ? null : (array) $alternate,
                    'access_instructions' => $input['access_instructions'] ?? null, 'vehicle_endpoint' => $restriction === 'YES' ? 'ALTERNATE_DROP_OFF' : 'INTENDED_LOCATION'];
            }
            $owner = DB::table('vendor_memberships')->where('vendor_organization_id', $input['vendor_id'])->where('role', 'OWNER')->where('status', 'ACTIVE')->value('user_id');
            if ($owner === null) {
                throw new AuthenticationException('STORE_UNAVAILABLE', 'This store cannot receive inquiries right now.', 409);
            }
            DB::table('conversations')->insert(['id' => $key, 'buyer_profile_id' => $buyer, 'vendor_organization_id' => $input['vendor_id'], 'purpose' => 'SALES',
                'context_type' => 'ITEM_BASED', 'context_id' => $input['listing_variant_id'] ?? null, 'handler_user_id' => $owner,
                'locked_reference' => json_encode($reference, JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
            $this->participant($key, (int) $request->user()->id, 'BUYER');
            $this->participant($key, (int) $owner, 'OWNER');
            DB::table('conversation_assignments')->insert(['id' => (string) Str::uuid7(), 'conversation_id' => $key, 'assigned_user_id' => $owner, 'assigned_role' => 'OWNER', 'created_at' => now(), 'updated_at' => now()]);
            $this->idempotency->claim($request, 'CONVERSATION_CREATE', $key, $key, 201);
            $this->audit->account($request, 'CONVERSATION_CREATED', 'CONVERSATION', $key, after: ['purpose' => 'SALES']);
            $this->changed($key);

            return $key;
        });
    }

    public function participant(string $id, int $userId, string $role): void
    {
        $existing = DB::table('conversation_participants')->where('conversation_id', $id)->where('user_id', $userId)->first();
        if ($existing !== null) {
            DB::table('conversation_participants')->where('id', $existing->id)->update(['participant_role' => $role, 'revoked_at' => null, 'updated_at' => now()]);
        } else {
            DB::table('conversation_participants')->insert(['id' => (string) Str::uuid7(), 'conversation_id' => $id, 'user_id' => $userId, 'participant_role' => $role, 'created_at' => now(), 'updated_at' => now()]);
        }
    }

    /**
     * @return array<string, mixed> */
    public function inbox(Request $request): array
    {
        $query = DB::table('conversations as c');
        if ($request->user()->account_type === 'BUYER') {
            $query->where('buyer_profile_id', $this->buyers->idFor($request));
        } else {
            $scope = app(AccountAccess::class)->resolve($request->user());
            $query->where('vendor_organization_id', $scope['organization_id']);
            if ($scope['role'] === 'FULFILLMENT') {
                $query->where('purpose', 'FULFILLMENT')->whereIn('order_id', DB::table('order_fulfillment_assignments')->select('order_id')->where('user_id', $request->user()->id)->whereNull('ended_at'));
            } elseif (! in_array($scope['role'], ['OWNER', 'STORE_MANAGER'], true)) {
                $query->where('purpose', 'SALES')->where('handler_user_id', $request->user()->id)
                    ->whereIn('id', DB::table('conversation_participants')->select('conversation_id')->where('user_id', $request->user()->id)->where('participant_role', $scope['role'])->whereNull('revoked_at'));
                if (! in_array($scope['role'], ConversationAccess::SALES_ROLES, true)) {
                    $query->whereRaw('1 = 0');
                }
            }
        }
        $page = $query->orderByDesc('updated_at')->orderByDesc('id')->paginate(25);

        return ['items' => array_map(fn (object $c): array => $this->header($request, $c), $page->items()), 'page' => $page->currentPage(), 'has_more' => $page->hasMorePages()];
    }

    /**
     * @return array<string, mixed> */
    public function header(Request $request, object $c): array
    {
        $store = DB::table('store_profiles')->where('vendor_organization_id', $c->vendor_organization_id)->first();
        $logo = $store?->logo_file_id === null ? null : DB::table('files as f')->join('store_media as m', 'm.file_id', '=', 'f.id')->where('f.id', $store->logo_file_id)->where('f.visibility', 'PUBLIC')->where('f.scan_state', 'CLEAN')->where('m.status', 'READY')->value('f.metadata');
        $logoData = is_string($logo) ? json_decode($logo, true) : [];
        $handler = $c->handler_user_id === null ? null : User::find($c->handler_user_id);
        $handlerIdentity = $handler !== null && $this->access->allows($handler, $c) ? $this->identity($handler, $c) : null;
        $unread = DB::table('messages as m')->where('m.conversation_id', $c->id)->where('m.sender_user_id', '<>', $request->user()->id)
            ->whereNotExists(fn ($q) => $q->selectRaw('1')->from('message_read_receipts as r')->whereColumn('r.message_id', 'm.id')->where('r.user_id', $request->user()->id))->count();

        return ['id' => $c->id, 'purpose' => $c->purpose, 'context_type' => $c->context_type, 'order_id' => $c->order_id, 'lock_version' => (int) $c->lock_version,
            'store' => ['id' => $c->vendor_organization_id, 'name' => $store->public_store_name ?? 'Store', 'logo_url' => $logoData['public_url'] ?? null,
                'verified' => DB::table('vendor_organizations')->where('id', $c->vendor_organization_id)->where('store_verification_status', 'APPROVED')->exists()],
            'handler' => $handlerIdentity, 'unread_count' => $unread, 'channel' => $this->access->channel($request->user(), $c),
            'locked_reference' => json_decode((string) $c->locked_reference, true), 'updated_at' => $c->updated_at,
            'can_transfer' => $request->user()->account_type === 'VENDOR' && $c->purpose === 'SALES', 'fulfillment_entry_enabled' => false];
    }

    /** Public allowlist only: login email, private phone, IDs and verification documents never enter the projection.
     * @return array<string, mixed> */
    public function identity(User $user, object $c): array
    {
        $profile = DB::table('user_profiles')->where('user_id', $user->id)->first();

        return ['display_name' => $profile?->full_name ?: ($user->account_type === 'BUYER' ? 'Buyer' : 'Store team'), 'role' => $this->access->role($user),
            'avatar_path' => $profile?->profile_photo_key === null ? null : '/conversations/'.$c->id.'/avatars/'.$user->id];
    }

    /**
     * @return array<string, mixed> */
    public function messages(Request $request, string $id): array
    {
        $this->access->require($request->user(), $id);
        $query = DB::table('messages')->where('conversation_id', $id);
        if (is_string($request->query('before'))) {
            $query->where('id', '<', $request->query('before'));
        }
        $rows = $query->orderByDesc('id')->limit(51)->get();
        $hasMore = $rows->count() > 50;
        $rows = $rows->take(50);

        return ['items' => $rows->reverse()->map(function (object $m) use ($request): array {
            $attachments = DB::table('message_attachments')->where('message_id', $m->id)->get(['id', 'display_name', 'media_type', 'size_bytes', 'scan_state']);

            return ['id' => $m->id, 'client_message_id' => $m->client_message_id, 'body' => $m->body, 'kind' => $m->kind, 'sender' => json_decode($m->public_sender, true),
                'sent_at' => $m->sent_at, 'mine' => (int) $m->sender_user_id === (int) $request->user()->id, 'attachments' => $attachments->all(),
                'read_by_recipient' => DB::table('message_read_receipts')->where('message_id', $m->id)->where('user_id', '<>', $m->sender_user_id)->exists()];
        })->values()->all(), 'has_more' => $hasMore, 'next_before' => $hasMore ? $rows->last()->id : null];
    }

    public function send(Request $request, string $id, string $body, string $clientId): string
    {
        return DB::transaction(function () use ($request, $id, $body, $clientId): string {
            $c = $this->access->require($request->user(), $id, true);
            $old = DB::table('messages')->where('conversation_id', $id)->where('client_message_id', $clientId)->first();
            if ($old !== null) {
                if ((int) $old->sender_user_id !== (int) $request->user()->id || $old->body !== trim($body)) {
                    throw new AuthenticationException('IDEMPOTENCY_CONFLICT', 'Use a new message identifier for changed text.', 409);
                }

                return (string) $old->id;
            }

            return $this->append($c, $request->user(), trim($body), 'TEXT', $clientId);
        });
    }

    public function append(object $c, User $actor, string $body, string $kind = 'SYSTEM', ?string $clientId = null): string
    {
        $id = (string) Str::uuid7();
        DB::table('messages')->insert(['id' => $id, 'conversation_id' => $c->id, 'sender_user_id' => $actor->id, 'body' => $body, 'kind' => $kind,
            'client_message_id' => $clientId ?? (string) Str::uuid7(), 'public_sender' => json_encode($kind === 'SYSTEM' ? ['display_name' => 'MateryalPH', 'role' => 'SYSTEM', 'avatar_path' => null] : $this->identity($actor, $c), JSON_THROW_ON_ERROR), 'sent_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        DB::table('conversations')->where('id', $c->id)->update(['updated_at' => now()]);
        $this->changed((string) $c->id);

        return $id;
    }

    public function changed(string $id): void
    {
        $this->outbox->publish('CONVERSATION_CHANGED', 'CONVERSATION', $id, ['conversation_id' => $id]);
    }

    public function read(Request $request, string $id, string $through): void
    {
        DB::transaction(function () use ($request, $id, $through): void {
            $this->access->require($request->user(), $id, true);
            if (! DB::table('messages')->where('conversation_id', $id)->where('id', $through)->exists()) {
                throw new AuthenticationException('MESSAGE_NOT_FOUND', 'This message is unavailable.', 404);
            }
            DB::table('messages')->where('conversation_id', $id)->where('id', '<=', $through)->orderBy('id')->chunkById(100, function ($rows) use ($request): void {
                foreach ($rows as $m) {
                    DB::table('message_read_receipts')->insertOrIgnore(['id' => (string) Str::uuid7(), 'message_id' => $m->id, 'user_id' => $request->user()->id, 'read_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
                }
            });
            $this->changed($id);
        });
    }

    /**
     * @return array<string, mixed> */
    public function handlers(Request $request, string $id): array
    {
        $c = $this->access->require($request->user(), $id);
        $this->access->requireSales($request->user(), $c);

        $page = DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->leftJoin('user_profiles as p', 'p.user_id', '=', 'u.id')
            ->where('m.vendor_organization_id', $c->vendor_organization_id)->where('m.status', 'ACTIVE')->where('u.account_status', 'ACTIVE')->whereIn('m.role', ConversationAccess::SALES_ROLES)
            ->orderBy('p.full_name')->orderBy('u.id')->paginate(50, ['u.id', 'p.full_name as display_name', 'm.role']);

        return ['items' => $page->items(), 'page' => $page->currentPage(), 'has_more' => $page->hasMorePages()];
    }

    public function transfer(Request $request, string $id, int $targetId, int $version, string $reason): void
    {
        DB::transaction(function () use ($request, $id, $targetId, $version, $reason): void {
            $c = $this->access->require($request->user(), $id, true);
            $this->access->requireSales($request->user(), $c);
            if ((int) $c->lock_version !== $version) {
                throw new AuthenticationException('CONVERSATION_VERSION_CONFLICT', 'The handler changed. Refresh before transferring.', 409);
            }
            $target = DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->where('m.vendor_organization_id', $c->vendor_organization_id)
                ->where('m.user_id', $targetId)->where('m.status', 'ACTIVE')->where('u.account_status', 'ACTIVE')->whereIn('m.role', ConversationAccess::SALES_ROLES)->first(['m.role']);
            if ($target === null) {
                throw new AuthenticationException('HANDLER_UNAVAILABLE', 'Choose an active sales handler from this store.', 422);
            }
            DB::table('conversation_assignments')->where('conversation_id', $id)->whereNull('ended_at')->update(['ended_at' => now(), 'updated_at' => now()]);
            DB::table('conversation_participants')->where('conversation_id', $id)->where('user_id', $c->handler_user_id)->update(['revoked_at' => now(), 'updated_at' => now()]);
            DB::table('conversation_assignments')->insert(['id' => (string) Str::uuid7(), 'conversation_id' => $id, 'assigned_user_id' => $targetId, 'assigned_by_user_id' => $request->user()->id,
                'assigned_role' => $target->role, 'reason' => $reason, 'created_at' => now(), 'updated_at' => now()]);
            $this->participant($id, $targetId, $target->role);
            DB::table('conversations')->where('id', $id)->update(['handler_user_id' => $targetId, 'lock_version' => $version + 1, 'updated_at' => now()]);
            $name = DB::table('user_profiles')->where('user_id', $targetId)->value('full_name') ?: 'Store team';
            $this->append($c, $request->user(), 'Conversation transferred. Handled by '.$name.' ('.str_replace('_', ' ', $target->role).').');
            $this->audit->account($request, 'CONVERSATION_TRANSFERRED', 'CONVERSATION', $id, before: ['handler_user_id' => $c->handler_user_id], after: ['handler_user_id' => $targetId, 'role' => $target->role]);
        });
    }
}
