import { useState } from 'react'
import { fireEvent, render, screen } from '@testing-library/react'
import { expect, test } from 'vitest'
import { CustomLabelInput } from '@materyalph/web-ui'

test('adds multiple custom labels, rejects duplicates, and removes submitted values', () => {
  function Harness() {
    const [values, setValues] = useState<string[]>(['Acoustic panels'])
    return <form data-testid="categories"><CustomLabelInput values={values} onChange={setValues} /></form>
  }
  render(<Harness />)
  const input = screen.getByRole('textbox', { name: 'Other category' })
  fireEvent.change(input, { target: { value: ' Reclaimed bricks ' } })
  fireEvent.click(screen.getByRole('button', { name: 'Add category' }))
  const data = () => new FormData(screen.getByTestId('categories') as HTMLFormElement).getAll('custom_labels')
  expect(data()).toEqual(['Acoustic panels', 'Reclaimed bricks'])
  fireEvent.change(input, { target: { value: 'ACOUSTIC PANELS' } })
  fireEvent.keyDown(input, { key: 'Enter' })
  expect(screen.getByRole('alert')).toHaveTextContent('already added')
  fireEvent.click(screen.getByRole('button', { name: 'Remove Acoustic panels' }))
  expect(data()).toEqual(['Reclaimed bricks'])
})
