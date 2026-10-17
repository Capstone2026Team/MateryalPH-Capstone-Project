<?php

declare(strict_types=1);

namespace App\Domain\Operations;

use App\Domain\Analytics\AnalyticsDataset;
use App\Domain\Compliance\ComplianceTextExtractor;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Jobs\ProcessOutboxEvent;
use App\Jobs\RunOperationalRetry;
use App\Support\PortalDateRange;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Throwable;

/**
 * Integration and Job Health (Admin Workflow §17). Shows safe operational status for Xendit, Google services, email,
 * push, file storage, Reverb, queues, scheduled tasks, geographic aggregation, the Materials Analytics snapshot, PSGC
 * and OCR. Credentials are never read into the response: only whether a value is configured, a masked environment
 * label, counts, timestamps and correlation-safe references. Failed jobs and dead-lettered outbox events show their
 * type and failure class — never payloads, recipients or exception messages. Retries are limited to allowlisted
 * idempotent work and need jobs.retry plus a recorded reason; payment and refund work is owned by reconciliation.
 */
final class JobHealthService
{
    /** Outbox deliveries that are safe to replay: each is deduplicated by its notification, delivery or export key. */
    public const RETRYABLE_OUTBOX = ['NOTIFICATION_READY', 'NOTIFICATION_DELIVERY', 'ORDER_NOTICE', 'DISPUTE_NOTICE', 'FINANCE_NOTICE', 'VENDOR_ONBOARDING_NOTICE', 'PRODUCT_COMPLIANCE_NOTICE',
        'VENDOR_INVENTORY_NOTICE', 'ACCOUNT_SECURITY_NOTICE', 'CONVERSATION_CHANGED', 'DISPUTE_CASE_CHANGED', 'DOCUMENT_EXPORT_REQUESTED', 'DISPUTE_EXPORT_REQUESTED',
        'MARKETPLACE_ELIGIBILITY_CHANGED', 'VENDOR_FLEET_CHANGED', 'VENDOR_TEAM_ACTIVITY_CHANGED', 'ORDER_STATE_CHANGED', 'NOTIFICATIONS_CHANGED'];

    public const RETRYABLE_JOBS = [ProcessOutboxEvent::class];

    /** Scheduled work expected by the platform and its maximum healthy age in minutes. */
    private const SCHEDULE = [
        'materyalph:outbox-dispatch' => 5, 'materyalph:orders-expire' => 5, 'materyalph:quotations-sweep' => 5, 'materyalph:disputes-sweep' => 5,
        'materyalph:payments-reconcile' => 15, 'materyalph:fulfillment-sweep' => 15, 'materyalph:reviews-sweep' => 45, 'materyalph:enforcement-sweep' => 45,
        'analytics:capture-material-prices' => 1500, 'analytics:aggregate-marketplace' => 1500, 'materyalph:scores-daily' => 1500, 'materyalph:finance-daily' => 1500,
    ];

    private const PER_PAGE = 25;

    public function __construct(private readonly AdminAccess $access, private readonly AuditRecorder $audit) {}

    /** @return array<string, mixed> */
    public function overview(Request $request): array
    {
        $actor = $this->access->require($request, 'integrations.view');
        $since = now()->subDay();

        return ['generated_at' => now()->toIso8601String(), 'environment' => ['app' => self::label((string) app()->environment()), 'commerce' => 'TEST — LIVE commerce disabled'],
            'integrations' => $this->integrations($since), 'queues' => $this->queues(), 'scheduled_tasks' => $this->scheduled(), 'analytics' => $this->analytics(),
            'can_retry' => in_array('jobs.retry', $actor['permissions'], true)];
    }

