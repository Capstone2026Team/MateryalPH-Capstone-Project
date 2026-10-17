import { useEffect, useId, useMemo, useRef, useState, type KeyboardEvent, type ReactNode, type RefCallback } from 'react'
import { ArrowDown, ArrowUp, ArrowUpDown, ChevronRight, EyeOff, MapPinned } from 'lucide-react'
import { chartLeftInset, chartMinimumWidth, chartTicks } from './chart-layout'
import { loadGoogleMaps } from './google-maps'
import './geo-analytics.css'

/** A geographic area value as the map, legend and table share it. Null values are suppressed or unavailable. */
export type GeoAreaValue = { code: string; name: string; levelLabel: string; value: number | null; suppressed: boolean; drillable: boolean; note?: string | null }
export type GeoFeature = { type: 'Feature'; id?: string; properties: { code: string; name: string; level: string }; geometry: unknown }

const STEPS = 5

/** Equal-count bin edges over the visible (non-null) values; at most five bins, collapsing duplicate edges. */
export function choroplethThresholds(values: (number | null)[]): number[] {
  const sorted = values.filter((value): value is number => value !== null && Number.isFinite(value) && value > 0).sort((a, b) => a - b)
  if (sorted.length === 0) return []
  const edges: number[] = []
  for (let step = 1; step < STEPS; step++) {
    const edge = sorted[Math.min(sorted.length - 1, Math.floor((step * sorted.length) / STEPS))] ?? 0
    if (edges.length === 0 || edge > (edges[edges.length - 1] ?? 0)) edges.push(edge)
  }
  return edges
}

/** 0 = no activity, 1..5 = magnitude bins. */
export function choroplethBin(value: number | null, thresholds: number[]): number {
  if (value === null || value <= 0) return 0
  let bin = 1
  for (const edge of thresholds) if (value >= edge) bin++
  return Math.min(STEPS, bin)
}

const binFill = (bin: number) => (bin === 0 ? 'var(--mp-viz-empty)' : `var(--mp-viz-seq-${bin})`)

export function GeoBreadcrumbs({ items, onSelect }: { items: { code: string | null; name: string }[]; onSelect: (code: string | null) => void }) {
  return <nav aria-label="Geographic level" className="min-w-0">
    <ol className="flex min-w-0 flex-wrap items-center gap-1 text-sm">
      {items.map((item, index) => {
        const last = index === items.length - 1
        return <li key={item.code ?? 'PH'} className="flex min-w-0 items-center gap-1">
          {last ? <span aria-current="page" className="break-words font-semibold text-text-strong">{item.name}</span>
            : <button type="button" onClick={() => onSelect(item.code)} className="min-h-11 break-words rounded-control px-1 font-semibold text-action-primary underline underline-offset-4 focus-visible:outline-2 focus-visible:outline-focus-ring">{item.name}</button>}
          {!last && <ChevronRight size={16} aria-hidden="true" className="shrink-0 text-text-secondary" />}
        </li>
      })}
    </ol>
  </nav>
}

/** Legend with swatch and text for every bin, the empty state and the hatched suppressed state. */
export function ChoroplethLegend({ title, thresholds, formatValue }: { title: string; thresholds: number[]; formatValue: (value: number) => string }) {
  const ranges = [...thresholds.map((edge, index) => ({ bin: index + 1, label: index === 0 ? `Below ${formatValue(edge)}` : `${formatValue(thresholds[index - 1] ?? 0)} to below ${formatValue(edge)}` })),
    ...(thresholds.length ? [{ bin: thresholds.length + 1, label: `${formatValue(thresholds[thresholds.length - 1] ?? 0)} and above` }] : [{ bin: 1, label: 'Any recorded value' }])]
  return <figure className="mp-viz m-0 min-w-0">
    <figcaption className="text-[13px] font-semibold text-text-strong">{title}</figcaption>
    <ul className="mt-2 flex flex-wrap gap-x-4 gap-y-2 text-[13px] text-text-secondary">
      <li className="flex items-center gap-2"><span aria-hidden="true" className="h-4 w-6 rounded-sm border border-border-default" style={{ background: binFill(0) }} />No activity</li>
      {ranges.map(range => <li key={range.bin} className="flex items-center gap-2"><span aria-hidden="true" className="h-4 w-6 rounded-sm border border-border-default" style={{ background: binFill(range.bin) }} />{range.label}</li>)}
      <li className="flex items-center gap-2"><span aria-hidden="true" className="mp-viz-hatch h-4 w-6 rounded-sm border border-border-default" />Suppressed small cell</li>
    </ul>
  </figure>
}

