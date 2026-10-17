import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { describe, expect, test, vi } from 'vitest'
import { AuthenticatorCodeField } from '@materyalph/web-ui'

describe('Shared authenticator code field', () => {
  test('pastes a formatted code into six slots and submits one canonical value', () => {
    const { container } = render(<form><AuthenticatorCodeField label="Authenticator code" name="code" required /></form>)
    const input = screen.getByRole('textbox', { name: 'Authenticator code' })
    fireEvent.paste(input, { clipboardData: { getData: () => '123 456' } })
    expect(input).toHaveValue('123456')
    expect(new FormData(container.querySelector('form')!).get('code')).toBe('123456')
    expect(input).toBeValid()
    expect(input).toHaveAttribute('autocomplete', 'one-time-code')
    expect(container.querySelector('[aria-hidden="true"].grid')?.textContent).toBe('123456')
  })

  test('accepts digits only and requires all six before submission', () => {
    render(<AuthenticatorCodeField label="Authenticator code" name="code" required />)
    const input = screen.getByRole('textbox', { name: 'Authenticator code' })
    fireEvent.change(input, { target: { value: '12x34' } })
    expect(input).toHaveValue('1234')
    expect(input).toBeInvalid()
    fireEvent.change(input, { target: { value: '012345' } })
    expect(input).toHaveValue('012345')
    expect(input).toBeValid()
  })

  test('form reset clears the code and restores empty placeholders', async () => {
    const { container } = render(<form><AuthenticatorCodeField label="Authenticator code" name="code" required /><button type="reset">Clear</button></form>)
    const input = screen.getByRole('textbox', { name: 'Authenticator code' })
    fireEvent.change(input, { target: { value: '123456' } })
    fireEvent.click(screen.getByRole('button', { name: 'Clear' }))
    await waitFor(() => expect(input).toHaveValue(''))
    expect(container.querySelector('[aria-hidden="true"].grid')?.textContent).toBe('––––––')
    expect(input).toBeInvalid()
  })

  test('associates errors and marks the keyboard-selected slot', () => {
    const { container } = render(<AuthenticatorCodeField label="Authenticator code" name="code" error="The code is incorrect." />)
    const input = screen.getByRole('textbox', { name: 'Authenticator code' }) as HTMLInputElement
    fireEvent.change(input, { target: { value: '123456' } })
    fireEvent.focus(input)
    input.setSelectionRange(2, 2)
    fireEvent.select(input)
    expect(container.querySelector('[aria-hidden="true"].grid')?.children[2]).toHaveClass('outline-focus-ring')
    expect(input).toHaveAttribute('aria-invalid', 'true')
    expect(input).toHaveAttribute('aria-describedby', screen.getByRole('alert').id)
  })

  test('clicking a filled box selects that digit for replacement', () => {
    render(<AuthenticatorCodeField label="Authenticator code" name="code" />)
    const input = screen.getByRole('textbox', { name: 'Authenticator code' }) as HTMLInputElement
    fireEvent.change(input, { target: { value: '123456' } })
    vi.spyOn(input, 'getBoundingClientRect').mockReturnValue({ left: 0, width: 384 } as DOMRect)
    fireEvent.click(input, { clientX: 160 })
    expect(input.selectionStart).toBe(2)
    expect(input.selectionEnd).toBe(3)
  })
})
