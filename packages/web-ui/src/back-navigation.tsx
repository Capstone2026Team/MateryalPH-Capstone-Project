import { cloneElement, type ReactElement, type ReactNode } from 'react'
import { ArrowLeft } from 'lucide-react'
import './back-navigation.css'

type NavigationControl = { className?: string; children?: ReactNode }

/** Keeps the existing link or button, including its routing, ref and event handlers. */
export function BackNavigation({ children }: { children: ReactElement<NavigationControl> }) {
  return cloneElement(children, {
    className: `mp-back-navigation ${children.props.className ?? ''}`.trim(),
    children: <><ArrowLeft size={16} aria-hidden="true" /><span className="mp-back-navigation__label">{children.props.children}</span></>,
  })
}
