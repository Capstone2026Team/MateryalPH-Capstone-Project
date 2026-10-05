<?php

declare(strict_types=1);

namespace App\Policies;

use App\Domain\Analytics\AnalyticsDataset;
use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuthenticationException;
use App\Models\User;

/**
 * MAT-05 audience policy, evaluated from the database on every request and every cache hit. Buyer views need an
 * active Buyer account; Vendor competitor views need materials_analytics.view_competitors, which only the Owner and
 * Store Manager hold (no dispute flag, delegation or combined scope grants it); Admin aggregates need
 * analytics.view_aggregates; source inspection needs materials_analytics.inspect_sources; Admin exports also need
 * analytics.export. The audience is the authenticated account type, never a request parameter.
 */
final class MaterialsAnalyticsPolicy
{
    public const VENDOR_VIEW = 'materials_analytics.view_competitors';

    public const ADMIN_VIEW = 'analytics.view_aggregates';

    public const INSPECT_SOURCES = 'materials_analytics.inspect_sources';

    public const ADMIN_EXPORT = 'analytics.export';

    public function __construct(private readonly AccountAccess $access) {}

    public function viewBuyer(User $user): bool
    {
        return $user->account_type === 'BUYER' && $user->account_status === 'ACTIVE';
    }

    public function viewVendor(User $user): bool
    {
        return $user->account_type === 'VENDOR' && in_array(self::VENDOR_VIEW, $this->access->resolve($user)['permissions'], true);
    }

    public function viewAdmin(User $user): bool
    {
        return $user->account_type === 'ADMIN' && in_array(self::ADMIN_VIEW, $this->access->resolve($user)['permissions'], true);
    }

    public function inspectSources(User $user): bool
    {
        return $user->account_type === 'ADMIN' && in_array(self::INSPECT_SOURCES, $this->access->resolve($user)['permissions'], true);
    }

    public function exportAdmin(User $user): bool
    {
        $permissions = $user->account_type === 'ADMIN' ? $this->access->resolve($user)['permissions'] : [];

        return in_array(self::ADMIN_VIEW, $permissions, true) && in_array(self::ADMIN_EXPORT, $permissions, true);
    }

    /** Throws the documented denial unless the named ability holds; also enforces the operational kill switch. */
    public function authorize(?User $user, string $ability): void
    {
        if (! AnalyticsDataset::enabled()) {
            throw new AuthenticationException('MATERIALS_ANALYTICS_UNAVAILABLE', 'Materials Analytics is temporarily unavailable.', 503);
        }
        if ($user === null || ! $this->{$ability}($user)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'Materials Analytics is not available to your role.', 403);
        }
    }
}
