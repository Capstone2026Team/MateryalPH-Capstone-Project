import { lazy, Suspense } from 'react'
import { AsyncLoading } from '@materyalph/web-ui'

import type { VendorPracticeKind } from '../lib/vendor-tutorial-catalog'
const components = {
  products: lazy(() => import('./VendorProductPractice')),
  vehicles: lazy(() => import('./VendorVehiclePractice')),
  invoices: lazy(() => import('./VendorInvoicePractice')),
  tracking: lazy(() => import('./VendorTrackingPractice')),
}
export default function VendorPractice({ kind, onClose, canPrepareInvoices }: { kind: VendorPracticeKind; onClose: (completed: boolean) => void; canPrepareInvoices: boolean }) {
  const Practice = components[kind]
  return <Suspense fallback={<AsyncLoading compact label="Opening tutorial demo…" />}><Practice onClose={onClose} canPrepare={canPrepareInvoices} /></Suspense>
}