    /**
     * @param  array<string, mixed>  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function failures(Request $request, array $filters): array
    {
        $this->access->require($request, 'integrations.view');
        $page = max(1, min(1000, (int) ($filters['page'] ?? 1)));
        if (($filters['kind'] ?? 'OUTBOX') === 'JOBS') {
            $query = DB::table('failed_jobs');
            PortalDateRange::apply($query, 'failed_at', $filters);
            $total = (clone $query)->count();
            $items = $query->orderByDesc('failed_at')->offset(($page - 1) * self::PER_PAGE)->limit(self::PER_PAGE)->get(['uuid', 'queue', 'payload', 'exception', 'failed_at'])
                ->map(function (object $row): array {
                    $payload = json_decode((string) $row->payload, true) ?: [];
                    $job = (string) ($payload['displayName'] ?? 'Unknown job');
                    $event = $this->failedOutboxEvent((string) $row->payload);
                    $retryable = $event !== null && in_array($event->event_type, self::RETRYABLE_OUTBOX, true);

                    return ['kind' => 'FAILED_JOB', 'reference' => (string) $row->uuid, 'label' => class_basename($job), 'queue' => (string) $row->queue,
                        'failure' => self::failureClass((string) $row->exception), 'attempts' => null, 'failed_at' => CarbonImmutable::parse((string) $row->failed_at)->toIso8601String(),
                        'retryable' => $retryable, 'retry_note' => $retryable ? null : 'Not an allowlisted idempotent delivery. Use its own reconciliation or a new request.'];
                })->all();
        } else {
            $query = DB::table('outbox_events')->whereNull('processed_at')->where('attempts', '>=', OutboxProcessor::MAX_ATTEMPTS);
            PortalDateRange::apply($query, 'updated_at', $filters);
            $total = (clone $query)->count();
            $items = $query->orderByDesc('updated_at')->offset(($page - 1) * self::PER_PAGE)->limit(self::PER_PAGE)->get(['id', 'event_type', 'aggregate_type', 'attempts', 'updated_at'])
                ->map(static fn (object $row): array => ['kind' => 'OUTBOX_EVENT', 'reference' => (string) $row->id, 'label' => (string) $row->event_type, 'queue' => (string) $row->aggregate_type,
                    'failure' => 'Delivery attempts exhausted', 'attempts' => (int) $row->attempts, 'failed_at' => CarbonImmutable::parse((string) $row->updated_at)->toIso8601String(),
                    'retryable' => in_array($row->event_type, self::RETRYABLE_OUTBOX, true),
                    'retry_note' => in_array($row->event_type, self::RETRYABLE_OUTBOX, true) ? null : 'Payment, refund, credential and invitation work is retried only by its own reconciliation or a new request.'])->all();
        }

        return ['items' => $items, 'meta' => ['page' => $page, 'per_page' => self::PER_PAGE, 'total' => $total, 'has_more' => $page * self::PER_PAGE < $total]];
    }

    /** @return array<string, mixed> */
    public function retry(Request $request, string $type, string $reference, mixed $reasonInput): array
    {
        $actor = $this->access->require($request, 'integrations.view', 'jobs.retry');
        $reason = AdminAccess::reason($reasonInput);
        $correlation = AdminAccess::correlation($request);
        $label = match ($type) {
            'FAILED_JOB' => $this->retryJob($reference),
            'OUTBOX_EVENT' => $this->retryOutbox($reference),
            'GEO_FACTS_RUN', 'MATERIAL_SNAPSHOT' => $this->retryAnalytics($type, $actor['user_id']),
            default => throw new AuthenticationException('RETRY_TARGET_INVALID', 'Choose a failed job, a dead-lettered delivery or a daily analytics run.', 422),
        };
        DB::table('operation_retries')->insert(['id' => (string) Str::uuid7(), 'target_type' => $type, 'target_reference' => mb_substr($reference, 0, 80), 'target_label' => mb_substr($label, 0, 120),
            'reason' => $reason, 'outcome' => 'QUEUED', 'actor_user_id' => $actor['user_id'], 'actor_role' => $actor['role'], 'correlation_id' => $correlation, 'created_at' => now()]);
        $this->audit->account($request, 'OPERATION_RETRY_QUEUED', 'OPERATION', null, [], ['target_type' => $type, 'target' => $label], reason: $reason);

        return ['target_type' => $type, 'reference' => $reference, 'label' => $label, 'outcome' => 'QUEUED', 'correlation_id' => $correlation];
    }

    /** @return list<array<string, mixed>> */
    public function retries(Request $request): array
    {
        $this->access->require($request, 'integrations.view');

        return DB::table('operation_retries as r')->join('users as u', 'u.id', '=', 'r.actor_user_id')->orderByDesc('r.created_at')->limit(25)
            ->get(['r.target_type', 'r.target_label', 'r.reason', 'r.outcome', 'r.actor_role', 'r.correlation_id', 'r.created_at', 'u.name'])
            ->map(static fn (object $row): array => ['target_type' => (string) $row->target_type, 'label' => (string) $row->target_label, 'reason' => (string) $row->reason, 'outcome' => (string) $row->outcome,
                'actor' => (string) $row->name, 'actor_role' => (string) $row->actor_role, 'correlation_id' => (string) $row->correlation_id,
                'created_at' => CarbonImmutable::parse((string) $row->created_at)->toIso8601String()])->all();
    }

