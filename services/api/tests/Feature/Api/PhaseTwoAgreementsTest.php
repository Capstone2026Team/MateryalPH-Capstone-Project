<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Identity\TokenSessionService;
use App\Models\AuthSession;
use App\Models\User;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Str;
use Laravel\Passport\AccessToken;
use Tests\TestCase;

final class PhaseTwoAgreementsTest extends TestCase
{
    use RefreshDatabase;

    public function test_new_required_versions_preserve_old_evidence_and_acceptance_is_idempotent(): void
    {
        $this->seed(SystemFoundationSeeder::class);
        $user = User::factory()->create(['account_type' => 'BUYER', 'account_status' => 'ACTIVE']);
        $tokens = app(TokenSessionService::class)->start($user, 'MOBILE', null, null, null);
        $session = AuthSession::query()->findOrFail($tokens->sessionId);
        $user->withAccessToken(new AccessToken(['oauth_access_token_id' => $session->oauth_access_token_id, 'oauth_scopes' => ['BUYER']]));
        $this->actingAs($user, 'api');
        $document = DB::table('agreement_documents')->where('code', 'TERMS_OF_SERVICE')->value('id');
        $old = DB::table('agreement_versions')->where('agreement_document_id', $document)->value('id');
        DB::table('agreement_acceptances')->insert(['id' => (string) Str::uuid7(), 'user_id' => $user->getKey(), 'agreement_version_id' => $old, 'source' => 'REGISTRATION', 'accepted_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        $version = (string) Str::uuid7();
        $text = 'Test fixture only. This is not legal copy.';
        DB::table('agreement_versions')->insert(['id' => $version, 'agreement_document_id' => $document, 'version' => 3, 'content_hash' => hash('sha256', $text), 'content_uri' => '/legal/terms/3', 'effective_at' => now(), 'requires_reacceptance' => true, 'created_at' => now(), 'updated_at' => now()]);
        $root = storage_path('framework/testing/agreements-'.Str::uuid7());
        config(['materyalph.agreements.content_path' => $root.'/agreements']);
        File::ensureDirectoryExists($root.'/agreements/TERMS_OF_SERVICE');
        try {
            $this->postJson('/api/v1/buyers/account/agreements', ['version_ids' => [$version]])->assertStatus(503);
            File::put($root.'/agreements/TERMS_OF_SERVICE/3.md', 'Different fixture content');
            $this->postJson('/api/v1/buyers/account/agreements', ['version_ids' => [$version]])->assertStatus(503);
            File::put($root.'/agreements/TERMS_OF_SERVICE/3.md', $text);
            $rows = $this->getJson('/api/v1/buyers/account/agreements')->assertOk()->json('data');
            $terms = collect($rows)->firstWhere('id', $version);
            self::assertTrue($terms['requires_acceptance']);
            self::assertSame($text, $terms['content']);
            $this->postJson('/api/v1/buyers/account/agreements', ['version_ids' => [$old]])->assertConflict();
            $this->postJson('/api/v1/buyers/account/agreements', ['version_ids' => [$version]])->assertOk();
            $this->postJson('/api/v1/buyers/account/agreements', ['version_ids' => [$version]])->assertOk();
            $this->assertDatabaseCount('agreement_acceptances', 2);
            $this->assertDatabaseHas('agreement_acceptances', ['agreement_version_id' => $old, 'source' => 'REGISTRATION']);
            self::assertSame(1, DB::table('audit_logs')->where('action', 'AGREEMENT_ACCEPTED')->count());
        } finally {
            File::deleteDirectory($root);
        }
    }
}
