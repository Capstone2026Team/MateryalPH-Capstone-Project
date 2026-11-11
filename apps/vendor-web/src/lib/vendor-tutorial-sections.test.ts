import { beforeEach, expect, test, vi } from 'vitest'
import { availableVendorGuides, currentVendorGuide, vendorFeatureGuides, vendorGuides } from './vendor-tutorial-catalog'
import { collectVendorGuideSteps, findGuideTab, prepareVendorGuideChapter, vendorGuideChapters } from './vendor-tutorial-sections'
import { explainVendorTopic } from './vendor-tutorial-copy'

beforeEach(() => {
  vi.spyOn(Element.prototype, 'getClientRects').mockReturnValue(Object.assign([new DOMRect(16, 100, 320, 150)], { item: () => new DOMRect(16, 100, 320, 150) }))
})
const dashboard = vendorGuides.find(guide => guide.id === 'dashboard')!

test('the library covers every enabled navigation page and the requested management/analytics domains', () => {
  const hrefs = ['/dashboard', '/orders', '/messages', '/invoices', '/disputes', '/reviews', '/products', '/vehicles', '/finance', '/performance', '/analytics/products', '/team', '/preview/tracking', '/store-profile']
  const guides = availableVendorGuides([{ label: 'All', items: hrefs.map(href => ({ href, label: href })) }], ['inventory.view', 'catalog.manage', 'staff.manage', 'vendor.onboarding.submit'], '/dashboard')
  for (const href of hrefs) expect(guides.some(guide => guide.href === href)).toBe(true)
  expect(guides.filter(guide => guide.group === 'Finance').map(guide => guide.id)).toEqual(['finance', 'commissions', 'transactions', 'remittance'])
  expect(guides.find(guide => guide.id === 'store')?.chapters).not.toContain('Account Deletion')
  expect(currentVendorGuide(guides, '/finance', '?section=threshold')?.id).toBe('remittance')
})

test('hidden, disabled and ungranted workspaces are absent; record guides require an actual open record', () => {
  const nav = [{ label: 'Scoped', items: [{ href: '/products', label: 'Products' }, { href: '/finance', label: 'Finance', disabled: true }] }]
  const limited = availableVendorGuides(nav, [], '/products')
  expect(limited.some(guide => guide.id === 'finance' || guide.id === 'inventory' || guide.contextOnly)).toBe(false)
  const record = availableVendorGuides(nav, ['catalog.manage'], '/products/example')
  expect(currentVendorGuide(record, '/products/example')?.id).toBe('product-editor')
})

test('a Finance or Products feature tour continues through its authorized related pages', () => {
  const finance = vendorGuides.find(guide => guide.id === 'finance')!
  expect(vendorFeatureGuides(vendorGuides, finance).map(guide => guide.id)).toEqual(['finance', 'commissions', 'transactions', 'remittance'])
  const inventory = vendorGuides.find(guide => guide.id === 'inventory')!
  expect(vendorFeatureGuides(vendorGuides, inventory).map(guide => guide.id)).toEqual(['inventory', 'products'])
  expect(vendorGuides.some(guide => guide.href === '/products/import')).toBe(false)
})

test('user listings, invoice identifiers, chat names and closed chart tables are never tutorial topics', () => {
  document.body.innerHTML = `<main id="main-content"><h1>Products</h1><ul><li class="mp-product-listing"><h3>PRIVATE VENDOR PRODUCT</h3></li></ul>
    <section class="mp-dashboard-panel"><header><h2>Deductions and commission</h2></header><details><summary>View as table</summary><div><table><caption>Deductions and commission per day</caption></table></div></details></section>
    <section class="mp-invoice-sheet" aria-label="Invoice details"><h2>PRIVATE ORDER NUMBER</h2></section>
    <div class="chat-thread"><h2>PRIVATE BUYER NAME</h2></div></main>`
  const steps = collectVendorGuideSteps(dashboard)
  expect(steps.map(step => step.title)).toEqual(['Dashboard', 'Deductions and commission', 'Invoice details', 'Conversation and quotations'])
  expect(JSON.stringify(steps)).not.toContain('PRIVATE')
})

test('invoice tabs with numeric badges are matched and visited through the existing handler', async () => {
  document.body.innerHTML = `<main id="main-content" data-vendor-guide-path="/invoices"><h1>E-Invoices</h1><div role="tablist" aria-label="Invoice view"><button role="tab" aria-selected="false"><span>No copy yet</span><span class="tabular-nums">6</span></button></div><dialog><div class="mp-async-loading">Hidden settings</div></dialog></main>`
  const tab = findGuideTab('No copy yet', 'Invoice view')!
  expect(tab).toBeDefined()
  tab.onclick = () => tab.setAttribute('aria-selected', 'true')
  const invoice = vendorGuides.find(guide => guide.id === 'invoices')!
  const steps = await prepareVendorGuideChapter({ guide: invoice, tab: 'No copy yet' }, { navigate: vi.fn(), route: () => '/invoices?view=DUE', signal: new AbortController().signal })
  expect(steps?.[0]?.title).toBe('E-Invoices · No copy yet')
})

