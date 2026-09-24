<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

final class BuyerRegistrationTermsTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        config(['materyalph.bot_protection.enabled' => false]);
        $this->seed(SystemFoundationSeeder::class);
    }

    /** @return array<string, mixed> */
    private function payload(): array
    {
        $terms = collect($this->getJson('/api/v1/agreements/current')->assertOk()->json('data'))->firstWhere('code', 'TERMS_OF_SERVICE');
        self::assertStringContainsString('# MateryalPH', $terms['content']);

        return ['full_name' => 'Buyer Fixture', 'email' => 'terms-buyer@example.test', 'mobile_e164' => '+639171234567',
            'password' => 'StrongPassword123', 'password_confirmation' => 'StrongPassword123', 'buyer_type' => 'INDIVIDUAL',
            'terms_accepted' => true, 'privacy_accepted' => true, 'terms_version_id' => $terms['id'], 'terms_content_hash' => $terms['content_hash']];
    }

    public function test_missing_and_stale_terms_cannot_create_an_account(): void
    {
        $payload = $this->payload();
        $missing = $payload;
        unset($missing['terms_version_id'], $missing['terms_content_hash']);
        $this->postJson('/api/v1/mobile/auth/register', $missing)->assertUnprocessable();
        $this->postJson('/api/v1/mobile/auth/register', [...$payload, 'terms_content_hash' => str_repeat('0', 64)])
            ->assertConflict()->assertJsonPath('errors.0.code', 'AGREEMENT_VERSION_CONFLICT');
        DB::table('agreement_versions')->where('id', $payload['terms_version_id'])->update(['retired_at' => now()]);
        $this->postJson('/api/v1/mobile/auth/register', $payload)->assertConflict();
        $this->assertDatabaseMissing('users', ['email' => $payload['email']]);
        $this->assertDatabaseCount('agreement_acceptances', 0);
    }

    public function test_reviewed_version_is_recorded_only_when_buyer_is_created(): void
    {
        $payload = $this->payload();
        $this->assertDatabaseCount('agreement_acceptances', 0);
        $this->postJson('/api/v1/mobile/auth/register', $payload)->assertCreated();
        $id = DB::table('users')->where('email', $payload['email'])->value('id');
        $this->assertDatabaseHas('agreement_acceptances', ['user_id' => $id, 'agreement_version_id' => $payload['terms_version_id'], 'source' => 'REGISTRATION']);
        $this->assertDatabaseCount('agreement_acceptances', 2);
    }

    public function test_unavailable_source_cannot_be_accepted_and_google_signup_requires_review_evidence(): void
    {
        $payload = $this->payload();
        $this->postJson('/api/v1/mobile/auth/google/start', ['mode' => 'SIGN_UP', 'mobile_e164' => '+639171234567', 'buyer_type' => 'INDIVIDUAL', 'terms_accepted' => true, 'privacy_accepted' => true])->assertUnprocessable();
        DB::table('agreement_versions')->where('id', $payload['terms_version_id'])->update(['content_hash' => str_repeat('0', 64)]);
        $rows = $this->getJson('/api/v1/agreements/current')->assertOk()->json('data');
        self::assertNull(collect($rows)->firstWhere('id', $payload['terms_version_id'])['content']);
        $this->postJson('/api/v1/mobile/auth/register', [...$payload, 'terms_content_hash' => str_repeat('0', 64)])->assertStatus(503);
        $this->assertDatabaseMissing('users', ['email' => $payload['email']]);
    }
}
