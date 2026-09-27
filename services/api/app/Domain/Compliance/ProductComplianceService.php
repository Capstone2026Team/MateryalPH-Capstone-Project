<?php

declare(strict_types=1);

namespace App\Domain\Compliance;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Catalog\CatalogFileStore;
use App\Domain\Catalog\ComparableMappingService;
use App\Domain\Catalog\ImageContentValidator;
use App\Domain\Catalog\ListingReadiness;
use App\Domain\Catalog\ListingTransitions;
use App\Domain\Catalog\MarketplaceDiscoverability;
use App\Domain\Catalog\VendorCatalogService;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\OutboxPublisher;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Product PS/ICC compliance. Photo/OCR, QR and Manual Entry all converge on one
 * Review and Confirm submission. Product evidence decisions are separate from
 * business/tax evidence decisions and never touch Store Activation.
 */
final class ProductComplianceService
{
    public const PATHS = ['PHOTO_OCR', 'QR', 'MANUAL'];

    public const OFFICIAL_REFERENCES = [
        ['label' => 'DTI-BPS PS and ICC Marks', 'url' => 'https://bps.dti.gov.ph/product-certification/ps-and-icc-marks'],
        ['label' => 'DTI-BPS Products Under Mandatory Certification', 'url' => 'https://bps.dti.gov.ph/product-certification/list-of-products-under-mandatory-certification'],
    ];

    public function __construct(
        private readonly CatalogAccess $access,
        private readonly VendorCatalogService $catalog,
        private readonly CatalogFileStore $files,
        private readonly ImageContentValidator $images,
        private readonly ComplianceTextExtractor $extractor,
        private readonly QrPayloadParser $qr,
        private readonly ComplianceReferenceProvider $reference,
        private readonly ListingTransitions $transitions,
        private readonly ListingReadiness $readiness,
        private readonly MarketplaceDiscoverability $discoverability,
        private readonly AuditRecorder $audit,
        private readonly OutboxPublisher $outbox,
    ) {}

