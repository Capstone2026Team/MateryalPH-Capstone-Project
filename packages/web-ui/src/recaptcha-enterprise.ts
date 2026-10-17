import type { VendorBotProtectionEvidence } from '@materyalph/api-client-ts'

export type WebBotAction = 'vendor_register' | 'vendor_login' | 'vendor_password_recovery' | 'vendor_invitation_accept' | 'admin_login' | 'admin_invitation_accept' | 'admin_password_recovery'

type CheckboxParameters = {
  sitekey: string
  action: WebBotAction
  callback(token: string): void
  'expired-callback'(): void
  'error-callback'(): void
}

type RecaptchaEnterpriseApi = {
  ready(callback: () => void): void
  render(container: HTMLElement, parameters: CheckboxParameters): number
  reset(widgetId: number): void
}

declare global {
  interface Window {
    grecaptcha?: { enterprise?: RecaptchaEnterpriseApi }
  }
}

export type EnterpriseCheckboxHandle = {
  reset(): void
}

type CheckboxCallbacks = {
  onToken(token: string | null): void
  onError(message: string): void
}

let loader: Promise<RecaptchaEnterpriseApi> | null = null

export async function renderWebCheckbox(
  container: HTMLElement,
  siteKey: string | undefined,
  action: WebBotAction,
  callbacks: CheckboxCallbacks,
  signal?: AbortSignal,
): Promise<EnterpriseCheckboxHandle> {
  const sitekey = siteKey?.trim()
  if (!sitekey) throw new BotProtectionConfigurationError('Bot protection is not configured for this portal.')
  const enterprise = await bounded(loadEnterprise())
  if (signal?.aborted) throw new RecaptchaRenderCancelledError()
  if (container.dataset.materyalphRecaptchaWidget === 'rendered') {
    throw new Error('The security checkbox is already active.')
  }

  let widgetId: number | null = null

  const reset = () => {
    callbacks.onToken(null)
    if (widgetId !== null) enterprise.reset(widgetId)
  }

  container.dataset.materyalphRecaptchaWidget = 'rendered'
  try {
    widgetId = enterprise.render(container, {
      sitekey,
      action,
      callback: (token) => callbacks.onToken(token || null),
      'expired-callback': reset,
      'error-callback': () => {
        reset()
        callbacks.onError('The security checkbox is unavailable. Try again or use the email security check.')
      },
    })
  } catch (error) {
    delete container.dataset.materyalphRecaptchaWidget
    throw error
  }

  return { reset }
}

export function webBotEvidence(
  token: string | null,
  accessibleFallback = false,
): VendorBotProtectionEvidence {
  if (accessibleFallback) return { requestEmailStepUp: true }
  if (!token) throw new Error('Complete the security checkbox before continuing.')

  return { recaptchaToken: token }
}

export function webCookieBotEvidence(): VendorBotProtectionEvidence {
  return {}
}

async function loadEnterprise(): Promise<RecaptchaEnterpriseApi> {
  if (window.grecaptcha?.enterprise) return waitUntilReady(window.grecaptcha.enterprise)
  if (loader) return loader

  loader = new Promise<RecaptchaEnterpriseApi>((resolve, reject) => {
    const script = document.createElement('script')
    script.src = 'https://www.google.com/recaptcha/enterprise.js?render=explicit'
    script.async = true
    script.defer = true
    script.dataset.materyalphRecaptcha = 'enterprise-checkbox'
    script.addEventListener('load', () => {
      const enterprise = window.grecaptcha?.enterprise
      if (!enterprise) {
        loader = null
        reject(new Error('The security checkbox could not be loaded.'))
        return
      }
      void waitUntilReady(enterprise).then(resolve, reject)
    }, { once: true })
    script.addEventListener('error', () => {
      loader = null
      reject(new Error('The security checkbox could not be loaded.'))
    }, { once: true })
    document.head.append(script)
  })

  return loader
}

function waitUntilReady(enterprise: RecaptchaEnterpriseApi): Promise<RecaptchaEnterpriseApi> {
  return new Promise((resolve) => enterprise.ready(() => resolve(enterprise)))
}

export class BotProtectionConfigurationError extends Error {}

export class RecaptchaRenderCancelledError extends Error {}

function bounded<T>(operation: Promise<T>): Promise<T> {
  return new Promise((resolve, reject) => {
    const timer = window.setTimeout(() => reject(new Error('Security check timed out.')), 10000)
    operation.then(
      (value) => { window.clearTimeout(timer); resolve(value) },
      (error: unknown) => { window.clearTimeout(timer); reject(error) },
    )
  })
}

export function resetEnterpriseLoaderForTests(): void {
  loader = null
}
