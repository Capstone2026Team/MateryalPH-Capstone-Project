import { expect, test } from 'vitest'
import { formatPesoInput, parsePesoInput, pesoInputCaret, pesoInputFromCentavos } from '../../../../packages/web-ui/src/money-input'

test('peso inputs produce exact integer centavos without rounding fractional amounts', () => {
  for (const [input, expected] of [['0', 0], ['0.01', 1], ['0.29', 29], ['.5', 50], ['285.50', 28550], ['1,234.56', 123456], ['1000000000.00', 100000000000], ['90071992547409.91', Number.MAX_SAFE_INTEGER]] as const) {
    expect(parsePesoInput(input)).toBe(expected)
    expect(parsePesoInput(pesoInputFromCentavos(expected))).toBe(expected)
  }
  for (const invalid of ['', '.', '-1', '1e3', '1.001', 'Infinity', 'NaN', '90071992547409.92']) expect(parsePesoInput(invalid)).toBeNull()
})

test('grouping keeps cleared text, decimal points and trailing fractional zeros editable', () => {
  for (const [input, expected] of [['', ''], ['0', '0'], ['1000', '1,000'], ['1234.', '1,234.'], ['1234.5', '1,234.5'], ['1234.50', '1,234.50'], ['.5', '.5'], ['12.345', '12.345']] as const) expect(formatPesoInput(input)).toBe(expected)
  expect(pesoInputFromCentavos(123450)).toBe('1,234.50')
  expect(pesoInputFromCentavos(0)).toBe('0.00')
  expect(pesoInputFromCentavos(null)).toBe('')
})

test('caret positions remain beside the edited digits when commas are inserted or removed', () => {
  expect(pesoInputCaret('1000', 4, '1,000')).toBe(5)
  expect(pesoInputCaret('1000', 0, '1,000')).toBe(0)
  expect(pesoInputCaret('12000.50', 2, '12,000.50')).toBe(2)
  expect(pesoInputCaret('1,00.50', 3, '100.50')).toBe(2)
  expect(pesoInputCaret('', 0, '')).toBe(0)
  expect(pesoInputCaret('.5', 1, '.5')).toBe(1)
})
