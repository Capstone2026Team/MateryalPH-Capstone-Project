const brandIconUrl = new URL('./assets/materyalph-icon.png', import.meta.url).href

/** Compact, consistent branding for every Admin and Vendor authentication page. */
export function PortalBrand({ portal }: { portal: 'admin' | 'vendor' }) {
  return <span className="inline-flex min-h-11 items-center gap-2 text-text-strong">
    <img className="h-9 w-9 shrink-0 object-contain" src={brandIconUrl} alt="" aria-hidden="true" width={36} height={36} />
    <span className="whitespace-nowrap text-lg font-bold leading-6 tracking-tight">Materyal<span className="text-action-primary-pressed">PH</span></span>
    <span className="border-l border-border-default pl-2 text-xs font-semibold leading-4 text-text-secondary">{portal === 'admin' ? 'Admin' : 'Vendor'}</span>
  </span>
}
