<?php

declare(strict_types=1);

namespace App\Domain\Operations;

use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use Carbon\CarbonImmutable;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Searchable view of the append-only audit log (Admin Workflow §13). The list is a safe projection: actor, role at the
 * time, action, resource, organization, result, reason and correlation ID — never before/after payloads. Opening the
 * redacted before/after detail needs audit.view_sensitive and is itself audited. There is no edit or delete path:
 * the table's trigger rejects both, and corrections are new compensating events.
 */
final class AuditSearchService
{
    public const PAGE_SIZE = 50;

    /** Keys whose values never leave the server, even in the sensitive detail. */
    private const REDACTED_KEYS = ['password', 'token', 'secret', 'otp', 'code_hash', 'recovery', 'tin', 'tin_last4', 'taxpayer_key', 'email', 'phone', 'mobile', 'latitude', 'longitude',
        'coordinates', 'location', 'geography', 'address', 'street', 'account_number', 'provider_account_id', 'invitation_url', 'checkout_url', 'url', 'signature', 'ip_address', 'identity_id_number', 'sealed'];

    public function __construct(private readonly AdminAccess $access, private readonly AuditRecorder $audit) {}

    /**
     * @param  array<string, mixed>  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function search(Request $request, array $filters): array
    {
        $actor = $this->access->require($request, 'audit.view');
        $query = $this->filtered($filters);
        $cursor = self::decodeCursor($filters['cursor'] ?? null);
        if ($cursor !== null) {
            $query->where(fn (Builder $q) => $q->where('a.created_at', '<', $cursor['at'])->orWhere(fn (Builder $same) => $same->where('a.created_at', $cursor['at'])->where('a.id', '<', $cursor['id'])));
        }
        $rows = $query->orderByDesc('a.created_at')->orderByDesc('a.id')->limit(self::PAGE_SIZE + 1)->get();
        $more = $rows->count() > self::PAGE_SIZE;
        $rows = $rows->take(self::PAGE_SIZE);
        $last = $rows->last();

        return ['items' => $rows->map(fn (object $row): array => self::present($row))->values()->all(),
            'meta' => ['next_cursor' => $more && $last !== null ? self::encodeCursor((string) $last->created_at, (string) $last->id) : null, 'page_size' => self::PAGE_SIZE,
                'can_view_detail' => in_array('audit.view_sensitive', $actor['permissions'], true), 'can_export' => in_array('audit.export', $actor['permissions'], true)]];
    }

    /** @return array<string, mixed> */
    public function detail(Request $request, string $auditId): array
    {
        $this->access->require($request, 'audit.view', 'audit.view_sensitive');
        $row = Str::isUuid($auditId) ? $this->base()->where('a.id', $auditId)->first() : null;
        if ($row === null) {
            throw new AuthenticationException('AUDIT_EVENT_NOT_FOUND', 'This audit event is unavailable.', 404);
        }
        // Access to sensitive audit details is itself an audit event (Admin Workflow §13).
        $this->audit->account($request, 'AUDIT_DETAIL_VIEWED', 'AUDIT_LOG', $auditId, after: ['action' => $row->action]);

        return self::present($row) + ['before' => self::redact(json_decode((string) ($row->before ?? 'null'), true)), 'after' => self::redact(json_decode((string) ($row->after ?? 'null'), true)),
            'redaction_note' => 'Credentials, tokens, contact details, tax identifiers, coordinates and URLs are redacted.'];
    }

    /**
     * Rows for an authorized export (safe projection only, at most 5,000 events).
     *
     * @param  array<string, mixed>  $filters
     * @return list<list<string|null>>
     */
    public function exportRows(array $filters): array
    {
        $rows = $this->filtered($filters)->orderByDesc('a.created_at')->orderByDesc('a.id')->limit(5001)->get();
        if ($rows->count() > 5000) {
            throw new AuthenticationException('EXPORT_TOO_LARGE', 'Narrow the audit filters to 5,000 events or fewer and try again.', 422);
        }
        $out = [['Recorded (Asia/Manila)', 'Actor', 'Role', 'Action', 'Resource type', 'Resource ID', 'Organization', 'Result', 'Reason', 'Correlation ID']];
        foreach ($rows as $row) {
            $item = self::present($row);
            $out[] = [CarbonImmutable::parse((string) $item['created_at'])->setTimezone('Asia/Manila')->format('Y-m-d H:i:s'), $item['actor'], $item['actor_role'], $item['action'],
                $item['resource_type'], $item['resource_id'], $item['organization'], $item['succeeded'] ? 'Succeeded' : 'Failed', $item['reason'], $item['correlation_id']];
        }

        return $out;
    }

    /** @return list<string> distinct values for the filter controls */
    public function facets(Request $request): array
    {
        $this->access->require($request, 'audit.view');

        return DB::table('audit_logs')->select('action')->distinct()->orderBy('action')->limit(500)->pluck('action')->map(static fn (mixed $value): string => (string) $value)->all();
    }

