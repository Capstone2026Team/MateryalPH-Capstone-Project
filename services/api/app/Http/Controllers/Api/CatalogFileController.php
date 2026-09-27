<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Catalog\CatalogAccess;
use App\Domain\Catalog\CatalogFileStore;
use App\Domain\Catalog\VendorCatalogService;
use App\Domain\Compliance\ProductComplianceService;
use App\Domain\Identity\AuthenticationException;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/** Streams a catalog file behind a short-lived signature and a fresh authorization check. */
final class CatalogFileController extends Controller
{
    public function __invoke(Request $request, string $fileId, AccountAccess $access, VendorCatalogService $catalog, ProductComplianceService $compliance, CatalogFileStore $files): mixed
    {
        $user = $request->user();
        $scope = $access->resolve($user);
        if ($user->account_type === 'VENDOR' && is_string($scope['organization_id'])) {
            if (! in_array(CatalogAccess::VIEW, $scope['permissions'], true)) {
                throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The file is unavailable.', 404);
            }
            $file = $catalog->authorizedVendorFile($request, $scope['organization_id'], $fileId);
        } elseif ($user->account_type === 'ADMIN') {
            $compliance->adminFileUrl($request, $fileId);
            $file = DB::table('files')->where('id', $fileId)->first();
        } else {
            throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The file is unavailable.', 404);
        }

        return $files->stream($file);
    }
}