type DataFeature = { getProperty: (name: string) => unknown }
type DataLayer = {
  addGeoJson: (json: unknown) => DataFeature[]
  forEach: (callback: (feature: DataFeature) => void) => void
  remove: (feature: DataFeature) => void
  setStyle: (style: (feature: DataFeature) => Record<string, unknown>) => void
  addListener: (event: string, handler: (event: { feature: DataFeature }) => void) => { remove: () => void }
  setMap: (map: unknown) => void
}
type MapsApi = { maps: { Map: new (element: HTMLElement, options: Record<string, unknown>) => { fitBounds: (bounds: unknown) => void }; Data: new () => DataLayer; LatLngBounds: new () => { extend: (point: unknown) => void; isEmpty: () => boolean } } }

/**
 * Drillable choropleth. With a browser key and imported boundaries it draws a Google Maps Data layer; areas without
 * geometry, and every area when the map is unavailable, are drawn as keyboard-operable tiles with the same colours,
 * text values and hatch. Colour never carries meaning alone: the focused area shows its exact value as text, and the
 * synchronized table offers the same selection without the map. No point data is ever placed on the map.
 */
export function GeoChoroplethMap({ browserKey, features, areas, thresholds, metricLabel, formatValue, focusedCode, selectedCode, onFocus, onSelect, missingCodes = [] }: {
  browserKey?: string | undefined; features: GeoFeature[]; areas: GeoAreaValue[]; thresholds: number[]; metricLabel: string; formatValue: (value: number) => string
  focusedCode: string | null; selectedCode: string | null; onFocus: (code: string | null) => void; onSelect: (area: GeoAreaValue) => void; missingCodes?: string[]
}) {
  const container = useRef<HTMLDivElement>(null)
  const root = useRef<HTMLDivElement>(null)
  const layer = useRef<DataLayer | null>(null)
  const callbacks = useRef({ onFocus, onSelect, areas })
  callbacks.current = { onFocus, onSelect, areas }
  const [state, setState] = useState<'tiles' | 'loading' | 'map'>(browserKey && features.length ? 'loading' : 'tiles')
  const statusId = useId()
  const byCode = useMemo(() => new Map(areas.map(area => [area.code, area])), [areas])
  const focused = focusedCode ? byCode.get(focusedCode) : undefined

  useEffect(() => {
    if (!browserKey || features.length === 0 || !container.current) { setState('tiles'); return }
    let active = true
    setState('loading')
    void loadGoogleMaps<MapsApi>(browserKey).then(google => {
      if (!active || !container.current) return
      const map = new google.maps.Map(container.current, { center: { lat: 12.8797, lng: 121.774 }, zoom: 5, gestureHandling: 'cooperative', streetViewControl: false, mapTypeControl: false, clickableIcons: false })
      const data = new google.maps.Data()
      data.addGeoJson({ type: 'FeatureCollection', features })
      data.setMap(map)
      data.addListener('click', event => { const area = callbacks.current.areas.find(item => item.code === String(event.feature.getProperty('code'))); if (area) callbacks.current.onSelect(area) })
      data.addListener('mouseover', event => callbacks.current.onFocus(String(event.feature.getProperty('code'))))
      data.addListener('mouseout', () => callbacks.current.onFocus(null))
      const bounds = new google.maps.LatLngBounds()
      const extend = (coordinates: unknown): void => {
        if (Array.isArray(coordinates) && typeof coordinates[0] === 'number') bounds.extend({ lng: coordinates[0], lat: coordinates[1] })
        else if (Array.isArray(coordinates)) coordinates.forEach(extend)
      }
      features.forEach(feature => extend((feature.geometry as { coordinates?: unknown }).coordinates))
      if (!bounds.isEmpty()) map.fitBounds(bounds)
      layer.current = data
      setState('map')
    }).catch(() => { if (active) setState('tiles') })
    return () => { active = false; layer.current?.setMap(null); layer.current = null }
  }, [browserKey, features])

  useEffect(() => {
    const data = layer.current
    if (!data || !root.current) return
    const styles = getComputedStyle(root.current)
    const color = (bin: number) => styles.getPropertyValue(bin === 0 ? '--mp-viz-empty' : `--mp-viz-seq-${bin}`).trim() || '#cccccc'
    const suppressed = styles.getPropertyValue('--mp-viz-suppressed').trim() || '#e5e7eb'
    data.setStyle(feature => {
      const area = byCode.get(String(feature.getProperty('code')))
      const isSelected = area?.code === selectedCode || area?.code === focusedCode
      return { fillColor: area?.suppressed ? suppressed : color(choroplethBin(area?.value ?? null, thresholds)), fillOpacity: 0.85, strokeColor: isSelected ? '#1f2937' : '#ffffff', strokeWeight: isSelected ? 3 : 1, clickable: true }
    })
  }, [byCode, thresholds, selectedCode, focusedCode, state])

  const tileAreas = state === 'map' ? areas.filter(area => missingCodes.includes(area.code)) : areas
  return <div ref={root} className="mp-viz grid min-w-0 gap-3">
    <div className="relative min-w-0">
      {(browserKey && features.length > 0) && <div ref={container} aria-label={`Map of ${metricLabel} by area. Use the table to select an area with the keyboard.`} role="region"
        className={`h-[420px] w-full overflow-hidden rounded-surface border border-border-default bg-surface-canvas ${state === 'map' ? '' : 'hidden'}`} />}
      {state === 'loading' && <p role="status" className="grid h-[420px] place-items-center rounded-surface border border-border-default bg-surface-canvas text-sm text-text-secondary">Loading the map…</p>}
    </div>
    <p id={statusId} role="status" aria-live="polite" className="min-h-11 rounded-control bg-surface-canvas px-4 py-3 text-sm text-text-strong">
      {focused ? <><span className="font-semibold">{focused.name}</span> · {focused.levelLabel}: {focused.suppressed ? `Suppressed small cell${focused.note ? `: ${focused.note}` : ''}` : focused.value === null ? 'No value' : `${formatValue(focused.value)} ${metricLabel.toLowerCase()}`}{focused.drillable ? ' · Select to drill down' : ''}</>
        : `Hover an area or focus a tile or table row to read its exact ${metricLabel.toLowerCase()}.`}
    </p>
    {state !== 'loading' && tileAreas.length > 0 && <div>
      {state === 'map' ? <p className="mb-2 text-[13px] text-text-secondary">Boundary geometry has not been imported for these areas; they are shown as tiles.</p>
        : <p className="mb-3 flex items-start gap-2 text-[13px] text-text-secondary"><MapPinned size={16} aria-hidden="true" className="mt-0.5 shrink-0" />{browserKey ? 'Imported boundaries are unavailable for this level, so areas are shown as tiles.' : 'The interactive map is not configured; areas are shown as tiles.'}</p>}
      <ul aria-label={`${metricLabel} by area`} className="mp-geo-tiles">
        {tileAreas.map(area => {
          const bin = choroplethBin(area.value, thresholds)
          const dark = !area.suppressed && bin >= 4
          return <li key={area.code} className="min-w-0">
            <button type="button" onClick={() => onSelect(area)} onFocus={() => onFocus(area.code)} onBlur={() => onFocus(null)} onMouseEnter={() => onFocus(area.code)} onMouseLeave={() => onFocus(null)}
              aria-pressed={area.code === selectedCode} aria-describedby={statusId}
              title={area.suppressed ? area.note ?? 'Suppressed small cell' : undefined}
              className={`${area.suppressed ? 'mp-viz-hatch ' : ''}mp-geo-tile flex h-full min-h-24 w-full min-w-0 flex-col justify-between gap-3 rounded-control border p-3 text-left focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring ${area.code === selectedCode ? 'border-text-strong ring-2 ring-text-strong' : 'border-border-default'}`}
              style={area.suppressed ? undefined : { background: binFill(bin), color: dark ? '#ffffff' : 'var(--mp-color-text-strong)' }}>
              <span className="break-words text-sm font-medium leading-5">{area.name}</span>
              <span className={`flex items-center justify-between gap-2 text-sm font-semibold tabular-nums ${area.suppressed ? 'text-text-strong' : ''}`}>
                <span className="inline-flex items-center gap-1.5">{area.suppressed && <EyeOff size={14} aria-hidden="true" className="shrink-0" />}{area.suppressed ? 'Suppressed' : area.value === null ? '—' : formatValue(area.value)}</span>
                {area.drillable && <ChevronRight size={16} aria-hidden="true" className="shrink-0" />}
              </span>
            </button>
          </li>
        })}
      </ul>
    </div>}
  </div>
}

