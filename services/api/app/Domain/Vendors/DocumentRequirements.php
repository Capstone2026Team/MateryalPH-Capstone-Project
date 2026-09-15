<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;

final class DocumentRequirements
{
    /** @return list<string> */
    public function required(object $organization): array
    {
        $registration = match ($organization->business_type) {
            'SOLE_PROPRIETORSHIP' => 'DTI',
            'COOPERATIVE' => 'CDA',
            'PARTNERSHIP', 'CORPORATION', 'ONE_PERSON_CORPORATION' => 'SEC',
            default => 'DTI',
        };

        return [...($organization->business_type === 'SOLE_PROPRIETORSHIP' ? ['GOVERNMENT_ID'] : []), $registration, 'LGU_PERMIT', 'BIR_COR', ...(($organization->regulatory_evidence_required ?? false) ? ['REGULATORY'] : [])];
    }

    public function label(string $type): string
    {
        return match ($type) {
            'DTI' => 'DTI Business Name Registration',
            'SEC' => 'SEC Registration',
            'CDA' => 'CDA Registration',
            'LGU_PERMIT' => 'LGU Business Permit',
            'BIR_COR' => 'BIR Certificate of Registration',
            'GOVERNMENT_ID' => 'Government-issued identity evidence',
            'REGULATORY' => 'Other regulatory evidence',
            default => str($type)->replace('_', ' ')->title()->toString(),
        };
    }

    /** @return array{status: string, version_id: ?string, reason: ?string, expires_on: ?string} */
    public function effective(string $organization, string $type): array
    {
        $document = DB::table('business_documents')->where('vendor_organization_id', $organization)->where('document_type', $type)->first();
        $missing = ['status' => 'NOT_STARTED', 'version_id' => null, 'reason' => 'Upload the applicable current evidence.', 'expires_on' => null];
        if ($document === null) {
            return $missing;
        }
        $versions = DB::table('business_document_versions')->where('business_document_id', $document->id)->where('environment', 'TEST')->orderByDesc('version')->get();
        $latest = null;
        foreach ($versions as $version) {
            $review = DB::table('business_document_reviews')->where('business_document_version_id', $version->id)->where('environment', 'TEST')->orderByDesc('created_at')->orderByDesc('id')->first();
            $scan = DB::table('files')->where('id', $version->file_id)->value('scan_state');
            $status = match ($review?->decision) {
                'APPROVE' => 'APPROVED', 'RETURN_FOR_CORRECTION' => 'CHANGES_REQUIRED', 'REJECT' => 'REJECTED', default => 'PENDING_VERIFICATION',
            };
            if ($review?->verified_expires_on !== null && Carbon::parse($review->verified_expires_on, 'Asia/Manila')->endOfDay()->isPast()) {
                $status = 'EXPIRED';
            }
            if (! in_array($scan, ['CLEAN', 'TEST_SIMULATED_CLEAN'], true)) {
                $status = 'PENDING_VERIFICATION';
            }
            $result = ['status' => $status, 'version_id' => (string) $version->id, 'reason' => $review?->reason, 'expires_on' => $review?->verified_expires_on];
            $latest ??= $result;
            if ($review?->immediate_restriction) {
                return $result['status'] === 'APPROVED' ? [...$result, 'status' => 'CHANGES_REQUIRED'] : $result;
            }
            if ($status === 'APPROVED') {
                return $result;
            }
            if ($status === 'EXPIRED' && $latest['status'] === 'PENDING_VERIFICATION') {
                return $result;
            }
            // Only a pending replacement can retain an earlier approval.
            if ($latest['status'] !== 'PENDING_VERIFICATION') {
                return $latest;
            }
        }

        return $latest ?? $missing;
    }
}
