/** A linked client can change without a lockfile change. Refresh once its build settles. */
export function watchGeneratedApiClient(watcher, directory, refresh) {
  const prefix = `${directory.replaceAll('\\', '/')}/`
  let pending
  const changed = (file) => {
    if (!file.replaceAll('\\', '/').startsWith(prefix) || !file.endsWith('.js')) return
    clearTimeout(pending)
    pending = setTimeout(refresh, 1000)
  }
  watcher.add(directory)
  for (const event of ['add', 'change', 'unlink']) watcher.on(event, changed)
  return () => {
    clearTimeout(pending)
    for (const event of ['add', 'change', 'unlink']) watcher.off(event, changed)
  }
}
