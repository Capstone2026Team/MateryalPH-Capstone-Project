import { useRef, useState, type ReactNode } from 'react'
import { Field } from './field'
import { Button } from './button'
import { StatusMessage } from './status-message'
import { StatusBadge } from './portal-shell'
import { FieldRow, OnboardingFormSection } from './onboarding-fields'

export function EmailVerificationPanel({ email: serverEmail, verified: serverVerified, canChange, requestCode, confirmCode, explainError, phone, initialEmail, panel = false }: {
  email: string; verified: boolean; canChange: boolean; phone: ReactNode; initialEmail?: string; panel?: boolean
  requestCode: (email: string) => Promise<string>
  confirmCode: (email: string, code: string) => Promise<string>
  explainError: (error: unknown) => Promise<string>
}) {
  const [email, setEmail] = useState(initialEmail ?? serverEmail)
  const [editing, setEditing] = useState(Boolean(initialEmail && initialEmail !== serverEmail))
  const [code, setCode] = useState('')
  const [sentTo, setSentTo] = useState<string | null>(null)
  const [busy, setBusy] = useState<'send' | 'confirm' | null>(null)
  const [message, setMessage] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  const input = useRef<HTMLInputElement>(null)
  const normalized = email.trim().toLowerCase()
  const verified = serverVerified && normalized !== '' && normalized === serverEmail.trim().toLowerCase()
  async function send() {
    if (!input.current?.reportValidity()) return
    setBusy('send'); setSentTo(null); setCode(''); setMessage(null)
    try { const expiry = await requestCode(normalized); setSentTo(normalized); setMessage({ tone: 'success', text: `Verification code sent. ${expiry}` }) }
    catch (error) { setMessage({ tone: 'error', text: await explainError(error) }) }
    finally { setBusy(null) }
  }
  async function confirm() {
    if (sentTo !== normalized) return
    if (!/^\d{6}$/.test(code)) { setMessage({ tone: 'error', text: 'Enter the six-digit code from the email.' }); return }
    setBusy('confirm'); setMessage(null)
    try { setEmail(await confirmCode(normalized, code)); setEditing(false); setSentTo(null); setCode(''); setMessage({ tone: 'success', text: 'Store email verified.' }) }
    catch (error) { setMessage({ tone: 'error', text: await explainError(error) }) }
    finally { setBusy(null) }
  }
  return <OnboardingFormSection panel={panel} region title="Store contact information">
    <FieldRow><div className="relative min-w-0"><Field ref={input} label="Store email" name="store_email" type="email" required value={email} readOnly={!editing || busy !== null} className="pr-28" aria-describedby="store-email-help" onChange={event => { setEmail(event.target.value); setSentTo(null); setCode(''); setMessage(null) }} />
      {verified && <span className="absolute -top-1 right-0"><StatusBadge label="Verified" tone="success" /></span>}
      {canChange && <button type="button" className="absolute right-0 top-7 min-h-12 w-28 rounded-r-control border-l border-border-default px-3 text-sm font-semibold text-action-primary disabled:opacity-50" disabled={busy !== null} onClick={() => { if (editing) void send(); else { setEditing(true); setMessage(null); input.current?.focus() } }}>{busy === 'send' ? 'Sending…' : editing ? 'Send Code' : 'Change'}</button>}
    </div>{phone}</FieldRow>
    <p id="store-email-help" className="text-sm leading-6 text-text-secondary">This email will be used for store-related communication. A different email address must be verified before it can replace the existing Store Email.</p>
    {sentTo === normalized && <div className="grid max-w-xl min-w-0 items-end gap-3 sm:grid-cols-[minmax(0,1fr)_auto]"><Field label="Six-digit code" id="verification_code" inputMode="numeric" autoComplete="one-time-code" maxLength={6} value={code} disabled={busy !== null} onChange={event => setCode(event.target.value.replace(/\D/g, '').slice(0, 6))} /><Button type="button" disabled={busy !== null} onClick={() => void confirm()}>Confirm email</Button></div>}
    {message && <StatusMessage tone={message.tone}>{message.text}</StatusMessage>}
  </OnboardingFormSection>
}
