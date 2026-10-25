/** A missing response, server error or timeout leaves the mutation's outcome unknown. Keep its key for retry. */
export function shouldRotateIdempotencyKey(cause: unknown): boolean {
  if (!cause || typeof cause !== 'object' || !('response' in cause)) return false
  const response = cause.response
  if (!response || typeof response !== 'object' || !('status' in response) || typeof response.status !== 'number') return false
  return response.status >= 400 && response.status < 500 && response.status !== 408
}