export type SortableColumn<T> = { key: string; header: string; cell: (row: T) => ReactNode; sortValue?: (row: T) => number | string | null; numeric?: boolean; minWidth?: number }

/**
 * The accessible equivalent of the map: sortable headers with aria-sort, a selectable name button per row, and a
 * highlight that follows the map focus. Wide tables scroll inside their own region with a sticky header.
 */
export function SortableDataTable<T>({ caption, columns, rows, rowKey, focusedKey, selectedKey, onFocusRow, onSelectRow, rowLabel, initialSort }: {
  caption: string; columns: SortableColumn<T>[]; rows: T[]; rowKey: (row: T) => string; focusedKey?: string | null; selectedKey?: string | null
  onFocusRow?: (key: string | null) => void; onSelectRow?: (row: T) => void; rowLabel?: (row: T) => string; initialSort?: { key: string; direction: 'ascending' | 'descending' }
}) {
  const [sort, setSort] = useState(initialSort ?? null)
  const sorted = useMemo(() => {
    const column = columns.find(item => item.key === sort?.key)
    if (!sort || !column?.sortValue) return rows
    const factor = sort.direction === 'ascending' ? 1 : -1
    return [...rows].sort((a, b) => {
      const left = column.sortValue?.(a) ?? null, right = column.sortValue?.(b) ?? null
      if (left === right) return 0
      if (left === null) return 1
      if (right === null) return -1
      return (left < right ? -1 : 1) * factor
    })
  }, [rows, columns, sort])
  const [first, ...rest] = columns
  const columnWidth = (column: SortableColumn<T>, index: number) => column.minWidth ?? (index === 0 ? 224 : column.numeric ? 144 : 192)
  const minimumWidth = Math.max(720, columns.reduce((width, column, index) => width + columnWidth(column, index), 0))
  return <div role="region" aria-label={caption} tabIndex={0} className="min-w-0 max-h-[70vh] max-w-full overflow-auto rounded-surface border border-border-default bg-surface-primary focus-visible:outline-2 focus-visible:outline-focus-ring">
    <table className="mp-geo-table w-full border-separate border-spacing-0 text-left text-sm" style={{ minWidth: minimumWidth }}>
      <caption className="sr-only">{caption}. Column headers sort the table.</caption>
      <colgroup>{columns.map((column, index) => <col key={column.key} style={{ width: columnWidth(column, index) }} />)}</colgroup>
      <thead>
        <tr>{columns.map((column, index) => {
          const active = sort?.key === column.key
          const Icon = !active ? ArrowUpDown : sort?.direction === 'ascending' ? ArrowUp : ArrowDown
          return <th key={column.key} scope="col" aria-sort={active ? sort?.direction : 'none'} style={{ minWidth: columnWidth(column, index) }} className={`sticky top-0 border-b border-border-default bg-surface-canvas px-4 py-2 font-semibold text-text-strong ${index === 0 ? 'left-0 z-20 border-r' : 'z-10'} ${column.numeric ? 'text-right' : ''}`}>
            {column.sortValue ? <button type="button" onClick={() => setSort(active && sort?.direction === 'descending' ? { key: column.key, direction: 'ascending' } : { key: column.key, direction: 'descending' })}
              className={`inline-flex min-h-11 items-center gap-2 whitespace-nowrap rounded-control focus-visible:outline-2 focus-visible:outline-focus-ring ${column.numeric ? 'flex-row-reverse' : ''}`}>{column.header}<Icon size={14} aria-hidden="true" className="shrink-0" /></button> : column.header}
          </th>
        })}</tr>
      </thead>
      <tbody>
        {sorted.map(row => {
          const key = rowKey(row)
          const highlighted = key === focusedKey || key === selectedKey
          return <tr key={key} data-highlighted={highlighted || undefined} onMouseEnter={() => onFocusRow?.(key)} onMouseLeave={() => onFocusRow?.(null)}>
            {first && <th scope="row" className="sticky left-0 z-1 border-b border-r border-border-default px-4 py-3 text-left font-normal">
              {onSelectRow ? <button type="button" onClick={() => onSelectRow(row)} onFocus={() => onFocusRow?.(key)} onBlur={() => onFocusRow?.(null)} aria-label={rowLabel?.(row)}
                className="min-h-11 w-full rounded-control text-left font-semibold leading-5 text-action-primary underline underline-offset-4 focus-visible:outline-2 focus-visible:outline-focus-ring">{first.cell(row)}</button> : first.cell(row)}
            </th>}
            {rest.map(column => <td key={column.key} style={{ minWidth: column.minWidth }} className={`border-b border-border-default px-4 py-3 ${column.numeric ? 'whitespace-nowrap text-right tabular-nums' : ''}`}>{column.cell(row)}</td>)}
          </tr>
        })}
      </tbody>
    </table>
  </div>
}

