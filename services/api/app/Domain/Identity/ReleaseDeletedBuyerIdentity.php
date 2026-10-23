<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/** Releases login identifiers for a fresh Buyer registration, never the retained account or its history. */
final class ReleaseDeletedBuyerIdentity
{
    /** The caller must lock the user inside the registration transaction. */
    public function release(User $user): bool
    {
        if ($user->account_type !== 'BUYER' || $user->account_status !== 'DELETED' || $user->account_deleted_at === null) {
            return false;
        }

        $placeholder = 'deleted-'.Str::uuid7().'@accounts.materyalph.invalid';
        DB::table('external_identities')->where('user_id', $user->getKey())->delete();
        // Old verification/recovery codes must neither authorize the new account nor throttle its first code.
        DB::table('email_otps')->where('user_id', $user->getKey())->update([
            'normalized_email' => $placeholder,
            'invalidated_at' => now(),
            'updated_at' => now(),
        ]);
        $user->forceFill([
            'email' => $placeholder,
            'email_verified_at' => null,
            'lock_version' => (int) $user->lock_version + 1,
        ])->save();

        return true;
    }
}
