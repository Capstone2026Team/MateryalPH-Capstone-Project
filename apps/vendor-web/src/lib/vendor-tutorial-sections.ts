import type { WalkthroughStep } from '@materyalph/web-ui'
import { vendorSectionHelp, type VendorGuide } from './vendor-tutorial-catalog'
import { explainVendorTopic } from './vendor-tutorial-copy'

export type VendorGuideChapter = { guide: VendorGuide; tab?: string; fallback?: boolean }
export const guideSelector = '[data-vendor-guide-target]'
let sequence = 0

export function guideElementVisible(element: Element): boolean {
  return !element.closest('dialog, [hidden], [aria-hidden="true"], .sr-only, details:not([open]) > :not(summary)') && element.getClientRects().length > 0 && getComputedStyle(element).visibility !== 'hidden'
}

function label(element: Element): string {
  const copy = element.cloneNode(true) as Element
  for (const child of copy.querySelectorAll('[aria-hidden="true"], .sr-only, .tabular-nums')) child.remove()
  for (const child of copy.querySelectorAll('span')) if (/^[\d,.]+$/.test(child.textContent?.trim() ?? '')) child.remove()
  return (element.getAttribute('aria-label') || copy.textContent || '').replace(/\s+/g, ' ').trim()
}

export function findGuideTab(name: string, list?: string): HTMLButtonElement | undefined {
  const main = document.getElementById('main-content')
  if (!main) return
  const named = [...main.querySelectorAll('[role="tablist"], nav[aria-label]')].find(element => element.getAttribute('aria-label') === list)
  const candidates = (named ?? main).querySelectorAll<HTMLButtonElement>('button[role="tab"], button[aria-pressed]')
  return [...candidates].find(element => guideElementVisible(element) && label(element) === name)
}

