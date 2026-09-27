<?php

declare(strict_types=1);

namespace App\Infrastructure\Compliance;

use App\Domain\Compliance\ComplianceReferenceProvider;
use App\Domain\Compliance\ReferenceMatch;
use App\Domain\Compliance\RegisterNormalizer;
use Illuminate\Support\Facades\DB;

/**
 * Compares a declaration with the active DTI-BPS register snapshot imported by
 * Product Compliance Staff (PS licensees for PS Marks, ICC certificates for ICC
 * stickers). Approved rule compliance.register-exact.v1: MATCHED requires the
 * same licence/certificate number, the same manufacturer (PS) or importer (ICC)
 * name after normalization, the product's PNS standard and an unexpired record.
 * A partial match is UNCERTAIN; no active snapshot is UNAVAILABLE.
 */
final class RegisterComplianceReferenceProvider implements ComplianceReferenceProvider
{
    public const RULE = 'compliance.register-exact.v1';

    public function match(array $declared, array $standards): ReferenceMatch
    {
        $kind = $declared['marking_type'] === 'ICC_STICKER' ? 'ICC_CERTIFICATE' : 'PS_LICENSE';
        $register = DB::table('compliance_reference_registers')->where('register_kind', $kind)->where('status', 'ACTIVE')->first(['id', 'snapshot_date', 'source_reference']);
        if ($register === null) {
            return new ReferenceMatch(ReferenceMatch::UNAVAILABLE, 'DTI_BPS_REGISTER', null, null, ['reason' => 'NO_ACTIVE_REGISTER', 'register_kind' => $kind]);
        }
        $source = $register->source_reference.' (snapshot '.$register->snapshot_date.')';
        $number = RegisterNormalizer::number($declared['certificate_number']);
        $records = $number === '' ? collect() : DB::table('compliance_reference_records')->where('compliance_reference_register_id', $register->id)->where('record_number', $number)->orderBy('row_number')->limit(50)->get();
        if ($records->isEmpty()) {
            return new ReferenceMatch(ReferenceMatch::UNMATCHED, 'DTI_BPS_REGISTER', $source, (string) $register->id, ['rule' => self::RULE, 'register_kind' => $kind, 'reason' => 'NUMBER_NOT_FOUND']);
        }
        $company = RegisterNormalizer::company((string) ($kind === 'ICC_CERTIFICATE' ? $declared['importer_name'] : $declared['manufacturer_name']));
        $best = null;
        $differences = [];
        foreach ($records as $record) {
            $checks = [
                'company' => $company !== '' && $record->normalized_company === $company,
                'standard' => $standards !== [] && array_intersect($standards, RegisterNormalizer::standards($record->reference_standard)) !== [],
                'not_expired' => $record->expires_on === null || (string) $record->expires_on >= now('Asia/Manila')->toDateString(),
            ];
            if (! in_array(false, $checks, true)) {
                $best = $record;
                break;
            }
            $differences[] = ['record_id' => $record->id, 'failed_checks' => array_keys(array_filter($checks, static fn (bool $passed): bool => ! $passed))];
        }
        if ($best === null) {
            return new ReferenceMatch(ReferenceMatch::UNCERTAIN, 'DTI_BPS_REGISTER', $source, (string) $register->id, ['rule' => self::RULE, 'register_kind' => $kind, 'candidates' => $differences]);
        }

        return new ReferenceMatch(ReferenceMatch::MATCHED, 'DTI_BPS_REGISTER', $source, (string) $register->id, [
            'rule' => self::RULE, 'register_kind' => $kind, 'record_id' => $best->id, 'record_number' => $best->record_number_display,
            'company_name' => $best->company_name, 'reference_standard' => $best->reference_standard, 'expires_on' => $best->expires_on,
        ]);
    }
}
