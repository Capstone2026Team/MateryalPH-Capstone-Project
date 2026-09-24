<?php

declare(strict_types=1);

namespace App\Http\Resources;

use App\Domain\Authorization\AccountAccess;
use App\Models\AuthSession;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\URL;

/** @mixin User */
final class AccountProfileResource extends JsonResource
{
    /** @return array<string, mixed> */
    public function toArray(Request $request): array
    {
        $scope = app(AccountAccess::class)->resolve($this->resource);
        $buyer = $this->account_type === 'BUYER' ? DB::table('buyer_profiles')->where('user_id', $this->getKey())->first() : null;
        $session = $request->attributes->get('auth_session');
        $recent = $session instanceof AuthSession && $session->revoked_at === null
            && $session->reauthenticated_at !== null && $session->reauthenticated_at->addMinutes(15)->isFuture();
        $email = $this->email;
        if ($this->account_type === 'BUYER' && ! $recent) {
            $parts = explode('@', $email, 2);
            $email = mb_substr($parts[0], 0, 1).'***@'.($parts[1] ?? '');
        }

        return [
            'id' => $this->public_id,
            'full_name' => $this->name,
            'avatar_url' => $this->account_type !== 'BUYER' && $this->profile_photo_key ? URL::temporarySignedRoute('account.photo.'.strtolower($this->account_type), now()->addMinutes(5), ['version' => $this->lock_version, 'owner' => $this->public_id]) : null,
            'email' => $email,
            'email_masked' => $this->account_type === 'BUYER' && ! $recent,
            'mobile_e164' => $this->account_type === 'BUYER' ? DB::table('user_profiles')->where('user_id', $this->getKey())->value('mobile_e164') : null,
            'account_type' => $this->account_type,
            'account_status' => $this->account_status,
            'lock_version' => (int) $this->lock_version,
            'created_at' => $this->created_at?->toIso8601String(),
            'buyer_type' => $buyer?->buyer_type,
            'company_name' => $buyer?->company_name,
            'organization_name' => $scope['organization_id'] === null ? null : DB::table('vendor_organizations')->where('id', $scope['organization_id'])->value('store_name'),
            ...$scope,
        ];
    }
}
