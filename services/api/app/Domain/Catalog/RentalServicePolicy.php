<?php

declare(strict_types=1);

namespace App\Domain\Catalog;

use Illuminate\Support\Str;

/**
 * Vehicle and equipment rental services are outside the capstone scope. Tools
 * and equipment offered for sale remain supported products.
 */
final class RentalServicePolicy
{
    public const MESSAGE = 'Vehicle and equipment rental services are not currently supported by MateryalPH. The marketplace currently supports construction materials, supplies, tools, equipment offered as supported products, and other approved procurement categories.';

    public function describesRental(string $label): bool
    {
        $normalized = trim((string) preg_replace('/[^a-z0-9]+/i', ' ', Str::ascii($label)));
        $compact = str_replace(' ', '', strtolower($normalized));

        return preg_match('/\b(?:rent(?:al|als|ing|ed)?|for hire|hire|leasing|lease)\b/i', $normalized) === 1
            || preg_match('/^(?:(?:construction)?(?:vehicles?|equipment|tools?|machinery))?(?:rentals?|forhire|hire|leasing)(?:services?)?$/', $compact) === 1;
    }
}
