import { createReadStream, existsSync, statSync } from 'node:fs'
import { defineConfig, type Plugin, type ProxyOptions } from 'vite'
import { fileURLToPath } from 'node:url'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

function buyerDemoApkPreviewRoute(): Plugin {
  const apkPath = fileURLToPath(new URL('./public/buyer-demo.apk', import.meta.url))
  return {
    name: 'materyalph-buyer-demo-apk-preview-route',
    configurePreviewServer(server) {
      server.middlewares.use('/buyer-demo.apk', (request, response, next) => {
        if (!existsSync(apkPath)) return next()
        if (request.method !== 'GET' && request.method !== 'HEAD') {
          response.statusCode = 405
          response.setHeader('Allow', 'GET, HEAD')
          return response.end()
        }
        response.statusCode = 200
        response.setHeader('Content-Type', 'application/vnd.android.package-archive')
        response.setHeader('Content-Disposition', 'attachment; filename="MateryalPH-Buyer-Demo.apk"')
        response.setHeader('Content-Length', statSync(apkPath).size)
        response.setHeader('Cache-Control', 'no-store')
        if (request.method === 'HEAD') return response.end()
        createReadStream(apkPath).pipe(response)
      })
    },
  }
}

function portalApiProxy(): ProxyOptions {
  const portalOrigin = 'http://localhost:5173'
  return {
    target: 'http://127.0.0.1:8080',
    headers: { host: 'localhost:8080' },
    cookieDomainRewrite: '',
    configure(proxy) {
      proxy.on('proxyReq', (proxyReq) => {
        // Laravel uses the portal origin to isolate its HttpOnly auth cookies.
        proxyReq.setHeader('Origin', portalOrigin)
        proxyReq.setHeader('Referer', `${portalOrigin}/`)
      })
      proxy.on('proxyRes', (proxyRes) => {
        // Google sign-in returns to the portal origin; keep that redirect on whichever host served the request.
        const location = proxyRes.headers.location
        if (typeof location === 'string' && location.startsWith(`${portalOrigin}/`)) {
          proxyRes.headers.location = location.slice(portalOrigin.length)
        }
        const cookies = proxyRes.headers['set-cookie']
        if (!Array.isArray(cookies)) return
        proxyRes.headers['set-cookie'] = cookies.map((cookie) => {
          const hostOnlyCookie = cookie.replace(/;\s*Domain=[^;]*/i, '')
          return /;\s*Secure(?:;|$)/i.test(hostOnlyCookie) ? hostOnlyCookie : `${hostOnlyCookie}; Secure`
        })
      })
    },
  }
}

const apiProxy = portalApiProxy()
const publicTunnelHosts = ['.trycloudflare.com']

export default defineConfig({
  resolve: { dedupe: ['react', 'react-dom'] },
  plugins: [react(), tailwindcss(), buyerDemoApkPreviewRoute()],
  server: {
    port: 5173,
    allowedHosts: publicTunnelHosts,
    proxy: {
      '/api/v1': apiProxy,
    },
    fs: {
      allow: ['.', '../../packages/web-ui', '../../packages/design-tokens', '../../packages/api-contract/generated/typescript'].map(path => fileURLToPath(new URL(path, import.meta.url))),
    },
  },
  preview: {
    host: '127.0.0.1',
    port: 5173,
    strictPort: true,
    allowedHosts: publicTunnelHosts,
    proxy: {
      '/api/v1': apiProxy,
    },
  },
})
