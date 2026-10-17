<?php

declare(strict_types=1);

namespace App\Domain\Orders;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Procurement\CartService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/**
 * Buy Again from a closed Item-Based order (approved by the project owner on 2026-10-10). The order's lines go back
 * into the Buyer's cart at today's prices; the old order's prices, discounts and delivery fee are never reused, and
 * nothing is ordered or reserved until the Buyer checks out again.
 */
final class BuyAgainService
{
    public function __construct(private readonly OrderAccess $access, private readonly CartService $carts) {}

    /** @return array{cart: array<string, mixed>, added: list<array<string, string>>, skipped: list<array<string, string>>, replayed: bool} */
    public function run(Request $request, string $orderId): array
    {
        $order = $this->access->buyerOrder($request, $orderId);
        if ($order->procurement_type !== 'ITEM_BASED' || ! OrderStates::isClosed((string) $order->order_state)) {
            throw new AuthenticationException('BUY_AGAIN_UNAVAILABLE', 'Buy Again is available for completed or cancelled item orders.', 409);
        }
        $lines = [];
        foreach (DB::table('order_lines')->where('order_id', $order->id)->where('quantity', '>', 0)->orderBy('line_number')->get(['listing_variant_id', 'quantity', 'snapshot']) as $line) {
            $snapshot = json_decode((string) $line->snapshot, true) ?: [];
            $name = (string) ($snapshot['display_name'] ?? 'Item');
            $lines[] = ['variant_id' => (string) $line->listing_variant_id, 'quantity' => (string) $line->quantity,
                'display_name' => isset($snapshot['variant_label']) && $snapshot['variant_label'] !== '' ? $name.' · '.$snapshot['variant_label'] : $name];
        }

        return $this->carts->addAgain($request, (string) $order->id, $lines, (string) $order->fulfillment_method);
    }
}
