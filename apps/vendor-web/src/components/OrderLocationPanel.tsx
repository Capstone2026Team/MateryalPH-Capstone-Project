import { AsyncLoading } from '@materyalph/web-ui'
import { useEffect, useState } from 'react'
import { Navigation } from 'lucide-react'
import { Button, DeliveryRouteMap, StatusMessage, formatManilaDateTime } from '@materyalph/web-ui'
import { getOrderRoute, readableOrderError, type OrderDetail } from '../lib/orders-api'

/** Shared by the order drawer and full order; only saved order locations are used. */
export function OrderLocationPanel({ order }: { order: OrderDetail }) {
  const delivery = order.fulfillmentMethod === 'DELIVERY'
  const store = order.locationMap?.store ?? null
  const dropOff = delivery ? order.locationMap?.destination ?? null : null
  const address = delivery
    ? (order.destination?.heavyVehicleRestriction === 'YES' ? order.destination.alternateDropOff : order.destination?.intended)?.formattedAddress
    : order.destination?.storeAddress
  const scope = JSON.stringify([order.id, store, dropOff])
  const [result, setResult] = useState<{ scope: string; route?: Awaited<ReturnType<typeof getOrderRoute>>; error?: string } | null>(null)
  const [attempt, setAttempt] = useState(0)
  const route = result?.scope === scope ? result.route : null
  const error = result?.scope === scope ? result.error : null
  useEffect(() => {
    let active = true
    if (!delivery || !store || !dropOff) return
    setResult(null)
    void getOrderRoute(order.id).then(route => {
      if (!active) return
      const matches = route.origin.latitude === store.latitude && route.origin.longitude === store.longitude
        && route.destination.latitude === dropOff.latitude && route.destination.longitude === dropOff.longitude
      setResult(matches ? { scope, route } : { scope, error: 'The store or drop-off location changed. Reload the order to update the map.' })
    }).catch(async cause => {
      const error = await readableOrderError(cause)
      if (active) setResult({ scope, error })
    })
    return () => { active = false }
  }, [order.id, delivery, scope, store, dropOff, attempt])
  const target = dropOff ?? (!delivery ? store : null)
  const query = target ? `${target.latitude},${target.longitude}` : address
  const navigation = query ? delivery
    ? `https://www.google.com/maps/dir/?api=1&${store ? `origin=${store.latitude},${store.longitude}&` : ''}destination=${encodeURIComponent(query)}&travelmode=driving`
    : `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(query)}` : null

  return <div className="grid min-w-0 gap-4">
    <DeliveryRouteMap stackAddresses origin={store} destination={dropOff} encodedPolyline={route?.encodedPolyline ?? ''} browserKey={import.meta.env.VITE_GOOGLE_MAPS_BROWSER_KEY ?? ''}
      mapLabel={delivery ? 'Order delivery map' : 'Order pickup map'} originLabel={delivery ? 'Registered store' : 'Pickup at your store'}
      destinationLabel={order.destination?.heavyVehicleRestriction === 'YES' ? 'Actual vehicle drop-off (heavy-vehicle restriction)' : 'Delivery destination'} />
    {!store && !delivery && <p className="break-words text-sm leading-6">Buyer collects at your store{address ? `: ${address}` : ''}.</p>}
    {!dropOff && delivery && <div className="text-sm"><p className="font-semibold">{order.destination?.heavyVehicleRestriction === 'YES' ? 'Actual vehicle drop-off (heavy-vehicle restriction)' : 'Delivery destination'}</p><p className="break-words">{(order.destination?.heavyVehicleRestriction === 'YES' ? order.destination.alternateDropOff : order.destination?.intended)?.label}</p><p className="break-words leading-6 text-text-secondary">{address ?? 'The delivery address is unavailable.'}</p></div>}
    {delivery && order.destination?.heavyVehicleRestriction === 'YES' && order.destination.intended && <div className="grid gap-1 text-sm"><p className="font-semibold">Intended destination / Project site</p><p className="break-words leading-6 text-text-secondary">{order.destination.intended.formattedAddress ?? order.destination.intended.label}</p></div>}
    {delivery && store && dropOff && (route ? <div className="grid gap-1 border-t border-border-default pt-3"><p className="text-sm font-semibold tabular-nums">{(route.distanceMeters / 1000).toFixed(1)} km · {Math.ceil(route.durationSeconds / 60)} min estimated drive</p><p className="text-xs leading-5 text-text-secondary">Google Routes estimate · {formatManilaDateTime(route.computedAt)}</p></div>
      : error ? <StatusMessage tone="error">{error}<Button variant="quiet" onClick={() => setAttempt(value => value + 1)}>Retry route</Button></StatusMessage>
        : <AsyncLoading compact label="Loading driving estimate…" />)}
    {order.destination?.accessInstructions && <div className="grid gap-1 text-sm"><p className="font-semibold">Access instructions</p><p className="whitespace-pre-wrap break-words leading-6 text-text-secondary">{order.destination.accessInstructions}</p></div>}
    {navigation && <a className="inline-flex min-h-11 w-fit items-center gap-2 text-sm font-semibold text-action-primary underline-offset-4 hover:underline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring" href={navigation} target="_blank" rel="noopener noreferrer"><Navigation size={16} aria-hidden="true" />{delivery ? 'Open directions' : 'Open in Google Maps'}</a>}
  </div>
}
