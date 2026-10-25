import { parseEnv } from 'node:util'
import { readFileSync, lstatSync } from 'node:fs'
import { isAbsolute } from 'node:path'
import { isIP } from 'node:net'
import { resolve4, resolve6 } from 'node:dns/promises'
import { pathToFileURL } from 'node:url'

export const hostKeys = ['VPS_API_HOST', 'VPS_VENDOR_HOST', 'VPS_ADMIN_HOST', 'VPS_REVERB_HOST']
export const readEnv = path => parseEnv(readFileSync(path, 'utf8'))
// Compose's raw secret files preserve quotes, dollar signs and inline hashes verbatim.
export function rawEnvironment(contents) {
  const values = Object.create(null)
  for (const line of contents.replace(/^\uFEFF/, '').split(/\r?\n/)) {
    if (!line.trim() || line.trimStart().startsWith('#')) continue
    const separator = line.indexOf('=')
    const key = line.slice(0, separator)
    if (separator < 1 || !/^[A-Z][A-Z0-9_]*$/.test(key) || Object.hasOwn(values, key) || /[\r\0]/.test(line)) throw new Error('Use unique flat raw environment inputs.')
    values[key] = line.slice(separator + 1)
  }
  return values
}
const imagePattern = /^(?:sha256:|[a-z0-9][a-z0-9./:_-]*@sha256:)[a-f0-9]{64}$/

