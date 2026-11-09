<?php

declare(strict_types=1);

namespace App\Domain\Messaging;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/** A combined read projection. Commercial context, messages, files and receipts retain their original IDs. */
final class VendorBuyerThread
{
    public function __construct(private readonly ConversationService $conversations, private readonly ConversationAccess $access) {}

    /** @return array<string, mixed> */
    public function show(Request $request, string $id): array
    {
        $source = $this->access->require($request->user(), $id);
        $scope = $this->conversations->buyerThreadScope($request, $source);
        // Replies use the existing normal store chat automatically. Never ask the user to select a chat subject.
        $reply = (clone $scope)->where('c.purpose', 'SALES')->whereNull('c.canonical_conversation_id')
            ->orderByRaw("CASE WHEN c.context_type = 'ITEM_BASED' THEN 0 ELSE 1 END")->orderByDesc('c.updated_at')->orderByDesc('c.id')->first(['c.*']);
        $source = $reply ?? $source;
        $id = $source->id;
        $messages = $this->conversations->messages($request, $id, $scope);
        $quotations = app(QuotationService::class)->show($request, $id, $scope);
        // Only the contexts referenced by this bounded response are attached, not an unbounded Buyer history.
        $ids = array_unique([$id, ...array_column($messages['items'], 'conversation_id'), ...array_column($quotations['versions'], 'conversation_id')]);
        $contexts = $this->conversations->headers($request, (clone $scope)->whereIn('c.id', $ids)->get(['c.*'])->all());
        $header = $this->conversations->header($request, $source);
        $header['needs_human_response'] = (clone $scope)->where('c.needs_human_response', true)->exists();
        $header['unread_count'] = DB::table('messages as m')->whereIn('m.conversation_id', (clone $scope)->select('c.id'))->where('m.sender_user_id', '<>', $request->user()->id)
            ->whereNotExists(fn ($q) => $q->selectRaw('1')->from('message_read_receipts as r')->whereColumn('r.message_id', 'm.id')->where('r.user_id', $request->user()->id))->count();

        $authority = (clone $scope)->selectRaw("md5(string_agg(c.id::text, ',' ORDER BY c.id)) as epoch")->first();

        return ['conversation' => $header, 'messages' => $messages, 'quotations' => $quotations, 'thread_contexts' => $contexts, 'thread_authority' => $authority?->epoch,
            'site_inspections' => app(SiteInspectionService::class)->forConversation($request->user(), $source)];
    }

    /** @return array<string, mixed> */
    public function contexts(Request $request, string $id): array
    {
        $source = $this->access->require($request->user(), $id);
        $page = $this->conversations->buyerThreadScope($request, $source, includeHistory: false)->orderByDesc('c.updated_at')->orderByDesc('c.id')->paginate(25, ['c.*']);

        return ['items' => $this->conversations->headers($request, $page->items()), 'page' => $page->currentPage(), 'has_more' => $page->hasMorePages()];
    }
}
