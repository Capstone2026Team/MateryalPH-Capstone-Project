<?php

declare(strict_types=1);

namespace App\Domain\Projects;

use App\Domain\Finance\Money;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/** Bounded combination search over the existing exact-match offer pipeline; no commercial mutations. */
final class ArrangementProposals
{
    private const BEAM_WIDTH = 18;

    private const OFFERS_PER_LINE = 24;

    public function __construct(private readonly WorkPackageAlternatives $alternatives, private readonly ProjectProcurementDraft $draft) {}

    /** @param array<string, array<string, mixed>> $facts
     * @param array<string, int> $weights
     * @return list<list<array<string, mixed>>> */
    public function generate(Request $r, object $w, array $facts, array $weights): array
    {
        $content = json_decode((string) DB::table('work_package_versions')->where('id', $w->current_version_id)->value('content'), true);
        $lines = $content['lines'];
        $pool = $live = [];
        foreach ($lines as $line) {
            $offers = [];
            for ($page = 1; $page <= 3 && count($offers) < self::OFFERS_PER_LINE; $page++) {
                $result = $this->alternatives->list($r, (string) $w->id, $line['id'], null, $page, projectOnly: true);
                foreach ($result['items'] as $offer) {
                    if (! $offer['exact_match'] || ! isset($facts[$offer['vendor_id']])) {
                        continue;
                    }
                    $preferred = $facts[$offer['vendor_id']]['fulfillment_method'];
                    $method = in_array($preferred, $offer['fulfillment_methods'], true) ? $preferred : $offer['fulfillment_methods'][0];
                    $key = $offer['variant_id'].':'.$method;
                    try {
                        $live[$key] ??= $this->draft->offer($w, $offer['variant_id'], $method);
                    } catch (AuthenticationException) {
                        continue;
                    }
                    $item = $live[$key];
                    if (! SpecificationMatch::satisfies($line['specifications'], $item['offered_specifications']) || ($line['preferred_brand'] !== null && $line['preferred_brand'] !== $item['brand'])) {
                        continue;
                    }
                    $offers[$item['variant_id']] = $item;
                    if (count($offers) >= self::OFFERS_PER_LINE) {
                        break;
                    }
                }
                if (! $result['has_more']) {
                    break;
                }
            }
            $pool[$line['id']] = array_values($offers);
        }
        $beam = [[]];
        foreach ($lines as $line) {
            $next = [];
            foreach ($beam as $selected) {
                $used = [];
                foreach ($selected as $item) {
                    $used[$item['variant_id']] = bcadd($used[$item['variant_id']] ?? '0', $item['quantity'], 4);
                }
                $offers = $pool[$line['id']];
                $choices = [];
                foreach ($offers as $first) {
                    $needed = (string) $line['quantity'];
                    $allocation = [];
                    $specs = SpecificationMatch::normalizeAll($first['offered_specifications']);
                    $rest = array_values(array_filter($offers, static fn (array $i): bool => $i['variant_id'] !== $first['variant_id']));
                    usort($rest, static fn (array $a, array $b): int => (($b['vendor_id'] === $first['vendor_id']) <=> ($a['vendor_id'] === $first['vendor_id']))
                        ?: ($a['unit_price_centavos'] <=> $b['unit_price_centavos']) ?: strcmp($a['variant_id'], $b['variant_id']));
                    foreach ([$first, ...$rest] as $item) {
                        if (SpecificationMatch::normalizeAll($item['offered_specifications']) !== $specs) {
                            continue;
                        }
                        $available = bcsub($item['_available'], $used[$item['variant_id']] ?? '0', 4);
                        $quantity = bcadd(bccomp($available, $needed, 4) <= 0 ? $available : $needed, '0', $item['unit_precision']);
                        if (bccomp($quantity, '0', 4) <= 0) {
                            continue;
                        }
                        unset($item['_available']);
                        $allocation[] = $item + ['draft_item_id' => (string) Str::uuid7(), 'stage' => 'DRAFT', 'line_id' => $line['id'], 'quantity' => $quantity,
                            'coverage_quantity' => $quantity, 'line_total_centavos' => Money::lineAmount($quantity, $item['unit_price_centavos']), 'satisfies_requirement' => true];
                        $needed = bcsub($needed, $quantity, 4);
                        if (bccomp($needed, '0', 4) <= 0) {
                            break;
                        }
                    }
                    if ($allocation !== []) {
                        $choices[self::key($allocation)] = $allocation;
                    }
                }
                if ($choices === []) {
                    $choices = [[]];
                }
                foreach ($choices as $choice) {
                    $items = array_merge($selected, $choice);
                    $next[self::key($items)] = ['items' => $items, 'hint' => self::hint($items, $lines, $facts, $weights, (int) $w->budget_centavos)];
                }
            }
            $next = array_values($next);
            usort($next, static fn (array $a, array $b): int => ArrangementMatchScore::compare($a['hint'], $b['hint']));
            // Keep competitive paths and different supplier sets, rather than 18 variants from the same stores.
            $beam = [];
            $sets = [];
            foreach ($next as $candidate) {
                $vendors = array_values(array_unique(array_column($candidate['items'], 'vendor_id')));
                sort($vendors);
                $set = implode(':', $vendors);
                if (count($beam) < 9 || ! isset($sets[$set])) {
                    $beam[] = $candidate['items'];
                    $sets[$set] = true;
                }
                if (count($beam) >= self::BEAM_WIDTH) {
                    break;
                }
            }
        }

        return $beam;
    }

    /** @param list<array<string, mixed>> $items */
    private static function key(array $items): string
    {
        $rows = array_map(static fn (array $i): array => [$i['line_id'], $i['variant_id'], bcadd($i['quantity'], '0', 4)], $items);
        sort($rows);

        return hash('sha256', json_encode($rows, JSON_THROW_ON_ERROR));
    }

    /** Materials-only search hint. Final ordering always uses the actual combined delivery previews.
     * @param list<array<string, mixed>> $items
     * @param list<array<string, mixed>> $lines
     * @param array<string, array<string, mixed>> $facts
     * @param array<string, int> $weights
     * @return array<string, mixed> */
    private static function hint(array $items, array $lines, array $facts, array $weights, int $budget): array
    {
        $vendors = [];
        $covered = [];
        foreach ($items as $item) {
            $vendor = $item['vendor_id'];
            $vendors[$vendor] ??= array_merge($facts[$vendor], ['vendor_id' => $vendor, 'materials_centavos' => 0]);
            $vendors[$vendor]['materials_centavos'] += $item['line_total_centavos'];
            $covered[$item['line_id']] = bcadd($covered[$item['line_id']] ?? '0', $item['quantity'], 4);
        }
        $rows = [];
        $complete = 0;
        foreach ($lines as $line) {
            $quantity = $covered[$line['id']] ?? '0';
            $complete += bccomp($quantity, $line['quantity'], 4) >= 0 ? 1 : 0;
            $rows[] = ['required_quantity' => $line['quantity'], 'vendor_quantity' => $quantity, 'separate_quantity' => '0'];
        }
        $coverage = ['lines' => $rows, 'lines_fulfilled' => $complete, 'lines_total' => count($lines)];
        $cost = array_sum(array_column($vendors, 'materials_centavos'));

        return ['id' => self::key($items), 'coverage' => $coverage, 'vendor_count' => count($vendors), 'total_centavos' => $cost, 'issues' => [],
            'fms' => ArrangementMatchScore::calculate($coverage, array_values($vendors), $cost, $budget, $weights)];
    }
}
