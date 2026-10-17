<?php

declare(strict_types=1);

namespace App\Domain\Reporting;

use App\Domain\Analytics\AnalyticsDataset;
use App\Domain\Analytics\AnalyticsRequest;
use App\Domain\Analytics\AnalyticsWindow;
use App\Domain\Analytics\Geo\GeoAnalyticsService;
use App\Domain\Analytics\MaterialsAnalyticsAssembler;
use App\Domain\Finance\VendorFinanceService;
use App\Domain\Geography\GeographyScopeResolver;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\AuditSearchService;
use App\Domain\Orders\OrderCommercial;
use App\Domain\Projects\ProjectBudget;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

/** Explicit projection: no provider bodies, contacts, private evidence, stock or tax identifiers. */
final class DocumentSnapshot
{
    /** @param array<string, mixed> $filters
     * @return array{rows: list<array<mixed>>, versions: array<string, mixed>} */
    public function capture(Request $request, string $type, ?string $id, array $filters): array
    {
        $rows = [];
        $versions = [];
        if (in_array($type, ['PURCHASE_ORDER', 'PAYMENT_CONFIRMATION', 'OPERATIONAL_ORDER'], true)) {
            $order = DB::table('orders')->where('id', $id)->first();
            $version = (int) ($order->accepted_snapshot_version ?? $order->current_snapshot_version);
            $snapshot = DB::table('order_snapshots')->where('order_id', $id)->where('version', $version)->first();
            if ($snapshot === null) {
                throw new AuthenticationException('SOURCE_NOT_AVAILABLE', 'An authoritative order snapshot is required.', 409);
            }
            $content = OrderCommercial::content($snapshot);
            $versions = ['order_snapshot' => $snapshot->id, 'version' => $version, 'content_hash' => $snapshot->content_hash, 'order_lock_version' => $order->lock_version];
            $rows[] = ['Order', $order->reference];
            $rows[] = ['Order status', $order->order_state];
            $rows[] = ['Commercial status', $order->accepted_snapshot_version === null ? 'REQUEST — subject to acceptance' : 'Accepted'];
            foreach (($content['commercial'] ?? []) as $key => $value) {
                if (is_int($value) && str_ends_with($key, '_centavos')) {
                    $rows[] = [self::label($key), self::money($value)];
                }
            }
            foreach (($content['commercial']['lines'] ?? []) as $line) {
                $lineId = (string) ($line['line_id'] ?? '');
                $frozen = DB::table('order_lines')->where('order_id', $id)->where('id', $lineId)->value('snapshot');
                $description = json_decode($frozen ?? '{}', true, flags: JSON_THROW_ON_ERROR);
                $rows[] = ['Item', (string) ($description['display_name'] ?? $lineId), (string) ($description['variant_label'] ?? ''), (string) ($description['unit_name'] ?? '')];
                $rows[] = ['Quantity', (string) ($line['quantity'] ?? ''), 'Unit price PHP', self::money((int) ($line['unit_price_centavos'] ?? 0))];
                $versions['order_lines'][] = ['id' => $lineId, 'hash' => hash('sha256', $frozen ?? '{}')];
            }
            if ($type === 'PAYMENT_CONFIRMATION') {
                $payments = DB::table('payments')->where('order_id', $id)->where('state', 'PAID')->orderBy('id')->get(['id', 'purpose', 'total_centavos', 'paid_at', 'evidence_origin']);
                $physical = DB::table('physical_payment_records')->where('order_id', $id)->whereIn('record_kind', ['COLLECTION', 'CORRECTION'])->whereIn('state', ['PARTIALLY_RECORDED', 'PHYSICAL_PAYMENT_RECORDED'])->orderBy('id')->get(['id', 'original_record_id', 'amount_centavos', 'recorded_at', 'state']);
                $superseded = $physical->pluck('original_record_id')->filter()->all();
                $physical = $physical->reject(fn (object $record): bool => in_array($record->id, $superseded, true));
                if ($payments->isEmpty() && $physical->isEmpty()) {
                    throw new AuthenticationException('PAYMENT_NOT_CONFIRMED', 'A verified payment is required for a confirmation.', 409);
                }
                foreach ($payments as $payment) {
                    $rows[] = ['Payment', $payment->id, $payment->purpose, self::money((int) $payment->total_centavos), $payment->paid_at, $payment->evidence_origin];
                    $versions['payments'][] = ['id' => $payment->id, 'paid_at' => $payment->paid_at];
                }
                foreach ($physical as $record) {
                    $rows[] = ['Vendor-recorded physical payment', $record->id, self::money((int) $record->amount_centavos), $record->recorded_at, $record->state];
                    $versions['physical_payments'][] = (array) $record;
                }
            }
        } elseif (in_array($type, ['PROJECT_SUMMARY', 'BUDGET_REPORT'], true)) {
            $project = DB::table('projects')->where('id', $id)->first();
            $versions = ['project' => $id, 'version' => $project->lock_version];
            $rows[] = ['Project', $project->name, $project->status];
            foreach (app(ProjectBudget::class)->metrics($project) as $key => $value) {
                if (is_scalar($value)) {
                    $rows[] = [self::label($key), str_ends_with($key, '_centavos') ? self::money((int) $value) : (string) $value];
                }
            }
            foreach (DB::table('work_packages')->where('project_id', $id)->orderBy('id')->get() as $package) {
                $rows[] = ['Work Package', $package->name, $package->status, self::money((int) $package->budget_centavos)];
                $versions['work_packages'][] = ['id' => $package->id, 'version' => $package->lock_version];
            }
            $versions['orders'] = DB::table('orders as o')->join('work_packages as w', 'w.id', '=', 'o.work_package_id')->where('w.project_id', $id)->orderBy('o.id')->get(['o.id', 'o.lock_version', 'o.accepted_snapshot_version'])->map(fn (object $r): array => (array) $r)->all();
        } elseif ($type === 'FEE_STATEMENT') {
            $statement = DB::table('fee_statements')->where('id', $id)->first();
            $versions = ['statement' => $id, 'version' => $statement->lock_version];
            foreach (['statement_reference', 'period_start', 'period_end', 'state', 'due_on', 'outstanding_centavos'] as $key) {
                $rows[] = [self::label($key), str_ends_with($key, '_centavos') ? self::money((int) $statement->$key) : (string) $statement->$key];
            }
            foreach (DB::table('fee_statement_lines')->where('fee_statement_id', $id)->orderBy('id')->get() as $line) {
                $rows[] = ['Statement line', $line->id, self::money((int) $line->amount_centavos)];
            }
        } elseif ($type === 'TAX_PACKAGE') {
            $package = DB::table('tax_report_packages')->where('id', $id)->first();
            $data = json_decode((string) $package->snapshot, true, flags: JSON_THROW_ON_ERROR);
            $rows = $data['rows'];
            $rows[] = ['Nominal due date', $package->nominal_due_date, 'Actual due date', $package->actual_due_date ?? $package->nominal_due_date];
            $rows[] = ['Due-date source', $package->due_date_source, 'Reviewer', (string) $package->due_date_reviewer_id];
            $versions = ['package' => $id, 'version' => $package->lock_version, 'hash' => $package->content_hash, 'calendar' => $package->filing_calendar_version_id, 'sources' => $data['versions']];
        } elseif (in_array($type, ['TRANSACTION_HISTORY', 'EARNINGS'], true)) {
            if (array_diff(array_keys($filters), $type === 'EARNINGS' ? ['from', 'to'] : ['tab', 'status', 'from', 'to']) !== []) {
                throw new AuthenticationException('EXPORT_FILTER_UNSUPPORTED', 'This filter is not available for this finance report.', 422);
            }
            Validator::make($filters, ['from' => ['sometimes', 'date_format:Y-m-d'], 'to' => ['sometimes', 'date_format:Y-m-d', ...(isset($filters['from']) ? ['after_or_equal:from'] : [])],
                'tab' => ['sometimes', Rule::in(VendorFinanceService::TABS)], 'status' => ['sometimes', Rule::in(VendorFinanceService::PAYMENT_STATUSES)]])->validate();
            $finance = app(VendorFinanceService::class);
            $rows[] = ['Internal Operational Report — Not a Tax Invoice. TEST/DEMO figures; no BIR filing.'];
            if ($type === 'EARNINGS') {
                $data = $finance->earnings($request, $filters);
                foreach ($data as $key => $value) {
                    if (is_scalar($value) && ! is_bool($value)) {
                        $rows[] = [self::label($key), str_ends_with($key, '_centavos') ? self::money((int) $value) : (string) $value];
                    }
                }
            } else {
                $data = [];
                $page = 1;
                do {
                    $result = $finance->transactions($request, $filters + ['page' => $page++]);
                    array_push($data, ...$result['items']);
                    if (count($data) > 5000) {
                        throw new AuthenticationException('EXPORT_TOO_LARGE', 'Narrow the date filters and try again.', 422);
                    }
                } while ($result['meta']['has_more']);
                if ($data !== []) {
                    $rows[] = array_map(self::label(...), array_keys($data[0]));
                    foreach ($data as $record) {
                        $row = [];
                        foreach ($record as $key => $value) {
                            $row[] = $value !== null && str_ends_with($key, '_centavos') ? self::money((int) $value) : (is_scalar($value) || $value === null ? (string) $value : json_encode($value, JSON_THROW_ON_ERROR));
                        }
                        $rows[] = $row;
                    }
                }
            }
            $versions = ['content_hash' => hash('sha256', json_encode($data, JSON_THROW_ON_ERROR)), 'filters' => $filters];
        } elseif ($type === 'MATERIALS_ANALYTICS') {
            $scope = $request->attributes->get('account_scope');
            $vendor = $request->user()->account_type === 'VENDOR';
            $allowed = $vendor ? ['preset_days', 'start_date', 'end_date', 'radius_km', 'category_id', 'q'] : ['preset_days', 'start_date', 'end_date', 'psgc_code', 'psgc_version_id', 'category_id', 'q'];
            if (array_diff(array_keys($filters), $allowed) !== []) {
                throw new AuthenticationException('ANALYTICS_FILTER_UNSUPPORTED', 'This filter is not available for your audience.', 422);
            }
            $resolver = app(GeographyScopeResolver::class);
            $geography = $vendor ? $resolver->forVendor($scope['organization_id'], array_intersect_key($filters, ['radius_km' => true])) : $resolver->forAdmin($filters['psgc_code'] ?? null, $filters['psgc_version_id'] ?? null);
            $dataset = AnalyticsDataset::active();
            $query = new AnalyticsRequest($vendor ? 'VENDOR' : 'ADMIN', $geography, $vendor ? $scope['organization_id'] : null, $dataset, AnalyticsWindow::resolve($filters, $dataset), array_intersect_key($filters, ['category_id' => true, 'q' => true]));
            $cursor = null;
            $versions = ['algorithm' => AnalyticsDataset::ALGORITHM_VERSION, 'dataset' => $dataset, 'generation' => AnalyticsDataset::generation()];
            $rows[] = ['Material', 'Variant', 'Unit', 'Start', 'Average PHP', 'End', 'Average PHP', 'Count', 'Change %', 'Quality'];
            do {
                $page = app(MaterialsAnalyticsAssembler::class)->list($query, $cursor, 50);
                foreach ($page['items'] as $row) {
                    $rows[] = [$row['material']['name'], $row['display_name'], $row['unit']['name'], $row['start_point']['date'], $row['start_point']['average_php'], $row['end_point']['date'], $row['end_point']['average_php'],
                        $row['end_point'][$vendor ? 'competitor_count' : 'vendor_count'] ?? null, $row['trend']['change_percent'], $row['trend']['label']];
                }
                $cursor = $page['next_cursor'];
                if (count($rows) > 5000) {
                    throw new AuthenticationException('EXPORT_TOO_LARGE', 'Narrow the material or date filters and try again.', 422);
                }
            } while ($cursor !== null);
        } elseif ($type === 'AUDIT_LOG') {
            // Safe audit projection only (no before/after payloads); the export itself is audited by the pipeline.
            if (array_diff(array_keys($filters), ['actor', 'actor_role', 'action', 'resource_type', 'organization_id', 'result', 'correlation_id', 'reason', 'from', 'to']) !== []) {
                throw new AuthenticationException('EXPORT_FILTER_UNSUPPORTED', 'This filter is not available for audit exports.', 422);
            }
            $rows = app(AuditSearchService::class)->exportRows($filters);
            $versions = ['filters' => $filters, 'latest_event_at' => DB::table('audit_logs')->max('created_at')];
        } elseif ($type === 'GEO_ANALYTICS') {
            if (array_diff(array_keys($filters), ['dataset', 'area', 'from', 'to', 'granularity', 'procurement_type', 'category_id', 'material_id', 'fulfillment_method', 'payment_method', 'order_state']) !== []) {
                throw new AuthenticationException('EXPORT_FILTER_UNSUPPORTED', 'This filter is not available for geographic analytics exports.', 422);
            }
            Validator::make($filters, GeoAnalyticsService::rules())->validate();
            // The same suppressed aggregate the dashboard shows; dataset label and disclosure rule travel with the file.
            $export = app(GeoAnalyticsService::class)->exportRows($request, $filters);
            $rows = $export['rows'];
            $versions = $export['versions'];
        }

        return ['rows' => $rows, 'versions' => $versions];
    }

    public static function money(int $centavos): string
    {
        return ($centavos < 0 ? '-' : '').intdiv(abs($centavos), 100).'.'.str_pad((string) (abs($centavos) % 100), 2, '0', STR_PAD_LEFT);
    }

    public static function label(string $name): string
    {
        return ucfirst(str_replace('_', ' ', str_replace('_centavos', ' PHP', $name)));
    }
}
