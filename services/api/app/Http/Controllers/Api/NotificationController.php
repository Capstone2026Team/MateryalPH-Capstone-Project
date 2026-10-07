<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Notifications\NotificationPolicy;
use App\Domain\Notifications\NotificationService;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;

final class NotificationController extends Controller
{
    public function index(Request $request, NotificationService $service): JsonResponse
    {
        $input = $request->validate(['cursor' => ['nullable', 'uuid']]);
        $page = $service->feed($request->user(), $input['cursor'] ?? null);

        return ApiResponse::success($page['items'], ['next_cursor' => $page['next_cursor']]);
    }

    public function read(Request $request, string $noticeId): JsonResponse
    {
        $notice = $this->notice($request, $noticeId);
        DB::table('notifications')->where('id', $notice->id)->whereNull('read_at')->update(['read_at' => now(), 'updated_at' => now()]);

        return ApiResponse::success(['read' => true]);
    }

    public function resolve(Request $request, string $noticeId, NotificationPolicy $policy): JsonResponse
    {
        // auth:api + account.access resolve the current session and membership before every click.
        return ApiResponse::success(['path' => $policy->target($request->user(), $this->notice($request, $noticeId))]);
    }

    public function preferences(Request $request): JsonResponse
    {
        $rows = DB::table('notification_preferences')->where('user_id', $request->user()->getKey())->get()->keyBy('category');
        $items = [];
        foreach (NotificationPolicy::CATEGORIES as $category) {
            $mandatory = NotificationPolicy::mandatory($category);
            $preference = $rows->get($category);
            $items[] = ['category' => $category, 'mandatory' => $mandatory,
                'explanation' => $mandatory ? 'Required to keep you informed about account safety, legal duties and active transactions. These notices remain enabled.' : 'Choose where you receive these optional updates.',
                'in_app' => $mandatory || ($preference->in_app ?? true), 'email' => $mandatory || ($preference->email ?? true), 'push' => $mandatory || ($preference->push ?? true)];
        }

        return ApiResponse::success($items, ['web_push_approved' => (bool) config('notifications.web_push_approved')]);
    }

    public function updatePreference(Request $request): JsonResponse
    {
        $input = $request->validate(['category' => ['required', Rule::in(NotificationPolicy::CATEGORIES)], 'in_app' => ['required', 'boolean'], 'email' => ['required', 'boolean'], 'push' => ['required', 'boolean']]);
        if (NotificationPolicy::mandatory($input['category']) && (! $input['in_app'] || ! $input['email'] || ! $input['push'])) {
            throw new AuthenticationException('MANDATORY_NOTIFICATION', 'Security, legal, suspension, payment, refund, dispute and threshold notices must stay enabled.', 422);
        }
        DB::table('notification_preferences')->upsert([['id' => (string) Str::uuid7(), 'user_id' => $request->user()->getKey(), ...$input, 'created_at' => now(), 'updated_at' => now()]], ['user_id', 'category'], ['in_app', 'email', 'push', 'updated_at']);

        return $this->preferences($request);
    }

    public function registerDevice(Request $request): JsonResponse
    {
        $input = $request->validate(['platform' => ['required', Rule::in(['ANDROID', 'IOS', 'WEB'])], 'token' => ['required', 'string', 'min:20', 'max:4096']]);
        $web = $request->user()->account_type !== 'BUYER';
        if (($web && ($input['platform'] !== 'WEB' || ! config('notifications.web_push_approved'))) || (! $web && $input['platform'] === 'WEB')) {
            throw new AuthenticationException('PUSH_NOT_APPROVED', 'Push notifications are not enabled for this client.', 403);
        }
        $hash = hash_hmac('sha256', $input['token'], (string) config('app.key'));
        $id = DB::transaction(function () use ($hash, $input, $request): string {
            $existing = DB::table('notification_devices')->where('token_hash', $hash)->lockForUpdate()->first();
            if ($existing !== null && (int) $existing->user_id !== (int) $request->user()->getKey() && $existing->revoked_at === null) {
                throw new AuthenticationException('DEVICE_ALREADY_REGISTERED', 'Remove the previous account registration on this device first.', 409);
            }
            $id = $existing->id ?? (string) Str::uuid7();
            DB::table('notification_devices')->updateOrInsert(['token_hash' => $hash], ['id' => $id, 'user_id' => $request->user()->getKey(), 'platform' => $input['platform'],
                'environment' => app()->environment(), 'sealed_token' => Crypt::encryptString($input['token']), 'session_id' => $request->attributes->get('auth_session')?->getKey(),
                'revoked_at' => null, 'last_seen_at' => now(), 'created_at' => $existing->created_at ?? now(), 'updated_at' => now()]);

            return $id;
        });

        return ApiResponse::success(['id' => $id], status: 201);
    }

    public function revokeDevice(Request $request, string $deviceId): JsonResponse
    {
        DB::table('notification_devices')->where('id', $deviceId)->where('user_id', $request->user()->getKey())->update(['revoked_at' => now(), 'updated_at' => now()]);

        return ApiResponse::success(['revoked' => true]);
    }

    public function failures(Request $request): JsonResponse
    {
        if ($request->user()->account_type !== 'ADMIN' || ! app(AccountAccess::class)->allows($request->user(), 'integrations.view')) {
            throw new AuthenticationException('PERMISSION_DENIED', 'Operational deliveries are not available to your role.', 403);
        }
        $input = $request->validate(['page' => ['sometimes', 'integer', 'min:1']]);
        $deliveries = DB::table('notification_deliveries')->where('state', 'FAILED')->select(['id', 'channel', 'state', 'attempt_count', 'failure_code', 'updated_at']);
        $exports = DB::table('data_exports')->where('state', 'FAILED')->selectRaw("id, 'EXPORT_GENERATION' as channel, state, 5 as attempt_count, failure_code, updated_at");
        $otherJobs = DB::table('outbox_events')->whereNull('processed_at')->where('attempts', '>=', 5)
            ->whereNotIn('event_type', ['NOTIFICATION_DELIVERY', 'DOCUMENT_EXPORT_REQUESTED'])
            ->selectRaw("id, 'OPERATIONAL_JOB' as channel, 'FAILED' as state, attempts as attempt_count, 'DELIVERY_FAILED' as failure_code, updated_at");
        $rows = DB::query()->fromSub($deliveries->unionAll($exports)->unionAll($otherJobs), 'failures')->orderByDesc('id')->paginate(25, ['*'], 'page', $input['page'] ?? 1);

        return ApiResponse::success($rows->items(), ['has_more' => $rows->hasMorePages()]);
    }

    private function notice(Request $request, string $id): object
    {
        $notice = DB::table('notifications')->where('id', $id)->where('user_id', $request->user()->getKey())->first();
        if ($notice === null || ! app(NotificationPolicy::class)->allows($request->user(), $notice)) {
            throw new AuthenticationException('NOTICE_ACCESS_REVOKED', 'This notification is unavailable or you no longer have permission to open it.', 403);
        }

        return $notice;
    }
}
