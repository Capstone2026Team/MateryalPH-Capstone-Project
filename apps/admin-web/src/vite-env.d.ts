/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_API_BASE_URL?: string
  readonly VITE_API_READ_TIMEOUT_MS?: string
  readonly VITE_RECAPTCHA_SITE_KEY?: string
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}
