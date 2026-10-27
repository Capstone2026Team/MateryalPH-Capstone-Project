import type { ProjectedGeoShape } from './geo-map-geometry'

export type GeoMapLabel = { code: string; name: string; lines: string[]; x: number; y: number; anchor: [number, number]; fontSize: number; width: number; height: number }

function nameLines(name: string): string[] {
  const short = name.match(/\((NCR|CAR|NIR|BARMM)\)$/)?.[1] ?? name.replace(/^Region [IVX]+(?:-[AB])? \((.*)\)$/, '$1').replace(/^City of /, '').replace(/ City$/, '')
  const lines: string[] = []
  for (const word of short.split(/\s+/).flatMap(word => word.match(/.{1,16}/g) ?? [])) {
    if (lines.length && `${lines[lines.length - 1]} ${word}`.length <= 16) lines[lines.length - 1] += ` ${word}`
    else lines.push(word)
  }
  return lines
}

/** Fit names without overlap; moved names retain a leader to their own polygon. Coordinates use SVG units. */
export function layoutGeoLabels(shapes: ProjectedGeoShape[], names: Map<string, string>, viewBox: string, pixelsPerUnit: number, focusedCode: string | null): GeoMapLabel[] {
  const [left = 0, top = 0, width = 600, height = 640] = viewBox.split(' ').map(Number)
  const fontSize = 11 / Math.max(0.1, pixelsPerUnit), gap = fontSize * 0.6
  const labels: GeoMapLabel[] = []
  const ordered = shapes.filter(shape => names.has(shape.code)).sort((a, b) => a.code === focusedCode ? -1 : b.code === focusedCode ? 1 : (b.bounds[2] - b.bounds[0]) * (b.bounds[3] - b.bounds[1]) - (a.bounds[2] - a.bounds[0]) * (a.bounds[3] - a.bounds[1]))
  for (const shape of ordered) {
    const name = names.get(shape.code)!, lines = nameLines(name)
    const labelWidth = Math.max(...lines.map(line => line.length)) * fontSize * 0.57, labelHeight = lines.length * fontSize * 1.25
    let placed = false
    for (let step = 0; step < 12 && !placed; step++) {
      const offsets = step === 0 ? [[0, 0]] : [[0, -step], [0, step], [-step, 0], [step, 0], [-step, -step], [step, step], [-step, step], [step, -step]]
      for (const [dx = 0, dy = 0] of offsets) {
        const x = Math.max(left + labelWidth / 2 + gap, Math.min(left + width - labelWidth / 2 - gap, shape.labelPoint[0] + dx * fontSize * 2))
        const y = Math.max(top + labelHeight / 2 + gap, Math.min(top + height - labelHeight / 2 - gap, shape.labelPoint[1] + dy * fontSize * 1.5))
        if (labels.some(label => Math.abs(label.x - x) < (label.width + labelWidth) / 2 + gap && Math.abs(label.y - y) < (label.height + labelHeight) / 2 + gap)) continue
        labels.push({ code: shape.code, name, lines, x, y, anchor: shape.labelPoint, fontSize, width: labelWidth, height: labelHeight })
        placed = true
        break
      }
    }
  }
  return labels
}