/** Read only semantic UI labels/purposes, never record values, private evidence or form contents. */
export function collectVendorGuideSteps(guide: VendorGuide, chapter?: string, windowRoot?: HTMLElement): WalkthroughStep[] {
  const main = windowRoot ?? document.getElementById('main-content')
  if (!main) return []
  const steps: WalkthroughStep[] = []
  const elements = new Set<Element>()
  const titles = new Set<string>()
  const stamp = String(++sequence)
  const visible = (element: Element) => windowRoot
    ? !element.closest('[hidden], [aria-hidden="true"], .sr-only, details:not([open]) > :not(summary)') && element.getClientRects().length > 0 && getComputedStyle(element).visibility !== 'hidden'
    : guideElementVisible(element)
  function add(element: Element | null | undefined, title: string, description: string | undefined) {
    if (!element || !title || !description || elements.has(element) || titles.has(title) || !visible(element)) return
    elements.add(element); titles.add(title)
    const id = `${stamp}-${steps.length}`
    element.setAttribute('data-vendor-guide-target', id)
    steps.push({ id: `${guide.id}-${id}`, target: `[data-vendor-guide-target="${id}"]`, title, description })
  }
  const tracking = guide.id === 'tracking'
  const trackingIntroduction = !chapter || chapter === guide.chapters?.[0]
  const trackingTarget = tracking && chapter ? (chapter === 'Statistics' ? findGuideTab(chapter, guide.tabList) : main.querySelector(`section[aria-label="${chapter}"]`)) : null
  add(trackingTarget ?? [...main.querySelectorAll('h1, h2, header')].find(visible) ?? main.querySelector('.chat-sidebar-heading'), chapter ? `${guide.label} · ${chapter}` : guide.label,
    chapter ? explainVendorTopic(guide, chapter) ?? guide.description : guide.description)

  if (tracking) {
    const picker = main.querySelector('.team-tracking-sidebar')
    if (trackingIntroduction) {
      add(picker?.querySelector('h2'), 'Your team', explainVendorTopic(guide, 'Your team'))
      for (const [index, field] of [...picker?.querySelectorAll('label') ?? []].entries()) {
        const title = index === 0 ? 'Find a team member' : 'Current role'
        add(field, title, explainVendorTopic(guide, title))
      }
      add(picker?.querySelector('a[href="/team"]'), 'Manage accounts', explainVendorTopic(guide, 'Manage accounts'))
    }
    // No member is selected: there are no statistics or history to explain yet.
    if (!main.querySelector('.team-tracking-workspace[data-tutorial-member-selected="true"]')) return steps
    if (trackingIntroduction) add(main.querySelector('.team-tracking-panel > header'), 'Selected team member', explainVendorTopic(guide, 'Selected team member'))
  }

  // Preserve the page's reading order, including every rendered metric, chart and section.
  const candidates = main.querySelectorAll<HTMLElement>('[role="tablist"], nav[aria-label], form[role="search"], .mp-dashboard-panel, .mp-metric-card, section[aria-label], [role="region"][aria-label], h2, h3, table, .chat-sidebar, .chat-thread')
  for (const element of candidates) {
    if (!visible(element) || element.closest('[data-vendor-tutorial-ui]')) continue
    if (element.matches('.team-tracking-panel, .team-tracking-body')) continue
    if (tracking && (element.closest('.team-tracking-sidebar') || !trackingIntroduction && element.matches('nav[aria-label="Tracking views"]'))) continue
    // Repeated records are user content, not platform features. A table inside an explained panel adds no new step.
    if (element.closest('li, tbody, .mp-product-listing, .mp-invoice-list-items, .chat-message') || element.matches('table') && element.closest('.mp-dashboard-panel, .mp-finance-breakdown, [role="region"][aria-label]')) continue
    if (element.matches('h2, h3') && element.closest('.mp-invoice-sheet, .chat-thread, .team-tracking-panel') && !vendorSectionHelp[label(element)]) continue
    if (element.matches('h2, h3') && element.closest('.mp-dashboard-panel, .mp-metric-card')) continue
    const metric = element.matches('.mp-metric-card')
    const heading = element.matches('h2, h3') ? element : element.querySelector(':scope > header h2, :scope > header h3, :scope > h2, :scope > h3')
    const title = metric ? element.querySelector('.mp-kpi-label > span')?.textContent?.trim() ?? ''
      : element.getAttribute('aria-label') || (element.matches('.chat-thread') ? 'Conversation and quotations' : element.matches('.chat-sidebar') ? 'Conversation inbox' : heading ? label(heading) : '') || (element.matches('table') ? element.querySelector('caption')?.textContent?.trim() || 'Results table' : '')
    if (!title || ['Workspace sections', chapter].includes(title)) continue
    // A chapter wrapper is a container, not an additional graph. Its children are explained separately.
    if (element.matches('section') && !element.matches('.mp-dashboard-panel') && element.querySelector('.mp-dashboard-panel, .mp-metric-card') && !vendorSectionHelp[title]) continue
    const purpose = element.matches('.mp-dashboard-panel') ? element.querySelector(':scope > header p')?.textContent?.replace(/\s+/g, ' ').trim() ?? '' : ''
    add(element, title, explainVendorTopic(guide, title, purpose))
  }
  const actions: Record<string, string> = {
    'Add product': 'Start a product listing with its material and variants. The tutorial does not create or publish a draft.',
    'Add new account': 'Invite an individual team account with one fixed role. Sending an invitation remains a separate explicit action.',
    'Add vehicle': 'Open the existing vehicle editor to enter capacity, availability, photo and delivery rates. Nothing is saved by this guide.',
    'Review Commission Terms': 'Open the currently applicable terms when you are ready. Acceptance still requires the existing authority and authentication checks.',
  }
  for (const element of main.querySelectorAll('button, a[href]')) {
    const title = label(element)
    if (actions[title]) add(element, title, actions[title])
  }
  if (windowRoot || guide.contextOnly) {
    for (const element of main.querySelectorAll('label, fieldset > legend')) {
      const title = element.querySelector(':scope > span')?.textContent?.trim() || label(element)
      if (title.length < 120) add(element, title, explainVendorTopic(guide, title))
    }
    for (const element of main.querySelectorAll<HTMLButtonElement>('button[type="submit"]')) add(element, label(element), explainVendorTopic(guide, label(element)))
  }
  return steps
}

