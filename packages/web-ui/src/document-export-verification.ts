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
  if (!cause || typeof cause !== 'object' || !('response' in cause) || !(cause.response instanceof Response) || cause.response.status !== 403) return false
  try {
    const body: unknown = await cause.response.clone().json()
    if (!body || typeof body !== 'object' || !('errors' in body) || !Array.isArray(body.errors)) return false
    const first: unknown = body.errors[0]
    return Boolean(first && typeof first === 'object' && 'code' in first
      && (first.code === 'RECENT_AUTHENTICATION_REQUIRED' || first.code === 'REAUTHENTICATION_REQUIRED'))
  } catch { return false }
}
