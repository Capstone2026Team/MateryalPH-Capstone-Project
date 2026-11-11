import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { TutorialsApi } from '@materyalph/api-client-ts'
import { beforeEach, expect, test, vi } from 'vitest'
import { MemoryRouter, useLocation, useNavigate } from 'react-router-dom'
import { FormDialog } from '@materyalph/web-ui'
import { vendorGuides } from '../lib/vendor-tutorial-catalog'
import { VendorTutorialProvider, useVendorTutorial, vendorTourSteps } from './VendorTutorial'

const seenPages = vendorGuides.flatMap(guide => guide.progressKey ? [{ tutorialKey: guide.progressKey, status: 'COMPLETED' as const, updatedAt: new Date() }] : [])
const navigation = [{ label: 'Menu', items: [{ label: 'Dashboard', href: '/dashboard' }, { label: 'Products', href: '/products', disabled: true }, { label: 'Messages', href: '/messages' }, { label: 'Orders', href: '/orders' }] }]
function Harness({ path = '/dashboard' }: { path?: string }) {
  const tutorial = useVendorTutorial(navigation, path, true)
  return <><nav>{navigation.flatMap(section => section.items).map(item => <a key={item.href} href={item.href} data-tour={`nav:${item.href}`}>{item.label}</a>)}</nav>{tutorial.helpButton}<main id="main-content" data-vendor-guide-path={tutorial.pagePath}>{tutorial.content}<h1>Workspace</h1><section aria-label="Sales trend" className="mp-dashboard-panel"><header><h2>Sales trend</h2></header><p>Saved chart</p></section></main></>
}
function Provider({ children }: { children: React.ReactNode }) { return <MemoryRouter><VendorTutorialProvider>{children}</VendorTutorialProvider></MemoryRouter> }
function LinkedProducts() {
  const tutorial = useVendorTutorial([{ label: 'Products', items: [{ label: 'My Products', href: '/products' }] }], '/products', true, ['inventory.view'])
  return <>{tutorial.helpButton}<main id="main-content" data-vendor-guide-path={tutorial.pagePath}>{tutorial.content}<h1>{tutorial.pagePath === '/products/inventory' ? 'Inventory workspace' : 'Products workspace'}</h1></main></>
}
const read = vi.spyOn(TutorialsApi.prototype, 'getTutorialProgress')
const save = vi.spyOn(TutorialsApi.prototype, 'acknowledgeTutorial')
function PracticeLibrary({ permissions }: { permissions: string[] }) {
  const tutorial = useVendorTutorial([{ label: 'Menu', items: [{ label: 'Products', href: '/products' }, { label: 'Vehicles', href: '/vehicles' }, { label: 'Invoices', href: '/invoices' }, { label: 'Tracking', href: '/preview/tracking' }] }], '/invoices', true, permissions)
  return <>{tutorial.helpButton}<main id="main-content" data-vendor-guide-path={tutorial.pagePath}><h1>Workspace</h1></main></>
}
beforeEach(() => {
  read.mockReset().mockResolvedValue({ data: [], meta: {}, errors: [] })
  save.mockReset().mockResolvedValue({ data: [], meta: {}, errors: [] })
  HTMLDialogElement.prototype.showModal = function () { this.open = true }
  HTMLDialogElement.prototype.close = function () { this.open = false }
  vi.stubGlobal('ResizeObserver', class { observe() {} disconnect() {} })
  vi.stubGlobal('matchMedia', () => ({ matches: false, addEventListener() {}, removeEventListener() {} }))
  vi.spyOn(Element.prototype, 'getClientRects').mockReturnValue(Object.assign([new DOMRect(16, 100, 320, 150)], { item: () => new DOMRect(16, 100, 320, 150) }))
})

function FirstPage({ activated = true }: { activated?: boolean }) {
  const location = useLocation()
  const navigate = useNavigate()
  const tutorial = useVendorTutorial([{ label: 'Menu', items: ['/dashboard', '/products', '/vehicles', '/invoices', '/preview/tracking', '/finance'].map(href => ({ href, label: href })) }], location.pathname, true, ['catalog.manage', 'vehicles.manage', 'invoices.view', 'invoices.upload', 'staff.manage'], activated)
  return <>{tutorial.helpButton}<button onClick={() => navigate('/finance')}>Change route</button><main id="main-content" data-vendor-guide-path={tutorial.pagePath}><h1>Workspace</h1>{location.pathname === '/invoices' && <div data-tutorial-invoices-empty="true" />}{location.pathname === '/preview/tracking' && <div className="team-tracking-workspace" data-tutorial-members-empty="true" data-tutorial-member-selected="false" data-tutorial-member-loading="false" />}</main></>
}
const pageVisit = (path: string, activated = true) => render(<MemoryRouter initialEntries={[path]}><VendorTutorialProvider><FirstPage activated={activated} /></VendorTutorialProvider></MemoryRouter>)