/**
 * The width of a chart's frame in CSS pixels, so the SVG view box matches it and 11 px axis text stays 11 px at every
 * width instead of scaling with a wide panel. Falls back to the given width where ResizeObserver is unavailable.
 */
export function useMeasuredWidth(fallback: number, minimum = 480): [RefCallback<HTMLDivElement>, number] {
  const [frame, setFrame] = useState<HTMLDivElement | null>(null)
  const [width, setWidth] = useState(fallback)
  useEffect(() => {
    if (!frame || typeof ResizeObserver === 'undefined') return
    const observer = new ResizeObserver(entries => {
      const measured = Math.round(entries[0]?.contentRect.width ?? 0)
      if (measured > 0) setWidth(Math.max(minimum, measured))
    })
    observer.observe(frame)
    return () => observer.disconnect()
  }, [frame, minimum])
  return [setFrame, width]
}

const NICE_STEPS = [1, 1.2, 1.5, 2, 2.5, 3, 4, 5, 6, 8, 10]

/** The smallest round step × 10ⁿ at or above the value, so an axis reads 0, 10, 20 rather than 0, 8.8, 17.6. */
export function niceCeiling(value: number): number {
  if (!Number.isFinite(value) || value <= 0) return 1
  const magnitude = 10 ** Math.floor(Math.log10(value))
  const fraction = value / magnitude
  return (NICE_STEPS.find(step => fraction <= step + 1e-9) ?? 10) * magnitude
}

