<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Finance\FinanceNotifier;
use App\Domain\Notifications\NotificationDelivery;
use App\Domain\Notifications\NotificationPolicy;
use App\Domain\Notifications\NotificationService;
use App\Domain\Notifications\OnboardingNotices;
use App\Domain\Notifications\PushGateway;
use App\Domain\Operations\OutboxProcessor;
use App\Domain\Operations\OutboxPublisher;
use App\Infrastructure\Notifications\FakePushGateway;
use App\Mail\FinanceNoticeMail;
use App\Models\AdminInvitation;
use App\Models\User;
use App\Models\VendorOrganization;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Queue;
use Illuminate\Support\Str;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\TestCase;

final class PhaseFifteenNotificationsTest extends TestCase
{
    use CreatesDiscoveryFixtures;
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SystemFoundationSeeder::class);
        Queue::fake();
        Mail::fake();
        $this->app->instance(PushGateway::class, new FakePushGateway);
    }

    private function notice(User $user, string $category = 'SECURITY'): string
    {
        return app(NotificationService::class)->record((int) $user->id, $category, 'Account update', 'Open your account to review the update.', 'ACCOUNT', $user->public_id, 'stable-event-'.$category);
    }

    public function test_deduplication_authoritative_storage_and_current_authenticated_deep_link(): void
    {
        $user = $this->buyer();
        $id = $this->notice($user);
        self::assertSame($id, $this->notice($user));
        self::assertSame(1, DB::table('notifications')->count());
        app(NotificationService::class)->enqueue($id);
        app(NotificationService::class)->enqueue($id);
        self::assertSame(1, DB::table('notification_deliveries')->count());
        $this->signInBuyer($user);
        $this->getJson('/api/v1/buyers/notifications')->assertOk()->assertJsonPath('data.0.id', $id);
        $this->postJson('/api/v1/buyers/notifications/'.$id.'/resolve')->assertOk()->assertJsonPath('data.path', '/settings');
        $other = $this->buyer();
        $this->signInBuyer($other);
        $this->postJson('/api/v1/buyers/notifications/'.$id.'/resolve')->assertForbidden();
    }

    public function test_optional_channel_is_skipped_but_mandatory_preference_is_rejected(): void
    {
        $user = $this->buyer();
        $this->signInBuyer($user);
        $this->putJson('/api/v1/buyers/notifications/preferences', ['category' => 'MARKETING', 'in_app' => false, 'email' => false, 'push' => false])->assertOk();
        $id = $this->notice($user, 'MARKETING');
        app(NotificationService::class)->enqueue($id);
        app(NotificationDelivery::class)->send(DB::table('notification_deliveries')->where('notification_id', $id)->value('id'));
        Mail::assertNothingSent();
        self::assertSame('SKIPPED', DB::table('notification_deliveries')->value('state'));
        $this->putJson('/api/v1/buyers/notifications/preferences', ['category' => 'FINANCE_MANDATORY', 'in_app' => true, 'email' => false, 'push' => true])->assertUnprocessable()->assertJsonPath('errors.0.code', 'MANDATORY_NOTIFICATION');
    }

    public function test_device_registration_is_private_and_revoked_device_does_not_receive_queued_push(): void
    {
        $user = $this->buyer();
        $this->signInBuyer($user);
        $token = 'synthetic-device-registration-fixture';
        $response = $this->postJson('/api/v1/buyers/notifications/devices', ['platform' => 'ANDROID', 'token' => $token])->assertCreated();
        self::assertStringNotContainsString($token, $response->getContent());
        self::assertStringNotContainsString($token, json_encode(DB::table('notification_devices')->first()));
        $id = $this->notice($user);
        app(NotificationService::class)->enqueue($id);
        $this->deleteJson('/api/v1/buyers/notifications/devices/'.$response->json('data.id'))->assertOk();
        $delivery = DB::table('notification_deliveries')->where('channel', 'PUSH')->value('id');
        app(NotificationDelivery::class)->send($delivery);
        self::assertSame('REVOKED', DB::table('notification_deliveries')->where('id', $delivery)->value('state'));
        self::assertSame(0, app(PushGateway::class)->sent);
    }

    public function test_bounded_retry_does_not_remove_notice_or_log_provider_details(): void
    {
        $user = $this->buyer();
        $id = $this->notice($user);
        $deviceId = (string) Str::uuid7();
        DB::table('notification_devices')->insert(['id' => $deviceId, 'user_id' => $user->id, 'platform' => 'ANDROID', 'environment' => 'testing', 'token_hash' => hash('sha256', $deviceId), 'sealed_token' => Crypt::encryptString('synthetic-device-registration-fixture'), 'last_seen_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        app(NotificationService::class)->enqueue($id);
        $delivery = DB::table('notification_deliveries')->where('channel', 'PUSH')->value('id');
        app(PushGateway::class)->fail = true;
        for ($i = 0; $i < 6; $i++) {
            try {
                app(NotificationDelivery::class)->send($delivery);
            } catch (\RuntimeException) {
            }
        }
        self::assertSame('FAILED', DB::table('notification_deliveries')->where('id', $delivery)->value('state'));
        self::assertSame(5, DB::table('notification_delivery_attempts')->count());
        self::assertSame(1, DB::table('notifications')->count());
        self::assertStringNotContainsString('synthetic-device', json_encode(DB::table('notification_delivery_attempts')->get()));
    }

    public function test_finance_recipient_is_exact_owner_and_revocation_blocks_queued_delivery(): void
    {
        $owner = User::factory()->create(['account_type' => 'VENDOR', 'account_status' => 'ACTIVE']);
        $manager = User::factory()->create(['account_type' => 'VENDOR', 'account_status' => 'ACTIVE']);
        $org = VendorOrganization::query()->create(['legal_name' => 'Sample legal entity', 'store_name' => 'Sample store', 'account_status' => 'ACTIVE']);
        foreach ([[$owner, 'OWNER'], [$manager, 'STORE_MANAGER']] as [$user, $role]) {
            DB::table('vendor_memberships')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $org->id, 'user_id' => $user->id, 'role' => $role, 'status' => 'ACTIVE', 'created_at' => now(), 'updated_at' => now()]);
        }
        app(FinanceNotifier::class)->owner($org->id, 'Threshold changed', 'Review your withholding status.', true, 'WITHHOLDING_ACCUMULATOR', (string) Str::uuid7());
        self::assertSame([(int) $owner->id], DB::table('notifications')->pluck('user_id')->all());
        $notice = DB::table('notifications')->first();
        app(NotificationService::class)->enqueue($notice->id, 'FINANCE_NOTICE');
        $preview = (new FinanceNoticeMail($notice->title, $notice->body))->with('noticeUrl', 'https://vendor.example.test/notifications?notice='.$notice->id)->render();
        self::assertStringContainsString('/notifications?notice='.$notice->id, $preview);
        self::assertStringNotContainsString('token=', $preview);
        DB::table('vendor_memberships')->where('user_id', $owner->id)->update(['status' => 'SUSPENDED']);
        app(NotificationDelivery::class)->send(DB::table('notification_deliveries')->value('id'));
        Mail::assertNothingSent();
        self::assertFalse(app(NotificationPolicy::class)->allows($owner, $notice));
    }

    public function test_expired_and_reused_invitation_jobs_do_not_send(): void
    {
        foreach (['expired', 'accepted'] as $kind) {
            $invitation = AdminInvitation::query()->create(['normalized_email' => 'invitee@example.test', 'platform_role_id' => DB::table('platform_roles')->where('code', 'ADMIN_SUPERADMIN')->value('id'),
                'token_hash' => hash('sha256', $kind), 'expires_at' => $kind === 'expired' ? now()->subMinute() : now()->addDay(), 'accepted_at' => $kind === 'accepted' ? now() : null, 'bootstrap' => true]);
            $event = app(OutboxPublisher::class)->publish('ADMIN_BOOTSTRAP_INVITATION_REQUESTED', 'ADMIN_INVITATION', $invitation->id, ['recipient' => 'invitee@example.test', 'invitation_url' => 'https://admin.example.test/accept-invite']);
            app(OutboxProcessor::class)->process($event);
        }
        Mail::assertNothingSent();
    }

    public function test_onboarding_notices_deduplicate_redact_and_resume_the_affected_requirement(): void
    {
        [$store, $owner] = $this->activeStore('Onboarding notices', false);
        $notices = app(OnboardingNotices::class);
        foreach (range(1, 2) as $_) {
            $notices->fromAudit('stable-setup-event', 'VENDOR_SETUP_INVALIDATED', 'VENDOR_ORGANIZATION', $store->id, $store->id, ['requirement' => 'delivery_configuration', 'private_evidence' => 'SECRET_FIXTURE', 'provider_payload' => 'SECRET_FIXTURE']);
        }
        $notice = DB::table('notifications')->sole();
        self::assertSame('/onboarding/setup?step=S2', app(NotificationPolicy::class)->target($owner, $notice));
        self::assertStringNotContainsString('SECRET_FIXTURE', json_encode($notice));
        $notices->fromAudit('stable-authority-event', 'VENDOR_ACTIVATION_BLOCKED', 'VENDOR_ORGANIZATION', $store->id, $store->id, ['blockers' => [['key' => 'authority_to_act']]]);
        $authority = DB::table('notifications')->where('resume_key', 'authority_to_act')->sole();
        self::assertSame('/onboarding/verification?requirement=authority_to_act', app(NotificationPolicy::class)->target($owner, $authority));
    }
}
