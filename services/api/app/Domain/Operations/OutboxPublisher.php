<?php

declare(strict_types=1);

namespace App\Domain\Operations;

use App\Jobs\ProcessOutboxEvent;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Throwable;

final class OutboxPublisher
{
    /** @param array<string, int|string> $sensitivePayload */
    public function publish(
        string $eventType,
        string $aggregateType,
        string $aggregateId,
        array $sensitivePayload,
    ): string {
        $id = (string) Str::uuid7();
        if ($eventType === 'ACCOUNT_SECURITY_NOTICE') {
            $userId = DB::table('users')->where('public_id', $aggregateId)->value('id');
            if ($userId !== null) {
                $noticeId = (string) Str::uuid7();
                DB::table('notifications')->insert(['id' => $noticeId, 'user_id' => $userId, 'category' => 'SECURITY', 'title' => 'Account security update',
                    'body' => $sensitivePayload['message'], 'resource_type' => 'ACCOUNT', 'resource_id' => $aggregateId, 'event_key' => hash('sha256', $id), 'created_at' => now(), 'updated_at' => now()]);
                $sensitivePayload['notification_id'] = $noticeId;
            }
        }
        if (is_string($sensitivePayload['notification_id'] ?? null) && $aggregateType === 'VENDOR_ORGANIZATION') {
            DB::table('notifications')->where('id', $sensitivePayload['notification_id'])->update(['vendor_organization_id' => $aggregateId]);
        }
        $sealedPayload = Crypt::encryptString(json_encode($sensitivePayload, JSON_THROW_ON_ERROR));

        DB::table('outbox_events')->insert([
            'id' => $id,
            'event_type' => $eventType,
            'aggregate_type' => $aggregateType,
            'aggregate_id' => $aggregateId,
            'payload' => json_encode(['sealed_payload' => $sealedPayload], JSON_THROW_ON_ERROR),
            'available_at' => now(),
            'attempts' => 0,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        DB::afterCommit(static function () use ($id): void {
            $leased = DB::table('outbox_events')->where('id', $id)->whereNull('processed_at')
                ->where(fn ($query) => $query->whereNull('dispatched_until')->orWhere('dispatched_until', '<=', now()))
                ->update(['dispatched_until' => now()->addHour()]);
            if ($leased === 0) {
                return;
            }
            try {
                ProcessOutboxEvent::dispatch($id);
            } catch (Throwable $exception) {
                DB::table('outbox_events')->where('id', $id)->whereNull('processed_at')->update(['dispatched_until' => null]);
                report($exception);
            }
        });

        return $id;
    }
}
