<?php

declare(strict_types=1);

namespace App\Domain\Procurement;

use App\Domain\Geography\BuyerProfiles;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Buyer Item-Based ranking preferences. The override is stored separately from the platform default in
 * buyer_ranking_preferences (procurement_type ITEM_BASED; Project-Based has its own record in Phase 10).
 * Reset to Default removes the override so the Buyer follows the current platform defaults again.
 * Every request is scoped to the authenticated Buyer's own profile; no Buyer id is ever accepted.
 */
final class RankingPreferenceService
{
    public const ITEM_BASED = 'ITEM_BASED';

    public function __construct(private readonly BuyerProfiles $profiles, private readonly AuditRecorder $audit) {}

    /** @return array{weights: RankingWeights, personalized: bool} */
    public function effectiveFor(string $buyerProfileId): array
    {
        $override = DB::table('buyer_ranking_preferences')->where('buyer_profile_id', $buyerProfileId)->where('procurement_type', self::ITEM_BASED)->value('weights');
        $decoded = $override === null ? null : json_decode((string) $override, true);
        if (is_array($decoded) && RankingWeights::errors($decoded) === []) {
            return ['weights' => RankingWeights::fromInput($decoded), 'personalized' => true];
        }

        return ['weights' => RankingWeights::platformDefault()['weights'], 'personalized' => false];
    }

    /** @return array<string, mixed> */
    public function show(Request $request): array
    {
        return $this->present($this->profiles->idFor($request));
    }

    /**
     * @param  array<string, mixed>  $weights
     * @return array<string, mixed>
     */
    public function save(Request $request, array $weights, int $expectedVersion): array
    {
        $buyerId = $this->profiles->idFor($request);
        $next = RankingWeights::fromInput($weights);
        DB::transaction(function () use ($request, $buyerId, $next, $expectedVersion): void {
            DB::table('buyer_profiles')->where('id', $buyerId)->lockForUpdate()->first(['id']);
            $current = DB::table('buyer_ranking_preferences')->where('buyer_profile_id', $buyerId)->where('procurement_type', self::ITEM_BASED)->lockForUpdate()->first();
            if (($current === null ? 0 : (int) $current->version) !== $expectedVersion) {
                throw new AuthenticationException('PREFERENCE_VERSION_CONFLICT', 'Your ranking preferences changed on another device. Review the latest values and try again.', 409, ['current_version' => $current === null ? 0 : (int) $current->version]);
            }
            $payload = json_encode($next->values, JSON_THROW_ON_ERROR);
            if ($current === null) {
                DB::table('buyer_ranking_preferences')->insert(['id' => (string) Str::uuid7(), 'buyer_profile_id' => $buyerId, 'procurement_type' => self::ITEM_BASED, 'weights' => $payload, 'version' => 1,
                    'updated_by_user_id' => $request->user()->getKey(), 'created_at' => now(), 'updated_at' => now()]);
            } else {
                DB::table('buyer_ranking_preferences')->where('id', $current->id)->update(['weights' => $payload, 'version' => (int) $current->version + 1, 'updated_by_user_id' => $request->user()->getKey(), 'updated_at' => now()]);
            }
            $this->audit->account($request, 'BUYER_RANKING_PREFERENCES_UPDATED', 'BUYER_RANKING_PREFERENCES', $buyerId,
                before: $current === null ? [] : ['weights' => json_decode((string) $current->weights, true)], after: ['procurement_type' => self::ITEM_BASED, 'weights' => $next->values]);
        });

        return $this->present($buyerId);
    }

    /** @return array<string, mixed> */
    public function reset(Request $request, int $expectedVersion): array
    {
        $buyerId = $this->profiles->idFor($request);
        DB::transaction(function () use ($request, $buyerId, $expectedVersion): void {
            DB::table('buyer_profiles')->where('id', $buyerId)->lockForUpdate()->first(['id']);
            $current = DB::table('buyer_ranking_preferences')->where('buyer_profile_id', $buyerId)->where('procurement_type', self::ITEM_BASED)->lockForUpdate()->first();
            if (($current === null ? 0 : (int) $current->version) !== $expectedVersion) {
                throw new AuthenticationException('PREFERENCE_VERSION_CONFLICT', 'Your ranking preferences changed on another device. Review the latest values and try again.', 409, ['current_version' => $current === null ? 0 : (int) $current->version]);
            }
            if ($current !== null) {
                DB::table('buyer_ranking_preferences')->where('id', $current->id)->delete();
                $this->audit->account($request, 'BUYER_RANKING_PREFERENCES_RESET', 'BUYER_RANKING_PREFERENCES', $buyerId,
                    before: ['weights' => json_decode((string) $current->weights, true)], after: ['procurement_type' => self::ITEM_BASED, 'follows_platform_default' => true]);
            }
        });

        return $this->present($buyerId);
    }

    /** @return array<string, mixed> */
    private function present(string $buyerId): array
    {
        $default = RankingWeights::platformDefault();
        $row = DB::table('buyer_ranking_preferences')->where('buyer_profile_id', $buyerId)->where('procurement_type', self::ITEM_BASED)->first(['version', 'updated_at']);
        $effective = $this->effectiveFor($buyerId);

        return [
            'procurement_type' => self::ITEM_BASED,
            'weights' => $effective['weights']->values,
            'default_weights' => $default['weights']->values,
            'defaults_version' => $default['version'],
            'personalized' => $effective['personalized'],
            'version' => $row === null ? 0 : (int) $row->version,
            'total_percent' => array_sum($effective['weights']->values),
            'algorithm_version' => SearchRelevanceScore::ALGORITHM_VERSION,
        ];
    }
}
