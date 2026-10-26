import { useEffect, useId, useState, type ReactNode } from 'react'
import { ImageOff, LockKeyhole } from 'lucide-react'
import './profile-details.css'

/** `card` frames the group on its own surface with stacked label/value pairs; `plain` keeps the ruled list. */
export function ProfileDetails({ title, items, action, columns = 2, appearance = 'plain' }: { title: string; items: [string, ReactNode][]; action?: ReactNode; columns?: 2 | 3; appearance?: 'plain' | 'card' }) {
  if (appearance === 'card') {
    return <section aria-label={title} className="min-w-0 rounded-surface border border-border-default bg-surface-primary">
      <div className="flex flex-wrap items-center justify-between gap-3 border-b border-border-default px-5 py-4 sm:px-6"><h2 className="text-lg font-semibold">{title}</h2>{action}</div>
      <dl className={`grid gap-x-8 gap-y-5 px-5 py-5 sm:grid-cols-2 sm:px-6 ${columns === 3 ? 'xl:grid-cols-3' : ''}`}>{items.map(([label, value]) => <div key={label} className="min-w-0"><dt className="text-xs font-medium text-text-secondary">{label}</dt><dd className="mt-1 break-words text-sm font-semibold text-text-strong">{value || 'Not recorded'}</dd></div>)}</dl>
    </section>
  }
  return <section aria-label={title} className="min-w-0 space-y-5">
    <div className="flex flex-wrap items-center justify-between gap-3"><h2 className="text-lg font-semibold">{title}</h2>{action}</div>
    <dl className={`grid gap-x-8 sm:grid-cols-2 ${columns === 3 ? 'xl:grid-cols-3' : ''}`}>{items.map(([label, value]) => <div key={label} className="min-w-0 border-t border-border-default py-4"><dt className="text-sm text-text-secondary">{label}</dt><dd className="mt-1 break-words text-sm font-semibold">{value || 'Not recorded'}</dd></div>)}</dl>
  </section>
}

export function ProfileSplitPanel({ details, documents }: { details: ReactNode; documents: ReactNode }) {
  return <div className="grid min-w-0 items-start gap-6 xl:grid-cols-[minmax(0,1.6fr)_minmax(320px,1fr)]"><div className="min-w-0 space-y-6">{details}</div><aside aria-label="Business documents" className="min-w-0 space-y-5 rounded-surface border border-border-default bg-surface-primary p-5 sm:p-6">{documents}</aside></div>
}

export function ProfileHeader({ eyebrow, name, avatar, metadata, statuses, actions, notice, banner }: {
  eyebrow: string
  name: string
  avatar: ReactNode
  metadata?: ReactNode
  statuses: ReactNode
  actions?: ReactNode
  notice: string
  banner?: ReactNode
}) {
  return <header className="profile-header">
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
      {actions && <div className="profile-header__actions">{actions}</div>}
    </div>
    <p className="profile-header__notice"><LockKeyhole size={15} aria-hidden="true" /><span>{notice}</span></p>
  </header>
}

/** A single ruled surface for a profile's main details and supporting account information. */
export function ProfileDetailsLayout({ children, sidebar }: { children: ReactNode; sidebar: ReactNode }) {
  return <div className="profile-details-layout">
    <div className="profile-details-layout__main">{children}</div>
    <div className="profile-details-layout__sidebar">{sidebar}</div>
  </div>
}

export function ProfileSection({ title, description, children }: { title: string; description?: string; children: ReactNode }) {
  const headingId = useId()
  return <section className="profile-section" aria-labelledby={headingId}>
    <div className="profile-section__heading">
      <h2 id={headingId}>{title}</h2>
      {description && <p>{description}</p>}
    </div>
    {children}
  </section>
}

type ProfileImageProps = {
  src?: string | null | undefined
  name: string
  kind: 'buyer' | 'store' | 'banner'
  loading?: boolean
  load?: (src: string) => Promise<Blob>
}

/** An optional loader keeps protected source URLs out of image requests. */
export function ProfileImage(props: ProfileImageProps) {
  return <ProfileImageContent key={`${props.kind}:${props.src ?? ''}`} {...props} />
}

function ProfileImageContent({ src, name, kind, loading = false, load }: ProfileImageProps) {
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
  return <span className={`profile-image profile-image--${kind}`} aria-busy={imageLoading || undefined}>
    {showImage ? <img src={imageSrc!} alt={alt} decoding="async" onError={() => setFailedImage(imageSrc ?? null)} /> : isBanner
      ? <span className="profile-image__banner-fallback" role={imageLoading ? 'status' : undefined}>
        <ImageOff size={24} aria-hidden="true" />
        <span>{imageLoading ? 'Loading store banner…' : src ? 'Banner unavailable' : 'No store banner provided'}</span>
      </span>
      : <span role="img" aria-label={imageLoading ? `Loading ${alt}` : `${alt} unavailable`} className="profile-image__initials">{initials}</span>}
  </span>
}
