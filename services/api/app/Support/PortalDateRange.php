<?php

declare(strict_types=1);

namespace App\Support;

use Carbon\CarbonImmutable;
use Illuminate\Contracts\Database\Query\Expression;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;

/** Inclusive Manila calendar filters. An omitted boundary leaves that side unrestricted. */
final class PortalDateRange
{
    /** @return array<string, list<string>> */
    public static function rules(Request $request): array
    {
        return [
            'from' => ['sometimes', 'date_format:Y-m-d'],
            'to' => ['sometimes', 'date_format:Y-m-d', ...($request->filled('from') ? ['after_or_equal:from'] : [])],
        ];
    }

    /** @param array<string, mixed> $filters */
    public static function apply(Builder $query, string|Expression $column, array $filters, bool $calendarDate = false): Builder
    {
        if (isset($filters['from'])) {
            $from = CarbonImmutable::parse((string) $filters['from'], 'Asia/Manila')->startOfDay();
            $query->where($column, '>=', $calendarDate ? $from->toDateString() : $from->setTimezone('UTC'));
        }
        if (isset($filters['to'])) {
            $to = CarbonImmutable::parse((string) $filters['to'], 'Asia/Manila')->startOfDay();
            $query->where($column, $calendarDate ? '<=' : '<', $calendarDate ? $to->toDateString() : $to->addDay()->setTimezone('UTC'));
        }

        return $query;
    }
}
