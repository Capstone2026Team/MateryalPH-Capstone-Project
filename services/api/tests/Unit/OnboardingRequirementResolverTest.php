<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Vendors\OnboardingRequirementResolver;
use PHPUnit\Framework\TestCase;

final class OnboardingRequirementResolverTest extends TestCase
{
    public function test_all_five_business_types_resolve_deterministically(): void
    {
        $resolver = new OnboardingRequirementResolver;
        foreach (['SOLE_PROPRIETORSHIP' => 'DTI_BUSINESS_NAME_REGISTRATION', 'PARTNERSHIP' => 'SEC_REGISTRATION', 'CORPORATION' => 'SEC_REGISTRATION', 'ONE_PERSON_CORPORATION' => 'SEC_REGISTRATION', 'COOPERATIVE' => 'CDA_REGISTRATION'] as $type => $document) {
            $input = ['business_type' => $type, 'fulfillment_method' => 'SELF_PICKUP', 'representative_role' => 'PROPRIETOR', 'declaration_claim' => false];
            $result = $resolver->resolve($input);
            self::assertSame($result, $resolver->resolve($input));
            self::assertSame($document, $result['business_registration']['document_type']);
            self::assertSame($type !== 'SOLE_PROPRIETORSHIP', $result['authority_to_act']['applicable']);
            self::assertFalse($result['delivery_configuration']['applicable']);
            self::assertFalse($result['tax_relief_evidence']['applicable']);
            foreach ($result as $requirement) {
                if (! $requirement['applicable']) {
                    self::assertSame('CONDITIONALLY_REQUIRED', $requirement['level']);
                    self::assertNotEmpty($requirement['applicability_reason']);
                }
            }
        }
    }

    public function test_representative_delivery_and_supplier_inputs_invalidate_only_their_dependencies(): void
    {
        $resolver = new OnboardingRequirementResolver;
        $input = ['business_type' => 'SOLE_PROPRIETORSHIP', 'fulfillment_method' => 'SELF_PICKUP', 'supplier_type' => 'RETAIL_HARDWARE_STORE', 'niches' => ['Electrical Supplies']];
        $before = $resolver->resolve($input);
        $after = $resolver->resolve(array_merge($input, ['representative_role' => 'REPRESENTATIVE', 'fulfillment_method' => 'BOTH', 'niches' => ['Cement and Concrete']]));
        self::assertTrue($after['authority_to_act']['applicable']);
        self::assertTrue($after['delivery_configuration']['applicable']);
        self::assertNotSame($before['supplier_classification']['resolution_hash'], $after['supplier_classification']['resolution_hash']);
        self::assertSame($before['business_registration']['resolution_hash'], $after['business_registration']['resolution_hash']);
        self::assertSame('OPTIONAL', $after['team']['level']);
    }
}