/** Categorical series slots, in the validated fixed order (never cycled; see geo-analytics.css). */
export type VizColor = '--mp-viz-series-1' | '--mp-viz-series-2' | '--mp-viz-series-3' | '--mp-viz-series-4' | '--mp-viz-series-5' | '--mp-viz-series-6'

export type TrendSeries = { key: string; label: string; colorVar: VizColor; values: (number | null)[]; kind?: 'line' | 'bar' }

/** A forecast continues the first series after the last label: a dashed line inside its 95% band. */
export type TrendForecast = { label: string; labels: string[]; values: number[]; lower: number[]; upper: number[] }

/** A labelled point of interest (for example an unusual day), by label index. */
export type TrendMarker = { index: number; label: string }

const LINE_DASHES = ['', '6 3', '2 3', '8 3 2 3', '8 3 2 3 2 3', '1 3']

/**
 * Multi-series chart on one axis (never dual-axis): lines, or one bar series with lines over it. Arrow keys, Home and
 * End move a crosshair; the focused bucket's exact values appear as text. Gaps mark suppressed or missing buckets and
 * are never drawn as zero. An optional forecast is drawn after the history as a dashed line inside a shaded 95% band,
 * in its own region identified by the legend, so an estimate is never mistaken for a recorded value. Markers and
 * series are named in the wrapping legend and in the focus text. Lines also have distinct dash patterns so identity
 * does not depend on colour; the caller renders the table view.
 */
