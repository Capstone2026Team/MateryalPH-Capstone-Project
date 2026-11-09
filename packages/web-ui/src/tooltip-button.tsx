import { useEffect, useId, useLayoutEffect, useRef, useState } from 'react'
import { Button, type ButtonProps } from './button'
import './tooltip-button.css'

/** An icon action with a hoverable, keyboard-dismissible label above clipped layouts. */
export function TooltipButton({ label, children, onClick, className = '', ...props }: Omit<ButtonProps, 'aria-label'> & { label: string }) {
  const [open, setOpen] = useState(false)
  const trigger = useRef<HTMLButtonElement>(null)
  const tooltip = useRef<HTMLDivElement>(null)
  const timer = useRef<ReturnType<typeof setTimeout> | undefined>(undefined)
  const id = useId()
  const cancelHide = () => clearTimeout(timer.current)
  const show = () => { cancelHide(); setOpen(true) }
  const hideSoon = () => { cancelHide(); timer.current = setTimeout(() => { if (document.activeElement !== trigger.current) setOpen(false) }, 150) }
  useEffect(() => () => clearTimeout(timer.current), [])

  useLayoutEffect(() => {
    if (!open) return
    const position = () => {
      if (!trigger.current || !tooltip.current) return
      const anchor = trigger.current.getBoundingClientRect()
      const bounds = tooltip.current.getBoundingClientRect()
      tooltip.current.style.left = `${Math.max(12, Math.min(anchor.right - bounds.width, window.innerWidth - bounds.width - 12))}px`
      const below = anchor.bottom + 4
      tooltip.current.style.top = `${Math.max(12, below + bounds.height <= window.innerHeight - 12 ? below : anchor.top - bounds.height - 4)}px`
    }
    const escape = (event: KeyboardEvent) => { if (event.key === 'Escape') { cancelHide(); setOpen(false) } }
    tooltip.current?.showPopover?.()
    position()
    window.addEventListener('resize', position)
    window.addEventListener('scroll', position, true)
    document.addEventListener('keydown', escape)
    return () => {
      window.removeEventListener('resize', position)
      window.removeEventListener('scroll', position, true)
      document.removeEventListener('keydown', escape)
    }
  }, [open])

  return <>
    <Button {...props} ref={trigger} className={`mp-tooltip-button ${className}`} aria-label={label} aria-describedby={open ? id : undefined}
      onMouseEnter={show} onMouseLeave={hideSoon} onFocus={show} onBlur={() => { cancelHide(); setOpen(false) }}
      onClick={event => { cancelHide(); setOpen(false); onClick?.(event) }}>{children}</Button>
    {open && <div ref={tooltip} id={id} role="tooltip" popover="manual" onMouseEnter={cancelHide} onMouseLeave={hideSoon}
      className="fixed inset-auto z-50 m-0 max-w-[calc(100vw_-_24px)] rounded-control border border-border-default bg-surface-primary px-3 py-2 text-xs font-medium leading-5 text-text-strong shadow-md">{label}</div>}
  </>
}
