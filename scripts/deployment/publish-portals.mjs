import { readdir, readFile } from 'node:fs/promises'
import { resolve, join } from 'node:path'
import { pathToFileURL } from 'node:url'

export async function publishPortals({ directory, owner, token, sourceCommit }, fetcher = fetch) {
  if (!token || !/^[\w-]+$/.test(owner ?? '') || !/^[a-f0-9]{40}$/.test(sourceCommit ?? '')) throw new Error('Configure the personal publishing identity and exact source SHA.')
  const repo = `/repos/${owner}/materyalph-staging-portals`
  async function request(path, method = 'GET', body, allowMissing = false) {
    const response = await fetcher(`https://api.github.com${path}`, { method,
      headers: { Authorization: `Bearer ${token}`, Accept: 'application/vnd.github+json', 'X-GitHub-Api-Version': '2022-11-28', 'Content-Type': 'application/json' },
      body: body === undefined ? undefined : JSON.stringify(body), signal: AbortSignal.timeout(30_000) })
    if (allowMissing && response.status === 404) return null
    if (!response.ok) throw new Error(`GitHub publishing failed (HTTP ${response.status}).`)
    return response.json()
  }
  const user = await request('/user')
  const repository = await request(repo)
  if (user.type !== 'User' || user.login !== owner || repository.private !== true
    || repository.owner?.login !== owner || repository.owner?.type !== 'User') throw new Error('Publish only to the authenticated personal owner’s private artifact repository.')
  const metadata = JSON.parse(await readFile(join(directory, 'release.json'), 'utf8'))
  if (metadata.sourceCommit !== sourceCommit) throw new Error('Release metadata does not match the tested source commit.')
  const files = []
  async function collect(path, prefix = '') {
    for (const entry of await readdir(path, { withFileTypes: true })) {
      if (entry.isSymbolicLink() || entry.name.startsWith('.')) throw new Error('Unsafe artifact entry.')
      const name = prefix + entry.name
      if (entry.isDirectory()) await collect(join(path, entry.name), name + '/')
      else if (entry.isFile()) files.push({ name, data: await readFile(join(path, entry.name)) })
      else throw new Error('Unexpected artifact entry.')
    }
  }
  await collect(directory)
  const extensions = /\.(?:html|js|css|svg|png|jpe?g|webp|gif|ico|woff2?|ttf|json|txt|webmanifest)$/
  for (const file of files) {
    if (!(file.name === 'release.json' || /^(?:vendor|admin)\//.test(file.name)) || !extensions.test(file.name)) throw new Error('Publish compiled portal files only.')
  }
  const previous = await request(`${repo}/git/ref/heads/main`, 'GET', undefined, true)
  const tree = []
  for (const file of files) {
    const blob = await request(`${repo}/git/blobs`, 'POST', { content: file.data.toString('base64'), encoding: 'base64' })
    tree.push({ path: file.name, mode: '100644', type: 'blob', sha: blob.sha })
  }
  // A complete tree removes obsolete hashed assets without touching the authoritative source repository.
  const createdTree = await request(`${repo}/git/trees`, 'POST', { tree })
  const commit = await request(`${repo}/git/commits`, 'POST', {
    message: `deploy: staging portals from ${sourceCommit}`, tree: createdTree.sha,
    parents: previous ? [previous.object.sha] : [],
    author: { name: user.name || user.login, email: `${user.id}+${user.login}@users.noreply.github.com` },
  })
  if (previous) await request(`${repo}/git/refs/heads/main`, 'PATCH', { sha: commit.sha, force: false })
  else await request(`${repo}/git/refs`, 'POST', { ref: 'refs/heads/main', sha: commit.sha })
  return commit.sha
}

if (process.argv[1] && import.meta.url === pathToFileURL(resolve(process.argv[1])).href) {
  try {
    const sha = await publishPortals({ directory: process.env.PORTAL_RELEASE_DIRECTORY, owner: process.env.PORTAL_DEPLOY_OWNER,
      token: process.env.PORTAL_PUBLISH_TOKEN, sourceCommit: process.env.DEPLOY_COMMIT })
    console.log(`Published compiled staging portals: ${sha}`)
  } catch { console.error('Portal publishing failed; no provider response or credential is logged.'); process.exitCode = 1 }
}
