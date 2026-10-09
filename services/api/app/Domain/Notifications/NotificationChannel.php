<?php

declare(strict_types=1);

namespace App\Domain\Notifications;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuthenticationException;
use App\Models\User;

/** Viewer-bound invalidations; account and membership changes rotate the opaque channel. */
final class NotificationChannel
{
    public function name(User $user): ?string
    {
        $user->refresh();
        try {
            $scope = app(AccountAccess::class)->resolve($user);
        } catch (AuthenticationException) {
            return null;
        }
        $epoch = hash_hmac('sha256', implode('|', [$user->id, $user->account_type, $user->account_status, $user->updated_at, json_encode($scope)]), (string) config('app.key'));

        return 'notifications.'.$epoch;
    }

    public function join(User $user, string $epoch): bool
    {
        $channel = $this->name($user);

        return $channel !== null && hash_equals($channel, 'notifications.'.$epoch);
    }
}