    /** @param array<string, mixed> $filters */
    private function filtered(array $filters): Builder
    {
        $query = $this->base();
        if (! empty($filters['actor'])) {
            $actor = trim((string) $filters['actor']);
            $query->where(fn (Builder $q) => $q->whereRaw('LOWER(u.email) = ?', [mb_strtolower($actor)])->orWhereRaw('u.name ILIKE ?', ['%'.addcslashes($actor, '%_\\').'%']));
        }
        foreach (['actor_role' => 'a.actor_role', 'resource_type' => 'a.resource_type'] as $key => $column) {
            if (! empty($filters[$key])) {
                $query->where($column, (string) $filters[$key]);
            }
        }
        if (! empty($filters['action'])) {
            $query->where('a.action', 'like', addcslashes(strtoupper((string) $filters['action']), '%_\\').'%');
        }
        if (! empty($filters['resource_id']) && Str::isUuid((string) $filters['resource_id'])) {
            $query->where('a.resource_id', (string) $filters['resource_id']);
        }
        if (! empty($filters['organization_id']) && Str::isUuid((string) $filters['organization_id'])) {
            $organization = (string) $filters['organization_id'];
            $query->where(fn (Builder $q) => $q->where('a.vendor_organization_id', $organization)->orWhere(fn (Builder $r) => $r->where('a.resource_type', 'VENDOR_ORGANIZATION')->where('a.resource_id', $organization)));
        }
        if (isset($filters['result']) && in_array($filters['result'], ['SUCCEEDED', 'FAILED'], true)) {
            $query->where('a.succeeded', $filters['result'] === 'SUCCEEDED');
        }
        if (! empty($filters['correlation_id'])) {
            $query->where('a.correlation_id', (string) $filters['correlation_id']);
        }
        if (! empty($filters['reason']) && mb_strlen(trim((string) $filters['reason'])) >= 3) {
            $query->whereRaw('a.reason ILIKE ?', ['%'.addcslashes(trim((string) $filters['reason']), '%_\\').'%']);
        }
        if (! empty($filters['from'])) {
            $query->where('a.created_at', '>=', CarbonImmutable::parse((string) $filters['from'], 'Asia/Manila')->startOfDay()->setTimezone('UTC'));
        }
        if (! empty($filters['to'])) {
            $query->where('a.created_at', '<', CarbonImmutable::parse((string) $filters['to'], 'Asia/Manila')->addDay()->startOfDay()->setTimezone('UTC'));
        }

        return $query;
    }

    private function base(): Builder
    {
        return DB::table('audit_logs as a')->leftJoin('users as u', 'u.id', '=', 'a.actor_user_id')->leftJoin('vendor_organizations as o', 'o.id', '=', 'a.vendor_organization_id')
            ->select(['a.*', 'u.name as actor_name', 'u.account_type as actor_account_type', 'u.public_id as actor_public_id', 'o.store_name as organization_name']);
    }

    /** @return array<string, mixed> */
    private static function present(object $row): array
    {
        // Admin staff are named for attribution; Buyer and Vendor actors are referenced pseudonymously.
        $actor = match (true) {
            $row->actor_user_id === null => 'System',
            $row->actor_account_type === 'ADMIN' => (string) $row->actor_name,
            default => ucfirst(strtolower((string) $row->actor_account_type)).' …'.substr(str_replace('-', '', (string) $row->actor_public_id), -6),
        };

        return ['id' => (string) $row->id, 'created_at' => CarbonImmutable::parse((string) $row->created_at)->toIso8601String(), 'actor' => $actor, 'actor_role' => $row->actor_role,
            'action' => (string) $row->action, 'resource_type' => (string) $row->resource_type, 'resource_id' => $row->resource_id, 'organization' => $row->organization_name,
            'organization_id' => $row->vendor_organization_id, 'succeeded' => (bool) $row->succeeded, 'reason' => $row->reason, 'correlation_id' => (string) $row->correlation_id,
            'has_detail' => ($row->before !== null && $row->before !== '[]') || ($row->after !== null && $row->after !== '[]')];
    }

    private static function redact(mixed $value, int $depth = 0): mixed
    {
        if (! is_array($value) || $depth > 6) {
            return is_string($value) && preg_match('/^https?:\/\//i', $value) === 1 ? '[redacted]' : $value;
        }
        $out = [];
        foreach ($value as $key => $item) {
            $lower = strtolower((string) $key);
            $sensitive = false;
            foreach (self::REDACTED_KEYS as $needle) {
                if (str_contains($lower, $needle)) {
                    $sensitive = true;
                    break;
                }
            }
            $out[$key] = $sensitive ? '[redacted]' : self::redact($item, $depth + 1);
        }

        return $out;
    }

    private static function encodeCursor(string $createdAt, string $id): string
    {
        return rtrim(strtr(base64_encode(json_encode(['at' => CarbonImmutable::parse($createdAt)->format('Y-m-d\TH:i:s.uP'), 'id' => $id], JSON_THROW_ON_ERROR)), '+/', '-_'), '=');
    }

    /** @return array{at: string, id: string}|null */
    private static function decodeCursor(mixed $cursor): ?array
    {
        if (! is_string($cursor) || $cursor === '') {
            return null;
        }
        $decoded = json_decode((string) base64_decode(strtr($cursor, '-_', '+/'), true), true);
        if (! is_array($decoded) || ! is_string($decoded['at'] ?? null) || ! is_string($decoded['id'] ?? null) || ! Str::isUuid($decoded['id'])) {
            throw new AuthenticationException('CURSOR_INVALID', 'The page cursor is invalid. Start the search again.', 422);
        }

        return ['at' => $decoded['at'], 'id' => $decoded['id']];
    }
}
