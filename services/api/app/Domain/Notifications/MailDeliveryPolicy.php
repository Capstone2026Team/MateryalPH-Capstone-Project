<?php

declare(strict_types=1);

namespace App\Domain\Notifications;

use Carbon\CarbonImmutable;
use Throwable;

final class MailDeliveryPolicy
{
    public function allows(string $requestedAt): bool
    {
        $activation = $this->activationTime();

        if ($activation === null) {
            return true;
        }
        if (trim($requestedAt) === '') {
            return false;
        }

        try {
            return CarbonImmutable::parse($requestedAt)->greaterThanOrEqualTo($activation);
        } catch (Throwable) {
            return false;
        }
    }

    public function activationTime(): ?CarbonImmutable
    {
        $configured = config('mail.delivery_not_before');
        if ($configured === null || $configured === '') {
            return null;
        }
        if (! is_string($configured)) {
            throw new MailDeliveryException('MAIL_CONFIGURATION_INVALID');
        }

        try {
            $activation = CarbonImmutable::createFromFormat('!Y-m-d\TH:i:s\Z', $configured, 'UTC');
            if ($activation !== null && $activation->format('Y-m-d\TH:i:s\Z') === $configured) {
                return $activation;
            }
        } catch (Throwable) {
            // Configuration errors must not expose environment values through exception chains.
        }

        throw new MailDeliveryException('MAIL_CONFIGURATION_INVALID');
    }
}
