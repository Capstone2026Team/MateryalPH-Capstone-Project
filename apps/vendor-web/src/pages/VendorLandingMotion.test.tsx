import { useScrollReveal } from '@materyalph/web-ui'
import { act, render, screen } from '@testing-library/react'
import { afterEach, expect, test, vi } from 'vitest'

function Content() {
  const ref = useScrollReveal()
  return <div ref={ref}><section data-mp-reveal="">First section</section><section data-mp-reveal="">Next section</section></div>
}

function motionEnvironment(reduced = false) {
  const preference = { matches: reduced, addEventListener: vi.fn(), removeEventListener: vi.fn() }
  vi.stubGlobal('matchMedia', vi.fn(() => preference))
  const observer = { observe: vi.fn(), unobserve: vi.fn(), disconnect: vi.fn() }
  let onIntersection: IntersectionObserverCallback = () => undefined
  const Observer = vi.fn(function (callback: IntersectionObserverCallback) {
    onIntersection = callback
    return observer
  })
  vi.stubGlobal('IntersectionObserver', Observer)
  return { preference, observer, Observer, intersect: (target: Element, isIntersecting: boolean) => {
    onIntersection([{ target, isIntersecting } as IntersectionObserverEntry], observer as unknown as IntersectionObserver)
  } }
}

afterEach(() => vi.unstubAllGlobals())

test('keeps content visible when motion is reduced or observation is unavailable', () => {
  const { Observer } = motionEnvironment(true)
  const first = render(<Content />)
  expect(screen.getByText('First section')).toHaveAttribute('data-mp-reveal', '')
  expect(Observer).not.toHaveBeenCalled()
  first.unmount()
  motionEnvironment()
  vi.stubGlobal('IntersectionObserver', undefined)
  render(<Content />)
  expect(screen.getByText('Next section')).toHaveAttribute('data-mp-reveal', '')
})

test('reveals entering sections once while leaving later sections ready for their turn', () => {
  const { intersect, observer } = motionEnvironment()
  render(<Content />)
  const first = screen.getByText('First section')
  const next = screen.getByText('Next section')
  expect(first).toHaveAttribute('data-mp-reveal', 'pending')
  act(() => intersect(first, false))
  expect(first).toHaveAttribute('data-mp-reveal', 'pending')
  act(() => intersect(first, true))
  expect(first).toHaveAttribute('data-mp-reveal', 'visible')
  expect(next).toHaveAttribute('data-mp-reveal', 'pending')
  expect(observer.unobserve).toHaveBeenCalledWith(first)
})

test('reveals all pending content immediately when reduced motion is enabled and cleans up on exit', () => {
  const { preference, observer } = motionEnvironment()
  const view = render(<Content />)
  preference.matches = true
  const onChange = preference.addEventListener.mock.calls[0]?.[1] as () => void
  act(onChange)
  expect(screen.getByText('First section')).toHaveAttribute('data-mp-reveal', 'visible')
  expect(screen.getByText('Next section')).toHaveAttribute('data-mp-reveal', 'visible')
  expect(observer.disconnect).toHaveBeenCalled()
  view.unmount()
  expect(preference.removeEventListener).toHaveBeenCalledWith('change', onChange)
})
