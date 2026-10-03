<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Geography\BuyerLocationService;
use App\Domain\Geography\BuyerOnboardingService;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

final class BuyerLocationController extends Controller
{
    public function __construct(private readonly BuyerLocationService $locations, private readonly BuyerOnboardingService $onboarding) {}

    public function onboarding(Request $request): JsonResponse
    {
        return ApiResponse::success($this->onboarding->snapshot($request));
    }

    public function saveOnboarding(Request $request): JsonResponse
    {
        $input = $request->validate([
            'lock_version' => ['required', 'integer', 'min:1'],
            'action' => ['required', Rule::in(['SAVE', 'COMPLETE', 'SKIP'])],
            'company_name' => ['sometimes', 'nullable', 'string', 'max:180'],
            'position_title' => ['sometimes', 'nullable', 'string', 'max:80'],
            'industry_classification' => ['sometimes', 'nullable', Rule::in(BuyerOnboardingService::INDUSTRIES)],
            'industry_other_label' => ['sometimes', 'nullable', 'string', 'max:80'],
            'preferred_category_ids' => ['sometimes', 'array', 'max:24'],
            'preferred_category_ids.*' => ['uuid', 'distinct'],
        ]);

        return ApiResponse::success($this->onboarding->save($request, $input));
    }

    public function saveRadius(Request $request): JsonResponse
    {
        $input = $request->validate(['radius_km' => ['required', 'integer']]);

        return ApiResponse::success(['radius_km' => $this->onboarding->saveRadius($request, $input['radius_km'])]);
    }

    public function areas(Request $request): JsonResponse
    {
        $input = $request->validate([
            'level' => ['required', Rule::in(['REGION', 'PROVINCE', 'CITY', 'BARANGAY'])],
            'parent_code' => ['sometimes', 'nullable', 'regex:/^[0-9]{10}$/'],
            'q' => ['sometimes', 'nullable', 'string', 'max:80'],
            'page' => ['sometimes', 'integer', 'between:1,200'],
        ]);
        $result = $this->onboarding->areas($input['level'], $input['parent_code'] ?? null, (string) ($input['q'] ?? ''), (int) ($input['page'] ?? 1));

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function index(Request $request): JsonResponse
    {
        return ApiResponse::success($this->locations->list($request));
    }

    public function resolve(Request $request): JsonResponse
    {
        $input = $request->validate([
            'mode' => ['required', Rule::in(['PIN', 'DEVICE', 'ADDRESS', 'PLACE'])],
            'latitude' => ['required_if:mode,PIN,DEVICE', 'prohibited_if:mode,ADDRESS,PLACE', 'numeric', 'between:-90,90'],
            'longitude' => ['required_if:mode,PIN,DEVICE', 'prohibited_if:mode,ADDRESS,PLACE', 'numeric', 'between:-180,180'],
            'place_id' => ['required_if:mode,PLACE', 'prohibited_unless:mode,PLACE', 'string', 'regex:/^[A-Za-z0-9_-]{10,300}$/D'],
            'session_token' => ['required_if:mode,PLACE', 'prohibited_unless:mode,PLACE', 'uuid'],
            'address_line' => ['required_if:mode,ADDRESS', 'nullable', 'string', 'max:200'],
            'barangay' => ['sometimes', 'nullable', 'string', 'max:120'],
            'city_municipality' => ['required_if:mode,ADDRESS', 'nullable', 'string', 'max:120'],
            'province' => ['sometimes', 'nullable', 'string', 'max:120'],
            'postal_code' => ['sometimes', 'nullable', 'string', 'regex:/^[0-9]{4}$/'],
            'city_code' => ['sometimes', 'nullable', 'regex:/^[0-9]{10}$/'],
            'barangay_code' => ['sometimes', 'nullable', 'regex:/^[0-9]{10}$/'],
        ]);

        return ApiResponse::success($this->locations->resolve($request, $input));
    }

    public function autocomplete(Request $request): JsonResponse
    {
        $input = $request->validate(['query' => ['required', 'string', 'min:2', 'max:200'], 'session_token' => ['required', 'uuid']]);

        return ApiResponse::success($this->locations->autocomplete($request, $input['query'], $input['session_token']))->header('Cache-Control', 'no-store');
    }

    public function store(Request $request): JsonResponse
    {
        return ApiResponse::success($this->locations->create($request, $request->validate($this->detailRules() + [
            'resolution_token' => ['required', 'string', 'max:8192'],
            'label' => ['required', 'string', 'min:1', 'max:60'],
            'make_primary' => ['sometimes', 'boolean'],
        ])), status: 201);
    }

    public function update(Request $request, string $locationId): JsonResponse
    {
        return ApiResponse::success($this->locations->update($request, $locationId, $request->validate($this->detailRules() + [
            'lock_version' => ['required', 'integer', 'min:1'],
            'resolution_token' => ['sometimes', 'string', 'max:8192'],
            'label' => ['sometimes', 'string', 'min:1', 'max:60'],
        ])));
    }

    public function primary(Request $request, string $locationId): JsonResponse
    {
        $input = $request->validate(['lock_version' => ['required', 'integer', 'min:1']]);

        return ApiResponse::success($this->locations->makePrimary($request, $locationId, (int) $input['lock_version']));
    }

    public function destroy(Request $request, string $locationId): JsonResponse
    {
        $input = $request->validate(['lock_version' => ['required', 'integer', 'min:1']]);
        $this->locations->archive($request, $locationId, (int) $input['lock_version']);

        return ApiResponse::success(['id' => $locationId, 'removed' => true]);
    }

    /** @return array<string, list<mixed>> */
    private function detailRules(): array
    {
        return [
            'location_kind' => ['sometimes', Rule::in(BuyerLocationService::KINDS)],
            'contact_name' => ['sometimes', 'nullable', 'string', 'max:120'],
            'contact_phone_e164' => ['sometimes', 'nullable', 'string', 'regex:/^\+[1-9][0-9]{7,14}$/'],
            'site_instructions' => ['sometimes', 'nullable', 'string', 'max:500'],
            'address_line' => ['sometimes', 'nullable', 'string', 'max:300'],
        ];
    }
}
