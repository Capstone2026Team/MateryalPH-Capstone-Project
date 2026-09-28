import type { DeliveryVehicleDraft } from '@materyalph/web-ui'
import { emptyDeliveryVehicle } from '@materyalph/web-ui'
import type { FleetVehicle, FleetVehicleInput, VendorSetupDraftVehiclesInner } from '@materyalph/api-client-ts'

export function pesosToCentavos(value: string): number | null {
  if (!/^\d+(?:\.\d{1,2})?$/.test(value.trim())) return null
  const [whole, fractional = ''] = value.trim().split('.')
  const result = Number(whole) * 100 + Number(fractional.padEnd(2, '0'))
  return Number.isSafeInteger(result) && result <= 1000000000 ? result : null
}

export function vehiclePayload(vehicle: DeliveryVehicleDraft): VendorSetupDraftVehiclesInner {
  if (vehicle.id && !vehicle.active) return { id: vehicle.id, active: false }
  const base = pesosToCentavos(vehicle.baseFee)
  const perKm = pesosToCentavos(vehicle.perKm)
  if (base === null || perKm === null) throw new Error('Enter valid delivery rates in pesos with up to two decimal places.')
  if (!vehicle.category || !vehicle.type || !vehicle.name.trim() || !vehicle.heavy || !vehicle.imageId) throw new Error('Complete the vehicle category, type, name, image and heavy-vehicle classification.')
  return {
    ...(vehicle.id ? { id: vehicle.id } : {}), vehicleCategory: vehicle.category as NonNullable<VendorSetupDraftVehiclesInner['vehicleCategory']>, vehicleType: vehicle.type,
    customTypeName: vehicle.type === 'CUSTOM' ? vehicle.customType.trim() : null, name: vehicle.name.trim(), brand: vehicle.brand.trim() || null,
    capacityKg: Number(vehicle.weight), numberAvailable: Number(vehicle.count), active: vehicle.active,
    mixerCapacityM3: vehicle.type === 'CONCRETE_MIXER' ? Number(vehicle.mixer) : null,
    cargoLengthM: vehicle.type === 'CONCRETE_MIXER' ? null : Number(vehicle.length),
    cargoWidthM: vehicle.type === 'CONCRETE_MIXER' ? null : Number(vehicle.width),
    cargoHeightM: vehicle.type === 'CONCRETE_MIXER' ? null : Number(vehicle.height),
    heavyClassification: vehicle.heavy, baseFeeCentavos: base, perKmCentavos: perKm, imageFileId: vehicle.imageId,
  }
}

export function vehicleDraft(row: Record<string, unknown>): DeliveryVehicleDraft {
  const value = (key: string) => row[key] === null || row[key] === undefined ? '' : String(row[key])
  const fee = (key: string) => typeof row[key] === 'number' ? (row[key] / 100).toFixed(2) : ''
  return { ...emptyDeliveryVehicle(), ...(value('id') ? { id: value('id') } : {}), category: value('vehicleCategory'), type: value('vehicleType'), customType: value('customTypeName'), name: value('name'), brand: value('brand'), count: value('numberAvailable'), weight: value('capacityKg'), mixer: value('mixerCapacityM3'), length: value('cargoLengthM'), width: value('cargoWidthM'), height: value('cargoHeightM'), heavy: value('heavyClassification'), baseFee: fee('baseFeeCentavos'), perKm: fee('perKmCentavos'), imageId: value('imageFileId'), active: row.active !== false }
}

/** Operational fleet row from the saved configuration, including its optimistic version. */
export function fleetVehicleDraft(row: FleetVehicle): DeliveryVehicleDraft {
  const text = (value: number | string | null | undefined) => value === null || value === undefined ? '' : String(value)
  const fee = (value: number | null | undefined) => typeof value === 'number' ? (value / 100).toFixed(2) : ''
  return {
    ...emptyDeliveryVehicle(), id: row.id, lockVersion: row.lockVersion, category: text(row.vehicleCategory), type: row.vehicleType, customType: text(row.customTypeName),
    name: row.name, brand: text(row.brand), count: text(row.numberAvailable), weight: text(row.capacityKg), mixer: text(row.mixerCapacityM3),
    length: text(row.cargoLengthM), width: text(row.cargoWidthM), height: text(row.cargoHeightM), heavy: text(row.heavyClassification),
    baseFee: fee(row.baseFeeCentavos), perKm: fee(row.perKmCentavos), maxDistance: text(row.maximumDistanceKm), imageId: text(row.imageFileId),
    active: row.active, available: row.available, removed: false,
  }
}

