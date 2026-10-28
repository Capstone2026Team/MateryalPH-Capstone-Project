<?php

declare(strict_types=1);

namespace App\Domain\Messaging;

use App\Domain\Geography\PhilippineBounds;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\AddressProviderUnavailable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/** Vendor-proposed endpoints belong to this conversation, never to the Buyer's address book. */
final class QuotationDestination
{
    /** @param array<string, mixed> $input */
    public function validateSelection(object $c, array $input): void
    {
        if (! isset($input['destination'])) {
            return;
        }
        if ($c->context_type !== 'ITEM_BASED') {
            throw new AuthenticationException('DESTINATION_LOCKED', 'Use the locked Work Package destination.', 409);
        }
        foreach (['intended_address_id', 'alternate_address_id'] as $field) {
            if (isset($input['destination'][$field])) {
                $this->point($c, $input['destination'][$field]);
            }
        }
    }

    /** @param array<string, mixed> $input
     * @return array<string, mixed> */
    public function search(Request $request, string $conversationId, array $input): array
    {
        $access = app(ConversationAccess::class);
        $c = $access->require($request->user(), $conversationId);
        $access->requireSales($request->user(), $c);
        app(ConversationService::class)->requireCurrent($c);
        if ($c->context_type !== 'ITEM_BASED') {
            throw new AuthenticationException('DESTINATION_LOCKED', 'Use the locked Work Package destination.', 409);
        }
        if (isset($input['address_id'])) {
            $point = $this->point($c, $input['address_id']);

            return ['id' => $input['address_id'], 'formatted_address' => $point['formatted_address'], 'latitude' => (float) $point['latitude'], 'longitude' => (float) $point['longitude']];
        }
        $pin = isset($input['latitude']);
        try {
            $geocoder = app(AddressGeocoder::class);
            $point = $pin ? $geocoder->reverse((float) $input['latitude'], (float) $input['longitude']) : $geocoder->forward(trim($input['query']).', Philippines');
            if ($point !== null && $pin) {
                $point = ['latitude' => (float) $input['latitude'], 'longitude' => (float) $input['longitude']] + $point;
            }
        } catch (AddressProviderUnavailable) {
            throw new AuthenticationException('ADDRESS_PROVIDER_UNAVAILABLE', 'Address search is unavailable. Retry in a moment.', 503);
        }
        if ($point === null || trim((string) $point['formatted_address']) === '' || ! PhilippineBounds::contains($point['latitude'], $point['longitude'])) {
            throw new AuthenticationException('ADDRESS_NOT_LOCATED', 'Address not found. Include the street, barangay and city, then search again.', 422);
        }
        // Provider lookup completes before the conversation lock; recheck access after that network call.
        $id = DB::transaction(function () use ($request, $conversationId, $point, $access, $pin): string {
            $c = $access->require($request->user(), $conversationId, true);
            $access->requireSales($request->user(), $c);
            app(ConversationService::class)->requireCurrent($c);
            $id = (string) Str::uuid7();
            DB::statement('INSERT INTO addresses (id, owner_type, owner_id, label, formatted_address, latitude, longitude, location, source, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ST_SetSRID(ST_MakePoint(?, ?),4326)::geography, ?, now(), now())',
                [$id, 'CONVERSATION', $c->id, 'Proposed delivery location', $point['formatted_address'], $point['latitude'], $point['longitude'], $point['longitude'], $point['latitude'], $pin ? 'MAP_PIN' : 'ADDRESS_SEARCH']);
            app(AuditRecorder::class)->account($request, 'QUOTATION_LOCATION_RESOLVED', 'CONVERSATION', $c->id, after: ['address_id' => $id]);

            return $id;
        });

        return ['id' => $id, 'formatted_address' => $point['formatted_address'], 'latitude' => (float) $point['latitude'], 'longitude' => (float) $point['longitude']];
    }

    /** @param array<string, mixed> $input
     * @return array<string, mixed> */
    public function resolve(object $c, array $input): array
    {
        $reference = json_decode((string) $c->locked_reference, true);
        $original = $reference['destination'] ?? [];
        $proposal = $input['destination'] ?? null;
        if ($proposal !== null && $c->context_type !== 'ITEM_BASED') {
            throw new AuthenticationException('DESTINATION_LOCKED', 'Use the locked Work Package destination.', 409);
        }
        $proposal ??= [];
        $intended = isset($proposal['intended_address_id']) ? $this->point($c, $proposal['intended_address_id']) : ($original['intended'] ?? null);
        $restriction = $proposal['heavy_vehicle_restriction'] ?? ($original['heavy_vehicle_restriction'] ?? 'UNANSWERED');
        $alternate = $restriction === 'YES' ? (isset($proposal['alternate_address_id']) ? $this->point($c, $proposal['alternate_address_id']) : ($original['alternate_drop_off'] ?? null)) : null;
        $instructions = trim((string) ($proposal['access_instructions'] ?? $original['access_instructions'] ?? ''));
        if ($intended === null || ! in_array($restriction, ['YES', 'NO'], true)) {
            throw new AuthenticationException('DELIVERY_ACCESS_REQUIRED', 'Select the delivery destination and record the Buyer’s heavy-vehicle restriction answer.', 422);
        }
        if ($restriction === 'YES' && ($alternate === null || $alternate['address_id'] === $intended['address_id'] || ((float) $alternate['latitude'] === (float) $intended['latitude'] && (float) $alternate['longitude'] === (float) $intended['longitude']) || mb_strlen($instructions) < 5)) {
            throw new AuthenticationException('DELIVERY_ACCESS_REQUIRED', 'A heavy-vehicle restriction requires a different drop-off and access/unloading instructions.', 422);
        }

        return ['type' => 'DELIVERY', 'intended' => $intended, 'heavy_vehicle_restriction' => $restriction,
            'alternate_drop_off' => $alternate, 'access_instructions' => $instructions, 'vehicle_endpoint' => $restriction === 'YES' ? 'ALTERNATE_DROP_OFF' : 'INTENDED_LOCATION'];
    }

    /** @return array<string, mixed> */
    private function point(object $c, string $id): array
    {
        $point = DB::table('addresses')->where('id', $id)->where('owner_type', 'CONVERSATION')->where('owner_id', $c->id)
            ->first(['id as address_id', 'label', 'formatted_address', 'latitude', 'longitude']);
        if ($point === null) {
            throw new AuthenticationException('LOCATION_NOT_FOUND', 'Search for a delivery location in this conversation.', 422);
        }

        return (array) $point;
    }
}