test.each([
  ['/products', 'Product listings', 'Practice adding a product', 'products'],
  ['/vehicles', 'Vehicles', 'Practice adding a vehicle', 'vehicles'],
] as const)('first active visit to %s starts its guide and practice automatically, and saves dismissal per person', async (path, heading, practice, key) => {
  const view = pageVisit(path)
  await screen.findByRole('heading', { name: heading })
  fireEvent.click(screen.getByRole('button', { name: 'Finish' }))
  await screen.findByRole('heading', { name: practice })
  expect(save).not.toHaveBeenCalledWith(expect.objectContaining({ tutorialKey: key, tutorialAcknowledgment: { status: 'COMPLETED' } }))
  fireEvent.click(screen.getByRole('button', { name: 'Skip' }))
  await waitFor(() => expect(save).toHaveBeenCalledWith(expect.objectContaining({ tutorialKey: key, tutorialAcknowledgment: { status: 'SKIPPED' } })))
  view.unmount()
  read.mockResolvedValue({ data: [{ tutorialKey: key, status: 'SKIPPED', updatedAt: new Date() }], meta: {}, errors: [] })
  pageVisit(path)
  await waitFor(() => expect(read).toHaveBeenCalledTimes(2))
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
})

test.each([
  ['/invoices', 'Practice E-Invoices', 'invoices'],
  ['/preview/tracking', 'Practice Team Tracking', 'tracking'],
] as const)('an empty first visit to %s automatically opens its demo and records the page status', async (path, heading, key) => {
  pageVisit(path)
  await screen.findByRole('heading', { name: heading })
  fireEvent.click(screen.getByRole('button', { name: 'Skip' }))
  await waitFor(() => expect(save).toHaveBeenCalledWith(expect.objectContaining({ tutorialKey: key, tutorialAcknowledgment: { status: 'SKIPPED' } })))
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
})

test('automatic page tutorials wait until full dashboard access is active', async () => {
  const view = pageVisit('/vehicles', false)
  await waitFor(() => expect(read).toHaveBeenCalledOnce())
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
  view.rerender(<MemoryRouter initialEntries={['/vehicles']}><VendorTutorialProvider><FirstPage activated /></VendorTutorialProvider></MemoryRouter>)
  await screen.findByRole('heading', { name: 'Vehicles' })
})

test.each(['/dashboard', '/vehicles'])('first visit to %s waits for an open editor to close', async path => {
  const editor = document.createElement('dialog')
  editor.open = true
  document.body.append(editor)
  try {
    pageVisit(path)
    await waitFor(() => expect(read).toHaveBeenCalledOnce())
    expect(screen.queryByRole('heading', { name: path === '/dashboard' ? 'Your store, at a glance' : 'Vehicles' })).not.toBeInTheDocument()
    editor.remove()
    await screen.findByRole('heading', { name: path === '/dashboard' ? 'Your store, at a glance' : 'Vehicles' })
  } finally { editor.remove() }
})

test.each(['/dashboard', '/vehicles', '/invoices'])('leaving the automatic tutorial on %s dismisses it without navigating back', async path => {
  pageVisit(path)
  await screen.findByRole('heading', { name: path === '/dashboard' ? 'Your store, at a glance' : path === '/vehicles' ? 'Vehicles' : 'Practice E-Invoices' })
  fireEvent.click(screen.getByRole('button', { name: 'Change route' }))
  await waitFor(() => expect(save).toHaveBeenCalledWith(expect.objectContaining({ tutorialKey: path.slice(1), tutorialAcknowledgment: { status: 'SKIPPED' } })))
  expect(screen.queryByRole('heading', { name: 'Practice E-Invoices' })).not.toBeInTheDocument()
  await waitFor(() => expect(document.querySelector('[data-vendor-guide-path]')).toHaveAttribute('data-vendor-guide-path', '/finance'))
})

