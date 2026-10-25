/** Reserve a tab during the user's click, then navigate it after the authorized request completes. */
export function openPendingWindow(): Window | null {
  const tab = window.open('about:blank', '_blank')
  if (tab) tab.opener = null
  return tab
}
