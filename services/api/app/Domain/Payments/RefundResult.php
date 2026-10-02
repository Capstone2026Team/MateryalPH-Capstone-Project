<?php

declare(strict_types=1);

namespace App\Domain\Payments;

final readonly class RefundResult
{
    public function __construct(public string $providerRefundId, public string $status) {}
}