test('an already completed page stays quiet and record editors do not start automatic tours', async () => {
  read.mockResolvedValue({ data: [{ tutorialKey: 'vehicles', status: 'COMPLETED', updatedAt: new Date() }], meta: {}, errors: [] })
  const view = pageVisit('/vehicles')
  await waitFor(() => expect(read).toHaveBeenCalledOnce())
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
  view.unmount()
  read.mockResolvedValue({ data: [], meta: {}, errors: [] })
  pageVisit('/products/existing-draft')
  await waitFor(() => expect(read).toHaveBeenCalledTimes(2))
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
})

test('guides a first visit, supports Back, and saves Skip without changing work', async () => {
  render(<Provider><Harness /></Provider>)
  expect(await screen.findByRole('dialog', { name: 'Your store, at a glance' })).toBeVisible()
  expect(screen.getByRole('button', { name: 'Back' })).toBeDisabled()
  fireEvent.click(screen.getByRole('button', { name: 'Next' }))
  expect(screen.getByRole('heading', { name: 'Turn inquiries into quotations' })).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: 'Back' }))
  expect(screen.getByRole('heading', { name: 'Your store, at a glance' })).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: 'Skip' }))
  await waitFor(() => expect(save).toHaveBeenCalledWith({ tutorialPortal: 'vendors', tutorialKey: 'overview', tutorialAcknowledgment: { status: 'SKIPPED' } }))
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
  expect(screen.getByRole('heading', { name: 'Workspace' })).toBeVisible()
})

test('saved completion suppresses automatic display and help offers one continuous tour per feature', async () => {
  read.mockResolvedValue({ data: [{ tutorialKey: 'overview', status: 'COMPLETED', updatedAt: new Date() }, ...seenPages], meta: {}, errors: [] })
  render(<Provider><Harness /></Provider>)
  await waitFor(() => expect(read).toHaveBeenCalledTimes(1))
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Help / tutorial' }))
  expect(screen.getByRole('button', { name: 'Take the complete tour' })).toBeVisible()
  fireEvent.change(screen.getByRole('searchbox', { name: 'Find a page or feature' }), { target: { value: 'dashboard' } })
  expect(screen.getByRole('button', { name: 'Tour Dashboard' })).toBeVisible()
  expect(screen.queryByRole('button', { name: 'Traffic & Volume' })).not.toBeInTheDocument()
  expect(screen.queryByText('On this page')).not.toBeInTheDocument()
  expect(screen.queryByText('Vehicles')).not.toBeInTheDocument()
})

test('only includes enabled destinations and assigned fulfillment for the current role', () => {
  expect(vendorTourSteps(navigation).map(step => step.id)).toEqual(['dashboard', 'messages', 'orders', 'help'])
  expect(vendorTourSteps([{ label: 'Assigned', items: [{ href: '/fulfillment', label: 'Fulfillment' }] }]).map(step => step.id)).toEqual(['dashboard', 'fulfillment', 'help'])
  const products = [{ label: 'Products', items: [{ href: '/products', label: 'My Products' }] }]
  expect(vendorTourSteps(products).some(step => step.id === 'inventory')).toBe(false)
  expect(vendorTourSteps(products, ['inventory.view']).some(step => step.id === 'inventory')).toBe(true)
})

test.each([{ permissions: [] as string[] }, { permissions: ['catalog.manage', 'vehicles.manage', 'staff.manage'] }])('practice creation entries respect the current editing permissions: $permissions', async ({ permissions }) => {
  read.mockResolvedValue({ data: [{ tutorialKey: 'overview', status: 'COMPLETED', updatedAt: new Date() }, ...seenPages], meta: {}, errors: [] })
  render(<MemoryRouter initialEntries={['/invoices']}><VendorTutorialProvider><PracticeLibrary permissions={permissions} /></VendorTutorialProvider></MemoryRouter>)
  fireEvent.click(screen.getByRole('button', { name: 'Help / tutorial' }))
  const search = screen.getByRole('searchbox', { name: 'Find a page or feature' })
  for (const [query, permission, button] of [['product', 'catalog.manage', 'Practice adding a product'], ['vehicles', 'vehicles.manage', 'Practice adding a vehicle'], ['tracking', 'staff.manage', 'Practice Team Tracking']] as const) {
    fireEvent.change(search, { target: { value: query } })
    expect(Boolean(screen.queryByRole('button', { name: button }))).toBe(permissions.includes(permission!))
  }
  fireEvent.change(search, { target: { value: 'invoices' } })
  fireEvent.click(screen.getByRole('button', { name: 'Practice E-Invoices' }))
  await screen.findByRole('heading', { name: 'Practice E-Invoices' })
  fireEvent.click(screen.getByRole('button', { name: 'Next' }))
  expect(screen.queryByRole('button', { name: 'Send sample copy' })).not.toBeInTheDocument()
  expect(screen.getByText(/current role can view permitted invoice records/)).toBeInTheDocument()
})

