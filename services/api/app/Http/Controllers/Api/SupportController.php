<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Support\SupportAccess;
use App\Domain\Support\SupportFiles;
use App\Domain\Support\SupportGuestAccess;
use App\Domain\Support\SupportRules;
use App\Domain\Support\SupportService;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use App\Http\Requests\Support\SubmitSupportRequest;
use App\Support\PortalDateRange;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;

final class SupportController extends Controller
{
    public function __construct(private readonly SupportService $support) {}

    public function create(SubmitSupportRequest $request): JsonResponse
    {
        return ApiResponse::success($this->support->submit($request, $request->validated()), status: 201)->header('Cache-Control', 'private, no-store');
    }

    public function reply(SubmitSupportRequest $request, string $ticketId): JsonResponse
    {
        return ApiResponse::success($this->support->reply($request, $ticketId, $request->validated()), status: 201);
    }

    public function index(Request $request): JsonResponse
    {
        $filters = $request->validate(['cursor' => ['sometimes', 'uuid'], 'q' => ['sometimes', 'string', 'max:160'],
            'category' => ['sometimes', Rule::in(SupportRules::CATEGORIES)], 'status' => ['sometimes', Rule::in(SupportRules::STATUSES)],
            'user_type' => ['sometimes', Rule::in(SupportRules::TYPES)]] + PortalDateRange::rules($request));
        $page = $this->support->list($request, $filters);

        return ApiResponse::success($page['items'], ['next_cursor' => $page['next_cursor']]);
    }

    public function show(Request $request, string $ticketId): JsonResponse
    {
        return ApiResponse::success($this->support->detail($request, $ticketId));
    }

    public function entries(Request $request, string $ticketId): JsonResponse
    {
        $input = $request->validate(['cursor' => ['sometimes', 'uuid']]);
        $page = $this->support->entries($request, $ticketId, $input['cursor'] ?? null);

        return ApiResponse::success($page['items'], ['next_cursor' => $page['next_cursor']]);
    }

    public function update(Request $request, string $ticketId): JsonResponse
    {
        return ApiResponse::success($this->support->update($request, $ticketId, $request->validate([
            'lock_version' => ['required', 'integer', 'min:1'], 'reason' => ['required', 'string', 'min:3', 'max:2000'],
            'status' => ['sometimes', Rule::in(SupportRules::STATUSES)], 'assigned_admin_id' => ['sometimes', 'nullable', 'uuid'],
        ])));
    }

    public function attachment(Request $request, string $ticketId, string $fileId): mixed
    {
        app(SupportAccess::class)->ticket($request, $ticketId);

        return app(SupportFiles::class)->stream($ticketId, $fileId);
    }

    public function handlers(Request $request): JsonResponse
    {
        $input = $request->validate(['cursor' => ['sometimes', 'uuid']]);
        $page = $this->support->handlers($request, $input['cursor'] ?? null);

        return ApiResponse::success($page['items'], ['next_cursor' => $page['next_cursor']]);
    }

    public function accessEmail(Request $request): JsonResponse
    {
        $input = $request->validate(['ticket_number' => ['required', 'string', 'max:32'], 'email' => ['required', 'email:rfc', 'max:254'], 'website' => ['nullable', 'string', 'max:0']]);
        DB::transaction(function () use ($input): void {
            $ticket = DB::table('support_tickets')->where('ticket_number', strtoupper(trim($input['ticket_number'])))->where('email', mb_strtolower(trim($input['email'])))->whereNull('user_id')->first();
            if ($ticket !== null) {
                app(SupportGuestAccess::class)->sendLink($ticket);
            }
        });

        return ApiResponse::success(['message' => 'If the details match a guest request, a secure access email will be sent.'])->header('Cache-Control', 'no-store');
    }

    public function exchange(Request $request): JsonResponse
    {
        $input = $request->validate(['token' => ['required', 'string', 'regex:/^[a-f0-9]{64}$/']]);
        $result = app(SupportGuestAccess::class)->exchange($input['token']);

        return ApiResponse::success(['ticket_id' => $result['ticket_id']])->withCookie(cookie('mp_support', $result['session'], 30,
            '/api/v1/support/guest', null, (bool) config('materyalph.auth.cookie_secure', true), true, false, 'strict'))->header('Cache-Control', 'no-store');
    }
}
