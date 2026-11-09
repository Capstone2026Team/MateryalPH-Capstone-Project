<?php

declare(strict_types=1);

namespace App\Domain\Messaging;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Catalog\CatalogAccess;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Models\User;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/** Static text and explicit button selections only. Never interprets a Buyer's message. */
final class AutomatedResponseService
{
    private function organization(Request $request): string
    {
        $scope = app(AccountAccess::class)->resolve($request->user());
        if ($request->user()->account_type !== 'VENDOR' || ! in_array($scope['role'], ['OWNER', 'STORE_MANAGER'], true)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'Only the Owner or Store Manager may configure automated responses.', 403);
        }

        return (string) $scope['organization_id'];
    }

    /** @return array<string, mixed> */
    public function settings(Request $request): array
    {
        $row = DB::table('vendor_automated_responses')->where('vendor_organization_id', $this->organization($request))->first();

        return ['enabled' => (bool) ($row->enabled ?? false), 'welcome_message' => $row->welcome_message ?? '',
            'options' => json_decode($row->options ?? '[]', true), 'lock_version' => (int) ($row->lock_version ?? 0)];
    }

    /** @param array<string, mixed> $input */
    public function save(Request $request, array $input): void
    {
        $org = $this->organization($request);
        $keys = app(CatalogAccess::class);
        $key = $keys->requireIdempotencyKey($request);
        DB::transaction(function () use ($request, $input, $org, $keys, $key): void {
            DB::table('vendor_organizations')->where('id', $org)->lockForUpdate()->first();
            if ($keys->replayed($request, 'AUTOMATED_RESPONSE_SETTINGS', $key, $org)) {
                return;
            }
            $old = DB::table('vendor_automated_responses')->where('vendor_organization_id', $org)->first();
            if ((int) ($old->lock_version ?? 0) !== $input['lock_version']) {
                throw new AuthenticationException('AUTOMATED_RESPONSE_VERSION_CONFLICT', 'These settings changed. Reopen settings to review the latest saved version.', 409);
            }
            DB::table('vendor_automated_responses')->updateOrInsert(['vendor_organization_id' => $org], [
                'enabled' => $input['enabled'], 'welcome_message' => trim($input['welcome_message'] ?? ''),
                'options' => json_encode($input['options'], JSON_THROW_ON_ERROR), 'lock_version' => $input['lock_version'] + 1,
                'created_at' => $old->created_at ?? now(), 'updated_at' => now(),
            ]);
            app(AuditRecorder::class)->account($request, 'AUTOMATED_RESPONSE_SETTINGS_SAVED', 'VENDOR', $org,
                after: ['enabled' => $input['enabled'], 'option_count' => count($input['options']), 'lock_version' => $input['lock_version'] + 1]);
            $keys->claim($request, 'AUTOMATED_RESPONSE_SETTINGS', $key, $org, 200);
        });
    }

    /** Caller holds the conversation lock; bot messages never call this hook. */
    public function humanMessage(object $c, User $actor): void
    {
        // Every sender locks their own context before this shared pair row. Never lock sibling contexts here.
        $state = $this->state($c);
        if ($actor->account_type === 'VENDOR') {
            DB::table('conversations')->where('id', $c->id)->update(['automated_sequence_active' => false, 'needs_human_response' => false]);
            $this->stateQuery($c)->update(['sequence_active' => false, 'updated_at' => now()]);

            return;
        }
        if ($actor->account_type !== 'BUYER') {
            return;
        }
        DB::table('conversations')->where('id', $c->id)->update(['needs_human_response' => true]);
        $settings = DB::table('vendor_automated_responses')->where('vendor_organization_id', $c->vendor_organization_id)->first();
        if ($settings === null || ! $settings->enabled || ($state->last_automated_response_at !== null && Carbon::parse($state->last_automated_response_at)->greaterThan(now()->subHours(24)))) {
            return;
        }
        $welcome = $this->post($c, $settings->welcome_message, json_decode($settings->options, true));
        DB::table('conversations')->where('id', $c->id)->update(['last_automated_response_at' => now(), 'automated_welcome_id' => $welcome, 'automated_sequence_active' => true]);
        $this->stateQuery($c)->update(['last_automated_response_at' => now(), 'active_welcome_message_id' => $welcome, 'sequence_active' => true, 'updated_at' => now()]);
    }

    private function stateQuery(object $c): Builder
    {
        return DB::table('buyer_thread_automation_states')->where('buyer_profile_id', $c->buyer_profile_id)->where('vendor_organization_id', $c->vendor_organization_id);
    }

    private function state(object $c): object
    {
        DB::table('buyer_thread_automation_states')->insertOrIgnore(['buyer_profile_id' => $c->buyer_profile_id, 'vendor_organization_id' => $c->vendor_organization_id,
            'sequence_active' => false, 'created_at' => now(), 'updated_at' => now()]);

        return $this->stateQuery($c)->lockForUpdate()->firstOrFail();
    }

    /** @param list<array<string, string>> $options */
    private function post(object $c, string $text, array $options = []): string
    {
        // SYSTEM excludes automated text from human reply/CRR and team-performance calculations.
        $name = DB::table('store_profiles')->where('vendor_organization_id', $c->vendor_organization_id)->value('public_store_name') ?: 'Store';
        $owner = DB::table('vendor_memberships')->where('vendor_organization_id', $c->vendor_organization_id)->where('role', 'OWNER')->value('user_id');
        $id = app(ConversationService::class)->append($c, User::query()->findOrFail($owner), $text,
            automation: ['store_name' => $name, 'options' => $options]);

        return $id;
    }

    public function choose(Request $request, string $id, string $welcomeId, int $index, string $clientId): string
    {
        return DB::transaction(function () use ($request, $id, $welcomeId, $index, $clientId): string {
            $c = app(ConversationAccess::class)->require($request->user(), $id, true);
            if ($request->user()->account_type !== 'BUYER') {
                throw new AuthenticationException('PERMISSION_DENIED', 'Only the Buyer may choose an automated reply option.', 403);
            }
            $welcome = DB::table('messages')->where('id', $welcomeId)->where('conversation_id', $id)->first();
            $option = json_decode($welcome->automation ?? '{}', true)['options'][$index] ?? null;
            if ($option === null) {
                throw new AuthenticationException('AUTOMATED_OPTION_UNAVAILABLE', 'This response option is unavailable.', 409);
            }
            $old = DB::table('messages')->where('conversation_id', $id)->where('client_message_id', $clientId)->first();
            if ($old !== null) {
                $selection = DB::table('conversation_automated_selections')->where('buyer_message_id', $old->id)->first();
                if ((int) $old->sender_user_id !== (int) $request->user()->id || $selection?->welcome_message_id !== $welcomeId || (int) $selection->option_index !== $index) {
                    throw new AuthenticationException('IDEMPOTENCY_CONFLICT', 'Use a new message identifier for a different choice.', 409);
                }

                return (string) $old->id;
            }
            app(ConversationService::class)->requireCurrent($c);
            FulfillmentThreadService::requireWritable($c);
            $enabled = DB::table('vendor_automated_responses')->where('vendor_organization_id', $c->vendor_organization_id)->where('enabled', true)->exists();
            $state = $this->state($c);
            if (! $enabled || ! $state->sequence_active || $state->active_welcome_message_id !== $welcomeId || DB::table('conversation_automated_selections')->where('welcome_message_id', $welcomeId)->where('option_index', $index)->exists()) {
                throw new AuthenticationException('AUTOMATED_OPTION_UNAVAILABLE', 'The store has taken over or this option was already used. You can continue messaging normally.', 409);
            }
            $message = app(ConversationService::class)->append($c, $request->user(), $option['label'], 'TEXT', $clientId, triggerAutomation: false);
            DB::table('conversation_automated_selections')->insert(['id' => (string) Str::uuid7(), 'conversation_id' => $id, 'welcome_message_id' => $welcomeId,
                'option_index' => $index, 'buyer_message_id' => $message, 'created_at' => now(), 'updated_at' => now()]);
            $this->post($c, $option['response']);
            DB::table('conversations')->where('id', $id)->update(['needs_human_response' => true]);

            return $message;
        });
    }
}
