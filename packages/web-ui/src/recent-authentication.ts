/** An action-scoped verification challenge does not revoke the signed-in account's access. */
export async function requiresRecentAuthentication(response: Response): Promise<boolean> {
  if (response.status !== 403) return false
  try {
    const body: unknown = await response.clone().json()
    if (!body || typeof body !== 'object' || !('errors' in body) || !Array.isArray(body.errors)) return false
    const first: unknown = body.errors[0]
    return Boolean(first && typeof first === 'object' && 'code' in first
      && (first.code === 'RECENT_AUTHENTICATION_REQUIRED' || first.code === 'REAUTHENTICATION_REQUIRED'))
  } catch { return false }
}
