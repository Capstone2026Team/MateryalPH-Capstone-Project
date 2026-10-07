<?php

declare(strict_types=1);

namespace App\Domain\Notifications;

interface PushGateway
{
    /** Returns SENT or REVOKED; throws a sanitized exception on a retryable failure. */
    public function send(string $token, string $notificationId, string $platform): string;
}
