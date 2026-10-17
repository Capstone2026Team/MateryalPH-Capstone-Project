<?php

declare(strict_types=1);

namespace App\Domain\Analytics\Mining;

/**
 * Apriori association rules over order baskets ("materials ordered together"). Itemsets of up to three items are
 * counted level by level, only extending itemsets that already met the support floor. Every rule reports support,
 * confidence and lift; only rules with lift above 1 (the items co-occur more than chance) are kept. When the caller
 * gives each basket an owner key, a rule also needs a minimum number of distinct owners, so a pattern produced by a
 * single Buyer never appears. Rules describe co-occurrence in past orders: they are not causation, not a price, and
 * not a recommendation to any Buyer.
 */
final class AssociationRules
{
    private const MAX_ITEMSET = 3;

    /**
     * @param  list<array{items: list<string>, owner?: string|null}>  $baskets
     * @return array{baskets: int, rules: list<array{antecedent: list<string>, consequent: list<string>, support: float, support_count: int, confidence: float, lift: float, owners: int}>}
     */
    public static function mine(array $baskets, int $minSupportCount = 2, float $minConfidence = 0.3, int $minOwners = 1, int $limit = 10): array
    {
        $transactions = [];
        foreach ($baskets as $basket) {
            $items = array_values(array_unique($basket['items']));
            sort($items);
            if (count($items) >= 1) {
                $transactions[] = ['items' => $items, 'owner' => $basket['owner'] ?? null];
            }
        }
        $total = count($transactions);
        if ($total === 0) {
            return ['baskets' => 0, 'rules' => []];
        }

        /** @var array<string, array{items: list<string>, count: int, owners: array<string, true>}> $frequent */
        $frequent = [];
        $level = self::count($transactions, 1, null, $minSupportCount, $minOwners);
        foreach ($level as $key => $entry) {
            $frequent[$key] = $entry;
        }
        for ($size = 2; $size <= self::MAX_ITEMSET && $level !== []; $size++) {
            $level = self::count($transactions, $size, $level, $minSupportCount, $minOwners);
            foreach ($level as $key => $entry) {
                $frequent[$key] = $entry;
            }
        }

        $rules = [];
        foreach ($frequent as $entry) {
            $items = $entry['items'];
            if (count($items) < 2) {
                continue;
            }
            // Rules with a single-item consequent, which keeps every rule readable as "A (and B) → C".
            foreach ($items as $consequent) {
                $antecedent = array_values(array_diff($items, [$consequent]));
                $antecedentCount = $frequent[self::key($antecedent)]['count'] ?? 0;
                $consequentCount = $frequent[self::key([$consequent])]['count'] ?? 0;
                if ($antecedentCount === 0 || $consequentCount === 0) {
                    continue;
                }
                $confidence = $entry['count'] / $antecedentCount;
                $lift = $confidence / ($consequentCount / $total);
                if ($confidence + 1e-12 < $minConfidence || $lift <= 1.0) {
                    continue;
                }
                $rules[] = ['antecedent' => $antecedent, 'consequent' => [$consequent], 'support' => round($entry['count'] / $total, 4), 'support_count' => $entry['count'],
                    'confidence' => round($confidence, 4), 'lift' => round($lift, 2), 'owners' => count($entry['owners'])];
            }
        }
        usort($rules, static fn (array $a, array $b): int => [$b['lift'], $b['confidence'], $b['support_count'], $a['antecedent'], $a['consequent']] <=> [$a['lift'], $a['confidence'], $a['support_count'], $b['antecedent'], $b['consequent']]);

        return ['baskets' => $total, 'rules' => array_slice($rules, 0, $limit)];
    }

    /**
     * @param  list<array{items: list<string>, owner: string|null}>  $transactions
     * @param  array<string, array{items: list<string>, count: int, owners: array<string, true>}>|null  $previous
     * @return array<string, array{items: list<string>, count: int, owners: array<string, true>}>
     */
    private static function count(array $transactions, int $size, ?array $previous, int $minSupportCount, int $minOwners): array
    {
        $counts = [];
        foreach ($transactions as $index => $transaction) {
            foreach (self::combinations($transaction['items'], $size) as $combination) {
                if ($previous !== null && ! self::subsetsFrequent($combination, $previous)) {
                    continue;
                }
                $key = self::key($combination);
                $counts[$key] ??= ['items' => $combination, 'count' => 0, 'owners' => []];
                $counts[$key]['count']++;
                $counts[$key]['owners'][$transaction['owner'] ?? 'basket:'.$index] = true;
            }
        }

        return array_filter($counts, static fn (array $entry): bool => $entry['count'] >= $minSupportCount && count($entry['owners']) >= $minOwners);
    }

    /**
     * Apriori pruning: every (size-1) subset of a candidate must itself be frequent.
     *
     * @param  list<string>  $combination
     * @param  array<string, array{items: list<string>, count: int, owners: array<string, true>}>  $previous
     */
    private static function subsetsFrequent(array $combination, array $previous): bool
    {
        foreach ($combination as $item) {
            if (! isset($previous[self::key(array_values(array_diff($combination, [$item])))])) {
                return false;
            }
        }

        return true;
    }

    /**
     * @param  list<string>  $items
     * @return list<list<string>>
     */
    private static function combinations(array $items, int $size): array
    {
        if ($size === 1) {
            return array_map(static fn (string $item): array => [$item], $items);
        }
        $out = [];
        foreach ($items as $index => $item) {
            foreach (self::combinations(array_slice($items, $index + 1), $size - 1) as $rest) {
                $out[] = [$item, ...$rest];
            }
        }

        return $out;
    }

    /** @param list<string> $items */
    private static function key(array $items): string
    {
        sort($items);

        return implode("\u{1F}", $items);
    }
}