export function fleetVehiclePayload(vehicle: DeliveryVehicleDraft): FleetVehicleInput {
  const version = vehicle.id ? { id: vehicle.id, lockVersion: vehicle.lockVersion ?? 0 } : {}
  if (vehicle.removed) return { ...version, removed: true }
  const mixer = vehicle.type === 'CONCRETE_MIXER'
  const number = (value: string) => value.trim() === '' ? null : Number(value)
  return {
    ...version, vehicleCategory: (vehicle.category || null) as NonNullable<FleetVehicleInput['vehicleCategory']> | null, vehicleType: vehicle.type || null,
    customTypeName: vehicle.type === 'CUSTOM' ? vehicle.customType.trim() : null, name: vehicle.name.trim(), brand: vehicle.brand.trim() || null,
    imageFileId: vehicle.imageId || null, numberAvailable: Number(vehicle.count), capacityKg: Number(vehicle.weight),
    mixerCapacityM3: mixer ? number(vehicle.mixer) : null, cargoLengthM: mixer ? null : number(vehicle.length), cargoWidthM: mixer ? null : number(vehicle.width), cargoHeightM: mixer ? null : number(vehicle.height),
    heavyClassification: (vehicle.heavy || null) as NonNullable<FleetVehicleInput['heavyClassification']> | null, active: vehicle.active, available: vehicle.available,
    baseFeeCentavos: pesosToCentavos(vehicle.baseFee) ?? -1, perKmCentavos: pesosToCentavos(vehicle.perKm) ?? -1, maximumDistanceKm: Number(vehicle.maxDistance),
  }
}

/** Maps backend field keys (vehicles.{index}.{field}) to draft field names. */
export const fleetFieldNames: Record<string, keyof DeliveryVehicleDraft> = {
  vehicle_category: 'category', vehicle_type: 'type', custom_type_name: 'customType', name: 'name', brand: 'brand', image_file_id: 'imageId', number_available: 'count',
  capacity_kg: 'weight', mixer_capacity_m3: 'mixer', cargo_length_m: 'length', cargo_width_m: 'width', cargo_height_m: 'height', heavy_classification: 'heavy',
  base_fee_centavos: 'baseFee', per_km_centavos: 'perKm', maximum_distance_km: 'maxDistance',
}

export function vehicleErrors(vehicle: DeliveryVehicleDraft, operational = false): Record<string, string> {
  const errors: Record<string, string> = {}
  if (operational && vehicle.removed) return errors
  if (operational) {
    const distance = Number(vehicle.maxDistance)
    if (!Number.isInteger(distance) || distance < 1 || distance > 1000) errors.maxDistance = 'Enter a whole number of kilometers from 1 to 1,000.'
  }
  if (!operational && vehicle.id && !vehicle.active) return errors
  for (const [field, label] of [['category', 'Vehicle Category'], ['type', 'Vehicle Type'], ['name', 'Vehicle Name'], ['heavy', 'Heavy Vehicle Classification'], ['imageId', 'Vehicle Image']] as const) if (!vehicle[field].trim()) errors[field] = `${label} is required.`
  if (vehicle.type === 'CUSTOM' && !vehicle.customType.trim()) errors.customType = 'Enter a custom vehicle type.'
  for (const field of ['weight', 'count', ...(vehicle.type === 'CONCRETE_MIXER' ? ['mixer'] : ['length', 'width', 'height'])] as const) {
    const value = Number(vehicle[field as keyof DeliveryVehicleDraft])
    if (!Number.isFinite(value) || value <= 0 || (field === 'count' && !Number.isInteger(value))) errors[field] = field === 'count' ? 'Enter a positive whole number.' : 'Enter a positive capacity or dimension.'
  }
  for (const field of ['baseFee', 'perKm'] as const) if (pesosToCentavos(vehicle[field]) === null) errors[field] = 'Enter pesos with up to two decimal places.'
  return errors
}
