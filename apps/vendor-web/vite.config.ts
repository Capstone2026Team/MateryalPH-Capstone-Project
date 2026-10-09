import { defineConfig } from 'vite'
import { fileURLToPath } from 'node:url'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  resolve: { dedupe: ['react', 'react-dom'] },
  plugins: [react(), tailwindcss()],
  server: {
    port: 5173,
    fs: {
      allow: ['.', '../../packages/web-ui', '../../packages/design-tokens', '../../packages/api-contract/generated/typescript'].map(path => fileURLToPath(new URL(path, import.meta.url))),
    },
  },
})
