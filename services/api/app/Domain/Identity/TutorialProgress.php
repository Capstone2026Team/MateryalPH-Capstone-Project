<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Models\User;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class TutorialProgress
{
    /** @return list<string> */
    public static function keys(string $accountType): array
    {
        return $accountType === 'BUYER'
            ? ['overview', 'discovery', 'procurement', 'projects', 'messages', 'orders']
            : ['overview', 'store', 'products', 'inventory', 'messages', 'orders', 'dashboard', 'fulfillment', 'invoices', 'disputes', 'reviews', 'vehicles', 'finance', 'commissions', 'transactions', 'remittance', 'performance', 'analytics', 'team', 'tracking', 'settings', 'notifications', 'support'];
    }

    /** @return list<array{tutorial_key: string, status: string, updated_at: string}> */
    public function read(User $user): array
    {
        return DB::table('user_tutorials')->where('user_id', $user->getKey())
            ->whereIn('tutorial_key', self::keys($user->account_type))->orderBy('tutorial_key')->get()
            ->map(fn (object $row): array => [
                'tutorial_key' => $row->tutorial_key, 'status' => $row->status,
                'updated_at' => CarbonImmutable::parse($row->updated_at)->toIso8601String(),
            ])->all();
    }

    /** @return list<array{tutorial_key: string, status: string, updated_at: string}> */
    public function acknowledge(Request $request, string $key, string $status): array
    {
        return DB::transaction(function () use ($request, $key, $status): array {
            $user = User::query()->whereKey($request->user()->getKey())->lockForUpdate()->firstOrFail();
            $saved = DB::table('user_tutorials')->where('user_id', $user->getKey())->where('tutorial_key', $key)->first();
            // Replays never clear completion. Retried acknowledgments are naturally idempotent.
            if ($saved === null || ($saved->status === 'SKIPPED' && $status === 'COMPLETED')) {
                DB::table('user_tutorials')->updateOrInsert(['user_id' => $user->getKey(), 'tutorial_key' => $key], [
                    'id' => $saved === null ? (string) Str::uuid7() : $saved->id, 'status' => $status,
                    'created_at' => $saved === null ? now() : $saved->created_at, 'updated_at' => now(),
                ]);
                app(AuditRecorder::class)->account($request, 'TUTORIAL_ACKNOWLEDGED', 'USER', $user->public_id,
                    after: ['tutorial_key' => $key, 'status' => $status]);
            }

            return $this->read($user);
        });
    }
}
