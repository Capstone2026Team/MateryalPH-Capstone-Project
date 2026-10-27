import { expect, test } from 'vitest'
import { geoShapeViewBox, projectGeoFeatures } from '../../../../packages/web-ui/src/geo-map-geometry'
import regions from '../../../../packages/web-ui/src/geography/philippines-regions.json'
import type { GeoFeature } from '@materyalph/web-ui'
import { referenceContext, type ReferenceBoundary } from '../../../../packages/web-ui/src/geo-reference-boundaries'
import { layoutGeoLabels } from '../../../../packages/web-ui/src/geo-map-labels'

test('the pinned national reference covers 18 unique PSGC regions, including NIR and BARMM', () => {
  expect(regions.features).toHaveLength(18)
  const codes = regions.features.map(feature => feature.properties.code)
  expect(new Set(codes).size).toBe(18)
  expect(codes.every(code => /^\d{2}00000000$/.test(code))).toBe(true)
  expect(codes).toContain('1800000000')
  expect(codes).toContain('1900000000')
  const shapes = projectGeoFeatures(regions.features.map(feature => ({ ...feature, type: 'Feature' as const })))
  expect(shapes).toHaveLength(18)
  for (const shape of shapes) {
    expect(shape.path).not.toMatch(/NaN|Infinity/)
    const coordinates = [...shape.path.matchAll(/[ML]([\d.]+),([\d.]+)/g)]
    expect(coordinates.length).toBeGreaterThan(3)
    for (const point of coordinates) {
      expect(Number(point[1])).toBeGreaterThanOrEqual(0)
      expect(Number(point[1])).toBeLessThanOrEqual(600)
      expect(Number(point[2])).toBeGreaterThanOrEqual(0)
      expect(Number(point[2])).toBeLessThanOrEqual(640)
    }
  }
})

test('projection preserves polygon holes and safely omits unsupported or malformed geometry', () => {
  const feature = (code: string, geometry: unknown): GeoFeature => ({ type: 'Feature', properties: { code, name: code, level: 'REGION' }, geometry })
  const result = projectGeoFeatures([
    feature('valid', { type: 'Polygon', coordinates: [[[120, 10], [122, 10], [122, 12], [120, 10]], [[120.5, 10.5], [121, 10.5], [121, 11], [120.5, 10.5]]] }),
    feature('point', { type: 'Point', coordinates: [120, 10] }),
    feature('invalid', { type: 'Polygon', coordinates: [[[Infinity, 10], [120, NaN], ['120', 10]]] }),
  ])
  expect(result.map(shape => shape.code)).toEqual(['valid'])
  expect(result[0]!.path.match(/Z/g)).toHaveLength(2)
  expect(projectGeoFeatures([])).toEqual([])
})

test('regional framing contains the entire selected outline without the national canvas margins', () => {
  const ncr = regions.features.find(feature => feature.properties.code === '1300000000')!
  const shapes = projectGeoFeatures([{ ...ncr, type: 'Feature' }])
  const [x, y, width, height] = geoShapeViewBox(shapes).split(' ').map(Number)
  expect(width! / height!).toBeLessThan(0.8)
  for (const shape of shapes) {
    expect(x).toBeLessThan(shape.bounds[0])
    expect(y).toBeLessThan(shape.bounds[1])
    expect(x! + width!).toBeGreaterThan(shape.bounds[2])
    expect(y! + height!).toBeGreaterThan(shape.bounds[3])
  }
})

test('local reference files retain every region and valid province/city borders, including all 17 NCR localities', () => {
  const collections = import.meta.glob<{ features: ReferenceBoundary[] }>('../../../../packages/web-ui/src/geography/subregions/*.json', { eager: true, import: 'default' })
  expect(Object.keys(collections)).toHaveLength(18)
  for (const region of regions.features) {
    const collection = Object.entries(collections).find(([path]) => path.endsWith(`/${region.properties.code}.json`))![1]
    const codes = collection.features.map(feature => feature.properties.code)
    expect(new Set(codes).size).toBe(codes.length)
    expect(codes.every(code => /^\d{10}$/.test(code))).toBe(true)
    expect(collection.features.every(feature => feature.properties.regionCode === region.properties.code)).toBe(true)
    expect(projectGeoFeatures(collection.features)).toHaveLength(collection.features.length)
    const context = referenceContext(collection.features, region.properties.code)
    expect(context.length).toBeGreaterThan(0)
    if (region.properties.code === '1300000000') {
      expect(context).toHaveLength(17)
      expect(context.some(feature => feature.properties.name === 'Pateros')).toBe(true)
    }
    const province = collection.features.find(feature => feature.properties.level === 'PROVINCE')
    if (province) {
      const cities = referenceContext(collection.features, province.properties.code)
      expect(cities.length).toBeGreaterThan(0)
      expect(cities.every(feature => feature.properties.provinceCode === province.properties.code)).toBe(true)
      expect(referenceContext(collection.features, cities[0]!.properties.code)).toEqual([])
    }
  }
})

test('geographic labels stay readable and separated on narrow maps, with the focused area prioritized', () => {
  const shapes = projectGeoFeatures(regions.features.map(feature => ({ ...feature, type: 'Feature' as const })))
  const viewBox = geoShapeViewBox(shapes)
  const [, , width = 600] = viewBox.split(' ').map(Number)
  const names = new Map(regions.features.map(feature => [feature.properties.code, feature.properties.name]))
  const labels = layoutGeoLabels(shapes, names, viewBox, 230 / width, '1300000000')
  expect(labels[0]!.code).toBe('1300000000')
  expect(labels.length).toBe(18)
  expect(labels[0]!.lines).toEqual(['NCR'])
  for (const label of labels) {
    expect(label.fontSize * 230 / width).toBeCloseTo(11)
    expect(label.name).toBe(names.get(label.code))
    for (const other of labels.filter(item => item.code !== label.code)) {
      expect(Math.abs(other.x - label.x) >= (other.width + label.width) / 2 || Math.abs(other.y - label.y) >= (other.height + label.height) / 2).toBe(true)
    }
  }
})

test('name anchors avoid a polygon hole', () => {
  const shape = projectGeoFeatures([{ type: 'Feature', properties: { code: 'sample', name: 'Sample', level: 'PROVINCE' }, geometry: { type: 'Polygon', coordinates: [[[120, 10], [122, 10], [122, 12], [120, 12], [120, 10]], [[120.5, 10.5], [121.5, 10.5], [121.5, 11.5], [120.5, 11.5], [120.5, 10.5]]] } }])[0]!
  const [minX, minY, maxX, maxY] = shape.bounds
  expect(shape.labelPoint[0]).toBeGreaterThan(minX)
  expect(shape.labelPoint[0]).toBeLessThan(maxX)
  expect(shape.labelPoint[1]).toBeGreaterThan(minY)
  expect(shape.labelPoint[1]).toBeLessThan(maxY)
  expect(Math.abs(shape.labelPoint[0] - (minX + maxX) / 2) > (maxX - minX) * 0.24 || Math.abs(shape.labelPoint[1] - (minY + maxY) / 2) > (maxY - minY) * 0.24).toBe(true)
})
