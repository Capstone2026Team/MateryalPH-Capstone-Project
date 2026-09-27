import { AgreementsApi, type Agreement } from '@materyalph/api-client-ts'
import { useEffect, useState } from 'react'
import { Button } from './button'
import { StatusMessage } from './status-message'
import { createWebApiConfiguration } from './web-api-session'

export function PublishedAgreementReader({ basePath, code }: { basePath: string; code: string }) {
  const [agreement, setAgreement] = useState<Agreement | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(false)
  const [attempt, setAttempt] = useState(0)

  useEffect(() => {
    let active = true
    setLoading(true)
    setAgreement(null)
    setError(false)
    void new AgreementsApi(createWebApiConfiguration(basePath)).listCurrentAgreements().then(response => {
      if (!active) return
      const current = response.data.filter(item => item.code === code && ['ALL', 'VENDOR'].includes(item.audience))
        .sort((a, b) => b.version - a.version)[0]
      if (!current?.content?.trim()) setError(true)
      else setAgreement(current)
    }).catch(() => { if (active) setError(true) })
      .finally(() => { if (active) setLoading(false) })
    return () => { active = false }
  }, [basePath, code, attempt])

  if (loading) return <StatusMessage>Loading the published document…</StatusMessage>
  if (error || !agreement) return <div className="grid gap-4"><StatusMessage tone="error">This document could not be loaded. Please try again before continuing registration.</StatusMessage><div><Button variant="secondary" onClick={() => setAttempt(value => value + 1)}>Try again</Button></div></div>

  return <article aria-label={agreement.title} className="grid gap-6">
    <p className="text-sm text-text-secondary">Version {agreement.version} · Effective {agreement.effectiveAt.toLocaleDateString('en-PH', { timeZone: 'Asia/Manila', year: 'numeric', month: 'long', day: 'numeric' })}</p>
    <div className="break-words text-sm leading-7 text-text-strong">{agreement.content?.split(/\n\s*\n/).map((block, index) => {
      if (block.startsWith('# ')) return <p key={index} className="text-lg font-semibold">{block.slice(2)}</p>
      if (block.startsWith('## ')) return <h2 key={index} className="mb-3 mt-8 text-lg font-semibold">{block.slice(3)}</h2>
      return <p key={index} className="mb-4 whitespace-pre-wrap">{block}</p>
    })}</div>
  </article>
}
