<?php

declare(strict_types=1);

namespace App\Domain\Privacy;

use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Notifications\NotificationService;
use App\Domain\Operations\AdminAccess;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Privacy Request Management (Admin Workflow §16). A Super Admin (privacy.manage) records a request received through
 * an official channel, assigns a handler and sees every request; User Management Staff (privacy.handle) see only the
 * requests assigned to them, and only the identity fields needed to act. Identity evidence is sighted and its method
 * recorded — never uploaded or stored here. RECEIVED → IDENTITY_VERIFIED → IN_PROGRESS → COMPLETED, or REJECTED /
 * WITHDRAWN with a reason. Each step needs the current lock_version, writes an append-only event and an audit event,
 * and closed requests are final. This module tracks the handling; it does not itself erase or export data.
 */
final class PrivacyRequestService
{
    public const TYPES = ['ACCESS', 'CORRECTION', 'OBJECTION', 'DELETION', 'RESTRICTION', 'PORTABILITY', 'OTHER'];

    public const CHANNELS = ['DPO_EMAIL', 'SUPPORT_CASE', 'WRITTEN_LETTER', 'IN_APP'];

    public const VERIFICATION_METHODS = ['REGISTERED_EMAIL_CONFIRMATION', 'SIGNED_IN_ACCOUNT_CONFIRMATION', 'GOVERNMENT_ID_SIGHTED', 'AUTHORIZED_REPRESENTATIVE_DOCUMENT_SIGHTED'];

    private const PER_PAGE = 25;

    public function __construct(private readonly AdminAccess $access, private readonly AuditRecorder $audit, private readonly NotificationService $notifications) {}

    /**
     * @param  array<string, mixed>  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function queue(Request $request, array $filters): array
    {
        $actor = $this->viewer($request);
        $manage = in_array('privacy.manage', $actor['permissions'], true);
        $query = DB::table('privacy_requests as p')->join('users as s', 's.id', '=', 'p.user_id')->leftJoin('users as h', 'h.id', '=', 'p.handler_user_id')
            ->when(! $manage, fn ($q) => $q->where('p.handler_user_id', $actor['user_id']))
            ->when($filters['state'] ?? null, fn ($q, string $state) => $q->where('p.state', $state))
            ->when($filters['request_type'] ?? null, fn ($q, string $type) => $q->where('p.request_type', $type))
            ->when($manage && ($filters['handler'] ?? null) === 'UNASSIGNED', fn ($q) => $q->whereNull('p.handler_user_id'));
        $total = (clone $query)->count();
        $page = max(1, min(1000, (int) ($filters['page'] ?? 1)));
        $rows = $query->orderByRaw("CASE WHEN p.state IN ('COMPLETED','REJECTED','WITHDRAWN') THEN 1 ELSE 0 END")->orderBy('p.received_at')->orderBy('p.id')
            ->offset(($page - 1) * self::PER_PAGE)->limit(self::PER_PAGE)->get(['p.*', 's.name as subject_name', 's.public_id', 's.account_type', 'h.name as handler_name']);

        return ['items' => $rows->map(fn (object $row): array => $this->summary($row))->all(),
            'meta' => ['page' => $page, 'per_page' => self::PER_PAGE, 'total' => $total, 'has_more' => $page * self::PER_PAGE < $total, 'scope' => $manage ? 'ALL' : 'ASSIGNED']];
    }

    /** @return array<string, mixed> */
    public function detail(Request $request, string $id): array
    {
        $actor = $this->viewer($request);
        $row = $this->authorized($actor, $id);
        $this->audit->account($request, 'PRIVACY_REQUEST_VIEWED', 'PRIVACY_REQUEST', $id, after: ['state' => $row->state]);

        return $this->summary($row) + [
            'scope' => $row->scope, 'response_summary' => $row->response_summary, 'legal_exception' => $row->retention_exception,
            'identity_verification_method' => $row->identity_verification_method, 'identity_verified_at' => self::iso($row->identity_verified_at),
            'subject_masked_email' => self::mask((string) $row->subject_email), 'completed_at' => self::iso($row->completed_at),
            'events' => DB::table('privacy_request_events as e')->join('users as u', 'u.id', '=', 'e.actor_user_id')->where('e.privacy_request_id', $id)->orderBy('e.occurred_at')->orderBy('e.id')
                ->get(['e.event', 'e.from_state', 'e.to_state', 'e.note', 'e.actor_role', 'e.correlation_id', 'e.occurred_at', 'u.name as actor_name'])
                ->map(static fn (object $event): array => ['event' => (string) $event->event, 'from_state' => $event->from_state, 'to_state' => (string) $event->to_state, 'note' => (string) $event->note,
                    'actor' => (string) $event->actor_name, 'actor_role' => (string) $event->actor_role, 'correlation_id' => (string) $event->correlation_id,
                    'occurred_at' => CarbonImmutable::parse((string) $event->occurred_at)->toIso8601String()])->all(),
            'allowed_actions' => $this->allowedActions($row, $actor),
            'handlers' => in_array('privacy.manage', $actor['permissions'], true) ? $this->handlers() : [],
        ];
    }

