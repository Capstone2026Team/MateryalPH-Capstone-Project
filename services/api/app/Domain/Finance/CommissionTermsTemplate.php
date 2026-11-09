<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/** Template v2. Published renderings and their hashes are retained with each policy. */
final class CommissionTermsTemplate
{
    public function render(int $basisPoints, CarbonImmutable $effective): string
    {
        return strtr((string) file_get_contents(resource_path('agreements/commission-template-v2.md')), [
            '{{rate}}' => CommissionPolicyService::percent($basisPoints),
            '{{effective}}' => $effective->setTimezone('Asia/Manila')->format('M j, Y g:i A').' (Asia/Manila)',
            '{{basis}}' => 'completed, non-refunded materials after Vendor discounts, excluding included materials VAT',
            '{{cycle}}' => 'automatically at 00:05 Asia/Manila on the first day of each month for billable completed orders in the previous month, with recovery every five minutes',
            '{{due}}' => 'the later of the fifteenth of the following month or twelve calendar days after issuance, end of day in Asia/Manila',
        ]);
    }

    public function create(string $documentId, int $basisPoints, CarbonImmutable $effective): string
    {
        $version = (int) DB::table('agreement_versions')->where('agreement_document_id', $documentId)->max('version') + 1;
        $content = $this->render($basisPoints, $effective);
        $id = (string) Str::uuid7();
        DB::table('agreement_versions')->insert(['id' => $id, 'agreement_document_id' => $documentId, 'version' => $version,
            'content_uri' => 'database:commission/template-v2/'.$version, 'content_hash' => hash('sha256', $content), 'published_content' => $content,
            'effective_at' => $effective, 'requires_reacceptance' => true, 'created_at' => now(), 'updated_at' => now()]);

        return $id;
    }

    public function backfill(): void
    {
        DB::transaction(function (): void {
            $document = DB::table('agreement_documents')->where('code', 'VENDOR_COMMISSION_TEST')->lockForUpdate()->first();
            if ($document === null) {
                return; // The foundation seeder calls this again on an empty database.
            }
            $renderings = [];
            DB::table('fee_policy_versions')->where('code', FinancialSnapshotService::FEE_POLICY_CODE)->whereNull('agreement_version_id')->orderBy('version')->get()->each(function (object $policy) use ($document, &$renderings): void {
                $effective = CarbonImmutable::parse($policy->effective_from);
                $key = $policy->commission_basis_points.'|'.$effective->utc()->toIso8601String();
                // TEST and DEMO foundation records share identical legal text. Do not publish competing
                // initial agreement versions for the same rate and instant in their shared document.
                $id = $renderings[$key] ??= $this->create((string) $document->id, (int) $policy->commission_basis_points, $effective);
                DB::table('fee_policy_versions')->where('id', $policy->id)->update(['agreement_version_id' => $id,
                    // Preserve real initial consent; never fabricate acceptance of the generated rendering.
                    'legacy_agreement_version_id' => (int) $policy->version === 1 ? DB::table('agreement_versions')->where('agreement_document_id', $document->id)->where('version', 1)->value('id') : null]);
            });
        });
    }
}
