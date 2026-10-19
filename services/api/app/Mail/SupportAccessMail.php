<?php

declare(strict_types=1);

namespace App\Mail;

use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;

final class SupportAccessMail extends Mailable
{
    public function __construct(public readonly string $ticketNumber, public readonly string $accessUrl) {}

    public function envelope(): Envelope
    {
        return new Envelope(subject: 'MateryalPH support update: '.$this->ticketNumber);
    }

    public function content(): Content
    {
        return new Content(view: 'mail.support-access');
    }
}
