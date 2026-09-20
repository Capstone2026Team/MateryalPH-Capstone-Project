<?php

declare(strict_types=1);

namespace App\Domain\Agreements;

final class AgreementContent
{
    public function read(object $version): ?string
    {
        // Only maintained document codes and numeric versions can name local content.
        if (! preg_match('/^[A-Z_]+$/D', $version->code) || ! ctype_digit((string) $version->version)) {
            return null;
        }
        $path = config('materyalph.agreements.content_path', resource_path('agreements')).'/'.$version->code.'/'.$version->version.'.md';
        $content = is_file($path) ? file_get_contents($path) : null;
        if (! is_string($content) || ! hash_equals($version->content_hash, hash('sha256', $content))) {
            return null;
        }

        return str_replace('{{PRIVACY_CONTACT}}', (string) config('materyalph.agreements.privacy_contact'), $content);
    }
}
