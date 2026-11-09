import { useEffect, useRef, useState } from 'react'
import type { DeliveryVehicleProfile } from '@materyalph/api-client-ts'
import { CircleCheck, Truck } from 'lucide-react'
import { vehicleTypes } from './delivery-vehicles'

/** Same vehicle presentation for recommendations and immutable order arrangements. */
export function DeliveryVehicleCard({ profile, name, status, imageScope, loadImage, vehicles, trips }: {
  profile?: DeliveryVehicleProfile | null | undefined; name?: string | null; status: string; imageScope: string
  loadImage?: (id: string) => Promise<Blob | string>; vehicles?: number | undefined; trips?: number | undefined
}) {
  const [preview, setPreview] = useState<{ url: string; failed: boolean }>({ url: '', failed: false })
  const [attempt, setAttempt] = useState(0)
  const reader = useRef(loadImage)
  reader.current = loadImage
  const imageId = profile?.imageFileId
  useEffect(() => {
    let active = true
    let objectUrl = ''
    setPreview({ url: '', failed: false })
    if (imageId && reader.current) void reader.current(imageId).then(value => {
      const url = typeof value === 'string' ? value : (objectUrl = URL.createObjectURL(value))
      if (active) setPreview({ url, failed: false })
      else if (objectUrl) URL.revokeObjectURL(objectUrl)
    }).catch(() => { if (active) setPreview({ url: '', failed: true }) })
    return () => { active = false; if (objectUrl) URL.revokeObjectURL(objectUrl) }
  }, [imageId, imageScope, attempt])
  const title = profile?.name || name || 'Delivery vehicle'
  const type = profile?.vehicleType === 'CUSTOM' ? profile.customTypeName : Object.values(vehicleTypes).flat().find(item => item.value === profile?.vehicleType)?.label ?? profile?.vehicleType?.replaceAll('_', ' ')
  const number = (value: string) => Number(value).toLocaleString('en-PH', { maximumFractionDigits: 4 })
  const dimensions = [profile?.cargoLengthM, profile?.cargoWidthM, profile?.cargoHeightM]
  const details = [
    profile?.capacityKg ? `${number(profile.capacityKg)} kg payload` : null,
    profile?.mixerCapacityM3 ? `${number(profile.mixerCapacityM3)} m³ mixer` : dimensions.every(Boolean) ? `${dimensions.map(value => number(value!)).join(' × ')} m cargo` : null,
    profile?.heavyClassification === 'HEAVY' ? 'Heavy vehicle' : profile?.heavyClassification === 'NOT_HEAVY' ? 'Not a heavy vehicle' : null,
  ].filter(Boolean)
  return <span className="flex min-w-0 flex-1 flex-wrap items-start gap-3 text-sm">
    <span className="flex h-20 w-28 shrink-0 items-center justify-center overflow-hidden rounded-control border border-border-default bg-surface-canvas">
      {preview.url ? <img src={preview.url} alt={`${title} vehicle photo`} className="h-full w-full object-contain" onError={() => setPreview({ url: '', failed: true })} /> : <Truck size={28} className="text-text-secondary" aria-label={imageId ? 'Vehicle photo loading or unavailable' : 'Vehicle photo not recorded'} />}
    </span>
    <span className="grid min-w-0 flex-1 basis-40 gap-1">
      <span className="break-words font-semibold text-text-strong">{title}</span>
      {(type || profile?.brand) && <span className="break-words text-xs text-text-secondary">{[type, profile?.brand].filter(Boolean).join(' · ')}</span>}
      {details.length > 0 && <span className="break-words text-xs text-text-secondary">{details.join(' · ')}</span>}
      {(vehicles !== undefined || trips !== undefined) && <span className="text-xs text-text-secondary">{vehicles !== undefined ? `${vehicles} vehicle${vehicles === 1 ? '' : 's'}` : ''}{vehicles !== undefined && trips !== undefined ? ' · ' : ''}{trips !== undefined ? `${trips} trip${trips === 1 ? '' : 's'}` : ''}</span>}
      <span className="flex items-center gap-1.5 text-xs font-semibold"><CircleCheck size={14} className="shrink-0" aria-hidden="true" />{status}</span>
      {preview.failed && <button type="button" className="min-h-11 justify-self-start text-xs font-semibold underline" onClick={event => { event.preventDefault(); event.stopPropagation(); setAttempt(value => value + 1) }}>Retry vehicle photo</button>}
    </span>
  </span>
}
