<?php

declare(strict_types=1);

namespace App\Domain\Agreements;

use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Vendors\OnboardingAccess;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class AccountAgreements
{
    public function __construct(private readonly AuditRecorder $audit) {}

    /** @return list<array{id: mixed, code: mixed, title: mixed, version: int, content: string|null, content_available: bool, accepted_at: mixed, requires_acceptance: bool}> */
    public function current(Request $request): array
    {
        $organization = $request->attributes->get('account_scope')['organization_id'] ?? null;

        return DB::table('agreement_versions as v')->join('agreement_documents as d', 'd.id', '=', 'v.agreement_document_id')
            ->whereIn('d.audience', ['ALL', $request->user()->account_type])->whereNull('v.retired_at')->where('v.effective_at', '<=', now())
            ->orderBy('d.code')->orderByDesc('v.version')->get(['v.*', 'd.code', 'd.title', 'd.audience'])->unique('agreement_document_id')->values()
            ->map(fn (object $row): array => $this->present($row, $request, $organization))->all();
    }

    /** @return array{id: mixed, code: mixed, title: mixed, version: int, content: string|null, content_available: bool, accepted_at: mixed, requires_acceptance: bool} */
    private function present(object $row, Request $request, ?string $organization): array
    {
        $query = DB::table('agreement_acceptances')->where('user_id', $request->user()->getKey())->where('agreement_version_id', $row->id);
        if ($row->audience === 'VENDOR') {
            $query->where('vendor_organization_id', $organization);
        } else {
            $query->where(fn ($q) => $q->whereNull('vendor_organization_id')->orWhere('vendor_organization_id', $organization));
        }
        $acceptance = $query->first();
        $path = config('materyalph.agreements.content_path', resource_path('agreements')).'/'.$row->code.'/'.$row->version.'.md';
        $content = is_file($path) ? file_get_contents($path) : null;
        if (is_string($content) && ! hash_equals($row->content_hash, hash('sha256', $content))) {
            $content = null;
        }
        if (is_string($content)) {
            $content = str_replace('{{PRIVACY_CONTACT}}', (string) config('materyalph.agreements.privacy_contact'), $content);
        }

        return ['id' => $row->id, 'code' => $row->code, 'title' => $row->title, 'version' => (int) $row->version,
            'content' => is_string($content) ? $content : null, 'content_available' => is_string($content), 'accepted_at' => $acceptance?->accepted_at,
            'requires_acceptance' => (bool) $row->requires_reacceptance && $acceptance === null];

    }

    /** @param list<string> $ids */
    public function accept(Request $request, array $ids): void
    {
        DB::transaction(function () use ($request, $ids): void {
            DB::table('users')->where('id', $request->user()->getKey())->lockForUpdate()->first();
            $current = collect($this->current($request))->keyBy('id');
            foreach ($ids as $id) {
                $agreement = $current->get($id);
                if ($agreement === null) {
                    throw new AuthenticationException('AGREEMENT_VERSION_CONFLICT', 'Reload the current agreement versions.', 409);
                }
                if ($agreement['code'] === 'VENDOR_COMMISSION_TEST') {
                    $organization = $request->attributes->get('account_scope')['organization_id'] ?? '';
                    app(OnboardingAccess::class)->vendor($request, $organization, 'finance.attest', true);
                    if (config('finance.live_commerce_enabled') || ! in_array(config('finance.mode'), ['TEST', 'DEMO'], true)) {
                        throw new AuthenticationException('TEST_ONLY', 'These commission Terms apply only to TEST.', 422);
                    }
                }
                if (! $agreement['content_available']) {
                    throw new AuthenticationException('AGREEMENT_CONTENT_UNAVAILABLE', 'The approved agreement text is not available yet.', 503);
                }
                if ($agreement['accepted_at'] !== null) {
                    continue;
                }
                DB::table('agreement_acceptances')->insert([
                    'id' => (string) Str::uuid7(), 'user_id' => $request->user()->getKey(), 'agreement_version_id' => $id,
                    'vendor_organization_id' => $request->attributes->get('account_scope')['organization_id'] ?? null,
                    'source' => $agreement['code'] === 'VENDOR_COMMISSION_TEST' ? 'PHASE_3_TEST' : 'ACCOUNT_SETTINGS', 'accepted_at' => now(), 'created_at' => now(), 'updated_at' => now(),
                ]);
                $this->audit->account($request, 'AGREEMENT_ACCEPTED', 'AGREEMENT_VERSION', $id, after: ['version' => $agreement['version'], 'code' => $agreement['code']]);
            }
        });
    }

    public function requireCurrent(Request $request): void
    {
        if (collect($this->current($request))->contains(fn (array $row): bool => $row['requires_acceptance'])) {
            throw new AuthenticationException('AGREEMENT_REACCEPTANCE_REQUIRED', 'Review and accept the current required agreements.', 403);
        }
    }

    /** @param list<string> $codes */
    public function requireCurrentCodes(Request $request, array $codes): void
    {
        if (collect($this->current($request))->whereIn('code', $codes)->contains(fn (array $row): bool => $row['requires_acceptance'])) {
            throw new AuthenticationException('AGREEMENT_REACCEPTANCE_REQUIRED', 'Review and accept the required registration agreements and Privacy Notice.', 403);
        }
    }
}
