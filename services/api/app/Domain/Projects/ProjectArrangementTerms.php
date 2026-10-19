<?php

declare(strict_types=1);

namespace App\Domain\Projects;

use App\Domain\Identity\AuthenticationException;
use Illuminate\Support\Facades\DB;

/** Scope a Vendor proposal to its own Work Package allocation, preserving explicit substitutions for Buyer review. */
final class ProjectArrangementTerms
{
    /** @param list<array<string, mixed>> $lines
     * @return list<array<string, mixed>> */
    public static function allocate(object $conversation, array $lines): array
    {
        $reference = json_decode((string) $conversation->locked_reference, true);
        if (! isset($reference['arrangement_id'])) {
            return $lines;
        }
        $member = DB::table('project_arrangement_vendors as m')->join('project_procurement_arrangements as a', 'a.id', '=', 'm.arrangement_id')
            ->where('m.id', $reference['arrangement_vendor_id'])->where('m.arrangement_id', $reference['arrangement_id'])
            ->where('m.vendor_organization_id', $conversation->vendor_organization_id)->where('m.conversation_id', $conversation->id)->where('a.work_package_version_id', $reference['version_id'])->first(['m.*']);
        if ($member === null) {
            throw new AuthenticationException('PROJECT_ALLOCATION_NOT_FOUND', 'This quotation has no current authorized supplier allocation.', 409);
        }
        $allocations = $reference['vendor_allocations'];
        $remaining = array_column($allocations, 'quantity');
        foreach ($lines as &$line) {
            $needed = $line['quantity'];
            $mapped = [];
            // Prefer the original product; a substitute can only use this supplier's same-material/unit allocation.
            $indices = array_keys($allocations);
            usort($indices, static fn (int $a, int $b): int => (($allocations[$b]['variant_id'] === $line['variant_id']) <=> ($allocations[$a]['variant_id'] === $line['variant_id'])) ?: ($a <=> $b));
            foreach ($indices as $index) {
                $allocation = $allocations[$index];
                if ($allocation['material_id'] !== $line['material_id'] || $allocation['unit_id'] !== $line['unit_id'] || bccomp($remaining[$index], '0', 4) <= 0) {
                    continue;
                }
                $quantity = bccomp($needed, $remaining[$index], 4) <= 0 ? $needed : $remaining[$index];
                $mapped[] = ['line_id' => $allocation['line_id'], 'quantity' => $quantity];
                $needed = bcsub($needed, $quantity, 4);
                $remaining[$index] = bcsub($remaining[$index], $quantity, 4);
                if (bccomp($needed, '0', 4) === 0) {
                    break;
                }
            }
            if (bccomp($needed, '0', 4) > 0) {
                throw new AuthenticationException('PROJECT_ALLOCATION_EXCEEDED', 'Propose only materials and quantities assigned to your store. Ask the Buyer to revise the allocation for additional items.', 422);
            }
            $line['work_package_allocations'] = $mapped;
            $product = DB::table('listing_variants as v')->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')->where('v.id', $line['variant_id'])->first(['l.technical_attributes', 'v.attributes']);
            $line['offered_specifications'] = SpecificationMatch::offered($product->technical_attributes, $product->attributes);
        }
        unset($line);

        return $lines;
    }
}
