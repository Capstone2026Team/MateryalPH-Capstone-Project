<?php

declare(strict_types=1);

namespace App\Domain\Authorization;

use App\Domain\Identity\AuthenticationException;
use App\Support\PortalDateRange;
use Carbon\CarbonInterface;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;

final class VendorTeamActivityQuery
{
    public const ROLES = ['OWNER', 'STORE_MANAGER', 'STORE_STAFF', 'CUSTOMER_SERVICE', 'INVENTORY', 'FULFILLMENT'];

    public const CATEGORIES = ['SALES', 'INVENTORY', 'FULFILLMENT', 'DISPUTES', 'TEAM', 'OTHER'];

    // Classify recorded operations, never infer sales ownership from inventory or delivery work.
    private const CATEGORY_SQL = <<<'SQL'
CASE
 WHEN a.action ~ '^(ORDER_FULFILLMENT_|ORDER_MILESTONE_|ORDER_VEHICLE_|FULFILLMENT_|DELIVERY_)' THEN 'FULFILLMENT'
 WHEN a.action ~ '^(CATALOG_|INVENTORY_|AUTO_ACCEPT_|COMPLIANCE_|PRODUCT_COMPLIANCE_)' THEN 'INVENTORY'
 WHEN a.resource_type ~ '(DISPUTE|APPEAL|INVOICE)' THEN 'DISPUTES'
 WHEN a.resource_type ~ '(CONVERSATION|MESSAGE|QUOTATION|ORDER)' THEN 'SALES'
 WHEN a.action ~ '^VENDOR_(STAFF_|MEMBERSHIP_|INVITATION_)' THEN 'TEAM'
 ELSE 'OTHER'
END
SQL;

    /**
     * Team Tracking needs staff-management authority: the Owner, or a Manager with delegation enabled.
     *
     * @return array<string, mixed>
     */
    public function scope(Request $request, AccountAccess $access): array
    {
        $scope = $access->resolve($request->user());
        if (! in_array('staff.manage', $scope['permissions'], true)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'You cannot view team activity.', 403);
        }

