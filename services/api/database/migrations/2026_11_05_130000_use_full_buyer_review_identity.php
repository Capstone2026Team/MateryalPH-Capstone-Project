<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        DB::statement('ALTER TABLE reviews DROP CONSTRAINT review_display_choice_check');
        DB::statement("ALTER TABLE reviews ADD CONSTRAINT review_display_choice_check CHECK (display_name_choice IN ('FULL_NAME','FIRST_NAME_LAST_INITIAL','VERIFIED_BUYER','STORE_NAME'))");
        DB::statement("ALTER TABLE reviews ALTER COLUMN display_name_choice SET DEFAULT 'FULL_NAME'");
        DB::statement('ALTER TABLE reviews ALTER COLUMN public_display_name TYPE varchar(160)');
        DB::statement("CREATE INDEX reviews_buyer_received_submitted_idx ON reviews (buyer_profile_id, submitted_at DESC, id DESC) WHERE review_type = 'BUYER'");
    }

    public function down(): void
    {
        throw new RuntimeException('Review identity history is retained. Apply a forward migration to change this policy.');
    }
};
