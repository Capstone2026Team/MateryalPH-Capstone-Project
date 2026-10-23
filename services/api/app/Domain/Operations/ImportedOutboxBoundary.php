<?php

declare(strict_types=1);

namespace App\Domain\Operations;

use Carbon\CarbonImmutable;
use Illuminate\Database\Query\Builder;
use RuntimeException;

/** Quarantines imported side effects without rewriting their immutable source history. */
final class ImportedOutboxBoundary
{
    public static function apply(Builder $query): Builder
    {
        $boundary = config('mail.outbox_delivery_not_before');
        if (! app()->environment('staging') || ! is_string($boundary) || $boundary === '') {
            return $query;
        }
        try {
            if (! preg_match('/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?Z\z/', $boundary)) {
                throw new RuntimeException;
            }
            $instant = CarbonImmutable::parse($boundary)->utc();
            if ($instant->format('Y-m-d\TH:i:s') !== substr($boundary, 0, 19)) {
                throw new RuntimeException;
            }
        } catch (\Throwable) {
            throw new RuntimeException('Invalid staging outbox import boundary.');
        }

        return $query->where('created_at', '>=', $instant);
    }
}
