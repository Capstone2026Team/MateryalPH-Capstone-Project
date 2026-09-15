<?php

declare(strict_types=1);

namespace App\Console\Commands;

use App\Domain\Identity\AuditRecorder;
use App\Domain\Vendors\ActivationReadiness;
use App\Domain\Vendors\DocumentRequirements;
use App\Domain\Vendors\ReviewVendorEvidence;
use Illuminate\Console\Command;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class EvaluateVendorEvidence extends Command
{
    protected $signature = 'materyalph:vendor-evidence-evaluate';

    protected $description = 'Evaluate verified document expiry and invitation expiration in bounded batches';

    public function handle(DocumentRequirements $requirements, ActivationReadiness $readiness, AuditRecorder $audit, ReviewVendorEvidence $notices): int
    {
        DB::table('vendor_organizations')->orderBy('id')->chunkById(100, function ($organizations) use ($requirements, $readiness, $audit, $notices): void {
            foreach ($organizations as $organization) {
                DB::transaction(function () use ($organization, $requirements, $readiness, $audit, $notices): void {
                    DB::table('vendor_organizations')->where('id', $organization->id)->lockForUpdate()->firstOrFail();
                    $request = Request::create('/scheduled/vendor-evidence');
                    $request->attributes->set('correlation_id', (string) Str::uuid7());
                    $request->attributes->set('account_scope', ['role' => 'SYSTEM', 'organization_id' => $organization->id]);
                    $changed = false;
                    foreach (DB::table('business_documents')->where('vendor_organization_id', $organization->id)->get() as $document) {
                        $effective = $requirements->effective($organization->id, $document->document_type);
                        if ($effective['status'] === 'EXPIRED' && $document->status !== 'EXPIRED') {
                            DB::table('business_documents')->where('id', $document->id)->update(['status' => 'EXPIRED', 'updated_at' => now()]);
                            $audit->account($request, 'VENDOR_DOCUMENT_EXPIRED', 'BUSINESS_DOCUMENT', $document->id, after: ['version_id' => $effective['version_id']]);
                            $notices->notice($organization->id, 'Verified business evidence expired. Review activation requirements and submit a replacement.');
                            $changed = true;
                        } elseif ($effective['status'] === 'APPROVED' && $effective['expires_on'] !== null && $document->expiry_warned_at === null
                            && Carbon::parse($effective['expires_on'], 'Asia/Manila')->startOfDay()->lessThanOrEqualTo(now()->addDays(max(1, (int) config('vendor_onboarding.expiry_reminder_days'))))) {
                            DB::table('business_documents')->where('id', $document->id)->update(['expiry_warned_at' => now()]);
                            $notices->notice($organization->id, 'Verified business evidence expires on '.$effective['expires_on'].' (Asia/Manila). Review your documents.');
                            $audit->account($request, 'VENDOR_DOCUMENT_EXPIRY_WARNING', 'BUSINESS_DOCUMENT', $document->id);
                        }
                    }
                    foreach (DB::table('vendor_invitations')->where('vendor_organization_id', $organization->id)->whereNull('accepted_at')->whereNull('revoked_at')->whereNull('expiry_recorded_at')->where('expires_at', '<=', now())->orderBy('id')->lockForUpdate()->get() as $invitation) {
                        DB::table('vendor_invitations')->where('id', $invitation->id)->update(['expiry_recorded_at' => now()]);
                        $audit->account($request, 'VENDOR_INVITATION_EXPIRED', 'VENDOR_INVITATION', $invitation->id);
                    }
                    if ($changed || in_array($organization->marketplace_status, ['ACTIVE', 'RESTRICTED'], true)) {
                        $readiness->reconcile($request, $organization->id);
                    }
                });
            }
        });
        $this->info('Vendor evidence and invitation evaluation completed.');

        return self::SUCCESS;
    }
}
