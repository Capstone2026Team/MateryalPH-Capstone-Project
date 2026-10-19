<?php

declare(strict_types=1);

namespace App\Domain\Procurement;

use App\Domain\Identity\AuthenticationException;
use Illuminate\Support\Facades\DB;

/**
 * Item-Based SRS weights as independent importance values. The platform default lives in platform_settings
 * (ranking.srs.default_weights); a Buyer override is stored separately per procurement type. Every weight
 * set has exactly the five components, each 0–100, with at least one above zero.
 */
final readonly class RankingWeights
{
    public const SETTING_KEY = 'ranking.srs.default_weights';

    public const COMPONENTS = ['distance', 'price', 'vps', 'stock', 'product_rating'];

    /** Approved System Workflow default, used only if the platform setting is missing or invalid. */
    public const APPROVED_DEFAULT = ['distance' => 30, 'price' => 25, 'vps' => 20, 'stock' => 15, 'product_rating' => 10];

    /** @param array<string, int> $values */
    private function __construct(public array $values) {}

    /**
     * @param  array<string, mixed>  $input
     *
     * @throws AuthenticationException 422 with field-level details
     */
    public static function fromInput(array $input): self
    {
        $errors = self::errors($input);
        if ($errors !== []) {
            $code = isset($errors['weights']) ? 'WEIGHTS_ALL_ZERO' : 'VALIDATION_FAILED';

            throw new AuthenticationException($code, $code === 'WEIGHTS_ALL_ZERO' ? 'Enable at least one ranking criterion by setting its weight above zero.' : 'Use whole ranking weights from 0 to 100 for every criterion.', 422, $errors);
        }
        $values = [];
        foreach (self::COMPONENTS as $component) {
            $values[$component] = (int) $input[$component];
        }

        return new self($values);
    }

    /**
     * @param  array<string, mixed>  $input
     * @return array<string, list<string>>
     */
    public static function errors(array $input): array
    {
        $errors = [];
        $unknown = array_diff(array_keys($input), self::COMPONENTS);
        foreach ($unknown as $key) {
            $errors['weights.'.$key][] = 'This ranking component is not part of the Item-Based score.';
        }
        $total = 0;
        foreach (self::COMPONENTS as $component) {
            $value = $input[$component] ?? null;
            if (! is_int($value) || $value < 0 || $value > 100) {
                $errors['weights.'.$component][] = 'Enter a whole weight from 0 to 100.';

                continue;
            }
            $total += $value;
        }
        if ($errors === []) {
            if ($total === 0) {
                $errors['weights'][] = 'At least one weight must be above zero.';
            }
        }

        return $errors;
    }

    /** @return array{weights: self, version: int} */
    public static function platformDefault(): array
    {
        $setting = DB::table('platform_settings')->where('key', self::SETTING_KEY)->first(['value', 'version']);
        $decoded = $setting === null ? null : json_decode((string) $setting->value, true);
        if (is_array($decoded) && self::errors($decoded) === [] && array_sum($decoded) === 100) {
            return ['weights' => self::fromInput($decoded), 'version' => (int) $setting->version];
        }

        return ['weights' => new self(self::APPROVED_DEFAULT), 'version' => 0];
    }

    public function weight(string $component): int
    {
        return $this->values[$component];
    }

    public function equals(self $other): bool
    {
        return $this->values === $other->values;
    }

    public function fingerprint(): string
    {
        return implode('-', array_map(fn (string $component): int => $this->values[$component], self::COMPONENTS));
    }
}
