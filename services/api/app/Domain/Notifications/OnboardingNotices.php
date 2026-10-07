<?php

declare(strict_types=1);

namespace App\Domain\Notifications;

use Illuminate\Support\Facades\DB;

/** Only allowlisted templates and identifiers cross from the private audit record into a notice. */
final class OnboardingNotices
{
    /** @param array<string, mixed> $after */
    public function fromAudit(string $eventId, string $action, string $resourceType, ?string $resourceId, ?string $organizationId, array $after): void
    {
        $template = match ($action) {
            'VENDOR_INVITATION_CREATED', 'VENDOR_INVITATION_ACCEPTED', 'VENDOR_MEMBERSHIP_ACTIVATED', 'VENDOR_INVITATION_REVOKED', 'VENDOR_MEMBERSHIP_CHANGED', 'VENDOR_STAFF_UPDATED', 'VENDOR_STAFF_DISPUTES_CHANGED' => ['TEAM', 'Team access changed', 'Review the current invitation, role, delegation and dispute-access settings in Team Accounts.', null],
            'VENDOR_PAYMENT_CONNECTION_FAILED', 'VENDOR_PAYMENT_RECONCILIATION_FAILED' => ['VENDOR_PAYMENT_CONNECTION', 'Payment connection needs attention', 'The payment connection could not be completed. Open Store Setup to check its current status and available retry.', null],
            'VENDOR_SETUP_INVALIDATED' => ['VENDOR_SETUP', 'Store Setup needs attention', 'A previously completed Setup requirement is no longer ready. Review Store Setup before continuing.', $after['requirement'] ?? null],
            'VENDOR_ACTIVATION_BLOCKED' => ['VENDOR_ACTIVATION', 'Store activation needs attention', 'Review the current authority, agreement and Setup blockers before continuing activation.', null],
            default => null,
        };
        if ($template === null) {
            return;
        }
        if ($resourceType === 'VENDOR_PAYMENT_ACCOUNT') {
            $organizationId = DB::table('vendor_payment_accounts')->where('id', $resourceId)->value('vendor_organization_id');
        } elseif ($resourceType === 'VENDOR_MEMBERSHIP') {
            $organizationId = DB::table('vendor_memberships')->where('id', $resourceId)->value('vendor_organization_id');
        } elseif ($resourceType === 'VENDOR_INVITATION') {
            $organizationId = DB::table('vendor_invitations')->where('id', $resourceId)->value('vendor_organization_id');
        } elseif ($resourceType === 'VENDOR_ORGANIZATION') {
            $organizationId = $resourceId;
        }
        if (! is_string($organizationId)) {
            return;
        }
        if ($action === 'VENDOR_ACTIVATION_BLOCKED') {
            foreach ($after['blockers'] ?? [] as $blocker) {
                if (in_array($blocker['key'] ?? null, ['authority_to_act', 'commission_terms', 'agreements'], true)) {
                    $template = ['VENDOR_VERIFICATION', 'Authority or terms need attention', 'Review the required authority and current terms in Store Verification.', $blocker['key'] === 'agreements' ? 'commission_terms' : $blocker['key']];
                    break;
                }
            }
        }
        $version = DB::table('vendor_organizations')->where('id', $organizationId)->value('lock_version');
        $key = $action === 'VENDOR_ACTIVATION_BLOCKED' ? $action.':'.$organizationId.':'.$version.':'.hash('sha256', json_encode($after['blockers'] ?? [])) : $eventId;
        foreach (DB::table('vendor_memberships')->where('vendor_organization_id', $organizationId)->where('role', 'OWNER')->where('status', 'ACTIVE')->pluck('user_id') as $owner) {
            app(NotificationService::class)->record((int) $owner, $template[0], $template[1], $template[2], 'VENDOR_ORGANIZATION', $organizationId, $key, $organizationId, $template[3]);
        }
    }
}
