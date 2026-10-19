<?php

declare(strict_types=1);

namespace App\Domain\Support;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\AdminAccess;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

final class SupportAccess
{
    public function ticket(Request $request, string $id, bool $manage = false): object
    {
        $ticket = DB::table('support_tickets')->where('id', $id)->first();
        if ($ticket === null) {
            throw new AuthenticationException('SUPPORT_NOT_FOUND', 'This support request is unavailable.', 404);
        }
        if ($request->attributes->get('support_portal') === 'guest') {
            $raw = $request->cookie('mp_support');
            $allowed = is_string($raw) && DB::table('support_guest_credentials')->where('ticket_id', $id)->where('purpose', 'SESSION')
                ->where('token_hash', self::hash($raw))->whereNull('consumed_at')->where('expires_at', '>', now())->exists();
            if ($ticket->user_id !== null || ! $allowed) {
                throw new AuthenticationException('SUPPORT_ACCESS_REQUIRED', 'Open a fresh secure link from your support email.', 401);
            }
        } elseif ($request->attributes->get('support_portal') === 'admin') {
            app(AdminAccess::class)->require($request, 'support.view', ...($manage ? ['support.manage'] : []));
        } elseif (! $request->user() instanceof User || (int) $ticket->user_id !== (int) $request->user()->getKey()) {
            throw new AuthenticationException('SUPPORT_NOT_FOUND', 'This support request is unavailable.', 404);
        }

        return $ticket;
    }

    public function allows(User $user, string $id): bool
    {
        if ($user->account_status !== 'ACTIVE') {
            return false;
        }
        try {
            $scope = app(AccountAccess::class)->resolve($user);

            return $user->account_type === 'ADMIN'
                ? in_array('support.view', $scope['permissions'], true)
                : DB::table('support_tickets')->where('id', $id)->where('user_id', $user->getKey())->exists();
        } catch (AuthenticationException) {
            return false;
        }
    }

    public static function hash(string $value): string
    {
        return hash_hmac('sha256', $value, (string) config('app.key'));
    }
}
