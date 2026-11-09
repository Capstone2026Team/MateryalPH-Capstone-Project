<?php

declare(strict_types=1);

namespace App\Mail;

use App\Domain\Finance\CommissionPolicyService;
use App\Domain\Finance\WithholdingThresholdService;
use Carbon\CarbonImmutable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;

final class CommissionPolicyMail extends Mailable
{
    /** @param array<string, mixed> $policy */
    public function __construct(public readonly array $policy, public readonly int $oldBasisPoints, public readonly string $type = 'RATE_PUBLISHED') {}

    public function envelope(): Envelope
    {
        return new Envelope(subject: ($this->type === 'RATE_CANCELLED' ? 'Commission change cancelled: ' : ($this->type === 'RATE_CORRECTED' ? 'Corrected commission rate: ' : ($this->type === 'RATE_REMINDER' ? 'Reminder — commission rate update: ' : 'Commission rate update: ')))
            .CommissionPolicyService::percent($this->oldBasisPoints).' -> '.$this->policy['rate_label'].' effective '.CarbonImmutable::parse($this->policy['effective_from'])->setTimezone('Asia/Manila')->format('M j, Y'));
    }

    public function content(): Content
    {
        $base = rtrim((string) config('app.vendor_frontend_url'), '/');

        return new Content(view: 'mail.commission-policy', text: 'mail.commission-policy-text', with: [
            'oldRate' => CommissionPolicyService::percent($this->oldBasisPoints),
            'effective' => CarbonImmutable::parse($this->policy['effective_from'])->setTimezone('Asia/Manila')->format('M j, Y g:i A').' (Asia/Manila)',
            'example' => 'P'.WithholdingThresholdService::pesos(intdiv(1000000 * (int) $this->policy['commission_basis_points'] + 5000, 10000)),
            'termsUrl' => $base.'/commission-terms?policy='.$this->policy['id'], 'financeUrl' => $base.'/finance/commissions', 'supportUrl' => $base.'/contact',
        ]);
    }
}