export function TrendLineChart({ title, labels, series, formatValue, emptyReason, forecast, markers = [], formatLabel = (label: string) => label }: {
  title: string; labels: string[]; series: TrendSeries[]; formatValue: (value: number) => string; emptyReason: string
  forecast?: TrendForecast | null | undefined; markers?: TrendMarker[]; formatLabel?: (label: string) => string
}) {
  const summaryId = useId()
  const [focus, setFocus] = useState<number | null>(null)
  const [frame, measured] = useMeasuredWidth(720)
  const all = series.flatMap(item => item.values.filter((value): value is number => value !== null))
  if (labels.length === 0 || all.length === 0) return <p className="rounded-control border border-dashed border-border-default px-4 py-6 text-center text-sm text-text-secondary">{emptyReason}</p>
  const ahead = forecast && forecast.labels.length > 0 ? forecast : null
  const total = labels.length + (ahead?.labels.length ?? 0)
  const allLabels = [...labels, ...(ahead?.labels ?? [])]
  const high = niceCeiling(Math.max(...all, ...(ahead?.upper ?? []), 1) * 1.05)
  const ticks = [0, high / 2, high]
  const tickLabels = ticks.map(formatValue)
  const axisLabels = allLabels.map(formatLabel)
  const height = 240, left = chartLeftInset(tickLabels, 72), right = 24, top = 16, bottom = 36
  const minimumWidth = chartMinimumWidth(axisLabels, left, right)
  const width = Math.max(measured, minimumWidth)
  const plot = width - left - right
  const x = (index: number) => left + (total === 1 ? plot / 2 : (index * plot) / (total - 1))
  const y = (value: number) => top + (1 - value / high) * (height - top - bottom)
  const path = (values: (number | null)[]) => {
    let d = '', open = false
    values.forEach((value, index) => { if (value === null) { open = false; return } d += `${open ? 'L' : 'M'}${x(index).toFixed(1)},${y(value).toFixed(1)} `; open = true })
    return d
  }
  const dateTicks = chartTicks(axisLabels, left, width - right)
  const gaps = labels.filter((_, index) => series.every(item => item.values[index] === null)).length
  const band = plot / Math.max(1, total)
  const bars = series.filter(item => item.kind === 'bar')
  const lines = series.filter(item => item.kind !== 'bar')
  const lineDash = new Map(lines.map((item, index) => [item.key, LINE_DASHES[index % LINE_DASHES.length]]))
  const lead = series[0]
  const lastIndex = lead ? lead.values.reduce<number>((found, value, index) => (value === null ? found : index), -1) : -1
  const forecastPath = ahead && lead && lastIndex === labels.length - 1
    ? `M${x(lastIndex).toFixed(1)},${y(lead.values[lastIndex] ?? 0).toFixed(1)} ` + ahead.values.map((value, i) => `L${x(labels.length + i).toFixed(1)},${y(value).toFixed(1)}`).join(' ')
    : ahead ? ahead.values.map((value, i) => `${i === 0 ? 'M' : 'L'}${x(labels.length + i).toFixed(1)},${y(value).toFixed(1)}`).join(' ') : ''
  const bandPath = ahead ? ahead.upper.map((value, i) => `${i === 0 ? 'M' : 'L'}${x(labels.length + i).toFixed(1)},${y(value).toFixed(1)}`).join(' ')
    + ' ' + [...ahead.lower].reverse().map((value, i) => `L${x(labels.length + ahead.lower.length - 1 - i).toFixed(1)},${y(value).toFixed(1)}`).join(' ') + ' Z' : ''
  const markerAt = new Map(markers.map(marker => [marker.index, marker.label]))
  const move = (event: KeyboardEvent<SVGSVGElement>) => {
    const delta: Record<string, number> = { ArrowRight: 1, ArrowLeft: -1 }
    if (event.key === 'Home' || event.key === 'End') { event.preventDefault(); setFocus(event.key === 'Home' ? 0 : total - 1); return }
    if (!(event.key in delta)) return
    event.preventDefault()
    setFocus(current => Math.min(total - 1, Math.max(0, (current ?? 0) + (delta[event.key] ?? 0))))
  }
  const describe = (index: number) => {
    if (ahead && index >= labels.length) {
      const i = index - labels.length
      return `${formatLabel(ahead.labels[i] ?? '')}: ${ahead.label} ${formatValue(ahead.values[i] ?? 0)} (95% range ${formatValue(ahead.lower[i] ?? 0)} to ${formatValue(ahead.upper[i] ?? 0)})`
    }
    const marker = markerAt.get(index)
    return `${formatLabel(labels[index] ?? '')}: ${series.map(item => `${item.label} ${item.values[index] === null || item.values[index] === undefined ? 'suppressed or no value' : formatValue(item.values[index] ?? 0)}`).join('; ')}${marker ? ` · ${marker}` : ''}`
  }
  return <figure className="mp-viz m-0 min-w-0">
    <figcaption id={summaryId} className="sr-only">{title}: {series.map(item => item.label).join(' and ')} over {labels.length} periods; {gaps} suppressed or empty periods.{ahead ? ` Followed by a ${ahead.labels.length}-period ${ahead.label.toLowerCase()} with a 95% range.` : ''}{markers.length ? ` ${markers.length} marked periods.` : ''} Use the arrow keys to read exact values; the table lists every value.</figcaption>
    <ul className="mb-3 flex flex-wrap gap-x-4 gap-y-2 text-[13px] text-text-secondary">
      {series.map(item => <li key={item.key} className="flex min-w-0 max-w-full items-center gap-2">
        {item.kind === 'bar' ? <span aria-hidden="true" className="h-3 w-3 shrink-0 rounded-sm" style={{ background: `var(${item.colorVar})` }} />
          : <svg width="28" height="12" viewBox="0 0 28 12" aria-hidden="true" className="shrink-0"><line x1="0" x2="28" y1="6" y2="6" stroke={`var(${item.colorVar})`} strokeWidth={2} strokeDasharray={lineDash.get(item.key)} /></svg>}
        <span className="min-w-0 break-words">{item.label}</span></li>)}
      {ahead && <li className="flex min-w-0 max-w-full items-center gap-2"><span aria-hidden="true" className="mp-viz-forecast-swatch h-3 w-5 shrink-0" /><span className="min-w-0 break-words">{ahead.label} (95% range)</span></li>}
      {markers.length > 0 && <li className="flex min-w-0 max-w-full items-center gap-2"><span aria-hidden="true" className="h-2.5 w-2.5 shrink-0 rotate-45 border-2 border-text-strong bg-surface-primary" /><span className="min-w-0 break-words">Marked period</span></li>}
    </ul>
    <div ref={frame} className="overflow-x-auto">
      <svg viewBox={`0 0 ${width} ${height}`} role="img" aria-labelledby={summaryId} tabIndex={0} onKeyDown={move} onBlur={() => setFocus(null)} onMouseLeave={() => setFocus(null)}
        style={{ minWidth: minimumWidth }} className="h-auto w-full rounded-control focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring">
        {ahead && <rect x={x(labels.length) - band / 2} y={top} width={x(total - 1) - x(labels.length) + band} height={height - top - bottom} fill="var(--mp-viz-forecast-region)" />}
        {ticks.map((tick, index) => <g key={tick}><line x1={left} x2={width - right} y1={y(tick)} y2={y(tick)} stroke="var(--mp-viz-grid)" strokeWidth={1} />
          <text x={left - 8} y={y(tick) + 4} textAnchor="end" fontSize={11} fill="var(--mp-color-text-secondary)">{tickLabels[index]}</text></g>)}
        {dateTicks.map(tick => <text key={tick.index} x={tick.x} y={height - 12} textAnchor={tick.textAnchor} fontSize={11} fill="var(--mp-color-text-secondary)">{tick.label}</text>)}
        {bars.map((item, b) => item.values.map((value, index) => value === null || value <= 0 ? null : <rect key={`${item.key}-${index}`} x={x(index) - (band * 0.6) / 2 + (b * band * 0.6) / Math.max(1, bars.length)}
          y={y(value)} width={Math.max(1, (band * 0.6) / Math.max(1, bars.length) - 1)} height={Math.max(0, y(0) - y(value))} rx={Math.min(2, band * 0.15)} fill={`var(${item.colorVar})`} />))}
        {ahead && <path d={bandPath} fill="var(--mp-viz-forecast-band)" stroke="none" />}
        {ahead && <path d={forecastPath} fill="none" stroke="var(--mp-color-text-strong)" strokeWidth={2} strokeDasharray="5 4" strokeLinejoin="round" strokeLinecap="round" />}
        {lines.map(item => <path key={item.key} d={path(item.values)} fill="none" stroke={`var(${item.colorVar})`} strokeWidth={2} strokeDasharray={lineDash.get(item.key)} strokeLinejoin="round" strokeLinecap="round" />)}
        {markers.map(marker => { const value = lead?.values[marker.index]; return value === null || value === undefined ? null
          : <rect key={`marker-${marker.index}`} x={x(marker.index) - 5} y={y(value) - 5} width={10} height={10} transform={`rotate(45 ${x(marker.index)} ${y(value)})`} fill="var(--mp-color-surface-primary)" stroke="var(--mp-color-text-strong)" strokeWidth={2} /> })}
        {allLabels.map((label, index) => <rect key={`hit-${label}-${index}`} x={x(index) - band / 2} y={top} width={band} height={height - top - bottom} fill="transparent" onMouseEnter={() => setFocus(index)} />)}
        {focus !== null && <g pointerEvents="none"><line x1={x(focus)} x2={x(focus)} y1={top} y2={height - bottom} stroke="var(--mp-color-text-secondary)" strokeDasharray="3 3" />
          {focus < labels.length ? lines.map(item => item.values[focus] === null || item.values[focus] === undefined ? null : <circle key={`dot-${item.key}`} cx={x(focus)} cy={y(item.values[focus] ?? 0)} r={4} fill={`var(${item.colorVar})`} stroke="var(--mp-color-surface-primary)" strokeWidth={2} />)
            : ahead && <circle cx={x(focus)} cy={y(ahead.values[focus - labels.length] ?? 0)} r={4} fill="var(--mp-color-surface-primary)" stroke="var(--mp-color-text-strong)" strokeWidth={2} />}</g>}
      </svg>
    </div>
    <p role="status" aria-live="polite" className="mt-2 min-h-11 text-sm text-text-strong">{focus === null ? 'Hover the chart or focus it and use the arrow keys to read exact values.' : describe(focus)}</p>
  </figure>
}

