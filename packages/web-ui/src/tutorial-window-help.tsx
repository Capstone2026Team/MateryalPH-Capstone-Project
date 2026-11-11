import { createContext, useContext, type ReactNode } from 'react'
import { BookOpen } from 'lucide-react'
import { Button } from './button'

const WindowHelp = createContext<((element: HTMLElement, title: string) => void) | null>(null)

export function TutorialWindowHelpProvider({ children, onGuide }: { children: ReactNode; onGuide: (element: HTMLElement, title: string) => void }) {
  return <WindowHelp.Provider value={onGuide}>{children}</WindowHelp.Provider>
}

/** Optional portal guide support for existing editors and record drawers, without closing their drafts. */
export function TutorialWindowHelpButton({ getWindow, title, disabled = false }: { getWindow: () => HTMLElement | null; title: string; disabled?: boolean }) {
  const guide = useContext(WindowHelp)
  if (!guide || title === 'Help / tutorial') return null
  return <Button data-tutorial-window-help variant="quiet" title="Guide this window" aria-label={`Guide ${title.toLowerCase()}`} disabled={disabled} onClick={() => { const element = getWindow(); if (element) guide(element, title) }}><BookOpen size={20} aria-hidden="true" /></Button>
}
