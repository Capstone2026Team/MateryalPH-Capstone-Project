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
        // Storage conversion only: retain version IDs, taxpayer hashes and historical content hashes.
        DB::table('vendor_tax_profile_versions')->orderBy('id')->each(function (object $row): void {
            $tin = empty($row->tin_encrypted) ? '' : Crypt::decryptString($row->tin_encrypted);
            $branch = empty($row->branch_code_encrypted) ? ($row->tin_branch_code ?? '') : Crypt::decryptString($row->branch_code_encrypted);
            DB::table('vendor_tax_profile_versions')->where('id', $row->id)->update([
                'tin_encrypted' => $tin.$branch === '' ? null : Crypt::encryptString($tin.$branch),
            ]);
        });
        DB::table('vendor_onboarding_drafts')->where('workstream', 'STORE_VERIFICATION')->orderBy('id')->each(function (object $row): void {
            $payload = json_decode(Crypt::decryptString($row->payload_encrypted), true, flags: JSON_THROW_ON_ERROR);
            if (! is_array($payload['tax_profile'] ?? null)) {
                return;
            }
            $tax = $payload['tax_profile'];
            if (isset($tax['tin']) && strlen($tax['tin']) === 9 && ! empty($tax['branch_code'])) {
                $tax['tin'] .= $tax['branch_code'];
            } elseif (isset($tax['tin']) && strlen($tax['tin']) === 9 && ($tax['head_office'] ?? false)) {
                $tax['tin'] .= str_repeat('0', (int) ($tax['branch_code_length'] ?? 5));
            }
            unset($tax['branch_code'], $tax['branch_code_length'], $tax['head_office']);
            $payload['tax_profile'] = $tax;
            DB::table('vendor_onboarding_drafts')->where('id', $row->id)->update([
                'payload_encrypted' => Crypt::encryptString(json_encode($payload, JSON_THROW_ON_ERROR)),
                'lock_version' => (int) $row->lock_version + 1,
            ]);
        });
        Schema::table('vendor_tax_profile_versions', fn (Blueprint $table) => $table->dropColumn(['tin_branch_code', 'branch_code_encrypted']));
    }

    public function down(): void
    {
        Schema::table('vendor_tax_profile_versions', function (Blueprint $table): void {
            $table->string('tin_branch_code', 16)->nullable();
            $table->text('branch_code_encrypted')->nullable();
        });
        DB::table('vendor_tax_profile_versions')->whereNotNull('tin_encrypted')->orderBy('id')->each(function (object $row): void {
            $tin = Crypt::decryptString($row->tin_encrypted);
            $core = strlen($tin) < 9 ? '' : substr($tin, 0, 9);
            $branch = strlen($tin) < 9 ? $tin : substr($tin, 9);
            DB::table('vendor_tax_profile_versions')->where('id', $row->id)->update([
                'tin_encrypted' => $core === '' ? null : Crypt::encryptString($core),
                'branch_code_encrypted' => $branch === '' ? null : Crypt::encryptString($branch),
            ]);
        });
    }
};
