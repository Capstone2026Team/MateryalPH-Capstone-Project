<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        $this->replaceChecks('> 0');
    }

    public function down(): void
    {
        // Refuse rollback if new preferences do not fit the old rule; never rewrite Buyer choices.
        $this->replaceChecks('= 100');
    }

    private function replaceChecks(string $totalRule): void
    {
        foreach ([
            'item' => ['ITEM_BASED', ['distance', 'price', 'vps', 'stock', 'product_rating']],
            'project' => ['PROJECT_BASED', ['material_match', 'budget_fit', 'distance', 'vps']],
        ] as $name => [$type, $keys]) {
            $columns = implode(',', array_map(static fn (string $key): string => "'{$key}'", $keys));
            $checks = ["jsonb_typeof(weights) = 'object'", "jsonb_exists_all(weights, array[{$columns}])", "(weights - array[{$columns}]) = '{}'::jsonb"];
            foreach ($keys as $key) {
                $checks[] = "jsonb_typeof(weights->'{$key}') = 'number' AND (weights->>'{$key}') ~ '^[0-9]{1,3}$' AND (weights->>'{$key}')::int BETWEEN 0 AND 100";
            }
            $sum = implode(' + ', array_map(static fn (string $key): string => "(weights->>'{$key}')::int", $keys));
            $checks[] = "({$sum}) {$totalRule}";
            $expression = implode(' AND ', $checks);
            DB::statement("ALTER TABLE buyer_ranking_preferences DROP CONSTRAINT buyer_ranking_{$name}_weights_check");
            DB::statement("ALTER TABLE buyer_ranking_preferences ADD CONSTRAINT buyer_ranking_{$name}_weights_check CHECK (procurement_type <> '{$type}' OR ({$expression}))");
        }
    }
};
