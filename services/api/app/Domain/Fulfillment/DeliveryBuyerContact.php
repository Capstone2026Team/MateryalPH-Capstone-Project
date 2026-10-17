<?php

declare(strict_types=1);

namespace App\Domain\Fulfillment;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderAccess;
use App\Domain\Orders\OrderStates;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Symfony\Component\HttpFoundation\StreamedResponse;

/** Buyer contact and sanitized profile media for the current delivery obligation only. */
final class DeliveryBuyerContact
{
    public function __construct(private readonly OrderAccess $access) {}

    /**
     * @param  array{organization_id: string, role: string, permissions: list<string>}  $scope
     * @return array{mobile_e164: ?string, avatar_path: ?string}
     */
    public function present(Request $request, object $order, array $scope): array
    {
        $hidden = ['mobile_e164' => null, 'avatar_path' => null];
        if (! $this->available($order, $scope)) {
            return $hidden;
        }
        $order = $this->authorizedOrder($request, (string) $order->id);
        $buyer = $this->buyer($order);

        return ['mobile_e164' => $buyer?->mobile_e164,
            'avatar_path' => $buyer?->profile_photo_key === null ? null : '/vendor/orders/'.$order->id.'/fulfillment/buyer-photo?version='.$buyer->lock_version];
    }

    public function photo(Request $request, string $orderId, ?int $version): StreamedResponse
    {
        $order = $this->authorizedOrder($request, $orderId);
        $buyer = $this->buyer($order);
        if ($buyer?->profile_photo_key === null || ($version !== null && $version !== (int) $buyer->lock_version)) {
            throw new AuthenticationException('FILE_NOT_FOUND', 'This Buyer photo is unavailable.', 404);
        }
        $bytes = Storage::disk((string) $buyer->profile_photo_disk)->get((string) $buyer->profile_photo_key);
        if (! is_string($bytes)) {
            throw new AuthenticationException('FILE_UNAVAILABLE', 'The Buyer photo is temporarily unavailable.', 503);
        }
        // Storage may be remote. Reassignment, closure or account revocation must take effect before bytes leave.
        $current = $this->buyer($this->authorizedOrder($request, $orderId));
        if ($current?->profile_photo_key !== $buyer->profile_photo_key || $current?->profile_photo_disk !== $buyer->profile_photo_disk
            || $current?->lock_version !== $buyer->lock_version) {
            throw new AuthenticationException('FILE_NOT_FOUND', 'This Buyer photo changed. Reload the delivery information.', 404);
        }

        return response()->stream(static function () use ($bytes): void {
            echo $bytes;
        }, 200, ['Content-Type' => 'image/png', 'Cache-Control' => 'private, no-store', 'X-Content-Type-Options' => 'nosniff']);
    }

    private function authorizedOrder(Request $request, string $orderId): object
    {
        $request->user()->refresh();
        $scope = $this->access->vendorScope($request);
        $this->access->require($scope, OrderAccess::RECORD_FULFILLMENT, 'Buyer delivery contact is restricted to fulfillment personnel.');
        $order = $this->access->vendorOrder($scope, $orderId);
        if (! $this->available($order, $scope)) {
            throw new AuthenticationException('DELIVERY_CONTACT_UNAVAILABLE', 'Buyer contact is available only for an accepted, open Site Delivery order.', 404);
        }

        return $order;
    }

    /** @param array{permissions: list<string>} $scope */
    private function available(object $order, array $scope): bool
    {
        return $order->fulfillment_method === 'DELIVERY' && $order->accepted_at !== null
            && ! OrderStates::isClosed((string) $order->order_state) && $order->order_state !== OrderStates::AWAITING_PAYMENT
            && OrderAccess::allows($scope, OrderAccess::RECORD_FULFILLMENT);
    }

    private function buyer(object $order): ?object
    {
        return DB::table('buyer_profiles as b')->join('users as u', 'u.id', '=', 'b.user_id')
            ->leftJoin('user_profiles as p', 'p.user_id', '=', 'u.id')->where('b.id', $order->buyer_profile_id)
            ->first(['p.mobile_e164', 'u.profile_photo_key', 'u.profile_photo_disk', 'u.lock_version']);
    }
}
