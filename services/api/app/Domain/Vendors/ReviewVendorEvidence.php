<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\ManageAccount;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;

final class ReviewVendorEvidence
{
    public function __construct(private readonly OnboardingAccess $access, private readonly ActivationReadiness $readiness, private readonly AuditRecorder $audit, private readonly ManageAccount $accounts) {}

    /** @param array<string, mixed> $input
     * @return array<string, mixed>
     */
    public function document(Request $request, string $organization, string $version, array $input): array
    {
        $this->access->reviewer($request);
        $data = Validator::make($input, [
            'lock_version' => ['required', 'integer', 'min:1'],
            'decision' => ['required', Rule::in(['APPROVE', 'RETURN_FOR_CORRECTION', 'REJECT'])],
            'reason' => ['required_unless:decision,APPROVE', 'nullable', 'string', 'min:3', 'max:1000'],
            'verified_reference' => ['required_if:decision,APPROVE', 'nullable', 'string', 'max:160'],
            'verified_issued_on' => ['required_if:decision,APPROVE', 'nullable', 'date_format:Y-m-d', 'before_or_equal:today'],
            'verified_expiry_not_applicable' => ['required', 'boolean'],
            'verified_expires_on' => [Rule::requiredIf(($input['decision'] ?? null) === 'APPROVE' && ! ($input['verified_expiry_not_applicable'] ?? false)), 'nullable', 'date_format:Y-m-d', 'after_or_equal:verified_issued_on', 'prohibited_if:verified_expiry_not_applicable,true'],
            'source_reference' => ['required', 'string', 'max:250'],
            'remarks' => ['nullable', 'string', 'max:1000'], 'immediate_restriction' => ['required', 'boolean'],
        ])->validate();

        return DB::transaction(function () use ($request, $organization, $version, $data): array {
            $org = DB::table('vendor_organizations')->where('id', $organization)->lockForUpdate()->first();
            if ($org === null) {
                throw new AuthenticationException('RESOURCE_NOT_FOUND', 'This organization is unavailable.', 404);
            }
            $this->access->version($org, $data['lock_version']);
            if ($org->submitted_at === null || ! in_array($org->store_verification_status, ['PENDING_VERIFICATION', 'CHANGES_REQUIRED', 'REJECTED'], true)) {
                throw new AuthenticationException('SUBMISSION_REQUIRED', 'The Vendor must submit Store Verification before Admin review.', 409);
            }
            $document = DB::table('business_document_versions as v')->join('business_documents as d', 'd.id', '=', 'v.business_document_id')->join('files as f', 'f.id', '=', 'v.file_id')->where('v.id', $version)->where('d.vendor_organization_id', $organization)->where('f.vendor_organization_id', $organization)->where('v.environment', 'TEST')->first(['d.id', 'd.current_version_id', 'v.uploaded_by_user_id', 'f.scan_state']);
            if ($document === null) {
                throw new AuthenticationException('RESOURCE_NOT_FOUND', 'This document is unavailable.', 404);
            }
            if ($document->current_version_id !== $version) {
                throw new AuthenticationException('VERSION_CONFLICT', 'Review the current document version.', 409);
            }
            if ((string) $document->uploaded_by_user_id === (string) $request->user()->getKey()) {
                throw new AuthenticationException('SELF_REVIEW_DENIED', 'An independent reviewer is required.', 403);
            }
            if ($data['decision'] === 'APPROVE' && ! in_array($document->scan_state, ['CLEAN', 'TEST_SIMULATED_CLEAN'], true)) {
                throw new AuthenticationException('DOCUMENT_SCAN_PENDING', 'Scanning must clear this evidence before approval.', 409);
            }
            $id = (string) Str::uuid7();
            $review = $data;
            unset($review['lock_version']);
            DB::table('business_document_reviews')->insert($review + ['id' => $id, 'business_document_version_id' => $version, 'reviewer_user_id' => $request->user()->getKey(), 'environment' => 'TEST', 'created_at' => now(), 'updated_at' => now()]);
            $status = match ($data['decision']) {
                'APPROVE' => 'APPROVED', 'REJECT' => 'REJECTED', default => 'CHANGES_REQUIRED'
            };
            DB::table('business_documents')->where('id', $document->id)->update(['status' => $status, 'expiry_warned_at' => null, 'updated_at' => now()]);
            DB::table('vendor_organizations')->where('id', $organization)->increment('lock_version');
            $this->audit->account($request, 'VENDOR_DOCUMENT_REVIEWED', 'BUSINESS_DOCUMENT_VERSION', $version, after: ['review_id' => $id, 'decision' => $data['decision'], 'organization_id' => $organization]);
            $this->notice($organization, 'Business evidence was reviewed. Open onboarding to see the result and next action.');

            return $this->readiness->reconcile($request, $organization);
        });
    }

