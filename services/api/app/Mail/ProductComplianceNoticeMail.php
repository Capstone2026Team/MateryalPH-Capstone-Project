<?php

declare(strict_types=1);

namespace App\Mail;

use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;

final class ProductComplianceNoticeMail extends Mailable
{
    public function __construct(public readonly string $notice) {}

    public function envelope(): Envelope
    {
        return new Envelope(subject: 'MateryalPH product compliance update');
    }

    public function content(): Content
    {
        return new Content(view: 'mail.product-compliance-notice', with: ['notice' => $this->notice]);
    }
}