    /** @return array<string, int> counts for the operations home */
    public static function counts(): array
    {
        return ['failed_jobs' => DB::table('failed_jobs')->count(),
            'dead_letters' => DB::table('outbox_events')->whereNull('processed_at')->where('attempts', '>=', OutboxProcessor::MAX_ATTEMPTS)->count()];
    }

    private function retryJob(string $uuid): string
    {
        return DB::transaction(function () use ($uuid): string {
            $row = DB::table('failed_jobs')->where('uuid', $uuid)->lockForUpdate()->first(['payload']);
            if ($row === null) {
                throw new AuthenticationException('RETRY_TARGET_NOT_FOUND', 'This failed job is no longer listed.', 404);
            }
            $event = $this->failedOutboxEvent((string) $row->payload, lock: true);
            if ($event === null || ! in_array($event->event_type, self::RETRYABLE_OUTBOX, true)) {
                throw new AuthenticationException('RETRY_NOT_ALLOWED', 'Only allowlisted idempotent deliveries can be retried from the portal.', 409);
            }
            if ($event->processed_at === null && (int) $event->attempts >= OutboxProcessor::MAX_ATTEMPTS) {
                $this->resetOutbox($event);
            }
            DB::afterCommit(static function () use ($uuid): void {
                Artisan::call('queue:retry', ['id' => [$uuid]]);
            });

            return class_basename(ProcessOutboxEvent::class);
        });
    }

    private function failedOutboxEvent(string $payload, bool $lock = false): ?object
    {
        $data = json_decode($payload, true);
        if (! is_array($data) || ! in_array($data['displayName'] ?? null, self::RETRYABLE_JOBS, true) || ! is_string($data['data']['command'] ?? null)) {
            return null;
        }
        try {
            $job = @unserialize($data['data']['command'], ['allowed_classes' => [ProcessOutboxEvent::class]]);
            if (! $job instanceof ProcessOutboxEvent || ! Str::isUuid($job->eventId)) {
                return null;
            }
        } catch (Throwable) {
            return null;
        }
        $query = DB::table('outbox_events')->where('id', $job->eventId);
        if ($lock) {
            $query->lockForUpdate();
        }

        return $query->first(['id', 'event_type', 'aggregate_id', 'attempts', 'processed_at']);
    }

    private function resetOutbox(object $event): void
    {
        DB::table('outbox_events')->where('id', $event->id)->update(['attempts' => 0, 'available_at' => now(), 'updated_at' => now()]);
        if ($event->event_type === 'DOCUMENT_EXPORT_REQUESTED') {
            // Retry the original immutable snapshot; processing rechecks the requester's current access.
            DB::table('data_exports')->where('id', $event->aggregate_id)->where('state', 'FAILED')->where('failure_code', 'GENERATION_FAILED')
                ->update(['state' => 'QUEUED', 'failure_code' => null, 'updated_at' => now()]);
        }
    }

    private function retryOutbox(string $id): string
    {
        return DB::transaction(function () use ($id): string {
            $row = Str::isUuid($id) ? DB::table('outbox_events')->where('id', $id)->lockForUpdate()->first(['id', 'event_type', 'aggregate_id', 'attempts', 'processed_at']) : null;
            if ($row === null || $row->processed_at !== null || (int) $row->attempts < OutboxProcessor::MAX_ATTEMPTS) {
                throw new AuthenticationException('RETRY_TARGET_NOT_FOUND', 'This delivery is not dead-lettered.', 404);
            }
            if (! in_array($row->event_type, self::RETRYABLE_OUTBOX, true)) {
                throw new AuthenticationException('RETRY_NOT_ALLOWED', 'Payment, refund, credential and invitation work is retried only by its own reconciliation or a new request.', 409);
            }
            $this->resetOutbox($row);
            // Dispatch failures are reported, never surfaced: the event stays in the outbox and is visible here again.
            DB::afterCommit(static function () use ($row): void {
                try {
                    ProcessOutboxEvent::dispatch((string) $row->id);
                } catch (Throwable $exception) {
                    report($exception);
                }
            });

            return (string) $row->event_type;
        });
    }

    private function retryAnalytics(string $type, int $userId): string
    {
        RunOperationalRetry::dispatch($type, $userId)->afterCommit();

        return $type === 'GEO_FACTS_RUN' ? 'Geographic analytics aggregation' : 'Materials Analytics daily snapshot';
    }