    /** @param array<string, mixed> $input
     * @return array<string, mixed>
     */
    public function business(Request $request, string $organization, array $input): array
    {
        $this->access->reviewer($request);
        $data = Validator::make($input, ['lock_version' => ['required', 'integer', 'min:1'], 'decision' => ['required', Rule::in(['APPROVE', 'RETURN_FOR_CORRECTION', 'REJECT'])], 'reason' => ['required_unless:decision,APPROVE', 'nullable', 'string', 'min:3', 'max:1000'], 'regulatory_evidence_required' => ['required_if:decision,APPROVE', 'boolean'], 'regulatory_review_basis' => ['required_if:decision,APPROVE', 'nullable', 'string', 'min:3', 'max:1000']])->validate();

        return DB::transaction(function () use ($request, $organization, $data): array {
            $org = DB::table('vendor_organizations')->where('id', $organization)->lockForUpdate()->first();
            if ($org === null) {
                throw new AuthenticationException('RESOURCE_NOT_FOUND', 'This organization is unavailable.', 404);
            }
            $this->access->version($org, $data['lock_version']);
            if ($org->submitted_at === null || $org->store_verification_status !== 'PENDING_VERIFICATION') {
                throw new AuthenticationException('SUBMISSION_REQUIRED', 'The Owner must submit Store Verification first.', 409);
            }
            $status = match ($data['decision']) {
                'APPROVE' => 'APPROVED', 'REJECT' => 'REJECTED', default => 'CHANGES_REQUIRED'
            };
            DB::table('vendor_organizations')->where('id', $organization)->update(['business_review_status' => $status, 'regulatory_evidence_required' => $data['regulatory_evidence_required'] ?? null, 'regulatory_review_basis' => $data['regulatory_review_basis'] ?? null, 'lock_version' => $org->lock_version + 1, 'updated_at' => now()]);
            $this->audit->account($request, 'VENDOR_BUSINESS_REVIEWED', 'VENDOR_ORGANIZATION', $organization, ['status' => $org->onboarding_status], ['status' => $status, 'reason' => $data['reason'] ?? null, 'regulatory_evidence_required' => $data['regulatory_evidence_required'] ?? null, 'regulatory_review_basis' => $data['regulatory_review_basis'] ?? null, 'reviewed_version' => $org->lock_version, 'submission_id' => DB::table('vendor_business_submissions')->where('vendor_organization_id', $organization)->orderByDesc('organization_version')->value('id')]);
            $this->notice($organization, 'Business information was reviewed. Open onboarding to see the result.');

            return $this->readiness->reconcile($request, $organization);
        });
    }

    public function notice(string $organization, string $message): void
    {
        $owner = DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->where('m.vendor_organization_id', $organization)->where('m.role', 'OWNER')->where('m.status', 'ACTIVE')->first(['u.email', 'u.public_id']);
        if ($owner !== null) {
            $this->accounts->notice($owner->email, $owner->public_id, $message);
        }
    }
}
