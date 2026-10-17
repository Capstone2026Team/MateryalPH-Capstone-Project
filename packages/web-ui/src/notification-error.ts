export async function notificationError(error: unknown): Promise<string> {
  if (error && typeof error === 'object' && 'response' in error && error.response instanceof Response) {
    try {
      const body: unknown = await error.response.clone().json()
      if (body && typeof body === 'object' && 'errors' in body && Array.isArray(body.errors)) {
        const first: unknown = body.errors[0]
        if (first && typeof first === 'object' && 'message' in first && typeof first.message === 'string') return first.message
      }
    } catch { /* Use the safe network message below. */ }
  }
  return 'This request could not be completed. Check your connection and try again.'
}