        return $scope;
    }

    /**
     * A member the viewer may monitor. Other organizations' members, and managers for a delegated Manager, are
     * indistinguishable from missing ones.
     *
     * @param  array<string, mixed>  $scope
     */
    public function member(array $scope, string $memberId): object
    {
        $member = DB::table('vendor_memberships')->where('id', $memberId)->where('vendor_organization_id', $scope['organization_id'])->first();
        if ($member === null || ($scope['role'] !== 'OWNER' && in_array($member->role, ['OWNER', 'STORE_MANAGER'], true))) {
            throw new AuthenticationException('RESOURCE_NOT_FOUND', 'This team member is unavailable.', 404);
        }

        return $member;
    }

    /**
     * Audit, Vendor message and quotation records of the viewer's organization as one source aliased `a`. Delegated
     * Managers see only actions taken under the four non-manager roles.
     *
     * @param  array<string, mixed>  $scope
     */
    public function events(array $scope, ?CarbonInterface $since = null): Builder
    {
        $audit = DB::table('audit_logs')->where('vendor_organization_id', $scope['organization_id'])->when($since !== null, fn ($q) => $q->where('created_at', '>=', $since))
            ->select(['id', 'actor_user_id', 'actor_role', 'action', 'resource_type', 'resource_id', 'created_at', 'succeeded', 'before', 'after', 'correlation_id']);
        // Existing immutable histories supply attribution only, never message bodies or quotation prices.
        $messages = DB::table('messages as m')->join('conversations as c', 'c.id', '=', 'm.conversation_id')
            ->where('c.vendor_organization_id', $scope['organization_id'])->when($since !== null, fn ($q) => $q->where('m.sent_at', '>=', $since))
            ->where('m.kind', '!=', 'SYSTEM')->whereIn(DB::raw("m.public_sender->>'role'"), self::ROLES)
            ->selectRaw("m.id, m.sender_user_id as actor_user_id, m.public_sender->>'role' as actor_role, CASE WHEN c.purpose = 'FULFILLMENT' THEN 'FULFILLMENT_MESSAGE_SENT' ELSE 'MESSAGE_SENT' END as action, 'CONVERSATION' as resource_type, c.id as resource_id, m.sent_at as created_at, true as succeeded, '{}'::jsonb as before, '{}'::jsonb as after, null::text as correlation_id");
        $quotations = DB::table('quotation_events as e')->join('quotations as q', 'q.id', '=', 'e.quotation_id')
            ->where('q.vendor_organization_id', $scope['organization_id'])->when($since !== null, fn ($q) => $q->where('e.created_at', '>=', $since))
            ->whereIn(DB::raw("e.payload->>'actor_role'"), self::ROLES)
            ->selectRaw("e.id, e.actor_user_id, e.payload->>'actor_role' as actor_role, CASE WHEN e.event_type LIKE 'QUOTATION_%' THEN e.event_type ELSE 'QUOTATION_' || e.event_type END as action, 'QUOTATION' as resource_type, q.id as resource_id, e.created_at, true as succeeded, '{}'::jsonb as before, '{}'::jsonb as after, e.payload->>'correlation_id' as correlation_id");
        $query = DB::query()->fromSub($audit->unionAll($messages)->unionAll($quotations), 'a');
        if ($scope['role'] !== 'OWNER') {
            $query->whereIn('a.actor_role', ['STORE_STAFF', 'CUSTOMER_SERVICE', 'INVENTORY', 'FULFILLMENT']);
        }

        return $query;
    }

    /** @return array{data: array<int, array<string, mixed>>, meta: array<string, mixed>} */
    public function read(Request $request, AccountAccess $access): array
    {
        $scope = $this->scope($request, $access);
        $input = $request->validate([
            'page' => ['sometimes', 'integer', 'min:1'],
            'member_id' => ['sometimes', 'uuid'],
            'role' => ['sometimes', Rule::in(self::ROLES)],
            'days' => ['sometimes', 'integer', Rule::in([7, 30, 90])],
            'category' => ['sometimes', Rule::in(self::CATEGORIES)],
        ] + PortalDateRange::rules($request));
        $since = isset($input['days']) && ! isset($input['from']) && ! isset($input['to']) ? now('Asia/Manila')->startOfDay()->subDays((int) $input['days'] - 1)->setTimezone('UTC') : null;
        $query = $this->events($scope, $since)->leftJoin('users as u', 'u.id', '=', 'a.actor_user_id');
        if (isset($input['member_id'])) {
            $query->where('a.actor_user_id', $this->member($scope, (string) $input['member_id'])->user_id);
        }
        if (isset($input['role'])) {
            $query->where('a.actor_role', $input['role']);
        }
        PortalDateRange::apply($query, 'a.created_at', $input);
        $groups = (clone $query)->selectRaw(self::CATEGORY_SQL.' as category, count(*) as total, count(*) filter (where a.succeeded) as succeeded')
            ->groupByRaw(self::CATEGORY_SQL)->get();
        $total = (int) $groups->sum('total');
        $succeeded = (int) $groups->sum('succeeded');
        if (isset($input['category'])) {
            $query->whereRaw('('.self::CATEGORY_SQL.') = ?', [$input['category']]);
        }
        $rows = $query->select(['a.id', 'u.name as actor_name', 'a.actor_role', 'a.action', 'a.resource_type', 'a.resource_id', 'a.created_at', 'a.succeeded', 'a.before', 'a.after', 'a.correlation_id'])
            ->selectRaw(self::CATEGORY_SQL.' as category')->orderByDesc('a.created_at')->orderByDesc('a.id')->paginate(20);
        $safeFields = array_flip(['role', 'status', 'can_manage_staff', 'enabled', 'name_changed', 'milestone', 'proof']);
        $items = collect($rows->items())->map(function (object $row) use ($safeFields): array {
            $row->before = (object) array_intersect_key(json_decode($row->before ?? '{}', true, flags: JSON_THROW_ON_ERROR), $safeFields);
            $row->after = (object) array_intersect_key(json_decode($row->after ?? '{}', true, flags: JSON_THROW_ON_ERROR), $safeFields);

            return (array) $row;
        })->all();

        return ['data' => $items, 'meta' => [
            'current_page' => $rows->currentPage(), 'last_page' => $rows->lastPage(), 'total' => $rows->total(),
            'total_events' => $total, 'succeeded_events' => $succeeded, 'failed_events' => $total - $succeeded,
            'categories' => array_map(fn (string $category): array => ['category' => $category, 'count' => (int) ($groups->firstWhere('category', $category)->total ?? 0)], self::CATEGORIES),
        ]];
    }
}
