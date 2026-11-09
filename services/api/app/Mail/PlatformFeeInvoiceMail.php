<?php

declare(strict_types=1);

namespace App\Mail;

use App\Domain\Finance\CommissionPolicyService;
use App\Domain\Finance\WithholdingThresholdService;
use Carbon\CarbonImmutable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Attachment;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use SensitiveParameter;

final class PlatformFeeInvoiceMail extends Mailable
{
    /** @param array<string, mixed> $invoice */
    public function __construct(public readonly array $invoice, #[SensitiveParameter] private readonly string $bytes, private readonly string $filename) {}

    public function envelope(): Envelope
    {
        return new Envelope(subject: (($this->invoice['statement_version'] ?? 1) > 1 ? 'Corrected statement — ' : '').'Your MateryalPH commission statement for '
            .CarbonImmutable::parse($this->invoice['period_start'])->format('F Y').' - P'.WithholdingThresholdService::pesos((int) $this->invoice['total_centavos'])
            .' due '.CarbonImmutable::parse($this->invoice['due_on'])->format('M j, Y'));
    }

    public function content(): Content
    {
        $rates = [];
        foreach ($this->invoice['lines'] as $line) {
            if ($line['type'] !== 'EARNED_COMMISSION' || $line['rate_basis_points'] === null) {
                continue;
            }
            $rate = (int) $line['rate_basis_points'];
            $rates[$rate] ??= ['rate' => CommissionPolicyService::percent($rate), 'basis_centavos' => 0, 'commission_centavos' => 0, 'basis_available' => true];
            $rates[$rate]['basis_available'] = $rates[$rate]['basis_available'] && isset($line['basis_centavos']);
            $rates[$rate]['basis_centavos'] += (int) ($line['basis_centavos'] ?? 0);
            $rates[$rate]['commission_centavos'] += (int) $line['amount_centavos'];
        }

        return new Content(view: 'mail.platform-fee-invoice', text: 'mail.platform-fee-invoice-text', with: ['rates' => array_values($rates),
            'financeUrl' => rtrim((string) config('app.vendor_frontend_url'), '/').'/finance/commissions',
            'supportUrl' => rtrim((string) config('app.vendor_frontend_url'), '/').'/contact']);
    }

    /** @return list<Attachment> */
    public function attachments(): array
    {
        return [Attachment::fromData(fn (): string => $this->bytes, $this->filename)->withMime('application/pdf')];
    }
}
