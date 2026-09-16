<?php

declare(strict_types=1);

namespace App\Mail;

use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;

final class VendorOnboardingNoticeMail extends Mailable
{
    public function __construct(public readonly string $message) {}

    public function envelope(): Envelope
    {
        return new Envelope(subject: 'MateryalPH Vendor onboarding update');
    }

    public function content(): Content
    {
        return new Content(view: 'mail.vendor-onboarding-notice', with: ['message' => $this->message]);
    }
}
