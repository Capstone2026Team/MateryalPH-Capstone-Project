<?php

declare(strict_types=1);

namespace App\Domain\Reporting;

use App\Domain\Finance\FinanceAccess;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class TaxPackageService
{
    /** @param array<string, mixed> $input
     * @return array<string, mixed> */
    public function prepare(Request $request, array $input): array
    {
        $actor = app(FinanceAccess::class)->admin($request, 'finance.export');
        $key = $request->header('Idempotency-Key');
        if (! is_string($key) || strlen($key) < 8 || strlen($key) > 128) {
            throw new AuthenticationException('IDEMPOTENCY_KEY_REQUIRED', 'Provide an Idempotency-Key for this package.', 422);
        }
        $fingerprint = hash('sha256', json_encode([$input['form'], $input['period_start'], $input['withholding_entity'], $input['vendor_organization_id'] ?? null], JSON_THROW_ON_ERROR));
        $period = TaxCalendar::period($input['form'], $input['period_start']);
        if ($input['form'] === '2307' && empty($input['vendor_organization_id'])) {
            throw new AuthenticationException('PAYEE_REQUIRED', 'A 2307 support package must name one Vendor payee.', 422);
        }

        return DB::transaction(function () use ($input, $request, $actor, $period, $key, $fingerprint): array {
            DB::table('users')->where('id', $actor)->lockForUpdate()->first();
            $existing = DB::table('tax_report_packages')->where('prepared_by_user_id', $actor)->where('request_key', hash('sha256', $key))->first();
            if ($existing !== null) {
                if (! hash_equals($existing->request_hash, $fingerprint)) {
                    throw new AuthenticationException('IDEMPOTENCY_CONFLICT', 'Use a new key for a different reporting scope.', 409);
                }

                return $this->detail($request, $existing->id);
            }
            $calendar = DB::table('filing_calendar_versions')->where('environment', 'TEST')->where('source_type', 'FIN08_NON_EFPS_DEMO')->orderByDesc('version')->first();
            if ($calendar === null) {
                throw new AuthenticationException('DUE_DATE_REVIEW_REQUIRED', 'The versioned demo filing calendar is unavailable.', 409);
            }
            $start = CarbonImmutable::parse($period['start'], 'Asia/Manila')->utc();
            $end = CarbonImmutable::parse($period['end'], 'Asia/Manila')->addDay()->utc();
            $query = DB::table('remittance_assessments as a')->join('orders as o', 'o.id', '=', 'a.order_id')
                ->where('a.environment', 'TEST')->where('a.assigned_withholding_entity', $input['withholding_entity'])->where('a.calculation_state', '<>', 'VOIDED')
                ->whereExists(fn ($q) => $q->selectRaw('1')->from('remittance_collections as c')->whereColumn('c.remittance_group_id', 'a.remittance_group_id')->where('c.collected_at', '>=', $start)->where('c.collected_at', '<', $end));
            if (! empty($input['vendor_organization_id'])) {
                $query->where('o.vendor_organization_id', $input['vendor_organization_id']);
            }
            $sources = $query->orderBy('a.id')->get(['a.*', 'o.vendor_organization_id']);
            if ($sources->count() > 10000) {
                throw new AuthenticationException('EXPORT_TOO_LARGE', 'Prepare a smaller reporting scope.', 422);
            }
            $rows = [['Form', $input['form'], 'Version', 'FIN08-DEMO-v1'], ['Issuer', $input['withholding_entity']], ['Calendar period', $period['start'], $period['end']],
                ['Payee', 'Month', 'ATC', 'Gross basis PHP', 'Withheld PHP', 'Relief / reconciliation', 'Assessment']];
            $versions = [];
            $blockers = [];
            $lines = [];
            $monthly = [];
            $basis = $tax = 0;
            foreach ($sources as $source) {
                $instant = (string) DB::table('remittance_collections')->where('remittance_group_id', $source->remittance_group_id)->min('collected_at');
                $profile = $source->tax_profile_version_id === null ? null : DB::table('vendor_tax_profile_versions')->where('id', $source->tax_profile_version_id)->first();
                $atc = $source->reporting_atc;
                if ($profile === null || $atc === null) {
                    $blockers[] = 'HISTORICAL_TAX_SOURCE_REVIEW_REQUIRED';
                }
                if ($source->calculation_state !== 'POSTED' || $source->reconciliation_state === 'RECONCILIATION_EXCEPTION') {
                    $blockers[] = 'RECONCILIATION_REQUIRED';
                }
                $adjustments = DB::table('tax_adjustments')->where('remittance_assessment_id', $source->id)->orderBy('id')->get();
                $gross = (int) $source->gross_basis_centavos;
                $withheld = (int) $source->withheld_centavos;
                foreach ($adjustments as $adjustment) {
                    if ($adjustment->state !== 'REJECTED') {
                        // No implicit reversal: an adjustment must explicitly provide the reviewed resulting base/tax.
                        $after = json_decode($adjustment->after_values, true);
                        if ($adjustment->state !== 'POSTED' || ! is_int($after['gross_basis_centavos'] ?? null) || ! is_int($after['withheld_centavos'] ?? null)) {
                            $blockers[] = 'TAX_ADJUSTMENT_REVIEW_REQUIRED';
                        } else {
                            $gross = $after['gross_basis_centavos'];
                            $withheld = $after['withheld_centavos'];
                        }
                    }
                    $versions['adjustments'][] = ['id' => $adjustment->id, 'state' => $adjustment->state, 'posted_at' => $adjustment->posted_at, 'hash' => hash('sha256', $adjustment->after_values)];
                }
                $month = CarbonImmutable::parse($instant)->setTimezone('Asia/Manila')->format('Y-m');
                $line = ['assessment_id' => $source->id, 'vendor_id' => $source->vendor_organization_id, 'month' => $month, 'atc' => $atc,
                    'basis_centavos' => $gross, 'tax_centavos' => $withheld, 'relief_reason' => $source->threshold_status, 'profile_version' => $source->tax_profile_version_id,
                    'atc_rule_version' => $source->atc_rule_version, 'source_hash' => hash('sha256', json_encode((array) $source, JSON_THROW_ON_ERROR))];
                $rows[] = [$source->vendor_organization_id, $month, $atc ?? 'REVIEW REQUIRED', DocumentSnapshot::money($gross), DocumentSnapshot::money($withheld), $source->threshold_status.' / '.$source->reconciliation_state, $source->id];
                $lines[] = $line;
                $versions['assessments'][] = $line;
                $group = $source->vendor_organization_id.':'.$month.':'.($atc ?? 'REVIEW_REQUIRED');
                $monthly[$group] ??= ['payee' => $source->vendor_organization_id, 'month' => $month, 'atc' => $atc, 'basis_centavos' => 0, 'tax_centavos' => 0];
                $monthly[$group]['basis_centavos'] += $gross;
                $monthly[$group]['tax_centavos'] += $withheld;
                $basis += $gross;
                $tax += $withheld;
            }
            ksort($monthly);
            foreach ($monthly as $group) {
                $rows[] = [$group['payee'], $group['month'], $group['atc'] ?? 'REVIEW REQUIRED', DocumentSnapshot::money($group['basis_centavos']), DocumentSnapshot::money($group['tax_centavos']), 'Monthly total', ''];
            }
            $rows[] = ['Period total', '', '', DocumentSnapshot::money($basis), DocumentSnapshot::money($tax), '', ''];
            $snapshot = ['rows' => $rows, 'versions' => $versions, 'blockers' => array_values(array_unique($blockers)), 'basis_centavos' => $basis, 'tax_centavos' => $tax,
                'monthly_totals' => array_values($monthly),
                'note' => 'Zero and exempt covered remittances are included. SAMPLE support data, not a BIR-valid electronic submission or issued certificate.'];
            $json = json_encode($snapshot, JSON_THROW_ON_ERROR);
            $id = (string) Str::uuid7();
            DB::table('tax_report_packages')->insert(['id' => $id, 'vendor_organization_id' => $input['vendor_organization_id'] ?? null, 'environment' => 'TEST', 'package_type' => $input['form'],
                'period_start' => $period['start'], 'period_end' => $period['end'], 'state' => 'DRAFT', 'filing_calendar_version_id' => $calendar->id,
                'prepared_by_user_id' => $actor, 'withholding_entity' => $input['withholding_entity'], 'form_version' => 'FIN08-DEMO-v1', 'nominal_due_date' => $period['nominal_due'],
                'request_key' => hash('sha256', $key), 'request_hash' => $fingerprint,
                'due_date_source' => TaxCalendar::SOURCE, 'snapshot' => $json, 'content_hash' => hash('sha256', $json), 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);
            foreach ($lines as $line) {
                DB::table('tax_report_package_lines')->insert(['id' => (string) Str::uuid7(), 'tax_report_package_id' => $id, 'source_type' => 'REMITTANCE_ASSESSMENT', 'source_id' => $line['assessment_id'],
                    'vendor_organization_id' => $line['vendor_id'], 'atc_code' => $line['atc'], 'basis_centavos' => $line['basis_centavos'], 'tax_centavos' => $line['tax_centavos'],
                    'source_snapshot' => json_encode($line, JSON_THROW_ON_ERROR), 'source_hash' => $line['source_hash'], 'created_at' => now(), 'updated_at' => now()]);
            }
            app(AuditRecorder::class)->account($request, 'TAX_PACKAGE_PREPARED', 'TAX_REPORT_PACKAGE', $id, after: ['source_hash' => hash('sha256', $json)]);

            return $this->detail($request, $id);
        });
    }

    /** @param array<string, mixed> $input
     * @return array<string, mixed> */
    public function review(Request $request, string $id, array $input): array
    {
        $actor = app(FinanceAccess::class)->admin($request, 'finance.review_tax');

        return DB::transaction(function () use ($request, $id, $input, $actor): array {
            $package = DB::table('tax_report_packages')->where('id', $id)->lockForUpdate()->first();
            if ($package === null || $package->state !== 'DRAFT' || (int) $package->lock_version !== $input['lock_version']) {
                throw new AuthenticationException('RESOURCE_VERSION_CONFLICT', 'Refresh the package before reviewing.', 409);
            }
            if ((int) $package->prepared_by_user_id === $actor) {
                throw new AuthenticationException('INDEPENDENT_REVIEW_REQUIRED', 'A different authorized finance reviewer must review this package.', 403);
            }
            $snapshot = json_decode($package->snapshot, true);
            if ($snapshot['blockers'] !== []) {
                throw new AuthenticationException('TAX_PACKAGE_RECONCILIATION_REQUIRED', 'Resolve the source exceptions and prepare a new package.', 409, ['blockers' => $snapshot['blockers']]);
            }
            if (empty($input['due_date_source']) || empty($input['actual_due_date']) || ! ($input['reconciled'] ?? false)) {
                throw new AuthenticationException('DUE_DATE_REVIEW_REQUIRED', 'An independent reviewer must cite and validate the actual deadline and source reconciliation.', 422);
            }
            // Reviewed source snapshots are immutable; source changes require another prepared version.
            foreach ($snapshot['versions']['assessments'] ?? [] as $source) {
                $current = DB::table('remittance_assessments as a')->join('orders as o', 'o.id', '=', 'a.order_id')->where('a.id', $source['assessment_id'])->first(['a.*', 'o.vendor_organization_id']);
                if ($current === null || ! hash_equals($source['source_hash'], hash('sha256', json_encode((array) $current, JSON_THROW_ON_ERROR)))) {
                    throw new AuthenticationException('SOURCE_VERSION_CHANGED', 'Source data changed. Prepare a new package.', 409);
                }
            }
            $assessmentIds = array_column($snapshot['versions']['assessments'] ?? [], 'assessment_id');
            $adjustments = DB::table('tax_adjustments')->whereIn('remittance_assessment_id', $assessmentIds)->orderBy('id')->get();
            $expected = array_column($snapshot['versions']['adjustments'] ?? [], null, 'id');
            if ($adjustments->count() !== count($expected)) {
                throw new AuthenticationException('SOURCE_VERSION_CHANGED', 'Tax adjustments changed. Prepare a new package.', 409);
            }
            foreach ($adjustments as $adjustment) {
                $before = $expected[$adjustment->id] ?? null;
                if ($before === null || $before['state'] !== $adjustment->state || $before['posted_at'] !== $adjustment->posted_at || ! hash_equals($before['hash'], hash('sha256', $adjustment->after_values))) {
                    throw new AuthenticationException('SOURCE_VERSION_CHANGED', 'Tax adjustments changed. Prepare a new package.', 409);
                }
            }
            DB::table('tax_report_packages')->where('id', $id)->update(['state' => 'REVIEWED', 'reviewed_by_user_id' => $actor, 'reviewed_at' => now(),
                'due_date_reviewer_id' => $actor, 'due_date_reviewed_at' => now(), 'actual_due_date' => $input['actual_due_date'], 'due_date_source' => $input['due_date_source'],
                'review_reason' => $input['reason'], 'lock_version' => $package->lock_version + 1, 'updated_at' => now()]);
            app(AuditRecorder::class)->account($request, 'TAX_PACKAGE_REVIEWED', 'TAX_REPORT_PACKAGE', $id, after: ['actual_due_date' => $input['actual_due_date'], 'source_hash' => $package->content_hash]);

            return $this->detail($request, $id);
        });
    }

    /** @return array<string, mixed> */
    public function detail(Request $request, string $id): array
    {
        app(FinanceAccess::class)->admin($request, 'finance.view');
        $package = DB::table('tax_report_packages')->where('id', $id)->first();
        if ($package === null) {
            throw new AuthenticationException('RESOURCE_NOT_FOUND', 'This package is unavailable.', 404);
        }
        $row = (array) $package;
        $row['snapshot'] = json_decode($package->snapshot, true);
        $row['due_date_status'] = $package->due_date_reviewer_id === null ? 'DUE_DATE_REVIEW_REQUIRED' : 'REVIEWED';

        return $row;
    }
}
