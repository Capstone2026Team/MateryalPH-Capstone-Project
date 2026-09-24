<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Http\Requests\Vendor\VendorVerificationDraftRequest;
use Illuminate\Translation\ArrayLoader;
use Illuminate\Translation\Translator;
use Illuminate\Validation\Factory;
use PHPUnit\Framework\TestCase;

final class VendorCombinedTinRequestTest extends TestCase
{
    public function test_combined_tin_accepts_supported_forms_and_rejects_incomplete_or_malformed_values(): void
    {
        $factory = new Factory(new Translator(new ArrayLoader, 'en'));
        $rules = (new VendorVerificationDraftRequest)->rules();
        foreach (['123456789000', '1234567891234', '12345678912345', '123-456-789-000', '123-456-789-1234', '123-456-789-12345'] as $tin) {
            self::assertTrue($factory->make(['tax_profile' => ['tin' => $tin]], ['tax_profile.tin' => $rules['tax_profile.tin']])->passes());
        }
        foreach (['123456789', '12345678900', '123456789123456', '123-456789-000', '123-456-789-ABC', '123 456 789 000'] as $tin) {
            self::assertFalse($factory->make(['tax_profile' => ['tin' => $tin]], ['tax_profile.tin' => $rules['tax_profile.tin']])->passes());
        }
        foreach (['head_office' => true, 'branch_code_length' => 3, 'branch_code' => '000'] as $key => $value) {
            self::assertFalse($factory->make(['tax_profile' => [$key => $value]], ['tax_profile.'.$key => $rules['tax_profile.'.$key]])->passes());
        }
    }
}
