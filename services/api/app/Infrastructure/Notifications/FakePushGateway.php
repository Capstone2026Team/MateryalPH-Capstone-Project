<?php

declare(strict_types=1);

namespace App\Infrastructure\Notifications;

use App\Domain\Notifications\PushGateway;
use App\Domain\Notifications\PushNotification;
use RuntimeException;

final class FakePushGateway implements PushGateway
{
    public int $sent = 0;

    public bool $fail = false;

    public bool $revoked = false;

    public ?PushNotification $lastNotification = null;

    public function send(#[\SensitiveParameter] string $token, PushNotification $notification, string $platform): string
    {
        if ($this->fail) {
            throw new RuntimeException('PUSH_UNAVAILABLE');
        }
        if ($this->revoked) {
            return 'REVOKED';
        }
        $this->sent++;
        $this->lastNotification = $notification;

        return 'SENT';
    }
}
