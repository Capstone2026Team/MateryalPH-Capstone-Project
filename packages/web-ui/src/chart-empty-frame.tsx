import './geo-analytics.css'

/** A neutral chart frame, without invented observations, totals or axis values. */
export function ChartEmptyFrame({ title, reason, variant = 'line', plotHeight }: { title: string; reason: string; variant?: 'line' | 'area' | 'bar' | 'donut' | 'scatter' | 'horizontal' | 'heatmap'; plotHeight?: number }) {
  const timeSeries = variant === 'line' || variant === 'area' || variant === 'bar'
  return <figure className="mp-viz mp-viz-muted m-0 min-w-0" data-chart-empty={variant}>
    {timeSeries && <div aria-hidden="true" className="mb-3 h-11" />}
    <svg viewBox={variant === 'donut' ? '0 0 320 180' : '0 0 480 208'} role="img" aria-label={`${title}: ${reason}`} className="w-full" style={{ height: plotHeight ?? (variant === 'donut' ? 144 : timeSeries ? 176 : 208) }} preserveAspectRatio={timeSeries ? 'none' : 'xMidYMid meet'}>
      {variant === 'donut' ? <circle cx={160} cy={90} r={64} fill="none" stroke="var(--mp-viz-placeholder)" strokeWidth={18} />
        : variant === 'horizontal' ? <g fill="var(--mp-viz-placeholder)">{[24, 64, 104, 144].map(y => <rect key={y} x={24} y={y} width={432} height={12} rx={4} />)}</g>
          : variant === 'heatmap' ? <g fill="var(--mp-viz-placeholder)">{Array.from({ length: 24 }, (_, index) => <rect key={index} x={24 + index % 6 * 73} y={16 + Math.floor(index / 6) * 40} width={65} height={32} rx={3} />)}</g>
            : <g>
              {[12, 66, 120, 176].map(y => <line key={y} x1={48} x2={464} y1={y} y2={y} stroke="var(--mp-viz-grid)" strokeDasharray={y === 176 ? undefined : '3 4'} />)}
              <line x1={48} x2={48} y1={12} y2={176} stroke="var(--mp-viz-grid)" />
              {variant === 'bar' ? <g fill="var(--mp-viz-placeholder)">{Array.from({ length: 10 }, (_, index) => <rect key={index} x={60 + index * 40} y={12} width={24} height={164} rx={3} />)}</g>
                : variant !== 'scatter' && <line x1={48} x2={464} y1={176} y2={176} stroke="var(--mp-viz-muted-ink)" strokeWidth={2} strokeDasharray="5 5" />}
            </g>}
    </svg>
    <figcaption className="mt-2 min-h-5 text-center text-xs leading-5 text-text-secondary">{reason}</figcaption>
  </figure>
}
