<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

final class AdminDashboardService
{
    /** @return array<string, mixed> */
    public function summary(Request $request): array
    {
        $scope = $request->attributes->get('account_scope', []);
        $super = ($scope['role'] ?? null) === 'ADMIN_SUPERADMIN';
        $review = $super || in_array('vendor_verification.review', $scope['permissions'] ?? [], true);
        $vendors = DB::table('vendor_organizations');

        return [
            'generated_at' => now()->toIso8601String(),
            'active_vendors' => $review ? (clone $vendors)->where('account_status', 'ACTIVE')->where('store_activation_status', 'ACTIVE')->count() : null,
            'inactive_vendors' => $review ? (clone $vendors)->where(function ($query): void {
                $query->where('account_status', '!=', 'ACTIVE')->orWhere('store_activation_status', '!=', 'ACTIVE');
            })->count() : null,
            'active_buyers' => $super ? DB::table('users')->where('account_type', 'BUYER')->where('account_status', 'ACTIVE')->count() : null,
            'pending_document_reviews' => $review ? DB::table('business_documents as d')->join('vendor_organizations as o', 'o.id', '=', 'd.vendor_organization_id')
                ->whereIn('o.store_verification_status', ['SUBMITTED', 'PENDING_VERIFICATION'])->whereIn('d.status', ['SUBMITTED', 'PENDING_VERIFICATION'])->count() : null,
            'audit_events' => $super ? DB::table('audit_logs')->count() : null,
            'can_view_audit' => $super,
        ];
    }

    /** @return array<string, mixed> */
    public function audit(Request $request): array
    {
        $scope = $request->attributes->get('account_scope', []);
        if (($scope['role'] ?? null) !== 'ADMIN_SUPERADMIN') {
            throw new AuthenticationException('PERMISSION_DENIED', 'Your role cannot view platform audit tracking.', 403);
        }
        // Explicit safe projection: never expose before/after payloads, secrets, IPs or private evidence.
        $rows = DB::table('audit_logs')->orderByDesc('created_at')->orderByDesc('id')
            ->paginate(20, ['id', 'actor_role', 'action', 'resource_type', 'correlation_id', 'succeeded', 'created_at']);

        return ['items' => $rows->items(), 'meta' => ['current_page' => $rows->currentPage(), 'last_page' => $rows->lastPage(), 'total' => $rows->total()]];
    }
}