export function configuration(env) {
  if (!/^[a-f0-9]{40}$/.test(env.VPS_DEPLOY_COMMIT ?? '')) throw new Error('Select the exact accepted commit.')
  for (const key of ['VPS_API_IMAGE', 'VPS_EDGE_IMAGE']) {
    if (!imagePattern.test(env[key] ?? '') || /0{64}$/.test(env[key])) throw new Error(`${key} must be an immutable image ID or digest.`)
  }
  const hosts = hostKeys.map(key => {
    const host = env[key] ?? ''
    if (!/^[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.duckdns\.org$/.test(host) || /replace/i.test(host)) throw new Error(`Configure the reserved ${key} hostname.`)
    return host
  })
  if (new Set(hosts).size !== 4) throw new Error('Each surface requires a distinct hostname.')
  const prefix = hosts[0].match(/^(materyalph\d+)-api\.duckdns\.org$/)?.[1]
  if (!prefix || hosts.some((host, index) => host !== `${prefix}-${['api', 'vendor', 'admin', 'ws'][index]}.duckdns.org`)) throw new Error('Use one shared numeric suffix across the four MateryalPH hostnames.')
  if (isIP(env.VPS_IPV4 ?? '') !== 4) throw new Error('Set the confirmed VPS IPv4 address.')
  for (const key of ['VPS_API_ENV_FILE', 'VPS_REVERB_ENV_FILE', 'VPS_BACKUP_ENV_FILE', 'VPS_DB_OWNER_PASSWORD_FILE', 'VPS_DB_APP_PASSWORD_FILE', 'VPS_BACKUP_PASSWORD_FILE', 'VPS_RECOVERY_DIRECTORY']) {
    if (!isAbsolute(env[key] ?? '') || /[\r\n\0]/.test(env[key])) throw new Error(`${key} must be an absolute private path.`)
  }
  return { ...env, hosts }
}

function requireValues(env, keys) {
  const missing = keys.filter(key => !env[key] || /REPLACE/.test(env[key]))
  if (missing.length) throw new Error(`Missing configuration names: ${missing.join(', ')}.`)
}

function privateHttpsEndpoint(value) {
  try {
    const url = new URL(value)
    return url.protocol === 'https:' && !url.username && !url.password && !url.search && !url.hash
  } catch { return false }
}

export function validateApi(config, api, reverb, appPassword) {
  const fixed = {
    APP_ENV: 'staging', APP_DEBUG: 'false', DB_CONNECTION: 'pgsql', DB_HOST: 'postgres',
    DB_USERNAME: 'materyalph_app', CACHE_STORE: 'redis',
    QUEUE_CONNECTION: 'redis', SESSION_DRIVER: 'redis', COOKIE_SECURE: 'true',
    XENDIT_MODE: 'TEST', LIVE_COMMERCE_ENABLED: 'false', FILESYSTEM_DISK: 's3',
    VENDOR_PRIVATE_DISK: 's3', SCANNER_DRIVER: 'bouncer', RECAPTCHA_ENABLED: 'true',
    TRUSTED_PROXIES: '172.30.240.0/24', REVERB_HOST: 'reverb', REVERB_PORT: '10000',
    REVERB_SCHEME: 'http', REVERB_PUBLIC_SCHEME: 'https', REVERB_PUBLIC_PORT: '443',
    FRONTEND_BUYER_REDIRECT_URI: 'materyalph://auth/callback', BROADCAST_CONNECTION: 'reverb',
    // Sign-in verifies only Argon2 hashes; any other driver locks out every reset or new account.
    HASH_DRIVER: 'argon2id',
  }
  for (const [key, value] of Object.entries(fixed)) if (api[key] !== value) throw new Error(`Invalid staging setting: ${key}.`)
  if (!/^materyalph_(?:staging|restore_\d{14})$/.test(api.DB_DATABASE ?? '')) throw new Error('Use the dedicated staging database or a newly restored staging database.')
  if (api.SESSION_DOMAIN) throw new Error('Use host-only portal cookies.')
  if (api.APP_URL !== `https://${config.VPS_API_HOST}` || api.FRONTEND_VENDOR_HOST !== config.VPS_VENDOR_HOST || api.FRONTEND_ADMIN_HOST !== config.VPS_ADMIN_HOST || api.REVERB_PUBLIC_HOST !== config.VPS_REVERB_HOST) throw new Error('API public addresses must match the reserved deployment hosts.')
  const publicBoundaries = {
    FRONTEND_VENDOR_URL: `https://${config.VPS_VENDOR_HOST}`, FRONTEND_ADMIN_URL: `https://${config.VPS_ADMIN_HOST}`,
    CORS_ALLOWED_ORIGINS: `https://${config.VPS_VENDOR_HOST},https://${config.VPS_ADMIN_HOST}`,
    RECAPTCHA_VENDOR_WEB_ALLOWED_HOSTNAMES: config.VPS_VENDOR_HOST, RECAPTCHA_ADMIN_WEB_ALLOWED_HOSTNAMES: config.VPS_ADMIN_HOST,
    GOOGLE_OIDC_REDIRECT_URI: `https://${config.VPS_VENDOR_HOST}/api/v1/auth/google/callback`,
  }
  for (const [key, value] of Object.entries(publicBoundaries)) if (api[key] !== value) throw new Error(`Deployment hostname mismatch: ${key}.`)
  requireValues(api, ['APP_KEY', 'PASSPORT_PRIVATE_KEY_BASE64', 'PASSPORT_PUBLIC_KEY_BASE64', 'DB_PASSWORD', 'AWS_ACCESS_KEY_ID', 'AWS_SECRET_ACCESS_KEY', 'AWS_DEFAULT_REGION', 'AWS_BUCKET', 'AWS_ENDPOINT', 'CLOUDINARY_CLOUD_NAME', 'CLOUDINARY_API_KEY', 'CLOUDINARY_API_SECRET', 'BOUNCER_API_KEY', 'MAIL_USERNAME', 'MAIL_PASSWORD', 'MAIL_FROM_ADDRESS', 'MAIL_DELIVERY_NOT_BEFORE', 'OUTBOX_DELIVERY_NOT_BEFORE', 'RECAPTCHA_GOOGLE_CLOUD_PROJECT_ID', 'RECAPTCHA_ENTERPRISE_API_KEY', 'RECAPTCHA_VENDOR_WEB_SITE_KEY', 'RECAPTCHA_ADMIN_WEB_SITE_KEY', 'GOOGLE_OIDC_CLIENT_ID', 'GOOGLE_OIDC_CLIENT_SECRET', 'GOOGLE_MAPS_SERVER_API_KEY', 'XENDIT_SECRET_KEY', 'XENDIT_WEBHOOK_VERIFICATION_TOKEN', 'REVERB_APP_ID', 'REVERB_APP_KEY', 'REVERB_APP_SECRET', 'FIREBASE_PROJECT_ID', 'FIREBASE_SERVICE_ACCOUNT_JSON_BASE64', 'PRIVACY_CONTACT_EMAIL'])
  if (!/^base64:[A-Za-z0-9+/]{43}=$/.test(api.APP_KEY)) throw new Error('Use the staging Laravel base64-prefixed 256-bit APP_KEY.')
  if (api.DB_PASSWORD !== appPassword.trim() || appPassword.trim().length < 32) throw new Error('The application DB password must match its private password file and contain at least 32 characters.')
  if (!privateHttpsEndpoint(api.AWS_ENDPOINT) || api.AWS_URL || api.APP_PREVIOUS_KEYS) throw new Error('Use private HTTPS storage without embedded credentials, public URL overrides or source encryption keys.')
  if (!Number.isFinite(Date.parse(api.MAIL_DELIVERY_NOT_BEFORE))) throw new Error('Set the import mail delivery boundary before processing jobs.')
  if (!/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?Z$/.test(api.OUTBOX_DELIVERY_NOT_BEFORE) || !Number.isFinite(Date.parse(api.OUTBOX_DELIVERY_NOT_BEFORE))) throw new Error('Set a valid UTC outbox import boundary.')
  if (api.MAIL_REQUIRE_TLS !== 'true') throw new Error('Transactional mail requires TLS.')
  for (const key of ['APP_ENV', 'APP_DEBUG', 'APP_KEY', 'REVERB_APP_ID', 'REVERB_APP_KEY', 'REVERB_APP_SECRET']) if (reverb[key] !== api[key]) throw new Error(`Reverb configuration mismatch: ${key}.`)
  if (reverb.REVERB_ALLOWED_ORIGINS !== `${config.VPS_VENDOR_HOST},${config.VPS_ADMIN_HOST}`) throw new Error('Use the exact Reverb portal allowlist.')
  for (const key of Object.keys(reverb)) if (/^(AWS_|PASSPORT_|XENDIT_|MAIL_PASSWORD|BOUNCER_|FIREBASE_SERVICE_ACCOUNT)/.test(key)) throw new Error('Reverb must not receive unrelated provider credentials.')
}

export async function validateDns(config, dns4 = resolve4, dns6 = resolve6) {
  for (const host of config.hosts) {
    const addresses = await dns4(host)
    if (addresses.length !== 1 || addresses[0] !== config.VPS_IPV4) throw new Error('All reserved hostnames must resolve exclusively to the confirmed VPS IPv4.')
    let ipv6 = []
    try { ipv6 = await dns6(host) } catch (error) { if (!['ENODATA', 'ENOTFOUND'].includes(error.code)) throw error }
    if (ipv6.length) throw new Error('Remove stale AAAA records before the IPv4-only deployment.')
  }
}

export function privateFile(path) {
  const stat = lstatSync(path)
  if (!stat.isFile() || stat.isSymbolicLink()) throw new Error('Use ordinary private input files.')
  if (process.platform !== 'win32' && (stat.mode & 0o077)) throw new Error('Private input files must have mode 0600 or stricter.')
  return readFileSync(path, 'utf8')
}

export async function preflight(path, checkDns = true) {
  const config = configuration(readEnv(path))
  const api = rawEnvironment(privateFile(config.VPS_API_ENV_FILE))
  const reverb = rawEnvironment(privateFile(config.VPS_REVERB_ENV_FILE))
  validateApi(config, api, reverb, privateFile(config.VPS_DB_APP_PASSWORD_FILE))
  for (const key of ['VPS_DB_OWNER_PASSWORD_FILE', 'VPS_BACKUP_PASSWORD_FILE']) if (privateFile(config[key]).trim().length < 32) throw new Error(`Configure a private ${key}.`)
  const backup = rawEnvironment(privateFile(config.VPS_BACKUP_ENV_FILE))
  requireValues(backup, ['RESTIC_REPOSITORY', 'AWS_ACCESS_KEY_ID', 'AWS_SECRET_ACCESS_KEY'])
  if (!backup.RESTIC_REPOSITORY.startsWith('s3:') || !privateHttpsEndpoint(backup.RESTIC_REPOSITORY.slice(3)) || backup.AWS_ACCESS_KEY_ID === api.AWS_ACCESS_KEY_ID) throw new Error('Use a separate HTTPS offsite backup repository and scoped key.')
  if (checkDns) await validateDns(config)
  return config
}

export async function duckdns(config, fetcher = fetch) {
  if (!isAbsolute(config.DUCKDNS_TOKEN_FILE ?? '')) throw new Error('Configure an absolute private DuckDNS token path only when using the DNS updater.')
  const token = privateFile(config.DUCKDNS_TOKEN_FILE).trim()
  if (!/^[a-f0-9-]{32,64}$/i.test(token)) throw new Error('Configure the private DuckDNS token file.')
  const url = new URL('https://www.duckdns.org/update')
  url.searchParams.set('domains', config.hosts.map(host => host.replace(/\.duckdns\.org$/, '')).join(','))
  url.searchParams.set('token', token)
  url.searchParams.set('ip', config.VPS_IPV4)
  let response
  try { response = await fetcher(url, { redirect: 'error', signal: AbortSignal.timeout(20_000) }) } catch { throw new Error('DuckDNS update failed; no token or provider response was logged.') }
  if (!response.ok || (await response.text()).trim() !== 'OK') throw new Error('DuckDNS rejected the update; reserve all four hostnames in the authenticated account first.')
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  try {
    const [command, path] = process.argv.slice(2)
    if (!path || !['validate', 'duckdns'].includes(command)) throw new Error('Usage: node scripts/deployment/vps-config.mjs validate|duckdns PRIVATE_CONTROL_FILE')
    if (command === 'duckdns') await duckdns(configuration(readEnv(path)))
    else await preflight(path)
    console.log(`${command}: deployment configuration passed; no credentials printed.`)
  } catch (error) { console.error(error.message); process.exitCode = 1 }
}
