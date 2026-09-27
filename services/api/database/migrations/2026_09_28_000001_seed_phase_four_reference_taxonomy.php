<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Seeds the canonical reference taxonomy the Vendor listing wizard needs.
 * Rows are keyed by stable codes so the seed is idempotent and never rewrites
 * an Admin-managed entry that already exists.
 *
 * Regulated mappings transcribe the "List of DTI-BPS Regulated Building and
 * Construction Products with Marking Requirements": each rule records its
 * product, PNS reference standard, DAO technical regulation, scope and marking
 * requirements. Locally manufactured goods carry the PS Mark with licence
 * number; imported goods carry the ICC sticker. MateryalPH review is an
 * operational marketplace control, not a government certification.
 */
return new class extends Migration
{
    private const SOURCE = 'DTI-BPS List of Regulated Building and Construction Products with Marking Requirements; https://bps.dti.gov.ph/product-certification/list-of-products-under-mandatory-certification';

    public function up(): void
    {
        $categories = [
            'CONSTRUCTION_MATERIALS' => 'Construction Materials', 'ELECTRICAL_SUPPLIES' => 'Electrical Supplies',
            'PLUMBING_AND_SANITARY' => 'Plumbing and Sanitary', 'TOOLS_AND_EQUIPMENT' => 'Tools and Equipment',
            'FINISHING_MATERIALS' => 'Finishing Materials', 'FASTENERS_AND_HARDWARE' => 'Fasteners and Hardware',
            'CEMENT_AND_CONCRETE' => 'Cement and Concrete', 'ROOFING_MATERIALS' => 'Roofing Materials',
            'FORMWORKS_AND_SCAFFOLDING' => 'Formworks and Scaffolding', 'WOOD_AND_LUMBER' => 'Wood and Lumber',
            'LANDSCAPING_AND_EXTERIOR' => 'Landscaping and Exterior', 'STEEL_AND_REINFORCEMENT' => 'Steel and Reinforcement',
            'TOOLS_AND_ACCESSORIES' => 'Tools and Accessories', 'MASONRY' => 'Masonry',
            'INSULATION_AND_WATERPROOFING' => 'Insulation and Waterproofing', 'AGGREGATES' => 'Aggregates',
            'DRAINAGE_AND_SEPTIC' => 'Drainage and Septic Materials', 'CONSTRUCTION_CHEMICALS' => 'Construction Chemicals',
            'FLOORING_MATERIALS' => 'Flooring Materials', 'WALL_AND_CEILING' => 'Wall and Ceiling Materials',
            'HVAC_MATERIALS' => 'HVAC Materials', 'SANITARY_FIXTURES' => 'Sanitary Fixtures',
            'FIRE_PROTECTION' => 'Fire Protection Materials', 'PAINTS_AND_FINISHES' => 'Paints and Finishes',
            'ADHESIVES_AND_SEALANTS' => 'Adhesives and Sealants', 'DOORS_WINDOWS_AND_GLASS' => 'Doors, Windows, and Glass',
        ];
        $order = 0;
        foreach ($categories as $code => $name) {
            $this->upsert('material_categories', ['code' => $code], ['name' => $name, 'sort_order' => $order += 10, 'active' => true]);
        }

        $units = [
            'PC' => ['Piece', 'COUNT', 0], 'BAG' => ['Bag', 'PACK', 0], 'BOX' => ['Box', 'PACK', 0], 'ROLL' => ['Roll', 'PACK', 0],
            'SHEET' => ['Sheet', 'COUNT', 0], 'KG' => ['Kilogram', 'MASS', 3], 'M' => ['Meter', 'LENGTH', 3],
            'SQM' => ['Square meter', 'AREA', 3], 'CUM' => ['Cubic meter', 'VOLUME', 3], 'L' => ['Liter', 'VOLUME', 3],
            'GAL' => ['Gallon (3.785 L can)', 'PACK', 0], 'COIL' => ['Coil', 'PACK', 0],
        ];
        foreach ($units as $code => [$name, $dimension, $precision]) {
            $this->upsert('units', ['code' => $code], ['name' => $name, 'dimension' => $dimension, 'precision' => $precision]);
        }

        $tags = ['STRUCTURAL' => 'Structural', 'FOUNDATION' => 'Foundation', 'MASONRY_WORK' => 'Masonry work', 'ROOFING' => 'Roofing',
            'ELECTRICAL' => 'Electrical', 'PLUMBING' => 'Plumbing', 'FINISHING' => 'Finishing', 'INTERIOR' => 'Interior',
            'EXTERIOR' => 'Exterior', 'WATERPROOFING' => 'Waterproofing', 'BAGGED' => 'Bagged', 'BULK' => 'Bulk',
            'POTABLE_WATER' => 'Potable water', 'DRAINAGE' => 'Drainage', 'FLOORING' => 'Flooring'];
        foreach ($tags as $code => $name) {
            $this->upsert('material_tags', ['code' => $code], ['name' => $name]);
        }

        // [code, label, type, required, allowed values, display unit, comparability key]
        $attributes = [
            'CEMENT_AND_CONCRETE' => [['cement_type', 'Cement type', 'TEXT', true, null, null, true], ['bag_weight_kg', 'Mass per bag', 'NUMBER', true, null, 'kg', true]],
            'STEEL_AND_REINFORCEMENT' => [['grade', 'Steel grade', 'ENUM', true, ['Grade 170', 'Grade 230', 'Grade 280', 'Grade 420', 'Grade 520', 'Grade 550'], null, true], ['diameter_mm', 'Nominal diameter or leg size', 'NUMBER', true, null, 'mm', true], ['length_m', 'Length', 'NUMBER', true, null, 'm', true]],
            'ELECTRICAL_SUPPLIES' => [['size_mm', 'Nominal size', 'NUMBER', false, null, 'mm', true]],
            'PLUMBING_AND_SANITARY' => [['nominal_size_mm', 'Nominal size', 'NUMBER', true, null, 'mm', true], ['pipe_class', 'Class, series or SDR', 'TEXT', false, null, null, true]],
            'DRAINAGE_AND_SEPTIC' => [['nominal_size_mm', 'Nominal size', 'NUMBER', true, null, 'mm', true]],
            'FASTENERS_AND_HARDWARE' => [['length_mm', 'Length', 'NUMBER', false, null, 'mm', true], ['diameter_mm', 'Wire diameter', 'NUMBER', false, null, 'mm', true]],
            'FLOORING_MATERIALS' => [['work_size_mm', 'Work size', 'TEXT', true, null, 'mm', true]],
            'WOOD_AND_LUMBER' => [['thickness_mm', 'Thickness', 'NUMBER', true, null, 'mm', true], ['bonding_class', 'Bonding class', 'ENUM', false, ['1', '2', '3'], null, true]],
            'SANITARY_FIXTURES' => [['fixture_type', 'Fixture type', 'ENUM', true, ['Bidet', 'Lavatory', 'Shower base', 'Sink', 'Urinal', 'Water closet'], null, true]],
            'MASONRY' => [['thickness_mm', 'Thickness', 'NUMBER', true, null, 'mm', true]],
            'AGGREGATES' => [['gradation', 'Gradation', 'TEXT', false, null, null, false]],
            'PAINTS_AND_FINISHES' => [['finish', 'Finish', 'ENUM', false, ['Flat', 'Semi-gloss', 'Gloss'], null, true]],
        ];
        foreach ($attributes as $categoryCode => $definitions) {
            $categoryId = DB::table('material_categories')->where('code', $categoryCode)->value('id');
            foreach ($definitions as $index => [$code, $label, $type, $required, $allowed, $unit, $key]) {
                $this->upsert('technical_attribute_definitions', ['material_category_id' => $categoryId, 'code' => $code], [
                    'label' => $label, 'value_type' => $type, 'required' => $required, 'allowed_values' => $allowed === null ? null : json_encode($allowed, JSON_THROW_ON_ERROR),
                    'unit_code' => $unit, 'sort_order' => $index * 10, 'comparability_key' => $key,
                ]);
            }
        }

        $cementMarking = ['Name and address of manufacturer', 'Name and address of importer', 'Cement type', 'Brand name', 'Mass in kg', 'Country of manufacture', 'PS Mark', 'Batch number and manufacturing date'];
        $steelTags = ['Correct and registered trade name or brand name', 'Duly registered trademark', 'Registered business name and address of importer and manufacturer (if imported) or of manufacturer (if locally manufactured)', 'Country of origin', 'Lot / batch number', 'PS License No. or SOC Number, whichever is applicable'];
        // [code, name, category, canonical unit, compatible units, aliases, tags, rule or null]
        // rule: [product name, reference standard, technical regulation, scope, marking requirements]
        $materials = [
            ['PORTLAND_CEMENT', 'Portland cement', 'CEMENT_AND_CONCRETE', 'BAG', ['BAG'], ['cement', 'semento', 'portland', 'ordinary portland cement', 'opc', 'portland cement'], ['STRUCTURAL', 'BAGGED'],
                ['PORTLAND CEMENT', 'PNS 07:2018', 'DAO 17-06:2017', 'Type I, Type IA, Type II, Type IIA, Type II (MH), Type II (MH) A, Type III, Type IIIA, Type IV, and Type V', $cementMarking]],
            ['BLENDED_CEMENT', 'Blended cement', 'CEMENT_AND_CONCRETE', 'BAG', ['BAG'], ['blended cement', 'pozzolan cement', 'type 1p cement', 'type ip cement'], ['STRUCTURAL', 'BAGGED'],
                ['BLENDED CEMENT', 'PNS 63:2019', 'DAO 17-06:2017', 'Blended hydraulic cements for both general and specific applications using slag, pozzolan, limestone, or combinations of these, with portland cement or portland cement clinker', $cementMarking]],
            ['DEFORMED_STEEL_BAR', 'Deformed steel bar', 'STEEL_AND_REINFORCEMENT', 'PC', ['PC'], ['rebar', 'bakal', 'steel bar', 'deformed bar', 'reinforcing bar', 'deformed steel bar'], ['STRUCTURAL', 'FOUNDATION'],
                ['DEFORMED STEEL BARS', 'PNS 49:2020', 'DAO 18-08:2018', 'Grades 230, 280, 420, 520 and 550. Weldable and Regular ductility classes. Diameters 10mm to 50mm', ['BPS pre-qualified logo, nominal diameter, grade, ductility class and other applicable markings embossed at approximately one-meter intervals (MC 21-07, Series of 2021)', 'Grade markings: 230 "230"/"2", 280 "280"/"3", 420 "420"/"4", 520 "520"/"5", 550 "550"/"6"', 'Ductility class 2 (weldable) marked "W"', 'Micro alloyed "MA"/"A"; quench and tempered "QT"/"Q"/"T"', 'Bundle tags per DAO 18-08, Series of 2018 section 10.1.5']]],
            ['REROLLED_STEEL_BAR', 'Rerolled steel bar', 'STEEL_AND_REINFORCEMENT', 'PC', ['PC'], ['rerolled bar', 'rerolled steel bar', 'reroll'], ['STRUCTURAL'],
                ['REROLLED STEEL BARS', 'PNS 211:2002', 'DAO 18-08:2018', 'Grades 170 - 6mm and 7mm; Grade 230 - 8 mm.', ['BPS pre-qualified logo embossed at approximately one-meter intervals', 'Bar size embossed or filled space per PNS 211', 'Color codes painted on both ends per PNS 211', ...$steelTags, 'Length', 'Diameter', 'Number of pieces']]],
            ['EQUAL_LEG_ANGLE_BAR', 'Equal-leg angle steel bar', 'STEEL_AND_REINFORCEMENT', 'PC', ['PC'], ['angle bar', 'equal leg angle bar', 'angle steel'], ['STRUCTURAL'],
                ['EQUAL-LEG ANGLE STEEL BARS', 'PNS 657:2008', 'DAO 18-08:2018', 'Only covers hot-rolled equal-leg angle steel bars - normally intended for bolted, riveted, or welded structures.', ['BPS pre-qualified logo, leg size and grade embossed on the inner face at approximately one-meter intervals', 'Thickness color marking at both ends per PNS 657 (optional system)', ...$steelTags, 'Grade and length', 'Thickness and leg length', 'Number of pieces']]],
            ['WELDED_STEEL_PIPE', 'Black iron or galvanized iron welded steel pipe', 'PLUMBING_AND_SANITARY', 'PC', ['PC'], ['gi pipe', 'bi pipe', 'black iron pipe', 'galvanized iron pipe', 'tubo gi'], ['PLUMBING'],
                ['BLACK IRON AND HOT-DIPPED GALVANIZED IRON LONGITUDINALLY WELDED STEEL PIPES', 'PNS 26:2018', 'DAO 19-16:2019', 'Pipes intended for ordinary use in steam, water, gas and air lines, but is not intended for close coiling or bending, or high temperature service.', ['Trademark of manufacturer or brand name', 'Type of pipe (B.I. or G.I.)', 'Class of pipe (heavy or light gauge)', 'Length, m', 'Nominal diameter', 'Product of the Philippines', 'Country of origin (if imported)', 'Color codes on both ends: blue heavy gauge, red light gauge', 'PS Mark with License number', 'Batch or serial number traceable to the date of manufacture']]],
            ['CERAMIC_TILE', 'Ceramic tile', 'FLOORING_MATERIALS', 'BOX', ['BOX', 'SQM', 'PC'], ['tile', 'tiles', 'ceramic tile', 'floor tile', 'wall tile', 'baldosa'], ['FLOORING', 'FINISHING'],
                ['CERAMIC TILES', 'PNS 13006:2019', 'DAO 20-09:2020', 'Ceramic Tiles produced via extrusion or dry pressing', ['Tradename or brandname', 'Trademark', 'Name and address of manufacturer and importer', 'Country of origin', 'Nominal and work sizes', 'Water absorption range', 'Method of shaping', 'Group and subgroup', 'Nature of surface', 'Intended use', 'Reference to appropriate annex', 'Total number of tiles per box', 'Lot/Batch number', 'PS Mark with License number for PS License holders']]],
            ['PLYWOOD', 'Plywood', 'WOOD_AND_LUMBER', 'SHEET', ['SHEET'], ['plywood', 'marine plywood', 'ordinary plywood', 'playwood'], ['INTERIOR'],
                ['PLYWOOD', 'PNS 12465:2017', 'DAO 20-06:2020', 'For general and construction use in dry, tropical dry/humid, and high humidity/exterior conditions', ['Trade name or brand name', 'Trademark', 'Name and address of manufacturer and importer', 'Country of origin', 'Plywood type (softwood or hardwood)', 'Bonding class (1, 2, or 3)', 'Thickness in mm', 'Formaldehyde emission FE and star rating', 'Lot/Batch or serial number', 'PS Mark with License number']]],
            ['SANITARY_WARE', 'Sanitary ware', 'SANITARY_FIXTURES', 'PC', ['PC'], ['toilet bowl', 'water closet', 'inidoro', 'lavatory', 'urinal', 'bidet', 'sink', 'shower base'], ['PLUMBING'],
                ['SANITARY WARES', 'PNS 156:2010; PNS 2085:2011', 'DAO 21-08:2021', 'Bidets, Lavatories, Shower Bases, Sinks (Laboratory, laundry, service, utility), Urinals, and Water Closet', ['Permanent: tradename or trademark; brandname and/or model number on the bottom or unglazed portion; water level mark', 'Water consumption labels', "Manufacturer's name or registered trademark", 'Address of the manufacturer', "Importer's name and address", 'Type/model number', '"Made in the Philippines" or country of manufacture for imported', 'Lot/Batch number', 'PS Mark with License Number (for PS License holders)']]],
            ['LOW_CARBON_STEEL_WIRE', 'Low carbon steel wire', 'FASTENERS_AND_HARDWARE', 'KG', ['KG', 'COIL'], ['tie wire', 'alambre', 'gi wire', 'annealed wire', 'steel wire'], ['STRUCTURAL'],
                ['LOW CARBON STEEL WIRES', 'PNS 113:2005', 'DAO 04:2008 / DAO 05:2008', 'plain wire, annealed wire, and zinc-coated (galvanized) wires and not intended for structural applications', ['Name and address of manufacturer', 'Name and address of importer (if imported)', 'Wire type (plain, annealed, zinc-coated)', 'Zinc-coating mass (Class 1, 2, 3, or 4)', 'Process (electrolytic or hot-dipped galvanized)', 'Wire diameter, mm', 'Net weight per coil, kg', 'Date of manufacture', 'Country of origin']]],
            ['STEEL_WIRE_NAIL', 'Steel wire nail', 'FASTENERS_AND_HARDWARE', 'KG', ['KG', 'BOX'], ['nail', 'pako', 'common nail', 'wire nail', 'finishing nail'], ['STRUCTURAL'],
                ['STEEL WIRE NAILS', 'PNS 136:2000', 'DAO 04:2008 / DAO 05:2008 / DAO 15-01:2015', 'Finishing nails', ['Type of nail (I or II)', 'Brand name or logo', 'Length and diameter, in mm', 'Net weight (25 kg)', 'Name and address of manufacturer', 'Year and date of manufacture', 'Lot / Batch Number', 'PS Quality Mark with License Number (for PS license holders) or ICC Sticker (for imported)']]],
            ['PB_PIPE', 'Polybutylene pipe for potable water', 'PLUMBING_AND_SANITARY', 'PC', ['PC', 'M', 'ROLL'], ['pb pipe', 'polybutylene pipe'], ['PLUMBING', 'POTABLE_WATER'],
                ['POLYBUTYLENE (PB) PIPES FOR POTABLE WATER SUPPLY', 'PNS 152:1987', 'DAO 04:2008 / DAO 05:2008', 'PB Pipes SDR 9/11/13.5/17', ['"PB" polymer identification', '"PW" meaning potable water', 'Class number', 'Nominal size in mm', 'Manufacturer/Trademark', '"Made in the Philippines/PHL"', 'Batch identification including month, day, year and shift number']]],
            ['PE_PIPE', 'Polyethylene pipe for potable water', 'PLUMBING_AND_SANITARY', 'PC', ['PC', 'M', 'ROLL'], ['pe pipe', 'hdpe pipe', 'polyethylene pipe'], ['PLUMBING', 'POTABLE_WATER'],
                ['POLYETHYLENE (PE) PIPES FOR POTABLE WATER SUPPLY', 'PNS ISO 4427:2002 Amd. 01:2002', 'DAO 04:2008 / DAO 05:2008', 'PE 100/80/63/60/32 SDR 9/11/13.6/17', ['Manufacturer/Trademark', 'Dimensions (nominal outside diameter x nominal wall thickness)', 'Outside diameter tolerance (A or B)', 'Designation of the pipe material', 'Nominal pressure (PN)', 'Pipe series (S or SDR, optional)', 'Production period (date or code)', 'Number of standard', '"Water" if intended for drinking water']]],
            ['UPVC_POTABLE_PIPE', 'uPVC pipe for potable water', 'PLUMBING_AND_SANITARY', 'PC', ['PC'], ['pvc', 'pvc pipe', 'upvc pipe', 'tubo', 'blue pipe'], ['PLUMBING', 'POTABLE_WATER'],
                ['UNPLASTICIZED POLYVINYL CHLORIDE (uPVC) PIPES FOR POTABLE WATER SUPPLY', 'PNS 65:1993', 'DAO 04:2008 / DAO 05:2008', 'uPVC pipes series 5/7/8/10', ['Name of the product', 'Nominal outside diameter in mm', 'Series and/or nominal pressure, MPa', 'Manufacturer/Trademark', '"Made in Philippines/PHL"', '"For Potable Water"']]],
            ['UPVC_ELECTRICAL_CONDUIT', 'uPVC electrical conduit', 'ELECTRICAL_SUPPLIES', 'PC', ['PC'], ['conduit', 'pvc conduit', 'electrical conduit', 'orange pipe'], ['ELECTRICAL'],
                ['UNPLASTICIZED POLYVINYL CHLORIDE (uPVC) Electrical Conduit', 'PNS 14:1983 Amd. 01:1987', 'DAO 04:2008 / DAO 05:2008', 'Thick wall and thin wall pipes', ['Name of the product', 'Application (electrical conduit/thin wall or thick wall)', 'Nominal outside diameter in mm', 'Manufacturer/Trademark', '"Made in Philippines/PHL"']]],
            ['PVC_U_SOIL_WASTE_PIPE', 'PVC-U soil and waste discharge pipe', 'DRAINAGE_AND_SEPTIC', 'PC', ['PC'], ['sanitary pipe', 'drain pipe', 'pvc sanitary pipe', 'orange sanitary pipe', 'soil pipe'], ['DRAINAGE', 'PLUMBING'],
                ['PLASTIC PIPING SYSTEM FOR SOIL AND WASTE DISCHARGE (LOW AND HIGH TEMPERATURE) INSIDE BUILDINGS - UNPLASTICIZED POLYVINYL CHLORIDE (PVC-U)', 'PNS 1950:2003 Corrigendum 01:2003', 'DAO 04:2008 / DAO 05:2008', 'uPVC Pipes for Sanitary Applications', ['Number of standard (PNS 1950)', 'Manufacturer/Trademark', 'Nominal size', 'Minimum wall thickness', 'Material (PVC-U)', "Manufacturer's information: production period (year and month) and production site name or code"]]],
            // Unregulated reference materials used for ordinary listings and comparability.
            ['THHN_WIRE', 'THHN building wire', 'ELECTRICAL_SUPPLIES', 'M', ['M', 'ROLL'], ['thhn', 'electrical wire', 'kawad', 'building wire', 'thhn wire'], ['ELECTRICAL'], null],
            ['CONCRETE_HOLLOW_BLOCK', 'Concrete hollow block', 'MASONRY', 'PC', ['PC'], ['chb', 'hollow block', 'hollow blocks', 'concrete hollow block'], ['MASONRY_WORK'], null],
            ['WASHED_SAND', 'Washed sand', 'AGGREGATES', 'CUM', ['CUM', 'BAG'], ['sand', 'buhangin', 'washed sand'], ['BULK', 'MASONRY_WORK'], null],
            ['GRAVEL', 'Crushed gravel', 'AGGREGATES', 'CUM', ['CUM', 'BAG'], ['gravel', 'graba', 'crushed gravel', 'aggregate'], ['BULK', 'FOUNDATION'], null],
            ['LATEX_PAINT', 'Latex paint', 'PAINTS_AND_FINISHES', 'GAL', ['GAL', 'L'], ['latex paint', 'pintura', 'acrylic latex paint'], ['FINISHING', 'INTERIOR', 'EXTERIOR'], null],
        ];
        foreach ($materials as [$code, $name, $categoryCode, $unitCode, $compatible, $aliases, $tagCodes, $rule]) {
            $materialId = $this->upsert('materials', ['code' => $code], [
                'material_category_id' => DB::table('material_categories')->where('code', $categoryCode)->value('id'),
                'name' => $name, 'normalized_name' => mb_strtolower($name), 'canonical_unit_id' => DB::table('units')->where('code', $unitCode)->value('id'),
                'regulated' => $rule !== null, 'active' => true,
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
            if ($rule !== null) {
                [$product, $standard, $regulation, $scope, $marking] = $rule;
                $this->upsert('regulated_material_rules', ['material_id' => $materialId, 'version' => 1], [
                    'required_marking' => 'PS_OR_ICC', 'source_reference' => self::SOURCE, 'effective_from' => '2026-01-01', 'effective_to' => null,
                    'product_name' => $product, 'reference_standard' => $standard, 'technical_regulation' => $regulation, 'scope' => $scope,
                    'marking_requirements' => json_encode($marking, JSON_THROW_ON_ERROR),
                ]);
            }
        }
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

    public function down(): void
    {
        // Reference taxonomy may already be referenced by listings, orders and compliance history.
    }
};
