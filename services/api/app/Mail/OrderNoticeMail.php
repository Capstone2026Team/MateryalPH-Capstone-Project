<?php

declare(strict_types=1);

namespace App\Mail;

use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;

final class OrderNoticeMail extends Mailable
{
    public function __construct(public readonly string $noticeSubject, public readonly string $notice) {}

    public function envelope(): Envelope
    {
        return new Envelope(subject: 'MateryalPH: '.$this->noticeSubject);
    }

    public function content(): Content
    {
        return new Content(view: 'mail.order-notice', with: ['noticeSubject' => $this->noticeSubject, 'notice' => $this->notice]);
    }
}
