import { useEffect, useId, useState, type ReactNode } from 'react'
import { ImageOff, LockKeyhole } from 'lucide-react'
import { StatCard } from './page-patterns'
import './profile-details.css'

/** `card` frames the group on its own surface with stacked label/value pairs; `plain` keeps the ruled list. */
export function ProfileDetails({ title, items, action, columns = 2, appearance = 'plain' }: { title: string; items: [string, ReactNode][]; action?: ReactNode; columns?: 2 | 3; appearance?: 'plain' | 'card' }) {
  if (appearance === 'card') {
    return <section aria-label={title} className="min-w-0 mp-card">
      <div className="mp-card-padded flex flex-wrap items-center justify-between gap-3 border-b border-border-default"><h2 className="mp-card-heading">{title}</h2>{action}</div>
      <dl className={`mp-card-padded grid gap-x-8 gap-y-5 sm:grid-cols-2 ${columns === 3 ? 'xl:grid-cols-3' : ''}`}>{items.map(([label, value]) => <div key={label} className="min-w-0"><dt className="text-xs font-medium text-text-secondary">{label}</dt><dd className="mt-1 break-words text-sm font-semibold text-text-strong">{value || 'Not recorded'}</dd></div>)}</dl>
    </section>
  }
  return <section aria-label={title} className="min-w-0 space-y-5">
    <div className="flex flex-wrap items-center justify-between gap-3"><h2 className="text-lg font-semibold">{title}</h2>{action}</div>
    <dl className={`grid gap-x-8 sm:grid-cols-2 ${columns === 3 ? 'xl:grid-cols-3' : ''}`}>{items.map(([label, value]) => <div key={label} className="min-w-0 border-t border-border-default py-4"><dt className="text-sm text-text-secondary">{label}</dt><dd className="mt-1 break-words text-sm font-semibold">{value || 'Not recorded'}</dd></div>)}</dl>
  </section>
}

export function ProfileSplitPanel({ details, documents }: { details: ReactNode; documents: ReactNode }) {
  return <div className="grid min-w-0 items-start gap-6 xl:grid-cols-[minmax(0,1.6fr)_minmax(320px,1fr)]"><div className="min-w-0 space-y-6">{details}</div><aside aria-label="Business documents" className="min-w-0 space-y-5 mp-card mp-card-padded">{documents}</aside></div>
}

export function ProfileHeader({ eyebrow, name, avatar, metadata, statuses, actions, notice, banner, details, appearance = 'header' }: {
  eyebrow: string
  name: string
  avatar: ReactNode
  metadata?: ReactNode
  statuses: ReactNode
  actions?: ReactNode
  notice: string
  banner?: ReactNode
  details?: ReactNode
  appearance?: 'header' | 'sidebar'
}) {
  return <header className={`mp-card profile-header${appearance === 'sidebar' ? ' profile-header--sidebar' : ''}`}>
    {banner && <div className="profile-header__banner">{banner}</div>}
    <div className="profile-header__body">
      <div className="profile-header__identity">
        <div className="profile-header__avatar">{avatar}</div>
        <div className="profile-header__summary">
          <p className="profile-header__eyebrow">{eyebrow}</p>
          <h1>{name}</h1>
          {metadata && <div className="profile-header__metadata">{metadata}</div>}
          <div className="profile-header__statuses">{statuses}</div>
        </div>
      </div>
      {details && <div className="profile-header__details">{details}</div>}
      {actions && <div className="profile-header__actions">{actions}</div>}
    </div>
    <p className="profile-header__notice"><LockKeyhole size={15} aria-hidden="true" /><span>{notice}</span></p>
  </header>
}

/** Persistent identity, with the selected workspace alongside it on wide screens. */
export function ProfileWorkspace({ identity, children }: { identity: ReactNode; children: ReactNode }) {
  return <div className="profile-workspace"><aside className="profile-workspace__identity" aria-label="User identity and contact">{identity}</aside><div className="profile-workspace__content">{children}</div></div>
}

/** A single ruled surface for a profile's main details and supporting account information. */
export function ProfileDetailsLayout({ children, sidebar, appearance = 'ruled' }: { children: ReactNode; sidebar: ReactNode; appearance?: 'ruled' | 'cards' }) {
  return <div className={`profile-details-layout ${appearance === 'cards' ? 'profile-details-layout--cards' : 'mp-card'}`}>
    <div className="profile-details-layout__main">{children}</div>
    <div className="profile-details-layout__sidebar">{sidebar}</div>
  </div>
}

