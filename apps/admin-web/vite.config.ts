import { defineConfig, type ProxyOptions } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

function portalApiProxy(): ProxyOptions {
  return {
    target: 'http://127.0.0.1:8080',
    headers: { host: 'localhost:8080' },
    cookieDomainRewrite: '',
    configure(proxy) {
      proxy.on('proxyReq', (proxyReq) => {
        // Laravel uses the portal origin to isolate its HttpOnly auth cookies.
        proxyReq.setHeader('Origin', 'http://localhost:5174')
        proxyReq.setHeader('Referer', 'http://localhost:5174/')
      })
      proxy.on('proxyRes', (proxyRes) => {
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
  plugins: [react(), tailwindcss()],
  // Prebundle the linked client, rebuilding on startup because regeneration does not change the npm lockfile.
  optimizeDeps: { include: ['@materyalph/api-client-ts'], force: true },
  server: {
    port: 5174,
    allowedHosts: publicTunnelHosts,
    proxy: {
      '/api/v1': apiProxy,
    },
  },
  preview: {
    host: '127.0.0.1',
    port: 5174,
    strictPort: true,
    allowedHosts: publicTunnelHosts,
    proxy: {
      '/api/v1': apiProxy,
    },
  },
})
