<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        DB::statement('DROP INDEX conversation_one_quotation');
        DB::statement("CREATE UNIQUE INDEX conversation_one_open_quotation ON quotations(conversation_id) WHERE state <> 'ACCEPTED'");
        DB::statement("CREATE UNIQUE INDEX conversation_one_project_quotation ON quotations(conversation_id) WHERE procurement_type = 'PROJECT_BASED'");
    }

    public function down(): void
    {
        // Fail without deleting history if later quotations have already been created.
        DB::statement('CREATE UNIQUE INDEX conversation_one_quotation ON quotations(conversation_id)');
        DB::statement('DROP INDEX conversation_one_open_quotation');
        DB::statement('DROP INDEX conversation_one_project_quotation');
    }
};
