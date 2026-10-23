<?php

declare(strict_types=1);

namespace App\Infrastructure\Encryption;

use Illuminate\Contracts\Encryption\DecryptException;
use Illuminate\Encryption\Encrypter;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/** Reads explicitly recovered import values without changing immutable source records or retaining source keys. */
final class ImportedValueEncrypter extends Encrypter
{
    public function decrypt($payload, $unserialize = true)
    {
        try {
            return parent::decrypt($payload, $unserialize);
        } catch (DecryptException $failure) {
            if (! Schema::hasTable('imported_encrypted_values')) {
                throw $failure;
            }

            $replacement = DB::table('imported_encrypted_values')
                ->where('source_ciphertext_sha256', hash('sha256', $payload))
                ->value('staging_ciphertext');
            if (! is_string($replacement)) {
                throw $failure;
            }

            // Exactly one lookup and one decryption: a corrupt recovery entry must never become a fallback chain.
            return parent::decrypt($replacement, $unserialize);
        }
    }
}
