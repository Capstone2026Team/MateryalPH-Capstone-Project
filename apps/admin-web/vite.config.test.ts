// @vitest-environment node
import { fileURLToPath } from 'node:url'
import { createServer } from 'vite'
import { expect, test } from 'vitest'

test('serves shared UI styles and the login image without exposing unrelated workspace files', async () => {
  const server = await createServer({
    root: fileURLToPath(new URL('.', import.meta.url)),
    configFile: fileURLToPath(new URL('./vite.config.ts', import.meta.url)),
    cacheDir: fileURLToPath(new URL('../../.tmp/admin-vite-config-test', import.meta.url)),
    logLevel: 'silent',
    optimizeDeps: { noDiscovery: true, include: [] },
    server: { host: '127.0.0.1', port: 0, strictPort: true },
  })

  try {
    await server.listen()
    const address = server.httpServer?.address()
    if (!address || typeof address === 'string') throw new Error('Vite did not open a test port')
    const origin = `http://127.0.0.1:${address.port}`
    const workspaceFileUrl = (path: string) => `${origin}/@fs/${encodeURI(fileURLToPath(new URL(path, import.meta.url)).replaceAll('\\', '/'))}`

    const image = await fetch(workspaceFileUrl('../../packages/web-ui/src/assets/materials-store.jpg'))
    expect(image.status).toBe(200)
    expect(image.headers.get('content-type')).toContain('image/jpeg')
    expect(new Uint8Array(await image.arrayBuffer()).slice(0, 2)).toEqual(new Uint8Array([0xff, 0xd8]))

    for (const filename of ['portal-card.css', 'kpi-card.css', 'metric-trend.css']) {
      const stylesheet = await fetch(workspaceFileUrl(`../../packages/web-ui/src/${filename}`))
      expect(stylesheet.status, `${filename} is served from the shared UI source`).toBe(200)
      expect(await stylesheet.text()).toContain('.mp-')
    }

    const chartModule = await fetch(workspaceFileUrl('../../packages/web-ui/src/chart-patterns.tsx'))
    expect(chartModule.status).toBe(200)
    expect(await chartModule.text()).toContain('kpi-card.css')

    const unrelatedFile = await fetch(workspaceFileUrl('../../PRODUCT.md'))
    expect(unrelatedFile.status).toBe(403)
    await unrelatedFile.arrayBuffer()
  } finally {
    await server.close()
  }
}, 30_000)
