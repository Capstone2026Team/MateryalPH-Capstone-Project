<?php

declare(strict_types=1);

namespace App\Domain\Messaging;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderAccess;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/** Shares a locked Work Package as a message in the normal store chat, not as another user-facing thread. */
final class WorkPackageChatAttachment
{
    public function share(Request $request, string $inquiryId, ?string $key = null): string
    {
        $access = app(ConversationAccess::class);
        $source = $access->require($request->user(), $inquiryId);
        if ($request->user()->account_type !== 'BUYER' || $source->purpose !== 'SALES' || $source->context_type !== 'PROJECT_BASED') {
            throw new AuthenticationException('PERMISSION_DENIED', 'Only the Buyer may attach this Work Package to the store chat.', 403);
        }

        return DB::transaction(function () use ($request, $source, $key, $access): string {
            DB::table('buyer_profiles')->where('id', $source->buyer_profile_id)->lockForUpdate()->first();
            $source = $access->require($request->user(), $source->id, true);
            $messages = app(ConversationService::class);
            $main = $messages->itemConversation($request, $source->buyer_profile_id, $source->vendor_organization_id, existingRelationship: true);
            $keys = app(CatalogAccess::class);
            if ($key !== null && $keys->replayed($request, 'WORK_PACKAGE_CHAT_ATTACHMENT', $key, $source->id)) {
                return $main;
            }
            // Arrangement Message buttons may not carry an idempotency header. Reopening still reuses the same card.
            if ($key === null && DB::table('messages')->where('conversation_id', $main)->where('work_package_inquiry_id', $source->id)->exists()) {
                return $main;
            }
            $reference = json_decode($source->locked_reference, true);
            $target = $access->require($request->user(), $main, true);
            $messages->append($target, $request->user(), 'Work Package: '.($reference['work_package']['name'] ?? 'Materials'), 'WORK_PACKAGE',
                workPackage: ['inquiry_id' => $source->id, 'reference' => $reference]);
            if ($key !== null) {
                $keys->claim($request, 'WORK_PACKAGE_CHAT_ATTACHMENT', $key, $source->id, 201);
            }

            return $main;
        });
    }

    public function shareOrder(Request $request, string $orderId, string $key): string
    {
        $orders = app(OrderAccess::class);
        $order = $orders->buyerOrder($request, $orderId);

        return DB::transaction(function () use ($request, $orders, $order, $key): string {
            DB::table('buyer_profiles')->where('id', $order->buyer_profile_id)->lockForUpdate()->first();
            $order = $orders->buyerOrder($request, $order->id);
            $messages = app(ConversationService::class);
            $main = $messages->itemConversation($request, $order->buyer_profile_id, $order->vendor_organization_id, existingRelationship: true);
            $keys = app(CatalogAccess::class);
            if ($keys->replayed($request, 'ORDER_WORK_PACKAGE_CHAT_ATTACHMENT', $key, $order->id)) {
                return $main;
            }
            if ($order->work_package_version_id !== null) {
                $version = DB::table('work_package_versions')->where('id', $order->work_package_version_id)->first();
                $reference = ['version_id' => $version->id, 'version' => (int) $version->version, 'content_hash' => $version->content_hash, 'work_package' => json_decode($version->content, true)];
                $target = app(ConversationAccess::class)->require($request->user(), $main, true);
                $messages->append($target, $request->user(), 'Work Package: '.($reference['work_package']['name'] ?? 'Materials'), 'WORK_PACKAGE',
                    workPackage: ['order_id' => $order->id, 'reference' => $reference]);
            }
            $keys->claim($request, 'ORDER_WORK_PACKAGE_CHAT_ATTACHMENT', $key, $order->id, 201);

            return $main;
        });
    }
}
