import {
  renderWebCheckbox,
  type WebBotAction,
} from '@materyalph/web-ui'

export {
  BotProtectionConfigurationError,
  RecaptchaRenderCancelledError,
  resetEnterpriseLoaderForTests,
  webBotEvidence as vendorBotEvidence,
  webCookieBotEvidence,
  type EnterpriseCheckboxHandle,
} from '@materyalph/web-ui'

export type VendorBotAction = Extract<WebBotAction, `vendor_${string}`>

export function renderVendorCheckbox(
  container: HTMLElement,
  action: VendorBotAction,
  callbacks: Parameters<typeof renderWebCheckbox>[3],
  signal?: AbortSignal,
) {
  return renderWebCheckbox(container, import.meta.env.VITE_RECAPTCHA_SITE_KEY, action, callbacks, signal)
}
