<?php

declare(strict_types=1);

namespace App\Domain\Messaging;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Finance\Money;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderEligibility;
use App\Models\User;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class QuotationService
{
    public const OPEN = ['PUBLISHED', 'VIEWED'];

    public function __construct(private readonly ConversationAccess $access, private readonly ConversationService $messages,
        private readonly QuotationTerms $terms, private readonly CatalogAccess $idempotency) {}

    /** @param array<string, mixed> $input */
    public function draft(Request $request, string $conversationId, array $input, int $version): void
    {
        $c = $this->access->require($request->user(), $conversationId);
        $this->access->requireSales($request->user(), $c);
        $input = $this->terms->validate($input);
        DB::transaction(function () use ($request, $conversationId, $input, $version): void {
            $c = $this->access->require($request->user(), $conversationId, true);
            $role = $this->access->requireSales($request->user(), $c);
            $q = $this->quotation($c, true);
            $this->version($q, $version);
            if ($q->state === 'ACCEPTED') {
                throw new AuthenticationException('QUOTATION_CLOSED', 'Accepted terms cannot be edited.', 409);
            }
            $old = json_decode((string) ($q->draft ?? '{}'), true);
            if ($role === 'CUSTOMER_SERVICE' && ($input['nrpc'] ?? null) !== ($old['nrpc'] ?? null)) {
                throw new AuthenticationException('PERMISSION_DENIED', 'Customer Service cannot set or change NRPC.', 403);
            }
            DB::table('quotations')->where('id', $q->id)->update(['draft' => json_encode($input, JSON_THROW_ON_ERROR), 'lock_version' => $version + 1, 'updated_at' => now()]);
            $this->event($q, $request->user(), 'DRAFT_SAVED', ['before' => $old, 'after' => $input]);
        });
    }

    public function publish(Request $request, string $conversationId, int $version): void
    {
        $c = $this->access->require($request->user(), $conversationId);
        $this->access->requireSales($request->user(), $c, true);
        $q = DB::table('quotations')->where('conversation_id', $conversationId)->first();
        if ($q === null || $q->draft === null) {
            throw new AuthenticationException('DRAFT_REQUIRED', 'Save a quotation draft before publishing.', 422);
        }
        $input = $this->terms->validate(json_decode($q->draft, true));
        $route = $this->terms->route($c, $input); // Network before locks.
        $key = $this->idempotency->requireIdempotencyKey($request);
        DB::transaction(function () use ($request, $conversationId, $version, $input, $route, $key, $c): void {
            $this->lockPackage($c);
            $org = DB::table('vendor_organizations')->where('id', $c->vendor_organization_id)->lockForUpdate()->first();
            $c = $this->access->require($request->user(), $conversationId, true);
            $role = $this->access->requireSales($request->user(), $c, true);
            if ($this->idempotency->replayed($request, 'QUOTATION_PUBLISH', $key, $conversationId)) {
                return;
            }
            $q = $this->quotation($c, true);
            $this->version($q, $version);
            if ($this->terms->validate(json_decode($q->draft, true)) !== $input) {
                throw new AuthenticationException('QUOTATION_VERSION_CONFLICT', 'The draft changed during delivery calculation. Review it and retry.', 409);
            }
            if ($q->state === 'ACCEPTED') {
                throw new AuthenticationException('QUOTATION_CLOSED', 'Accepted terms cannot be republished.', 409);
            }
            if (app(OrderEligibility::class)->storeBlockers($org) !== []) {
                throw new AuthenticationException('STORE_NOT_ELIGIBLE', 'This store cannot publish new commercial terms.', 409);
            }
            $content = $this->terms->freeze($request->user(), $c, $input, $route);
            $previous = $q->current_version_id === null ? null : DB::table('quotation_versions')->where('id', $q->current_version_id)->first();
            $before = $previous === null ? [] : json_decode($previous->content, true);
            $changes = QuotationTerms::changes($before, $content);
            $hours = (int) ($input['deadline_hours'] ?? 24);
            if ($previous !== null && (int) $previous->deadline_hours !== $hours) {
                $changes[] = ['path' => 'deadline_hours', 'before' => (int) $previous->deadline_hours, 'after' => $hours,
                    'label' => 'Buyer response window changed from '.$previous->deadline_hours.' hours to '.$hours.' hours.'];
            }
            $content['changes'] = $changes;
            $content['original_changes'] = QuotationTerms::changes(json_decode((string) $c->locked_reference, true), $content);
            $json = json_encode($content, JSON_THROW_ON_ERROR);
            $id = (string) Str::uuid7();
            $expires = CarbonImmutable::now()->addHours($hours);
            $money = $content['commercial'];
            $this->release($q, 'SUPERSEDED');
            DB::table('quotation_versions')->insert(['id' => $id, 'quotation_id' => $q->id, 'version' => $previous === null ? 1 : (int) $previous->version + 1,
                'created_by_user_id' => $request->user()->id, 'actor_role' => $role, 'published_at' => now(), 'expires_at' => $expires, 'supersedes_version_id' => $previous?->id,
                'materials_centavos' => $money['materials_payable_centavos'], 'delivery_centavos' => $money['delivery_centavos'], 'nrpc_centavos' => $money['nrpc_centavos'],
                'total_centavos' => $money['commercial_total_centavos'], 'content_hash' => hash('sha256', $json), 'content' => $json, 'deadline_hours' => $hours,
                'price_source' => 'PRIVATE_TRANSACTION', 'created_at' => now(), 'updated_at' => now()]);
            foreach ($content['lines'] as $line) {
                DB::table('quotation_lines')->insert(['id' => (string) Str::uuid7(), 'quotation_version_id' => $id, 'listing_variant_id' => $line['variant_id'],
                    'description' => $line['description'], 'unit_id' => $line['unit_id'], 'quantity' => $line['quantity'], 'unit_price_centavos' => $line['unit_price_centavos'],
                    'subtotal_centavos' => Money::lineAmount($line['quantity'], $line['unit_price_centavos']), 'source_snapshot' => json_encode($line, JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
                $inventory = DB::table('inventory_items')->where('listing_variant_id', $line['variant_id'])->first();
                if ($inventory !== null) {
                    DB::table('inventory_holds')->insert(['id' => (string) Str::uuid7(), 'inventory_item_id' => $inventory->id, 'hold_type' => 'SOFT', 'quantity' => $line['quantity'],
                        'state' => 'ACTIVE', 'source_type' => 'QUOTATION', 'source_id' => $id, 'expires_at' => $expires, 'created_at' => now(), 'updated_at' => now()]);
                }
            }
            DB::table('quotation_changes')->insert(['id' => (string) Str::uuid7(), 'quotation_id' => $q->id, 'quotation_version_id' => $id, 'actor_user_id' => $request->user()->id,
                'event_type' => 'PUBLISHED', 'payload' => json_encode(['before' => $before, 'after' => $content, 'changes' => $changes], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
            DB::table('quotations')->where('id', $q->id)->update(['current_version_id' => $id, 'state' => 'PUBLISHED', 'response_due_at' => $expires, 'reminded_at' => null, 'lock_version' => $version + 1, 'updated_at' => now()]);
            $q->current_version_id = $id;
            $this->event($q, $request->user(), 'PUBLISHED', ['before_version_id' => $previous?->id, 'after_version_id' => $id, 'expires_at' => $expires->toIso8601String(), 'content_hash' => hash('sha256', $json)]);
            $this->messages->append($c, $request->user(), 'Quotation version '.($previous === null ? 1 : (int) $previous->version + 1).' published. Review the terms and changes before accepting.');
            $this->idempotency->claim($request, 'QUOTATION_PUBLISH', $key, $conversationId, 200);
        });
    }

    /** @param array<string, mixed> $input */
    public function decide(Request $request, string $conversationId, string $action, array $input): ?string
    {
        $c = $this->access->require($request->user(), $conversationId);
        if ($c->purpose !== 'SALES') {
            throw new AuthenticationException('PERMISSION_DENIED', 'Fulfillment messages cannot change commercial terms.', 403);
        }
        if ($action === 'withdraw') {
            $this->access->requireSales($request->user(), $c, true);
        } elseif ($request->user()->account_type !== 'BUYER') {
            throw new AuthenticationException('PERMISSION_DENIED', 'Only the Buyer can decide on the quotation.', 403);
        }
        $key = $this->idempotency->requireIdempotencyKey($request);
        $result = DB::transaction(function () use ($request, $conversationId, $action, $input, $key, $c): ?string {
            $this->lockPackage($c, $action === 'accept');
            DB::table('vendor_organizations')->where('id', $c->vendor_organization_id)->lockForUpdate()->first();
            $c = $this->access->require($request->user(), $conversationId, true);
            if ($action === 'withdraw') {
                $this->access->requireSales($request->user(), $c, true);
            }
            $q = $this->quotation($c, true);
            if ($this->idempotency->replayed($request, 'QUOTATION_'.$action, $key, $conversationId)) {
                return $q->accepted_order_id;
            }
            $this->expireLocked($q);
            if ($q->state === 'EXPIRED') {
                return '!EXPIRED';
            }
            if ($q->current_version_id !== $input['version_id'] || ! in_array($q->state, self::OPEN, true)) {
                throw new AuthenticationException('QUOTATION_VERSION_CONFLICT', 'This quotation changed. Open the latest version, review its changes, and try again.', 409, ['current_version_id' => $q->current_version_id]);
            }
            if ($action === 'view') {
                if ($q->state !== 'VIEWED') {
                    $this->state($q, 'VIEWED', $q->response_due_at);
                    $this->event($q, $request->user(), 'VIEWED');
                }
            } elseif ($action === 'accept') {
                $order = app(QuotationAcceptance::class)->accept($request, $c, $q, $input);
                if ($order === null) {
                    $this->release($q, 'STOCK_REVALIDATION_REQUIRED');
                    $this->state($q, 'STOCK_REVALIDATION_REQUIRED');
                    $this->event($q, $request->user(), 'STOCK_REVALIDATION_REQUIRED');

                    return '!STOCK';
                }
                DB::table('quotations')->where('id', $q->id)->update(['accepted_order_id' => $order]);
                $this->state($q, 'ACCEPTED');
                if ($q->work_package_id !== null) {
                    DB::table('work_packages')->where('id', $q->work_package_id)->update(['selected_vendor_organization_id' => $q->vendor_organization_id, 'status' => 'VENDOR_SELECTED', 'updated_at' => now()]);
                    foreach (DB::table('quotations')->where('work_package_id', $q->work_package_id)->where('id', '<>', $q->id)->whereIn('state', [...self::OPEN, 'COUNTERED'])->orderBy('id')->lockForUpdate()->get() as $other) {
                        $this->release($other, 'WORK_PACKAGE_ASSIGNED');
                        $this->state($other, 'EXPIRED');
                        $this->systemEvent($other, 'WORK_PACKAGE_ASSIGNED');
                    }
                }
                $this->release($q, 'ACCEPTED');
                $this->event($q, $request->user(), 'ACCEPTED', ['order_id' => $order]);
                $this->messages->append($c, $request->user(), 'Quotation accepted. Continue in Order Details to review payment.');
                $this->idempotency->claim($request, 'QUOTATION_'.$action, $key, $conversationId, 200);

                return $order;
            } else {
                $state = match ($action) {
                    'counter' => 'COUNTERED', 'reject' => 'REJECTED', 'withdraw' => 'WITHDRAWN', default => throw new \LogicException('Invalid quotation action')
                };
                $due = $action === 'counter' ? CarbonImmutable::now()->addDay() : null;
                $this->state($q, $state, $due);
                $this->release($q, $state);
                if ($action === 'counter') {
                    DB::table('quotation_counter_offers')->insert(['id' => (string) Str::uuid7(), 'quotation_id' => $q->id, 'quotation_version_id' => $q->current_version_id,
                        'actor_user_id' => $request->user()->id, 'event_type' => 'COUNTERED', 'payload' => json_encode(['requested_changes' => $input['reason'], 'vendor_due_at' => $due], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
                }
                $this->event($q, $request->user(), $state, ['reason' => $input['reason'] ?? null]);
                $this->messages->append($c, $request->user(), 'Quotation '.strtolower($state).'.'.($action === 'counter' ? ' Requested changes: '.$input['reason'].'. Vendor response due within 24 hours.' : ''));
            }
            $this->idempotency->claim($request, 'QUOTATION_'.$action, $key, $conversationId, 200);

            return null;
        });
        if ($result === '!STOCK' || $result === '!EXPIRED') {
            throw new AuthenticationException($result === '!STOCK' ? 'STOCK_REVALIDATION_REQUIRED' : 'QUOTATION_EXPIRED',
                $result === '!STOCK' ? 'Stock changed. Nothing was reserved or charged. Ask the Vendor for a revised quotation.' : 'The deadline passed. Ask the Vendor for a new quotation.', 409);
        }

        return $result;
    }

    /** @return array<string, mixed> */
    public function show(Request $request, string $conversationId): array
    {
        $c = $this->access->require($request->user(), $conversationId);
        if ($c->purpose !== 'SALES') {
            return ['quotation' => null, 'versions' => [], 'has_more' => false];
        }
        $q = DB::table('quotations')->where('conversation_id', $conversationId)->first();
        if ($q === null) {
            return ['quotation' => null, 'versions' => [], 'has_more' => false];
        }
        DB::transaction(function () use (&$q): void {
            DB::table('conversations')->where('id', $q->conversation_id)->lockForUpdate()->first();
            $q = DB::table('quotations')->where('id', $q->id)->lockForUpdate()->first();
            $this->expireLocked($q);
        });
        $page = DB::table('quotation_versions')->where('quotation_id', $q->id)->orderByDesc('version')->paginate(10);
        $buyer = $request->user()->account_type === 'BUYER';
        $publish = ! $buyer && $this->access->role($request->user()) !== 'CUSTOMER_SERVICE';

        return ['quotation' => ['id' => $q->id, 'state' => $q->state, 'lock_version' => (int) $q->lock_version, 'current_version_id' => $q->current_version_id,
            'accepted_order_id' => $q->accepted_order_id, 'response_due_at' => $q->response_due_at, 'draft' => $buyer ? null : json_decode((string) ($q->draft ?? 'null'), true),
            'can_draft' => ! $buyer && $q->state !== 'ACCEPTED', 'can_publish' => $publish && $q->state !== 'ACCEPTED'],
            'versions' => array_map(function (object $v) use ($q, $buyer, $publish): array {
                $latest = $q->current_version_id === $v->id;

                return ['id' => $v->id, 'version' => (int) $v->version, 'latest' => $latest, 'state' => $latest ? $q->state : 'SUPERSEDED', 'published_at' => $v->published_at,
                    'expires_at' => $v->expires_at, 'content_hash' => $v->content_hash, 'content' => json_decode($v->content, true),
                    'viewed' => DB::table('quotation_events')->where('quotation_version_id', $v->id)->where('event_type', 'VIEWED')->exists(),
                    'actions' => $latest && in_array($q->state, self::OPEN, true) ? ($buyer ? ['view', 'accept', 'reject', 'counter'] : ($publish ? ['withdraw'] : [])) : []];
            }, $page->items()), 'has_more' => $page->hasMorePages(), 'page' => $page->currentPage()];
    }

    private function quotation(object $c, bool $create): object
    {
        $q = DB::table('quotations')->where('conversation_id', $c->id)->lockForUpdate()->first();
        if ($q === null && $create) {
            $id = (string) Str::uuid7();
            DB::table('quotations')->insert(['id' => $id, 'conversation_id' => $c->id, 'buyer_profile_id' => $c->buyer_profile_id, 'vendor_organization_id' => $c->vendor_organization_id,
                'procurement_type' => $c->context_type, 'work_package_id' => $c->context_type === 'PROJECT_BASED' ? $c->context_id : null, 'created_at' => now(), 'updated_at' => now()]);
            $q = DB::table('quotations')->where('id', $id)->first();
        }

        return $q;
    }

    private function version(object $q, int $version): void
    {
        if ((int) $q->lock_version !== $version) {
            throw new AuthenticationException('QUOTATION_VERSION_CONFLICT', 'The draft changed. Refresh and review the latest saved quotation.', 409);
        }
    }

    public function release(object $q, string $reason): void
    {
        DB::table('inventory_holds')->where('source_type', 'QUOTATION')->whereIn('source_id', DB::table('quotation_versions')->select('id')->where('quotation_id', $q->id))->where('state', 'ACTIVE')->where('hold_type', 'SOFT')
            ->update(['state' => 'RELEASED', 'released_at' => now(), 'release_reason' => $reason, 'updated_at' => now()]);
    }

    private function state(object $q, string $state, mixed $due = null): void
    {
        DB::table('quotations')->where('id', $q->id)->update(['state' => $state, 'response_due_at' => $due, 'lock_version' => DB::raw('lock_version + 1'), 'updated_at' => now()]);
        $q->state = $state;
        $q->lock_version++;
        $q->response_due_at = $due;
        $this->messages->changed((string) $q->conversation_id);
    }

    /** @param array<string, mixed> $payload */
    public function event(object $q, User $actor, string $type, array $payload = []): void
    {
        DB::table('quotation_events')->insert(['id' => (string) Str::uuid7(), 'quotation_id' => $q->id, 'quotation_version_id' => $q->current_version_id,
            'actor_user_id' => $actor->id, 'event_type' => $type, 'payload' => json_encode($payload + ['actor_role' => $this->access->role($actor), 'context_type' => $q->procurement_type,
                'conversation_id' => $q->conversation_id, 'buyer_profile_id' => $q->buyer_profile_id, 'vendor_organization_id' => $q->vendor_organization_id,
                'correlation_id' => request()->attributes->get('correlation_id')], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
        $this->messages->changed((string) $q->conversation_id);
    }

    public function expireLocked(object $q): bool
    {
        if (! in_array($q->state, [...self::OPEN, 'COUNTERED'], true) || $q->response_due_at === null || CarbonImmutable::parse($q->response_due_at)->isFuture()) {
            return false;
        }
        $this->release($q, 'EXPIRED');
        $this->state($q, 'EXPIRED');
        $this->systemEvent($q, 'EXPIRED');

        return true;
    }

    public function sweep(): int
    {
        $count = 0;
        DB::table('quotations')->whereIn('state', [...self::OPEN, 'COUNTERED'])->orderBy('id')->chunkById(100, function ($rows) use (&$count): void {
            foreach ($rows as $row) {
                DB::transaction(function () use ($row, &$count): void {
                    DB::table('conversations')->where('id', $row->conversation_id)->lockForUpdate()->first();
                    $q = DB::table('quotations')->where('id', $row->id)->lockForUpdate()->first();
                    if ($this->expireLocked($q)) {
                        $count++;
                    } elseif (in_array($q->state, self::OPEN, true) && $q->reminded_at === null) {
                        $v = DB::table('quotation_versions')->where('id', $q->current_version_id)->first();
                        $reminder = CarbonImmutable::parse($v->expires_at)->subMinutes((int) $v->deadline_hours >= 8 ? 240 : 30);
                        if ($reminder->lessThanOrEqualTo(CarbonImmutable::now())) {
                            DB::table('quotations')->where('id', $q->id)->update(['reminded_at' => now()]);
                            $this->systemEvent($q, 'REMINDER');
                        }
                    }
                });
            }
        });

        return $count;
    }

    private function systemEvent(object $q, string $type): void
    {
        $v = DB::table('quotation_versions')->where('id', $q->current_version_id)->first();
        // The scheduler is explicitly attributed as SYSTEM; creator is only the required FK provenance.
        DB::table('quotation_events')->insert(['id' => (string) Str::uuid7(), 'quotation_id' => $q->id, 'quotation_version_id' => $q->current_version_id,
            'actor_user_id' => $v->created_by_user_id, 'event_type' => $type, 'payload' => json_encode(['actor_role' => 'SYSTEM', 'response_due_at' => $q->response_due_at], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
        $this->messages->changed((string) $q->conversation_id);
        $c = DB::table('conversations')->where('id', $q->conversation_id)->first();
        $body = match ($type) {
            'REMINDER' => 'Quotation deadline approaching. Review the latest version before its displayed deadline.',
            'WORK_PACKAGE_ASSIGNED' => 'Another quotation was accepted for this Work Package. This quotation expired; conversation history remains available.',
            default => 'The quotation response deadline passed. Its soft stock hold was released. Request a new version to continue.',
        };
        $this->messages->append($c, User::findOrFail($v->created_by_user_id), $body);
    }

    private function lockPackage(object $c, bool $requireUnassigned = true): void
    {
        if ($c->context_type !== 'PROJECT_BASED') {
            return;
        }
        $package = DB::table('work_packages')->where('id', $c->context_id)->lockForUpdate()->first();
        DB::table('conversations')->where('context_type', 'PROJECT_BASED')->where('context_id', $c->context_id)->orderBy('id')->lockForUpdate()->get(['id']);
        $owned = $package !== null && DB::table('projects')->where('id', $package->project_id)->where('buyer_profile_id', $c->buyer_profile_id)->exists();
        if (! $owned || ($requireUnassigned && $package->selected_vendor_organization_id !== null && ! DB::table('quotations')->where('conversation_id', $c->id)->whereNotNull('accepted_order_id')->exists())) {
            throw new AuthenticationException('WORK_PACKAGE_ALREADY_ASSIGNED', 'This Work Package is unavailable or already assigned. Its quotation history remains readable.', 409);
        }
    }
}