test('page collection includes each metric, graph, section and search while excluding hidden panels and record values', () => {
  document.body.innerHTML = `<main id="main-content" data-vendor-guide-path="/dashboard"><h1>Dashboard</h1>
    <dl class="mp-metric-card"><dt class="mp-kpi-label"><span>Earnings</span></dt><dd>PRIVATE VALUE</dd></dl>
    <section class="mp-dashboard-panel" aria-label="Sales trend"><header><h2>Sales trend</h2></header><svg role="img"></svg></section>
    <section class="mp-dashboard-panel" aria-label="Product demand segments"><header><h2>Product demand segments</h2></header></section>
    <section hidden aria-label="Cases filed per day" class="mp-dashboard-panel"><header><h2>Cases filed per day</h2></header></section>
    <section aria-label="Supporting files"><h2>Supporting files</h2><p>PRIVATE EVIDENCE CONTENT</p></section>
    <form role="search" aria-label="Find orders"><input value="PRIVATE INPUT" /></form></main>`
  const steps = collectVendorGuideSteps(dashboard, 'Overview')
  expect(steps.map(step => step.title)).toEqual(['Dashboard · Overview', 'Earnings', 'Sales trend', 'Product demand segments', 'Supporting files', 'Find orders'])
  expect(JSON.stringify(steps)).not.toMatch(/PRIVATE VALUE|PRIVATE INPUT|PRIVATE EVIDENCE/)
  expect(steps.find(step => step.title === 'Earnings')?.description).toMatch(/different from money collected/)
  for (const step of steps) expect(document.querySelector(step.target)).not.toBeNull()
})

test('preparing a chapter selects only its existing tab and never invokes a save or commercial action', async () => {
  document.body.innerHTML = `<main id="main-content" data-vendor-guide-path="/dashboard"><h1>Dashboard</h1><div role="tablist" aria-label="Workspace sections"><button role="tab" aria-selected="false">Traffic &amp; Volume</button></div><section aria-label="Demand funnel"><h2>Demand funnel</h2></section><button id="save">Save</button></main>`
  const tab = findGuideTab('Traffic & Volume', 'Workspace sections')!
  tab.onclick = () => tab.setAttribute('aria-selected', 'true')
  const save = vi.fn(); document.getElementById('save')!.onclick = save
  const navigate = vi.fn()
  const steps = await prepareVendorGuideChapter({ guide: dashboard, tab: 'Traffic & Volume' }, { navigate, route: () => '/dashboard', signal: new AbortController().signal })
  expect(steps?.some(step => step.title === 'Demand funnel')).toBe(true)
  expect(navigate).not.toHaveBeenCalled(); expect(save).not.toHaveBeenCalled()
})

test('a refused section guard does not explain the wrong panel as a successful chapter', async () => {
  document.body.innerHTML = `<main id="main-content" data-vendor-guide-path="/dashboard"><h1>Dashboard</h1><div role="tablist" aria-label="Workspace sections"><button role="tab" aria-selected="false">Traffic &amp; Volume</button></div></main>`
  await expect(prepareVendorGuideChapter({ guide: dashboard, tab: 'Traffic & Volume' }, { navigate: vi.fn(), route: () => '/dashboard', signal: new AbortController().signal })).rejects.toThrow(/existing save/)
  expect(vendorGuideChapters([dashboard]).map(chapter => chapter.tab)).toEqual(['Overview', 'Traffic & Volume', 'Disputes & Quality'])
})

test('metrics explain their meaning and use the correct context instead of generic calculation instructions', () => {
  const products = vendorGuides.find(guide => guide.id === 'products')!
  document.body.innerHTML = `<main id="main-content"><h1>Products</h1><div class="mp-metric-card"><dt class="mp-kpi-label"><span>Total</span></dt><dd>123</dd></div><div class="mp-metric-card"><dt class="mp-kpi-label"><span>Active</span></dt><dd>42</dd></div><h2>Unmapped future control</h2></main>`
  const steps = collectVendorGuideSteps(products)
  expect(steps.find(step => step.title === 'Total')?.description).toMatch(/store’s listings/)
  expect(steps.find(step => step.title === 'Active')?.description).toMatch(/Active state/)
  expect(steps.some(step => step.title === 'Unmapped future control')).toBe(false)
  expect(explainVendorTopic({ id: 'tracking', label: 'Team Tracking' }, 'Orders confirmed')).toMatch(/employee/)
  expect(explainVendorTopic(dashboard, 'Orders confirmed')).toMatch(/first confirmed/)
  expect(explainVendorTopic(dashboard, 'Vendor performance (VPS)')).toMatch(/half Community rating and half Operational health/)
  expect(JSON.stringify(steps)).not.toMatch(/Read the measure|Review this section|Use its information control/)
})

