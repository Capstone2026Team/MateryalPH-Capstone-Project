<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\TokenSessionService;
use App\Domain\Reviews\ReviewService;
use App\Domain\Scores\MetricEventProjector;
use App\Domain\Scores\PublicScores;
use App\Domain\Scores\ScoreRules;
use App\Domain\Scores\ScoreSnapshotService;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\VendorFileScanner;
use App\Models\AuthSession;
use App\Models\User;
use App\Models\VendorOrganization;
use Carbon\CarbonImmutable;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Database\QueryException;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Illuminate\Testing\TestResponse;
use Laravel\Passport\AccessToken;
use Mockery\MockInterface;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\Support\CreatesOrderFixtures;
use Tests\Support\FakeAddressGeocoder;
use Tests\Support\FakePlacesProvider;
use Tests\Support\FakeRouteProvider;
use Tests\TestCase;

/**
 * Phase 14 reviews, scores and badges acceptance with a frozen clock at every edge: the 14-day window (open one
 * second before, closed at the exact instant), the 24-hour correction lock, blind reveal on both submissions or on
 * expiry, dispute withholding, immutable revisions and moderation history, the 7-day Admin-requested correction,
 * no Vendor delete path, MQS/VCS/OHS sample gates and 90/30-day windows, OHS weekly carry-forward, idempotent daily
 * replay, Admin exclusions, CRR at exactly 12 hours, and automatic badge award/removal with suppression only.
 */
final class PhaseFourteenReviewsScoresTest extends TestCase
{
    use CreatesDiscoveryFixtures;
    use CreatesOrderFixtures;
    use RefreshDatabase;