    /** @return array<string, mixed> */
    public function uploadEvidence(Request $request, string $listingId, string $path, UploadedFile $file, ?string $qrPayload): array
    {
        $organizationId = $this->access->organizationFor($request, CatalogAccess::SUBMIT_COMPLIANCE);
        if (! in_array($path, self::PATHS, true)) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['path' => ['Choose Photo/OCR, QR or Manual Entry.']]);
        }
        $image = $this->images->validate($file, (int) config('materyalph.catalog.max_compliance_evidence_kb', 10240), $path === 'QR' ? 'QR image' : 'marking photo');
        DB::transaction(function () use ($organizationId, $listingId): void {
            $this->access->lockActiveStore($organizationId);
            $listing = $this->catalog->ownedListing($listingId, $organizationId, false);
            if (! $listing->regulated) {
                throw new AuthenticationException('COMPLIANCE_NOT_REQUIRED', 'This material is not on the DTI-BPS regulated list, so no PS/ICC evidence is requested.', 422);
            }
        });
        $fileId = $this->files->store($file, 'VENDOR_ORGANIZATION', $organizationId, CatalogFileStore::COMPLIANCE_EVIDENCE, (int) $request->user()->getKey(), $image['mime']);
        $extraction = match ($path) {
            'PHOTO_OCR' => $this->extractor->extract((string) $file->getRealPath(), $image['mime']) + ['source' => 'OCR', 'provider' => $this->extractor->provider()],
            'QR' => $this->qr->parse($qrPayload) + ['source' => 'QR', 'provider' => 'BROWSER_QR_DECODER'],
            default => null,
        };
        try {
            $evidenceId = DB::transaction(function () use ($request, $organizationId, $listingId, $fileId, $path, $extraction): string {
                $evidenceId = (string) Str::uuid7();
                DB::table('compliance_evidence')->insert(['id' => $evidenceId, 'compliance_submission_id' => null, 'vendor_organization_id' => $organizationId, 'vendor_listing_id' => $listingId, 'file_id' => $fileId, 'evidence_kind' => $path === 'QR' ? 'QR_IMAGE' : 'MARKING_PHOTO', 'path' => $path, 'uploaded_by_user_id' => $request->user()->getKey(), 'payload' => json_encode(['path' => $path], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
                if ($extraction !== null) {
                    DB::table('compliance_extractions')->insert(['id' => (string) Str::uuid7(), 'compliance_submission_id' => null, 'compliance_evidence_id' => $evidenceId, 'source' => $extraction['source'], 'provider' => $extraction['provider'], 'status' => $extraction['status'], 'confidence' => $extraction['confidence'], 'payload' => json_encode(['suggestions' => $extraction['suggestions']], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
                }
                $this->audit->account($request, 'PRODUCT_COMPLIANCE_EVIDENCE_UPLOADED', 'COMPLIANCE_EVIDENCE', $evidenceId, after: ['path' => $path, 'listing_id' => $listingId]);

                return $evidenceId;
            });
        } catch (\Throwable $exception) {
            $this->files->discard($fileId);
            throw $exception;
        }
        $stored = DB::table('files')->where('id', $fileId)->first(['content_type', 'byte_size', 'scan_state']);

        return [
            'evidence_id' => $evidenceId, 'file_id' => $fileId, 'path' => $path, 'evidence_kind' => $path === 'QR' ? 'QR_IMAGE' : 'MARKING_PHOTO',
            'content_type' => $stored->content_type, 'byte_size' => (int) $stored->byte_size, 'scan_state' => $stored->scan_state,
            'extraction' => $extraction === null ? ['source' => null, 'status' => 'NOT_REQUESTED', 'confidence' => null, 'suggestions' => (object) []]
                : ['source' => $extraction['source'], 'status' => $extraction['status'], 'confidence' => $extraction['confidence'], 'suggestions' => (object) $extraction['suggestions'], 'assistance_only' => true],
        ];
    }

    /**
     * Review and Confirm. Values are the Vendor-confirmed declaration, never raw extraction.
     *
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function submit(Request $request, string $listingId, array $input): array
    {
        $organizationId = $this->access->organizationFor($request, CatalogAccess::SUBMIT_COMPLIANCE);
        $key = $this->access->requireIdempotencyKey($request);
        $notice = DB::transaction(function () use ($request, $organizationId, $listingId, $input, $key): ?array {
            $this->access->lockActiveStore($organizationId);
            if ($this->access->replayed($request, 'catalog.compliance.submit', $key, $listingId)) {
                return null;
            }
            $listing = $this->catalog->ownedListing($listingId, $organizationId, true);
            if ((int) $input['listing_lock_version'] !== (int) $listing->lock_version) {
                throw new AuthenticationException('RESOURCE_VERSION_CONFLICT', 'This listing changed in another session. Reload before submitting evidence.', 409, ['current_lock_version' => (int) $listing->lock_version]);
            }
            if (! $listing->regulated || $listing->regulated_material_rule_id === null) {
                throw new AuthenticationException('COMPLIANCE_NOT_REQUIRED', 'This material is not on the DTI-BPS regulated list, so no PS/ICC evidence is requested.', 422);
            }
            if ($listing->compliance_status === 'VERIFIED') {
                throw new AuthenticationException('COMPLIANCE_ALREADY_VERIFIED', 'This listing already has verified PS/ICC evidence. A compliance-sensitive product edit reopens verification.', 409);
            }
            $evidence = DB::table('compliance_evidence as e')->join('files as f', 'f.id', '=', 'e.file_id')->whereIn('e.id', $input['evidence_ids'])
                ->where('e.vendor_listing_id', $listingId)->where('e.vendor_organization_id', $organizationId)->whereNull('e.compliance_submission_id')
                ->where('f.scan_state', 'CLEAN')->where('f.visibility', 'PRIVATE')->lockForUpdate()->get(['e.id', 'e.evidence_kind', 'e.file_id']);
            if ($evidence->count() !== count(array_unique($input['evidence_ids']))) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['evidence_ids' => ['Attach evidence uploaded for this listing that passed the safety check and is not already submitted.']]);
            }
            $path = (string) $input['path'];
            $requiredKinds = $path === 'MANUAL' ? ['MARKING_PHOTO'] : ['MARKING_PHOTO', 'QR_IMAGE'];
            if (! $evidence->contains(fn (object $item): bool => in_array($item->evidence_kind, $requiredKinds, true))) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['evidence_ids' => [$path === 'MANUAL' ? 'Manual Entry requires a clear photo of the physical marking.' : 'Attach the marking photo or QR image as evidence.']]);
            }
            $declared = [
                'marking_type' => (string) $input['marking_type'],
                'certificate_number' => trim((string) $input['certificate_number']),
                'manufacturer_name' => $this->text($input['manufacturer_name'] ?? null),
                'manufacturer_address' => $this->text($input['manufacturer_address'] ?? null),
                'importer_name' => $this->text($input['importer_name'] ?? null),
                'importer_address' => $this->text($input['importer_address'] ?? null),
                'country_of_manufacture' => $this->text($input['country_of_manufacture'] ?? null),
                'brand' => $this->text($input['brand'] ?? null),
                'batch_number' => $this->text($input['batch_number'] ?? null),
            ];
            $rule = DB::table('regulated_material_rules')->where('id', $listing->regulated_material_rule_id)->first();
            $match = $this->reference->match($declared, RegisterNormalizer::standards($rule->reference_standard));

            DB::table('compliance_submissions')->where('vendor_listing_id', $listingId)->where('status', 'PENDING_ADMIN_REVIEW')->update(['status' => 'SUPERSEDED', 'lock_version' => DB::raw('lock_version + 1'), 'updated_at' => now()]);
            $previous = DB::table('compliance_submissions')->where('vendor_listing_id', $listingId)->orderByDesc('version')->first(['id', 'version']);
            $submissionId = (string) Str::uuid7();
            $verified = $match->result === ReferenceMatch::MATCHED;
            DB::table('compliance_submissions')->insert([
                'id' => $submissionId, 'vendor_listing_id' => $listingId, 'vendor_organization_id' => $organizationId, 'path' => $path, 'status' => $verified ? 'VERIFIED' : 'PENDING_ADMIN_REVIEW',
                'version' => ($previous === null ? 0 : (int) $previous->version) + 1, 'regulated_material_rule_id' => $rule->id, 'rule_version' => (int) $rule->version,
                'marking_type' => $declared['marking_type'], 'declared' => json_encode($declared, JSON_THROW_ON_ERROR), 'submitted_by_user_id' => $request->user()->getKey(),
                'submitted_at' => now(), 'supersedes_submission_id' => $previous?->id, 'decided_at' => $verified ? now() : null,
                'listing_fingerprint' => $this->catalog->listingFingerprint($listingId), 'created_at' => now(), 'updated_at' => now(),
            ]);
            DB::table('compliance_evidence')->whereIn('id', $evidence->pluck('id'))->update(['compliance_submission_id' => $submissionId, 'attached_at' => now(), 'updated_at' => now()]);
            DB::table('compliance_extractions')->whereIn('compliance_evidence_id', $evidence->pluck('id'))->update(['compliance_submission_id' => $submissionId, 'updated_at' => now()]);
            DB::table('compliance_reference_matches')->insert(['id' => (string) Str::uuid7(), 'compliance_submission_id' => $submissionId, 'provider' => $match->provider, 'result' => $match->result, 'source_reference' => $match->sourceReference, 'checked_at' => now(), 'payload' => json_encode($match->details + ['register_id' => $match->registerId], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
            if ($verified) {
                // Approved rule: an exact current register match is recorded as an audited system decision.
                DB::table('compliance_reviews')->insert(['id' => (string) Str::uuid7(), 'compliance_submission_id' => $submissionId, 'reviewer_user_id' => null, 'decision' => 'APPROVED', 'reason' => 'Exact DTI-BPS register match ('.($match->details['rule'] ?? 'register').').', 'source_reference' => $match->sourceReference, 'submission_version' => ($previous === null ? 0 : (int) $previous->version) + 1, 'submission_lock_version' => 1, 'evidence_file_ids' => json_encode($evidence->pluck('file_id')->all(), JSON_THROW_ON_ERROR), 'reviewed_at' => now(), 'payload' => json_encode(['register_id' => $match->registerId, 'record_id' => $match->details['record_id'] ?? null], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
            }
            DB::table('vendor_listings')->where('id', $listingId)->update(['compliance_status' => $verified ? 'VERIFIED' : 'PENDING_ADMIN_REVIEW', 'current_compliance_submission_id' => $submissionId, 'lock_version' => DB::raw('lock_version + 1'), 'updated_at' => now()]);
            $this->advanceListing($listingId, $request->user()->getKey(), $verified ? 'SYSTEM' : 'VENDOR', $submissionId);
            $this->access->claim($request, 'catalog.compliance.submit', $key, $listingId, 201);
            $this->audit->account($request, 'PRODUCT_COMPLIANCE_SUBMITTED', 'COMPLIANCE_SUBMISSION', $submissionId, after: ['path' => $path, 'reference_result' => $match->result, 'status' => $verified ? 'VERIFIED' : 'PENDING_ADMIN_REVIEW']);
            $this->discoverability->evaluate($organizationId, $request->user()->getKey(), 'VENDOR');

            return $verified ? [$organizationId, (string) $listing->display_name, 'verified through an exact DTI-BPS register match'] : null;
        });
        if ($notice !== null) {
            $this->notify(...$notice);
        }

        return $this->catalog->present($request, $this->catalog->ownedListing($listingId, $organizationId, false));
    }

    /**
     * @param  array<string, mixed>  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function queue(Request $request, array $filters): array
    {
        $this->access->requireAdmin($request, 'product_compliance.review');
        $status = $filters['status'] ?? 'PENDING_ADMIN_REVIEW';
        $query = DB::table('compliance_submissions as s')->join('vendor_listings as l', 'l.id', '=', 's.vendor_listing_id')->join('products as p', 'p.id', '=', 'l.product_id')
            ->leftJoin('materials as m', 'm.id', '=', 'p.material_id')->leftJoin('store_profiles as sp', 'sp.vendor_organization_id', '=', 'l.vendor_organization_id')
            ->leftJoin('regulated_material_rules as r', 'r.id', '=', 's.regulated_material_rule_id')
            ->leftJoin('compliance_reference_matches as rm', 'rm.compliance_submission_id', '=', 's.id');
        if ($status !== 'ALL') {
            $query->where('s.status', $status);
        }
        if (! empty($filters['path'])) {
            $query->where('s.path', $filters['path']);
        }
        if (! empty($filters['reference_result'])) {
            $query->where('rm.result', $filters['reference_result']);
        }
        $query->orderBy('s.submitted_at', ($filters['sort'] ?? 'oldest') === 'newest' ? 'desc' : 'asc')->orderBy('s.id');
        $page = $query->paginate(20, ['s.id', 's.version', 's.path', 's.status', 's.marking_type', 's.submitted_at', 'l.id as listing_id', 'l.display_name', 'l.vendor_sku', 'sp.public_store_name', 'm.name as material_name', 'r.product_name', 'r.reference_standard', 'rm.result as reference_result'], 'page', (int) ($filters['page'] ?? 1));

        return ['items' => array_map(static fn (object $row): array => (array) $row, $page->items()), 'meta' => ['current_page' => $page->currentPage(), 'last_page' => $page->lastPage(), 'total' => $page->total()]];
    }

    /** @return array<string, mixed> */
    public function detail(Request $request, string $submissionId): array
    {
        $this->access->requireAdmin($request, 'product_compliance.review');
        $submission = DB::table('compliance_submissions')->where('id', $submissionId)->first();
        if ($submission === null) {
            throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The compliance submission is unavailable.', 404);
        }
        $listing = DB::table('vendor_listings as l')->join('products as p', 'p.id', '=', 'l.product_id')->leftJoin('materials as m', 'm.id', '=', 'p.material_id')
            ->leftJoin('material_categories as c', 'c.id', '=', 'l.material_category_id')->leftJoin('store_profiles as sp', 'sp.vendor_organization_id', '=', 'l.vendor_organization_id')
            ->where('l.id', $submission->vendor_listing_id)
            ->first(['l.id', 'l.display_name', 'l.vendor_sku', 'l.status', 'l.compliance_status', 'l.description', 'l.lock_version', 'l.technical_attributes', 'p.brand', 'p.model', 'p.manufacturer', 'p.manufacturer_address', 'p.country_of_manufacture', 'm.name as material_name', 'm.code as material_code', 'c.name as category_name', 'sp.public_store_name']);
        $rule = DB::table('regulated_material_rules')->where('id', $submission->regulated_material_rule_id)->first();
        $evidence = DB::table('compliance_evidence as e')->join('files as f', 'f.id', '=', 'e.file_id')->where('e.compliance_submission_id', $submissionId)->orderBy('e.created_at')
            ->get(['e.id', 'e.evidence_kind', 'e.path', 'e.file_id', 'e.created_at', 'f.content_type', 'f.byte_size', 'f.scan_state', 'f.checksum_sha256']);
        $extractions = DB::table('compliance_extractions')->where('compliance_submission_id', $submissionId)->orderBy('created_at')->get(['id', 'source', 'provider', 'status', 'confidence', 'payload', 'compliance_evidence_id']);
        $match = DB::table('compliance_reference_matches')->where('compliance_submission_id', $submissionId)->orderByDesc('created_at')->first();

        return [
            'submission' => ['id' => $submission->id, 'version' => (int) $submission->version, 'lock_version' => (int) $submission->lock_version, 'path' => $submission->path, 'status' => $submission->status, 'marking_type' => $submission->marking_type, 'declared' => ComparableMappingService::decode($submission->declared), 'submitted_at' => $submission->submitted_at, 'decided_at' => $submission->decided_at, 'rule_version' => $submission->rule_version === null ? null : (int) $submission->rule_version],
            'listing' => $listing === null ? null : ((array) $listing) + ['technical_attributes' => ComparableMappingService::decode($listing->technical_attributes), 'media_file_ids' => DB::table('listing_media')->where('vendor_listing_id', $listing->id)->where('status', 'READY')->orderBy('sort_order')->pluck('file_id')->all()],
            'rule' => $rule === null ? null : ['id' => $rule->id, 'version' => (int) $rule->version, 'product_name' => $rule->product_name, 'reference_standard' => $rule->reference_standard, 'technical_regulation' => $rule->technical_regulation, 'scope' => $rule->scope, 'required_marking' => $rule->required_marking, 'marking_requirements' => ComparableMappingService::decode($rule->marking_requirements), 'source_reference' => $rule->source_reference],
            'evidence' => $evidence->map(fn (object $item): array => ['id' => $item->id, 'evidence_kind' => $item->evidence_kind, 'path' => $item->path, 'file_id' => $item->file_id, 'content_type' => $item->content_type, 'byte_size' => (int) $item->byte_size, 'scan_state' => $item->scan_state, 'checksum_prefix' => substr((string) $item->checksum_sha256, 0, 12), 'uploaded_at' => $item->created_at])->all(),
            'extractions' => $extractions->map(fn (object $item): array => ['source' => $item->source, 'provider' => $item->provider, 'status' => $item->status, 'confidence' => $item->confidence === null ? null : (float) $item->confidence, 'suggestions' => ComparableMappingService::decode($item->payload)['suggestions'] ?? [], 'assistance_only' => true])->all(),
            'reference_match' => $match === null ? null : ['result' => $match->result, 'provider' => $match->provider, 'source_reference' => $match->source_reference, 'checked_at' => $match->checked_at, 'details' => ComparableMappingService::decode($match->payload)],
            'previous_submissions' => DB::table('compliance_submissions')->where('vendor_listing_id', $submission->vendor_listing_id)->where('id', '!=', $submissionId)->orderByDesc('version')->limit(20)->get(['id', 'version', 'path', 'status', 'marking_type', 'submitted_at', 'decided_at'])->all(),
            'reviews' => DB::table('compliance_reviews as r')->leftJoin('users as u', 'u.id', '=', 'r.reviewer_user_id')->join('compliance_submissions as s', 's.id', '=', 'r.compliance_submission_id')
                ->where('s.vendor_listing_id', $submission->vendor_listing_id)->orderByDesc('r.created_at')->limit(30)
                ->get(['r.id', 'r.compliance_submission_id', 'r.decision', 'r.reason', 'r.remarks', 'r.source_reference', 'r.submission_version', 'r.reviewed_at', 'u.name as reviewer_name'])
                ->map(fn (object $review): array => ((array) $review) + ['source' => $review->reviewer_name === null ? 'SYSTEM_REGISTER_MATCH' : 'ADMIN'])->all(),
            'official_references' => self::OFFICIAL_REFERENCES,
        ];
    }

    /**
     * @param  array{decision: string, reason?: ?string, remarks?: ?string, lock_version: int, source_reference?: ?string}  $input
     * @return array<string, mixed>
     */
    public function decide(Request $request, string $submissionId, array $input): array
    {
        $this->access->requireAdmin($request, 'product_compliance.review');
        $key = $this->access->requireIdempotencyKey($request);
        $notice = DB::transaction(function () use ($request, $submissionId, $input, $key): ?array {
            $listingId = DB::table('compliance_submissions')->where('id', $submissionId)->value('vendor_listing_id');
            if (! is_string($listingId)) {
                throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The compliance submission is unavailable.', 404);
            }
            $listing = DB::table('vendor_listings')->where('id', $listingId)->lockForUpdate()->first();
            $submission = DB::table('compliance_submissions')->where('id', $submissionId)->lockForUpdate()->first();
            if ($this->access->replayed($request, 'admin.product-compliance.decide', $key, $submissionId)) {
                return null;
            }
            if ($submission->status !== 'PENDING_ADMIN_REVIEW' || (int) $input['lock_version'] !== (int) $submission->lock_version) {
                throw new AuthenticationException('STALE_REVIEW', 'This submission changed or was already decided. Refresh to review the current version.', 409, ['current_status' => $submission->status, 'current_lock_version' => (int) $submission->lock_version]);
            }
            $decision = (string) $input['decision'];
            $reason = $this->text($input['reason'] ?? null);
            if ($decision !== 'APPROVED' && ($reason === null || mb_strlen($reason) < 3)) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['reason' => ['A reason is required to return for correction or reject.']]);
            }
            $status = ['APPROVED' => 'VERIFIED', 'CHANGES_REQUIRED' => 'CHANGES_REQUIRED', 'REJECTED' => 'REJECTED'][$decision];
            $evidenceFiles = DB::table('compliance_evidence')->where('compliance_submission_id', $submissionId)->orderBy('id')->pluck('file_id')->all();
            $reviewId = (string) Str::uuid7();
            DB::table('compliance_reviews')->insert(['id' => $reviewId, 'compliance_submission_id' => $submissionId, 'reviewer_user_id' => $request->user()->getKey(), 'decision' => $decision, 'reason' => $reason, 'remarks' => $this->text($input['remarks'] ?? null), 'source_reference' => $this->text($input['source_reference'] ?? null), 'submission_version' => (int) $submission->version, 'submission_lock_version' => (int) $submission->lock_version, 'evidence_file_ids' => json_encode($evidenceFiles, JSON_THROW_ON_ERROR), 'reviewed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
            DB::table('compliance_submissions')->where('id', $submissionId)->update(['status' => $status, 'decided_at' => now(), 'lock_version' => DB::raw('lock_version + 1'), 'updated_at' => now()]);
            // A decision only applies to the listing when it is still the listing's current declaration.
            if ($listing->current_compliance_submission_id === $submissionId) {
                if ($status !== 'VERIFIED' && in_array($listing->status, ['ACTIVE', 'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED'], true)) {
                    $this->transitions->transition($listing, 'PENDING_COMPLIANCE', 'ADMIN', $request->user()->getKey(), 'COMPLIANCE_'.$decision, $reason, $submissionId);
                }
                DB::table('vendor_listings')->where('id', $listingId)->update(['compliance_status' => $status, 'lock_version' => DB::raw('lock_version + 1'), 'updated_at' => now()]);
                $this->advanceListing($listingId, $request->user()->getKey(), 'ADMIN', $submissionId, $reason);
            }
            $this->access->claim($request, 'admin.product-compliance.decide', $key, $submissionId, 200);
            $this->audit->account($request, 'PRODUCT_COMPLIANCE_DECIDED', 'COMPLIANCE_SUBMISSION', $submissionId, before: ['status' => $submission->status, 'version' => (int) $submission->version], after: ['status' => $status, 'review_id' => $reviewId], reason: $reason);
            $this->discoverability->evaluate((string) $listing->vendor_organization_id, $request->user()->getKey(), 'ADMIN');

            return [(string) $listing->vendor_organization_id, (string) $listing->display_name, match ($decision) {
                'APPROVED' => 'approved by Product Compliance review', 'CHANGES_REQUIRED' => 'returned for correction: '.$reason, default => 'rejected: '.$reason
            }];
        });
        if ($notice !== null) {
            $this->notify(...$notice);
        }

        return $this->detail($request, $submissionId);
    }

    /** @return array{url: string, expires_at: string} */
    public function adminFileUrl(Request $request, string $fileId): array
    {
        $this->access->requireAdmin($request, 'product_compliance.view_evidence');
        $file = DB::table('files')->where('id', $fileId)->where('scan_state', 'CLEAN')->first();
        $allowed = $file !== null && (
            ($file->purpose === CatalogFileStore::COMPLIANCE_EVIDENCE && DB::table('compliance_evidence')->where('file_id', $fileId)->whereNotNull('compliance_submission_id')->exists())
            || ($file->purpose === CatalogFileStore::LISTING_MEDIA && DB::table('listing_media')->where('file_id', $fileId)->exists())
        );
        if (! $allowed) {
            throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The file is unavailable.', 404);
        }
        $this->audit->account($request, 'PRODUCT_COMPLIANCE_EVIDENCE_VIEWED', 'FILE', $fileId);

        return $this->files->temporaryUrl($file);
    }

    /** Moves a listing whose compliance changed to its publication target, when the Vendor asked to publish. */
    private function advanceListing(string $listingId, ?int $actorId, string $source, string $submissionId, ?string $reason = null): void
    {
        $listing = DB::table('vendor_listings')->where('id', $listingId)->first();
        if (! in_array($listing->status, ['PENDING_COMPLIANCE', 'PENDING_ADMIN_REVIEW', 'REJECTED'], true) && ! ($listing->status === 'DRAFT' && $listing->publication_requested_at !== null)) {
            return;
        }
        $target = ListingTransitions::publicationTarget($listing);
        if ($target === 'ACTIVE') {
            $organization = DB::table('vendor_organizations')->where('id', $listing->vendor_organization_id)->first(['store_activation_status']);
            if ($listing->publication_requested_at === null || $organization->store_activation_status !== 'ACTIVE' || $this->readiness->evaluate($listingId)['blockers'] !== []) {
                // Verified evidence does not publish a listing that is not otherwise ready or was not submitted for publication.
                $target = 'DRAFT';
            }
        }
        $this->transitions->transition($listing, $target, $source, $actorId, 'COMPLIANCE_'.($listing->compliance_status), $reason, $submissionId);
    }

    private function notify(string $organizationId, string $listingName, string $outcome): void
    {
        $recipients = DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->where('m.vendor_organization_id', $organizationId)->where('m.status', 'ACTIVE')
            ->whereIn('m.role', ['OWNER', 'STORE_MANAGER', 'STORE_STAFF', 'INVENTORY'])->where('u.account_status', 'ACTIVE')->orderBy('u.id')->get(['u.id', 'u.email', 'm.role']);
        $body = 'PS/ICC evidence for “'.Str::limit($listingName, 120).'” was '.$outcome.'.';
        foreach ($recipients as $recipient) {
            $notificationId = (string) Str::uuid7();
            DB::table('notifications')->insert(['id' => $notificationId, 'user_id' => $recipient->id, 'category' => 'PRODUCT_COMPLIANCE', 'title' => 'Product compliance update', 'body' => $body, 'resource_type' => 'VENDOR_ORGANIZATION', 'resource_id' => $organizationId, 'created_at' => now(), 'updated_at' => now()]);
            if ($recipient->role === 'OWNER') {
                $this->outbox->publish('PRODUCT_COMPLIANCE_NOTICE', 'VENDOR_ORGANIZATION', $organizationId, ['recipient' => $recipient->email, 'message' => $body, 'notification_id' => $notificationId]);
            }
        }
    }

    private function text(mixed $value): ?string
    {
        if (! is_string($value) || trim($value) === '') {
            return null;
        }

        return Str::limit(trim((string) preg_replace('/\s+/u', ' ', $value)), 500, '');
    }
}