export function ProfileSection({ title, description, children, appearance = 'plain', icon }: { title: string; description?: string; children: ReactNode; appearance?: 'plain' | 'card'; icon?: ReactNode }) {
  const headingId = useId()
  return <section className={`profile-section${appearance === 'card' ? ' mp-card profile-section--card' : ''}`} aria-labelledby={headingId}>
    <div className="profile-section__heading">
      <h2 id={headingId}>{title}</h2>
      {description && <p>{description}</p>}
      {icon && <span className="profile-section__icon" aria-hidden="true">{icon}</span>}
    </div>
    {children}
  </section>
}

/** Compact, neutral metrics retain the shared calculation hints and accessible values. */
export function ProfileMetricGroup({ label, tiles }: { label: string; tiles: { label: string; value: ReactNode; hint?: string; icon?: ReactNode }[] }) {
  const id = useId()
  return <section className="mp-card profile-metric-group" aria-labelledby={id}><h2 id={id}>{label}</h2><dl aria-label={label} className="profile-metric-group__grid">{tiles.map(tile => <StatCard key={tile.label} {...tile} compact />)}</dl></section>
}

type ProfileImageProps = {
  src?: string | null | undefined
  name: string
  kind: 'buyer' | 'store' | 'banner'
  size?: 'default' | 'compact'
  loading?: boolean
  load?: (src: string) => Promise<Blob>
}

/** An optional loader keeps protected source URLs out of image requests. */
export function ProfileImage(props: ProfileImageProps) {
  return <ProfileImageContent key={`${props.kind}:${props.src ?? ''}`} {...props} />
}

function ProfileImageContent({ src, name, kind, size = 'default', loading = false, load }: ProfileImageProps) {
  const [failedImage, setFailedImage] = useState<string | null>(null)
  const [photo, setPhoto] = useState<{ source: string; loader: NonNullable<ProfileImageProps['load']>; url: string } | null>(null)
  const [failedLoad, setFailedLoad] = useState<{ source: string; loader: NonNullable<ProfileImageProps['load']> } | null>(null)

  useEffect(() => {
    if (!src || !load) return
    let active = true
    let objectUrl: string | undefined
    const source = src
    const loader = load
    async function readImage() {
      try {
        const blob = await loader(source)
        if (!active) return
        objectUrl = URL.createObjectURL(blob)
        setPhoto({ source, loader, url: objectUrl })
      } catch {
        if (active) setFailedLoad({ source, loader })
      }
    }
    void readImage()
    return () => {
      active = false
      if (objectUrl) URL.revokeObjectURL(objectUrl)
    }
  }, [src, load])

  const isBanner = kind === 'banner'
  const alt = kind === 'buyer' ? `${name} profile photo` : kind === 'store' ? `${name} logo` : `${name} store banner`
  const initials = name.trim().split(/\s+/).slice(0, 2).map(part => part[0]).join('').toUpperCase() || '—'
  const loadedPhoto = photo && photo.source === src && photo.loader === load ? photo.url : undefined
  const loadFailed = failedLoad && failedLoad.source === src && failedLoad.loader === load
  const imageSrc = load ? loadedPhoto : src
  const imageLoading = loading || Boolean(src && load && !loadedPhoto && !loadFailed)
  const showImage = Boolean(imageSrc) && failedImage !== imageSrc && !imageLoading
  return <span className={`profile-image profile-image--${kind}${size === 'compact' && !isBanner ? ' profile-image--compact' : ''}`} aria-busy={imageLoading || undefined}>
    {showImage ? <img src={imageSrc!} alt={alt} decoding="async" onError={() => setFailedImage(imageSrc ?? null)} /> : isBanner
      ? <span className="profile-image__banner-fallback" role={imageLoading ? 'status' : undefined}>
        <ImageOff size={24} aria-hidden="true" />
        <span>{imageLoading ? 'Loading store banner…' : src ? 'Banner unavailable' : 'No store banner provided'}</span>
      </span>
      : <span role="img" aria-label={imageLoading ? `Loading ${alt}` : `${alt} unavailable`} className="profile-image__initials">{initials}</span>}
  </span>
}
