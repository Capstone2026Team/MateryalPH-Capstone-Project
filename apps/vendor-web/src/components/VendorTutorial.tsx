/* oxlint-disable react/only-export-components -- The provider and its consuming hook share one private context. */
import { createContext, useCallback, useContext, useEffect, useMemo, useRef, useState, type ReactNode } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'
import { TutorialsApi, type AcknowledgeTutorialTutorialKeyEnum } from '@materyalph/api-client-ts'
import { Button, createWebApiConfiguration, GuidedWalkthrough, SidePanel, StatusMessage, TutorialWindowHelpProvider, type PortalNavSection, type WalkthroughStep } from '@materyalph/web-ui'
import { BookOpen, ChartNoAxesCombined, ChevronDown, Compass, FileText, Layers, Package, Search, Settings, Store, Users, Wallet } from 'lucide-react'
import { readableOnboardingError } from '../lib/onboarding-api'
import { availableVendorGuides, currentVendorGuide, vendorFeatureGuides, type VendorGuide } from '../lib/vendor-tutorial-catalog'
import { explainVendorTopic } from '../lib/vendor-tutorial-copy'
import { collectVendorGuideSteps, prepareVendorGuideChapter, vendorGuideChapters, type VendorGuideChapter } from '../lib/vendor-tutorial-sections'
import './VendorTutorial.css'
import VendorPractice from './VendorPractice'
import { practiceLabels, type VendorPracticeKind } from '../lib/vendor-tutorial-catalog'

