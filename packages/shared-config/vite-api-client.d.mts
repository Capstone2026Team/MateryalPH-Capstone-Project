type ClientWatcher = {
  add(path: string): unknown
  on(event: 'add' | 'change' | 'unlink', listener: (file: string) => void): unknown
  off(event: 'add' | 'change' | 'unlink', listener: (file: string) => void): unknown
}

export function watchGeneratedApiClient(watcher: ClientWatcher, directory: string, refresh: () => void): () => void