    /**
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function create(Request $request, array $input): array
    {
        $actor = $this->access->require($request, 'privacy.manage');
        $subject = DB::table('users')->whereRaw('LOWER(email) = ?', [mb_strtolower(trim((string) $input['subject_email']))])->whereIn('account_type', ['BUYER', 'VENDOR'])->first(['id', 'account_type']);
        if ($subject === null) {
            throw new AuthenticationException('PRIVACY_SUBJECT_NOT_FOUND', 'No Buyer or Vendor account uses that exact email address.', 422, ['fields' => ['subject_email' => ['Enter the account email exactly.']]]);
        }
        $received = CarbonImmutable::parse((string) $input['received_on'], 'Asia/Manila')->startOfDay();
        if ($received->isFuture()) {
            throw new AuthenticationException('VALIDATION_FAILED', 'The received date cannot be in the future.', 422, ['fields' => ['received_on' => ['Use today or an earlier date.']]]);
        }
        $note = AdminAccess::reason($input['note'] ?? null, 3);
        $correlation = AdminAccess::correlation($request);
        $id = DB::transaction(function () use ($subject, $input, $received, $actor, $note, $correlation): string {
            $id = (string) Str::uuid7();
            $reference = 'PR-'.$received->format('Y').'-'.strtoupper(substr(str_replace('-', '', (string) Str::uuid7()), -6));
            DB::table('privacy_requests')->insert(['id' => $id, 'user_id' => $subject->id, 'request_type' => $input['request_type'], 'state' => 'RECEIVED', 'reference' => $reference,
                'subject_account_type' => $subject->account_type, 'intake_channel' => $input['intake_channel'], 'received_at' => $received->setTimezone('UTC'),
                'scope' => mb_substr(trim((string) $input['scope']), 0, 4000), 'recorded_by_user_id' => $actor['user_id'], 'created_at' => now(), 'updated_at' => now()]);
            $this->event($id, 'RECEIVED', null, 'RECEIVED', $note, $actor, $correlation);

            return $id;
        });
        $this->audit->account($request, 'PRIVACY_REQUEST_RECORDED', 'PRIVACY_REQUEST', $id, [], ['request_type' => $input['request_type'], 'intake_channel' => $input['intake_channel']]);
        $this->notifications->record((int) $subject->id, 'LEGAL', 'Privacy request received', 'Your '.strtolower((string) $input['request_type']).' request was recorded. We will verify your identity before acting on it.',
            'ACCOUNT', (string) DB::table('users')->where('id', $subject->id)->value('public_id'), 'privacy-request:'.$id.':received');

        return $this->detail($request, $id);
    }

    /**
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function transition(Request $request, string $id, string $command, array $input): array
    {
        $actor = $this->viewer($request);
        $note = AdminAccess::reason($input['note'] ?? null, $command === 'complete' ? 10 : 3);
        $correlation = AdminAccess::correlation($request);
        $result = DB::transaction(function () use ($actor, $id, $command, $input, $note, $correlation): array {
            $row = DB::table('privacy_requests')->where('id', Str::isUuid($id) ? $id : '00000000-0000-0000-0000-000000000000')->lockForUpdate()->first();
            if ($row === null || ! $this->canSee($actor, $row)) {
                throw new AuthenticationException('PRIVACY_REQUEST_NOT_FOUND', 'This privacy request is unavailable.', 404);
            }
            if ((int) ($input['lock_version'] ?? 0) !== (int) $row->lock_version) {
                throw new AuthenticationException('PRIVACY_REQUEST_VERSION_CONFLICT', 'This request changed after you opened it. Refresh to review the current state.', 409);
            }
            if (! in_array(strtoupper($command), $this->allowedActions($row, $actor), true)) {
                throw new AuthenticationException('PRIVACY_TRANSITION_NOT_ALLOWED', 'This step is not available for the request\'s current state or your role.', 409);
            }
            $update = ['lock_version' => (int) $row->lock_version + 1, 'updated_at' => now()];
            [$event, $to] = match ($command) {
                'assign' => ['ASSIGNED', (string) $row->state],
                'verify' => ['IDENTITY_VERIFIED', 'IDENTITY_VERIFIED'],
                'start' => ['IN_PROGRESS', 'IN_PROGRESS'],
                'complete' => ['COMPLETED', 'COMPLETED'],
                'reject' => ['REJECTED', 'REJECTED'],
                default => ['WITHDRAWN', 'WITHDRAWN'],
            };
            if ($command === 'assign') {
                $handler = (int) ($input['handler_user_id'] ?? 0);
                if (! collect($this->handlers())->contains(fn (array $candidate): bool => $candidate['user_id'] === $handler)) {
                    throw new AuthenticationException('VALIDATION_FAILED', 'Choose an active Admin who can handle privacy requests.', 422, ['fields' => ['handler_user_id' => ['Choose an eligible handler.']]]);
                }
                $update += ['handler_user_id' => $handler, 'assigned_at' => now(), 'target_date' => $input['target_date'] ?? $row->target_date];
            }
            if ($command === 'verify') {
                if (! in_array($input['verification_method'] ?? null, self::VERIFICATION_METHODS, true)) {
                    throw new AuthenticationException('VALIDATION_FAILED', 'Choose how the requester\'s identity was verified.', 422, ['fields' => ['verification_method' => ['Choose a verification method.']]]);
                }
                $update += ['identity_verification_method' => $input['verification_method'], 'identity_verified_at' => now(), 'identity_verified_by_user_id' => $actor['user_id']];
            }
            if (in_array($command, ['complete', 'reject', 'withdraw'], true)) {
                $update += ['completed_at' => now(), 'response_summary' => mb_substr($note, 0, 4000), 'retention_exception' => trim((string) ($input['legal_exception'] ?? '')) ?: $row->retention_exception];
            }
            DB::table('privacy_requests')->where('id', $row->id)->update($update + ['state' => $to]);
            $this->event((string) $row->id, $event, (string) $row->state, $to, $note, $actor, $correlation);

            return ['row' => $row, 'to' => $to, 'event' => $event];
        });
        $row = $result['row'];
        $this->audit->account($request, 'PRIVACY_REQUEST_'.$result['event'], 'PRIVACY_REQUEST', $id, ['state' => $row->state], ['state' => $result['to']], reason: $note);
        if ($command === 'assign') {
            $this->notifications->record((int) $input['handler_user_id'], 'ADMIN_OPERATIONS', 'Privacy request assigned', 'Privacy request '.$row->reference.' was assigned to you.', 'PRIVACY_REQUEST', $id, 'privacy-assigned:'.$id.':'.$input['handler_user_id']);
        }
        if (in_array($command, ['complete', 'reject', 'withdraw'], true)) {
            $this->notifications->record((int) $row->user_id, 'LEGAL', 'Privacy request '.strtolower($result['to']), 'Your privacy request '.$row->reference.' was '.strtolower($result['to']).'. '.$note,
                'ACCOUNT', (string) DB::table('users')->where('id', $row->user_id)->value('public_id'), 'privacy-request:'.$id.':'.$result['to']);
        }

        return $this->detail($request, $id);
    }

    /** @return array<string, int> */
    public static function counts(): array
    {
        return ['open' => DB::table('privacy_requests')->whereNotIn('state', ['COMPLETED', 'REJECTED', 'WITHDRAWN'])->count(),
            'unassigned' => DB::table('privacy_requests')->whereNotIn('state', ['COMPLETED', 'REJECTED', 'WITHDRAWN'])->whereNull('handler_user_id')->count()];
    }

