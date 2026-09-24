<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        DB::table('vendor_onboarding_drafts')->where('workstream', 'STORE_VERIFICATION')->orderBy('id')->chunkById(100, function ($drafts): void {
            foreach ($drafts as $draft) {
                $payload = json_decode(Crypt::decryptString($draft->payload_encrypted), true, flags: JSON_THROW_ON_ERROR);
                if (is_array($payload) && array_key_exists('contacts', $payload)) {
                    unset($payload['contacts']);
                    DB::table('vendor_onboarding_drafts')->where('id', $draft->id)->update([
                        'payload_encrypted' => Crypt::encryptString(json_encode($payload, JSON_THROW_ON_ERROR)),
                        'lock_version' => (int) $draft->lock_version + 1,
                        'updated_at' => now(),
                    ]);
                }
            }
        });
        Schema::dropIfExists('vendor_contacts');
    }

    public function down(): void
    {
        // Recreates the retired schema; removed contact records cannot be restored.
        Schema::create('vendor_contacts', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->string('full_name');
            $table->string('title')->nullable();
            $table->string('email')->nullable();
            $table->string('phone', 24)->nullable();
            $table->boolean('is_primary')->default(false);
            $table->boolean('is_public')->default(false);
            $table->boolean('is_authorized')->default(false);
            $table->boolean('active')->default(true);
            $table->unsignedInteger('lock_version')->default(1);
            $table->index(['vendor_organization_id', 'active']);
            $table->timestampsTz();
        });
        DB::statement('CREATE UNIQUE INDEX vendor_one_primary_contact_unique ON vendor_contacts (vendor_organization_id) WHERE is_primary = true AND active = true');
        DB::statement('ALTER TABLE vendor_contacts ADD CONSTRAINT vendor_contact_primary_check CHECK (is_primary = false OR active = true)');
    }
};
