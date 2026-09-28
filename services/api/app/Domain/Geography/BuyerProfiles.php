<?php

declare(strict_types=1);

namespace App\Domain\Geography;

use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/** Resolves the authenticated Buyer's own profile; every Buyer resource is scoped to it. */
final class BuyerProfiles
{
    public function idFor(Request $request): string
    {
        $user = $request->user();
        $id = $user === null || $user->account_type !== 'BUYER' ? null : DB::table('buyer_profiles')->where('user_id', $user->getKey())->value('id');
        if ($id === null) {
            throw new AuthenticationException('BUYER_PROFILE_REQUIRED', 'Complete your Buyer account before using locations and discovery.', 409);
        }

        return (string) $id;
    }
}
