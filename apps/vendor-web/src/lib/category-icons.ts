import { Bath, BrickWall, Construction, DoorOpen, Droplets, Fan, Flame, FlaskConical, Hammer, House, LayoutGrid, Mountain, Package, Paintbrush, Trees, Truck, Umbrella, Wrench, Zap, type LucideIcon } from 'lucide-react'

/** The same category icons Buyers see on the Explore tiles in the MateryalPH app (buyer-mobile `categoryIcon`). */
export function categoryIcon(code: string | null | undefined): LucideIcon {
  switch (code) {
    case 'CEMENT_AND_CONCRETE': case 'MASONRY': return BrickWall
    case 'READY_MIXED_CONCRETE': return Truck
    case 'ROOFING_MATERIALS': return House
    case 'WOOD_AND_LUMBER': case 'LANDSCAPING_AND_EXTERIOR': return Trees
    case 'STEEL_AND_REINFORCEMENT': case 'FORMWORKS_AND_SCAFFOLDING': return Construction
    case 'TOOLS_AND_ACCESSORIES': case 'TOOLS_AND_EQUIPMENT': return Hammer
    case 'FASTENERS_AND_HARDWARE': return Wrench
    case 'ELECTRICAL_SUPPLIES': return Zap
    case 'PLUMBING_AND_SANITARY': case 'DRAINAGE_AND_SEPTIC': return Droplets
    case 'SANITARY_FIXTURES': return Bath
    case 'FIRE_PROTECTION': return Flame
    case 'PAINTS_AND_FINISHES': case 'FINISHING_MATERIALS': return Paintbrush
    case 'ADHESIVES_AND_SEALANTS': case 'CONSTRUCTION_CHEMICALS': return FlaskConical
    case 'DOORS_WINDOWS_AND_GLASS': return DoorOpen
    case 'HVAC_MATERIALS': return Fan
    case 'AGGREGATES': return Mountain
    case 'FLOORING_MATERIALS': case 'WALL_AND_CEILING': return LayoutGrid
    case 'INSULATION_AND_WATERPROOFING': return Umbrella
    default: return Package
  }
}
