<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use Illuminate\Support\Facades\DB;

/** Imported tax identities must keep their existing cumulative withholding groups across environment keys. */
final class TaxpayerIdentityHash
{
    public static function taxpayerKey(string $value): string
    {
        return self::resolve($value, 'taxpayer_key_encrypted');
    }

    public static function tin(string $coreTin): string
    {
        return self::resolve($coreTin, 'tin_encrypted');
    }

    private static function resolve(string $value, string $column): string
    {
        $hash = hash_hmac('sha256', $value, (string) config('app.key'));
        if (! config('app.imported_data_recovery_enabled') || ! app()->environment(['staging', 'testing'])) {
            return $hash;
        }
        $canonical = DB::table('imported_encrypted_values')
            ->where('source_table', 'vendor_tax_profile_versions')->where('source_column', $column)
            ->where('staging_identity_hash', $hash)->value('canonical_identity_hash');

        return is_string($canonical) ? $canonical : $hash;
    }
}
