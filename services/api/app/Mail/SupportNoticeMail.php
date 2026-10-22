<?php

declare(strict_types=1);

namespace App\Mail;

use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;

final class SupportNoticeMail extends Mailable
{
    public function __construct(public readonly string $noticeSubject, public readonly string $noticeBody, public readonly string $accountType) {}

    public function envelope(): Envelope
    {
        return new Envelope(subject: 'MateryalPH: '.$this->noticeSubject);
    }

    public function content(): Content
    {
        return new Content(view: 'mail.support-notice');
    }
}