    /** @return array{user_id: int, role: string, permissions: list<string>} */
    private function viewer(Request $request): array
    {
        $actor = $this->access->actor($request);
        if (! in_array('privacy.manage', $actor['permissions'], true) && ! in_array('privacy.handle', $actor['permissions'], true)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'Privacy requests are not available to your Admin role.', 403);
        }

        return $actor;
    }

    /** @param array{user_id: int, role: string, permissions: list<string>} $actor */
    private function canSee(array $actor, object $row): bool
    {
        return in_array('privacy.manage', $actor['permissions'], true) || (int) $row->handler_user_id === $actor['user_id'];
    }

    /** @param array{user_id: int, role: string, permissions: list<string>} $actor */
    private function authorized(array $actor, string $id): object
    {
        $row = Str::isUuid($id) ? DB::table('privacy_requests as p')->join('users as s', 's.id', '=', 'p.user_id')->leftJoin('users as h', 'h.id', '=', 'p.handler_user_id')->where('p.id', $id)
            ->first(['p.*', 's.name as subject_name', 's.email as subject_email', 's.public_id', 's.account_type', 'h.name as handler_name']) : null;
        // A non-assigned handler receives the same response as a missing request.
        if ($row === null || ! $this->canSee($actor, $row)) {
            throw new AuthenticationException('PRIVACY_REQUEST_NOT_FOUND', 'This privacy request is unavailable.', 404);
        }

        return $row;
    }

    /**
     * @param  array{user_id: int, role: string, permissions: list<string>}  $actor
     * @return list<string>
     */
    private function allowedActions(object $row, array $actor): array
    {
        $manage = in_array('privacy.manage', $actor['permissions'], true);
        $handler = (int) $row->handler_user_id === $actor['user_id'];
        $actions = [];
        if ($manage && in_array($row->state, ['RECEIVED', 'IDENTITY_VERIFIED', 'IN_PROGRESS'], true)) {
            $actions[] = 'ASSIGN';
        }
        if (! $manage && ! $handler) {
            return $actions;
        }

        return [...$actions, ...match ($row->state) {
            'RECEIVED' => ['VERIFY', 'REJECT', 'WITHDRAW'],
            'IDENTITY_VERIFIED' => ['START', 'REJECT', 'WITHDRAW'],
            'IN_PROGRESS' => ['COMPLETE', 'REJECT', 'WITHDRAW'],
            default => [],
        }];
    }

    /** @return list<array{user_id: int, name: string, role: string}> */
    private function handlers(): array
    {
        return DB::table('admin_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->join('platform_roles as r', 'r.id', '=', 'm.platform_role_id')
            ->join('role_permissions as rp', 'rp.platform_role_id', '=', 'r.id')->join('permissions as p', 'p.id', '=', 'rp.permission_id')
            ->where('p.code', 'privacy.handle')->where('m.status', 'ACTIVE')->where('u.account_status', 'ACTIVE')->orderBy('u.name')->get(['u.id', 'u.name', 'r.name as role'])
            ->map(static fn (object $row): array => ['user_id' => (int) $row->id, 'name' => (string) $row->name, 'role' => (string) $row->role])->all();
    }

    /** @return array<string, mixed> */
    private function summary(object $row): array
    {
        $parts = preg_split('/\s+/', trim((string) $row->subject_name)) ?: [];

        return ['id' => (string) $row->id, 'reference' => (string) $row->reference, 'request_type' => (string) $row->request_type, 'state' => (string) $row->state,
            'subject_account_type' => (string) ($row->subject_account_type ?? $row->account_type), 'subject_display' => trim(($parts[0] ?? 'Account').' '.(count($parts) > 1 ? mb_substr((string) end($parts), 0, 1).'.' : ''))
                .' · …'.substr(str_replace('-', '', (string) $row->public_id), -6),
            'intake_channel' => $row->intake_channel, 'received_at' => self::iso($row->received_at), 'target_date' => $row->target_date, 'handler' => $row->handler_name,
            'handler_user_id' => $row->handler_user_id === null ? null : (int) $row->handler_user_id, 'identity_verified' => $row->identity_verified_at !== null,
            'lock_version' => (int) $row->lock_version, 'created_at' => self::iso($row->created_at)];
    }

    /** @param array{user_id: int, role: string, permissions: list<string>} $actor */
    private function event(string $id, string $event, ?string $from, string $to, string $note, array $actor, string $correlation): void
    {
        DB::table('privacy_request_events')->insert(['id' => (string) Str::uuid7(), 'privacy_request_id' => $id, 'event' => $event, 'from_state' => $from, 'to_state' => $to,
            'note' => mb_substr($note, 0, 2000), 'actor_user_id' => $actor['user_id'], 'actor_role' => $actor['role'], 'correlation_id' => $correlation, 'occurred_at' => now()]);
    }

    private static function mask(string $email): string
    {
        [$local, $domain] = array_pad(explode('@', $email, 2), 2, '');

        return mb_substr($local, 0, 1).'•••@'.$domain;
    }

    private static function iso(mixed $value): ?string
    {
        return $value === null ? null : CarbonImmutable::parse((string) $value)->toIso8601String();
    }
}
