<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Identity\TokenSessionService;
use App\Domain\Operations\OutboxProcessor;
use App\Domain\Orders\OrderActor;
use App\Domain\Orders\OrderTransitionService;
use App\Domain\Reporting\DocumentSnapshot;
use App\Domain\Reporting\OrderDocumentLayout;
use App\Domain\Reporting\OrderDocumentService;
use App\Domain\Reporting\PurchaseOrderDetails;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\VendorFileScanner;
use App\Jobs\ProcessOutboxEvent;
use App\Models\AuthSession;
use App\Models\User;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Database\QueryException;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Queue;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Laravel\Passport\AccessToken;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\Support\CreatesOrderFixtures;
use Tests\Support\CreatesPaymentFixtures;
use Tests\Support\FakeAddressGeocoder;
use Tests\Support\FakePlacesProvider;
use Tests\Support\FakeRouteProvider;
use Tests\TestCase;

final class OrderDocumentsTest extends TestCase
{
    use CreatesDiscoveryFixtures, CreatesOrderFixtures, CreatesPaymentFixtures, RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SystemFoundationSeeder::class);
        config()->set('materyalph.files.disk', 'local');
        config()->set('services.cloudinary.cloud_name', '');
        Storage::fake('local');
        $this->mock(VendorFileScanner::class)->shouldReceive('assertClean')->andReturnNull();
        $this->withCredentials()->withUnencryptedCookie('mp_csrf', 'test-csrf')->withHeader('X-CSRF-Token', 'test-csrf');
        $this->app->instance(PlacesProvider::class, new FakePlacesProvider);
        $this->app->instance(RouteProvider::class, new FakeRouteProvider);
        $this->app->instance(AddressGeocoder::class, new FakeAddressGeocoder);
        $this->fakePayments();
    }

    public function test_acceptance_and_paid_events_issue_reusable_pdfs_without_an_export_request(): void
    {
        [$store, $owner, $buyer, $order] = $this->awaitingPayment('Issued documents');
        $service = app(OrderDocumentService::class);
        $po = DB::table('order_documents')->where('order_id', $order)->sole();
        self::assertSame('PURCHASE_ORDER', $po->kind);
        $details = json_decode($po->source_snapshot, true, flags: JSON_THROW_ON_ERROR)['order_details'];
        self::assertSame('Online payment', $details['payment_method']);
        self::assertSame('Self-Pickup', $details['fulfillment_method']);
        self::assertNotEmpty($details['buyer']['name']);
        self::assertNotEmpty($details['vendor']['name']);
        self::assertSame($buyer->email, $details['buyer']['email']);
        self::assertSame('', $details['buyer']['phone']);
        self::assertArrayNotHasKey('tin', $details['buyer']);
        $service->process($po->id);
        self::assertSame($details, json_decode(DB::table('order_document_renditions')->where('order_document_id', $po->id)->value('context_snapshot'), true, flags: JSON_THROW_ON_ERROR));
        $this->getJson('/api/v1/buyers/orders/'.$order.'/documents')->assertOk()->assertJsonPath('data.0.availability', 'READY')->assertJsonCount(1, 'data');
        $payment = $this->startPayment($buyer, $order);
        $this->completePayment($payment['id'])->assertOk();
        self::assertSame(0, DB::table('order_documents')->where('order_id', $order)->where('kind', 'PAYMENT_CONFIRMATION')->count());
        $this->getJson('/api/v1/buyers/orders/'.$order.'/documents/PAYMENT_CONFIRMATION/download')->assertNotFound();
        self::assertSame(0, $service->prepare($order));
        $service->process($po->id);
        self::assertSame(1, DB::table('files')->where('purpose', 'ORDER_DOCUMENT')->count());
        self::assertSame(0, DB::table('data_exports')->count());
        $route = '/api/v1/buyers/orders/'.$order.'/documents/PURCHASE_ORDER/download';
        $bytes = $this->get($route)->assertOk()->streamedContent();
        self::assertStringStartsWith('%PDF-', $bytes);
        $this->travel(2)->days();
        self::assertSame($bytes, $this->get($route)->assertOk()->streamedContent(), 'Issued documents remain available beyond report-copy expiry.');
        $this->travelBack();
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendor/orders/'.$order.'/invoices')->assertOk()->assertJsonPath('data.platform_documents.0.availability', 'READY')->assertJsonCount(1, 'data.platform_documents');
        self::assertSame($bytes, $this->get('/api/v1/vendor/orders/'.$order.'/documents/PURCHASE_ORDER/download')->assertOk()->streamedContent());
        self::assertSame(3, DB::table('audit_logs')->where('action', 'ORDER_DOCUMENT_DOWNLOADED')->count());
        $this->buyer();
        $this->getJson($route)->assertNotFound();
        $this->signInStoreMember($owner);
        DB::table('vendor_memberships')->where('user_id', $owner->id)->update(['status' => 'SUSPENDED']);
        $this->getJson('/api/v1/vendor/orders/'.$order.'/documents/PURCHASE_ORDER/download')->assertForbidden();
    }

    public function test_completion_and_scheduled_backfill_prepare_legacy_documents_without_read_side_effects(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Legacy documents');
        [$buyer, $order] = $this->pickupOrder($store, $listing);
        DB::table('orders')->where('id', $order)->update(['accepted_snapshot_version' => 1, 'accepted_at' => now(), 'order_state' => 'PICKED_UP', 'fulfillment_state' => 'PICKED_UP']);
        $this->getJson('/api/v1/buyers/orders/'.$order.'/documents')->assertOk();
        self::assertSame(0, DB::table('order_documents')->count(), 'Reads never generate a document.');
        DB::transaction(function () use ($order): void {
            $row = DB::table('orders')->where('id', $order)->lockForUpdate()->first();
            app(OrderTransitionService::class)->apply($row, ['ORDER' => 'COMPLETED'], OrderActor::system());
        });
        self::assertSame(1, DB::table('order_documents')->where('order_id', $order)->count());
        self::assertSame(0, app(OrderDocumentService::class)->sweep());
        self::assertSame(0, DB::table('order_documents')->where('kind', 'PAYMENT_CONFIRMATION')->count(), 'Completion alone must not claim payment.');
        [$otherBuyer, $legacy] = $this->pickupOrder($store, $listing);
        DB::table('orders')->where('id', $legacy)->update(['accepted_snapshot_version' => 1, 'accepted_at' => now(), 'order_state' => 'COMPLETED', 'closed_at' => now()]);
        self::assertSame(1, app(OrderDocumentService::class)->sweep());
        self::assertSame(0, app(OrderDocumentService::class)->sweep());
    }

    public function test_queued_download_and_checksum_failure_never_generate_or_deliver_another_file(): void
    {
        Queue::fake();
        [, , $buyer, $order] = $this->awaitingPayment('Verified documents');
        $document = DB::table('order_documents')->where('order_id', $order)->sole();
        $route = '/api/v1/buyers/orders/'.$order.'/documents/PURCHASE_ORDER/download';
        $this->getJson($route)->assertStatus(409)->assertJsonPath('errors.0.code', 'ORDER_DOCUMENT_NOT_READY');
        self::assertSame(0, DB::table('files')->where('purpose', 'ORDER_DOCUMENT')->count());
        app(OrderDocumentService::class)->process($document->id);
        $file = DB::table('files')->where('id', DB::table('order_documents')->where('id', $document->id)->value('file_id'))->sole();
        Storage::disk('local')->put($file->object_key, '%PDF-corrupt');
        $this->getJson($route)->assertStatus(409)->assertJsonPath('errors.0.code', 'ORDER_DOCUMENT_CHECKSUM_FAILED');
        self::assertSame(0, DB::table('audit_logs')->where('action', 'ORDER_DOCUMENT_DOWNLOADED')->count());
        self::assertSame(1, DB::table('order_documents')->count());
    }

    public function test_failed_generation_is_retryable_with_the_original_immutable_source(): void
    {
        Queue::fake();
        [, , , $order] = $this->awaitingPayment('Retry documents');
        $document = DB::table('order_documents')->where('order_id', $order)->sole();
        $event = DB::table('outbox_events')->where('event_type', OrderDocumentService::EVENT)->where('aggregate_id', $document->id)->sole();
        (new ProcessOutboxEvent($event->id))->failed(new \RuntimeException('Synthetic worker failure'));
        self::assertSame('FAILED', DB::table('order_documents')->where('id', $document->id)->value('state'));
        $admin = User::factory()->create(['account_type' => 'ADMIN', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        DB::table('admin_memberships')->insert(['id' => (string) Str::uuid7(), 'user_id' => $admin->id, 'platform_role_id' => DB::table('platform_roles')->where('code', 'ADMIN_SUPERADMIN')->value('id'), 'status' => 'ACTIVE', 'created_at' => now(), 'updated_at' => now()]);
        DB::table('totp_factors')->insert(['id' => (string) Str::uuid7(), 'user_id' => $admin->id, 'encrypted_secret' => Crypt::encryptString('SYNTHETIC-ORDER-DOCUMENT-TEST'), 'confirmed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        $tokens = app(TokenSessionService::class)->start($admin, 'WEB', null, null, null);
        $session = AuthSession::query()->findOrFail($tokens->sessionId);
        $session->update(['reauthenticated_at' => now(), 'reauthentication_method' => 'PASSWORD_TOTP']);
        $admin->withAccessToken(new AccessToken(['oauth_access_token_id' => $session->oauth_access_token_id, 'oauth_scopes' => ['ADMIN']]));
        $this->actingAs($admin, 'api');
        $this->postJson('/api/v1/admin/integrations/retries', ['target_type' => 'OUTBOX_EVENT', 'reference' => $event->id, 'reason' => 'Retry original immutable order document after worker recovery'], ['Idempotency-Key' => (string) Str::uuid7()])->assertAccepted();
        app(OutboxProcessor::class)->process($event->id);
        self::assertSame('READY', DB::table('order_documents')->where('id', $document->id)->value('state'));
        self::assertSame($document->source_snapshot, DB::table('order_documents')->where('id', $document->id)->value('source_snapshot'));
        $this->get('/api/v1/admin/orders/'.$order.'/documents/PURCHASE_ORDER/download')->assertOk();
    }

    public function test_source_and_issued_file_cannot_be_rewritten_or_deleted(): void
    {
        [, , , $order] = $this->awaitingPayment('Immutable issued documents');
        $document = DB::table('order_documents')->where('order_id', $order)->sole();
        app(OrderDocumentService::class)->process($document->id);
        foreach ([fn () => DB::table('order_documents')->where('id', $document->id)->update(['source_hash' => str_repeat('0', 64)]),
            fn () => DB::table('order_documents')->where('id', $document->id)->update(['state' => 'QUEUED']),
            fn () => DB::table('order_documents')->where('id', $document->id)->delete()] as $mutation) {
            try {
                DB::transaction($mutation);
                self::fail('Issued order documents are immutable.');
            } catch (QueryException $exception) {
                self::assertSame('P0001', $exception->errorInfo[0]);
            }
        }
    }

    public function test_existing_issued_pdf_receives_a_new_layout_without_rewriting_its_source_or_original_file(): void
    {
        Queue::fake();
        [$store, , $listing] = $this->pickupStore('Existing layout');
        [, $order] = $this->pickupOrder($store, $listing);
        DB::table('orders')->where('id', $order)->update(['accepted_snapshot_version' => 1, 'accepted_at' => now(), 'order_state' => 'COMPLETED']);
        $capture = app(DocumentSnapshot::class)->order('PURCHASE_ORDER', $order);
        unset($capture['order_details']);
        $snapshot = ['title' => 'MateryalPH Purchase Order', 'generated_at' => now('Asia/Manila')->format('Y-m-d H:i:s'),
            'source_hash' => hash('sha256', json_encode($capture, JSON_THROW_ON_ERROR)), ...$capture];
        DB::table('order_documents')->insert(['id' => (string) Str::uuid7(), 'order_id' => $order, 'kind' => 'PURCHASE_ORDER', 'state' => 'QUEUED',
            'source_snapshot' => json_encode($snapshot, JSON_THROW_ON_ERROR), 'source_hash' => $snapshot['source_hash'], 'created_at' => now(), 'updated_at' => now()]);
        $document = DB::table('order_documents')->where('order_id', $order)->sole();
        $originalFile = (string) Str::uuid7();
        $originalBytes = '%PDF-1.4 Original legacy layout';
        $originalKey = 'private/legacy-order-document.pdf';
        Storage::disk('local')->put($originalKey, $originalBytes);
        DB::table('files')->insert(['id' => $originalFile, 'owner_type' => 'ORDER', 'owner_id' => $order,
            'purpose' => 'ORDER_DOCUMENT', 'visibility' => 'PRIVATE', 'content_type' => 'application/pdf', 'byte_size' => strlen($originalBytes),
            'checksum_sha256' => hash('sha256', $originalBytes), 'scan_state' => 'CLEAN', 'object_key' => $originalKey,
            'retention_class' => 'COMMERCIAL_RECORD', 'metadata' => json_encode(['disk' => 'local']), 'created_at' => now(), 'updated_at' => now()]);
        DB::table('order_documents')->where('id', $document->id)->update(['state' => 'READY', 'file_id' => $originalFile, 'generated_at' => now()]);
        DB::table('outbox_events')->where('event_type', OrderDocumentService::EVENT)->where('aggregate_id', $document->id)->update(['processed_at' => now()]);
        $originalRecord = DB::table('order_documents')->where('id', $document->id)->sole();
        $service = app(OrderDocumentService::class);
        self::assertSame(1, $service->sweep());
        self::assertSame(0, $service->sweep(), 'An existing queued or failed layout job is never republished by the sweep.');
        $route = '/api/v1/buyers/orders/'.$order.'/documents/PURCHASE_ORDER/download';
        self::assertSame($originalBytes, $this->get($route)->assertOk()->streamedContent());
        $service->process($document->id);
        $service->process($document->id);
        $rendition = DB::table('order_document_renditions')->where('order_document_id', $document->id)->sole();
        self::assertSame(OrderDocumentLayout::VERSION, (int) $rendition->layout_version);
        $context = json_decode($rendition->context_snapshot, true, flags: JSON_THROW_ON_ERROR);
        self::assertNotEmpty($context['buyer']['name']);
        self::assertNotEmpty($context['vendor']['name']);
        self::assertSame('Self-Pickup', $context['fulfillment_method']);
        self::assertSame(PurchaseOrderDetails::hash($context), $rendition->context_hash);
        DB::table('store_profiles')->where('vendor_organization_id', $store->id)->update(['public_store_name' => 'Changed after capture']);
        $service->process($document->id);
        self::assertSame($context, json_decode(DB::table('order_document_renditions')->where('id', $rendition->id)->value('context_snapshot'), true, flags: JSON_THROW_ON_ERROR));
        self::assertNotSame($originalFile, $rendition->file_id);
        self::assertEquals($originalRecord, DB::table('order_documents')->where('id', $document->id)->sole());
        self::assertSame($originalBytes, Storage::disk('local')->get($originalKey));
        $bytes = $this->get($route)->assertOk()->streamedContent();
        self::assertStringStartsWith('%PDF-', $bytes);
        self::assertNotSame($originalBytes, $bytes);
        $this->getJson('/api/v1/buyers/orders/'.$order.'/documents')->assertOk()->assertJsonPath('data.0.checksum', hash('sha256', $bytes));
        self::assertSame(2, DB::table('files')->where('purpose', 'ORDER_DOCUMENT')->count());
        self::assertSame(1, DB::table('audit_logs')->where('action', 'ORDER_DOCUMENT_LAYOUT_GENERATED')->count());
        foreach ([fn () => DB::table('order_document_renditions')->where('id', $rendition->id)->update(['layout_version' => 99]),
            fn () => DB::table('order_document_renditions')->where('id', $rendition->id)->delete()] as $mutation) {
            try {
                DB::transaction($mutation);
                self::fail('Issued layouts are immutable.');
            } catch (QueryException $exception) {
                self::assertSame('P0001', $exception->errorInfo[0]);
            }
        }
    }

    public function test_buyer_contacts_supplement_old_details_without_rewriting_previously_frozen_values(): void
    {
        [$store, , $listing] = $this->pickupStore('Buyer contacts');
        [$buyer, $order] = $this->pickupOrder($store, $listing);
        DB::table('user_profiles')->insert(['id' => (string) Str::uuid7(), 'user_id' => $buyer->id, 'full_name' => 'Sample Buyer',
            'mobile_e164' => '+639170000001', 'created_at' => now(), 'updated_at' => now()]);
        $details = PurchaseOrderDetails::capture($order);
        self::assertSame($buyer->email, $details['buyer']['email']);
        self::assertSame('+639170000001', $details['buyer']['phone']);
        unset($details['buyer']['email'], $details['buyer']['phone']);
        $details['buyer']['name'] = 'Original Buyer name';
        $details['vendor']['name'] = 'Original Vendor name';
        $context = PurchaseOrderDetails::withBuyerContact($order, $details);
        self::assertSame('Original Buyer name', $context['buyer']['name']);
        self::assertSame('Original Vendor name', $context['vendor']['name']);
        self::assertSame($details['captured_at'], $context['captured_at']);
        self::assertSame($buyer->email, $context['buyer']['email']);
        self::assertSame('+639170000001', $context['buyer']['phone']);
        self::assertNotEmpty($context['buyer_contact_captured_at']);
        DB::table('user_profiles')->where('user_id', $buyer->id)->update(['mobile_e164' => '+639170000002']);
        self::assertSame($context, PurchaseOrderDetails::withBuyerContact($order, $context), 'Issued contact details stay frozen.');
        $reordered = $context;
        $reordered['buyer'] = array_reverse($context['buyer'], true);
        self::assertSame(PurchaseOrderDetails::hash($context), PurchaseOrderDetails::hash($reordered), 'JSONB key order does not change the context hash.');
    }
}