export type HeatmapCell = { value: number | string | null; suppressed: boolean; reason?: string | null }

/** Demand heatmap as a table: every cell shows its value as text over a one-hue fill; suppressed cells are hatched. */
export function DemandHeatmap({ caption, columns, rows, formatValue }: { caption: string; columns: { id: string; name: string }[]; rows: { code: string; name: string; cells: HeatmapCell[] }[]; formatValue: (value: number) => string }) {
  const numeric = rows.flatMap(row => row.cells.map(cell => (cell.value === null ? null : Number(cell.value))))
  const thresholds = choroplethThresholds(numeric)
  if (columns.length === 0) return <p className="rounded-control border border-dashed border-border-default px-4 py-6 text-center text-sm text-text-secondary">No confirmed demand matches these filters.</p>
  return <div role="region" aria-label={caption} tabIndex={0} className="mp-viz max-w-full overflow-auto rounded-surface border border-border-default bg-surface-primary focus-visible:outline-2 focus-visible:outline-focus-ring">
    <table className="w-full min-w-[640px] border-separate border-spacing-0.5 text-sm">
      <caption className="sr-only">{caption}</caption>
      <thead><tr><th scope="col" className="sticky left-0 bg-surface-canvas px-3 py-2 text-left font-semibold">Area</th>{columns.map(column => <th key={column.id} scope="col" className="bg-surface-canvas px-3 py-2 text-left font-semibold">{column.name}</th>)}</tr></thead>
      <tbody>{rows.map(row => <tr key={row.code}><th scope="row" className="sticky left-0 bg-surface-primary px-3 py-2 text-left font-semibold">{row.name}</th>
        {row.cells.map((cell, index) => {
          const value = cell.value === null ? null : Number(cell.value)
          const bin = choroplethBin(value, thresholds)
          return <td key={columns[index]?.id ?? index} title={cell.reason ?? undefined} className={`${cell.suppressed ? 'mp-viz-hatch ' : ''}rounded-sm px-3 py-2 text-right tabular-nums`}
            style={cell.suppressed ? undefined : { background: binFill(bin), color: bin >= 4 ? '#ffffff' : 'var(--mp-color-text-strong)' }}>
            {cell.suppressed ? <span className="inline-flex items-center gap-1 font-semibold text-text-strong"><EyeOff size={14} aria-hidden="true" />Suppressed</span> : value === null ? '—' : formatValue(value)}
          </td>
        })}</tr>)}</tbody>
    </table>
  </div>
}
