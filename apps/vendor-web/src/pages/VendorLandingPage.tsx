import { FilterTabs, useScrollReveal } from '@materyalph/web-ui'
import { ArrowRight, BadgeCheck, Boxes, ChevronDown, ClipboardCheck, FileCheck2, LockKeyhole, MapPinned, MessageSquare, PackageCheck, ReceiptText, ShieldCheck, Store, Users } from 'lucide-react'
import { useState } from 'react'
import { Link } from 'react-router-dom'

import { BrandHeader } from '../components/BrandHeader'
import './VendorLandingPage.css'

const benefits = [
  { icon: MapPinned, title: 'Be found by buyers building nearby', text: 'Give contractors and material buyers a clearer way to discover your store, location and approved products.' },
  { icon: MessageSquare, title: 'Turn questions into clear requirements', text: 'Keep conversations connected to the materials, order or project a Buyer is asking about.' },
  { icon: BadgeCheck, title: 'Build trust with a documented track record', text: 'Store verification, completed orders and eligible purchase reviews help Buyers make informed decisions.' },
]
const steps = [
  ['Create your Owner account', 'Have your name, business name, email and mobile number ready. Review the Terms and Privacy Notice.'],
  ['Verify and secure your access', 'Verify email ownership and set up the required authenticator-based security for your Owner account.'],
  ['Prepare your store for review', 'Provide store details, location and required business documents. Complete the applicable activation requirements.'],
  ['Prepare your product listings', 'Add materials, variants, prices and fulfillment options. Complete any required product compliance review.'],
  ['Connect with eligible Buyers', 'After activation, receive item orders and respond to direct project inquiries with clear quotations.'],
  ['Build your store’s reputation', 'Keep information current, communicate clearly and fulfill accepted orders. Eligible reviews build your record.'],
]
const questions = [
  ['Getting started', [
    ['Who can register as a Vendor?', 'Independent hardware stores and construction-material suppliers can create a Vendor Owner account, subject to the required identity, business, location and verification checks.'],
    ['What should I prepare before registering?', 'Start with your Account Owner Name, email and mobile number. Have access to your email and an authenticator app. Store review later requires the applicable business, ownership and location evidence.'],
    ['What happens after I create my store account?', 'Complete email verification and required account security. Your account is the starting point for preparing store information and activation requirements; it does not publish a storefront automatically.'],
    ['Does registration activate my store immediately?', 'No. Registration creates your account. Store activation is reviewed before publication, and the applicable verification and readiness requirements must be completed.'],
  ]],
  ['Your store and Buyers', [
    ['What does Vendor verification provide?', 'An approved Tier 2 Vendor has an authenticated storefront and access to eligible marketplace capabilities after activation. Verification supports informed Buyer decisions; it does not guarantee sales or ranking. A Tier 1 supplier is a directory presence only and cannot transact on MateryalPH.'],
    ['Can every product be published immediately?', 'No. Product listings must meet the applicable publication requirements. Regulated materials need the required reviewed PS Mark or ICC evidence before publication. Store approval does not replace product compliance review.'],
    ['How do Buyers contact my store?', 'Eligible Buyers can start conversations linked to listings, orders or project Work Packages. Project inquiries are sent directly to selected Vendors with the Buyer’s material and fulfillment requirements.'],
    ['Can I send quotations?', 'Eligible Vendors can respond to direct Work Package inquiries with a quotation. Revisions create a new version so Buyers can clearly see and accept the current offer.'],
    ['Can my store improve visibility on the platform?', 'Accurate listings, approved store details, responsive communication and eligible fulfillment/review evidence help Buyers evaluate your store. Visibility follows the platform’s rules; registration does not promise placement or a sales volume.'],
  ]],
  ['Payments and account security', [
    ['When is commission charged?', 'It is earned on completed materials and billed monthly. The initial default is 2.00%; review the effective rate in Finance and the versioned Commission Terms. Earlier transactions keep their saved rate. Vendor discounts are considered and included materials VAT is excluded.'],
    ['Are processing fees included in commission?', 'Vendor-paid commission and third-party payment-processing fees are separate. Processing charges vary by payment method and provider; there is no single processing rate shown in this example.'],
    ['How are refunds and dispute adjustments handled?', 'Refunds and concluded-dispute adjustments are recorded separately from payment-processing fees and commission. Approved changes refer back to the original transaction and may lead to a corresponding commission adjustment.'],
    ['Do I need to verify my email?', 'Email/password registration requires email verification. A valid verified Google email satisfies email ownership verification when you register with Google. You still complete the remaining Vendor account requirements.'],
    ['Why do I need authenticator-based security?', 'Vendor Owner access uses an authenticator as an additional account safeguard. Save your recovery codes securely during setup so you have the supported recovery option if your authenticator becomes unavailable.'],
    ['What happens if I forget my password?', 'Use Forgot password on the Vendor sign-in page and follow the instructions sent to your registered email. A password reset does not remove the account’s required authenticator security.'],
  ]],
] as const
const previews = [
  { label: 'Storefront', icon: Store, title: 'Your materials. A clearer digital presence.', text: 'Present approved products with useful specifications, prices and availability. Exact inventory stays private.', rows: [['Portland cement', '40 kg · Per bag'], ['Deformed steel bar', '12 mm · Per length'], ['Concrete hollow block', '6 in · Per piece']] },
  { label: 'Inquiries', icon: MessageSquare, title: 'A project brief you can respond to.', text: 'Review direct Work Package inquiries with material quantities and fulfillment needs, then prepare a versioned quotation.', rows: [['Material requirements', 'Cement, steel and blocks'], ['Requested fulfillment', 'Delivery to project site'], ['Vendor response', 'Quotation with clear terms']] },
  { label: 'Orders', icon: ClipboardCheck, title: 'Keep the next action in view.', text: 'Review item orders, confirm availability and follow the approved fulfillment steps with a documented transaction history.', rows: [['Review', 'Check the order requirements'], ['Confirm', 'Accept through the approved flow'], ['Fulfill', 'Record delivery or pickup']] },
]

