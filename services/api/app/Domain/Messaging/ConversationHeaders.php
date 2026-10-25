<?php

declare(strict_types=1);

namespace App\Domain\Messaging;

use App\Models\User;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;

/** Request-local, batched public projection. The caller supplies currently authorized conversation scopes. */
final class ConversationHeaders
{
    /** @param list<object> $rows
     * @return list<array<string, mixed>> */
    public function build(Request $request, array $rows, Builder $sales, Builder $projects, bool $grouped = false): array
    {
        if ($rows === []) {
            return [];
        }
        $viewer = $request->user();
        $ids = array_column($rows, 'id');
        $orgIds = array_unique(array_column($rows, 'vendor_organization_id'));
        $buyerIds = array_unique(array_column($rows, 'buyer_profile_id'));
        $buyers = DB::table('buyer_profiles')->whereIn('id', $buyerIds)->pluck('user_id', 'id');
        $users = User::query()->leftJoin('user_profiles as p', 'p.user_id', '=', 'users.id')
            ->whereIn('users.id', [...$buyers->values()->all(), ...array_column($rows, 'handler_user_id')])->get(['users.*', 'p.full_name'])->keyBy('id');
        $stores = DB::table('store_profiles as s')->join('vendor_organizations as o', 'o.id', '=', 's.vendor_organization_id')
            ->whereIn('o.id', $orgIds)->get(['s.*', 'o.store_verification_status', 'o.account_status as organization_status'])->keyBy('vendor_organization_id');
        $logos = DB::table('files as f')->join('store_media as m', 'm.file_id', '=', 'f.id')
            ->whereIn('f.id', $stores->pluck('logo_file_id')->filter())->where('f.visibility', 'PUBLIC')->where('f.scan_state', 'CLEAN')->where('m.status', 'READY')->pluck('f.metadata', 'f.id');
        $members = DB::table('vendor_memberships')->whereIn('vendor_organization_id', $orgIds)
            ->whereIn('user_id', [...array_column($rows, 'handler_user_id'), $viewer->id])->get()->keyBy(fn ($m) => $m->vendor_organization_id.'|'.$m->user_id);
        $participants = DB::table('conversation_participants')->whereIn('conversation_id', $ids)->whereNull('revoked_at')->get()
            ->keyBy(fn ($p) => $p->conversation_id.'|'.$p->user_id.'|'.$p->participant_role);
        $assignments = DB::table('conversation_assignments')->whereIn('conversation_id', $ids)->whereNull('ended_at')->pluck('id', 'conversation_id');
        $fulfillmentAssignments = DB::table('order_fulfillment_assignments')->whereIn('order_id', array_column($rows, 'order_id'))->whereNull('ended_at')->get(['id', 'order_id', 'user_id'])->keyBy('order_id');
        $orders = DB::table('orders')->whereIn('id', array_column($rows, 'order_id'))->get(['id', 'reference', 'order_state'])->keyBy('id');
        $related = $this->pairs($sales, $rows)->get(['c.id', 'c.buyer_profile_id', 'c.vendor_organization_id', 'c.context_type']);
        $projectIds = $this->pairs($projects, $rows)->pluck('c.id')->flip();
        $threadIds = array_values(array_unique([...$ids, ...$related->pluck('id')->all()]));
        $latest = DB::table('messages')->whereIn('conversation_id', $threadIds)->selectRaw('DISTINCT ON (conversation_id) *')->orderBy('conversation_id')->orderByDesc('id')->get()->keyBy('conversation_id');
        $latestProducts = DB::table('messages')->whereIn('conversation_id', $ids)->whereNotNull('product_id')
            ->selectRaw('DISTINCT ON (conversation_id) conversation_id, product_id')->orderBy('conversation_id')->orderByDesc('id')->pluck('product_id', 'conversation_id');
        $unread = $this->unread($viewer)->whereIn('m.conversation_id', $threadIds)->groupBy('m.conversation_id')->selectRaw('m.conversation_id, count(*) as total')->pluck('total', 'conversation_id');
        $supervisor = $viewer->account_type === 'VENDOR' && in_array($request->attributes->get('account_scope')['role'] ?? null, ['OWNER', 'STORE_MANAGER'], true);
        $fulfillmentUnread = $supervisor ? $this->pairs($this->unread($viewer)->join('conversations as c', 'c.id', '=', 'm.conversation_id')->where('c.purpose', 'FULFILLMENT'), $rows)
            ->groupBy('c.buyer_profile_id', 'c.vendor_organization_id')->selectRaw('c.buyer_profile_id, c.vendor_organization_id, count(*) as total')->get()->keyBy(fn ($c) => $this->pair($c)) : collect();
        $legacyPage = max(1, $request->integer('legacy_page', 1));
        $legacyQuery = DB::table('conversations')->whereIn('canonical_conversation_id', $ids)
            ->selectRaw('id, canonical_conversation_id, ROW_NUMBER() OVER (PARTITION BY canonical_conversation_id ORDER BY id) as position');
        $legacy = DB::query()->fromSub($legacyQuery, 'legacy')->whereBetween('position', [($legacyPage - 1) * 25 + 1, $legacyPage * 25 + 1])->orderBy('position')->get()->groupBy('canonical_conversation_id');
        $pairs = $related->groupBy(fn ($c) => $this->pair($c));

        return array_map(function (object $c) use ($viewer, $buyers, $users, $stores, $logos, $members, $participants, $assignments, $fulfillmentAssignments, $orders, $latest, $latestProducts, $unread, $supervisor, $fulfillmentUnread, $legacyPage, $legacy, $pairs, $projectIds, $grouped): array {
            $store = $stores->get($c->vendor_organization_id);
            $logo = $logos->get($store?->logo_file_id);
            $logoData = is_string($logo) ? json_decode($logo, true) : [];
            $buyer = $users->get($buyers->get($c->buyer_profile_id));
            $handler = $users->get($c->handler_user_id);
            $member = $members->get($c->vendor_organization_id.'|'.$c->handler_user_id);
            $handlerAllowed = $handler !== null && $member !== null && $store !== null && $handler->account_status === 'ACTIVE' && $handler->account_type === 'VENDOR' && $store->organization_status === 'ACTIVE'
                && $member->status === 'ACTIVE' && $member->deleted_at === null
                && (in_array($member->role, ['OWNER', 'STORE_MANAGER'], true)
                    || ($c->purpose === 'FULFILLMENT' ? ($member->role === 'FULFILLMENT' && (int) $fulfillmentAssignments->get($c->order_id)?->user_id === (int) $handler->id)
                        : (in_array($member->role, ConversationAccess::SALES_ROLES, true) && $participants->has($c->id.'|'.$handler->id.'|'.$member->role))));
            $siblings = $pairs->get($this->pair($c), collect());
            $activeProjects = $siblings->filter(fn ($s) => $projectIds->has($s->id));
            $last = $latest->get($c->id);
            $count = (int) $unread->get($c->id, 0);
            if ($grouped && $c->purpose === 'SALES') {
                $count = 0;
                foreach ($siblings as $sibling) {
                    $message = $latest->get($sibling->id);
                    if ($message !== null && ($last === null || strcmp($message->id, $last->id) > 0)) {
                        $last = $message;
                    }
                    $count += (int) $unread->get($sibling->id, 0);
                }
            }
            $product = $last?->product_snapshot === null ? null : json_decode($last->product_snapshot, true);
            $legacyRows = $legacy->get($c->id, collect());
            $order = $orders->get($c->order_id);
            $readOnly = $c->purpose === 'FULFILLMENT' && ! in_array($order?->order_state, FulfillmentThreadService::WRITABLE_STATES, true);
            $reference = json_decode((string) $c->locked_reference, true);

            return ['id' => $c->id, 'purpose' => $c->purpose, 'context_type' => $c->context_type, 'order_id' => $c->order_id, 'lock_version' => (int) $c->lock_version,
                'buyer' => $buyer === null ? null : $this->identity($buyer, $c, 'BUYER'),
                'last_message_preview' => $product === null ? ($last->body ?? '') : 'Sent a product: '.$product['name'],
                'latest_product_id' => $latestProducts->get($c->id), 'canonical_conversation_id' => $c->canonical_conversation_id,
                'legacy_conversation_ids' => $legacyRows->take(25)->pluck('id')->all(), 'legacy_has_more' => $legacyRows->count() > 25, 'legacy_page' => $legacyPage,
                'store' => ['id' => $c->vendor_organization_id, 'name' => $store->public_store_name ?? 'Store', 'logo_url' => $logoData['public_url'] ?? null, 'verified' => $store?->store_verification_status === 'APPROVED'],
                'handler' => $handlerAllowed ? $this->identity($handler, $c, $member->role) : null, 'unread_count' => $count,
                'channel' => app(ConversationAccess::class)->channelWithEpoch($viewer, $c, $members->get($c->vendor_organization_id.'|'.$viewer->id), $c->purpose === 'FULFILLMENT' ? $fulfillmentAssignments->get($c->order_id)?->id : $assignments->get($c->id)),
                'locked_reference' => (object) $reference, 'updated_at' => Carbon::parse($grouped ? $c->inbox_updated_at : $c->updated_at)->toIso8601String(),
                'can_transfer' => $viewer->account_type === 'VENDOR' && $c->purpose === 'SALES', 'can_list_fulfillment_conversations' => $supervisor && $c->purpose === 'SALES',
                'main_conversation_id' => $c->purpose === 'SALES' ? $siblings->firstWhere('context_type', 'ITEM_BASED')?->id : null,
                'project_inquiry_count' => $c->purpose === 'SALES' ? $activeProjects->count() : 0,
                'project_unread_count' => $c->purpose === 'SALES' ? $activeProjects->sum(fn ($s) => (int) $unread->get($s->id, 0)) : 0,
                'inquiry_label' => $c->context_type === 'PROJECT_BASED' ? ($reference['work_package']['name'] ?? 'Project inquiry') : 'Inquiry',
                'fulfillment_unread_count' => $supervisor && $c->purpose === 'SALES' ? (int) ($fulfillmentUnread->get($this->pair($c))->total ?? 0) : 0,
                'fulfillment_entry_enabled' => $c->purpose === 'FULFILLMENT', 'order_reference' => $c->purpose === 'FULFILLMENT' ? $order?->reference : null,
                'read_only' => $readOnly, 'read_only_reason' => ! $readOnly ? null : match ($order?->order_state) {
                    'COMPLETED' => 'ORDER_COMPLETED', 'CANCELLED' => 'ORDER_CANCELLED', default => 'ORDER_NOT_IN_FULFILLMENT'
                }];
        }, $rows);
    }

    /** @param list<object> $rows */
    private function pairs(Builder $query, array $rows): Builder
    {
        return $query->where(function (Builder $query) use ($rows): void {
            foreach ($rows as $row) {
                $query->orWhere(fn (Builder $q) => $q->where('c.buyer_profile_id', $row->buyer_profile_id)->where('c.vendor_organization_id', $row->vendor_organization_id));
            }
        });
    }

    private function pair(object $row): string
    {
        return $row->buyer_profile_id.'|'.$row->vendor_organization_id;
    }

    private function unread(User $viewer): Builder
    {
        return DB::table('messages as m')->where('m.sender_user_id', '<>', $viewer->id)
            ->whereNotExists(fn ($q) => $q->selectRaw('1')->from('message_read_receipts as r')->whereColumn('r.message_id', 'm.id')->where('r.user_id', $viewer->id));
    }

    /** @return array<string, mixed> */
    private function identity(User $user, object $c, string $role): array
    {
        return ['display_name' => $user->getAttribute('full_name') ?: ($role === 'BUYER' ? 'Buyer' : 'Store team'), 'role' => $role,
            'avatar_path' => $user->profile_photo_key === null ? null : '/conversations/'.$c->id.'/avatars/'.$user->id];
    }
}