    private MockInterface $mediaScanner;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(SystemFoundationSeeder::class);
        config()->set('materyalph.files.disk', 'local');
        config()->set('services.cloudinary.cloud_name', '');
        config()->set('finance.materials_analytics_enabled', true);
        Storage::fake('local');
        $this->mediaScanner = $this->mock(VendorFileScanner::class);
        $this->mediaScanner->shouldReceive('assertClean')->andReturnNull()->byDefault();
        $this->withCredentials()->withUnencryptedCookie('mp_csrf', 'test-csrf')->withHeader('X-CSRF-Token', 'test-csrf');
        $this->app->instance(PlacesProvider::class, new FakePlacesProvider);
        $this->app->instance(RouteProvider::class, new FakeRouteProvider);
        $this->app->instance(AddressGeocoder::class, new FakeAddressGeocoder);
    }

    protected function tearDown(): void
    {
        Carbon::setTestNow();
        CarbonImmutable::setTestNow();
        parent::tearDown();
    }

    public function test_product_review_media_is_private_typed_retry_safe_and_retired_without_deleting_history(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Media Store');
        [$buyer, $orderId] = $this->pickupOrder($store, $listing);
        $completed = $this->complete($orderId);
        $this->freeze($completed);
        $this->signInBuyer($buyer);
        $line = (string) DB::table('order_lines')->where('order_id', $orderId)->value('id');
        $this->submitBuyer($orderId, ['vendor_rating' => ['service_quality' => 5, 'speed_rating' => 5], 'product_reviews' => [['order_line_id' => $line, 'rating' => 5]]])->assertCreated();
        $reviewId = (string) DB::table('reviews')->where('order_id', $orderId)->where('review_type', 'PRODUCT')->value('id');
        $vendorReview = (string) DB::table('reviews')->where('order_id', $orderId)->where('review_type', 'VENDOR')->value('id');
        $this->uploadReviewMedia($vendorReview, [UploadedFile::fake()->image('photo.png')])->assertUnprocessable()->assertJsonPath('errors.0.code', 'REVIEW_MEDIA_NOT_ALLOWED');
        $video = (string) file_get_contents(base_path('tests/Fixtures/review-video.mp4'));
        $key = (string) Str::uuid7();
        $result = $this->uploadReviewMedia($reviewId, [UploadedFile::fake()->image('photo.png'), UploadedFile::fake()->createWithContent('video.mp4', $video)], $key)->assertOk();
        $media = $result->json('data.lines.0.review.media');
        self::assertSame(['image/png', 'video/mp4'], array_column($media, 'content_type'));
        $this->get($media[1]['url'])->assertOk()->assertHeader('Content-Type', 'video/mp4');
        $this->uploadReviewMedia($reviewId, [UploadedFile::fake()->image('photo.png'), UploadedFile::fake()->createWithContent('video.mp4', $video)], $key)->assertOk();
        self::assertSame(2, DB::table('files')->where('purpose', 'REVIEW_MEDIA')->count(), 'A replay must not leave unreferenced stored files.');
        self::assertSame(2, DB::table('review_revisions')->where('review_id', $reviewId)->count());
        $this->uploadReviewMedia($reviewId, [UploadedFile::fake()->image('third.png')])->assertOk();
        $this->uploadReviewMedia($reviewId, [UploadedFile::fake()->image('fourth.png')])->assertUnprocessable();
        self::assertSame(3, DB::table('files')->where('purpose', 'REVIEW_MEDIA')->count(), 'Failed attachment transaction discards only its uncommitted files.');
        $this->signInBuyer($this->buyer());
        $this->get($media[1]['url'])->assertNotFound();
        $this->uploadReviewMedia($reviewId, [UploadedFile::fake()->image('intruder.png')])->assertNotFound();
        $this->signInBuyer($buyer);
        $this->deleteJson('/api/v1/buyers/reviews/'.$reviewId.'/media/'.$media[0]['id'])->assertOk()->assertJsonCount(2, 'data.lines.0.review.media');
        self::assertSame(3, DB::table('files')->where('purpose', 'REVIEW_MEDIA')->count(), 'Retired files remain commercial history.');
        $this->get($media[0]['url'])->assertNotFound();
        $this->freeze($completed->addHours(24));
        $this->uploadReviewMedia($reviewId, [UploadedFile::fake()->image('late.png')])->assertConflict()->assertJsonPath('errors.0.code', 'REVIEW_LOCKED');
        $this->getJson('/api/v1/buyers/orders/'.$orderId.'/reviews')->assertOk()->assertJsonPath('data.rules.photo_max_bytes', 10 * 1024 * 1024)->assertJsonPath('data.rules.video_max_bytes', 25 * 1024 * 1024);
    }

    public function test_review_media_rejects_invalid_content_and_scanner_failure_without_changing_the_review(): void
    {
        [$store, , $listing] = $this->pickupStore('Media Safety');
        [$buyer, $orderId] = $this->pickupOrder($store, $listing);
        $this->complete($orderId);
        $this->signInBuyer($buyer);
        $line = (string) DB::table('order_lines')->where('order_id', $orderId)->value('id');
        $this->submitBuyer($orderId, ['product_reviews' => [['order_line_id' => $line, 'rating' => 4]]])->assertCreated();
        $reviewId = (string) DB::table('reviews')->where('order_id', $orderId)->value('id');
        $this->uploadReviewMedia($reviewId, [UploadedFile::fake()->createWithContent('video.mp4', 'not a video')])->assertUnprocessable()->assertJsonPath('errors.0.code', 'FILE_VALIDATION_FAILED');
        $this->uploadReviewMedia($reviewId, [UploadedFile::fake()->create('oversized.mp4', 25601, 'video/mp4')])->assertUnprocessable();
        $this->mediaScanner->shouldReceive('assertClean')->andThrow(new AuthenticationException('FILE_SCANNER_UNAVAILABLE', 'File scanning is unavailable. Try again later.', 503));
        $this->uploadReviewMedia($reviewId, [UploadedFile::fake()->createWithContent('video.mp4', (string) file_get_contents(base_path('tests/Fixtures/review-video.mp4')))])->assertStatus(503)->assertJsonPath('errors.0.code', 'FILE_SCANNER_UNAVAILABLE');
        self::assertSame(0, DB::table('review_media')->where('review_id', $reviewId)->count());
        self::assertSame(0, DB::table('files')->where('purpose', 'REVIEW_MEDIA')->count());
        self::assertSame(1, DB::table('review_revisions')->where('review_id', $reviewId)->count());
    }

    /** @param list<UploadedFile> $files */
    private function uploadReviewMedia(string $reviewId, array $files, ?string $key = null): TestResponse
    {
        return $this->post('/api/v1/buyers/reviews/'.$reviewId.'/media', ['files' => $files], ['Accept' => 'application/json', 'Idempotency-Key' => $key ?? (string) Str::uuid7()]);
    }

    public function test_vendor_review_detail_preserves_purchase_snapshot_and_rechecks_media_access(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Review Detail');
        [$buyer, $orderId] = $this->pickupOrder($store, $listing);
        $this->complete($orderId);
        $line = DB::table('order_lines')->where('order_id', $orderId)->first();
        $snapshot = json_decode((string) $line->snapshot, true);
        $this->signInBuyer($buyer);
        $this->submitBuyer($orderId, ['vendor_rating' => ['service_quality' => 4, 'speed_rating' => 5],
            'product_reviews' => [['order_line_id' => $line->id, 'rating' => 4, 'comment' => 'Arrived in good condition.']]], 'VERIFIED_BUYER')->assertCreated();
        $reviewId = (string) DB::table('reviews')->where('order_id', $orderId)->where('review_type', 'PRODUCT')->value('id');
        $video = (string) file_get_contents(base_path('tests/Fixtures/review-video.mp4'));
        $this->uploadReviewMedia($reviewId, [UploadedFile::fake()->image('detail.png'), UploadedFile::fake()->createWithContent('detail.mp4', $video)])->assertOk();
        $this->signInStoreMember($owner);
        $this->getJson('/api/v1/vendor/reviews/'.$reviewId)->assertNotFound();
        $this->postJson('/api/v1/vendor/orders/'.$orderId.'/buyer-rating', ['inquiry_seriousness' => 5, 'communication_quality' => 4, 'payment_reliability' => 5], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated();
        DB::table('vendor_listings')->where('id', $listing)->update(['display_name' => 'Renamed after purchase']);
        DB::table('listing_variants')->where('id', $line->listing_variant_id)->update(['label' => 'Renamed variant']);
        $detail = $this->getJson('/api/v1/vendor/reviews/'.$reviewId)->assertOk()
            ->assertJsonPath('data.product.listing_id', $listing)->assertJsonPath('data.product.name', $snapshot['display_name'])
            ->assertJsonPath('data.product.variant_label', $snapshot['variant_label'])->assertJsonPath('data.variant_label', $snapshot['variant_label'])
            ->assertJsonPath('data.display_name', 'Verified Buyer')->assertJsonPath('data.comment', 'Arrived in good condition.')
            ->assertJsonPath('data.ratings.product_quality', 4)->assertJsonPath('data.can_report', true)->json('data');
        self::assertSame(['image/png', 'video/mp4'], array_column($detail['media'], 'content_type'));
        self::assertNotEmpty($detail['submitted_at']);
        self::assertArrayNotHasKey('reviewer_user_id', $detail);
        self::assertStringNotContainsString((string) $buyer->email, json_encode($detail, JSON_THROW_ON_ERROR));
        $this->get($detail['media'][0]['url'])->assertOk()->assertHeader('Content-Type', 'image/png');
        $this->get($detail['media'][1]['url'])->assertOk()->assertHeader('Content-Type', 'video/mp4');
        $ownId = (string) DB::table('reviews')->where('order_id', $orderId)->where('review_type', 'BUYER')->value('id');
        DB::table('reviews')->where('id', $ownId)->update(['revealed_at' => null]);
        $this->getJson('/api/v1/vendor/reviews/'.$ownId)->assertOk()->assertJsonPath('data.product', null)->assertJsonPath('data.can_report', false);

        [, $otherOwner] = $this->activeStore('Unrelated Reviews', false);
        $this->signInStoreMember($otherOwner);
        $this->getJson('/api/v1/vendor/reviews/'.$reviewId)->assertNotFound();
        $this->get($detail['media'][1]['url'])->assertNotFound();
        $member = $this->teamMember($store, 'CUSTOMER_SERVICE');
        $this->signInStoreMember($member);
        $this->getJson('/api/v1/vendor/reviews/'.$reviewId)->assertOk();
        DB::table('vendor_memberships')->where('user_id', $member->id)->update(['role' => 'INVENTORY']);
        $this->getJson('/api/v1/vendor/reviews/'.$reviewId)->assertForbidden();
        $this->get($detail['media'][0]['url'])->assertNotFound();

        $this->signInStoreMember($owner);
        foreach (['HIDDEN_PENDING_REVIEW', 'CORRECTION_REQUESTED', 'REMOVED'] as $state) {
            DB::table('reviews')->where('id', $reviewId)->update(['moderation_state' => $state]);
            $this->getJson('/api/v1/vendor/reviews/'.$reviewId)->assertNotFound();
            $this->get($detail['media'][1]['url'])->assertNotFound();
            $this->getJson('/api/v1/vendor/reviews?type=PRODUCT&listing_id='.$listing)->assertOk()->assertJsonPath('meta.summary.count', 0);
        }
    }

    public function test_vendor_review_product_summary_uses_all_visible_rows_before_pagination_and_scopes_dates(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Review Summary');
        $buyer = $this->buyer();
        $profile = $this->buyerProfileId($buyer);
        $today = CarbonImmutable::now('Asia/Manila')->startOfDay();
        for ($index = 0; $index < 23; $index++) {
            $this->ratedOrder($store, $profile, (int) $buyer->id, 5, 4, $index < 21 ? 5 : 1, $index < 21 ? $today->addHours(10) : $today->subDay(), $listing);
        }
        $otherListing = $this->orderListingFor($owner, 'OTHER-REVIEW');
        $this->ratedOrder($store, $profile, (int) $buyer->id, 5, 5, 2, $today, $otherListing);
        $this->signInStoreMember($owner);
        $url = '/api/v1/vendor/reviews?type=PRODUCT&listing_id='.$listing;
        $first = $this->getJson($url)->assertOk()->assertJsonPath('meta.total', 23)->assertJsonPath('meta.summary.count', 23)
            ->assertJsonPath('meta.summary.average', 4.65)->assertJsonPath('meta.summary.distribution', [
                ['stars' => 5, 'count' => 21], ['stars' => 4, 'count' => 0], ['stars' => 3, 'count' => 0], ['stars' => 2, 'count' => 0], ['stars' => 1, 'count' => 2],
            ]);
        self::assertCount(20, $first->json('data'));
        self::assertCount(3, $this->getJson($url.'&page=2')->assertOk()->assertJsonPath('meta.summary.count', 23)->json('data'));
        $this->getJson($url.'&from='.$today->toDateString().'&to='.$today->toDateString())->assertOk()->assertJsonPath('meta.total', 21)->assertJsonPath('meta.summary.count', 21)->assertJsonPath('meta.summary.average', 5);
        $this->getJson($url.'&from='.$today->addDay()->toDateString())->assertOk()->assertJsonPath('meta.summary.count', 0)->assertJsonPath('meta.summary.average', null);
        DB::table('vendor_listings')->where('id', $listing)->update(['status' => 'INACTIVE']);
        $this->getJson($url)->assertOk()->assertJsonPath('meta.summary.count', 23);
        $this->getJson('/api/v1/vendor/reviews?listing_id='.$listing)->assertUnprocessable();
        $this->getJson('/api/v1/vendor/reviews?type=BUYER&listing_id='.$listing)->assertUnprocessable();
        $this->getJson('/api/v1/vendor/reviews?type=PRODUCT&listing_id=invalid')->assertUnprocessable();
        $this->getJson('/api/v1/vendor/reviews?type=PRODUCT&listing_id=')->assertUnprocessable();
        $this->getJson('/api/v1/vendor/reviews?type=PRODUCT&listing_id='.Str::uuid7())->assertNotFound();
        [, $otherOwner] = $this->activeStore('Different Review Store', false);
        $this->signInStoreMember($otherOwner);
        $this->getJson($url)->assertNotFound();
    }

    public function test_vendor_review_detail_and_summary_withhold_disputes_exclusions_and_unrevealed_reviews(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Review Visibility');
        $buyer = $this->buyer();
        $orderId = $this->ratedOrder($store, $this->buyerProfileId($buyer), (int) $buyer->id, 4, 4, 5, CarbonImmutable::now(), $listing);
        $reviewId = (string) DB::table('reviews')->where('order_id', $orderId)->where('review_type', 'PRODUCT')->value('id');
        $this->signInStoreMember($owner);
        $detail = '/api/v1/vendor/reviews/'.$reviewId;
        $list = '/api/v1/vendor/reviews?type=PRODUCT&listing_id='.$listing;
        $this->getJson($detail)->assertOk();
        $this->getJson($list)->assertJsonPath('meta.summary.count', 1);
        DB::table('reviews')->where('id', $reviewId)->update(['revealed_at' => null]);
        $this->getJson($detail)->assertNotFound();
        $this->getJson($list)->assertJsonPath('meta.summary.count', 0);
        DB::table('reviews')->where('id', $reviewId)->update(['revealed_at' => now()]);
        $case = (string) Str::uuid7();
        DB::table('dispute_cases')->insert(['id' => $case, 'reference' => 'CASE-REVIEW-VISIBILITY', 'order_id' => $orderId, 'vendor_organization_id' => $store->id,
            'status' => 'OPEN_AWAITING_RESPONSE', 'filed_by_party' => 'BUYER', 'responding_party' => 'VENDOR', 'description' => 'The materials were damaged on arrival.',
            'issue_type' => 'DEFECTIVE', 'requested_remedy' => 'REPLACEMENT', 'response_due_at' => now()->addDays(2), 'created_at' => now(), 'updated_at' => now()]);
        $this->getJson($detail)->assertNotFound();
        $this->getJson($list)->assertJsonPath('meta.summary.count', 0);
        DB::table('dispute_cases')->where('id', $case)->update(['status' => 'RESOLVED']);
        $this->getJson($detail)->assertOk();
        DB::table('score_exclusions')->insert(['id' => (string) Str::uuid7(), 'order_id' => $orderId, 'vendor_organization_id' => $store->id, 'reason_code' => 'TEST',
            'note' => 'Exclude this fixture from public score inputs.', 'created_by_user_id' => $owner->id, 'created_role' => 'ADMIN_SUPERADMIN', 'created_at' => now(), 'updated_at' => now()]);
        $this->getJson($detail)->assertNotFound();
        $this->getJson($list)->assertJsonPath('meta.summary.count', 0);
    }

    public function test_blind_reveal_edit_lock_party_separation_and_no_vendor_delete(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Review Store');
        [$buyer, $orderId] = $this->pickupOrder($store, $listing);
        $this->signInBuyer($buyer);
        $this->getJson('/api/v1/buyers/orders/'.$orderId.'/reviews')->assertOk()->assertJsonPath('data.state', 'NOT_COMPLETED');
        $this->submitBuyer($orderId, ['vendor_rating' => ['service_quality' => 5, 'speed_rating' => 4]])->assertStatus(409)->assertJsonPath('errors.0.code', 'REVIEW_NOT_ELIGIBLE');

        $completed = $this->complete($orderId);
        $line = (string) DB::table('order_lines')->where('order_id', $orderId)->value('id');
        $view = $this->getJson('/api/v1/buyers/orders/'.$orderId.'/reviews')->assertOk()->json('data');
        self::assertSame('OPEN', $view['state']);
        self::assertSame($completed->addDays(14)->toIso8601String(), $view['closes_at']);
        self::assertSame('Processing Speed', $view['speed_label']);
        $key = (string) Str::uuid7();
        $body = ['vendor_rating' => ['service_quality' => 5, 'speed_rating' => 4, 'comment' => 'Fast and clear.'], 'product_reviews' => [['order_line_id' => $line, 'rating' => 5, 'comment' => 'Solid blocks.']]];
        $this->submitBuyer($orderId, $body, 'VERIFIED_BUYER', $key)->assertCreated();
        $this->submitBuyer($orderId, $body, 'VERIFIED_BUYER', $key)->assertCreated();
        self::assertSame(2, DB::table('reviews')->where('order_id', $orderId)->count(), 'An idempotent replay creates nothing.');
        $this->submitBuyer($orderId, ['vendor_rating' => ['service_quality' => 1, 'speed_rating' => 1]])->assertStatus(409)->assertJsonPath('errors.0.code', 'REVIEW_ALREADY_SUBMITTED');

        // Hidden from the Vendor and the public until the Vendor submits too.
        $this->signInStoreMember($owner);
        self::assertSame([], $this->getJson('/api/v1/vendor/orders/'.$orderId.'/reviews')->assertOk()->json('data.received'));
        $other = $this->buyer();
        $this->getJson('/api/v1/buyers/listings/'.$listing.'/reviews')->assertOk()->assertJsonPath('meta.summary.count', 0);

        foreach (['INVENTORY', 'FULFILLMENT'] as $role) {
            $this->signInStoreMember($this->teamMember($store, $role));
            $this->postJson('/api/v1/vendor/orders/'.$orderId.'/buyer-rating', ['inquiry_seriousness' => 5, 'communication_quality' => 5, 'payment_reliability' => 5], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(403);
        }
        $service = $this->teamMember($store, 'CUSTOMER_SERVICE');
        $this->signInStoreMember($service);
        $vendorView = $this->postJson('/api/v1/vendor/orders/'.$orderId.'/buyer-rating', ['inquiry_seriousness' => 5, 'communication_quality' => 4, 'payment_reliability' => 5], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertCreated()->json('data');
        self::assertTrue($vendorView['revealed']);
        self::assertSame('BOTH_SUBMITTED', $vendorView['reveal_reason']);
        self::assertCount(2, $vendorView['received']);
        self::assertStringNotContainsString((string) $buyer->email, json_encode($vendorView, JSON_THROW_ON_ERROR));

        $this->signInBuyer($other);
        $public = $this->getJson('/api/v1/buyers/listings/'.$listing.'/reviews')->assertOk();
        $public->assertJsonPath('meta.summary.count', 1)->assertJsonPath('data.0.display_name', 'Verified Buyer')->assertJsonPath('data.0.verified_purchase', true);
        self::assertArrayNotHasKey('reviewer_user_id', $public->json('data.0'));
        $this->getJson('/api/v1/buyers/stores/'.$store->id.'/reviews')->assertOk()->assertJsonPath('meta.summary.count', 1)->assertJsonPath('meta.scores.label', ScoreRules::NEW_VENDOR_LABEL);
        $this->signInBuyer($buyer);
        self::assertSame(4, $this->getJson('/api/v1/buyers/orders/'.$orderId.'/reviews')->json('data.counterpart_rating.ratings.communication_quality'));

        // 24-hour correction: one second before is allowed, the exact instant is locked.
        $review = DB::table('reviews')->where('order_id', $orderId)->where('review_type', 'VENDOR')->first();
        $this->freeze(CarbonImmutable::parse((string) $review->submitted_at)->addHours(24)->subSecond());
        $this->signInBuyer($buyer);
        $this->patchJson('/api/v1/buyers/reviews/'.$review->id, ['lock_version' => 1, 'service_quality' => 4])->assertOk();
        $this->freeze(CarbonImmutable::parse((string) $review->submitted_at)->addHours(24));
        $this->signInBuyer($buyer);
        $this->patchJson('/api/v1/buyers/reviews/'.$review->id, ['lock_version' => 2, 'service_quality' => 3])->assertStatus(409)->assertJsonPath('errors.0.code', 'REVIEW_LOCKED');
        self::assertSame(2, DB::table('review_revisions')->where('review_id', $review->id)->count());

        // No Vendor delete path exists and the database refuses any deletion or revision rewrite.
        $this->signInStoreMember($owner);
        $this->deleteJson('/api/v1/vendor/reviews/'.$review->id)->assertStatus(405);
        $this->expectRefused(fn () => DB::table('reviews')->where('id', $review->id)->delete());
        $this->expectRefused(fn () => DB::table('review_revisions')->where('review_id', $review->id)->update(['reason' => 'EDITED']));
    }

    public function test_window_expiry_reveals_and_closes_and_active_dispute_withholds_publication(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Window Store');
        [$buyer, $orderId] = $this->pickupOrder($store, $listing);
        $completed = $this->complete($orderId);
        $this->freeze($completed);
        $this->signInBuyer($buyer);
        $this->submitBuyer($orderId, ['vendor_rating' => ['service_quality' => 4, 'speed_rating' => 4]])->assertCreated();
        $line = (string) DB::table('order_lines')->where('order_id', $orderId)->value('id');

        $this->freeze($completed->addDays(14)->subSecond());
        self::assertSame(0, app(ReviewService::class)->sweep()['revealed']);
        $this->signInBuyer($buyer);
        $this->submitBuyer($orderId, ['product_reviews' => [['order_line_id' => $line, 'rating' => 4]]])->assertCreated();
        $this->freeze($completed->addDays(14));
        self::assertSame(1, app(ReviewService::class)->sweep()['revealed']);
        self::assertSame('WINDOW_EXPIRED', DB::table('review_windows')->where('order_id', $orderId)->value('reveal_reason'));
        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/vendor/orders/'.$orderId.'/buyer-rating', ['inquiry_seriousness' => 5, 'communication_quality' => 5, 'payment_reliability' => 5], ['Idempotency-Key' => (string) Str::uuid7()])
            ->assertStatus(409)->assertJsonPath('errors.0.code', 'REVIEW_WINDOW_CLOSED');

        $viewer = $this->buyer();
        $this->getJson('/api/v1/buyers/listings/'.$listing.'/reviews')->assertJsonPath('meta.summary.count', 1);
        // A directly related active dispute withholds publication and score use without deleting anything.
        $caseId = (string) Str::uuid7();
        DB::table('dispute_cases')->insert(['id' => $caseId, 'reference' => 'CASE-TEST-1', 'order_id' => $orderId, 'vendor_organization_id' => $store->id, 'status' => 'OPEN_AWAITING_RESPONSE', 'filed_by_party' => 'BUYER', 'responding_party' => 'VENDOR', 'description' => 'Several blocks arrived cracked and unusable.',
            'issue_type' => 'DEFECTIVE', 'requested_remedy' => 'REPLACEMENT', 'response_due_at' => now()->addDays(2), 'created_at' => now(), 'updated_at' => now()]);
        $this->signInBuyer($viewer);
        $this->getJson('/api/v1/buyers/listings/'.$listing.'/reviews')->assertJsonPath('meta.summary.count', 0);
        $this->signInBuyer($buyer);
        $this->getJson('/api/v1/buyers/orders/'.$orderId.'/reviews')->assertJsonPath('data.withheld_for_dispute', true)->assertJsonPath('data.vendor_rating.visibility', 'WITHHELD_ACTIVE_DISPUTE');
        DB::table('dispute_cases')->where('id', $caseId)->update(['status' => 'RESOLVED']);
        $this->signInBuyer($viewer);
        $this->getJson('/api/v1/buyers/listings/'.$listing.'/reviews')->assertJsonPath('meta.summary.count', 1);
        self::assertSame(2, DB::table('reviews')->where('order_id', $orderId)->count());
    }

    public function test_moderation_actions_correction_window_history_and_admin_roles(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Moderation Store');
        [$buyer, $orderId] = $this->pickupOrder($store, $listing);
        $this->complete($orderId);
        $line = (string) DB::table('order_lines')->where('order_id', $orderId)->value('id');
        $this->signInBuyer($buyer);
        $this->submitBuyer($orderId, ['product_reviews' => [['order_line_id' => $line, 'rating' => 1, 'comment' => 'Call me at 0917 000 0000']]])->assertCreated();
        $review = DB::table('reviews')->where('order_id', $orderId)->first();
        DB::table('review_windows')->where('order_id', $orderId)->update(['revealed_at' => now(), 'reveal_reason' => 'BOTH_SUBMITTED']);
        DB::table('reviews')->where('id', $review->id)->update(['revealed_at' => now()]);

        $this->signInStoreMember($owner);
        $this->postJson('/api/v1/vendor/reviews/'.$review->id.'/flags', ['reason_code' => 'PERSONAL_INFORMATION'], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated();
        self::assertSame('FLAGGED', DB::table('reviews')->where('id', $review->id)->value('moderation_state'));
        $this->signInBuyer($this->buyer());
        $this->getJson('/api/v1/buyers/listings/'.$listing.'/reviews')->assertJsonPath('meta.summary.count', 1);

        foreach (['ADMIN_SUPPORT', 'ADMIN_ORDER_DISPUTE', 'ADMIN_PRODUCT_COMPLIANCE'] as $role) {
            $this->signInAdmin($this->admin($role));
            $this->getJson('/api/v1/admin/reviews')->assertStatus(403);
        }
        $moderator = $this->admin('ADMIN_USER_MANAGEMENT');
        $this->signInAdmin($moderator);
        self::assertSame((string) $review->id, $this->getJson('/api/v1/admin/reviews')->assertOk()->json('data.0.id'));
        $this->moderate((string) $review->id, 'REQUEST_CORRECTION', 2)->assertOk()->assertJsonPath('data.moderation_state', 'CORRECTION_REQUESTED');
        $this->signInBuyer($this->buyer());
        $this->getJson('/api/v1/buyers/listings/'.$listing.'/reviews')->assertJsonPath('meta.summary.count', 0);

        // One correction within 7 days, then the review returns to the queue still hidden.
        $this->freeze(CarbonImmutable::parse((string) DB::table('reviews')->where('id', $review->id)->value('correction_due_at'))->subSecond());
        $this->signInBuyer($buyer);
        $this->patchJson('/api/v1/buyers/reviews/'.$review->id, ['lock_version' => 3, 'comment' => 'Blocks arrived cracked.'])->assertOk();
        self::assertSame('HIDDEN_PENDING_REVIEW', DB::table('reviews')->where('id', $review->id)->value('moderation_state'));
        $this->patchJson('/api/v1/buyers/reviews/'.$review->id, ['lock_version' => 4, 'comment' => 'Again'])->assertStatus(409);
        $this->signInAdmin($moderator);
        $this->moderate((string) $review->id, 'RESTORE', 4)->assertOk()->assertJsonPath('data.moderation_state', 'NONE');
        $this->moderate((string) $review->id, 'REMOVE', 5)->assertOk()->assertJsonPath('data.moderation_state', 'REMOVED');
        $this->moderate((string) $review->id, 'RESTORE', 6)->assertStatus(409)->assertJsonPath('errors.0.code', 'MODERATION_ACTION_UNAVAILABLE');
        $history = $this->getJson('/api/v1/admin/reviews/'.$review->id)->assertOk()->json('data');
        self::assertSame(['FLAG_RAISED', 'REQUEST_CORRECTION', 'CORRECTION_SUBMITTED', 'RESTORE', 'REMOVE'], array_column($history['history'], 'action'));
        self::assertSame('Call me at 0917 000 0000', $history['revisions'][0]['content']['comment'], 'The original content is preserved for audit.');
        $this->expectRefused(fn () => DB::table('review_moderation')->where('review_id', $review->id)->delete());

        // An unused correction window closes after 7 days.
        [, , $listing2] = [$store, $owner, $this->orderListingFor($owner, 'MOD-2')];
        [$buyer2, $order2] = $this->pickupOrder($store, $listing2);
        $this->complete($order2);
        $this->signInBuyer($buyer2);
        $this->submitBuyer($order2, ['vendor_rating' => ['service_quality' => 2, 'speed_rating' => 2, 'comment' => 'rude words']])->assertCreated();
        $second = DB::table('reviews')->where('order_id', $order2)->first();
        $this->signInAdmin($moderator);
        $this->moderate((string) $second->id, 'REQUEST_CORRECTION', 1)->assertOk();
        $this->freeze(CarbonImmutable::parse((string) DB::table('reviews')->where('id', $second->id)->value('correction_due_at')));
        $this->signInBuyer($buyer2);
        $this->patchJson('/api/v1/buyers/reviews/'.$second->id, ['lock_version' => 2, 'comment' => 'late'])->assertStatus(409)->assertJsonPath('errors.0.code', 'REVIEW_CORRECTION_CLOSED');
    }

    public function test_score_sample_gates_windows_ohs_weekly_carry_replay_and_exclusion(): void
    {
        [$store] = $this->activeStore('Score Store', false);
        $buyer = $this->buyer();
        $profile = $this->buyerProfileId($buyer);
        // Two consecutive Mondays at 00:30 Asia/Manila; each window ends at that Monday's local midnight.
        $monday = CarbonImmutable::parse('next monday', 'Asia/Manila')->setTime(0, 30);
        $e1 = $monday->startOfDay();
        $e2 = $e1->addWeek();
        $rated = [];
        for ($i = 0; $i < 5; $i++) {
            $rated[] = $this->ratedOrder($store, $profile, (int) $buyer->id, 5, 4, $i < 4 ? 5 : null, $e1->subDays(10 + $i));
        }
        $this->freeze($monday);
        $scores = app(ScoreSnapshotService::class);
        $scores->run(CarbonImmutable::now());
        $snapshot = DB::table('score_snapshots')->where('vendor_organization_id', $store->id)->first();
        self::assertNull($snapshot->mqs, 'Four product ratings stay below the MQS gate.');
        self::assertNull($snapshot->vcs, 'VCS needs an eligible MQS too.');
        self::assertNull($snapshot->ohs);
        self::assertSame(ScoreRules::NEW_VENDOR_LABEL, app(PublicScores::class)->forOrganization($store->id)['label']);
        self::assertSame(5, json_decode((string) $snapshot->sample_counts, true)['vendor_ratings']);
        self::assertSame(0, $scores->run(CarbonImmutable::now())['snapshots'], 'A replay of the same day writes nothing.');

        // For the second Monday: exactly end − 90 days is inside the window, one second earlier is outside.
        $this->ratedOrder($store, $profile, (int) $buyer->id, 5, 4, 5, $e2->subDays(90));
        $this->ratedOrder($store, $profile, (int) $buyer->id, 1, 1, 1, $e2->subDays(90)->subSecond());
        // Ten confirmed orders in the trailing 30 days and one Vendor-caused cancellation: NFR 10.00% → 0.75.
        $orders = [];
        for ($i = 0; $i < 10; $i++) {
            $orders[] = $this->bareOrder($store, $profile, 'CONFIRMED');
            $this->metric($store->id, 'ORDER_CONFIRMED', $orders[$i], $orders[$i], $e2->subDays(9));
        }
        $this->metric($store->id, 'VENDOR_NON_FULFILLMENT', (string) Str::uuid7(), $orders[0], $e2->subDays(8));
        $this->freeze($monday->addWeek());
        $scores->run(CarbonImmutable::now());
        $week2 = DB::table('score_snapshots')->where('vendor_organization_id', $store->id)->orderByDesc('window_ends_on')->first();
        self::assertSame(5, json_decode((string) $week2->sample_counts, true)['product_ratings']);
        self::assertSame('5.00', (string) $week2->mqs);
        self::assertSame('4.67', (string) $week2->vcs, '(5 + 4 + 5) / 3; the 1-star rating one second outside the window is ignored.');
        self::assertSame('4.25', (string) $week2->ohs, '5.00 − 0.75 NFR penalty.');
        self::assertSame('4.46', (string) $week2->vps, '4.6666… × 0.5 + 4.25 × 0.5 = 4.4583… → 4.46');
        self::assertSame('10.00', json_decode((string) $week2->components, true)['operations']['rates']['NFR']);

        // Tuesday carries Monday's OHS forward although a new defect event arrived.
        $this->metric($store->id, 'ORDER_DEFECT', (string) Str::uuid7(), $orders[1], $e2->addHours(5));
        $this->freeze($monday->addWeek()->addDay());
        $scores->run(CarbonImmutable::now());
        $tuesday = DB::table('score_snapshots')->where('vendor_organization_id', $store->id)->orderByDesc('window_ends_on')->first();
        self::assertSame('4.25', (string) $tuesday->ohs);
        self::assertFalse(json_decode((string) $tuesday->components, true)['ohs_recalculated']);
        self::assertSame((string) $week2->ohs_calculated_on, (string) $tuesday->ohs_calculated_on);

        // An Admin exclusion removes the excluded order's ratings from later snapshots; it is reversible and audited.
        $this->signInAdmin($this->admin('ADMIN_USER_MANAGEMENT'));
        $this->postJson('/api/v1/admin/scores/'.$store->id.'/exclusions', ['order_id' => $rated[0], 'reason_code' => 'DUPLICATE', 'note' => 'Duplicate test purchase.'], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated();
        $this->freeze($monday->addWeek()->addDays(2));
        $scores->run(CarbonImmutable::now());
        $excluded = DB::table('score_snapshots')->where('vendor_organization_id', $store->id)->orderByDesc('window_ends_on')->first();
        self::assertSame(3, json_decode((string) $excluded->sample_counts, true)['product_ratings']);
        self::assertNull($excluded->mqs);
        self::assertTrue(DB::table('audit_logs')->where('action', 'SCORE_SOURCE_EXCLUDED')->exists());
        $this->signInAdmin($this->admin('ADMIN_ORDER_DISPUTE'));
        $this->getJson('/api/v1/admin/scores/'.$store->id)->assertOk()->assertJsonPath('data.can_investigate', false);
        $this->postJson('/api/v1/admin/scores/'.$store->id.'/exclusions', ['order_id' => $orders[2], 'reason_code' => 'FRAUD', 'note' => 'Not permitted for this role.'], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(403);
        $this->expectRefused(fn () => DB::table('score_snapshots')->where('vendor_organization_id', $store->id)->update(['vps' => '5.00']));
    }

    public function test_inquiry_crr_edges_badges_award_remove_and_suppression_without_manual_award(): void
    {
        [$store, $owner] = $this->activeStore('Responder Store', false);
        $buyer = $this->buyer();
        $profile = $this->buyerProfileId($buyer);
        $conversation = (string) Str::uuid7();
        DB::table('conversations')->insert(['id' => $conversation, 'buyer_profile_id' => $profile, 'vendor_organization_id' => $store->id, 'context_type' => 'ITEM_BASED', 'purpose' => 'SALES', 'state' => 'ACTIVE', 'created_at' => now(), 'updated_at' => now()]);
        $start = CarbonImmutable::now()->subDays(20)->setTime(1, 0);
        // Ten inquiries: nine answered by a person within 12 h (one at exactly 12 h), one answered 12 h + 1 s later.
        for ($i = 0; $i < 10; $i++) {
            $at = $start->addDays($i);
            $this->message($conversation, (int) $buyer->id, $at, 'TEXT');
            $this->message($conversation, (int) $buyer->id, $at->addMinutes(5), 'TEXT');
            $this->message($conversation, (int) $owner->id, $at->addMinute(), 'SYSTEM');
            $this->message($conversation, (int) $owner->id, $at->addHours(12)->addSeconds($i === 9 ? 1 : ($i === 0 ? 0 : -60)), 'TEXT');
        }
        // A pending inquiry under 12 hours old is not counted yet.
        $this->message($conversation, (int) $buyer->id, CarbonImmutable::now()->subHours(2), 'TEXT');
        $projected = app(MetricEventProjector::class)->project(CarbonImmutable::now());
        self::assertSame(10, $projected['INQUIRY']);
        self::assertSame(9, (int) DB::table('metric_events')->where('metric', 'INQUIRY')->sum('value'));
        self::assertSame(0, app(MetricEventProjector::class)->project(CarbonImmutable::now())['INQUIRY'], 'Replays insert nothing.');
        // The pending inquiry is answered by a person within 12 hours, so the daily run records it as answered.
        $this->message($conversation, (int) $owner->id, CarbonImmutable::now()->subHour(), 'TEXT');

        $this->freeze(CarbonImmutable::now('Asia/Manila')->addDay()->setTime(0, 30));
        app(ScoreSnapshotService::class)->run(CarbonImmutable::now());
        self::assertSame('90.91', (string) DB::table('score_snapshots')->where('vendor_organization_id', $store->id)->value('crr'));
        $badges = app(PublicScores::class)->forOrganization($store->id)['badges'];
        self::assertSame(['FAST_RESPONDER'], array_column($badges, 'code'));

        // Suppression hides the badge for a documented case; there is no manual award route.
        $this->signInAdmin($this->admin('ADMIN_ORDER_DISPUTE'));
        $this->postJson('/api/v1/admin/scores/'.$store->id.'/badge-suppressions', ['badge_code' => 'FAST_RESPONDER', 'reason_code' => 'FRAUD', 'case_reference' => 'CASE-9', 'note' => 'Documented fraud review.'], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(403);
        $this->signInAdmin($this->admin('ADMIN_USER_MANAGEMENT'));
        $this->postJson('/api/v1/admin/scores/'.$store->id.'/badges', ['badge_code' => 'TRUSTED_SUPPLIER'], ['Idempotency-Key' => (string) Str::uuid7()])->assertNotFound();
        $this->postJson('/api/v1/admin/scores/'.$store->id.'/badge-suppressions', ['badge_code' => 'FAST_RESPONDER', 'reason_code' => 'OTHER', 'case_reference' => 'CASE-9', 'note' => 'Documented fraud review.'], ['Idempotency-Key' => (string) Str::uuid7()])->assertStatus(422);
        $this->postJson('/api/v1/admin/scores/'.$store->id.'/badge-suppressions', ['badge_code' => 'FAST_RESPONDER', 'reason_code' => 'FRAUD', 'case_reference' => 'CASE-9', 'note' => 'Documented fraud review.'], ['Idempotency-Key' => (string) Str::uuid7()])->assertCreated();
        self::assertSame([], app(PublicScores::class)->forOrganization($store->id)['badges']);
        $this->signInStoreMember($owner);
        $performance = $this->getJson('/api/v1/vendor/performance')->assertOk()->json('data');
        self::assertSame('SUPPRESSED', collect($performance['badges'])->firstWhere('code', 'FAST_RESPONDER')['status']);
        self::assertArrayNotHasKey('case_reference', collect($performance['badges'])->firstWhere('code', 'FAST_RESPONDER')['suppression']);
        foreach (['STORE_STAFF', 'CUSTOMER_SERVICE', 'INVENTORY', 'FULFILLMENT'] as $role) {
            $this->signInStoreMember($this->teamMember($store, $role));
            $this->getJson('/api/v1/vendor/performance')->assertStatus(403);
        }

        // Criteria stop holding → the award is removed automatically, never deleted.
        DB::table('messages')->where('conversation_id', $conversation)->count();
        $this->freeze(CarbonImmutable::now()->addDays(31));
        app(ScoreSnapshotService::class)->run(CarbonImmutable::now());
        self::assertSame('CRITERIA_NOT_MET', DB::table('vendor_badge_history')->where('vendor_organization_id', $store->id)->value('revocation_reason'));
        self::assertSame(1, DB::table('vendor_badge_history')->where('vendor_organization_id', $store->id)->count());
    }

    public function test_milestones_and_dispute_findings_project_lsr_frr_and_defect_events(): void
    {
        [$store] = $this->activeStore('Fulfillment Store', false);
        $profile = $this->buyerProfileId($this->buyer());
        $onTime = $this->bareOrder($store, $profile, 'COMPLETED', CarbonImmutable::now('Asia/Manila')->toDateString());
        $late = $this->bareOrder($store, $profile, 'COMPLETED', CarbonImmutable::now('Asia/Manila')->subDays(2)->toDateString());
        foreach ([$onTime, $late] as $orderId) {
            $fulfillment = (string) Str::uuid7();
            DB::table('fulfillments')->insert(['id' => $fulfillment, 'order_id' => $orderId, 'state' => 'READY_FOR_PICKUP', 'created_at' => now(), 'updated_at' => now()]);
            DB::table('fulfillment_milestones')->insert(['id' => (string) Str::uuid7(), 'fulfillment_id' => $fulfillment, 'order_id' => $orderId, 'event_type' => 'READY_FOR_PICKUP', 'occurred_at' => now()->subHour(), 'created_at' => now(), 'updated_at' => now()]);
        }
        app(MetricEventProjector::class)->project(CarbonImmutable::now());
        self::assertSame('1', $this->metricValue('ORDER_FULFILLED', $onTime));
        self::assertSame('0', $this->metricValue('ORDER_FULFILLED', $late));
        self::assertSame('1', $this->metricValue('FULFILLMENT_DISPATCHED', $late), 'Made ready after the Vendor-confirmed date counts toward LSR.');
        self::assertSame('0', $this->metricValue('FULFILLMENT_DISPATCHED', $onTime));
    }

    private function metricValue(string $metric, string $orderId): string
    {
        return bcadd((string) DB::table('metric_events')->where('metric', $metric)->where('order_id', $orderId)->value('value'), '0', 0);
    }

    private function orderListingFor(User $owner, string $sku): string
    {
        $this->signInStoreMember($owner);

        return $this->orderListing($sku.'-'.Str::upper(Str::random(3)));
    }

    private function complete(string $orderId): CarbonImmutable
    {
        $now = CarbonImmutable::now()->startOfSecond();
        DB::table('orders')->where('id', $orderId)->update(['order_state' => 'COMPLETED', 'closed_at' => $now, 'updated_at' => $now]);

        return $now;
    }

    /** @param array<string, mixed> $body */
    private function submitBuyer(string $orderId, array $body, string $choice = 'FIRST_NAME_LAST_INITIAL', ?string $key = null): TestResponse
    {
        return $this->postJson('/api/v1/buyers/orders/'.$orderId.'/reviews', ['display_name_choice' => $choice] + $body, ['Idempotency-Key' => $key ?? (string) Str::uuid7()]);
    }

    private function moderate(string $reviewId, string $action, int $lockVersion): TestResponse
    {
        return $this->postJson('/api/v1/admin/reviews/'.$reviewId.'/moderation', ['action' => $action, 'reason' => 'Guideline review recorded for audit.', 'lock_version' => $lockVersion], ['Idempotency-Key' => (string) Str::uuid7()]);
    }

    private function bareOrder(VendorOrganization $store, string $profile, string $state, ?string $expected = null): string
    {
        $id = (string) Str::uuid7();
        DB::table('orders')->insert(['id' => $id, 'reference' => 'ORD-'.Str::upper(Str::random(10)), 'buyer_profile_id' => $profile, 'vendor_organization_id' => $store->id, 'procurement_type' => 'ITEM_BASED',
            'order_state' => $state, 'fulfillment_method' => 'PICKUP', 'payment_method' => 'ONLINE', 'commercial_total_centavos' => 1000, 'materials_centavos' => 1000, 'expected_fulfillment_date' => $expected,
            'closed_at' => $state === 'COMPLETED' ? now() : null, 'created_at' => now(), 'updated_at' => now()]);

        return $id;
    }

    private function ratedOrder(VendorOrganization $store, string $profile, int $userId, int $service, int $speed, ?int $quality, CarbonImmutable $submittedAt, ?string $listingId = null): string
    {
        $orderId = $this->bareOrder($store, $profile, 'COMPLETED');
        $base = ['order_id' => $orderId, 'reviewer_user_id' => $userId, 'reviewer_party' => 'BUYER', 'reviewer_role' => 'BUYER', 'vendor_organization_id' => $store->id, 'buyer_profile_id' => $profile,
            'submitted_at' => $submittedAt->setTimezone('UTC'), 'editable_until' => $submittedAt->setTimezone('UTC')->addHours(24), 'revealed_at' => $submittedAt->setTimezone('UTC'), 'created_at' => now(), 'updated_at' => now()];
        DB::table('reviews')->insert($base + ['id' => (string) Str::uuid7(), 'review_type' => 'VENDOR', 'service_quality' => $service, 'speed_rating' => $speed, 'speed_kind' => 'PROCESSING_SPEED']);
        if ($quality !== null) {
            $listing = $listingId ?? DB::table('vendor_listings')->where('vendor_organization_id', $store->id)->value('id') ?? $this->fixtureListing($store);
            $variant = (string) DB::table('listing_variants')->where('vendor_listing_id', $listing)->value('id');
            $lineId = (string) Str::uuid7();
            DB::table('order_lines')->insert(['id' => $lineId, 'order_id' => $orderId, 'listing_variant_id' => $variant, 'unit_id' => DB::table('listing_variants')->where('id', $variant)->value('unit_id'),
                'quantity' => '1', 'unit_price_centavos' => 1000, 'payable_centavos' => 1000, 'tax_category' => 'NON_VAT', 'created_at' => now(), 'updated_at' => now()]);
            DB::table('reviews')->insert($base + ['id' => (string) Str::uuid7(), 'review_type' => 'PRODUCT', 'rating' => $quality, 'order_line_id' => $lineId, 'vendor_listing_id' => $listing]);
        }

        return $orderId;
    }

    private function fixtureListing(VendorOrganization $store): string
    {
        $owner = User::query()->findOrFail(DB::table('vendor_memberships')->where('vendor_organization_id', $store->id)->where('role', 'OWNER')->value('user_id'));
        $this->signInStoreMember($owner);

        return $this->orderListing('SCORE-'.Str::upper(Str::random(4)));
    }

    private function metric(string $organizationId, string $metric, string $sourceId, string $orderId, CarbonImmutable $at, ?string $override = null): void
    {
        DB::table('metric_events')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'metric' => $override === null ? $metric : 'ORDER_CONFIRMED', 'source_id' => $override === null ? $sourceId : (string) Str::uuid7(),
            'order_id' => $orderId, 'occurred_at' => $at->setTimezone('UTC'), 'value' => '1', 'source_kind' => 'TEST_FIXTURE', 'created_at' => now(), 'updated_at' => now()]);
    }

    private function message(string $conversationId, int $senderId, CarbonImmutable $at, string $kind): void
    {
        DB::table('messages')->insert(['id' => (string) Str::uuid7(), 'conversation_id' => $conversationId, 'sender_user_id' => $senderId, 'client_message_id' => (string) Str::uuid7(), 'body' => $kind === 'SYSTEM' ? 'Thanks, we received your message.' : 'Message',
            'sent_at' => $at->setTimezone('UTC'), 'kind' => $kind, 'created_at' => now(), 'updated_at' => now()]);
    }

    private function freeze(CarbonImmutable $instant): void
    {
        CarbonImmutable::setTestNow($instant);
        Carbon::setTestNow(Carbon::instance($instant->toDateTime()));
    }

    private function expectRefused(callable $mutation): void
    {
        try {
            DB::transaction($mutation);
            self::fail('The protected history accepted a mutation.');
        } catch (QueryException $exception) {
            self::assertMatchesRegularExpression('/append-only|never deleted|retained/', $exception->getMessage());
        }
    }

    private function admin(string $role): User
    {
        $user = User::factory()->create(['account_type' => 'ADMIN', 'account_status' => 'ACTIVE', 'email_verified_at' => now()]);
        DB::table('admin_memberships')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'platform_role_id' => DB::table('platform_roles')->where('code', $role)->value('id'), 'status' => 'ACTIVE', 'created_at' => now(), 'updated_at' => now()]);
        DB::table('totp_factors')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'encrypted_secret' => Crypt::encryptString('PHASE14ADMINSECRET'), 'confirmed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);

        return $user;
    }

    private function signInAdmin(User $user): void
    {
        $tokens = app(TokenSessionService::class)->start($user, 'WEB', null, null, null);
        $session = AuthSession::query()->findOrFail($tokens->sessionId);
        $session->update(['reauthenticated_at' => now(), 'reauthentication_method' => 'PASSWORD_TOTP']);
        $user->withAccessToken(new AccessToken(['oauth_access_token_id' => $session->oauth_access_token_id, 'oauth_scopes' => ['ADMIN']]));
        $this->actingAs($user, 'api');
    }
}