    /** @return list<array<string, mixed>> */
    private function integrations(\DateTimeInterface $since): array
    {
        $configured = static fn (mixed $value): bool => is_string($value) && trim($value) !== '';
        $lastWebhook = DB::table('webhook_events')->where('provider', 'XENDIT')->max('received_at');
        $failedWebhooks = DB::table('webhook_events')->where('provider', 'XENDIT')->where('received_at', '>=', $since)->where('verification', '<>', 'TOKEN_VERIFIED')->count();
        $stalledWebhooks = DB::table('webhook_events')->where('provider', 'XENDIT')->where('state', 'RECEIVED')->where('received_at', '<', now()->subMinutes(10))->count();
        $gateway = (string) config('payments.gateway');
        $emailFailures = DB::table('notification_deliveries')->where('channel', 'EMAIL')->where('state', 'FAILED')->where('updated_at', '>=', $since)->count();
        $pushFailures = DB::table('notification_deliveries')->where('channel', 'PUSH')->where('state', 'FAILED')->where('updated_at', '>=', $since)->count();
        $scanBacklog = DB::table('files')->where('scan_state', 'PENDING')->where('created_at', '<', now()->subHour())->count();
        $quarantined = DB::table('files')->whereNotIn('scan_state', ['CLEAN', 'PENDING'])->where('created_at', '>=', $since)->count();
        $providerErrors = DB::table('vendor_payment_accounts')->whereNotNull('last_error_code')->count();
        $ocr = app(ComplianceTextExtractor::class);
        $ocrConfigured = $ocr->provider() !== 'NONE';
        $ocrAvailable = $ocrConfigured && $ocr->available();
        $item = static fn (string $key, string $label, string $status, string $detail, ?string $environment = null, ?string $lastEventAt = null): array => ['key' => $key, 'label' => $label,
            'status' => $status, 'detail' => $detail, 'environment' => $environment, 'last_event_at' => $lastEventAt];
        // DTI-BPS updates its PS licensee and ICC certificate lists monthly; an old snapshot misses new licences.
        $registers = DB::table('compliance_reference_registers')->where('status', 'ACTIVE')->pluck('snapshot_date', 'register_kind');
        $staleBefore = now('Asia/Manila')->subDays((int) config('materyalph.compliance_registers.stale_after_days', 45))->toDateString();
        $registerState = static fn (string $kind, string $name): string => $name.' '.(isset($registers[$kind]) ? 'snapshot '.$registers[$kind].((string) $registers[$kind] < $staleBefore ? ' (stale)' : '') : 'not loaded');
        $registersStale = count($registers) < 2 || collect($registers)->contains(static fn (mixed $date): bool => (string) $date < $staleBefore);

        return [
            $item('xendit_payments', 'Xendit payments and webhooks', $gateway === 'fake' ? 'SIMULATED' : (! $configured(config('services.xendit.secret_key')) ? 'NOT_CONFIGURED' : ($failedWebhooks > 0 || $stalledWebhooks > 0 ? 'DEGRADED' : 'HEALTHY')),
                ($gateway === 'fake' ? 'Simulated gateway; no provider calls. ' : '').$failedWebhooks.' unverified webhook(s) in 24 h; '.$stalledWebhooks.' stored but unprocessed for over 10 minutes.',
                'Xendit '.strtoupper((string) config('services.xendit.mode', 'TEST')), $lastWebhook === null ? null : CarbonImmutable::parse((string) $lastWebhook)->toIso8601String()),
            $item('xendit_accounts', 'Xendit sub-account onboarding', $providerErrors > 0 ? 'DEGRADED' : 'HEALTHY', $providerErrors.' Vendor connection(s) report a provider error code; retry from the Vendor case.', 'Xendit '.strtoupper((string) config('services.xendit.mode', 'TEST'))),
            $item('google_maps', 'Google Maps, Places and Routes', $configured(config('services.google_maps.server_api_key')) ? 'HEALTHY' : 'NOT_CONFIGURED', $configured(config('services.google_maps.server_api_key'))
                ? 'Server key configured (value hidden). Places '.(config('services.google_maps.places.enabled') ? 'enabled' : 'disabled').'.' : 'No server key configured; geocoding and routes use manual fallbacks.'),
            $item('google_oidc', 'Google sign-in', $configured(config('services.google_oidc.client_id')) ? 'HEALTHY' : 'NOT_CONFIGURED', 'Client configuration '.($configured(config('services.google_oidc.client_id')) ? 'present' : 'absent').' (values hidden).'),
            $item('email', 'Email delivery', $emailFailures > 0 ? 'DEGRADED' : 'HEALTHY', $emailFailures.' failed email deliveries in 24 h.', 'Mailer: '.self::label((string) config('mail.default'))),
            $item('push', 'Push notifications', $pushFailures > 0 ? 'DEGRADED' : 'HEALTHY', $pushFailures.' failed push deliveries in 24 h.', 'Driver: '.self::label((string) config('notifications.push_driver'))),
            $item('file_storage', 'Private file storage and scanning', $scanBacklog > 0 ? 'DEGRADED' : 'HEALTHY', $scanBacklog.' file(s) waiting for a malware scan over 1 hour; '.$quarantined.' rejected or quarantined in 24 h. Pending files never satisfy a requirement.',
                'Disk: '.self::label((string) config('filesystems.default'))),
            $item('reverb', 'Laravel Reverb realtime', config('broadcasting.default') === 'reverb' && $configured(config('broadcasting.connections.reverb.key')) ? 'HEALTHY' : 'NOT_CONFIGURED',
                'Clients fall back to REST polling whenever the realtime connection is unavailable.', 'Broadcaster: '.self::label((string) config('broadcasting.default'))),
            $item('ocr', 'OCR assistance', ! $ocrConfigured ? 'NOT_CONFIGURED' : ($ocrAvailable ? 'HEALTHY' : 'DEGRADED'),
                ! $ocrConfigured ? 'OCR is disabled. Vendors enter PS/ICC marking values manually.' : ($ocrAvailable
                    ? 'Local PS/ICC photo reading is available. Suggestions require Vendor confirmation; OCR never approves compliance.'
                    : 'The local OCR engine or English language data is unavailable. Vendors can still enter PS/ICC values manually.')),
            $item('dti_bps_registers', 'DTI-BPS PS and ICC registers', $registers->isEmpty() ? 'NOT_CONFIGURED' : ($registersStale ? 'DEGRADED' : 'HEALTHY'),
                $registerState('PS_LICENSE', 'PS licensees:').'; '.$registerState('ICC_CERTIFICATE', 'ICC certificate holders:').'. Without a current snapshot, Vendors can still request manual review.'),
        ];
    }

