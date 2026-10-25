<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Common hardware-store reference materials (approved by the project owner on 2026-10-25) so ordinary listings can be
 * price-compared in Materials Analytics instead of staying "Other" / Not Yet Comparable.
 *
 * Every material here is unregulated: none is on the DTI-BPS List of Regulated Building and Construction Products
 * transcribed in the Phase 4 reference taxonomy. DTI-regulated electrical goods (lamps, breakers, cords, wiring
 * devices, insulating tape), power tools, pumps and safety helmets are deliberately not added and stay "Other".
 *
 * MAT-03 comparability keys are category-wide, so only categories that had none receive one: a free-text "Size"
 * (stated exactly, e.g. "16 oz" or "700 x 2100 mm"). Aggregates already recorded gradation as an ordinary attribute;
 * it becomes the comparison key so different gradations never average together. No existing key, unit, conversion or
 * regulated rule changes, and rows are keyed by stable codes so the seed is idempotent and never rewrites an
 * Admin-managed entry that already exists.
 */
return new class extends Migration
{
    private const SIZE_CATEGORIES = [
        'TOOLS_AND_ACCESSORIES', 'ADHESIVES_AND_SEALANTS', 'DOORS_WINDOWS_AND_GLASS', 'ROOFING_MATERIALS',
        'INSULATION_AND_WATERPROOFING', 'WALL_AND_CEILING', 'FORMWORKS_AND_SCAFFOLDING',
    ];

    public function up(): void
    {
        foreach (self::SIZE_CATEGORIES as $categoryCode) {
            $categoryId = DB::table('material_categories')->where('code', $categoryCode)->value('id');
            $this->upsert('technical_attribute_definitions', ['material_category_id' => $categoryId, 'code' => 'size'], [
                'label' => 'Size', 'value_type' => 'TEXT', 'required' => false, 'allowed_values' => null, 'unit_code' => null, 'sort_order' => 0, 'comparability_key' => true,
            ]);
        }
        DB::table('technical_attribute_definitions')->where('code', 'gradation')
            ->where('material_category_id', DB::table('material_categories')->where('code', 'AGGREGATES')->value('id'))
            ->update(['comparability_key' => true, 'updated_at' => now()]);

        // [code, name, category, canonical unit, compatible units, aliases, tags]
        $materials = [
            ['ENAMEL_PAINT', 'Enamel paint', 'PAINTS_AND_FINISHES', 'L', ['L', 'GAL'], ['enamel', 'enamel paint', 'quick dry enamel', 'quick drying enamel', 'qde', 'flat wall enamel', 'gloss enamel'], ['FINISHING', 'INTERIOR', 'EXTERIOR']],
            ['ELASTOMERIC_SEALANT', 'Elastomeric sealant', 'ADHESIVES_AND_SEALANTS', 'PC', ['PC'], ['elastomeric sealant', 'crack sealant', 'roof sealant'], ['WATERPROOFING', 'EXTERIOR']],
            ['POLYURETHANE_SEALANT', 'Polyurethane sealant', 'ADHESIVES_AND_SEALANTS', 'PC', ['PC'], ['polyurethane sealant', 'pu sealant', 'joint sealant'], ['WATERPROOFING', 'EXTERIOR']],
            ['WATERPROOFING_SEALANT', 'Waterproofing sealant', 'ADHESIVES_AND_SEALANTS', 'PC', ['PC'], ['waterproofing sealant', 'leak sealant'], ['WATERPROOFING']],
            ['EPOXY_ADHESIVE', 'Epoxy adhesive', 'ADHESIVES_AND_SEALANTS', 'PC', ['PC'], ['epoxy', 'epoxy adhesive', 'epoxy glue'], ['INTERIOR', 'EXTERIOR']],
            ['TEK_SCREW', 'Tek screw', 'FASTENERS_AND_HARDWARE', 'BOX', ['BOX'], ['tek screw', 'self-drilling screw', 'roofing screw'], ['ROOFING', 'STRUCTURAL']],
            ['WEDGE_ANCHOR', 'Wedge anchor', 'FASTENERS_AND_HARDWARE', 'BOX', ['BOX'], ['wedge anchor', 'anchor bolt', 'expansion bolt'], ['STRUCTURAL']],
            ['DROP_IN_ANCHOR', 'Drop-in anchor', 'FASTENERS_AND_HARDWARE', 'BOX', ['BOX'], ['drop-in anchor', 'drop in anchor', 'concrete anchor'], ['STRUCTURAL']],
            ['PLASTIC_WALL_PLUG', 'Plastic wall plug', 'FASTENERS_AND_HARDWARE', 'BOX', ['BOX'], ['plastic wall anchor', 'wall plug', 'tox', 'plastic anchor'], ['INTERIOR']],
            ['BLIND_RIVET', 'Blind rivet', 'FASTENERS_AND_HARDWARE', 'BOX', ['BOX'], ['blind rivet', 'pop rivet', 'rivets'], ['STRUCTURAL']],
            ['SPC_FLOORING', 'SPC vinyl plank flooring', 'FLOORING_MATERIALS', 'BOX', ['BOX'], ['spc flooring', 'spc vinyl plank', 'vinyl plank', 'click flooring'], ['FLOORING', 'INTERIOR']],
            ['WPC_DECKING', 'WPC decking board', 'FLOORING_MATERIALS', 'PC', ['PC'], ['wpc decking', 'composite decking', 'decking board'], ['FLOORING', 'EXTERIOR']],
            ['INTERLOCKING_PAVING_BLOCK', 'Interlocking paving block', 'MASONRY', 'PC', ['PC'], ['paving block', 'interlocking pavers', 'pavers'], ['EXTERIOR', 'MASONRY_WORK']],
            ['FLOOR_DRAIN', 'Floor drain', 'DRAINAGE_AND_SEPTIC', 'PC', ['PC'], ['floor drain', 'shower drain'], ['DRAINAGE', 'PLUMBING']],
            ['CLAW_HAMMER', 'Claw hammer', 'TOOLS_AND_ACCESSORIES', 'PC', ['PC'], ['claw hammer', 'martilyo', 'hammer'], ['STRUCTURAL']],
            ['TAPE_MEASURE', 'Tape measure', 'TOOLS_AND_ACCESSORIES', 'PC', ['PC'], ['tape measure', 'metro', 'measuring tape'], ['INTERIOR', 'STRUCTURAL']],
            ['SPIRIT_LEVEL', 'Spirit level', 'TOOLS_AND_ACCESSORIES', 'PC', ['PC'], ['spirit level', 'level bar', 'liwanag'], ['MASONRY_WORK', 'STRUCTURAL']],
            ['HAND_SAW', 'Hand saw', 'TOOLS_AND_ACCESSORIES', 'PC', ['PC'], ['hand saw', 'lagari', 'crosscut saw'], ['STRUCTURAL']],
            ['UTILITY_KNIFE', 'Utility knife', 'TOOLS_AND_ACCESSORIES', 'PC', ['PC'], ['utility knife', 'cutter', 'box cutter'], ['INTERIOR']],
            ['PIPE_WRENCH', 'Pipe wrench', 'TOOLS_AND_ACCESSORIES', 'PC', ['PC'], ['pipe wrench', 'tubo wrench'], ['PLUMBING']],
            ['RUBBER_MALLET', 'Rubber mallet', 'TOOLS_AND_ACCESSORIES', 'PC', ['PC'], ['rubber mallet', 'mallet'], ['FLOORING']],
            ['CARPENTER_SQUARE', 'Carpenter square', 'TOOLS_AND_ACCESSORIES', 'PC', ['PC'], ['carpenter square', 'framing square', 'escuala'], ['STRUCTURAL']],
            ['BRICKLAYING_TROWEL', 'Bricklaying trowel', 'TOOLS_AND_ACCESSORIES', 'PC', ['PC'], ['bricklaying trowel', 'kutsara', 'masonry trowel'], ['MASONRY_WORK']],
            ['NOTCHED_TROWEL', 'Notched trowel', 'TOOLS_AND_ACCESSORIES', 'PC', ['PC'], ['notched trowel', 'tile trowel'], ['FLOORING']],
            ['STEEL_SHOVEL', 'Steel shovel', 'TOOLS_AND_ACCESSORIES', 'PC', ['PC'], ['shovel', 'pala', 'steel shovel'], ['MASONRY_WORK']],
            ['WHEELBARROW', 'Wheelbarrow', 'TOOLS_AND_ACCESSORIES', 'PC', ['PC'], ['wheelbarrow', 'kartilya'], ['MASONRY_WORK', 'BULK']],
            ['PAINT_ROLLER', 'Paint roller', 'TOOLS_AND_ACCESSORIES', 'PC', ['PC'], ['paint roller', 'roller', 'paint tray'], ['FINISHING']],
            ['MASKING_TAPE', 'Masking tape', 'TOOLS_AND_ACCESSORIES', 'ROLL', ['ROLL'], ['masking tape', 'painters tape'], ['FINISHING']],
            ['WORK_GLOVES', 'Work gloves', 'TOOLS_AND_ACCESSORIES', 'PC', ['PC'], ['work gloves', 'gloves', 'guwantes'], ['STRUCTURAL']],
            ['SANDPAPER', 'Sandpaper', 'TOOLS_AND_ACCESSORIES', 'BOX', ['BOX'], ['sandpaper', 'liha', 'abrasive paper'], ['FINISHING']],
            ['TILE_SPACERS', 'Tile spacers', 'TOOLS_AND_ACCESSORIES', 'BOX', ['BOX'], ['tile spacers', 'tile spacer'], ['FLOORING']],
            ['TILE_LEVELING_CLIPS', 'Tile leveling clips', 'TOOLS_AND_ACCESSORIES', 'BOX', ['BOX'], ['tile leveling clips', 'tile leveling system'], ['FLOORING']],
            ['FLUSH_DOOR', 'Flush door', 'DOORS_WINDOWS_AND_GLASS', 'PC', ['PC'], ['flush door', 'pinto', 'plywood door'], ['INTERIOR']],
            ['PVC_DOOR', 'PVC door', 'DOORS_WINDOWS_AND_GLASS', 'PC', ['PC'], ['pvc door', 'bathroom door', 'pvc bathroom door'], ['INTERIOR']],
            ['JALOUSIE_WINDOW', 'Jalousie window', 'DOORS_WINDOWS_AND_GLASS', 'PC', ['PC'], ['jalousie', 'jalousie window', 'louver window'], ['EXTERIOR']],
            ['SLIDING_WINDOW', 'Sliding window', 'DOORS_WINDOWS_AND_GLASS', 'PC', ['PC'], ['sliding window', 'aluminum sliding window'], ['EXTERIOR']],
            ['WINDOW_GRILLE', 'Window grille', 'DOORS_WINDOWS_AND_GLASS', 'PC', ['PC'], ['window grille', 'window grill', 'rehas'], ['EXTERIOR']],
            ['CLEAR_FLOAT_GLASS', 'Clear float glass', 'DOORS_WINDOWS_AND_GLASS', 'SQM', ['SQM'], ['clear glass', 'float glass', 'salamin'], ['INTERIOR', 'EXTERIOR']],
            ['DOOR_KNOBSET', 'Door knobset', 'DOORS_WINDOWS_AND_GLASS', 'PC', ['PC'], ['door knob', 'knobset', 'door lock'], ['INTERIOR']],
            ['DOOR_LEVERSET', 'Door leverset', 'DOORS_WINDOWS_AND_GLASS', 'PC', ['PC'], ['door lever', 'leverset', 'lever handle'], ['INTERIOR']],
            ['DEADBOLT', 'Deadbolt', 'DOORS_WINDOWS_AND_GLASS', 'PC', ['PC'], ['deadbolt', 'dead bolt lock'], ['INTERIOR']],
            ['DOOR_CLOSER', 'Door closer', 'DOORS_WINDOWS_AND_GLASS', 'PC', ['PC'], ['door closer', 'hydraulic door closer'], ['INTERIOR']],
            ['DOOR_VIEWER', 'Door viewer', 'DOORS_WINDOWS_AND_GLASS', 'PC', ['PC'], ['door viewer', 'peephole'], ['INTERIOR']],
            ['BALL_BEARING_HINGE', 'Ball-bearing hinge', 'DOORS_WINDOWS_AND_GLASS', 'PC', ['PC'], ['ball bearing hinge', 'door hinge', 'bisagra'], ['INTERIOR']],
            ['POLYCARBONATE_ROOFING', 'Polycarbonate roofing sheet', 'ROOFING_MATERIALS', 'SHEET', ['SHEET'], ['polycarbonate roofing', 'polycarbonate sheet', 'corrugated polycarbonate'], ['ROOFING']],
            ['TWINWALL_POLYCARBONATE', 'Twinwall polycarbonate sheet', 'ROOFING_MATERIALS', 'SHEET', ['SHEET'], ['twinwall polycarbonate', 'multiwall polycarbonate', 'hollow polycarbonate'], ['ROOFING']],
            ['PVC_SOFFIT', 'PVC soffit', 'ROOFING_MATERIALS', 'PC', ['PC'], ['pvc soffit', 'soffit', 'eaves'], ['ROOFING', 'EXTERIOR']],
            ['RAIN_GUTTER', 'Rain gutter', 'ROOFING_MATERIALS', 'PC', ['PC'], ['rain gutter', 'alulod', 'gutter'], ['ROOFING', 'DRAINAGE']],
            ['PVC_CEILING_PANEL', 'PVC ceiling panel', 'WALL_AND_CEILING', 'PC', ['PC'], ['pvc ceiling', 'pvc ceiling panel', 'pvc kisame'], ['INTERIOR']],
            ['CEMENTITIOUS_WATERPROOFING', 'Cementitious waterproofing', 'INSULATION_AND_WATERPROOFING', 'PC', ['PC'], ['cementitious waterproofing', 'waterproofing coating'], ['WATERPROOFING']],
            ['FIBERGLASS_MESH_TAPE', 'Fiberglass mesh tape', 'INSULATION_AND_WATERPROOFING', 'ROLL', ['ROLL'], ['fiberglass mesh tape', 'mesh tape', 'drywall tape'], ['WATERPROOFING', 'INTERIOR']],
            ['HYDRAULIC_LEAK_PLUG', 'Hydraulic leak plug', 'INSULATION_AND_WATERPROOFING', 'PC', ['PC'], ['hydraulic cement', 'leak plug', 'water plug'], ['WATERPROOFING']],
            ['BAMBOO_POLE', 'Bamboo pole', 'FORMWORKS_AND_SCAFFOLDING', 'PC', ['PC'], ['bamboo', 'kawayan', 'bamboo pole'], ['STRUCTURAL']],
        ];
        foreach ($materials as [$code, $name, $categoryCode, $unitCode, $compatible, $aliases, $tagCodes]) {
            $materialId = $this->upsert('materials', ['code' => $code], [
                'material_category_id' => DB::table('material_categories')->where('code', $categoryCode)->value('id'),
                'name' => $name, 'normalized_name' => mb_strtolower($name), 'canonical_unit_id' => DB::table('units')->where('code', $unitCode)->value('id'),
                'regulated' => false, 'active' => true,
            ]);
            foreach ($compatible as $compatibleCode) {
                $this->upsert('material_compatible_units', ['material_id' => $materialId, 'unit_id' => DB::table('units')->where('code', $compatibleCode)->value('id')], []);
            }
            foreach ($aliases as $alias) {
                $this->upsert('material_aliases', ['material_id' => $materialId, 'normalized_alias' => mb_strtolower($alias)], []);
            }
            foreach ($tagCodes as $tagCode) {
                $this->upsert('material_tag_links', ['material_id' => $materialId, 'material_tag_id' => DB::table('material_tags')->where('code', $tagCode)->value('id')], []);
            }
        }
    }

    public function down(): void
    {
        // Reference taxonomy may already be referenced by listings, orders, analytics and compliance history.
    }

    /**
     * @param  array<string, mixed>  $keys
     * @param  array<string, mixed>  $values
     */
    private function upsert(string $table, array $keys, array $values): string
    {
        $existing = DB::table($table)->where($keys)->value('id');
        if (is_string($existing)) {
            return $existing;
        }
        $id = (string) Str::uuid7();
        DB::table($table)->insert($keys + $values + ['id' => $id, 'created_at' => now(), 'updated_at' => now()]);

        return $id;
    }
};
