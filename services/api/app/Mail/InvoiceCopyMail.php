<?php

declare(strict_types=1);

namespace App\Mail;

use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Attachment;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use SensitiveParameter;

final class InvoiceCopyMail extends Mailable
{
    /** @param array<string, mixed> $invoice */
    public function __construct(public readonly array $invoice, #[SensitiveParameter] private readonly string $fileBytes, private readonly string $fileMime) {}

    public function envelope(): Envelope
    {
        return new Envelope(subject: 'Your invoice '.$this->invoice['invoice_number'].' · '.$this->invoice['issuer']);
    }

    public function content(): Content
    {
        return new Content(view: 'mail.invoice-copy', text: 'mail.invoice-copy-text');
    }

    /** @return list<Attachment> */
    public function attachments(): array
    {
        return [Attachment::fromData(fn (): string => $this->fileBytes, $this->invoice['filename'])->withMime($this->fileMime)];
    }
}
