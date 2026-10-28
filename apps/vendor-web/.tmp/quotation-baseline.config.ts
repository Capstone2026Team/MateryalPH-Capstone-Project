import { defineConfig, mergeConfig } from 'vitest/config'
import base from '../vitest.config'
import { fileURLToPath } from 'node:url'
export default mergeConfig(base, defineConfig({ resolve: { alias: [{ find: /.*web-api-session(?:\.ts)?$/, replacement: fileURLToPath(new URL('../../../.tmp/quotation-baseline-web-api-session.ts', import.meta.url)) }, { find: '@materyalph/api-client-ts', replacement: fileURLToPath(new URL('../../../packages/api-contract/generated/typescript/src/index.ts', import.meta.url)) }] } }))
