<?php

declare(strict_types=1);

namespace App\Mail;

use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;

final class AccountSecurityMail extends Mailable
{
    public function __construct(public readonly string $notice) {}

    public function envelope(): Envelope
    {
        return new Envelope(subject: 'MateryalPH account security notice');
    }

    public function content(): Content
    {
        return new Content(view: 'mail.account-security', with: ['notice' => $this->notice]);
    }
}
