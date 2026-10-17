<?php

declare(strict_types=1);

namespace App\Infrastructure\Compliance;

use App\Domain\Compliance\ComplianceReferenceProvider;
use App\Domain\Compliance\ProductRelevance;
use App\Domain\Compliance\ReferenceMatch;
use App\Domain\Compliance\RegisterNormalizer;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;

/**
 * Compares a marking number with the active DTI-BPS register snapshot (PS
 * licensees for PS Marks, ICC certificate holders for ICC stickers). Approved
 * rule compliance.register-number.v2 (project owner, 2026-10-17): MATCHED needs
 * the PS License No. listed, or the ICC sticker serial inside a listed sticker
 * serial range, on a record whose product or PNS standard covers the listing's
 * regulated product and that has not expired. The record then supplies the
 * manufacturer or importer and other details. A listed number for another
 * product is UNCERTAIN; an unlisted number is UNMATCHED; no active snapshot is
 * UNAVAILABLE.
 */
final class RegisterComplianceReferenceProvider implements ComplianceReferenceProvider
{
    public const RULE = 'compliance.register-number.v2';

    private const MAX_CANDIDATES = 24;

    public function lookup(string $markingType, string $number, ProductRelevance $relevance): ReferenceMatch
    {
        $kind = $markingType === 'ICC_STICKER' ? 'ICC_CERTIFICATE' : 'PS_LICENSE';
        $register = DB::table('compliance_reference_registers')->where('register_kind', $kind)->where('status', 'ACTIVE')->first(['id', 'snapshot_date', 'source_reference']);
        if ($register === null) {
            return new ReferenceMatch(ReferenceMatch::UNAVAILABLE, 'DTI_BPS_REGISTER', null, null, ['rule' => self::RULE, 'reason' => 'NO_ACTIVE_REGISTER', 'register_kind' => $kind]);
        }
        $source = $register->source_reference.' (snapshot '.$register->snapshot_date.')';
        $base = ['rule' => self::RULE, 'register_kind' => $kind, 'snapshot_date' => (string) $register->snapshot_date];
        $records = $this->records((string) $register->id, $kind, $number);
        if ($records === null) {
            return new ReferenceMatch(ReferenceMatch::UNMATCHED, 'DTI_BPS_REGISTER', $source, (string) $register->id, $base + ['reason' => $kind === 'ICC_CERTIFICATE' && preg_match('/^\s*\d{6}\s*\/\s*\d{4}\s*$/', $number) === 1 ? 'CERTIFICATE_NUMBER_GIVEN' : 'NUMBER_FORMAT']);
        }
        if ($records->isEmpty()) {
            return new ReferenceMatch(ReferenceMatch::UNMATCHED, 'DTI_BPS_REGISTER', $source, (string) $register->id, $base + ['reason' => 'NUMBER_NOT_FOUND']);
        }
        $today = now('Asia/Manila')->toDateString();
        $differences = [];
        foreach ($records as $record) {
            $checks = [
                'product' => $relevance->covers($record->reference_standard, $record->product_description),
                'not_expired' => $record->expires_on === null || (string) $record->expires_on >= $today,
            ];
            if (! in_array(false, $checks, true)) {
                return new ReferenceMatch(ReferenceMatch::MATCHED, 'DTI_BPS_REGISTER', $source, (string) $register->id, $base + ['record_id' => $record->id, 'record' => $this->present($record, $kind)]);
            }
            $differences[] = ['record_id' => $record->id, 'failed_checks' => array_keys(array_filter($checks, static fn (bool $passed): bool => ! $passed))];
        }

        return new ReferenceMatch(ReferenceMatch::UNCERTAIN, 'DTI_BPS_REGISTER', $source, (string) $register->id, $base + [
            'reason' => in_array('product', $differences[0]['failed_checks'], true) ? 'PRODUCT_NOT_COVERED' : 'RECORD_EXPIRED',
            'candidates' => $differences, 'record' => $this->present($records->first(), $kind),
        ]);
    }

    public function firstListed(string $markingType, array $candidates, ProductRelevance $relevance): ?string
    {
        $listed = null;
        foreach (array_slice(array_values(array_unique($candidates)), 0, self::MAX_CANDIDATES) as $candidate) {
            $match = $this->lookup($markingType, $candidate, $relevance);
            if ($match->result === ReferenceMatch::MATCHED) {
                return $this->display($markingType, $candidate);
            }
            if ($match->result === ReferenceMatch::UNAVAILABLE) {
                return null;
            }
            $listed ??= $match->result === ReferenceMatch::UNCERTAIN ? $this->display($markingType, $candidate) : null;
        }

        return $listed;
    }

    /** @return Collection<int, \stdClass>|null Null when the number cannot be a PS licence number or sticker serial. */
    private function records(string $registerId, string $kind, string $number): ?Collection
    {
        $query = DB::table('compliance_reference_records')->where('compliance_reference_register_id', $registerId)->orderBy('row_number')->limit(50);
        if ($kind === 'PS_LICENSE') {
            $candidates = RegisterNormalizer::psLicenceCandidates($number);

            return $candidates === [] ? null : $query->whereIn('record_number', $candidates)->get();
        }
        $serial = RegisterNormalizer::serial($number);

        return $serial === null ? null : $query->where('serial_prefix', $serial['prefix'])->where('serial_from', '<=', $serial['number'])->where('serial_to', '>=', $serial['number'])->get();
    }

    /** @return array<string, mixed> */
    private function present(object $record, string $kind): array
    {
        $details = is_string($record->details ?? null) ? (json_decode($record->details, true) ?: []) : [];
        $range = $record->serial_prefix === null ? null
            : $record->serial_prefix.str_pad((string) $record->serial_from, (int) $record->serial_digits, '0', STR_PAD_LEFT).' – '.$record->serial_prefix.str_pad((string) $record->serial_to, (int) $record->serial_digits, '0', STR_PAD_LEFT);

        return [
            'record_id' => $record->id,
            'register_kind' => $kind,
            'company_name' => $record->company_name,
            'product_description' => $record->product_description,
            'brand' => $record->brand,
            'model_type' => $record->model_type,
            'reference_standard' => $record->reference_standard,
            'address' => $record->address,
            'origin' => $details['origin'] ?? null,
            'license_number' => $kind === 'PS_LICENSE' ? $record->record_number_display : null,
            'icc_certificate_number' => $kind === 'ICC_CERTIFICATE' ? $record->record_number_display : null,
            'serial_range' => $range,
            'expires_on' => $record->expires_on,
        ];
    }

    private function display(string $markingType, string $candidate): string
    {
        $number = RegisterNormalizer::number($candidate);

        return $markingType === 'PS_MARK' && preg_match('/^([A-Z]+)(\d+)$/', $number, $parts) === 1 ? $parts[1].'-'.$parts[2] : $number;
    }
}
