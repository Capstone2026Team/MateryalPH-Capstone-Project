<?php

declare(strict_types=1);

namespace App\Domain\Notifications;

use RuntimeException;

final class MailDeliveryException extends RuntimeException
{
    public function __construct(public readonly string $errorCode = 'MAIL_TRANSPORT_UNAVAILABLE')
    {
        parent::__construct('Email delivery is unavailable. Check the local mail configuration.');
    }
}
