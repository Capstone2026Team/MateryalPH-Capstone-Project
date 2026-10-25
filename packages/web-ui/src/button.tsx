import { forwardRef, type ButtonHTMLAttributes } from 'react'

export type ButtonVariant = 'primary' | 'secondary' | 'outline' | 'quiet' | 'danger'

export interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: ButtonVariant
}

const variantClasses: Record<ButtonVariant, string> = {
  primary: 'bg-action-primary text-white hover:bg-action-primary-pressed',
  secondary: 'border border-border-default bg-surface-primary text-text-strong hover:border-brand-orange-300 hover:bg-surface-canvas',
  outline: 'border border-action-primary bg-surface-primary text-action-primary hover:bg-brand-orange-50',
  quiet: 'bg-transparent text-text-strong hover:bg-brand-orange-50',
  danger: 'bg-status-error text-white hover:brightness-90',
}

/** Lets a navigation link look identical to a Button without becoming one. */
export function buttonClassName(variant: ButtonVariant = 'primary', className = '') {
  return `inline-flex min-h-12 min-w-11 shrink-0 items-center justify-center gap-2 rounded-control px-4 py-2 text-body-strong transition-colors duration-150 motion-reduce:transition-none sm:min-h-11 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring disabled:cursor-not-allowed disabled:opacity-50 ${variantClasses[variant]} ${className}`
}

export const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className = '', type = 'button', variant = 'primary', ...props }, ref) => (
    <button
      className={buttonClassName(variant, className)}
      ref={ref}
      type={type}
      {...props}
    />
  ),
)

Button.displayName = 'Button'
