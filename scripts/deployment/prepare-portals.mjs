import { copyFile, mkdir, readdir, readFile, lstat, writeFile } from 'node:fs/promises'
import { resolve, join, extname } from 'node:path'
import { pathToFileURL } from 'node:url'

export function portalConfiguration(origin) {
  const url = new URL(origin)
  if (url.protocol !== 'https:' || url.username || url.password || url.pathname !== '/' || url.search || url.hash
    || !/^[a-z0-9-]+\.up\.railway\.app$/.test(url.hostname)) throw new Error('Use the assigned Railway HTTPS API origin.')
  return {
    $schema: 'https://openapi.vercel.sh/vercel.json',
    framework: null, buildCommand: '', installCommand: '', outputDirectory: '.',
    rewrites: [
      { source: '/api/v1', destination: `${url.origin}/api/v1` },
      { source: '/api/v1/:path*', destination: `${url.origin}/api/v1/:path*` },
      { source: '/:path*', destination: '/index.html' },
    ],
    headers: [
      ...['/api/v1', '/api/v1/:path*'].map(source => ({ source, headers: [
        { key: 'Cache-Control', value: 'private, no-store, max-age=0' },
        { key: 'CDN-Cache-Control', value: 'no-store' },
        { key: 'Vercel-CDN-Cache-Control', value: 'no-store' },
      ] })),
      { source: '/:path*', headers: [
        { key: 'X-Content-Type-Options', value: 'nosniff' },
        { key: 'Referrer-Policy', value: 'strict-origin-when-cross-origin' },
      ] },
    ],
  }
}

export async function preparePortals({ root, output, apiOrigin, sourceCommit }) {
  if (!/^[a-f0-9]{40}$/.test(sourceCommit ?? '')) throw new Error('Provide the exact passing source commit SHA.')
  const configuration = portalConfiguration(apiOrigin)
  const base = resolve(root, '.tmp')
  const destination = resolve(output)
  if (!destination.startsWith(base + '/') && !destination.startsWith(base + '\\')) throw new Error('Output must be a new directory inside the repository .tmp directory.')
  await mkdir(base, { recursive: true })
  // Never overwrite a previous release or recursively remove an operator-selected path.
  await mkdir(destination)
  const extensions = new Set(['.html', '.js', '.css', '.svg', '.png', '.jpg', '.jpeg', '.webp', '.gif', '.ico', '.woff', '.woff2', '.ttf', '.json', '.txt', '.webmanifest'])
  async function copy(source, target) {
    await mkdir(target)
    for (const entry of await readdir(source, { withFileTypes: true })) {
      if (entry.isSymbolicLink() || entry.name.startsWith('.')) throw new Error('Hidden files and symlinks cannot enter a portal release.')
      const path = join(source, entry.name)
      if (entry.isDirectory()) await copy(path, join(target, entry.name))
      else {
        if (!(await lstat(path)).isFile() || !extensions.has(extname(entry.name))) throw new Error('Unexpected artifact type in portal build.')
        await copyFile(path, join(target, entry.name))
      }
    }
  }
  for (const role of ['vendor', 'admin']) {
    const source = resolve(root, `apps/${role}-web/dist`)
    await readFile(join(source, 'index.html'))
    const target = join(destination, role)
    await copy(source, target)
    await writeFile(join(target, 'vercel.json'), JSON.stringify(configuration, null, 2) + '\n')
    await writeFile(join(target, 'release.json'), JSON.stringify({ sourceCommit, portal: role }, null, 2) + '\n')
  }
  await writeFile(join(destination, 'release.json'), JSON.stringify({ sourceCommit, apiOrigin: new URL(apiOrigin).origin }, null, 2) + '\n')
  return destination
}

if (process.argv[1] && import.meta.url === pathToFileURL(resolve(process.argv[1])).href) {
  try {
    await preparePortals({ root: process.cwd(), output: process.env.PORTAL_RELEASE_DIRECTORY,
      apiOrigin: process.env.RAILWAY_API_ORIGIN, sourceCommit: process.env.DEPLOY_COMMIT })
    console.log('Both portal releases prepared with exact source metadata.')
  } catch { console.error('Portal preparation failed. Check paths, build output, API origin and source commit.'); process.exitCode = 1 }
}
