<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\TokenSessionService;
use App\Domain\Notifications\MailProvider;
use App\Domain\Notifications\NotificationPolicy;
use App\Domain\Operations\OutboxProcessor;
use App\Domain\Support\SupportGuestAccess;
use App\Domain\Vendors\VendorFileScanner;
use App\Mail\SupportAccessMail;
use App\Mail\SupportNoticeMail;
use App\Models\AuthSession;
use App\Models\User;
use App\Models\VendorMembership;
use App\Models\VendorOrganization;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Database\QueryException;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Mail\Mailable;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Queue;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Laravel\Passport\AccessToken;
use PHPUnit\Framework\Attributes\DataProvider;
use Tests\TestCase;

final class SupportRequestsTest extends TestCase
{
    use RefreshDatabase;

    private bool $scannerUnavailable = false;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SystemFoundationSeeder::class);
        Queue::fake();
        Storage::fake('local');
        config()->set('materyalph.files.disk', 'local');
        $this->mock(VendorFileScanner::class)->shouldReceive('assertClean')->andReturnUsing(function (): void {
            if ($this->scannerUnavailable) {
                throw new AuthenticationException('FILE_SCANNER_UNAVAILABLE', 'File scanning is unavailable.', 503);
            }
        });
        $this->withCredentials()->withUnencryptedCookie('mp_csrf', 'support-test')->withHeader('X-CSRF-Token', 'support-test');
    }

    public function test_guest_creation_is_persisted_idempotent_private_and_notifies_only_support_admins(): void
    {
        $allowed = $this->admin('ADMIN_SUPPORT');
        $denied = $this->admin('ADMIN_ORDER_DISPUTE');
        $key = (string) Str::uuid7();
        $input = $this->input();
        $first = $this->withHeader('Idempotency-Key', $key)->postJson('/api/v1/support/guest/tickets', $input)->assertCreated();
        $id = $first->json('data.id');
        $first->assertJsonMissingPath('data.email')->assertJsonMissingPath('data.token');
        $this->postJson('/api/v1/support/guest/tickets', $input)->assertCreated()->assertJsonPath('data.id', $id);
        $this->assertDatabaseCount('support_tickets', 1);
        $this->assertDatabaseCount('support_entries', 1);
        $this->assertDatabaseHas('notifications', ['user_id' => $allowed->getKey(), 'resource_id' => $id]);
        $this->assertDatabaseMissing('notifications', ['user_id' => $denied->getKey(), 'resource_id' => $id]);
        $this->postJson('/api/v1/support/guest/tickets', $this->input(['subject' => 'Changed request']))->assertConflict();
        $this->getJson('/api/v1/support/guest/tickets/'.$id)->assertUnauthorized();
        $this->assertDatabaseHas('audit_logs', ['action' => 'SUPPORT_CREATED', 'resource_id' => $id]);
    }

    public function test_authenticated_identity_is_server_authoritative_and_other_buyers_cannot_access_it(): void
    {
        $owner = User::factory()->create(['name' => 'Buyer Owner']);
        $this->signIn($owner);
        $id = $this->createBuyerTicket();
        $this->getJson('/api/v1/support/buyers/tickets/'.$id)->assertOk()->assertJsonPath('data.full_name', 'Buyer Owner')->assertJsonPath('data.email', $owner->email)->assertJsonPath('data.user_type', 'BUYER');
        $this->signIn(User::factory()->create());
        $this->getJson('/api/v1/support/buyers/tickets')->assertOk()->assertJsonCount(0, 'data');
        $this->getJson('/api/v1/support/buyers/tickets/'.$id)->assertNotFound();
        $this->getJson('/api/v1/support/buyers/tickets/'.$id.'/entries')->assertNotFound();
        $this->withHeader('Idempotency-Key', (string) Str::uuid7())->postJson('/api/v1/support/buyers/tickets/'.$id.'/entries', ['message' => 'Unauthorized reply'])->assertNotFound();
    }

    public function test_admin_and_buyer_conversation_status_assignment_reopen_and_notifications(): void
    {
        $buyer = User::factory()->create();
        $this->signIn($buyer);
        $id = $this->createBuyerTicket();
        $admin = $this->admin('ADMIN_SUPPORT');
        $this->signIn($admin);
        $this->withHeader('Idempotency-Key', (string) Str::uuid7())->patchJson('/api/v1/support/admin/tickets/'.$id, ['lock_version' => 1, 'status' => 'WAITING_FOR_USER', 'assigned_admin_id' => $admin->public_id, 'reason' => 'Please provide more information.'])->assertOk();
        $this->withHeader('Idempotency-Key', (string) Str::uuid7())->postJson('/api/v1/support/admin/tickets/'.$id.'/entries', ['message' => 'Please explain the error message.'])->assertCreated();
        $this->assertDatabaseHas('notifications', ['user_id' => $buyer->getKey(), 'resource_type' => 'SUPPORT_TICKET', 'resource_id' => $id]);
        $this->signIn($buyer);
        $this->withHeader('Idempotency-Key', (string) Str::uuid7())->postJson('/api/v1/support/buyers/tickets/'.$id.'/entries', ['message' => 'Here is the requested information.'])->assertCreated();
        $this->getJson('/api/v1/support/buyers/tickets/'.$id)->assertOk()->assertJsonPath('data.status', 'OPEN')->assertJsonPath('data.lock_version', 4);
        $this->getJson('/api/v1/support/buyers/tickets/'.$id.'/entries')->assertOk()->assertJsonCount(6, 'data');
        $this->signIn($admin);
        $this->withHeader('Idempotency-Key', (string) Str::uuid7())->patchJson('/api/v1/support/admin/tickets/'.$id, ['lock_version' => 1, 'status' => 'CLOSED', 'reason' => 'Stale version'])->assertConflict();
        $this->withHeader('Idempotency-Key', (string) Str::uuid7())->patchJson('/api/v1/support/admin/tickets/'.$id, ['lock_version' => 4, 'status' => 'CLOSED', 'reason' => 'Concern completed'])->assertOk();
        $this->withHeader('Idempotency-Key', (string) Str::uuid7())->postJson('/api/v1/support/admin/tickets/'.$id.'/entries', ['message' => 'Closed reply'])->assertConflict();
        $this->withHeader('Idempotency-Key', (string) Str::uuid7())->patchJson('/api/v1/support/admin/tickets/'.$id, ['lock_version' => 5, 'status' => 'IN_PROGRESS', 'reason' => 'Reopening for investigation'])->assertOk();
    }

    public function test_unprivileged_admins_cannot_read_reply_assign_or_download_and_revoked_notifications_are_denied(): void
    {
        $this->signIn(User::factory()->create());
        $id = $this->createBuyerTicket();
        $admin = $this->admin('ADMIN_ORDER_DISPUTE');
        $this->signIn($admin);
        $base = '/api/v1/support/admin';
        foreach (['/tickets', '/handlers', '/tickets/'.$id, '/tickets/'.$id.'/entries', '/tickets/'.$id.'/attachments/'.Str::uuid7()] as $path) {
            $this->getJson($base.$path)->assertForbidden();
        }
        $this->withHeader('Idempotency-Key', (string) Str::uuid7())->postJson($base.'/tickets/'.$id.'/entries', ['message' => 'Not allowed'])->assertForbidden();
        $this->patchJson($base.'/tickets/'.$id, ['lock_version' => 1, 'status' => 'RESOLVED', 'reason' => 'Not allowed'])->assertForbidden();
        self::assertFalse(app(NotificationPolicy::class)->allows($admin, (object) ['user_id' => $admin->getKey(), 'resource_type' => 'SUPPORT_TICKET', 'resource_id' => $id, 'category' => 'SUPPORT']));
    }

    public function test_guest_links_are_single_use_expiring_ticket_scoped_and_never_return_the_secret(): void
    {
        $ticket = $this->withHeader('Idempotency-Key', (string) Str::uuid7())->postJson('/api/v1/support/guest/tickets', $this->input())->assertCreated()->json('data');
        $event = DB::table('outbox_events')->where('event_type', 'SUPPORT_GUEST_EMAIL')->first();
        $envelope = json_decode($event->payload, true);
        $payload = json_decode(Crypt::decryptString($envelope['sealed_payload']), true);
        $raw = $payload['token'];
        self::assertFalse(str_contains(DB::table('support_guest_credentials')->value('token_hash'), $raw));
        $result = $this->postJson('/api/v1/support/guest/access', ['token' => $raw])->assertOk()->assertJsonPath('data.ticket_id', $ticket['id']);
        $cookie = collect($result->headers->getCookies())->first(fn ($item) => $item->getName() === 'mp_support');
        self::assertTrue($cookie->isHttpOnly());
        self::assertTrue($cookie->isSecure());
        self::assertSame('strict', $cookie->getSameSite());
        $this->postJson('/api/v1/support/guest/access', ['token' => $raw])->assertUnprocessable();
        $this->withUnencryptedCookie('mp_support', $cookie->getValue());
        $this->getJson('/api/v1/support/guest/tickets/'.$ticket['id'])->assertOk();
        $this->withHeader('Idempotency-Key', (string) Str::uuid7())->postJson('/api/v1/support/guest/tickets/'.$ticket['id'].'/entries', ['message' => 'My follow-up'])->assertCreated();
        $this->travel(31)->minutes();
        $this->getJson('/api/v1/support/guest/tickets/'.$ticket['id'])->assertUnauthorized();
        $this->travelBack();
        app(SupportGuestAccess::class)->sendLink(DB::table('support_tickets')->where('id', $ticket['id'])->first());
        $freshEvent = DB::table('outbox_events')->where('event_type', 'SUPPORT_GUEST_EMAIL')->orderByDesc('id')->first();
        $freshEnvelope = json_decode($freshEvent->payload, true);
        $freshPayload = json_decode(Crypt::decryptString($freshEnvelope['sealed_payload']), true);
        $this->travel(25)->hours();
        $this->expectException(AuthenticationException::class);
        app(SupportGuestAccess::class)->exchange($freshPayload['token']);
    }

    public function test_guest_access_email_does_not_reveal_existence_and_requires_csrf(): void
    {
        $response = $this->postJson('/api/v1/support/guest/access-email', ['ticket_number' => 'SUP-UNKNOWN', 'email' => 'nobody@example.com'])->assertOk();
        $response->assertJsonPath('data.message', 'If the details match a guest request, a secure access email will be sent.');
        $this->withHeader('X-CSRF-Token', 'incorrect')->postJson('/api/v1/support/guest/tickets', $this->input())->assertStatus(419);
    }

    public function test_validation_spam_trap_and_rate_limit(): void
    {
        $this->withHeader('Idempotency-Key', (string) Str::uuid7())->postJson('/api/v1/support/guest/tickets', $this->input(['category' => 'INVALID']))->assertUnprocessable();
        $this->postJson('/api/v1/support/guest/tickets', $this->input(['website' => 'spam']))->assertUnprocessable();
        $this->postJson('/api/v1/support/guest/tickets', $this->input(['privacy_acknowledged' => false]))->assertUnprocessable();
        $this->postJson('/api/v1/support/guest/tickets', $this->input(['message' => '']))->assertUnprocessable();
        $this->postJson('/api/v1/support/guest/tickets', $this->input(['email' => 'invalid']))->assertUnprocessable();
        $this->postJson('/api/v1/support/guest/tickets', $this->input(['subject' => '']))->assertUnprocessable();
        $this->postJson('/api/v1/support/guest/tickets', $this->input())->assertStatus(429);
        $this->assertDatabaseCount('support_tickets', 0);
    }

    public function test_valid_attachments_stay_private_and_unauthorized_files_are_unavailable(): void
    {
        $owner = User::factory()->create();
        $this->signIn($owner);
        $input = $this->input(['files' => [UploadedFile::fake()->image('proof.png')]]);
        $id = $this->withHeader('Idempotency-Key', (string) Str::uuid7())->post('/api/v1/support/buyers/tickets', $input, ['Accept' => 'application/json'])->assertCreated()->json('data.id');
        $file = DB::table('files')->where('owner_id', $id)->first();
        self::assertSame('PRIVATE', $file->visibility);
        self::assertSame('CLEAN', $file->scan_state);
        $this->get('/api/v1/support/buyers/tickets/'.$id.'/attachments/'.$file->id)->assertOk()->assertHeader('X-Content-Type-Options', 'nosniff');
        $this->signIn(User::factory()->create());
        $this->get('/api/v1/support/buyers/tickets/'.$id.'/attachments/'.$file->id, ['Accept' => 'application/json'])->assertNotFound();
    }

    public function test_attachment_validation_and_scanner_failure_do_not_create_ticket_or_file_records(): void
    {
        $this->signIn(User::factory()->create());
        $this->withHeader('Idempotency-Key', (string) Str::uuid7())->post('/api/v1/support/buyers/tickets', $this->input(['files' => [UploadedFile::fake()->createWithContent('fake.png', 'not an image')]]), ['Accept' => 'application/json'])->assertUnprocessable();
        $this->scannerUnavailable = true;
        $this->post('/api/v1/support/buyers/tickets', $this->input(['files' => [UploadedFile::fake()->image('safe.png')]]), ['Accept' => 'application/json'])->assertStatus(503);
        $this->assertDatabaseCount('support_tickets', 0);
        $this->assertDatabaseCount('files', 0);
    }

    public function test_admin_filters_and_pagination_and_invalid_handler(): void
    {
        $this->signIn(User::factory()->create());
        $id = $this->createBuyerTicket();
        $this->signIn($this->admin('ADMIN_SUPPORT'));
        $this->getJson('/api/v1/support/admin/tickets?q=Need&category=TECHNICAL_ISSUE&status=OPEN&user_type=BUYER&from='.now('Asia/Manila')->toDateString())->assertOk()->assertJsonCount(1, 'data')->assertJsonPath('meta.next_cursor', null);
        $this->getJson('/api/v1/support/admin/tickets?q=unknown')->assertOk()->assertJsonCount(0, 'data');
        $this->getJson('/api/v1/support/admin/tickets?cursor=invalid')->assertUnprocessable();
        $unqualified = $this->admin('ADMIN_ORDER_DISPUTE');
        $this->withHeader('Idempotency-Key', (string) Str::uuid7())->patchJson('/api/v1/support/admin/tickets/'.$id, ['lock_version' => 1, 'assigned_admin_id' => $unqualified->public_id, 'reason' => 'Transfer for review'])->assertUnprocessable();
    }

    public function test_history_is_append_only_at_the_database_boundary(): void
    {
        $this->signIn(User::factory()->create());
        $this->createBuyerTicket();
        $this->expectException(QueryException::class);
        DB::transaction(fn () => DB::table('support_entries')->update(['body' => 'rewritten']));
    }

    public function test_guest_mail_uses_the_sealed_outbox_and_rechecks_link_expiry_before_delivery(): void
    {
        config()->set('app.vendor_frontend_url', 'https://vendor.example.test');
        config()->set('mail.delivery_not_before', null);
        $id = $this->withHeader('Idempotency-Key', (string) Str::uuid7())->postJson('/api/v1/support/guest/tickets', $this->input())->assertCreated()->json('data.id');
        $event = DB::table('outbox_events')->where('event_type', 'SUPPORT_GUEST_EMAIL')->first();
        $delivered = 0;
        $this->mock(MailProvider::class)->shouldReceive('send')->andReturnUsing(function (string $recipient, Mailable $mail) use (&$delivered): void {
            self::assertTrue($recipient === 'support-guest@example.com');
            self::assertTrue($mail instanceof SupportAccessMail);
            self::assertTrue(str_starts_with($mail->accessUrl, 'https://vendor.example.test/contact/access#token='));
            $delivered++;
        });
        app(OutboxProcessor::class)->process($event->id);
        self::assertSame(1, $delivered);
        $this->assertDatabaseHas('outbox_events', ['id' => $event->id, 'attempts' => 0]);
        app(SupportGuestAccess::class)->sendLink(DB::table('support_tickets')->where('id', $id)->first());
        $next = DB::table('outbox_events')->where('event_type', 'SUPPORT_GUEST_EMAIL')->orderByDesc('id')->first();
        $this->travel(25)->hours();
        app(OutboxProcessor::class)->process($next->id);
        self::assertSame(1, $delivered, 'Expired links must not be delivered.');
    }

    /** @return array<string, array{string, string}> */
    public static function authenticatedSupportRecipients(): array
    {
        return ['buyer' => ['BUYER', 'buyers'], 'vendor' => ['VENDOR', 'vendors']];
    }

    #[DataProvider('authenticatedSupportRecipients')]
    public function test_admin_reply_emails_the_authenticated_requester_once(string $accountType, string $portal): void
    {
        Mail::fake();
        config()->set('mail.delivery_not_before', null);
        config()->set('app.vendor_frontend_url', 'https://vendor.example.test');
        $user = User::factory()->create(['account_type' => $accountType]);
        if ($accountType === 'VENDOR') {
            $organization = VendorOrganization::query()->create(['legal_name' => 'Support test vendor', 'store_name' => 'Support test store', 'account_status' => 'ACTIVE']);
            VendorMembership::query()->create(['vendor_organization_id' => $organization->id, 'user_id' => $user->id, 'role' => 'OWNER', 'status' => 'ACTIVE']);
            DB::table('totp_factors')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->id, 'encrypted_secret' => Crypt::encryptString(bin2hex(random_bytes(20))), 'confirmed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        }
        $this->signIn($user);
        $id = $this->withHeader('Idempotency-Key', (string) Str::uuid7())->postJson('/api/v1/support/'.$portal.'/tickets', $this->input())->assertCreated()->json('data.id');
        $this->signIn($this->admin('ADMIN_SUPPORT'));
        $key = (string) Str::uuid7();
        $reply = ['message' => 'Private response that belongs only in the ticket.'];
        $this->withHeader('Idempotency-Key', $key)->postJson('/api/v1/support/admin/tickets/'.$id.'/entries', $reply)->assertCreated();
        $this->postJson('/api/v1/support/admin/tickets/'.$id.'/entries', $reply)->assertCreated();
        $notice = DB::table('notifications')->where('user_id', $user->id)->where('resource_id', $id)->first();
        self::assertNotNull($notice);
        self::assertSame(1, DB::table('notifications')->where('user_id', $user->id)->where('resource_id', $id)->count());
        $processor = app(OutboxProcessor::class);
        $processor->process((string) DB::table('outbox_events')->where('event_type', 'NOTIFICATION_READY')->where('aggregate_id', $notice->id)->value('id'));
        $delivery = DB::table('notification_deliveries')->where('notification_id', $notice->id)->where('channel', 'EMAIL')->first();
        self::assertNotNull($delivery);
        $eventId = (string) DB::table('outbox_events')->where('event_type', 'NOTIFICATION_DELIVERY')->where('aggregate_id', $delivery->id)->value('id');
        $processor->process($eventId);
        $processor->process($eventId);
        Mail::assertSent(SupportNoticeMail::class, function (SupportNoticeMail $mail) use ($user, $accountType, $reply, $notice): bool {
            $rendered = $mail->render();
            self::assertStringContainsString('My Support Requests', $rendered);
            self::assertStringNotContainsString($reply['message'], $rendered);
            self::assertStringNotContainsString('Open the order', $rendered);
            if ($accountType === 'VENDOR') {
                self::assertStringContainsString('https://vendor.example.test/notifications?notice='.$notice->id, $rendered);
            } else {
                self::assertStringContainsString('Profile → Help Center', $rendered);
            }

            return $mail->hasTo($user->email) && $mail->accountType === $accountType;
        });
        Mail::assertSentCount(1);
        $this->assertDatabaseHas('notification_deliveries', ['id' => $delivery->id, 'state' => 'SENT', 'attempt_count' => 1]);
    }

    public function test_admin_reply_emails_a_guest_a_fresh_private_link_once(): void
    {
        Mail::fake();
        $this->mock(MailProvider::class)->shouldReceive('send')->once()->andReturnUsing(function (string $recipient, Mailable $mail): void {
            Mail::to($recipient)->send($mail);
        });
        config()->set('mail.delivery_not_before', null);
        config()->set('app.vendor_frontend_url', 'http://localhost:5173');
        $id = $this->withHeader('Idempotency-Key', (string) Str::uuid7())->postJson('/api/v1/support/guest/tickets', $this->input())->assertCreated()->json('data.id');
        $this->signIn($this->admin('ADMIN_SUPPORT'));
        $key = (string) Str::uuid7();
        $reply = ['message' => 'Private response that belongs only in the ticket.'];
        $this->withHeader('Idempotency-Key', $key)->postJson('/api/v1/support/admin/tickets/'.$id.'/entries', $reply)->assertCreated();
        $this->postJson('/api/v1/support/admin/tickets/'.$id.'/entries', $reply)->assertCreated();
        self::assertSame(2, DB::table('outbox_events')->where('event_type', 'SUPPORT_GUEST_EMAIL')->where('aggregate_id', $id)->count());
        $event = DB::table('outbox_events')->where('event_type', 'SUPPORT_GUEST_EMAIL')->where('aggregate_id', $id)->orderByDesc('id')->first();
        $this->app->instance('env', 'development');
        $processor = app(OutboxProcessor::class);
        $processor->process($event->id);
        $processor->process($event->id);
        Mail::assertSent(SupportAccessMail::class, function (SupportAccessMail $mail) use ($reply): bool {
            self::assertStringNotContainsString($reply['message'], $mail->render());

            return $mail->hasTo('support-guest@example.com') && str_starts_with($mail->accessUrl, 'http://localhost:5173/contact/access#token=');
        });
        Mail::assertSentCount(1);
        self::assertNotNull(DB::table('outbox_events')->where('id', $event->id)->value('processed_at'));
    }

    public function test_support_email_is_not_sent_after_requester_access_is_revoked(): void
    {
        Mail::fake();
        $user = User::factory()->create();
        $this->signIn($user);
        $id = $this->createBuyerTicket();
        $this->signIn($this->admin('ADMIN_SUPPORT'));
        $this->withHeader('Idempotency-Key', (string) Str::uuid7())->postJson('/api/v1/support/admin/tickets/'.$id.'/entries', ['message' => 'We have an update.'])->assertCreated();
        $noticeId = DB::table('notifications')->where('user_id', $user->id)->where('resource_id', $id)->value('id');
        $processor = app(OutboxProcessor::class);
        $processor->process((string) DB::table('outbox_events')->where('event_type', 'NOTIFICATION_READY')->where('aggregate_id', $noticeId)->value('id'));
        $deliveryId = DB::table('notification_deliveries')->where('notification_id', $noticeId)->where('channel', 'EMAIL')->value('id');
        $user->update(['account_status' => 'SUSPENDED']);
        $processor->process((string) DB::table('outbox_events')->where('event_type', 'NOTIFICATION_DELIVERY')->where('aggregate_id', $deliveryId)->value('id'));
        Mail::assertNothingSent();
        $this->assertDatabaseHas('notification_deliveries', ['id' => $deliveryId, 'state' => 'REVOKED']);
    }

    /** @return array<string, array{string, string, bool}> */
    public static function guestMailFrontendUrls(): array
    {
        return [
            'development localhost' => ['development', 'http://localhost:5173', true],
            'local IPv4 loopback' => ['local', 'http://127.0.0.1:5173', true],
            'development IPv6 loopback' => ['development', 'http://[::1]:5173', true],
            'production HTTPS' => ['production', 'https://vendor.example.test', true],
            'production HTTP denied' => ['production', 'http://localhost:5173', false],
            'staging HTTP denied' => ['staging', 'http://localhost:5173', false],
            'remote HTTP denied' => ['development', 'http://vendor.example.test', false],
            'localhost suffix denied' => ['development', 'http://localhost.example.test', false],
            'embedded credentials denied' => ['development', 'http://example-user@localhost:5173', false],
        ];
    }

    #[DataProvider('guestMailFrontendUrls')]
    public function test_guest_email_requires_https_except_for_development_loopback(string $environment, string $url, bool $allowed): void
    {
        config()->set('app.vendor_frontend_url', $url);
        config()->set('mail.delivery_not_before', null);
        $id = $this->withHeader('Idempotency-Key', (string) Str::uuid7())->postJson('/api/v1/support/guest/tickets', $this->input())->assertCreated()->json('data.id');
        $event = DB::table('outbox_events')->where('event_type', 'SUPPORT_GUEST_EMAIL')->where('aggregate_id', $id)->first();
        $envelope = json_decode($event->payload, true, flags: JSON_THROW_ON_ERROR);
        $payload = json_decode(Crypt::decryptString($envelope['sealed_payload']), true, flags: JSON_THROW_ON_ERROR);
        $this->app->instance('env', $environment);
        $this->mock(MailProvider::class)->shouldReceive('send')->times($allowed ? 1 : 0);
        if (! $allowed) {
            $this->expectException(AuthenticationException::class);
            $this->expectExceptionMessage('A secure Vendor frontend URL is required');
        }
        app(SupportGuestAccess::class)->deliver($payload['credential_id'], $payload['token'], (string) $event->created_at);
    }

    /** @param array<string, mixed> $extra
     * @return array<string, mixed>
     */
    private function input(array $extra = []): array
    {
        return $extra + ['full_name' => 'Guest Reporter', 'email' => 'support-guest@example.com', 'user_type' => 'GUEST', 'category' => 'TECHNICAL_ISSUE', 'subject' => 'Need assistance', 'message' => 'Please help investigate this issue.', 'privacy_acknowledged' => true];
    }

    private function createBuyerTicket(): string
    {
        return $this->withHeader('Idempotency-Key', (string) Str::uuid7())->postJson('/api/v1/support/buyers/tickets', $this->input())->assertCreated()->json('data.id');
    }

    private function admin(string $role): User
    {
        $user = User::factory()->create(['account_type' => 'ADMIN']);
        DB::table('admin_memberships')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'platform_role_id' => DB::table('platform_roles')->where('code', $role)->value('id'), 'status' => 'ACTIVE', 'created_at' => now(), 'updated_at' => now()]);
        DB::table('totp_factors')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'encrypted_secret' => Crypt::encryptString(bin2hex(random_bytes(20))), 'confirmed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);

        return $user;
    }

    private function signIn(User $user): void
    {
        $sessionData = app(TokenSessionService::class)->start($user, $user->account_type === 'BUYER' ? 'MOBILE' : 'WEB', null, null, null);
        $session = AuthSession::query()->findOrFail($sessionData->sessionId);
        $user->withAccessToken(new AccessToken(['oauth_access_token_id' => $session->oauth_access_token_id, 'oauth_scopes' => [$user->account_type]]));
        $this->actingAs($user, 'api');
    }
}