export function vendorGuideChapters(guides: readonly VendorGuide[], requestedTab?: string): VendorGuideChapter[] {
  return guides.flatMap(guide => guide.id === 'tracking' && document.querySelector('.team-tracking-workspace[data-tutorial-member-selected="false"]:not([data-tutorial-member-loading="true"])') ? [{ guide }] : requestedTab ? [{ guide, tab: requestedTab }] : guide.chapters?.length
    ? guide.chapters.map((tab, index) => ({ guide, tab, fallback: index === 0 })) : [{ guide }])
}

/** Route/tab preparation uses the existing UI handlers, so their guards are retained. */
export async function prepareVendorGuideChapter(chapter: VendorGuideChapter, options: {
  navigate: (href: string) => void; route: () => string; signal: AbortSignal
  onEmptyGuide?: (guide: VendorGuide) => void
}): Promise<WalkthroughStep[] | null> {
  const { guide, tab } = chapter
  const desired = new URL(guide.href || options.route(), 'https://tutorial.local')
  const current = new URL(options.route(), 'https://tutorial.local')
  if (desired.pathname !== current.pathname || (guide.id === 'remittance' && current.searchParams.get('section') !== 'threshold') || (guide.id === 'finance' && current.searchParams.get('section') === 'threshold')) options.navigate(guide.href)
  const started = Date.now()
  let selected = !tab
  let stableSince = 0
  let previous = ''
  while (!options.signal.aborted && Date.now() - started < 12_000) {
    const root = document.querySelector<HTMLElement>('[data-vendor-guide-path]')
    const main = document.getElementById('main-content')
    if (root?.dataset.vendorGuidePath === desired.pathname && main && ![...main.querySelectorAll('.mp-async-loading, [aria-label="Loading products"], [aria-label="Loading inventory"]')].some(guideElementVisible)) {
      if (guide.id === 'tracking' && main.querySelector('.team-tracking-workspace[data-tutorial-member-loading="true"]')) { await new Promise(resolve => setTimeout(resolve, 80)); continue }
      if (options.onEmptyGuide && (guide.id === 'invoices' && main.querySelector('[data-tutorial-invoices-empty="true"]') || guide.id === 'tracking' && main.querySelector('.team-tracking-workspace[data-tutorial-members-empty="true"]'))) { options.onEmptyGuide(guide); return null }
      if (guide.id === 'tracking' && main.querySelector('.team-tracking-workspace[data-tutorial-member-selected="false"]')) return !tab || chapter.fallback ? collectVendorGuideSteps(guide) : null
      if (!selected && tab) {
        const control = findGuideTab(tab, guide.tabList)
        if (control) {
          if (control.disabled) { await new Promise(resolve => setTimeout(resolve, 80)); continue }
          if (control.getAttribute('aria-selected') !== 'true' && control.getAttribute('aria-pressed') !== 'true') control.click()
          selected = true; stableSince = 0
          await new Promise(resolve => setTimeout(resolve, 100)); continue
        }
        if (chapter.fallback) selected = true
        else if (Date.now() - started > 800) return null // This role or state has no such section.
      }
      if (selected) {
        // A refused save/navigation guard keeps the original tab selected; never explain it as the requested tab.
        const control = tab ? findGuideTab(tab, guide.tabList) : null
        if (control?.disabled) { await new Promise(resolve => setTimeout(resolve, 80)); continue }
        if (control && control.getAttribute('aria-selected') !== 'true' && control.getAttribute('aria-pressed') !== 'true') throw new Error('Finish the page’s existing save or navigation checks before opening this chapter.')
        const signature = [...main.querySelectorAll('h1,h2,h3,.mp-kpi-label')].filter(guideElementVisible).map(element => element.textContent).join('|')
        if (signature !== previous) { previous = signature; stableSince = Date.now() }
        if (signature && Date.now() - stableSince >= 240) return collectVendorGuideSteps(guide, control ? tab : undefined)
      }
    }
    await new Promise(resolve => setTimeout(resolve, 80))
  }
  if (options.signal.aborted) return null
  throw new Error('The page did not finish opening. Close the guide to use the page’s retry control, or retry this chapter.')
}
