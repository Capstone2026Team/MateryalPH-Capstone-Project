import { requiresRecentAuthentication } from './recent-authentication'

/** Retry a protected export once after verification, while its original context is still current. */
export async function requestExportWithVerification<T>(request: () => Promise<T>, verify: () => Promise<boolean>, isCurrent: () => boolean): Promise<T | null> {
  if (!isCurrent()) return null
  try {
    const result = await request()
    return isCurrent() ? result : null
  } catch (cause) {
    if (!isCurrent()) return null
    if (!(await requiresVerification(cause))) throw cause
    if (!isCurrent() || !(await verify()) || !isCurrent()) return null
    const result = await request()
    return isCurrent() ? result : null
  }
}

async function requiresVerification(cause: unknown): Promise<boolean> {
  return Boolean(cause && typeof cause === 'object' && 'response' in cause && cause.response instanceof Response
    && await requiresRecentAuthentication(cause.response))
}
