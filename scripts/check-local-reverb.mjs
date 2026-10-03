// Local infrastructure smoke check. Credentials stay in memory and are never printed.
// Application channel authorization is covered by PhaseNineMessagingTest.
import { readFileSync } from 'node:fs'
import { createHash, createHmac, randomUUID } from 'node:crypto'
import WebSocket from '../apps/vendor-web/node_modules/ws/wrapper.mjs'
import { parseEnv } from 'node:util'

const settings = parseEnv(readFileSync(new URL('../services/api/.env', import.meta.url), 'utf8'))
const key = settings.REVERB_APP_KEY
const secret = settings.REVERB_APP_SECRET
if (!key || !secret) throw new Error('Local Reverb credentials are not configured.')
const port = settings.REVERB_PUBLIC_PORT || '8081'
const channel = `private-local-smoke-${randomUUID()}`
const nonce = randomUUID()
const sign = value => createHmac('sha256', secret).update(value).digest('hex')
const socket = new WebSocket(`ws://127.0.0.1:${port}/app/${encodeURIComponent(key)}?protocol=7&client=local-check&version=1.0`, { origin: 'https://materyalph-buyer' })
let stage = 'connect'
try {
  await new Promise((resolve, reject) => {
    const timeout = setTimeout(() => reject(new Error('Local Reverb delivery timed out.')), 10000)
    const fail = () => { clearTimeout(timeout); reject(new Error('Local Reverb connection or publication failed.')) }
    socket.onerror = fail
    socket.onmessage = event => {
      void (async () => {
        const message = JSON.parse(String(event.data))
        const data = typeof message.data === 'string' ? JSON.parse(message.data) : message.data
        if (message.event === 'pusher:connection_established') {
          stage = 'subscribe'
          socket.send(JSON.stringify({ event: 'pusher:subscribe', data: { channel, auth: `${key}:${sign(`${data.socket_id}:${channel}`)}` } }))
        } else if (message.event === 'pusher_internal:subscription_succeeded') {
          stage = 'publish'
          const body = JSON.stringify({ name: 'local.smoke', channels: [channel], data: JSON.stringify({ nonce }) })
          const path = `/apps/${encodeURIComponent(settings.REVERB_APP_ID)}/events`
          const query = new URLSearchParams({ auth_key: key, auth_timestamp: String(Math.floor(Date.now() / 1000)), auth_version: '1.0', body_md5: createHash('md5').update(body).digest('hex') }).toString()
          const response = await fetch(`http://127.0.0.1:${port}${path}?${query}&auth_signature=${sign(`POST\n${path}\n${query}`)}`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body })
          if (!response.ok) { stage = `publish HTTP ${response.status}`; fail() }
        } else if (message.event === 'local.smoke' && message.channel === channel && data.nonce === nonce) {
          clearTimeout(timeout)
          resolve()
        } else if (message.event === 'pusher:error') { stage = `${stage} protocol ${Number(data.code)}`; fail() }
      })().catch(fail)
    }
  })
  console.log('PASS: local Reverb private subscription, signed publication, and socket delivery.')
} catch {
  console.error(`FAIL: local Reverb smoke check at ${stage}. No credential values were logged.`)
  process.exitCode = 1
} finally {
  socket.close()
}
