import { useEffect, useRef } from 'react'

import './landing-motion.css'

const motionQuery = '(prefers-reduced-motion: reduce)'

/** Enhances marked content once; unsupported browsers and reduced motion keep it visible. */
export function useScrollReveal() {
  const root = useRef<HTMLDivElement>(null)
  useEffect(() => {
    const preference = window.matchMedia?.(motionQuery)
    if (!root.current || !preference || preference.matches || !window.IntersectionObserver) return
    const elements = root.current.querySelectorAll<HTMLElement>('[data-mp-reveal]')
    const observer = new IntersectionObserver(entries => {
      for (const entry of entries) {
        if (!entry.isIntersecting) continue
        entry.target.setAttribute('data-mp-reveal', 'visible')
        observer.unobserve(entry.target)
      }
    }, { threshold: 0.1, rootMargin: '0px 0px -40px 0px' })
    elements.forEach(element => { element.dataset.mpReveal = 'pending'; observer.observe(element) })
    const revealAll = () => {
      if (!preference.matches) return
      observer.disconnect()
      elements.forEach(element => { element.dataset.mpReveal = 'visible' })
    }
    preference.addEventListener('change', revealAll)
    return () => {
      observer.disconnect()
      preference.removeEventListener('change', revealAll)
      elements.forEach(element => { element.dataset.mpReveal = 'visible' })
    }
  }, [])
  return root
}

