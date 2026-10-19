<?php

declare(strict_types=1);

namespace App\Domain\Support;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Notifications\NotificationService;
use App\Domain\Operations\AdminAccess;
use App\Models\User;
use App\Support\PortalDateRange;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class SupportService
{
    public function __construct(private readonly SupportAccess $access, private readonly SupportCommands $commands, private readonly SupportFiles $files, private readonly AuditRecorder $audit) {}

    /** @param array<string, mixed> $input
     * @return array<string, mixed>
     */
    public function submit(Request $request, array $input): array
    {
        $guest = $request->attributes->get('support_portal') === 'guest';
        $user = $guest ? null : $request->user();
        $name = $user === null ? $input['full_name'] : (DB::table('user_profiles')->where('user_id', $user->getKey())->value('full_name') ?? $user->name);
        $email = mb_strtolower(trim((string) ($user === null ? $input['email'] : $user->email)));
        $id = (string) Str::uuid7();

        return $this->withFiles($request, $id, $input, function (array $fileIds, array $fingerprint) use ($request, $input, $user, $name, $email, $id): array {
            $used = false;
            try {
                return $this->commands->run($request, 'create|'.($user?->getKey() ?? $email), $fingerprint, function () use ($request, $input, $user, $name, $email, $id, $fileIds, &$used): array {
                    DB::table('support_tickets')->insert(['id' => $id, 'ticket_number' => 'SUP-'.strtoupper(bin2hex(random_bytes(8))),
                        'user_id' => $user?->getKey(), 'full_name' => $this->text((string) $name), 'email' => $email,
                        'user_type' => $user->account_type ?? $input['user_type'], 'category' => $input['category'], 'subject' => $this->text($input['subject']),
                        'reference_type' => $input['reference_type'] ?? null, 'reference' => isset($input['reference']) ? $this->text($input['reference']) : null,
                        'privacy_acknowledged_at' => now(), 'status' => 'OPEN', 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);
                    $ticket = DB::table('support_tickets')->where('id', $id)->first();
                    $entryId = $this->entry($request, $ticket, 'MESSAGE', $input['message'], [], $fileIds);
                    $this->audit->account($request, 'SUPPORT_CREATED', 'SUPPORT_TICKET', $id);
                    $this->notifyAdmins($ticket, $entryId);
                    app(SupportGuestAccess::class)->sendLink($ticket);
                    $used = true;

                    return ['id' => $id, 'ticket_number' => $ticket->ticket_number, 'status' => 'OPEN'];
                });
            } finally {
                if (! $used) {
                    $this->files->discard($fileIds);
                }
            }
        });
    }

    /** @param array<string, mixed> $input
     * @return array<string, mixed>
     */
    public function reply(Request $request, string $id, array $input): array
    {
        $this->access->ticket($request, $id, true);

        return $this->withFiles($request, $id, $input, function (array $fileIds, array $fingerprint) use ($request, $id, $input): array {
            $used = false;
            try {
                return $this->commands->run($request, 'reply|'.$id.'|'.($request->user()?->getKey() ?? 'guest'), $fingerprint, function () use ($request, $id, $input, $fileIds, &$used): array {
                    $this->access->ticket($request, $id, true);
                    $ticket = DB::table('support_tickets')->where('id', $id)->lockForUpdate()->first();
                    if ($ticket->status === 'CLOSED') {
                        throw new AuthenticationException('SUPPORT_CLOSED', 'This request is closed. An administrator must reopen it before another reply.', 409);
                    }
                    $entryId = $this->entry($request, $ticket, 'MESSAGE', $input['message'], [], $fileIds);
                    $admin = $request->attributes->get('support_portal') === 'admin';
                    $status = ! $admin && in_array($ticket->status, ['WAITING_FOR_USER', 'RESOLVED'], true) ? 'OPEN' : $ticket->status;
                    if ($status !== $ticket->status) {
                        $this->entry($request, $ticket, 'STATUS_CHANGED', 'Reopened by a user follow-up.', ['from_status' => $ticket->status, 'to_status' => $status]);
                    }
                    DB::table('support_tickets')->where('id', $id)->update(['status' => $status, 'lock_version' => (int) $ticket->lock_version + 1, 'updated_at' => now()]);
                    $this->audit->account($request, 'SUPPORT_REPLIED', 'SUPPORT_TICKET', $id, [], ['entry_id' => $entryId]);
                    if ($admin) {
                        $this->notifyUser($ticket, $entryId);
                    } else {
                        $this->notifyAdmins($ticket, $entryId);
                    }
                    $used = true;

                    return ['id' => $entryId];
                });
            } finally {
                if (! $used) {
                    $this->files->discard($fileIds);
                }
            }
        });
    }

    /** @param array<string, mixed> $input
     * @return array<string, mixed>
     */
    public function update(Request $request, string $id, array $input): array
    {
        app(AdminAccess::class)->require($request, 'support.view', 'support.manage');
        $this->access->ticket($request, $id, true);

        return $this->commands->run($request, 'update|'.$id.'|'.$request->user()->getKey(), $input, function () use ($request, $id, $input): array {
            $ticket = DB::table('support_tickets')->where('id', $id)->lockForUpdate()->first();
            if ((int) $ticket->lock_version !== (int) $input['lock_version']) {
                throw new AuthenticationException('SUPPORT_VERSION_CONFLICT', 'This request changed. Reload it before updating.', 409);
            }
            $reason = AdminAccess::reason($input['reason'], 3);
            $changes = [];
            if (isset($input['status']) && $input['status'] !== $ticket->status) {
                $changes['status'] = $input['status'];
                $this->entry($request, $ticket, 'STATUS_CHANGED', $reason, ['from_status' => $ticket->status, 'to_status' => $input['status']]);
            }
            if (array_key_exists('assigned_admin_id', $input)) {
                $handler = $input['assigned_admin_id'] === null ? null : User::query()->where('public_id', $input['assigned_admin_id'])->first();
                if ($input['assigned_admin_id'] !== null && (! $handler instanceof User || $handler->account_type !== 'ADMIN' || ! $this->access->allows($handler, $id)
                    || ! app(AccountAccess::class)->allows($handler, 'support.manage'))) {
                    throw new AuthenticationException('SUPPORT_HANDLER_INVALID', 'Choose an active support administrator.', 422);
                }
                if ($ticket->assigned_admin_id !== $handler?->getKey()) {
                    $changes['assigned_admin_id'] = $handler?->getKey();
                    $this->entry($request, $ticket, 'ASSIGNED', $reason, ['previous_handler' => $this->actorName($ticket->assigned_admin_id), 'new_handler' => $handler === null ? 'Unassigned' : $this->actorName($handler->getKey())]);
                }
            }
            if ($changes !== []) {
                DB::table('support_tickets')->where('id', $id)->update($changes + ['lock_version' => (int) $ticket->lock_version + 1, 'updated_at' => now()]);
                $this->audit->account($request, 'SUPPORT_UPDATED', 'SUPPORT_TICKET', $id, ['status' => $ticket->status, 'assigned_admin_id' => $ticket->assigned_admin_id], $changes, reason: $reason);
                if (isset($changes['status'])) {
                    $this->notifyUser($ticket, (string) Str::uuid7());
                }
            }

            return ['id' => $id];
        });
    }

    /** @param array<string, mixed> $filters
     * @return array{items: list<array<string, mixed>>, next_cursor: ?string}
     */
    public function list(Request $request, array $filters): array
    {
        $admin = $request->attributes->get('support_portal') === 'admin';
        if ($admin) {
            app(AdminAccess::class)->require($request, 'support.view');
        }
        $query = DB::table('support_tickets')->orderByDesc('id');
        if (! $admin) {
            $query->where('user_id', $request->user()->getKey());
        }
        foreach (['category', 'user_type', 'status'] as $key) {
            if (isset($filters[$key])) {
                $query->where($key, $filters[$key]);
            }
        }
        if (! empty($filters['cursor'])) {
            $query->where('id', '<', $filters['cursor']);
        }
        if (! empty($filters['q'])) {
            $q = '%'.addcslashes($filters['q'], '%_\\').'%';
            $query->where(fn ($query) => $query->where('ticket_number', 'ilike', $q)->orWhere('full_name', 'ilike', $q)->orWhere('email', 'ilike', $q)->orWhere('subject', 'ilike', $q));
        }
        PortalDateRange::apply($query, 'created_at', $filters);
        $rows = $query->limit(26)->get();
        $items = $rows->take(25);

        return ['items' => $items->map(fn ($ticket) => $this->present($ticket))->all(), 'next_cursor' => $rows->count() > 25 ? $items->last()->id : null];
    }

    /** @return array<string, mixed> */
    public function detail(Request $request, string $id): array
    {
        $ticket = $this->access->ticket($request, $id);
        if ($request->attributes->get('support_portal') === 'admin') {
            $this->audit->account($request, 'SUPPORT_VIEWED', 'SUPPORT_TICKET', $id);
        }

        return $this->present($ticket);
    }

    /** @return array{items: list<array<string, mixed>>, next_cursor: ?string} */
    public function entries(Request $request, string $id, ?string $cursor): array
    {
        $this->access->ticket($request, $id);
        $rows = DB::table('support_entries')->where('ticket_id', $id)->when($cursor, fn ($q) => $q->where('id', '<', $cursor))->orderByDesc('id')->limit(51)->get();
        $items = $rows->take(50)->reverse()->values()->map(function ($row): array {
            $attachments = DB::table('support_attachments as a')->join('files as f', 'f.id', '=', 'a.file_id')->where('a.entry_id', $row->id)->get(['f.id', 'f.original_name', 'f.content_type', 'f.byte_size'])->map(fn ($file) => (array) $file)->all();

            return ['id' => $row->id, 'kind' => $row->kind, 'actor_name' => $row->actor_name, 'actor_role' => $row->actor_role, 'body' => $row->body,
                'details' => (object) json_decode((string) $row->details, true), 'created_at' => CarbonImmutable::parse($row->created_at)->toIso8601String(), 'attachments' => $attachments];
        })->all();

        return ['items' => $items, 'next_cursor' => $rows->count() > 50 ? $rows[49]->id : null];
    }

    /** @return array{items: list<array<string, mixed>>, next_cursor: ?string} */
    public function handlers(Request $request, ?string $cursor): array
    {
        app(AdminAccess::class)->require($request, 'support.view');
        $query = DB::table('users as u')->join('admin_memberships as m', 'm.user_id', '=', 'u.id')->join('role_permissions as rp', 'rp.platform_role_id', '=', 'm.platform_role_id')
            ->join('permissions as p', 'p.id', '=', 'rp.permission_id')->where('p.code', 'support.manage')->where('u.account_type', 'ADMIN')->where('u.account_status', 'ACTIVE')->where('m.status', 'ACTIVE')
            ->when($cursor, fn ($q) => $q->where('u.public_id', '>', $cursor))->orderBy('u.public_id')->limit(51)->get(['u.public_id', 'u.id']);

        return ['items' => $query->take(50)->map(fn ($user) => ['id' => $user->public_id, 'name' => $this->actorName($user->id)])->all(), 'next_cursor' => $query->count() > 50 ? $query[49]->public_id : null];
    }

    /** @return array<string, mixed> */
    private function present(object $ticket): array
    {
        return ['id' => $ticket->id, 'ticket_number' => $ticket->ticket_number, 'full_name' => $ticket->full_name, 'email' => $ticket->email,
            'user_type' => $ticket->user_type, 'category' => $ticket->category, 'subject' => $ticket->subject, 'reference_type' => $ticket->reference_type, 'reference' => $ticket->reference,
            'status' => $ticket->status, 'assigned_admin_id' => $ticket->assigned_admin_id === null ? null : DB::table('users')->where('id', $ticket->assigned_admin_id)->value('public_id'),
            'assigned_admin_name' => $ticket->assigned_admin_id === null ? null : $this->actorName($ticket->assigned_admin_id),
            'lock_version' => (int) $ticket->lock_version, 'created_at' => CarbonImmutable::parse($ticket->created_at)->toIso8601String(), 'updated_at' => CarbonImmutable::parse($ticket->updated_at)->toIso8601String()];
    }

    /** @param array<string, mixed> $details
     * @param  list<string>  $fileIds
     */
    private function entry(Request $request, object $ticket, string $kind, string $body, array $details = [], array $fileIds = []): string
    {
        $id = (string) Str::uuid7();
        $guest = $request->attributes->get('support_portal') === 'guest';
        $userId = $guest ? null : $request->user()?->getKey();
        DB::table('support_entries')->insert(['id' => $id, 'ticket_id' => $ticket->id, 'kind' => $kind, 'actor_user_id' => $userId,
            'actor_name' => $userId === null ? $ticket->full_name : $this->actorName($userId), 'actor_role' => $guest ? 'GUEST' : ($request->attributes->get('account_scope')['role'] ?? $request->user()?->account_type),
            'body' => $this->text($body), 'details' => json_encode((object) $details, JSON_THROW_ON_ERROR), 'correlation_id' => AdminAccess::correlation($request), 'created_at' => now()]);
        foreach ($fileIds as $fileId) {
            DB::table('support_attachments')->insert(['id' => (string) Str::uuid7(), 'entry_id' => $id, 'file_id' => $fileId, 'created_at' => now()]);
        }

        return $id;
    }

    private function actorName(?int $userId): string
    {
        return $userId === null ? 'Unassigned' : (string) (DB::table('user_profiles')->where('user_id', $userId)->value('full_name') ?? DB::table('users')->where('id', $userId)->value('name') ?? 'MateryalPH user');
    }

    private function notifyAdmins(object $ticket, string $eventId): void
    {
        foreach (User::query()->where('account_type', 'ADMIN')->where('account_status', 'ACTIVE')->lazyById(100) as $user) {
            if ($this->access->allows($user, $ticket->id)) {
                app(NotificationService::class)->record((int) $user->getKey(), 'SUPPORT', 'Support request update', 'Review support ticket '.$ticket->ticket_number.'.', 'SUPPORT_TICKET', $ticket->id, 'support|'.$eventId);
            }
        }
    }

    private function notifyUser(object $ticket, string $eventId): void
    {
        if ($ticket->user_id === null) {
            app(SupportGuestAccess::class)->sendLink($ticket);
        } else {
            app(NotificationService::class)->record((int) $ticket->user_id, 'SUPPORT', 'Support request update', 'There is an update to support ticket '.$ticket->ticket_number.'.', 'SUPPORT_TICKET', $ticket->id, 'support|'.$eventId);
        }
    }

    private function text(string $value): string
    {
        $text = trim(preg_replace('/[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]/u', '', strip_tags($value)) ?? '');
        if ($text === '') {
            throw new AuthenticationException('VALIDATION_FAILED', 'Enter meaningful text for the support request.', 422);
        }

        return $text;
    }

    /** Scanning/storage happen before any ticket/command row is locked.
     * @param  array<string, mixed>  $input
     * @param  callable(list<string>, array<string, mixed>): array<string, mixed>  $operation
     * @return array<string, mixed>
     */
    private function withFiles(Request $request, string $ticketId, array $input, callable $operation): array
    {
        $stored = [];
        $fingerprint = $input;
        unset($fingerprint['files']);
        $fingerprint['file_hashes'] = [];
        try {
            /** @var UploadedFile $upload */
            foreach ($request->file('files', []) as $upload) {
                $fingerprint['file_hashes'][] = ['sha256' => hash_file('sha256', (string) $upload->getRealPath()), 'name' => $upload->getClientOriginalName(), 'mime' => $upload->getClientMimeType(), 'size' => $upload->getSize()];
                $stored[] = $this->files->store($upload, $ticketId, $request->attributes->get('support_portal') === 'guest' ? null : $request->user()?->getKey());
            }

            return $operation($stored, $fingerprint);
        } catch (\Throwable $exception) {
            $this->files->discard($stored);
            throw $exception;
        }
    }
}
