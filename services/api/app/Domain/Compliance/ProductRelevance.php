<?php

declare(strict_types=1);

namespace App\Domain\Compliance;

/**
 * Whether a register record covers the listing's regulated product. A licence
 * or sticker for an electric fan must never verify a bag of cement, so a found
 * number also needs the record's PNS standard or its product description to
 * correspond to the listing's DTI-BPS rule. PNS editions change over time
 * ("PNS may change depending on the requirements of relevant Technical
 * Regulations"), so either signal is enough.
 */
final readonly class ProductRelevance
{
    /**
     * @param  list<string>  $standards  Normalized PNS designations of the rule.
     * @param  list<list<string>>  $phrases  Product names whose words must all appear in the record's product.
     */
    public function __construct(public array $standards, public array $phrases) {}

    /** @param  list<string>  $names  Rule product name, material name and multi-word aliases. */
    public static function from(?string $referenceStandard, array $names): self
    {
        $phrases = [];
        foreach ($names as $name) {
            $words = RegisterNormalizer::productWords($name);
            if ($words !== []) {
                $phrases[implode(' ', $words)] = $words;
            }
        }

        return new self(RegisterNormalizer::standards($referenceStandard), array_values($phrases));
    }

    public function covers(?string $recordStandard, ?string $recordProduct): bool
    {
        if (array_intersect($this->standards, RegisterNormalizer::standards($recordStandard)) !== []) {
            return true;
        }
        $words = RegisterNormalizer::productWords($recordProduct);
        foreach ($this->phrases as $phrase) {
            if (array_diff($phrase, $words) === []) {
                return true;
            }
        }

        return false;
    }
}
