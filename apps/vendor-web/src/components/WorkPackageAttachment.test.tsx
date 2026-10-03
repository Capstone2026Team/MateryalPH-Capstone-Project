import { render, screen } from '@testing-library/react'
import { describe, expect, it } from 'vitest'
import { WorkPackageAttachment } from './WorkPackageAttachment'

describe('Project Work Package attachment', () => {
  it('shows original, editable proposal, separate endpoint and retained source without private scores', () => {
    render(<WorkPackageAttachment reference={{version_id:'v1',content_hash:'hash',work_package:{name:'Foundation',budget_centavos:10000,site:{name:'House site',point:{formatted_address:'Quezon City'}},destination:{vehicle_endpoint:'ALTERNATE_DROP_OFF'},lines:[{id:'a',name:'Blocks',quantity:'10',unit_code:'PC',specifications:{thickness_mm:'100'}}]},working_duplicate:{lines:[{variant_id:'b',description:'Proposed blocks',quantity:'8',unit_price_centavos:1500}]}}} />)
    expect(screen.getByRole('region',{name:'Buyer original'})).toHaveTextContent('Blocks')
    expect(screen.getByRole('region',{name:'Vendor working duplicate / proposal'})).toHaveTextContent('Proposed blocks')
    expect(screen.getByText(/Project site remains the discovery origin/)).toHaveTextContent('Alternative vehicle drop-off')
    expect(screen.getByRole('button',{name:/Phase 15/})).toBeDisabled()
  })
  it('does not show a Project attachment for Item-Based conversations', () => {
    const {container}=render(<WorkPackageAttachment reference={{lines:[]}} />)
    expect(container).toBeEmptyDOMElement()
  })
})
