<?php

declare(strict_types=1);

namespace App\Domain\Orders;

use Illuminate\Http\Request;
use Illuminate\Support\Str;

/** Who caused an order change: a Buyer, a Vendor user, the automated auto-accept policy or a system job. */
final readonly class OrderActor
{
    public function __construct(
        public ?int $userId,
        public ?string $role,
        public string $source,
        public string $correlationId,
    ) {}

    public static function buyer(Request $request): self
    {
        return new self((int) $request->user()->getKey(), 'BUYER', 'BUYER', self::correlation($request));
    }

    public static function vendor(Request $request, string $role): self
    {
        return new self((int) $request->user()->getKey(), $role, 'VENDOR', self::correlation($request));
    }

    public static function autoAccept(?Request $request = null): self
    {
        return new self(null, 'AUTOMATED_POLICY', 'AUTO_ACCEPT', $request === null ? (string) Str::uuid7() : self::correlation($request));
    }

    public static function system(?string $correlationId = null): self
    {
        return new self(null, 'SYSTEM', 'SYSTEM', $correlationId ?? (string) Str::uuid7());
    }

    private static function correlation(Request $request): string
    {
        $id = $request->attributes->get('correlation_id');

        return is_string($id) && $id !== '' ? $id : (string) Str::uuid7();
    }
}
