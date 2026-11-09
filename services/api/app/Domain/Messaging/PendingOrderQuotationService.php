<?php

declare(strict_types=1);

namespace App\Domain\Messaging;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderAccess;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class PendingOrderQuotationService
{
    public static function eligible(?object $order): bool
    {
        return $order !== null && $order->order_state === 'AWAITING_VENDOR_CONFIRMATION' && $order->accepted_at === null
            && $order->accepted_snapshot_version === null && $order->payment_state === 'NOT_REQUIRED';
    }

    public function open(Request $request, string $orderId, int $version): string
    {
        $access = app(OrderAccess::class);
        $scope = $access->vendorScope($request);
        $source = $access->vendorOrder($scope, $orderId);
        if (! in_array($scope['role'], ['OWNER', 'STORE_MANAGER', 'STORE_STAFF'], true)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'Your role cannot publish quotations for this order.', 403);
        }
        $keys = app(CatalogAccess::class);
        $key = $keys->requireIdempotencyKey($request);

        return DB::transaction(function () use ($request, $source, $version, $keys, $key): string {
            $package = $source->work_package_id === null ? null : DB::table('work_packages')->where('id', $source->work_package_id)->lockForUpdate()->first();
            DB::table('vendor_organizations')->where('id', $source->vendor_organization_id)->lockForUpdate()->first();
            $order = DB::table('orders')->where('id', $source->id)->lockForUpdate()->first();
            $existing = DB::table('quotations')->where('replaces_order_id', $order->id)->orderByDesc('id')->first();
            if ($existing !== null) {
                app(ConversationAccess::class)->require($request->user(), (string) $existing->conversation_id);
            }
            if ($keys->replayed($request, 'PENDING_ORDER_QUOTATION', $key, $order->id) && $existing !== null) {
                return (string) $existing->conversation_id;
            }
            if (! self::eligible($order) || (int) $order->lock_version !== $version || DB::table('payments')->where('order_id', $order->id)->exists()) {
                throw new AuthenticationException('ORDER_QUOTATION_UNAVAILABLE', 'Only a pending, unconfirmed order without payments can be replaced by a quotation.', 409);
            }
            if ($existing !== null) {
                $keys->claim($request, 'PENDING_ORDER_QUOTATION', $key, $order->id, 200);

                return (string) $existing->conversation_id;
            }
            $messages = app(ConversationService::class);
            $lines = DB::table('order_lines')->where('order_id', $order->id)->orderBy('line_number')->get()->map(static function (object $line): array {
                $snapshot = json_decode($line->snapshot, true);

                return ['variant_id' => $line->listing_variant_id, 'quantity' => $line->quantity, 'unit_price_centavos' => (int) $line->unit_price_centavos,
                    'description' => $snapshot['display_name'] ?? $snapshot['name'] ?? 'Material', 'specifications' => $snapshot['specifications'] ?? []];
            })->all();
            $draft = ['lines' => $lines, 'fulfillment_method' => $order->fulfillment_method, 'payment_method' => $order->payment_method, 'fulfillment_date' => null];
            if ($package === null) {
                $conversation = $messages->itemConversation($request, (string) $order->buyer_profile_id, (string) $order->vendor_organization_id);
                $current = DB::table('quotations')->where('conversation_id', $conversation)->orderByDesc('id')->first();
                if ($current !== null && $current->state !== 'ACCEPTED') {
                    throw new AuthenticationException('QUOTATION_STILL_OPEN', 'Finish the current store quotation before preparing an order replacement.', 409);
                }
                $reference = json_decode((string) DB::table('conversations')->where('id', $conversation)->value('locked_reference'), true);
                $reference['destination'] = json_decode($order->destination, true);
                DB::table('conversations')->where('id', $conversation)->update(['locked_reference' => json_encode($reference, JSON_THROW_ON_ERROR), 'lock_version' => DB::raw('lock_version + 1'), 'updated_at' => now()]);
            } else {
                $member = $order->project_arrangement_vendor_id === null ? null : DB::table('project_arrangement_vendors')->where('id', $order->project_arrangement_vendor_id)->first();
                $conversation = $member?->conversation_id;
                if ($conversation === null) {
                    $conversation = DB::table('conversations')->where('purpose', 'SALES')->where('context_type', 'PROJECT_BASED')->where('context_id', $package->id)
                        ->where('vendor_organization_id', $order->vendor_organization_id)->whereRaw("locked_reference->>'version_id' = ?", [$order->work_package_version_id])->orderByDesc('id')->value('id');
                }
                if ($conversation === null) {
                    $v = DB::table('work_package_versions')->where('id', $order->work_package_version_id)->first();
                    $content = json_decode($v->content, true);
                    $reference = ['version_id' => $v->id, 'version' => (int) $v->version, 'content_hash' => $v->content_hash,
                        'work_package' => $content, 'working_duplicate' => $draft, 'destination' => json_decode($order->destination, true), 'lines' => $content['lines']];
                    if ($member !== null) {
                        $reference += ['arrangement_id' => $order->project_arrangement_id, 'arrangement_vendor_id' => $member->id];
                        $reference['vendor_allocations'] = DB::table('project_arrangement_items')->where('arrangement_vendor_id', $member->id)->whereNull('removed_at')->get()->map(static function (object $item): array {
                            $snapshot = json_decode($item->snapshot, true);

                            return ['line_id' => $item->work_package_line_id, 'variant_id' => $item->listing_variant_id, 'quantity' => $item->quantity,
                                'material_id' => $snapshot['material_id'], 'unit_id' => $snapshot['unit_id']];
                        })->all();
                    }
                    $conversation = (string) Str::uuid7();
                    // Vendor initiation uses the already authorized order's Buyer, not the Vendor's Buyer profile.
                    $messages->createProjectForBuyer($request, $conversation, $order->vendor_organization_id, $package->id, $reference, $order->buyer_profile_id);
                    if ($member !== null) {
                        DB::table('project_arrangement_vendors')->where('id', $member->id)->update(['conversation_id' => $conversation, 'updated_at' => now()]);
                    }
                }
            }
            app(ConversationAccess::class)->require($request->user(), (string) $conversation, true);
            $current = DB::table('quotations')->where('conversation_id', $conversation)->orderByDesc('id')->lockForUpdate()->first();
            $values = ['replaces_order_id' => $order->id, 'draft' => json_encode($draft, JSON_THROW_ON_ERROR), 'updated_at' => now()];
            if ($current !== null && $current->state !== 'ACCEPTED') {
                if (! in_array($current->state, ['DRAFT', 'EXPIRED', 'WITHDRAWN', 'REJECTED'], true)) {
                    throw new AuthenticationException('QUOTATION_STILL_OPEN', 'Withdraw or finish the published quotation before replacing the pending order.', 409);
                }
                DB::table('quotations')->where('id', $current->id)->update($values + ['state' => 'DRAFT', 'lock_version' => $current->lock_version + 1]);
            } else {
                DB::table('quotations')->insert($values + ['id' => (string) Str::uuid7(), 'conversation_id' => $conversation,
                    'buyer_profile_id' => $order->buyer_profile_id, 'vendor_organization_id' => $order->vendor_organization_id, 'procurement_type' => $order->procurement_type,
                    'work_package_id' => $order->work_package_id, 'state' => 'DRAFT', 'created_at' => now()]);
            }
            $keys->claim($request, 'PENDING_ORDER_QUOTATION', $key, $order->id, 200);
            app(AuditRecorder::class)->account($request, 'PENDING_ORDER_QUOTATION_OPENED', 'ORDER', (string) $order->id,
                after: ['conversation_id' => $conversation]);
            $messages->changed($conversation);

            return $conversation;
        });
    }
}
