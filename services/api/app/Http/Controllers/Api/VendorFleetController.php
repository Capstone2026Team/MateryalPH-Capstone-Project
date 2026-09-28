<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Vendors\VendorFleetService;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use App\Http\Requests\Inventory\FleetVehiclesRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

final class VendorFleetController extends Controller
{
    public function __construct(private readonly VendorFleetService $fleet) {}

    public function index(Request $request): JsonResponse
    {
        $result = $this->fleet->list($request);

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function save(FleetVehiclesRequest $request): JsonResponse
    {
        /** @var list<array<string, mixed>> $vehicles */
        $vehicles = array_values($request->validated()['vehicles']);
        $result = $this->fleet->save($request, $vehicles);

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function uploadImage(Request $request): JsonResponse
    {
        $request->validate(['file' => ['required', 'file', 'max:20480']]);

        return ApiResponse::success($this->fleet->uploadImage($request, $request->file('file')), status: 201);
    }

    public function imageUrl(Request $request, string $fileId): JsonResponse
    {
        return ApiResponse::success($this->fleet->imageUrl($request, $fileId));
    }
}
