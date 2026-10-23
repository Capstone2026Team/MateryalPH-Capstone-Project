<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Finance\TaxpayerIdentityHash;
use App\Domain\Vendors\VendorAuthorityService;
use App\Infrastructure\Encryption\ImportedValueEncrypter;
use App\Models\User;
use App\Models\VendorOrganization;
use App\Providers\AppServiceProvider;
use Illuminate\Contracts\Encryption\DecryptException;
use Illuminate\Database\QueryException;
use Illuminate\Encryption\Encrypter;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Tests\TestCase;

final class ImportedEncryptionRecoveryTest extends TestCase
{
    use RefreshDatabase;

    public function test_recovered_import_decrypts_without_retaining_the_source_key_or_changing_the_source(): void
    {
        $source = new Encrypter(random_bytes(32), 'AES-256-CBC');
        $staging = new ImportedValueEncrypter(random_bytes(32), 'AES-256-CBC');
        $original = $source->encryptString('synthetic imported identity');
        $recovered = $staging->encryptString($source->decryptString($original));
        $this->store($original, $recovered);

        self::assertSame('synthetic imported identity', $staging->decryptString($original));
        self::assertSame('synthetic imported identity', $source->decryptString($original));
        self::assertSame([], $staging->getPreviousKeys());
        $this->assertDatabaseCount('imported_encrypted_values', 1);
    }

    public function test_new_values_use_only_the_current_staging_key(): void
    {
        $key = random_bytes(32);
        $staging = new ImportedValueEncrypter($key, 'AES-256-CBC');
        $ciphertext = $staging->encryptString('synthetic new value');

        self::assertSame('synthetic new value', (new Encrypter($key, 'AES-256-CBC'))->decryptString($ciphertext));
        self::assertSame('synthetic new value', $staging->decryptString($ciphertext));
        $this->assertDatabaseCount('imported_encrypted_values', 0);
    }

    public function test_unknown_source_ciphertext_is_rejected(): void
    {
        $source = new Encrypter(random_bytes(32), 'AES-256-CBC');
        $staging = new ImportedValueEncrypter(random_bytes(32), 'AES-256-CBC');
        $this->expectException(DecryptException::class);

        $staging->decryptString($source->encryptString('unregistered value'));
    }

    public function test_tampering_with_the_original_payload_cannot_select_a_recovery_value(): void
    {
        $source = new Encrypter(random_bytes(32), 'AES-256-CBC');
        $staging = new ImportedValueEncrypter(random_bytes(32), 'AES-256-CBC');
        $original = $source->encryptString('synthetic identity');
        $this->store($original, $staging->encryptString('synthetic identity'));
        $this->expectException(DecryptException::class);

        $staging->decryptString(substr($original, 0, -4).'AAAA');
    }

    public function test_a_corrupt_recovery_entry_is_rejected_without_recursion(): void
    {
        $source = new Encrypter(random_bytes(32), 'AES-256-CBC');
        $staging = new ImportedValueEncrypter(random_bytes(32), 'AES-256-CBC');
        $original = $source->encryptString('synthetic identity');
        $this->store($original, $original);
        $this->expectException(DecryptException::class);

        $staging->decryptString($original);
    }

    public function test_recovery_records_cannot_be_rewritten(): void
    {
        $this->store('synthetic source ciphertext', 'synthetic staging ciphertext');
        $this->expectException(QueryException::class);

        DB::table('imported_encrypted_values')->update(['staging_ciphertext' => 'replaced']);
    }

    public function test_domain_read_recovers_an_immutable_representative_without_rewriting_history(): void
    {
        $user = User::factory()->create(['account_type' => 'VENDOR']);
        $organization = VendorOrganization::query()->create(['legal_name' => 'Synthetic import test', 'store_name' => 'Synthetic import test']);
        $source = new Encrypter(random_bytes(32), 'AES-256-CBC');
        $details = ['name' => 'Synthetic representative', 'id_number' => 'SYNTHETIC-1234'];
        $original = $source->encryptString(json_encode($details, JSON_THROW_ON_ERROR));
        $id = (string) Str::uuid7();
        DB::table('vendor_representative_versions')->insert([
            'id' => $id, 'vendor_organization_id' => $organization->getKey(), 'version' => 1,
            'details_encrypted' => $original, 'content_hash' => hash('sha256', 'synthetic fixture'),
            'created_by_user_id' => $user->getKey(), 'created_at' => now(),
        ]);
        $staging = app('encrypter');
        $this->store($original, $staging->encryptString(json_encode($details, JSON_THROW_ON_ERROR)));
        config()->set('app.imported_data_recovery_enabled', true);
        (new AppServiceProvider($this->app))->register();
        Crypt::clearResolvedInstance('encrypter');

        self::assertInstanceOf(ImportedValueEncrypter::class, app('encrypter'));
        $snapshot = app(VendorAuthorityService::class)->snapshot((string) $organization->getKey());
        self::assertSame('Synthetic representative', $snapshot['name']);
        self::assertSame('1234', $snapshot['id_number_last4']);
        self::assertArrayNotHasKey('id_number', $snapshot);
        self::assertSame($original, DB::table('vendor_representative_versions')->where('id', $id)->value('details_encrypted'));
        self::assertSame(1, DB::table('vendor_representative_versions')->where('id', $id)->value('version'));
    }

    public function test_imported_taxpayer_group_is_preserved_for_new_profile_versions(): void
    {
        $key = 'TEST|synthetic-taxpayer';
        $stagingHash = hash_hmac('sha256', $key, (string) config('app.key'));
        $canonical = hash('sha256', 'synthetic legacy taxpayer group');
        DB::table('imported_encrypted_values')->insert([
            'id' => (string) Str::uuid7(), 'source_ciphertext_sha256' => hash('sha256', 'synthetic tax ciphertext'),
            'staging_ciphertext' => 'synthetic encrypted identity', 'source_table' => 'vendor_tax_profile_versions',
            'source_column' => 'taxpayer_key_encrypted', 'source_record_id' => (string) Str::uuid7(),
            'staging_identity_hash' => $stagingHash, 'canonical_identity_hash' => $canonical,
            'import_batch_id' => (string) Str::uuid7(), 'created_at' => now(),
        ]);
        self::assertSame($stagingHash, TaxpayerIdentityHash::taxpayerKey($key));
        config()->set('app.imported_data_recovery_enabled', true);

        self::assertSame($canonical, TaxpayerIdentityHash::taxpayerKey($key));
        self::assertSame(hash_hmac('sha256', 'unregistered taxpayer', (string) config('app.key')), TaxpayerIdentityHash::taxpayerKey('unregistered taxpayer'));
        self::assertSame(hash_hmac('sha256', '123456789', (string) config('app.key')), TaxpayerIdentityHash::tin('123456789'));
    }

    private function store(string $source, string $staging): void
    {
        DB::table('imported_encrypted_values')->insert([
            'id' => (string) Str::uuid7(), 'source_ciphertext_sha256' => hash('sha256', $source),
            'staging_ciphertext' => $staging, 'source_table' => 'vendor_tax_profile_versions', 'source_column' => 'tin_encrypted',
            'source_record_id' => (string) Str::uuid7(), 'import_batch_id' => (string) Str::uuid7(), 'created_at' => now(),
        ]);
    }
}
