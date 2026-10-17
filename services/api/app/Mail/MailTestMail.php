<?php

declare(strict_types=1);

namespace App\Mail;

use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;

final class MailTestMail extends Mailable
{
    public function envelope(): Envelope
    {
        return new Envelope(subject: 'MateryalPH email delivery test');
    }

    public function content(): Content
    {
        return new Content(text: 'mail.delivery-test');
    }
}