test('one Products tour continues into Inventory and acknowledges both feature completions', async () => {
  read.mockResolvedValue({ data: [{ tutorialKey: 'overview', status: 'COMPLETED', updatedAt: new Date() }, ...seenPages], meta: {}, errors: [] })
  render(<MemoryRouter initialEntries={['/products']}><VendorTutorialProvider><LinkedProducts /></VendorTutorialProvider></MemoryRouter>)
  fireEvent.click(screen.getByRole('button', { name: 'Help / tutorial' }))
  fireEvent.change(screen.getByRole('searchbox', { name: 'Find a page or feature' }), { target: { value: 'products' } })
  fireEvent.click(screen.getByRole('button', { name: 'Tour Product listings' }))
  await screen.findByRole('heading', { name: 'Product listings' })
  fireEvent.click(screen.getByRole('button', { name: 'Next' }))
  await screen.findByRole('heading', { name: 'Inventory' })
  fireEvent.click(screen.getByRole('button', { name: 'Finish' }))
  await waitFor(() => expect(save).toHaveBeenCalledWith(expect.objectContaining({ tutorialKey: 'inventory', tutorialAcknowledgment: { status: 'COMPLETED' } })))
  expect(save).toHaveBeenCalledWith(expect.objectContaining({ tutorialKey: 'products', tutorialAcknowledgment: { status: 'COMPLETED' } }))
})

test('failed saves remain dismissible and can be retried explicitly', async () => {
  save.mockRejectedValueOnce(new Error('offline'))
  render(<Provider><Harness /></Provider>)
  fireEvent.click(await screen.findByRole('button', { name: 'Close tutorial' }))
  expect(await screen.findByText(/Tutorial progress could not be saved/)).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: 'Retry saving progress' }))
  await waitFor(() => expect(save).toHaveBeenCalledTimes(3))
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
})

test('a new signed-in account gets its own tour and page guidance opens automatically', async () => {
  read.mockResolvedValueOnce({ data: [{ tutorialKey: 'overview', status: 'SKIPPED', updatedAt: new Date() }], meta: {}, errors: [] })
  const view = render(<Provider key="first"><Harness path="/messages" /></Provider>)
  fireEvent.click(await screen.findByRole('button', { name: 'Skip' }))
  await waitFor(() => expect(save).toHaveBeenCalledWith(expect.objectContaining({ tutorialKey: 'messages', tutorialAcknowledgment: { status: 'SKIPPED' } })))
  view.rerender(<Provider key="second"><Harness /></Provider>)
  expect(await screen.findByRole('heading', { name: 'Your store, at a glance' })).toBeVisible()
})

test('editor window guidance leaves entered values in place and does not submit the form', async () => {
  read.mockResolvedValue({ data: [{ tutorialKey: 'overview', status: 'COMPLETED', updatedAt: new Date() }, ...seenPages], meta: {}, errors: [] })
  const submit = vi.fn((event: React.FormEvent) => event.preventDefault())
  render(<Provider><Harness /><FormDialog open title="Edit vehicle" description="Vehicle configuration" onClose={vi.fn()} footer={null}><form onSubmit={submit}><label><span>Vehicle name</span><input defaultValue="Unsaved van" /></label><button type="submit">Save vehicle</button></form></FormDialog></Provider>)
  fireEvent.click(await screen.findByRole('button', { name: 'Guide edit vehicle' }))
  expect(screen.getAllByRole('dialog', { name: 'Edit vehicle' })).toHaveLength(2)
  fireEvent.click(screen.getByRole('button', { name: 'Next' }))
  expect(screen.getByRole('heading', { name: 'Vehicle name' })).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: 'Close tutorial' }))
  expect(screen.getByRole('textbox', { name: 'Vehicle name' })).toHaveValue('Unsaved van')
  expect(submit).not.toHaveBeenCalled()
  expect(save).not.toHaveBeenCalled()
})
