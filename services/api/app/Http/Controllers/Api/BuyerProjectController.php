<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Catalog\MaterialSearch;
use App\Domain\Geography\BuyerProfiles;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Projects\FulfillmentMatchScore;
use App\Domain\Projects\ProjectEstimateService;
use App\Domain\Projects\ProjectInquiryService;
use App\Domain\Projects\ProjectService;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use App\Http\Requests\Projects\WorkPackageRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class BuyerProjectController extends Controller
{
    public function __construct(private readonly ProjectService $projects) {}

    public function index(Request $r): JsonResponse
    {
        $this->page($r);

        return ApiResponse::success($this->projects->index($r));
    }

    public function show(Request $r, string $projectId): JsonResponse
    {
        $this->page($r);

        return ApiResponse::success($this->projects->show($r, $projectId));
    }

    public function packageShow(Request $r, string $packageId): JsonResponse
    {
        $this->page($r);

        return ApiResponse::success($this->projects->packageShow($r, $packageId));
    }

    public function create(Request $r): JsonResponse
    {
        $input = $r->validate(['name' => ['required', 'string', 'max:150'], 'budget_centavos' => ['required', 'integer', 'between:0,100000000000'], 'starts_on' => ['required', 'date_format:Y-m-d'],
            'ends_on' => ['required', 'date_format:Y-m-d', 'after_or_equal:starts_on'], 'location_id' => ['required', 'uuid']]);

        return ApiResponse::success($this->projects->show($r, $this->projects->create($r, $input)), [], 201);
    }

    public function update(Request $r, string $projectId): JsonResponse
    {
        $input = $r->validate(['lock_version' => ['required', 'integer', 'min:1'], 'name' => ['sometimes', 'string', 'max:150'], 'budget_centavos' => ['sometimes', 'integer', 'between:0,100000000000'],
            'starts_on' => ['sometimes', 'date_format:Y-m-d'], 'ends_on' => ['sometimes', 'date_format:Y-m-d'], 'location_id' => ['sometimes', 'uuid'], 'status' => ['sometimes', 'in:ACTIVE,COMPLETED,ARCHIVED']]);
        $p = $this->projects->project($r, $projectId);
        if (($input['ends_on'] ?? $p->ends_on) < ($input['starts_on'] ?? $p->starts_on)) {
            throw new AuthenticationException('VALIDATION_FAILED', 'The end date must be on or after the start date.', 422);
        }
        $this->projects->update($r, $projectId, $input);

        return ApiResponse::success($this->projects->show($r, $projectId));
    }

    public function savePackage(WorkPackageRequest $r, string $projectId): JsonResponse
    {
        return ApiResponse::success($this->projects->packageShow($r, $this->projects->savePackage($r, $projectId, null, $r->validated())), [], 201);
    }

    public function editPackage(WorkPackageRequest $r, string $packageId): JsonResponse
    {
        $input = $r->validated();
        if (! isset($input['lock_version'])) {
            throw new AuthenticationException('VERSION_REQUIRED', 'Provide the current version.', 422);
        }
        $w = $this->projects->package($r, $packageId);
        $this->projects->savePackage($r, $w->project_id, $packageId, $input, $r->route()->getActionMethod() === 'newVersion');

        return ApiResponse::success($this->projects->packageShow($r, $packageId));
    }

    public function newVersion(WorkPackageRequest $r, string $packageId): JsonResponse
    {
        return $this->editPackage($r, $packageId);
    }

    public function activate(Request $r, string $packageId): JsonResponse
    {
        $input = $r->validate(['lock_version' => ['required', 'integer', 'min:1']]);
        $this->projects->activate($r, $packageId, $input['lock_version']);

        return ApiResponse::success($this->projects->packageShow($r, $packageId));
    }

    public function estimates(Request $r, string $packageId, ProjectEstimateService $estimates): JsonResponse
    {
        $this->page($r);

        return ApiResponse::success($estimates->show($r, $packageId));
    }

    public function compile(Request $r, string $packageId, ProjectEstimateService $estimates): JsonResponse
    {
        $input = $r->validate(['lock_version' => ['required', 'integer', 'min:1'], 'radius_km' => ['required', 'integer', 'in:5,10,20,30,40,50']]);

        return ApiResponse::success($estimates->compile($r, $packageId, $input['lock_version'], $input['radius_km']));
    }

    public function inquire(Request $r, string $packageId, ProjectInquiryService $inquiries): JsonResponse
    {
        $input = $r->validate(['lock_version' => ['required', 'integer', 'min:1'], 'candidate_id' => ['required', 'uuid']]);

        return ApiResponse::success(['id' => $inquiries->inquire($r, $packageId, $input)], [], 201);
    }

    public function select(Request $r, string $packageId, ProjectInquiryService $inquiries): JsonResponse
    {
        $input = $r->validate(['lock_version' => ['required', 'integer', 'min:1'], 'candidate_id' => ['required', 'uuid'], 'note' => ['nullable', 'string', 'max:2000'], 'budget_override_reason' => ['nullable', 'string', 'min:10', 'max:2000']]);

        return ApiResponse::success(['id' => $inquiries->select($r, $packageId, $input)], [], 201);
    }

    public function route(Request $r, string $packageId, string $candidateId, ProjectEstimateService $estimates): JsonResponse
    {
        return ApiResponse::success($estimates->route($r, $packageId, $candidateId));
    }

    public function preferences(Request $r): JsonResponse
    {
        return ApiResponse::success(FulfillmentMatchScore::preferences(app(BuyerProfiles::class)->idFor($r)));
    }

    public function savePreferences(Request $r): JsonResponse
    {
        $input = $r->validate(['version' => ['required', 'integer', 'min:0'], 'weights' => ['required', 'array']]);
        $weights = FulfillmentMatchScore::validate($input['weights']);

        return $this->writePreferences($r, $input['version'], $weights);
    }

    public function resetPreferences(Request $r): JsonResponse
    {
        $input = $r->validate(['version' => ['required', 'integer', 'min:0']]);

        return $this->writePreferences($r, $input['version'], null);
    }

    /** @param array<string, int>|null $weights */
    private function writePreferences(Request $r, int $version, ?array $weights): JsonResponse
    {
        $buyer = app(BuyerProfiles::class)->idFor($r);
        DB::transaction(function () use ($r, $buyer, $version, $weights): void {
            DB::table('buyer_profiles')->where('id', $buyer)->lockForUpdate()->first();
            $row = DB::table('buyer_ranking_preferences')->where('buyer_profile_id', $buyer)->where('procurement_type', 'PROJECT_BASED')->lockForUpdate()->first();
            if ((int) ($row->version ?? 0) !== $version) {
                throw new AuthenticationException('PREFERENCE_VERSION_CONFLICT', 'Review the latest Project-Based weights.', 409);
            }
            $effective = $weights ?? FulfillmentMatchScore::preferences($buyer)['default_weights'];
            DB::table('buyer_ranking_preferences')->updateOrInsert(['buyer_profile_id' => $buyer, 'procurement_type' => 'PROJECT_BASED'],
                ['id' => $row->id ?? (string) Str::uuid7(), 'weights' => json_encode($effective, JSON_THROW_ON_ERROR), 'is_personalized' => $weights !== null,
                    'version' => $version + 1, 'updated_by_user_id' => $r->user()->id, 'created_at' => $row->created_at ?? now(), 'updated_at' => now()]);
            $this->projects->record($r, 'PROJECT_RANKING_PREFERENCES_UPDATED', $buyer);
        });

        return $this->preferences($r);
    }

    public function missing(Request $r, string $packageId, string $lineId): JsonResponse
    {
        $input = $r->validate(['lock_version' => ['required', 'integer', 'min:1'], 'order_id' => ['nullable', 'uuid'], 'reason' => ['required_without:order_id', 'nullable', 'string', 'min:10', 'max:2000'], 'budget_override_reason' => ['nullable', 'string', 'min:10', 'max:2000']]);
        $this->projects->resolveMissing($r, $packageId, $lineId, $input);

        return ApiResponse::success($this->projects->packageShow($r, $packageId));
    }

    public function importPreview(Request $r): JsonResponse
    {
        app(BuyerProfiles::class)->idFor($r);
        $input = $r->validate(['csv' => ['required', 'string', 'max:100000']]);
        $stream = fopen('php://temp', 'r+');
        fwrite($stream, $input['csv']);
        rewind($stream);
        $header = fgetcsv($stream, escape: '');
        if ($header !== ['material_code', 'name', 'unit_code', 'quantity', 'preferred_brand', 'specifications']) {
            fclose($stream);
            throw new AuthenticationException('CSV_HEADER_INVALID', 'Use material_code,name,unit_code,quantity,preferred_brand,specifications. Specifications must be a JSON object.', 422);
        }
        $lines = [];
        $errors = [];
        $number = 1;
        while (($row = fgetcsv($stream, escape: '')) !== false) {
            $number++;
            if ($number > 101 || count($row) !== 6) {
                $errors[] = ['row' => $number, 'message' => 'Use six columns and at most 100 lines.'];
                break;
            }
            $material = DB::table('materials')->where('code', $row[0])->value('id');
            $unit = DB::table('units')->where('code', $row[2])->first();
            $specs = json_decode($row[5], true);
            if ($material === null || $unit === null || trim($row[1]) === '' || ! preg_match('/^\d{1,7}(\.\d{1,4})?$/', $row[3]) || bccomp($row[3], '0', 4) <= 0 || bccomp($row[3], '1000000', 4) > 0 || ! is_array($specs)
                || bccomp($row[3], bcadd($row[3], '0', (int) $unit->precision), 4) !== 0) {
                $errors[] = ['row' => $number, 'message' => 'Check material code, name, normalized unit, positive quantity and specification JSON.'];

                continue;
            }
            if (! str_starts_with(trim($row[5]), '{') || count($specs) > 30 || count(array_filter($specs, 'is_string')) !== count($specs)
                || ! DB::table('material_compatible_units')->where('material_id', $material)->where('unit_id', $unit->id)->exists()) {
                $errors[] = ['row' => $number, 'message' => 'Use compatible units and a specification object containing at most 30 text values.'];

                continue;
            }
            $lines[] = ['material_id' => $material, 'name' => $row[1], 'unit_id' => $unit->id, 'quantity' => $row[3], 'preferred_brand' => trim($row[4]) === '' ? null : $row[4], 'specifications' => (object) $specs];
        }
        fclose($stream);

        return ApiResponse::success(['lines' => $lines, 'validation_errors' => $errors, 'valid' => $errors === [] && $lines !== []]);
    }

    public function close(Request $r, string $packageId): JsonResponse
    {
        $input = $r->validate(['lock_version' => ['required', 'integer', 'min:1']]);
        DB::transaction(function () use ($r, $packageId, $input): void {
            $w = $this->projects->package($r, $packageId, true);
            ProjectService::version($w, $input['lock_version']);
            if ($w->selected_vendor_organization_id !== null) {
                throw new AuthenticationException('ORDER_CANCELLATION_REQUIRED', 'Use the linked order cancellation rules before correcting this package.', 409);
            }
            $this->projects->invalidate($packageId);
            DB::table('work_packages')->where('id', $packageId)->update(['status' => 'CANCELLED', 'lock_version' => $w->lock_version + 1]);
            $this->projects->record($r, 'WORK_PACKAGE_CANCELLED', $packageId);
        });

        return ApiResponse::success($this->projects->packageShow($r, $packageId));
    }

    private function page(Request $r): void
    {
        $r->validate(['page' => ['sometimes', 'integer', 'between:1,10000']]);
    }

    public function materials(Request $r): JsonResponse
    {
        app(BuyerProfiles::class)->idFor($r);
        $input = $r->validate(['query' => ['required', 'string', 'min:2', 'max:100']]);
        $matches = app(MaterialSearch::class)->search($input['query']);
        foreach ($matches as &$match) {
            $match['compatible_units'] = DB::table('material_compatible_units as m')->join('units as u', 'u.id', '=', 'm.unit_id')->where('m.material_id', $match['id'])->orderBy('u.code')->get(['u.id', 'u.code', 'u.name', 'u.precision'])->all();
        }
        unset($match);

        return ApiResponse::success(['items' => $matches]);
    }

    public function deletePackage(Request $r, string $packageId): JsonResponse
    {
        $input = $r->validate(['lock_version' => ['required', 'integer', 'min:1']]);
        DB::transaction(function () use ($r, $packageId, $input): void {
            $w = $this->projects->package($r, $packageId, true);
            ProjectService::version($w, $input['lock_version']);
            if ($w->status !== 'DRAFT' || DB::table('work_package_versions')->where('work_package_id', $w->id)->whereNotNull('locked_at')->exists()) {
                throw new AuthenticationException('WORK_PACKAGE_HISTORY_RETAINED', 'Locked versions must be retained. Cancel the package instead.', 409);
            }
            DB::table('work_packages')->where('id', $w->id)->update(['current_version_id' => null]);
            DB::table('work_package_lines')->whereIn('work_package_version_id', DB::table('work_package_versions')->select('id')->where('work_package_id', $w->id))->delete();
            DB::table('work_package_versions')->where('work_package_id', $w->id)->delete();
            DB::table('work_packages')->where('id', $w->id)->delete();
            $this->projects->record($r, 'WORK_PACKAGE_DRAFT_DELETED', $packageId);
        });

        return ApiResponse::success();
    }

    public function deleteProject(Request $r, string $projectId): JsonResponse
    {
        $input = $r->validate(['lock_version' => ['required', 'integer', 'min:1']]);
        DB::transaction(function () use ($r, $projectId, $input): void {
            $p = $this->projects->project($r, $projectId, true);
            ProjectService::version($p, $input['lock_version']);
            if ($p->status !== 'ACTIVE') {
                throw new AuthenticationException('PROJECT_CLOSED', 'This Project is read-only. Retain its history.', 409);
            }
            if (DB::table('work_packages')->where('project_id', $projectId)->exists()) {
                throw new AuthenticationException('PROJECT_HISTORY_RETAINED', 'Remove editable drafts first. Projects with locked history can be archived.', 409);
            }
            DB::table('project_sites')->where('project_id', $projectId)->delete();
            DB::table('projects')->where('id', $projectId)->delete();
            $this->projects->record($r, 'PROJECT_DELETED', $projectId);
        });

        return ApiResponse::success();
    }
}