type Key = AcknowledgeTutorialTutorialKeyEnum
type Progress = Partial<Record<Key, 'COMPLETED' | 'SKIPPED'>>
type GuidePage = { navigation: PortalNavSection[]; permissions: readonly string[]; enabled: boolean; automaticEnabled: boolean; path: string }
type GuideSession = { chapters: VendorGuideChapter[]; index: number; progressKey?: Key | undefined; back?: boolean; automaticOrigin?: string; practiceAfter?: VendorPracticeKind }
const api = () => new TutorialsApi(createWebApiConfiguration(import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1', { refreshSession: true, localForbidden: true }))
const TutorialContext = createContext<{
  progress: Progress | null; error: string | null; pending: boolean; active: boolean; navigationOpen: boolean
  register: (page: GuidePage) => void; openHelp: () => void; startGuide: (guide: VendorGuide, tab?: string) => void
  retry: () => Promise<void>; save: (key: Key, completed: boolean) => Promise<void>
} | null>(null)

function GuideIcon({ group }: { group: string }) {
  const Icon = group === 'Store Management' ? Package : group === 'Finance' ? Wallet : group === 'Analytics' ? ChartNoAxesCombined : group === 'Vendor Team Accounts' ? Users : group === 'Store Profile' ? Store : group === 'Store Operations' ? FileText : group === 'Account & Help' ? Settings : Compass
  return <Icon size={22} aria-hidden="true" />
}

/** A compact first-login orientation; the library offers detailed page and section tours. */
export function vendorTourSteps(navigation: PortalNavSection[], permissions: readonly string[] = []): WalkthroughStep[] {
  const enabled = new Set(navigation.flatMap(section => section.items.filter(item => !item.disabled).map(item => item.href)))
  const topics = availableVendorGuides(navigation, permissions, '').filter(guide => guide.navigation && guide.href === guide.navigation && guide.id !== 'dashboard')
  const order = navigation.flatMap(section => section.items.map(item => item.href))
  topics.sort((first, second) => order.indexOf(first.href) - order.indexOf(second.href))
  return [
    { id: 'dashboard', target: '[data-tour="nav:/dashboard"]', title: 'Your store, at a glance', description: 'Start on Dashboard for your store status, priority work and analytics. Help / tutorial offers a detailed guide to every available page and section.', icon: <Compass size={24} /> },
    ...topics.map(guide => ({ id: guide.id, target: `[data-tour="nav:${guide.navigation}"]`, title: guide.id === 'messages' ? 'Turn inquiries into quotations' : guide.id === 'orders' ? 'Follow each order through fulfillment' : guide.label, description: guide.description, icon: <GuideIcon group={guide.group} /> })),
    ...(enabled.has('/products') && permissions.includes('inventory.view') ? [{ id: 'inventory', target: '[data-tour="nav:/products"]', title: 'Keep stock and prices current', description: 'Open Inventory inside My Products for stock, confirmation, prices, allotments and auto-accept.', icon: <Layers size={24} /> }] : []),
    { id: 'help', target: '[data-tour="tutorial-help"]', title: 'A little help, whenever you need it', description: 'Find a page, tour its sections and graphs, or take the complete portal tour. Record details and editors can be guided after you open a real record.', icon: <BookOpen size={24} /> },
  ]
}

export function VendorTutorialProvider({ children }: { children: ReactNode }) {
  const navigate = useNavigate()
  const location = useLocation()
  const route = useRef(location.pathname + location.search)
  route.current = location.pathname + location.search
  const navigateRef = useRef(navigate)
  navigateRef.current = navigate
  const [page, setPage] = useState<GuidePage | null>(null)
  const [progress, setProgress] = useState<Progress | null>(null)
  const [error, setError] = useState<string | null>(null)
  const pending = useRef(new Map<Key, boolean>())
  const [, updatePending] = useState(0)
  const overviewOffered = useRef(false)
  const pageOffered = useRef(new Set<Key>())
  const mounted = useRef(false)
  const [help, setHelp] = useState(false)
  const [query, setQuery] = useState('')
  const [quick, setQuick] = useState<WalkthroughStep[] | null>(null)
  const quickProgress = useRef<Key | null>('overview')
  const [needsNavigation, setNeedsNavigation] = useState(true)
  const [session, setSession] = useState<GuideSession | null>(null)
  const [practice, setPractice] = useState<{ kind: VendorPracticeKind; continueTour: boolean; progressKey?: Key | undefined; automaticOrigin?: string } | null>(null)
  const [prepared, setPrepared] = useState<WalkthroughStep[] | null>(null)
  const [problem, setProblem] = useState(false)
  const [attempt, setAttempt] = useState(0)
  const stepCounts = useRef(new Map<number, number>())
  const register = useCallback((next: GuidePage) => setPage(previous => {
    const resolved = !next.navigation.length && previous ? { ...next, navigation: previous.navigation, permissions: previous.permissions } : next
    return JSON.stringify(previous) === JSON.stringify(resolved) ? previous : resolved
  }), [])
  const reload = useCallback(async () => {
    try {
      const result = await api().getTutorialProgress({ tutorialPortal: 'vendors' })
      if (mounted.current) { setProgress(previous => ({ ...Object.fromEntries(result.data.map(row => [row.tutorialKey, row.status])), ...previous })); setError(null) }
    } catch (cause) { const message = await readableOnboardingError(cause); if (mounted.current) setError(message) }
  }, [])
  useEffect(() => { mounted.current = true; void reload(); return () => { mounted.current = false } }, [reload])
  async function save(key: Key, completed: boolean) {
    setProgress(previous => ({ ...previous, [key]: completed ? 'COMPLETED' : previous?.[key] ?? 'SKIPPED' }))
    try {
      await api().acknowledgeTutorial({ tutorialPortal: 'vendors', tutorialKey: key, tutorialAcknowledgment: { status: completed ? 'COMPLETED' : 'SKIPPED' } })
      if (mounted.current) {
        if (completed || !pending.current.get(key)) pending.current.delete(key)
        updatePending(value => value + 1)
        setError(pending.current.size ? 'Some tutorial progress is still not saved.' : null)
      }
    } catch (cause) {
      const message = await readableOnboardingError(cause)
      if (mounted.current) { pending.current.set(key, completed || pending.current.get(key) === true); updatePending(value => value + 1); setError(`Tutorial progress could not be saved. ${message}`) }
    }
  }
  async function retry() { for (const [key, completed] of new Map(pending.current)) await save(key, completed) }
  const guides = useMemo(() => page ? availableVendorGuides(page.navigation, page.permissions, location.pathname).filter(guide => page.enabled || guide.contextOnly).map(guide => guide.contextOnly ? { ...guide, href: route.current } : guide) : [], [page, location.pathname])
  const pagePath = location.pathname === '/' ? page?.path ?? '/' : location.pathname
  const current = currentVendorGuide(guides, pagePath, location.search)
  const stepChanged = useCallback((step: WalkthroughStep) => setNeedsNavigation(step.target.includes('nav:')), [])
  function finishSession(completed: boolean) {
    if (completed && session?.practiceAfter) {
      setPractice({ kind: session.practiceAfter, continueTour: false, progressKey: session.progressKey, ...(session.automaticOrigin ? { automaticOrigin: session.automaticOrigin } : {}) })
      setSession(null); setPrepared(null); setProblem(false)
      return
    }
    const currentKey = session?.chapters[session.index]?.guide.progressKey
    if (!completed && currentKey && currentKey !== session?.progressKey) void save(currentKey, false)
    const finalKey = session?.chapters.at(-1)?.guide.progressKey
    if (completed && finalKey && finalKey !== session?.progressKey) void save(finalKey, true)
    if (session?.progressKey) void save(session.progressKey, completed)
    setSession(null); setPrepared(null); setProblem(false)
  }
  const finishCurrent = useRef(finishSession)
  finishCurrent.current = finishSession
  function startGuide(guide: VendorGuide, tab?: string, automatic = false) {
    setHelp(false); setQuick(null); setPrepared(null); setProblem(false)
    if (guide.progressKey) pageOffered.current.add(guide.progressKey)
    stepCounts.current.clear()
    const sample = automatic && (guide.id === 'products' || guide.id === 'vehicles') ? practiceKind(guide) : null
    setSession({ chapters: vendorGuideChapters(automatic ? [guide] : vendorFeatureGuides(guides, guide), tab), index: 0, progressKey: guide.progressKey,
      ...(automatic ? { automaticOrigin: pagePath } : {}), ...(sample ? { practiceAfter: sample } : {}) })
  }
  function practiceKind(guide: VendorGuide): VendorPracticeKind | null {
    if (guide.id === 'products' && page?.permissions.includes('catalog.manage')) return 'products'
    if (guide.id === 'vehicles' && page?.permissions.includes('vehicles.manage')) return 'vehicles'
    return guide.id === 'invoices' || guide.id === 'tracking' ? guide.id : null
  }
  function startPractice(kind: VendorPracticeKind) {
    const guide = guides.find(guide => practiceKind(guide) === kind)
    if (!guide) return
    if (current?.progressKey) pageOffered.current.add(current.progressKey)
    setHelp(false); setQuick(null); setSession(null); setPrepared(null)
    setPractice({ kind, continueTour: false, progressKey: guide.progressKey })
  }
  function closePractice(completed: boolean) {
    setPractice(null)
    if (!practice?.continueTour || !session) {
      if (practice?.progressKey) void save(practice.progressKey, completed)
      return
    }
    if (!completed) { finishSession(false); return }
    const next = session.chapters.findIndex((chapter, index) => index > session.index && chapter.guide.id !== practice.kind)
    if (next < 0) finishSession(true)
    else {
      if (practice.progressKey) void save(practice.progressKey, true)
      setPrepared(null); setSession({ ...session, index: next, back: false })
    }
  }
  function startComplete() {
    setHelp(false); setQuick(null); setPrepared(null); setProblem(false)
    stepCounts.current.clear()
    setSession({ chapters: vendorGuideChapters(guides.filter(guide => !guide.contextOnly)), index: 0, progressKey: 'overview' })
  }
  const startCurrentGuide = useRef(startGuide)
  startCurrentGuide.current = startGuide
  const closeCurrentPractice = useRef(closePractice)
  closeCurrentPractice.current = closePractice
  useEffect(() => {
    if (!page?.enabled || !page.automaticEnabled || page.path !== pagePath || pagePath !== '/dashboard' || help || quick || session || practice || !progress || progress.overview || overviewOffered.current) return
    const startWhenClear = () => {
      if (document.querySelector('dialog[open]') || overviewOffered.current) return
      overviewOffered.current = true
      pageOffered.current.add('dashboard')
      quickProgress.current = 'overview'; setNeedsNavigation(true); setQuick(vendorTourSteps(page.navigation, page.permissions))
    }
    const observer = new MutationObserver(startWhenClear)
    observer.observe(document.body, { childList: true, subtree: true, attributes: true, attributeFilter: ['open'] })
    startWhenClear()
    return () => observer.disconnect()
  }, [page, pagePath, help, quick, session, practice, progress])
  useEffect(() => {
    if (!page?.enabled || !page.automaticEnabled || page.path !== pagePath || !progress || help || quick || session || practice || !current?.progressKey || current.contextOnly || progress[current.progressKey] || pageOffered.current.has(current.progressKey)) return
    // Leave existing editors and confirmations alone, and let the first-login orientation go first.
    if (current.id === 'dashboard' && !progress.overview) return
    const startWhenClear = () => {
      if (!document.querySelector('dialog[open]') && !pageOffered.current.has(current.progressKey!)) startCurrentGuide.current(current, undefined, true)
    }
    const observer = new MutationObserver(startWhenClear)
    observer.observe(document.body, { childList: true, subtree: true, attributes: true, attributeFilter: ['open'] })
    startWhenClear()
    return () => observer.disconnect()
  }, [page, pagePath, progress, help, quick, session, practice, current])
  useEffect(() => {
    if (quick && quickProgress.current === 'overview' && (pagePath !== '/dashboard' || !page?.automaticEnabled)) {
      setQuick(null); void save('overview', false); void save('dashboard', false)
    }
    else if (practice?.automaticOrigin && (practice.automaticOrigin !== pagePath || !page?.automaticEnabled || practice.progressKey !== current?.progressKey)) closeCurrentPractice.current(false)
    else if (session?.automaticOrigin && (session.automaticOrigin !== pagePath || !page?.automaticEnabled || session.progressKey !== current?.progressKey)) finishCurrent.current(false)
  }, [pagePath, page?.automaticEnabled, current?.progressKey, quick, session?.automaticOrigin, session?.progressKey, practice?.automaticOrigin, practice?.progressKey])
  useEffect(() => {
    if (!session || practice) return
    if (session.automaticOrigin && (session.automaticOrigin !== pagePath || !page?.automaticEnabled || session.progressKey !== current?.progressKey)) return
    const controller = new AbortController()
    setPrepared(null); setProblem(false)
    const chapter = session.chapters[session.index]
    if (!chapter) { setProblem(true); return }
    let sampleRequested = false
    void prepareVendorGuideChapter(chapter, { navigate: href => navigateRef.current(href), route: () => route.current, signal: controller.signal, onEmptyGuide: guide => {
      if (guide.id !== 'invoices' && guide.id !== 'tracking') return
      sampleRequested = true; setPractice({ kind: guide.id, continueTour: true, progressKey: guide.progressKey, ...(session.automaticOrigin ? { automaticOrigin: session.automaticOrigin } : {}) })
    } }).then(steps => {
      if (controller.signal.aborted || sampleRequested) return
      if (steps?.length) { if (chapter.guide.progressKey) pageOffered.current.add(chapter.guide.progressKey); stepCounts.current.set(session.index, steps.length); setPrepared(steps) }
      else if (session.index < session.chapters.length - 1) setSession(previous => previous ? { ...previous, index: previous.index + 1, back: false } : null)
      else if (session.index > 0) finishCurrent.current(true)
      else setProblem(true)
    }).catch(() => { if (!controller.signal.aborted) setProblem(true) })
    return () => controller.abort()
  }, [session, attempt, practice, pagePath, page?.automaticEnabled, current?.progressKey])

  const normalizedQuery = query.toLowerCase().trim()
  const matches = guides.filter(guide => !guide.parent && vendorFeatureGuides(guides, guide).some(part => `${part.id} ${part.group} ${part.label} ${part.description} ${part.chapters?.join(' ') ?? ''}`.toLowerCase().includes(normalizedQuery)))
  const groups = [...new Set(matches.map(guide => guide.group))]
  const chapter = session?.chapters[session.index]
  const sessionLabel = prepared?.[0]?.title ?? chapter?.guide.label ?? 'Page guide'
  return <TutorialContext.Provider value={{ progress, error, pending: pending.current.size > 0, active: !!(quick || session || practice), navigationOpen: !!quick && needsNavigation, register, openHelp: () => setHelp(true), startGuide, retry, save }}>
    <TutorialWindowHelpProvider onGuide={(element, title) => {
      const explanation = explainVendorTopic({ id: 'window', label: title }, title) ?? current?.description
      if (!explanation) return
      quickProgress.current = null; setHelp(false); setSession(null); setNeedsNavigation(false)
      setQuick(collectVendorGuideSteps({ id: 'window', label: title, href: location.pathname, group: 'Current record', contextOnly: true, description: explanation }, undefined, element))
    }}>{children}</TutorialWindowHelpProvider>
    {help && <SidePanel open title="Help / tutorial" description="Page, section and graph guides for your role." onClose={() => setHelp(false)}>
      <div className="vendor-tutorial-library" data-vendor-tutorial-ui>
        {error && <StatusMessage tone="error">{error}<Button variant="quiet" onClick={() => pending.current.size ? void retry() : void reload()}>Retry</Button></StatusMessage>}
        <Button className="w-full" disabled={!page?.enabled} onClick={startComplete}><Compass size={20} aria-hidden="true" />Take the complete tour</Button>
        {current && <Button className="w-full" variant="secondary" onClick={() => startGuide(current)}><BookOpen size={18} aria-hidden="true" />Tour this page: {current.label}</Button>}
        <label className="vendor-tutorial-search"><Search size={18} aria-hidden="true" /><span className="sr-only">Find a page or feature</span><input type="search" placeholder="Find a page, section or feature" value={query} onChange={event => setQuery(event.target.value)} /></label>
        <p className="text-xs leading-5 text-text-secondary">Choose a feature for one continuous tour through its pages and tabs. Open an existing record or editor to guide that window. You can leave at any time.</p>
        {!matches.length && <p role="status" className="py-6 text-sm text-text-secondary">No matching guide. Try a page name such as Finance or Vehicles.</p>}
        {groups.map(group => <section key={group} className="vendor-tutorial-group" aria-label={`${group} guides`}><h2>{group}</h2>{matches.filter(guide => guide.group === group).map(guide => <details key={guide.id} className="vendor-tutorial-topic" open={query ? true : undefined}>
          <summary><span className="vendor-tutorial-topic-icon"><GuideIcon group={guide.group} /></span><span className="min-w-0 flex-1"><strong>{guide.label}</strong><small>One continuous feature tour</small></span><ChevronDown size={16} aria-hidden="true" /></summary>
          <div className="vendor-tutorial-topic-body"><p>{guide.description}</p><Button variant="outline" onClick={() => startGuide(guide)}>Tour {guide.label}</Button>{practiceKind(guide) && <Button variant="secondary" onClick={() => startPractice(practiceKind(guide)!)}>{practiceLabels[practiceKind(guide)!]}</Button>}</div>
        </details>)}</section>)}
      </div>
    </SidePanel>}
    {quick && <GuidedWalkthrough steps={quick} onStepChange={stepChanged} label={quickProgress.current ? 'Welcome to MateryalPH' : 'Window guide'} onClose={completed => {
      if (quickProgress.current) void save(quickProgress.current, completed)
      setQuick(null)
      if (quickProgress.current === 'overview' && current?.id === 'dashboard') {
        if (completed) startGuide(current, undefined, true)
        else void save('dashboard', false)
      }
    }} />}
    {practice && <VendorPractice kind={practice.kind} onClose={closePractice} canPrepareInvoices={page?.permissions.includes('invoices.upload') ?? false} />}
    {session && !practice && <GuidedWalkthrough key={`${session.index}-${attempt}-${prepared ? 'ready' : 'loading'}`} steps={prepared ?? [{ id: 'preparing', target: '[data-vendor-guide-loading-target]', title: problem ? 'This guide is not ready' : `Opening ${chapter?.guide.label ?? 'your page'}`, description: problem ? 'This page or section did not finish opening. Retry the guide, or close it and use the page’s existing retry or save controls.' : 'Waiting for the page and its available sections. You can skip or close at any time.' }]} label={sessionLabel}
      continuousProgress={{ stepOffset: [...stepCounts.current].filter(([index]) => index < session.index).reduce((sum, [, count]) => sum + count, 0), pageIndex: session.index, pageCount: session.chapters.length }}
      busy={!prepared && !problem} initialIndex={session.back ? (prepared?.length ?? 1) - 1 : 0}
      finishLabel={problem ? 'Retry' : session.index < session.chapters.length - 1 ? 'Next' : 'Finish'}
      onBackAtStart={session.index > 0 ? () => { setPrepared(null); setSession(previous => previous ? { ...previous, index: previous.index - 1, back: true } : null) } : undefined}
      onClose={completed => {
        if (!completed) finishSession(false)
        else if (problem) setAttempt(value => value + 1)
        else if (session.index < session.chapters.length - 1) {
          if (chapter?.guide.progressKey && session.chapters[session.index + 1]?.guide.id !== chapter.guide.id) void save(chapter.guide.progressKey, true)
          setPrepared(null); setSession(previous => previous ? { ...previous, index: previous.index + 1, back: false } : null)
        }
        else finishSession(true)
      }} />}
  </TutorialContext.Provider>
}

export function useVendorTutorial(navigation: PortalNavSection[], activeHref: string, enabled: boolean, permissions: readonly string[] = [], automaticEnabled = enabled) {
  const context = useContext(TutorialContext)
  const location = useLocation()
  const signature = JSON.stringify({ navigation: navigation.map(section => ({ label: section.label, items: section.items.map(({ label, href, disabled }) => ({ label, href, disabled })) })), permissions, enabled, automaticEnabled, path: location.pathname === '/' ? activeHref : location.pathname })
  const register = context?.register
  useEffect(() => { register?.(JSON.parse(signature) as GuidePage) }, [register, signature])
  return {
    navigationOpen: context?.navigationOpen ?? false,
    pagePath: location.pathname,
    helpButton: <Button variant="quiet" aria-label="Help / tutorial" data-tour="tutorial-help" disabled={!context} onClick={context?.openHelp}><BookOpen size={18} aria-hidden="true" /><span className="hidden sm:inline">Help / tutorial</span></Button>,
    content: <div data-vendor-tutorial-ui>
      {context?.pending && !context.active && <StatusMessage tone="error">{context.error}<Button variant="quiet" onClick={() => void context.retry()}>Retry saving progress</Button></StatusMessage>}
    </div>,
  }
}
