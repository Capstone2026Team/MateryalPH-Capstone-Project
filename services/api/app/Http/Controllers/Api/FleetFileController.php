<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Catalog\CatalogFileStore;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Inventory\InventoryAccess;
use App\Domain\Vendors\VendorFleetService;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

/** Streams a private vehicle image behind a short-lived signature and a fresh authorization check. */
final class FleetFileController extends Controller
{
    public function __invoke(Request $request, string $fileId, AccountAccess $access, VendorFleetService $fleet, CatalogFileStore $files): mixed
    {
        $user = $request->user();
        $scope = $access->resolve($user);
        if ($user->account_type !== 'VENDOR' || ! is_string($scope['organization_id']) || ! in_array(InventoryAccess::VEHICLES_MANAGE, $scope['permissions'], true)) {
            throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The file is unavailable.', 404);
        }

        return $files->stream($fleet->authorizedImage($scope['organization_id'], $fileId));
    }
}
