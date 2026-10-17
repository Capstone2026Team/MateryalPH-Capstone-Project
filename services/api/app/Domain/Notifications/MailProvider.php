<?php

declare(strict_types=1);

namespace App\Domain\Notifications;

use Illuminate\Mail\Mailable;
use SensitiveParameter;

interface MailProvider
{
    public function send(#[SensitiveParameter] string $recipient, #[SensitiveParameter] Mailable $mail): void;
}
