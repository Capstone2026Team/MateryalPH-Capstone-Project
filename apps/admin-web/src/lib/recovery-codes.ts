export function downloadRecoveryCodes(codes: readonly string[]): void {
  const content = ['MateryalPH Admin Account Recovery Codes', '', 'Each recovery code works once.', 'Store these codes securely and offline.', '', ...codes, ''].join('\n')
  const url = URL.createObjectURL(new Blob([content], { type: 'text/plain;charset=utf-8' }))
  try {
    const link = document.createElement('a')
    link.href = url
    link.download = 'MateryalPH-Admin-Recovery-Codes.txt'
    link.click()
  } finally {
    URL.revokeObjectURL(url)
  }
}
