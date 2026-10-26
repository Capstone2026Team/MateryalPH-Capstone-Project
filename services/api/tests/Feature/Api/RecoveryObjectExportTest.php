<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Models\User;
use App\Models\VendorOrganization;
use Illuminate\Filesystem\Filesystem;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use RuntimeException;
use Tests\TestCase;

final class RecoveryObjectExportTest extends TestCase
{
    use RefreshDatabase;

    private string $directory = '';

    protected function setUp(): void
    {
        parent::setUp();
        if (! defined('MATERYALPH_RECOVERY_LIBRARY')) {
            define('MATERYALPH_RECOVERY_LIBRARY', true);
        }
        require_once base_path('../../scripts/deployment/vps-transfer.php');
        config()->set('materyalph.files.disk', 's3');
        Storage::fake('local');
        Storage::fake('s3');
        $this->directory = sys_get_temp_dir().'/materyalph-recovery-test-'.bin2hex(random_bytes(8));
        mkdir($this->directory, 0700);
        mkdir($this->directory.'/objects', 0700);
    }

    protected function tearDown(): void
    {
        if ($this->directory !== '') {
            (new Filesystem)->deleteDirectory($this->directory);
        }
        parent::tearDown();
    }

    public function test_imported_chat_uses_its_recorded_disk_and_exports_one_verified_object(): void
    {
        $key = 'chat/a';
        $bytes = 'synthetic private attachment';
        $this->attachment($key, $bytes);
        Storage::disk('local')->put($key, $bytes);
        Storage::disk('s3')->put($key, 'different object on the new default disk');

        [$objects, $external] = recoveryExportObjects($this->directory);

        $hash = hash('sha256', $bytes);
        self::assertSame([['disk' => 'local', 'key' => $key, 'sha256' => $hash, 'bytes' => strlen($bytes)]], $objects);
        self::assertSame([], $external);
        self::assertSame($bytes, file_get_contents($this->directory.'/objects/'.$hash));
        self::assertSame([$this->directory.'/objects/'.$hash], glob($this->directory.'/objects/*'));
    }

    public function test_missing_chat_object_cannot_be_replaced_by_the_default_disk_copy(): void
    {
        $key = 'chat/b';
        $bytes = 'synthetic private attachment';
        $this->attachment($key, $bytes);
        Storage::disk('s3')->put($key, $bytes);
        $this->expectException(RuntimeException::class);
        $this->expectExceptionMessage('REFERENCED_OBJECT_MISSING');

        recoveryExportObjects($this->directory);
    }

    public function test_tampered_chat_object_is_rejected_on_its_recorded_disk(): void
    {
        $key = 'chat/c';
        $this->attachment($key, 'original synthetic bytes');
        Storage::disk('local')->put($key, 'tampered bytes');
        $this->expectException(RuntimeException::class);
        $this->expectExceptionMessage('SOURCE_OBJECT_CHECKSUM_MISMATCH');

        recoveryExportObjects($this->directory);
    }

    public function test_inconsistent_chat_storage_keys_are_rejected(): void
    {
        $fileId = $this->attachment('chat/d', 'synthetic bytes');
        DB::table('message_attachments')->where('file_id', $fileId)->update(['storage_key' => 'chat/e']);
        $this->expectException(RuntimeException::class);
        $this->expectExceptionMessage('ATTACHMENT_OBJECT_REFERENCE_MISMATCH');

        recoveryExportObjects($this->directory);
    }

    public function test_other_files_keep_explicit_disk_metadata_and_default_disk_fallback(): void
    {
        $this->file('synthetic/legacy', 'legacy bytes', ['disk' => 'local']);
        $this->file('synthetic/current', 'current bytes');
        Storage::disk('local')->put('synthetic/legacy', 'legacy bytes');
        Storage::disk('s3')->put('synthetic/current', 'current bytes');

        [$objects, $external] = recoveryExportObjects($this->directory);

        self::assertSame(['local', 's3'], array_column($objects, 'disk'));
        self::assertSame(['synthetic/legacy', 'synthetic/current'], array_column($objects, 'key'));
        self::assertSame([], $external);
    }

    public function test_cloudinary_media_stays_in_the_external_inventory(): void
    {
        $this->file('synthetic/cloudinary', 'external bytes', ['storage_provider' => 'CLOUDINARY', 'public_url' => 'https://example.test/synthetic.png']);

        [$objects, $external] = recoveryExportObjects($this->directory);

        self::assertSame([], $objects);
        self::assertSame([['provider' => 'CLOUDINARY', 'object_key' => 'synthetic/cloudinary', 'url' => 'https://example.test/synthetic.png']], $external);
    }

    /** @param array<string, string> $metadata */
    private function file(string $key, string $bytes, array $metadata = [], ?string $conversationId = null): string
    {
        $id = (string) Str::uuid7();
        DB::table('files')->insert(['id' => $id, 'owner_type' => $conversationId === null ? 'USER' : 'CONVERSATION', 'owner_id' => $conversationId ?? (string) Str::uuid7(),
            'purpose' => $conversationId === null ? 'DOCUMENT_EXPORT' : 'CHAT_SALES', 'visibility' => 'PRIVATE', 'content_type' => 'image/png', 'byte_size' => strlen($bytes),
            'checksum_sha256' => hash('sha256', $bytes), 'scan_state' => 'CLEAN', 'object_key' => $key, 'retention_class' => 'COMMERCIAL_HISTORY',
            'metadata' => json_encode($metadata, JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);

        return $id;
    }

    private function attachment(string $key, string $bytes): string
    {
        $user = User::factory()->create(['account_type' => 'BUYER']);
        $buyerId = (string) Str::uuid7();
        DB::table('buyer_profiles')->insert(['id' => $buyerId, 'user_id' => $user->id, 'buyer_type' => 'INDIVIDUAL', 'created_at' => now(), 'updated_at' => now()]);
        $vendor = VendorOrganization::query()->create(['legal_name' => 'Synthetic recovery vendor', 'store_name' => 'Synthetic recovery vendor']);
        $conversationId = (string) Str::uuid7();
        DB::table('conversations')->insert(['id' => $conversationId, 'buyer_profile_id' => $buyerId, 'vendor_organization_id' => $vendor->id,
            'context_type' => 'ITEM_BASED', 'purpose' => 'SALES', 'created_at' => now(), 'updated_at' => now()]);
        $messageId = (string) Str::uuid7();
        DB::table('messages')->insert(['id' => $messageId, 'conversation_id' => $conversationId, 'sender_user_id' => $user->id, 'client_message_id' => (string) Str::uuid7(),
            'body' => 'Attachment', 'kind' => 'ATTACHMENT', 'sent_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        $fileId = $this->file($key, $bytes, conversationId: $conversationId);
        DB::table('message_attachments')->insert(['id' => (string) Str::uuid7(), 'message_id' => $messageId, 'file_id' => $fileId, 'scan_state' => 'CLEAN',
            'disk' => 'local', 'storage_key' => $key, 'media_type' => 'image/png', 'size_bytes' => strlen($bytes), 'display_name' => 'Attachment.png',
            'purpose' => 'SALES', 'created_at' => now(), 'updated_at' => now()]);

        return $fileId;
    }
}
