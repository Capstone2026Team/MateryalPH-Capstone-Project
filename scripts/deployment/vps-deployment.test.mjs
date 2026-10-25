import assert from 'node:assert/strict'
import { test } from 'node:test'
import { mkdtempSync, rmSync, writeFileSync, readFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import { parseEnv } from 'node:util'
import { configuration, validateDns, duckdns, rawEnvironment, validateApi } from './vps-config.mjs'
import { validateScenario, percentile, measure } from './load-vps.mjs'

function control() {
  return configuration({ ...parseEnv(readFileSync(new URL('../../infrastructure/vps/.env.example', import.meta.url), 'utf8')),
    VPS_DEPLOY_COMMIT: 'a'.repeat(40), VPS_API_IMAGE: 'sha256:' + 'b'.repeat(64), VPS_EDGE_IMAGE: 'sha256:' + 'c'.repeat(64), VPS_IPV4: '192.0.2.25',
    ...Object.fromEntries(['VPS_API_ENV_FILE', 'VPS_REVERB_ENV_FILE', 'VPS_BACKUP_ENV_FILE', 'VPS_DB_OWNER_PASSWORD_FILE', 'VPS_DB_APP_PASSWORD_FILE', 'VPS_BACKUP_PASSWORD_FILE', 'VPS_RECOVERY_DIRECTORY', 'DUCKDNS_TOKEN_FILE'].map(key => [key, resolve(tmpdir(), key)])),
  })
}

test('release references and all four shared hostname suffixes are explicit', () => {
  const config = control()
  assert.equal(config.hosts.length, 4)
  assert.equal(configuration({ ...config, DUCKDNS_TOKEN_FILE: undefined }).hosts.length, 4)
  assert.throws(() => configuration({ ...config, VPS_API_IMAGE: 'materyalph:latest' }))
  assert.throws(() => configuration({ ...config, VPS_ADMIN_HOST: 'materyalph27-admin.duckdns.org' }))
})

test('raw secret inputs retain literal values and reject duplicate or malformed names', () => {
  const values = rawEnvironment('PASSWORD=literal$UNDEFINED #suffix\nQUOTED="literal"\nEMPTY=\n')
  assert.equal(values.PASSWORD, 'literal$UNDEFINED #suffix')
  assert.equal(values.QUOTED, '"literal"')
  assert.equal(values.EMPTY, '')
  for (const input of ['KEY=first\nKEY=second', 'MULTILINE=first\nsecond', 'KEY=bad\0', 'KEY=first\rsecond']) assert.throws(() => rawEnvironment(input))
})

test('provider draft pins callback, portal origins, captcha identities and broadcasting', () => {
  const api = rawEnvironment(readFileSync(new URL('../../infrastructure/vps/api/.env.example', import.meta.url), 'utf8'))
  for (const key of Object.keys(api)) if (!api[key] && key !== 'SESSION_DOMAIN') api[key] = 'synthetic-only'
  Object.assign(api, { APP_KEY: `base64:${Buffer.alloc(32).toString('base64')}`, DB_PASSWORD: 's'.repeat(32),
    AWS_ENDPOINT: 'https://storage.example.test', MAIL_DELIVERY_NOT_BEFORE: '2026-10-23T00:00:00Z', OUTBOX_DELIVERY_NOT_BEFORE: '2026-10-23T00:00:00Z' })
  const reverb = rawEnvironment(readFileSync(new URL('../../infrastructure/vps/reverb/.env.example', import.meta.url), 'utf8'))
  for (const key of ['APP_KEY', 'REVERB_APP_KEY', 'REVERB_APP_SECRET']) reverb[key] = api[key]
  validateApi(control(), api, reverb, api.DB_PASSWORD)
  for (const key of ['FRONTEND_VENDOR_URL', 'FRONTEND_ADMIN_URL', 'GOOGLE_OIDC_REDIRECT_URI', 'CORS_ALLOWED_ORIGINS',
    'RECAPTCHA_VENDOR_WEB_ALLOWED_HOSTNAMES', 'RECAPTCHA_ADMIN_WEB_ALLOWED_HOSTNAMES', 'BROADCAST_CONNECTION', 'HASH_DRIVER']) {
    assert.throws(() => validateApi(control(), { ...api, [key]: 'stale-deployment' }, reverb, api.DB_PASSWORD))
  }
})

test('DNS rejects stale addresses, extra addresses and IPv6 routes', async () => {
  const config = control()
  const absent = async () => { throw Object.assign(new Error(), { code: 'ENODATA' }) }
  await validateDns(config, async () => ['192.0.2.25'], absent)
  await assert.rejects(validateDns(config, async () => ['192.0.2.26'], absent))
  await assert.rejects(validateDns(config, async () => ['192.0.2.25', '192.0.2.26'], absent))
  await assert.rejects(validateDns(config, async () => ['192.0.2.25'], async () => ['::1']))
})

test('DuckDNS network errors cannot expose a token or response', async () => {
  const directory = mkdtempSync(join(tmpdir(), 'materyalph-dns-'))
  try {
    const token = 'a'.repeat(36)
    const path = join(directory, 'token')
    writeFileSync(path, token, { mode: 0o600 })
    await assert.rejects(duckdns({ ...control(), DUCKDNS_TOKEN_FILE: path }, async url => { throw new Error(url.href) }), error => !error.message.includes(token))
  } finally { rmSync(directory, { recursive: true }) }
})

const scenario = () => ({ origin: 'https://materyalph26-api.duckdns.org', syntheticDataConfirmed: true,
  actors: Array.from({ length: 20 }, (_, index) => ({ role: ['buyer', 'vendor', 'admin'][index % 3], headers: { Authorization: 'synthetic-test-only' }, requests: ['/buyers/listings/search'] })),
})
test('load gate requires all roles and synthetic data; rejects provider/foreign routes', () => {
  assert.equal(validateScenario(scenario()), 'https://materyalph26-api.duckdns.org')
  assert.throws(() => validateScenario({ ...scenario(), syntheticDataConfirmed: false }))
  for (const route of ['https://other.test/buyers/listings/search', '/buyers/discovery/routes', '//other.test/buyers/listings/search']) {
    const invalid = scenario(); invalid.actors[0].requests = [route]; assert.throws(() => validateScenario(invalid))
  }
  assert.equal(percentile([100, 2, 3, 5, 20], 0.95), 100)
})

test('load reports only aggregate outcomes, consumes JSON and requires sufficient samples', async () => {
  const report = await measure(scenario(), 0.01, async url => {
    assert.match(url, /^https:\/\/materyalph26-api\.duckdns\.org\/api\/v1\/buyers\/listings\/search$/)
    return { status: 200, json: async () => ({ data: { confidential: 'do-not-report' }, errors: [] }) }
  })
  assert.equal(report.users, 20)
  assert.equal(report.passed, false)
  assert.ok(!JSON.stringify(report).includes('do-not-report'))
  assert.ok(!JSON.stringify(report).includes('synthetic-test-only'))
})
