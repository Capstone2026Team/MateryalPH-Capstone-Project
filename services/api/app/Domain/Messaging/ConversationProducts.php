<?php

declare(strict_types=1);

namespace App\Domain\Messaging;

use App\Domain\Catalog\EligibleOfferQuery;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Procurement\ListingPublicFacts;
use Illuminate\Http\Request;

final class ConversationProducts
{
    /** @return array<string, mixed> */
    public function page(Request $request, string $id): array
    {
        $c = app(ConversationAccess::class)->require($request->user(), $id);
        app(ConversationService::class)->requireCurrent($c);
        $query = app(EligibleOfferQuery::class)->variants([$c->vendor_organization_id]);
        if ($request->filled('q')) {
            $query->where('l.display_name', 'ilike', '%'.$request->string('q')->toString().'%');
        }
        if ($request->filled('product_id')) {
            $query->where('v.id', $request->input('product_id'));
        }
        $page = $query->orderBy('l.display_name')->orderBy('v.id')->paginate(25, ['v.id', 'v.label', 'l.id as listing_id', 'l.display_name', 'pv.amount_centavos']);

        return ['items' => array_map(fn (object $row): array => $this->card($row), $page->items()), 'page' => $page->currentPage(), 'has_more' => $page->hasMorePages()];
    }

    /** @return array<string, mixed> */
    public function snapshot(object $conversation, string $id): array
    {
        if ($conversation->purpose !== 'SALES') {
            throw new AuthenticationException('PRODUCT_NOT_PERMITTED', 'Product inquiries belong in sales messages.', 422);
        }
        $row = app(EligibleOfferQuery::class)->variants([$conversation->vendor_organization_id])->where('v.id', $id)
            ->first(['v.id', 'v.label', 'l.id as listing_id', 'l.display_name', 'pv.amount_centavos']);
        if ($row === null) {
            throw new AuthenticationException('PRODUCT_UNAVAILABLE', 'Choose an available product from this store.', 422);
        }

        return $this->card($row);
    }

    /** @return array<string, mixed>|null */
    public function stored(object $message): ?array
    {
        if ($message->product_snapshot === null) {
            return null;
        }
        $card = json_decode($message->product_snapshot, true, flags: JSON_THROW_ON_ERROR);
        $card['available'] = app(EligibleOfferQuery::class)->variants()->where('v.id', $message->product_id)->exists();

        return $card;
    }

    /** @return array<string, mixed> */
    private function card(object $row): array
    {
        $images = app(ListingPublicFacts::class)->images([$row->listing_id]);

        return ['product_id' => $row->id, 'listing_id' => $row->listing_id, 'name' => $row->display_name.($row->label ? ' · '.$row->label : ''),
            'price_centavos' => (int) $row->amount_centavos, 'image_url' => $images[$row->listing_id][0]['url'] ?? null, 'available' => true];
    }
}
