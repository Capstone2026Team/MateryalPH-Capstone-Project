<?php

declare(strict_types=1);

namespace App\Domain\Authorization;

use App\Models\User;

final class FinancePolicy
{
    public function __construct(private readonly AccountAccess $access) {}

    public function review(User $user, string $permission, int|string $preparerId): bool
    {
        return $user->account_type === 'ADMIN'
            && in_array($permission, ['finance.review_tax', 'finance.approve_statements'], true)
            && (string) $user->getKey() !== (string) $preparerId
            && $this->access->allows($user, $permission);
    }
}
