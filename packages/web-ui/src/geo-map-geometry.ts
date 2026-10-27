import type { GeoFeature } from './geo-analytics-patterns'

type Point = [number, number]
export type ProjectedGeoShape = { code: string; path: string; bounds: [number, number, number, number]; labelPoint: Point }

function signedArea(ring: Point[]): number {
  return ring.reduce((sum, [x, y], index) => { const next = ring[(index + 1) % ring.length]!; return sum + x * next[1] - next[0] * y }, 0) / 2
}

function inside(point: Point, ring: Point[]): boolean {
  let hit = false
  for (let i = 0, j = ring.length - 1; i < ring.length; j = i++) {
    const a = ring[i]!, b = ring[j]!
    if ((a[1] > point[1]) !== (b[1] > point[1]) && point[0] < (b[0] - a[0]) * (point[1] - a[1]) / (b[1] - a[1]) + a[0]) hit = !hit
  }
  return hit
}

/** Place a name on the largest land polygon, avoiding concave coastlines and interior holes. */
function labelAnchor(rings: Point[][]): Point {
  const largest = rings.reduce((best, ring) => Math.abs(signedArea(ring)) > Math.abs(signedArea(best)) ? ring : best)
  const area = signedArea(largest)
  let x = 0, y = 0
  for (let index = 0; index < largest.length; index++) {
    const a = largest[index]!, b = largest[(index + 1) % largest.length]!
    const cross = a[0] * b[1] - b[0] * a[1]
    x += (a[0] + b[0]) * cross; y += (a[1] + b[1]) * cross
  }
  const centroid: Point = [x / (6 * area), y / (6 * area)]
  const onLand = (point: Point) => rings.reduce((hit, ring) => inside(point, ring) ? !hit : hit, false)
  if (Number.isFinite(centroid[0]) && Number.isFinite(centroid[1]) && onLand(centroid)) return centroid
  let left = Infinity, right = -Infinity, top = Infinity, bottom = -Infinity
  for (const [px, py] of largest) { left = Math.min(left, px); right = Math.max(right, px); top = Math.min(top, py); bottom = Math.max(bottom, py) }
  let best: Point = largest[0]!, distance = Infinity
  for (let row = 1; row < 12; row++) for (let col = 1; col < 12; col++) {
    const point: Point = [left + (right - left) * col / 12, top + (bottom - top) * row / 12]
    const delta = Math.hypot(point[0] - (left + right) / 2, point[1] - (top + bottom) / 2)
    if (delta < distance && onLand(point)) { best = point; distance = delta }
  }
  return best
}

function rings(geometry: unknown): Point[][] {
  if (!geometry || typeof geometry !== 'object') return []
  const { type, coordinates } = geometry as { type?: string; coordinates?: unknown }
  if (!Array.isArray(coordinates)) return []
  const polygons: unknown[] = type === 'Polygon' ? [coordinates] : type === 'MultiPolygon' ? coordinates : []
  return polygons.flatMap(polygon => !Array.isArray(polygon) ? [] : polygon.flatMap(ring => {
    if (!Array.isArray(ring)) return []
    const points: Point[] = ring.filter((point): point is Point => Array.isArray(point) && point.length >= 2 && typeof point[0] === 'number' && typeof point[1] === 'number' && Number.isFinite(point[0]) && Number.isFinite(point[1]) && Math.abs(point[0]) <= 180 && Math.abs(point[1]) < 85)
    return points.length >= 3 ? [points] : []
  }))
}

/** Mercator projection fitted to public boundary geometry; never accepts or plots marketplace point locations. */
export function projectGeoFeatures(features: GeoFeature[], width = 600, height = 640): ProjectedGeoShape[] {
  const projected = features.map(feature => ({ code: feature.properties.code, rings: rings(feature.geometry).map(ring => ring.map(([lng, lat]): Point => [lng * Math.PI / 180, -Math.log(Math.tan(Math.PI / 4 + lat * Math.PI / 360))])) }))
  const points = projected.flatMap(feature => feature.rings.flat())
  if (points.length === 0) return []
  let left = Infinity, right = -Infinity, top = Infinity, bottom = -Infinity
  for (const [x, y] of points) { left = Math.min(left, x); right = Math.max(right, x); top = Math.min(top, y); bottom = Math.max(bottom, y) }
  const scale = Math.min((width - 48) / Math.max(right - left, 0.000001), (height - 48) / Math.max(bottom - top, 0.000001))
  const offsetX = (width - (right - left) * scale) / 2, offsetY = (height - (bottom - top) * scale) / 2
  return projected.filter(feature => feature.rings.length > 0).map(feature => {
    let minX = Infinity, minY = Infinity, maxX = -Infinity, maxY = -Infinity
    const fitted = feature.rings.map(ring => ring.map(([x, y]): Point => [(x - left) * scale + offsetX, (y - top) * scale + offsetY]))
    const path = fitted.map(ring => ring.map(([px, py], index) => {
      minX = Math.min(minX, px); maxX = Math.max(maxX, px); minY = Math.min(minY, py); maxY = Math.max(maxY, py)
      return `${index ? 'L' : 'M'}${px.toFixed(1)},${py.toFixed(1)}`
    }).join('') + 'Z').join('')
    return { code: feature.code, path, bounds: [minX, minY, maxX, maxY], labelPoint: labelAnchor(fitted) }
  })
}

/** Fits the outline itself rather than retaining empty canvas margins, regardless of the panel's aspect ratio. */
export function geoShapeViewBox(shapes: ProjectedGeoShape[], padding = 20): string {
  if (shapes.length === 0) return '0 0 600 640'
  let left = Infinity, top = Infinity, right = -Infinity, bottom = -Infinity
  for (const shape of shapes) {
    left = Math.min(left, shape.bounds[0]); top = Math.min(top, shape.bounds[1])
    right = Math.max(right, shape.bounds[2]); bottom = Math.max(bottom, shape.bounds[3])
  }
  return [left - padding, top - padding, Math.max(1, right - left) + padding * 2, Math.max(1, bottom - top) + padding * 2].map(value => value.toFixed(1)).join(' ')
}
