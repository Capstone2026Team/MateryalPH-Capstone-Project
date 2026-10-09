<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Domain\Authorization\VendorTeamActivityBroadcast;
use App\Domain\Notifications\OnboardingNotices;
use App\Models\LoginEvent;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class AuditRecorder
{
    /**
     * @param  array<string, mixed>  $before
     * @param  array<string, mixed>  $after
     */
    public function account(Request $request, string $action, string $resourceType, ?string $resourceId, array $before = [], array $after = [], bool $succeeded = true, ?string $reason = null): void
    {
        $scope = $request->attributes->get('account_scope', []);
        $auditId = (string) Str::uuid7();
        DB::table('audit_logs')->insert([
            'id' => $auditId,
            'actor_user_id' => $request->user()?->getKey(),
            'actor_role' => $scope['role'] ?? $request->user()?->account_type,
            'vendor_organization_id' => $scope['organization_id'] ?? null,
            'action' => $action,
            'resource_type' => $resourceType,
            'resource_id' => $resourceId,
            'before' => json_encode($before, JSON_THROW_ON_ERROR),
            'after' => json_encode($after, JSON_THROW_ON_ERROR),
            'reason' => $reason,
            'correlation_id' => (string) $request->attributes->get('correlation_id'),
            'succeeded' => $succeeded,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        app(VendorTeamActivityBroadcast::class)->publish($scope['organization_id'] ?? null, $scope['role'] ?? $request->user()?->account_type);
        app(OnboardingNotices::class)->fromAudit($auditId, $action, $resourceType, $resourceId, $scope['organization_id'] ?? null, $after);
    }

    /** @param array<string, mixed> $safeContext */
    public function record(Request $request, string $eventType, bool $succeeded, ?User $user = null, array $safeContext = []): void
    {
        LoginEvent::query()->create([
            'user_id' => $user?->getKey(),
            'normalized_email_hash' => isset($safeContext['email'])
                ? hash_hmac('sha256', mb_strtolower(trim((string) $safeContext['email'])), (string) config('app.key'))
                : null,
            'event_type' => $eventType,
            'succeeded' => $succeeded,
            'ip_address' => $request->ip(),
            'correlation_id' => (string) $request->attributes->get('correlation_id'),
            'safe_context' => array_diff_key($safeContext, ['email' => true]),
        ]);
    }
}
