import { useEffect, useState } from 'react'
import { AccountsApi, ResponseError } from '@materyalph/api-client-ts'
import { createWebApiConfiguration, readAccountPhoto } from './web-api-session'

export function AccountAvatar({ portal, basePath, avatarUrl, fullName, className, alt = '' }: {
  portal: 'vendors' | 'admin'
  basePath: string
  avatarUrl?: string | null | undefined
  fullName: string
  className: string
  alt?: string
}) {
  const [photo, setPhoto] = useState<{ source: string; url: string } | null>(null)

  useEffect(() => {
    let active = true
    let objectUrl = ''
    setPhoto(null)
    if (!avatarUrl) return
    const source = avatarUrl
    async function load() {
      let blob: Blob
      try {
        blob = await readAccountPhoto(basePath, portal, source)
      } catch (error) {
        // An expired signature or a changed profile version needs a new owner-bound link.
        // Renew once; a denied or missing photo must never cause a request loop.
        if (!active || !(error instanceof ResponseError) || ![403, 404].includes(error.response.status)) return
        const { data } = await new AccountsApi(createWebApiConfiguration(basePath, { refreshSession: true })).getAccountProfile({ accountPortal: portal })
        if (!active || !data.avatarUrl) return
        blob = await readAccountPhoto(basePath, portal, data.avatarUrl)
      }
      if (!active) return
      objectUrl = URL.createObjectURL(blob)
      setPhoto({ source, url: objectUrl })
    }
    void load().catch(() => {})
    return () => { active = false; if (objectUrl) URL.revokeObjectURL(objectUrl) }
  }, [avatarUrl, basePath, portal])

  const initials = fullName.trim().split(/\s+/).slice(0, 2).map(part => part[0]).join('').toUpperCase() || '…'
  return <span className={className}>{photo && photo.source === avatarUrl ? <img src={photo.url} alt={alt} className="h-full w-full object-cover" onError={() => setPhoto(null)} /> : initials}</span>
}
