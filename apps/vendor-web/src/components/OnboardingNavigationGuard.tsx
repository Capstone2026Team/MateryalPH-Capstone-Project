import { useBlocker } from 'react-router-dom'
import { useSaveBeforeLeave } from '@materyalph/web-ui'

export function OnboardingNavigationGuard({ unsaved, save }: { unsaved: boolean; save: () => Promise<boolean> }) {
  // Session expiry and sign-out must clear protected content without another authorized write.
  const blocker = useBlocker(({ currentLocation, nextLocation }) => nextLocation.pathname !== '/login' && unsaved && (
    currentLocation.pathname !== nextLocation.pathname || currentLocation.search !== nextLocation.search
  ))
  useSaveBeforeLeave({ unsaved, save, blocked: blocker.state === 'blocked' ? blocker : null })
  return null
}