    /** @return array<string, mixed> */
    private function queues(): array
    {
        $backlog = DB::table('outbox_events')->whereNull('processed_at')->where('attempts', '<', OutboxProcessor::MAX_ATTEMPTS)->where('available_at', '<', now()->subMinutes(5))->count();
        $counts = self::counts();

        return ['connection' => self::label((string) config('queue.default')), 'outbox_backlog' => $backlog, 'dead_letters' => $counts['dead_letters'], 'failed_jobs' => $counts['failed_jobs'],
            'status' => $counts['dead_letters'] > 0 || $counts['failed_jobs'] > 0 ? 'DEGRADED' : ($backlog > 0 ? 'DELAYED' : 'HEALTHY')];
    }

    /** @return list<array<string, mixed>> */
    private function scheduled(): array
    {
        $latest = DB::table('scheduled_task_runs as r')->whereRaw('r.started_at = (SELECT MAX(x.started_at) FROM scheduled_task_runs x WHERE x.task = r.task)')->get()->keyBy('task');
        $tasks = [];
        foreach (self::SCHEDULE as $task => $maxAge) {
            $run = $latest->get($task);
            $age = $run === null ? null : (int) CarbonImmutable::parse((string) $run->started_at)->diffInMinutes(now());
            $status = match (true) {
                $run === null => 'NO_RUN_RECORDED',
                $run->outcome === 'FAILED' => 'FAILED',
                $age !== null && $age > $maxAge => 'OVERDUE',
                default => $run->outcome === 'RUNNING' ? 'RUNNING' : 'HEALTHY',
            };
            $tasks[] = ['task' => $task, 'status' => $status, 'last_outcome' => $run?->outcome, 'last_started_at' => $run === null ? null : CarbonImmutable::parse((string) $run->started_at)->toIso8601String(),
                'duration_ms' => $run?->duration_ms === null ? null : (int) $run->duration_ms, 'expected_within_minutes' => $maxAge];
        }

        return $tasks;
    }