test('every registered tutorial tab has its own definition', () => {
  for (const guide of vendorGuides) for (const chapter of guide.chapters ?? []) {
    const explanation = explainVendorTopic(guide, chapter)
    expect(explanation, `${guide.id}: ${chapter}`).toBeTruthy()
    expect(explanation).not.toMatch(/Read the measure|Review this section|Use its information control/)
  }
})

test('unselected Team Tracking explains the picker, never the empty workspace or member names', () => {
  const tracking = vendorGuides.find(guide => guide.id === 'tracking')!
  document.body.innerHTML = `<main id="main-content" data-vendor-guide-path="/preview/tracking"><div class="team-tracking-workspace" data-tutorial-member-selected="false"><h1 class="sr-only">Team Tracking</h1><aside class="team-tracking-sidebar"><h2>Your team</h2><label>Find a team member<input /></label><label>Current role<select><option>All staff roles</option></select></label><ul><li><button>PRIVATE EMPLOYEE NAME</button></li></ul><a href="/team">Manage accounts</a></aside><section class="team-tracking-panel" aria-label="Selected team member"><header><h2>Team member activity</h2></header><div class="team-tracking-body" role="region" aria-label="Team member details"><h3>Select a team member</h3></div></section></div></main>`
  const steps = collectVendorGuideSteps(tracking)
  expect(steps.map(step => step.title)).toEqual(['Team Tracking', 'Find a team member', 'Current role', 'Manage accounts'])
  for (const step of steps) expect(document.querySelector(step.target)?.closest('.team-tracking-panel')).toBeNull()
  expect(JSON.stringify(steps)).not.toContain('PRIVATE')
  expect(vendorGuideChapters([tracking])).toEqual([{ guide: tracking }])
})

test('selected Team Tracking explains role-specific metrics and prepares its real read-only tabs', async () => {
  const tracking = vendorGuides.find(guide => guide.id === 'tracking')!
  document.body.innerHTML = `<main id="main-content" data-vendor-guide-path="/preview/tracking"><div class="team-tracking-workspace" data-tutorial-member-selected="true"><aside class="team-tracking-sidebar"><h2>Your team</h2></aside><section class="team-tracking-panel" aria-label="Selected team member"><header><h2>PRIVATE EMPLOYEE NAME</h2></header><nav aria-label="Tracking views"><button aria-pressed="true">Statistics</button><button aria-pressed="false">Activity history</button><button aria-pressed="false">Role responsibilities</button></nav><div class="team-tracking-body" role="region" aria-label="Team member details"><div class="mp-metric-card"><dt class="mp-kpi-label"><span>Orders confirmed</span></dt><dd>55</dd></div></div></section></div></main>`
  const chapters = vendorGuideChapters([tracking])
  expect(chapters.map(item => item.tab)).toEqual(['Statistics', 'Activity history', 'Role responsibilities'])
  const steps = collectVendorGuideSteps(tracking, 'Statistics')
  expect(steps.find(step => step.title === 'Orders confirmed')?.description).toMatch(/employee/)
  expect(steps.some(step => step.title === 'Team member details')).toBe(false)
  expect(JSON.stringify(steps)).not.toContain('PRIVATE')
  const history = findGuideTab('Activity history', 'Tracking views')!
  history.onclick = () => { for (const button of document.querySelectorAll('nav button')) button.setAttribute('aria-pressed', String(button === history)) }
  const prepared = await prepareVendorGuideChapter(chapters[1]!, { navigate: vi.fn(), route: () => '/preview/tracking', signal: new AbortController().signal })
  expect(prepared?.[0]?.title).toBe('Team Tracking · Activity history')
})

