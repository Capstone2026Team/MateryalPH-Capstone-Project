<?php

declare(strict_types=1);

namespace App\Mail;

use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;

final class VendorInvitationMail extends Mailable
{
    public function __construct(public readonly string $acceptUrl) {}

    public function envelope(): Envelope
    {
        return new Envelope(subject: 'Your MateryalPH team invitation');
    }

    public function content(): Content
    {
        return new Content(view: 'mail.vendor-invitation', with: ['acceptUrl' => $this->acceptUrl]);
    }
}
