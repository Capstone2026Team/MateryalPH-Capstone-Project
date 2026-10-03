<?php

declare(strict_types=1);

namespace App\Domain\Messaging;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuthenticationException;
use App\Models\User;

/** Account-scoped invalidations only; every inbox fetch reauthorizes its data. */
final class BuyerInboxChannel
{
    public function name(User $user): ?string
    {
        $user->refresh();
        if (! in_array($user->account_type, ['BUYER', 'VENDOR'], true)) {
            return null;
        }
        try {
            $scope = app(AccountAccess::class)->resolve($user);
        } catch (AuthenticationException) {
            return null;
        }
        $epoch = hash_hmac('sha256', implode('|', [$user->id, $user->account_status, $user->updated_at, json_encode($scope)]), (string) config('app.key'));

        return strtolower($user->account_type).'-inbox.'.$epoch;
    }

    public function join(User $user, string $epoch): bool
    {
        $channel = $this->name($user);

        return $channel !== null && hash_equals($channel, strtolower($user->account_type).'-inbox.'.$epoch);
    }
}