    /** @return array<string, mixed> */
    private function analytics(): array
    {
        $geo = DB::table('analytics_geo_runs')->where('environment', 'TEST')->orderByDesc('created_at')->first();
        $geoPublished = DB::table('analytics_geo_runs')->where('environment', 'TEST')->where('state', 'PUBLISHED')->orderByDesc('published_at')->first();
        $demo = DB::table('analytics_geo_runs')->where('environment', 'DEMO')->where('state', 'PUBLISHED')->orderByDesc('published_at')->first();
        $today = CarbonImmutable::now('Asia/Manila');
        $snapshot = DB::table('analytics_published_runs as p')->join('analytics_refresh_runs as r', 'r.id', '=', 'p.analytics_refresh_run_id')->where('p.kind', AnalyticsDataset::KIND)
            ->where('r.environment', AnalyticsDataset::CAPTURE_ENVIRONMENT)->orderByDesc('r.snapshot_date')->first(['r.snapshot_date', 'r.published_at', 'r.revision', 'r.selected_count', 'r.selected_vendor_count']);
        $failedCaptures = DB::table('analytics_refresh_runs')->where('kind', AnalyticsDataset::KIND)->where('state', 'FAILED')->where('created_at', '>=', now()->subDays(7))->count();
        // The 00:10 Asia/Manila capture is due; until it publishes, yesterday's snapshot is stale.
        $captureDue = $today->greaterThanOrEqualTo($today->startOfDay()->addMinutes(40));
        $snapshotStale = $snapshot === null || ($captureDue && (string) $snapshot->snapshot_date < $today->toDateString());
        $version = DB::table('psgc_versions')->where('status', 'ACTIVE')->first(['id', 'version', 'effective_on', 'activated_at']);
        $boundaries = $version === null ? collect() : DB::table('psgc_boundaries as b')->join('psgc_areas as a', 'a.id', '=', 'b.psgc_area_id')->where('a.psgc_version_id', $version->id)
            ->groupBy('a.level')->selectRaw('a.level, COUNT(*) AS total')->pluck('total', 'level');

        return [
            'geo_aggregation' => ['status' => $geo === null ? 'NO_RUN_RECORDED' : ($geo->state === 'FAILED' ? 'FAILED' : ($geoPublished !== null && (string) $geoPublished->through_date < $today->subDay()->toDateString() ? 'STALE' : 'HEALTHY')),
                'last_state' => $geo?->state, 'last_published_at' => $geoPublished?->published_at === null ? null : CarbonImmutable::parse((string) $geoPublished->published_at)->toIso8601String(),
                'through_date' => $geoPublished?->through_date, 'revision' => $geoPublished === null ? null : (int) $geoPublished->revision, 'error_code' => $geo?->error_code,
                'demo_dataset' => $demo === null ? null : ['label' => 'DEMO — Simulated Marketplace Data', 'published_at' => CarbonImmutable::parse((string) $demo->published_at)->toIso8601String()]],
            'materials_snapshot' => ['status' => $snapshot === null ? 'NO_RUN_RECORDED' : ($snapshotStale ? 'STALE' : 'HEALTHY'), 'dataset' => AnalyticsDataset::active()['label'],
                'snapshot_date' => $snapshot?->snapshot_date, 'published_at' => $snapshot?->published_at === null ? null : CarbonImmutable::parse((string) $snapshot->published_at)->toIso8601String(),
                'revision' => $snapshot === null ? null : (int) $snapshot->revision, 'observations' => $snapshot === null ? null : (int) $snapshot->selected_count,
                'vendors' => $snapshot === null ? null : (int) $snapshot->selected_vendor_count, 'failed_captures_7_days' => $failedCaptures],
            'psgc' => ['status' => $version === null ? 'NOT_CONFIGURED' : 'HEALTHY', 'version' => $version?->version, 'effective_on' => $version?->effective_on,
                'activated_at' => $version?->activated_at === null ? null : CarbonImmutable::parse((string) $version->activated_at)->toIso8601String(),
                'boundaries' => $boundaries->map(static fn (mixed $total): int => (int) $total)->all(),
                'last_boundary_import' => DB::table('psgc_boundary_imports')->orderByDesc('imported_at')->value('imported_at')],
        ];
    }

    /** Masked, non-secret label for an environment or driver name. */
    private static function label(string $value): string
    {
        $value = trim($value);

        return $value === '' ? 'Not set' : strtoupper(preg_replace('/[^A-Za-z0-9_-]/', '', $value) ?? 'Set');
    }

    /** Exception class only: messages may contain identifiers, so they never leave the server. */
    private static function failureClass(string $exception): string
    {
        $first = strtok($exception, "\n") ?: '';
        $class = trim((string) preg_replace('/[:(].*$/', '', $first));

        return class_basename($class === '' ? 'Exception' : $class);
    }
}