export function VendorLandingPage() {
  const landing = useScrollReveal()
  const [preview, setPreview] = useState(0)
  const [faqTopic, setFaqTopic] = useState<string>(questions[0][0])
  const selected = previews[preview] ?? previews[0]!
  const PreviewIcon = selected.icon
  const [topic, entries] = questions.find(([group]) => group === faqTopic) ?? questions[0]
  return <div className="vendor-landing" ref={landing}>
    <BrandHeader />
    <main id="main-content">
      <div className="lp-hero-band">
        <picture className="lp-hero-media" aria-hidden="true">
          <source media="(max-width: 600px)" srcSet="/media/vendor-landing/materials-store-mobile.jpg" />
          <img src="/media/vendor-landing/materials-store-poster.jpg" alt="" fetchPriority="high" decoding="async" width="1344" height="752" />
        </picture>
        <section className="lp-hero lp-container" aria-labelledby="hero-title">
        <div className="lp-hero-copy">
          <span className="lp-eyebrow"><span aria-hidden="true" /> For the stores behind every build</span>
          <h1 id="hero-title">Build your store’s <em>next chapter.</em></h1>
          <p>Bring your materials to the people building the Philippines. A digital storefront. Clearer inquiries. A stronger connection to your next Buyer.</p>
          <div className="hero__actions lp-actions"><Link className="button button--primary" to="/register">Register your store <ArrowRight aria-hidden="true" /></Link><a className="button button--secondary" href="#how-it-works">See how it works</a></div>
          <p className="lp-hero-note"><ShieldCheck aria-hidden="true" /> Start with an Owner account. Store activation is reviewed.</p>
        </div>
        </section>
        <div className="lp-hero-footer"><div className="lp-container lp-hero-journey" aria-label="Connect your store with Buyers">
          <div><Boxes aria-hidden="true" /><span><small>What you supply</small><strong>Your materials</strong></span></div><ArrowRight aria-hidden="true" />
          <div><Store aria-hidden="true" /><span><small>Where you connect</small><strong>Your digital storefront</strong></span></div><ArrowRight aria-hidden="true" />
          <div><Users aria-hidden="true" /><span><small>Who you reach</small><strong>Buyers building nearby</strong></span></div>
        </div></div>
      </div>
      <div className="lp-audience"><div className="lp-container" data-mp-reveal=""><p>Built for the Philippine construction community</p><ul><li>Hardware stores</li><li>Material suppliers</li><li>Independent Vendors</li></ul></div></div>
      <section id="benefits" className="lp-container lp-section" aria-labelledby="benefits-title"><div className="lp-heading" data-mp-reveal=""><div><span className="lp-eyebrow">Built around your business</span><h2 id="benefits-title">Good materials deserve<br />a stronger presence.</h2></div><p>Make your store easier to discover, your offers easier to understand and your Buyer relationships easier to manage.</p></div><div className="lp-benefits">{benefits.map(({ icon: Icon, title, text }, i) => <article key={title} data-mp-reveal="" data-mp-reveal-delay={i}><div className="lp-benefit-top"><Icon aria-hidden="true" /><span aria-hidden="true">0{i + 1}</span></div><h3>{title}</h3><p>{text}</p></article>)}</div></section>
      <section id="features" className="lp-feature-band" aria-labelledby="features-title"><div className="lp-container lp-section"><div className="lp-heading" data-mp-reveal=""><div><span className="lp-eyebrow">Your store, connected</span><h2 id="features-title">From product discovery<br />to a documented order.</h2></div><p>Explore the marketplace capabilities for eligible, activated stores. Registration is your first step; publication follows review.</p></div><div className="lp-feature-layout" data-mp-reveal=""><div className="lp-feature-options" aria-label="Explore marketplace capabilities">{previews.map(({ label, icon: Icon, title }, i) => <button type="button" key={label} aria-label={`${label} ${title}`} aria-pressed={preview === i} aria-controls="landing-feature-preview" onClick={() => setPreview(i)}><Icon aria-hidden="true" /><span><strong>{label}</strong><span>{title}</span></span><ArrowRight aria-hidden="true" /></button>)}</div><div id="landing-feature-preview" className="lp-feature-preview" aria-live="polite"><div className="lp-preview-content" key={preview}><div className="lp-preview-top"><PreviewIcon aria-hidden="true" /><span className="lp-preview-label">Illustrative {selected.label.toLowerCase()} preview</span><span className="lp-preview-count" aria-hidden="true">0{preview + 1} / 03</span></div><h3>{selected.title}</h3><p>{selected.text}</p><dl>{selected.rows.map(([label, value], i) => <div key={label}><dt><span className="lp-row-index" aria-hidden="true">0{i + 1}</span>{label}</dt><dd>{value}</dd></div>)}</dl></div></div></div></div></section>
      <section id="how-it-works" className="lp-container lp-section" aria-labelledby="how-title"><div className="lp-heading" data-mp-reveal=""><div><span className="lp-eyebrow">A clear way forward</span><h2 id="how-title">Start with your account.<br />Build toward your storefront.</h2></div><p>A clear path from registration to eligible marketplace participation, with checks at the stages that matter.</p></div><ol className="lp-steps">{steps.map(([title, description], i) => <li key={title} data-mp-reveal="" data-mp-reveal-delay={i % 3}><span className="lp-step-number" aria-hidden="true">{String(i + 1).padStart(2, '0')}</span><div><h3>{title}</h3><p>{description}</p></div></li>)}</ol></section>
      <section id="verification" className="lp-trust lp-container" data-mp-reveal="" aria-labelledby="trust-title"><div><span className="lp-eyebrow"><ShieldCheck aria-hidden="true" /> Trust &amp; compliance</span><h2 id="trust-title">Trust starts before<br />your first order.</h2><p>Creating an account is the beginning. Store activation is reviewed before publication, and regulated products need their own applicable compliance checks.</p><a className="lp-text-link" href="#faq" onClick={() => setFaqTopic('Your store and Buyers')}>Understand the requirements <ArrowRight aria-hidden="true" /></a></div><ul><li><BadgeCheck aria-hidden="true" /><div><h3>A reviewed store identity</h3><p>Business, ownership and location information support the Vendor review.</p></div></li><li><PackageCheck aria-hidden="true" /><div><h3>Products ready for publication</h3><p>Applicable regulated materials need reviewed PS Mark or ICC evidence. Store approval alone does not publish every product.</p></div></li><li><LockKeyhole aria-hidden="true" /><div><h3>Private documents. Protected access.</h3><p>Required evidence is available to authorized reviewers. Owner accounts use authenticator-based security.</p></div></li></ul></section>
      <section id="payments-fees" className="lp-container lp-section lp-fees" aria-labelledby="fees-title"><div data-mp-reveal=""><span className="lp-eyebrow">Understand the numbers</span><h2 id="fees-title">Plain-language payments and fees, before you commit</h2><p>The initial default Vendor-paid platform commission is <strong>2%</strong>, assessed on the completed-materials basis and billed monthly.</p><p>Vendor discounts are considered. Included material VAT and delivery are excluded from the commission basis.</p><ul className="lp-fee-notes"><li><ReceiptText aria-hidden="true" /><span><strong>Processing is separate.</strong> Third-party processing fees are distinct and vary by payment method and provider.</span></li><li><FileCheck2 aria-hidden="true" /><span><strong>Adjustments stay traceable.</strong> Refunds and dispute adjustments have separate records, with corresponding approved commission adjustments where applicable.</span></li></ul></div><div className="lp-fee-example" data-mp-reveal=""><div className="lp-fee-top"><h3>A simple monthly example</h3><span>2% monthly example</span></div><p>Illustrative amounts · Material VAT already excluded</p><dl><div><dt>Completed materials before discounts</dt><dd>₱150,000</dd></div><div><dt>Less Vendor discounts</dt><dd>− ₱10,000</dd></div><div className="lp-basis"><dt>Commission basis</dt><dd>₱140,000</dd></div></dl><div className="lp-fee-result"><span>Vendor platform commission<strong>₱2,800</strong></span><span>₱140,000 × 2%</span></div><p>Delivery and processing fees are not part of this example. This is a commission illustration, not a payout statement.</p></div></section>
      <section id="faq" className="lp-faq-band" aria-labelledby="faq-title"><div className="lp-container lp-section lp-faq-layout"><div className="lp-faq-intro" data-mp-reveal=""><span className="lp-eyebrow">Good questions. Clear answers.</span><h2 id="faq-title">A few answers.<br />A clearer next step.</h2><p>What to know about joining, publishing products, connecting with Buyers and protecting your account.</p><Link className="lp-text-link" to="/support">Need more help? <ArrowRight aria-hidden="true" /></Link></div><div className="lp-faq-groups" data-mp-reveal="" data-mp-reveal-delay="1"><FilterTabs label="Frequently asked question topics" appearance="tabs" chips={questions.map(([group]) => ({ value: group, label: group }))} value={topic} onChange={setFaqTopic} /><div key={topic} role="tabpanel" aria-label={topic} tabIndex={0}><h3 className="sr-only">{topic}</h3>{entries.map(([question, answer]) => <details key={question}><summary>{question}<ChevronDown aria-hidden="true" /></summary><p>{answer}</p></details>)}</div></div></div></section>
      <section className="lp-container lp-section" aria-labelledby="registration-title"><div className="lp-final" data-mp-reveal=""><div><span className="lp-eyebrow">Built for what comes next</span><h2 id="registration-title">Your next chapter<br />starts with your store.</h2><p>Create your Vendor Owner account and take the first step toward a reviewed digital storefront.</p></div><div><Link className="button button--primary" to="/register">Start registration <ArrowRight aria-hidden="true" /></Link><p>Already have an account? <Link to="/login">Sign in</Link></p></div></div></section>
    </main>
    <footer className="lp-footer"><div className="lp-container"><div className="lp-footer-main" data-mp-reveal=""><div><Link className="brand-link" to="/"><img src="/brand/materyalph-mark.png" alt="MateryalPH" width="48" height="48" /><span>MateryalPH Vendor</span></Link><p>Materials for every build.<br />Connections that help your store move forward.</p></div><nav aria-label="Explore"><strong>Explore MateryalPH</strong><a href="#benefits">Vendor benefits</a><a href="#how-it-works">How it works</a><a href="#payments-fees">Payments &amp; fees</a></nav><nav aria-label="Vendor resources"><strong>Here to help</strong><a href="#verification">Verification</a><a href="#faq">Common questions</a><Link to="/contact">Contact Us</Link></nav></div><div className="lp-footer-bottom"><small>MateryalPH · Built for the Philippine construction community.</small><nav aria-label="Legal"><Link to="/legal/terms-of-service">Terms of Service</Link><Link to="/legal/privacy-notice">Privacy Notice</Link></nav></div></div></footer>
  </div>
}
