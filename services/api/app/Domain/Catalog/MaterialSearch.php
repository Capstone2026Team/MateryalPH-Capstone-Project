<?php

declare(strict_types=1);

namespace App\Domain\Catalog;

use Illuminate\Support\Facades\DB;

/**
 * Normalizes a Vendor-entered material name, prefers exact canonical or alias
 * matches and otherwise offers pg_trgm suggestions. A fuzzy suggestion is only
 * a suggestion: the Vendor confirms it, and it never establishes comparability.
 */
final class MaterialSearch
{
    public const FUZZY_THRESHOLD = 0.3;

    public const LIMIT = 8;

    public static function normalize(string $value): string
    {
        return trim((string) preg_replace('/\s+/u', ' ', mb_strtolower($value)));
    }

    /** @return list<array{id: string, code: string, name: string, category_id: string, category_name: string, regulated: bool, match_type: string, matched_text: string, similarity: float}> */
    public function search(string $query): array
    {
        $normalized = self::normalize($query);
        if (mb_strlen($normalized) < 2) {
            return [];
        }
        $base = DB::table('materials as m')->join('material_categories as c', 'c.id', '=', 'm.material_category_id')->where('m.active', true);

        $exact = (clone $base)->where(fn ($query) => $query->whereRaw('lower(m.name) = ?', [$normalized])->orWhere('m.code', mb_strtoupper(str_replace(' ', '_', $normalized))))
            ->get(['m.id', 'm.code', 'm.name', 'm.regulated', 'c.id as category_id', 'c.name as category_name'])
            ->map(fn (object $row): array => $this->row($row, 'EXACT', $row->name, 1.0));
        $alias = (clone $base)->join('material_aliases as a', 'a.material_id', '=', 'm.id')->where('a.normalized_alias', $normalized)
            ->get(['m.id', 'm.code', 'm.name', 'm.regulated', 'c.id as category_id', 'c.name as category_name', 'a.normalized_alias'])
            ->map(fn (object $row): array => $this->row($row, 'ALIAS', $row->normalized_alias, 1.0));

        // Fuzzy candidates use the GIN trigram indexes on names and aliases.
        $fuzzy = DB::select(<<<'SQL'
SELECT m.id, m.code, m.name, m.regulated, c.id AS category_id, c.name AS category_name, candidate.text AS matched_text, MAX(candidate.score) AS score
FROM (
    SELECT id AS material_id, lower(name) AS text, similarity(lower(name), ?) AS score FROM materials WHERE active = true AND lower(name) % ?
    UNION ALL
    SELECT material_id, normalized_alias AS text, similarity(normalized_alias, ?) AS score FROM material_aliases WHERE normalized_alias % ?
) candidate
JOIN materials m ON m.id = candidate.material_id AND m.active = true
JOIN material_categories c ON c.id = m.material_category_id
WHERE candidate.score >= ?
GROUP BY m.id, m.code, m.name, m.regulated, c.id, c.name, candidate.text
ORDER BY score DESC, m.name ASC
LIMIT 24
SQL, [$normalized, $normalized, $normalized, $normalized, self::FUZZY_THRESHOLD]);

        $results = [];
        foreach ([...$exact->all(), ...$alias->all()] as $row) {
            $results[$row['id']] ??= $row;
        }
        foreach ($fuzzy as $row) {
            if (! isset($results[$row->id])) {
                $results[$row->id] = $this->row($row, 'FUZZY', (string) $row->matched_text, round((float) $row->score, 4));
            }
        }

        return array_slice(array_values($results), 0, self::LIMIT);
    }

    /** @return array{id: string, code: string, name: string, category_id: string, category_name: string, regulated: bool, match_type: string, matched_text: string, similarity: float} */
    private function row(object $row, string $type, string $matched, float $similarity): array
    {
        return ['id' => (string) $row->id, 'code' => (string) $row->code, 'name' => (string) $row->name, 'category_id' => (string) $row->category_id, 'category_name' => (string) $row->category_name, 'regulated' => (bool) $row->regulated, 'match_type' => $type, 'matched_text' => $matched, 'similarity' => $similarity];
    }
}
