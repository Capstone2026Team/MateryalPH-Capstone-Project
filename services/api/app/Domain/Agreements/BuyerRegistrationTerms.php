<?php

declare(strict_types=1);

namespace App\Domain\Agreements;

use App\Domain\Identity\AuthenticationException;
use Illuminate\Support\Facades\DB;

final class BuyerRegistrationTerms
{
    public function assertCurrent(?string $id, ?string $hash): void
    {
        $versions = DB::table('agreement_versions as v')
            ->join('agreement_documents as d', 'd.id', '=', 'v.agreement_document_id')
            ->whereIn('d.audience', ['ALL', 'BUYER'])->where('d.code', 'TERMS_OF_SERVICE')
            ->whereNull('v.retired_at')->where('v.effective_at', '<=', now())
            ->sharedLock()->get(['v.*', 'd.code']);
        $version = $versions->count() === 1 ? $versions->first() : null;
        if ($version === null || $id !== $version->id || ! is_string($hash) || ! hash_equals($version->content_hash, $hash)) {
            throw new AuthenticationException('AGREEMENT_VERSION_CONFLICT', 'Review and accept the current Terms of Service before registering.', 409);
        }
        if (app(AgreementContent::class)->read($version) === null) {
            throw new AuthenticationException('AGREEMENT_CONTENT_UNAVAILABLE', 'The approved agreement text is not available yet.', 503);
        }
    }
}