test('Team Tracking introduces shared controls once and preserves the full guide on Back or replay', async () => {
  const tracking = vendorGuides.find(guide => guide.id === 'tracking')!
  document.body.innerHTML = `<main id="main-content" data-vendor-guide-path="/preview/tracking"><div class="team-tracking-workspace" data-tutorial-member-selected="true"><aside class="team-tracking-sidebar"><h2>Your team</h2><label>Find a team member<input /></label><label>Current role<select><option>All staff roles</option></select></label><a href="/team">Manage accounts</a></aside><section class="team-tracking-panel" aria-label="Selected team member"><header><h2>PRIVATE EMPLOYEE NAME</h2></header><nav aria-label="Tracking views"><button aria-pressed="true">Statistics</button><button aria-pressed="false">Activity history</button><button aria-pressed="false">Role responsibilities</button></nav><div class="team-tracking-body" role="region" aria-label="Team member details"></div></section></div></main>`
  const body = document.querySelector('.team-tracking-body')!
  const content: Record<string, string> = {
    Statistics: '<div class="mp-metric-card"><dt class="mp-kpi-label"><span>Stock updates</span></dt><dd>55</dd></div>',
    'Activity history': '<h3>Activity history</h3><section aria-label="Activity history">No recorded activity</section>',
    'Role responsibilities': '<section aria-label="Role responsibilities"><h3>Inventory Staff</h3></section>',
  }
  body.innerHTML = content.Statistics!
  for (const button of document.querySelectorAll<HTMLButtonElement>('nav button')) button.onclick = () => {
    for (const other of document.querySelectorAll('nav button')) other.setAttribute('aria-pressed', String(other === button))
    body.innerHTML = content[button.textContent!]!
  }
  const options = { navigate: vi.fn(), route: () => '/preview/tracking', signal: new AbortController().signal }
  const chapters = vendorGuideChapters([tracking])
  const titles: string[][] = []
  for (const chapter of chapters) titles.push((await prepareVendorGuideChapter(chapter, options))!.map(step => step.title))
  expect(titles[0]).toEqual(['Team Tracking · Statistics', 'Your team', 'Find a team member', 'Current role', 'Manage accounts', 'Selected team member', 'Tracking views', 'Stock updates'])
  expect(titles[1]).toEqual(['Team Tracking · Activity history'])
  expect(titles[2]).toEqual(['Team Tracking · Role responsibilities'])
  expect(new Set(titles.flat()).size).toBe(titles.flat().length)
  for (const index of [1, 0, 0]) expect((await prepareVendorGuideChapter(chapters[index]!, options))!.map(step => step.title)).toEqual(titles[index])
})

test('starting Team Tracking while its first account is loading retains all three views and waits for selection', async () => {
  const tracking = vendorGuides.find(guide => guide.id === 'tracking')!
  document.body.innerHTML = `<main id="main-content" data-vendor-guide-path="/preview/tracking"><div class="team-tracking-workspace" data-tutorial-member-selected="false" data-tutorial-member-loading="true"><h2>Your team</h2></div></main>`
  const chapters = vendorGuideChapters([tracking])
  expect(chapters).toHaveLength(3)
  let settled = false
  const preparation = prepareVendorGuideChapter(chapters[0]!, { navigate: vi.fn(), route: () => '/preview/tracking', signal: new AbortController().signal }).then(steps => { settled = true; return steps })
  await new Promise(resolve => setTimeout(resolve, 100))
  expect(settled).toBe(false)
  const workspace = document.querySelector('.team-tracking-workspace')!
  workspace.setAttribute('data-tutorial-member-loading', 'false')
  workspace.setAttribute('data-tutorial-member-selected', 'true')
  workspace.innerHTML = '<nav aria-label="Tracking views"><button aria-pressed="true">Statistics</button></nav><div class="mp-metric-card"><dt class="mp-kpi-label"><span>Stock updates</span></dt><dd>55</dd></div>'
  const steps = await preparation
  expect(steps?.[0]?.title).toBe('Team Tracking · Statistics')
  expect(steps?.some(step => step.title === 'Stock updates')).toBe(true)
})

test.each(['invoices', 'tracking'])('a confirmed empty %s view requests a tutorial sample without creating a record', async id => {
  const guide = vendorGuides.find(item => item.id === id)!
  document.body.innerHTML = `<main id="main-content" data-vendor-guide-path="${guide.href}"><h1>Workspace</h1><div ${id === 'invoices' ? 'data-tutorial-invoices-empty="true"' : 'class="team-tracking-workspace" data-tutorial-members-empty="true" data-tutorial-member-selected="false"'}></div></main>`
  const sample = vi.fn()
  expect(await prepareVendorGuideChapter({ guide }, { navigate: vi.fn(), route: () => guide.href, signal: new AbortController().signal, onEmptyGuide: sample })).toBeNull()
  expect(sample).toHaveBeenCalledExactlyOnceWith(guide)
})

test('Team Tracking read failures do not masquerade as an empty team with demo data', async () => {
  const guide = vendorGuides.find(item => item.id === 'tracking')!
  document.body.innerHTML = '<main id="main-content" data-vendor-guide-path="/preview/tracking"><h1>Team Tracking</h1><div class="team-tracking-workspace" data-tutorial-members-empty="false" data-tutorial-member-selected="false"><p role="alert">Access denied</p></div></main>'
  const sample = vi.fn()
  await prepareVendorGuideChapter({ guide }, { navigate: vi.fn(), route: () => guide.href, signal: new AbortController().signal, onEmptyGuide: sample })
  expect(sample).not.toHaveBeenCalled()
})
