<?php

declare(strict_types=1);

namespace App\Domain\Messaging;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Authorization\VendorTeamActivityBroadcast;
use App\Domain\Authorization\VendorTeamActivityQuery;
use App\Domain\Catalog\CatalogAccess;
use App\Domain\Catalog\EligibleOfferQuery;
use App\Domain\Enforcement\BuyerCommerceRestriction;
use App\Domain\Geography\BuyerProfiles;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Notifications\NotificationBroadcast;
use App\Domain\Notifications\NotificationService;
use App\Domain\Notifications\PushNotification;
use App\Domain\Operations\OutboxPublisher;
use App\Domain\Orders\OrderAccess;
use App\Domain\Orders\OrderEligibility;
use App\Domain\Vendors\NewProcurementAvailability;
use App\Models\User;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class ConversationService
{
    public function __construct(private readonly ConversationAccess $access, private readonly BuyerProfiles $buyers,
        private readonly CatalogAccess $idempotency, private readonly OutboxPublisher $outbox, private readonly AuditRecorder $audit) {}

    /** Open the authorized order's existing sales context, or its permanent store chat. */
    public function fromOrder(Request $request, string $orderId): string
    {
        $orders = app(OrderAccess::class);
        $scope = $orders->vendorScope($request);
        $order = $orders->vendorOrder($scope, $orderId);
        $key = $this->idempotency->requireIdempotencyKey($request);
        if (! in_array($scope['role'], [...ConversationAccess::SALES_ROLES, 'FULFILLMENT'], true)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'Your role cannot message this Buyer.', 403);
        }

        return DB::transaction(function () use ($request, $order, $scope, $key): string {
            $buyer = DB::table('buyer_profiles')->where('id', $order->buyer_profile_id)->lockForUpdate()->first();
            $replayed = $this->idempotency->replayed($request, 'ORDER_CONVERSATION', $key, $order->id);
            if ($scope['role'] === 'FULFILLMENT') {
                $id = DB::table('conversations')->where('order_id', $order->id)->where('purpose', 'FULFILLMENT')->value('id');
            } elseif ($order->quotation_version_id !== null) {
                $id = DB::table('quotation_versions as v')->join('quotations as q', 'q.id', '=', 'v.quotation_id')->where('v.id', $order->quotation_version_id)->value('q.conversation_id');
            } else {
                $id = DB::table('conversations')->where('buyer_profile_id', $order->buyer_profile_id)->where('vendor_organization_id', $order->vendor_organization_id)
                    ->where('purpose', 'SALES')->where('context_type', 'ITEM_BASED')->whereNull('canonical_conversation_id')->value('id');
            }
            if ($id === null) {
                if ($scope['role'] === 'FULFILLMENT' || $order->procurement_type !== 'ITEM_BASED' || $order->quotation_version_id !== null || $buyer === null) {
                    throw new AuthenticationException('CONVERSATION_UNAVAILABLE', 'This order does not have an available conversation yet.', 409);
                }
                $id = (string) Str::uuid7();
                DB::table('conversations')->insert(['id' => $id, 'buyer_profile_id' => $order->buyer_profile_id, 'vendor_organization_id' => $order->vendor_organization_id,
                    'purpose' => 'SALES', 'context_type' => 'ITEM_BASED', 'context_id' => null, 'handler_user_id' => $request->user()->id,
                    'locked_reference' => '{}', 'created_at' => now(), 'updated_at' => now()]);
                $this->participant($id, (int) $buyer->user_id, 'BUYER');
                $this->participant($id, (int) $request->user()->id, $scope['role']);
                DB::table('conversation_assignments')->insert(['id' => (string) Str::uuid7(), 'conversation_id' => $id, 'assigned_user_id' => $request->user()->id,
                    'assigned_role' => $scope['role'], 'created_at' => now(), 'updated_at' => now()]);
                $this->audit->account($request, 'CONVERSATION_CREATED', 'CONVERSATION', $id, after: ['purpose' => 'SALES', 'order_id' => $order->id]);
                $this->changed($id);
            }
            $conversation = $this->access->require($request->user(), (string) $id);
            if ($conversation->canonical_conversation_id !== null) {
                $id = $this->access->require($request->user(), $conversation->canonical_conversation_id)->id;
            }
            if (! $replayed) {
                $this->idempotency->claim($request, 'ORDER_CONVERSATION', $key, $order->id, 200);
            }

            return (string) $id;
        });
    }

    /**
     * @param array<string, mixed> $input */
    public function create(Request $request, array $input): string
    {
        $buyer = $this->buyers->idFor($request);
        BuyerCommerceRestriction::assertAllowed($buyer);
        $key = $this->idempotency->requireIdempotencyKey($request);

        return DB::transaction(function () use ($request, $input, $buyer, $key): string {
            if (($input['context_type'] ?? 'ITEM_BASED') !== 'ITEM_BASED') {
                throw new AuthenticationException('PROJECT_INQUIRY_UNAVAILABLE', 'Use the Work Package inquiry flow for Project-Based procurement.', 409);
            }
            DB::table('buyer_profiles')->where('id', $buyer)->lockForUpdate()->first();
            // A stable UUID supplied as the request key also identifies the thread on a lost response.
            $replayed = $this->idempotency->replayed($request, 'CONVERSATION_CREATE', $key, $key);
            $existing = DB::table('conversations')->where('buyer_profile_id', $buyer)->where('vendor_organization_id', $input['vendor_id'])
                ->where('purpose', 'SALES')->where('context_type', 'ITEM_BASED')->whereNull('canonical_conversation_id')->first();
            if ($existing !== null) {
                $this->access->require($request->user(), $existing->id);
                if (! $replayed) {
                    $this->idempotency->claim($request, 'CONVERSATION_CREATE', $key, $key, 201);
                }

                return $existing->id;
            }
            app(NewProcurementAvailability::class)->assertAvailable($input['vendor_id']);
            if (isset($input['listing_variant_id'])) {
                $variant = DB::table('listing_variants as v')->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')
                    ->where('v.id', $input['listing_variant_id'])->where('l.vendor_organization_id', $input['vendor_id'])->where('l.status', 'ACTIVE')->where('v.active', true)
                    ->first(['v.id', 'v.unit_id', 'v.label', 'l.display_name']);
                if ($variant === null) {
                    throw new AuthenticationException('PRODUCT_UNAVAILABLE', 'Select an available product from this store.', 422);
                }
                // Selection belongs to a local unsent draft; only sending snapshots a product.
            }
            $this->insertItemConversation($request, $key, $buyer, (string) $input['vendor_id'], $this->destinationReference($input, $buyer));
            $this->idempotency->claim($request, 'CONVERSATION_CREATE', $key, $key, 201);

            return $key;
        });
    }

    /**
     * The Buyer's Item-Based store conversation, created when missing. Callers hold the Buyer profile lock inside
     * their transaction and have checked commerce restrictions.
     */
    public function itemConversation(Request $request, string $buyer, string $vendorId, bool $existingRelationship = false): string
    {
        $existing = DB::table('conversations')->where('buyer_profile_id', $buyer)->where('vendor_organization_id', $vendorId)
            ->where('purpose', 'SALES')->where('context_type', 'ITEM_BASED')->whereNull('canonical_conversation_id')->value('id');
        if ($existing !== null) {
            $this->access->require($request->user(), (string) $existing);

            return (string) $existing;
        }
        if (! $existingRelationship) {
            app(NewProcurementAvailability::class)->assertAvailable($vendorId);
        }
        $id = (string) Str::uuid7();
        $this->insertItemConversation($request, $id, $buyer, $vendorId, []);

        return $id;
    }

    /** @param array<string, mixed> $reference */
    private function insertItemConversation(Request $request, string $id, string $buyer, string $vendorId, array $reference): void
    {
        $owner = DB::table('vendor_memberships')->where('vendor_organization_id', $vendorId)->where('role', 'OWNER')->where('status', 'ACTIVE')->value('user_id');
        if ($owner === null) {
            throw new AuthenticationException('STORE_UNAVAILABLE', 'This store cannot receive inquiries right now.', 409);
        }
        $handler = $request->user()->account_type === 'VENDOR' ? (int) $request->user()->id : (int) $owner;
        $handlerRole = $request->user()->account_type === 'VENDOR' ? $this->access->role($request->user()) : 'OWNER';
        if (! in_array($handlerRole, ConversationAccess::SALES_ROLES, true)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'Your role cannot initiate a sales inquiry.', 403);
        }
        DB::table('conversations')->insert(['id' => $id, 'buyer_profile_id' => $buyer, 'vendor_organization_id' => $vendorId, 'purpose' => 'SALES',
            'context_type' => 'ITEM_BASED', 'context_id' => null, 'handler_user_id' => $handler,
            'locked_reference' => json_encode($reference, JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
        $this->participant($id, (int) DB::table('buyer_profiles')->where('id', $buyer)->value('user_id'), 'BUYER');
        $this->participant($id, $handler, $handlerRole);
        DB::table('conversation_assignments')->insert(['id' => (string) Str::uuid7(), 'conversation_id' => $id, 'assigned_user_id' => $handler, 'assigned_role' => $handlerRole, 'created_at' => now(), 'updated_at' => now()]);
        $this->audit->account($request, 'CONVERSATION_CREATED', 'CONVERSATION', $id, after: ['purpose' => 'SALES']);
        $this->changed($id);
    }

    /** @param array<string, mixed> $input
     * @return array<string, mixed> */
    private function destinationReference(array $input, string $buyer): array
    {
        $reference = [];
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

        return $reference;
    }

    /** @param array<string, mixed> $input */
    public function destination(Request $request, string $id, array $input): void
    {
        $buyer = $this->buyers->idFor($request);
        $reference = $this->destinationReference($input, $buyer);
        DB::transaction(function () use ($request, $id, $input, $reference): void {
            $c = $this->access->require($request->user(), $id, true);
            $this->requireCurrent($c);
            if ($c->purpose !== 'SALES' || $c->context_type !== 'ITEM_BASED') {
                throw new AuthenticationException('DESTINATION_LOCKED', 'Work Package and fulfillment destinations retain their own workflow.', 409);
            }
            if ((int) $c->lock_version !== $input['lock_version']) {
                throw new AuthenticationException('CONVERSATION_VERSION_CONFLICT', 'The conversation changed. Refresh before updating delivery details.', 409);
            }
            $q = DB::table('quotations')->where('conversation_id', $id)->orderByDesc('id')->lockForUpdate()->first();
            if ($q !== null && in_array($q->state, ['PUBLISHED', 'VIEWED'], true)) {
                throw new AuthenticationException('DESTINATION_LOCKED', 'Ask the Vendor to withdraw the published quotation before changing delivery details.', 409);
            }
            $before = json_decode((string) $c->locked_reference, true);
            DB::table('conversations')->where('id', $id)->update(['locked_reference' => json_encode(array_replace($before, $reference), JSON_THROW_ON_ERROR),
                'lock_version' => $c->lock_version + 1, 'updated_at' => now()]);
            if ($q !== null && $q->state !== 'ACCEPTED') {
                DB::table('quotations')->where('id', $q->id)->update(['lock_version' => $q->lock_version + 1, 'updated_at' => now()]);
            }
            $this->audit->account($request, 'CONVERSATION_DESTINATION_UPDATED', 'CONVERSATION', $id, after: ['lock_version' => $c->lock_version + 1]);
            $this->changed($id);
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

    /** Internal Phase 10 entry: caller has authorized and locked the Project/version and compiled candidate.
     * @param array<string, mixed> $reference */
    public function createProject(Request $request, string $id, string $vendor, string $package, array $reference): void
    {
        $this->createProjectForBuyer($request, $id, $vendor, $package, $reference, $this->buyers->idFor($request));
    }

    /** Internal entry after authorizing a pending order or Work Package.
     * @param array<string, mixed> $reference */
    public function createProjectForBuyer(Request $request, string $id, string $vendor, string $package, array $reference, string $buyer): void
    {
        $buyerRow = DB::table('buyer_profiles')->where('id', $buyer)->lockForUpdate()->first();
        app(NewProcurementAvailability::class)->assertAvailable($vendor);
        $org = DB::table('vendor_organizations')->where('id', $vendor)->first();
        if (app(OrderEligibility::class)->storeBlockers($org) !== [] || ! DB::table('store_profiles')->where('vendor_organization_id', $vendor)->where('bulk_capability', true)->exists()) {
            throw new AuthenticationException('PROJECT_VENDOR_INELIGIBLE', 'This Vendor is no longer eligible for new Project-Based work.', 409);
        }
        $owner = DB::table('vendor_memberships')->where('vendor_organization_id', $vendor)->where('role', 'OWNER')->where('status', 'ACTIVE')->value('user_id');
        if ($owner === null) {
            throw new AuthenticationException('STORE_UNAVAILABLE', 'This store cannot receive inquiries right now.', 409);
        }
        $handler = $request->user()->account_type === 'VENDOR' ? (int) $request->user()->id : (int) $owner;
        $handlerRole = $request->user()->account_type === 'VENDOR' ? $this->access->role($request->user()) : 'OWNER';
        if (! in_array($handlerRole, ConversationAccess::SALES_ROLES, true)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'Your role cannot initiate a sales inquiry.', 403);
        }
        DB::table('conversations')->insert(['id' => $id, 'buyer_profile_id' => $buyer, 'vendor_organization_id' => $vendor, 'purpose' => 'SALES',
            'context_type' => 'PROJECT_BASED', 'context_id' => $package, 'handler_user_id' => $handler, 'locked_reference' => json_encode($reference, JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
        $this->participant($id, (int) $buyerRow->user_id, 'BUYER');
        $this->participant($id, $handler, $handlerRole);
        DB::table('conversation_assignments')->insert(['id' => (string) Str::uuid7(), 'conversation_id' => $id, 'assigned_user_id' => $handler, 'assigned_role' => $handlerRole, 'created_at' => now(), 'updated_at' => now()]);
        $this->changed($id);
    }

    /**
     * @return array<string, mixed> */
    public function inbox(Request $request): array
    {
        $fulfillmentStaff = $request->user()->account_type === 'VENDOR' && $this->access->role($request->user()) === 'FULFILLMENT';
        if (! $fulfillmentStaff && in_array($request->user()->account_type, ['VENDOR', 'BUYER'], true)) {
            // Group before pagination, so a Buyer never appears again on a later page.
            $scope = $this->inboxQuery($request);
            $partition = $request->user()->account_type === 'BUYER' ? 'c.vendor_organization_id' : 'c.buyer_profile_id';
            $ranked = (clone $scope)->select('c.*')->selectRaw('c.updated_at as inbox_updated_at, ROW_NUMBER() OVER (PARTITION BY '.$partition.' ORDER BY c.updated_at DESC, c.id DESC) as buyer_position');
            $page = DB::query()->fromSub($ranked, 'buyers')->where('buyer_position', 1)->orderByDesc('inbox_updated_at')->orderByDesc('id')->paginate(25);
            $rows = $page->items();
            $roots = $this->inboxQuery($request, filterArchived: false, includeHistory: true)->where('c.purpose', 'SALES')->where('c.context_type', 'ITEM_BASED')->whereNull('c.canonical_conversation_id')
                ->whereIn('c.buyer_profile_id', array_column($rows, 'buyer_profile_id'))->whereIn('c.vendor_organization_id', array_column($rows, 'vendor_organization_id'))->get(['c.*'])->keyBy(fn (object $c): string => $c->buyer_profile_id.'|'.$c->vendor_organization_id);
            $rows = array_map(static function (object $row) use ($roots): object {
                $root = clone ($roots->get($row->buyer_profile_id.'|'.$row->vendor_organization_id) ?? $row);
                $root->inbox_updated_at = $row->inbox_updated_at;

                return $root;
            }, $rows);

            return ['items' => app(ConversationHeaders::class)->build($request, $rows, $scope, $this->activeProjectInquiries($request), grouped: true), 'page' => $page->currentPage(), 'has_more' => $page->hasMorePages()];
        }
        $page = $this->inboxQuery($request)->orderByDesc('c.updated_at')->orderByDesc('c.id')->paginate(25, ['c.*']);

        return ['items' => app(ConversationHeaders::class)->build($request, $page->items(), $this->inboxQuery($request, filterArchived: false)->where('c.purpose', 'SALES'), $this->activeProjectInquiries($request)), 'page' => $page->currentPage(), 'has_more' => $page->hasMorePages()];
    }

    /** Uses the same current role, assignment and canonical-thread scope as the inbox, across every page. */
    public function unreadInboxCount(Request $request): int
    {
        return $this->unreadQueryCount($request, $this->inboxQuery($request));
    }

    /** Vendor navigation includes authorized fulfillment threads without changing the sales inbox's contents. */
    public function unreadNavigationCount(Request $request): int
    {
        return $this->unreadQueryCount($request, $this->inboxQuery($request, includeFulfillment: true));
    }

    private function unreadQueryCount(Request $request, Builder $conversations): int
    {
        return DB::table('messages as m')->whereIn('m.conversation_id', $conversations->select('c.id'))
            ->where('m.sender_user_id', '<>', $request->user()->id)
            ->whereNotExists(fn ($query) => $query->selectRaw('1')->from('message_read_receipts as r')
                ->whereColumn('r.message_id', 'm.id')->where('r.user_id', $request->user()->id))->count();
    }

    private function inboxQuery(Request $request, bool $includeFulfillment = false, bool $filterArchived = true, bool $includeHistory = false): Builder
    {
        $query = DB::table('conversations as c');
        if (! $includeHistory) {
            $query->whereNull('canonical_conversation_id');
        }
        // Older releases created empty store chats solely as containers for Work Package inquiries.
        if (! $includeHistory) {
            $query->where(fn (Builder $q) => $q->where('c.context_type', '<>', 'ITEM_BASED')->orWhere('c.purpose', '<>', 'SALES')
                ->orWhereExists(fn (Builder $m) => $m->selectRaw('1')->from('messages')->whereColumn('messages.conversation_id', 'c.id'))
                ->orWhereExists(fn (Builder $quote) => $quote->selectRaw('1')->from('quotations')->whereColumn('quotations.conversation_id', 'c.id'))
                ->orWhereNotExists(fn (Builder $project) => $project->selectRaw('1')->from('conversations as sibling')->whereColumn('sibling.buyer_profile_id', 'c.buyer_profile_id')
                    ->whereColumn('sibling.vendor_organization_id', 'c.vendor_organization_id')->where('sibling.purpose', 'SALES')->where('sibling.context_type', 'PROJECT_BASED')));
        }
        if ($request->user()->account_type === 'BUYER') {
            // Order-specific fulfillment threads live in Order Details, not in the Buyer's message inbox.
            $query->where('buyer_profile_id', $this->buyers->idFor($request))->where('purpose', 'SALES');
            if ($filterArchived) {
                $this->filterArchived($request, $query);
            }
        } else {
            $scope = $request->attributes->get('account_scope') ?? app(AccountAccess::class)->resolve($request->user());
            $query->where('vendor_organization_id', $scope['organization_id']);
            if ($scope['role'] === 'FULFILLMENT') {
                $query->where('purpose', 'FULFILLMENT')->whereIn('order_id', DB::table('order_fulfillment_assignments')->select('order_id')->where('user_id', $request->user()->id)->whereNull('ended_at'));
            } elseif (! in_array($scope['role'], ['OWNER', 'STORE_MANAGER'], true)) {
                $query->where('purpose', 'SALES')->where('handler_user_id', $request->user()->id)
                    ->whereIn('id', DB::table('conversation_participants')->select('conversation_id')->where('user_id', $request->user()->id)->where('participant_role', $scope['role'])->whereNull('revoked_at'));
                if (! in_array($scope['role'], ConversationAccess::SALES_ROLES, true)) {
                    $query->whereRaw('1 = 0');
                }
            } else {
                // Owner and Store Manager use the order popup or inquiry's linked list, not the main sales inbox.
                $query->whereIn('purpose', $includeFulfillment ? ['SALES', 'FULFILLMENT'] : ['SALES']);
            }
        }

        return $query;
    }

    /** The same current role and assignment boundary used by the inbox; a Buyer thread never expands authority. */
    public function buyerThreadScope(Request $request, object $source, bool $includeHistory = true): Builder
    {
        $query = $this->inboxQuery($request, filterArchived: false, includeHistory: true)
            ->where('c.buyer_profile_id', $source->buyer_profile_id)->where('c.vendor_organization_id', $source->vendor_organization_id);
        if ($this->access->role($request->user()) === 'FULFILLMENT') {
            $query->where('c.id', $source->id);
        }

        return $includeHistory ? $query : $query->whereNull('c.canonical_conversation_id');
    }

    /** Permanent sales parent for an existing order relationship, independent of fulfillment closure. */
    public function ensureOrderStoreChat(object $order): string
    {
        return DB::transaction(function () use ($order): string {
            $buyer = DB::table('buyer_profiles')->where('id', $order->buyer_profile_id)->lockForUpdate()->firstOrFail();
            $existing = DB::table('conversations')->where('buyer_profile_id', $order->buyer_profile_id)->where('vendor_organization_id', $order->vendor_organization_id)
                ->where('purpose', 'SALES')->where('context_type', 'ITEM_BASED')->whereNull('canonical_conversation_id')->value('id');
            if ($existing !== null) {
                return (string) $existing;
            }
            $id = (string) Str::uuid7();
            $owner = DB::table('vendor_memberships')->where('vendor_organization_id', $order->vendor_organization_id)->where('role', 'OWNER')->whereNull('deleted_at')->value('user_id');
            DB::table('conversations')->insert(['id' => $id, 'buyer_profile_id' => $order->buyer_profile_id, 'vendor_organization_id' => $order->vendor_organization_id,
                'purpose' => 'SALES', 'context_type' => 'ITEM_BASED', 'handler_user_id' => $owner, 'locked_reference' => '{}',
                'created_at' => $order->created_at, 'updated_at' => $order->created_at]);
            $this->participant($id, (int) $buyer->user_id, 'BUYER');
            if ($owner !== null) {
                $this->participant($id, (int) $owner, 'OWNER');
                DB::table('conversation_assignments')->insert(['id' => (string) Str::uuid7(), 'conversation_id' => $id, 'assigned_user_id' => $owner,
                    'assigned_role' => 'OWNER', 'reason' => 'Permanent store chat for an existing order', 'created_at' => now(), 'updated_at' => now()]);
            }
            DB::table('audit_logs')->insert(['id' => (string) Str::uuid7(), 'actor_role' => 'SYSTEM', 'vendor_organization_id' => $order->vendor_organization_id,
                'action' => 'CONVERSATION_CREATED', 'resource_type' => 'CONVERSATION', 'resource_id' => $id,
                'before' => '{}', 'after' => json_encode(['purpose' => 'SALES', 'order_id' => $order->id], JSON_THROW_ON_ERROR),
                'reason' => 'Permanent store chat for an existing order', 'correlation_id' => (string) Str::uuid7(), 'succeeded' => true, 'created_at' => now(), 'updated_at' => now()]);
            $this->changed($id);

            return $id;
        });
    }

    /** @param list<object> $rows
     * @return list<array<string, mixed>> */
    public function headers(Request $request, array $rows): array
    {
        return app(ConversationHeaders::class)->build($request, $rows, $this->inboxQuery($request, filterArchived: false)->where('c.purpose', 'SALES'), $this->activeProjectInquiries($request));
    }

    private function filterArchived(Request $request, Builder $query): void
    {
        if ($request->user()->account_type !== 'BUYER') {
            return;
        }
        $archived = fn ($q) => $q->selectRaw('1')->from('conversation_archives as a')->whereColumn('a.conversation_id', 'c.id')->where('a.user_id', $request->user()->id);
        $request->boolean('archived') ? $query->whereExists($archived) : $query->whereNotExists($archived);
    }

    private function salesFor(Request $request, object $source): Builder
    {
        return $this->inboxQuery($request, filterArchived: false)->where('c.purpose', 'SALES')
            ->where('c.buyer_profile_id', $source->buyer_profile_id)->where('c.vendor_organization_id', $source->vendor_organization_id);
    }

    /** @return array<string, mixed> */
    public function projectInquiries(Request $request, string $id): array
    {
        $source = $this->access->require($request->user(), $id);
        if ($source->purpose !== 'SALES') {
            throw new AuthenticationException('PERMISSION_DENIED', 'Project inquiries are available from sales conversations only.', 403);
        }
        $page = $this->activeProjectInquiries($request, $source)->orderByDesc('c.updated_at')->orderByDesc('c.id')->paginate(25);

        return ['items' => app(ConversationHeaders::class)->build($request, $page->items(), $this->inboxQuery($request, filterArchived: false)->where('c.purpose', 'SALES'), $this->activeProjectInquiries($request)), 'page' => $page->currentPage(), 'has_more' => $page->hasMorePages()];
    }

    /** Navigation covers open quotation workflows only; history remains directly authorized and readable. */
    private function activeProjectInquiries(Request $request, ?object $source = null): Builder
    {
        return ($source === null ? $this->inboxQuery($request, filterArchived: false)->where('c.purpose', 'SALES') : $this->salesFor($request, $source))->where('c.context_type', 'PROJECT_BASED')
            ->whereExists(fn (Builder $query) => $query->selectRaw('1')->from('work_packages as w')
                ->join('projects as p', 'p.id', '=', 'w.project_id')
                ->whereColumn('w.id', 'c.context_id')->whereColumn('p.buyer_profile_id', 'c.buyer_profile_id')
                ->where('p.status', 'ACTIVE')->whereNull('w.deleted_at')
                ->where(fn (Builder $scope) => $scope->where(fn (Builder $legacy) => $legacy->whereNull('w.selected_vendor_organization_id')->whereNull('w.selected_arrangement_id')->whereIn('w.status', ['ACTIVE', 'QUOTATION_INQUIRY']))
                    ->orWhereExists(fn (Builder $member) => $member->selectRaw('1')->from('project_arrangement_vendors as m')->join('project_procurement_arrangements as a', 'a.id', '=', 'm.arrangement_id')
                        ->whereColumn('m.conversation_id', 'c.id')->whereColumn('m.vendor_organization_id', 'c.vendor_organization_id')
                        ->whereRaw("a.work_package_version_id::text = c.locked_reference->>'version_id'")
                        ->where(fn (Builder $selected) => $selected->whereNull('w.selected_arrangement_id')->orWhereColumn('w.selected_arrangement_id', 'm.arrangement_id'))))
                ->whereRaw("w.current_version_id::text = c.locked_reference->>'version_id'"))
            ->whereExists(fn (Builder $query) => $query->selectRaw('1')->from('quotations as q')
                ->whereColumn('q.conversation_id', 'c.id')->whereNull('q.accepted_order_id')
                ->whereIn('q.state', ['DRAFT', ...QuotationService::OPEN, 'COUNTERED', 'STOCK_REVALIDATION_REQUIRED'])
                ->where(fn (Builder $deadline) => $deadline->whereNotIn('q.state', [...QuotationService::OPEN, 'COUNTERED'])
                    ->orWhere('q.response_due_at', '>', now())));
    }

    /**
     * @return array<string, mixed> */
    public function header(Request $request, object $c): array
    {
        return app(ConversationHeaders::class)->build($request, [$c], $this->inboxQuery($request, filterArchived: false)->where('c.purpose', 'SALES'), $this->activeProjectInquiries($request))[0];
    }

    public function canListFulfillment(Request $request, object $conversation): bool
    {
        return $request->user()->account_type === 'VENDOR' && $conversation->purpose === 'SALES'
            && in_array(($request->attributes->get('account_scope') ?? app(AccountAccess::class)->resolve($request->user()))['role'], ['OWNER', 'STORE_MANAGER'], true);
    }

    /** Existing threads for this inquiry's buyer/store pair; opening the list never creates a thread.
     * @return array<string, mixed> */
    public function fulfillmentConversations(Request $request, string $conversationId): array
    {
        $source = $this->access->require($request->user(), $conversationId);
        if (! $this->canListFulfillment($request, $source)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'Your role cannot list fulfillment conversations from this inquiry.', 403);
        }
        $states = FulfillmentThreadService::WRITABLE_STATES;
        $placeholders = implode(',', array_fill(0, count($states), '?'));
        $page = DB::table('conversations as c')->join('orders as o', 'o.id', '=', 'c.order_id')
            ->where('c.purpose', 'FULFILLMENT')->where('c.buyer_profile_id', $source->buyer_profile_id)
            ->where('c.vendor_organization_id', $source->vendor_organization_id)
            ->orderByRaw("CASE WHEN o.order_state IN ($placeholders) THEN 0 ELSE 1 END", $states)
            ->orderByDesc('c.updated_at')->orderByDesc('c.id')
            ->paginate(25, ['c.*', 'o.reference as order_reference', 'o.order_state', 'o.fulfillment_method']);

        return ['items' => array_map(function (object $thread) use ($request): array {
            $this->access->require($request->user(), (string) $thread->id);

            return ['conversation_id' => $thread->id, 'order_id' => $thread->order_id, 'order_reference' => $thread->order_reference,
                'order_state' => $thread->order_state, 'fulfillment_method' => $thread->fulfillment_method,
                'unread_count' => $this->unreadCount($request, (string) $thread->id), 'updated_at' => Carbon::parse($thread->updated_at)->toIso8601String()]
                + $this->writableFields($thread);
        }, $page->items()), 'page' => $page->currentPage(), 'has_more' => $page->hasMorePages()];
    }

    private function unreadCount(Request $request, string $conversationId): int
    {
        return self::unreadFor((int) $request->user()->id, $conversationId);
    }

    /** Messages from anyone else that this user has not read. */
    public static function unreadFor(int $userId, string $conversationId): int
    {
        return DB::table('messages as m')->where('m.conversation_id', $conversationId)->where('m.sender_user_id', '<>', $userId)
            ->whereNotExists(fn ($q) => $q->selectRaw('1')->from('message_read_receipts as r')->whereColumn('r.message_id', 'm.id')->where('r.user_id', $userId))->count();
    }

    /** @return array{read_only: bool, read_only_reason: ?string} */
    private function writableFields(object $c): array
    {
        $state = FulfillmentThreadService::writability($c);

        return ['read_only' => $state['read_only'], 'read_only_reason' => $state['reason']];
    }

    /** Public allowlist only: login email, private phone, IDs and verification documents never enter the projection.
     * @return array<string, mixed> */
    public function identity(User $user, object $c): array
    {
        $profile = DB::table('user_profiles')->where('user_id', $user->id)->first();

        return ['display_name' => $profile?->full_name ?: ($user->account_type === 'BUYER' ? 'Buyer' : 'Store team'), 'role' => $this->access->displayRole($user, $c),
            'avatar_path' => $user->profile_photo_key === null ? null : '/conversations/'.$c->id.'/avatars/'.$user->id];
    }

    /**
     * @return array<string, mixed> */
    public function messages(Request $request, string $id, ?Builder $authorizedScope = null): array
    {
        $c = $this->access->require($request->user(), $id);
        $query = DB::table('messages as m')
            ->leftJoin('user_profiles as sender_profile', 'sender_profile.user_id', '=', 'm.sender_user_id')
            ->when($authorizedScope === null, fn (Builder $q) => $q->where('m.conversation_id', $id), fn (Builder $q) => $q->whereIn('m.conversation_id', (clone $authorizedScope)->select('c.id')))
            ->select(['m.*', 'sender_profile.full_name as current_sender_name']);
        if (is_string($request->query('before'))) {
            $query->where('m.id', '<', $request->query('before'));
        }
        $rows = $query->orderByDesc('m.id')->limit(51)->get();
        $hasMore = $rows->count() > 50;
        $rows = $rows->take(50);

        $attachmentsByMessage = DB::table('message_attachments')->whereIn('message_id', $rows->pluck('id'))->get(['message_id', 'id', 'display_name', 'media_type', 'size_bytes', 'scan_state'])->groupBy('message_id');
        $readMessages = DB::table('message_read_receipts as r')->join('messages as m', 'm.id', '=', 'r.message_id')->whereIn('m.id', $rows->pluck('id'))
            ->whereColumn('r.user_id', '<>', 'm.sender_user_id')->pluck('m.id')->flip();
        $productIds = $rows->pluck('product_id')->filter()->unique()->all();
        $availableProducts = $productIds === [] ? [] : app(EligibleOfferQuery::class)->variants()->whereIn('v.id', $productIds)->pluck('v.id')->all();

        $botEnabled = DB::table('vendor_automated_responses')->where('vendor_organization_id', $c->vendor_organization_id)->where('enabled', true)->exists();
        $botState = DB::table('buyer_thread_automation_states')->where('buyer_profile_id', $c->buyer_profile_id)->where('vendor_organization_id', $c->vendor_organization_id)->first();
        $usedOptions = DB::table('conversation_automated_selections')->whereIn('welcome_message_id', $rows->pluck('id'))->get(['welcome_message_id', 'option_index'])->groupBy('welcome_message_id');
        $inquiryIds = $rows->pluck('work_package_inquiry_id')->filter()->unique()->all();
        $legacy = DB::table('conversations')->whereIn('id', $rows->pluck('conversation_id'))->where('context_type', 'PROJECT_BASED')->get()->keyBy('id');
        $firstLegacy = DB::table('messages')->whereIn('conversation_id', $legacy->keys())->where('kind', '<>', 'SYSTEM')->groupBy('conversation_id')->selectRaw('conversation_id, MIN(id::text) as first_id')->pluck('first_id', 'conversation_id');
        $inquiryIds = array_unique([...$inquiryIds, ...$legacy->keys()->all()]);
        $allowedInquiries = $this->buyerThreadScope($request, $c)->whereIn('c.id', $inquiryIds)->pluck('c.id')->flip();
        $quoteStates = DB::table('quotations')->whereIn('conversation_id', $inquiryIds)->selectRaw('DISTINCT ON (conversation_id) conversation_id, state, accepted_order_id')->orderBy('conversation_id')->orderByDesc('id')->get()->keyBy('conversation_id');
        $attachmentOrders = DB::table('orders')->whereIn('id', [...$rows->pluck('work_package_order_id')->filter()->all(), ...$quoteStates->pluck('accepted_order_id')->filter()->all()])->get()->keyBy('id');
        $packageView = app(WorkPackageAttachmentView::class);
        $orderTerms = $packageView->orderTerms($attachmentOrders->values()->all());
        $role = $request->attributes->get('account_scope')['role'] ?? $this->access->role($request->user());
        $salesRole = $request->user()->account_type === 'VENDOR' && in_array($request->attributes->get('account_scope')['role'] ?? $this->access->role($request->user()), ConversationAccess::SALES_ROLES, true);

        return ['items' => $rows->reverse()->map(function (object $m) use ($request, $attachmentsByMessage, $readMessages, $availableProducts, $botState, $botEnabled, $usedOptions, $legacy, $firstLegacy, $allowedInquiries, $quoteStates, $salesRole, $attachmentOrders, $role, $packageView, $orderTerms): array {
            $attachments = $attachmentsByMessage->get($m->id, collect())->map(function (object $attachment): object {
                unset($attachment->message_id);

                return $attachment;
            });
            $sender = json_decode($m->public_sender, true);
            // Resolve the original sender's current name without changing their recorded role or message history.
            if ($m->kind !== 'SYSTEM' && is_string($m->current_sender_name) && trim($m->current_sender_name) !== '') {
                $sender['display_name'] = $m->current_sender_name;
            }

            $automation = $m->automation === null ? null : json_decode($m->automation, true);
            $active = $automation !== null && $request->user()->account_type === 'BUYER' && $botEnabled
                && $botState?->active_welcome_message_id === $m->id && $botState->sequence_active;
            $used = $usedOptions->get($m->id, collect())->pluck('option_index')->map(static fn ($index): int => (int) $index)->all();
            $inquiry = $m->work_package_inquiry_id;
            $reference = $m->work_package_snapshot;
            if ($inquiry === null && $firstLegacy->get($m->conversation_id) === $m->id) {
                $inquiry = $m->conversation_id;
                $reference = $legacy->get($inquiry)?->locked_reference;
            }
            $order = $attachmentOrders->get($m->work_package_order_id ?? $quoteStates->get($inquiry)?->accepted_order_id);
            $package = $reference === null ? null : ['inquiry_id' => $inquiry, 'order_id' => $order?->id, 'order_lock_version' => $order === null ? null : (int) $order->lock_version,
                'reference' => $order === null ? $packageView->inquiry(json_decode($reference, true)) : $packageView->order(json_decode($reference, true), $orderTerms[$order->id]),
                'can_prepare_quotation' => $order === null ? ($salesRole && $allowedInquiries->has($inquiry) && $quoteStates->get($inquiry)?->state !== 'ACCEPTED')
                    : ($request->user()->account_type === 'VENDOR' && in_array($role, ['OWNER', 'STORE_MANAGER', 'STORE_STAFF'], true) && PendingOrderQuotationService::eligible($order))];

            return ['id' => $m->id, 'conversation_id' => $m->conversation_id, 'client_message_id' => $m->client_message_id, 'body' => $m->body, 'kind' => $m->kind, 'sender' => $sender,
                'work_package_attachment' => $package,
                'automated_reply' => $automation === null ? null : ['options' => array_map(static fn (array $option, int $index): array => ['index' => $index, 'label' => $option['label'], 'available' => $active && ! in_array($index, $used, true)], $automation['options'], array_keys($automation['options']))],
                'product' => app(ConversationProducts::class)->stored($m, $availableProducts),
                'sent_at' => Carbon::parse($m->sent_at)->toIso8601String(), 'mine' => (int) $m->sender_user_id === (int) $request->user()->id, 'attachments' => $attachments->all(),
                'read_by_recipient' => $readMessages->has($m->id)];
        })->values()->all(), 'has_more' => $hasMore, 'next_before' => $hasMore ? $rows->last()->id : null];
    }

    public function send(Request $request, string $id, string $body, string $clientId, ?string $productId = null): string
    {
        return DB::transaction(function () use ($request, $id, $body, $clientId, $productId): string {
            $c = $this->access->require($request->user(), $id, true);
            $old = DB::table('messages')->where('conversation_id', $id)->where('client_message_id', $clientId)->first();
            if ($old !== null) {
                if ((int) $old->sender_user_id !== (int) $request->user()->id || $old->body !== trim($body) || $old->product_id !== $productId || ! in_array($old->kind, ['TEXT', 'PRODUCT', 'TEXT_WITH_PRODUCT'], true)) {
                    throw new AuthenticationException('IDEMPOTENCY_CONFLICT', 'Use a new message identifier for changed text.', 409);
                }

                return (string) $old->id;
            }
            $this->requireCurrent($c);
            FulfillmentThreadService::requireWritable($c);

            $product = $productId === null ? null : app(ConversationProducts::class)->snapshot($c, $productId);

            return $this->append($c, $request->user(), trim($body), $product === null ? 'TEXT' : (trim($body) === '' ? 'PRODUCT' : 'TEXT_WITH_PRODUCT'), $clientId, $product);
        });
    }

    public function requireCurrent(object $conversation): void
    {
        if ($conversation->canonical_conversation_id !== null) {
            throw new AuthenticationException('CONVERSATION_MERGED', 'Open the current store conversation to send a new message.', 409, ['conversation_id' => $conversation->canonical_conversation_id]);
        }
    }

    /**
     * @param  array<string, mixed>|null  $product
     * @param  array<string, mixed>|null  $automation
     * @param  array<string, mixed>|null  $workPackage
     */
    public function append(object $c, User $actor, string $body, string $kind = 'SYSTEM', ?string $clientId = null, ?array $product = null, bool $triggerAutomation = true, ?array $automation = null, ?array $workPackage = null): string
    {
        $id = (string) Str::uuid7();
        $sender = $kind === 'SYSTEM' ? ['display_name' => 'MateryalPH', 'role' => 'SYSTEM', 'avatar_path' => null] : $this->identity($actor, $c);
        if ($automation !== null) {
            $sender['display_name'] = $automation['store_name'].' · Automated response';
        }
        DB::table('messages')->insert(['id' => $id, 'conversation_id' => $c->id, 'sender_user_id' => $actor->id, 'body' => $body, 'kind' => $kind,
            'product_id' => $product['product_id'] ?? null, 'product_snapshot' => $product === null ? null : json_encode($product, JSON_THROW_ON_ERROR),
            'client_message_id' => $clientId ?? (string) Str::uuid7(), 'public_sender' => json_encode($sender, JSON_THROW_ON_ERROR),
            'work_package_inquiry_id' => $workPackage['inquiry_id'] ?? null, 'work_package_snapshot' => $workPackage === null ? null : json_encode($workPackage['reference'], JSON_THROW_ON_ERROR),
            'work_package_order_id' => $workPackage['order_id'] ?? null,
            'automation' => $automation === null ? null : json_encode($automation, JSON_THROW_ON_ERROR), 'sent_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        if ($kind !== 'SYSTEM' && in_array($sender['role'], VendorTeamActivityQuery::ROLES, true)) {
            app(VendorTeamActivityBroadcast::class)->publish((string) $c->vendor_organization_id, $sender['role']);
        }
        DB::table('conversations')->where('id', $c->id)->update(['updated_at' => now()]);
        // New activity brings an archived thread back to the inbox so a reply is never missed.
        $archiveThreads = $c->purpose === 'SALES' ? DB::table('conversations')->where('buyer_profile_id', $c->buyer_profile_id)->where('vendor_organization_id', $c->vendor_organization_id)->where('purpose', 'SALES')->select('id') : DB::table('conversations')->where('id', $c->id)->select('id');
        DB::table('conversation_archives')->whereIn('conversation_id', $archiveThreads)->delete();
        if (($kind !== 'SYSTEM' || $automation !== null) && $actor->account_type === 'VENDOR') {
            $buyerId = DB::table('buyer_profiles')->where('id', $c->buyer_profile_id)->value('user_id');
            $storeName = DB::table('store_profiles')->where('vendor_organization_id', $c->vendor_organization_id)->value('public_store_name') ?: 'a Vendor';
            if ($buyerId !== null && (int) $buyerId !== (int) $actor->id) {
                $title = PushNotification::preview((string) $sender['display_name'], 100).' · '.PushNotification::preview((string) $storeName, 150);
                $preview = match ($kind) {
                    'ATTACHMENT' => 'Sent an attachment',
                    'PRODUCT' => 'Sent a product: '.($product['name'] ?? 'Product'),
                    default => $body,
                };
                app(NotificationService::class)->record((int) $buyerId, 'MESSAGES', $title,
                    PushNotification::preview($preview), 'CONVERSATION', (string) $c->id,
                    'conversation-message:'.$id, (string) $c->vendor_organization_id, $id);
            }
        }
        if ($kind !== 'SYSTEM' && $triggerAutomation) {
            app(AutomatedResponseService::class)->humanMessage($c, $actor);
        }
        $this->changed((string) $c->id);

        return $id;
    }

    /** Idempotent personal archive. History, quotations and orders are never changed or deleted. */
    public function archive(Request $request, string $id, bool $archived): void
    {
        DB::transaction(function () use ($request, $id, $archived): void {
            $c = $this->access->require($request->user(), $id);
            if ($c->purpose !== 'SALES') {
                throw new AuthenticationException('CONVERSATION_NOT_ARCHIVABLE', 'Fulfillment messages stay with their order.', 409);
            }
            $threads = DB::table('conversations')->where('buyer_profile_id', $c->buyer_profile_id)->where('vendor_organization_id', $c->vendor_organization_id)->where('purpose', 'SALES')->pluck('id')->all();
            if ($archived) {
                foreach ($threads as $thread) {
                    DB::table('conversation_archives')->insertOrIgnore(['id' => (string) Str::uuid7(), 'conversation_id' => $thread, 'user_id' => $request->user()->id,
                        'archived_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
                }
            } else {
                DB::table('conversation_archives')->whereIn('conversation_id', $threads)->where('user_id', $request->user()->id)->delete();
            }
            $this->audit->account($request, $archived ? 'CONVERSATION_ARCHIVED' : 'CONVERSATION_RESTORED', 'CONVERSATION', $id);
            $this->changed($id);
        });
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
            $noticesRead = DB::table('notifications')->where('user_id', $request->user()->id)->where('category', 'MESSAGES')
                ->where('resource_type', 'CONVERSATION')->where('resource_id', $id)->where('resume_key', '<=', $through)->whereNull('read_at')
                ->update(['read_at' => now(), 'updated_at' => now()]);
            if ($noticesRead > 0) {
                app(NotificationBroadcast::class)->publish($request->user());
            }
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
