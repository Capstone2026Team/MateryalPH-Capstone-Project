import { RecaptchaCheckbox, type RecaptchaCheckboxProps, type RecaptchaCheckboxRef } from '@materyalph/web-ui'
import { forwardRef } from 'react'
import type { VendorBotAction } from '../../lib/recaptcha-enterprise'

export type VendorRecaptchaCheckboxRef = RecaptchaCheckboxRef

export const VendorRecaptchaCheckbox = forwardRef<VendorRecaptchaCheckboxRef, Omit<RecaptchaCheckboxProps, 'siteKey' | 'action'> & { action: VendorBotAction }>(
  function VendorRecaptchaCheckbox(props, ref) {
    return <RecaptchaCheckbox {...props} ref={ref} siteKey={import.meta.env.VITE_RECAPTCHA_SITE_KEY} />
  },
)
