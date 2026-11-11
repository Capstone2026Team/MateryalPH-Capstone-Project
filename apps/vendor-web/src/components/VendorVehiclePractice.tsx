import { useCallback, useEffect, useRef, useState } from 'react'
import { Button, DeliveryVehicles, StatusMessage, TutorialPractice, type PracticeStep } from '@materyalph/web-ui'
import { vehicleErrors } from '../lib/delivery-vehicles'
import { sampleVehicle } from '../lib/vendor-tutorial-samples'

const steps: PracticeStep[] = [
  { title: 'Choose the vehicle', description: 'Add vehicle opens this editor. Choose a category and type, then name the configuration. This sample is one mid-size pickup. Configure only vehicles your store operates or legitimately controls.', target: '[data-vehicle-editor] h3' },
  { title: 'Confirm capacity and site access', description: 'Enter the actual rated payload and usable cargo dimensions in meters. The sample carries 1,000 kg. Heavy-vehicle classification helps with road and site checks. Ready-mix trucks also require confirmed usable mixer volume.', target: '[aria-label="Capacity and access"]' },
  { title: 'Add a vehicle image', description: 'The sample illustration shows where the vehicle image appears. Try Select image to preview a local JPEG, PNG or WebP; it stays in this session. Use a clear photo of your actual vehicle when configuring your store.', target: '[data-vehicle-editor] img' },
  { title: 'Set rates and delivery distance', description: 'The sample charges ₱300 per trip plus ₱25 per kilometer, with a 25 km vehicle limit. Try the rate calculator below. You still confirm the final arrangement and fee before Buyer acceptance; these are example rates, not platform rates.', target: '[aria-label="Vehicle 1 delivery rates"]' },
  { title: 'Check availability and save the sample', description: 'Enabled for future deliveries controls whether this vehicle may be offered. Available now records current readiness. Review the fields, then select Save sample vehicle below. Real saved changes apply to future proposals; accepted orders keep their confirmed arrangement.', target: '[data-demo-vehicle-save]' },
]
export default function VendorVehiclePractice({ onClose }: { onClose: (completed: boolean) => void }) {
  const [step, setStep] = useState(0)
  const [vehicles, setVehicles] = useState(() => [sampleVehicle()])
  const [errors, setErrors] = useState<Record<string, Record<string, string>>>({})
  const [saved, setSaved] = useState(false)
  const urls = useRef<string[]>([])
  const images = useRef(new Map([['demo-truck-image', '/tutorial/truck.svg']]))
  useEffect(() => () => urls.current.forEach(url => URL.revokeObjectURL(url)), [])
  const upload = useCallback(async (file: File) => { const id = `demo-image-${urls.current.length}`; const url = URL.createObjectURL(file); urls.current.push(url); images.current.set(id, url); return id }, [])
  const resolve = useCallback(async (id: string) => images.current.get(id) ?? '/tutorial/truck.svg', [])
  function save() { const invalid = Object.fromEntries(vehicles.map(vehicle => [vehicle.key, vehicleErrors(vehicle, true)])); setErrors(invalid); if (Object.values(invalid).every(value => Object.keys(value).length === 0)) setSaved(true) }
  return <TutorialPractice title="Practice adding a vehicle" steps={steps} step={step} onStep={setStep} onNext={() => step !== steps.length - 1 || saved} onClose={onClose}>
    <p className="mb-4 text-xs font-semibold text-action-primary">DEMO · Delivery vehicle configuration</p>
    <DeliveryVehicles vehicles={vehicles} onChange={value => { setVehicles(value); setSaved(false) }} uploadImage={upload} resolveImage={resolve} coverageKm={50} operational inlineEditor initialEditorKey="demo-vehicle" errors={errors}
      editorActions={<div data-demo-vehicle-save className="grid gap-3 border-t border-border-default pt-4">{saved && <StatusMessage tone="success">Sample vehicle saved in this practice session. Your fleet has not changed.</StatusMessage>}<Button className="justify-self-start" onClick={save}>Save sample vehicle</Button></div>} />
  </TutorialPractice>
}
