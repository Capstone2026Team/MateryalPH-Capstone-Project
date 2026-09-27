import type { DeliveryVehicleDraft } from '@materyalph/web-ui'
import { emptyDeliveryVehicle } from '@materyalph/web-ui'
import type { VendorSetupDraftVehiclesInner } from '@materyalph/api-client-ts'

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

export function vehicleErrors(vehicle: DeliveryVehicleDraft): Record<string, string> {
  const errors: Record<string, string> = {}
  if (vehicle.id && !vehicle.active) return errors
  for (const [field, label] of [['category', 'Vehicle Category'], ['type', 'Vehicle Type'], ['name', 'Vehicle Name'], ['heavy', 'Heavy Vehicle Classification'], ['imageId', 'Vehicle Image']] as const) if (!vehicle[field].trim()) errors[field] = `${label} is required.`
  if (vehicle.type === 'CUSTOM' && !vehicle.customType.trim()) errors.customType = 'Enter a custom vehicle type.'
  for (const field of ['weight', 'count', ...(vehicle.type === 'CONCRETE_MIXER' ? ['mixer'] : ['length', 'width', 'height'])] as const) {
    const value = Number(vehicle[field as keyof DeliveryVehicleDraft])
    if (!Number.isFinite(value) || value <= 0 || (field === 'count' && !Number.isInteger(value))) errors[field] = field === 'count' ? 'Enter a positive whole number.' : 'Enter a positive capacity or dimension.'
  }
  for (const field of ['baseFee', 'perKm'] as const) if (pesosToCentavos(vehicle[field]) === null) errors[field] = 'Enter pesos with up to two decimal places.'
  return errors
}
