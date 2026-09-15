<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Agreements\AccountAgreements;
use App\Domain\Authorization\RecentAuthentication;
use App\Domain\Identity\ManageAccount;
use App\Domain\Identity\ManageSecurityFactor;
use App\Domain\Identity\TotpService;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use App\Http\Requests\Account\AccountRequest;
use App\Http\Resources\AccountProfileResource;
use App\Models\AuthSession;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

final class AccountController extends Controller
{
    public function profile(Request $request): JsonResponse
    {
        return ApiResponse::success((new AccountProfileResource($request->user()))->resolve($request));
    }

    public function updateProfile(AccountRequest $request, ManageAccount $accounts): JsonResponse
    {
        return ApiResponse::success((new AccountProfileResource($accounts->updateProfile($request, $request->validated())))->resolve($request));
    }

    public function security(Request $request, RecentAuthentication $recent, TotpService $totp): JsonResponse
    {
        $session = $recent->session($request);

        return ApiResponse::success(['totp_enrolled' => $totp->hasConfirmedFactor($request->user()), 'recent_authentication_expires_at' => $session->reauthenticated_at?->addMinutes(15)->toIso8601String()]);
    }

    public function reauthenticate(AccountRequest $request, RecentAuthentication $recent): JsonResponse
    {
        $recent->confirm($request, $request->validated('password'), $request->validated('code'), $request->validated('email_code'));

        return ApiResponse::success(['verified' => true]);
    }

    public function reauthenticationEmail(AccountRequest $request, RecentAuthentication $recent): JsonResponse
    {
        $recent->sendEmail($request);

        return ApiResponse::success(['queued' => true]);
    }

    public function sessions(Request $request, RecentAuthentication $recent): JsonResponse
    {
        $request->validate(['page' => ['sometimes', 'integer', 'min:1']]);
        $current = $recent->session($request)->getKey();
        $sessions = AuthSession::query()->where('user_id', $request->user()->getKey())->whereNull('revoked_at')->where('expires_at', '>', now())->orderByDesc('created_at')->paginate(20);

        return ApiResponse::success($sessions->getCollection()->map(fn (AuthSession $session): array => [
            'id' => $session->getKey(), 'description' => $session->client_kind === 'MOBILE' ? 'Buyer mobile app' : 'Web browser',
            'current' => $session->getKey() === $current, 'created_at' => $session->created_at->toIso8601String(), 'last_active_at' => $session->last_used_at->toIso8601String(),
        ]), ['current_page' => $sessions->currentPage(), 'last_page' => $sessions->lastPage()]);
    }

    public function revokeSession(AccountRequest $request, string $sessionId, ManageAccount $accounts): JsonResponse
    {
        $accounts->revokeSessions($request, 'ONE', $sessionId);

        return ApiResponse::success(['revoked' => true]);
    }

    public function revokeSessions(AccountRequest $request, ManageAccount $accounts): JsonResponse
    {
        $accounts->revokeSessions($request, $request->validated('scope'));

        return ApiResponse::success(['revoked' => true]);
    }

    public function changePassword(AccountRequest $request, ManageAccount $accounts): JsonResponse
    {
        $accounts->changePassword($request, $request->validated('password'));

        return ApiResponse::success(['changed' => true, 'sign_in_required' => $request->user()->account_type !== 'BUYER']);
    }

    public function startEmailChange(AccountRequest $request, ManageAccount $accounts): JsonResponse
    {
        return ApiResponse::success($accounts->startEmailChange($request, $request->validated('email')));
    }

    public function confirmEmailChange(AccountRequest $request, ManageAccount $accounts): JsonResponse
    {
        $accounts->confirmEmailChange($request, $request->validated('id'), $request->validated('code'));

        return ApiResponse::success(['changed' => true, 'sign_in_required' => true]);
    }

    public function startFactor(AccountRequest $request, ManageSecurityFactor $factors): JsonResponse
    {
        return ApiResponse::success($factors->start($request));
    }

    public function confirmFactor(AccountRequest $request, ManageSecurityFactor $factors): JsonResponse
    {
        return ApiResponse::success(['recovery_codes' => $factors->confirm($request, $request->validated('id'), $request->validated('code')), 'sign_in_required' => true]);
    }

    public function recoveryCodes(AccountRequest $request, ManageSecurityFactor $factors): JsonResponse
    {
        return ApiResponse::success(['recovery_codes' => $factors->recoveryCodes($request)]);
    }

    public function agreements(Request $request, AccountAgreements $agreements): JsonResponse
    {
        return ApiResponse::success($agreements->current($request));
    }

    public function acceptAgreements(AccountRequest $request, AccountAgreements $agreements): JsonResponse
    {
        $agreements->accept($request, $request->validated('version_ids'));

        return ApiResponse::success(['accepted' => true]);
    }
}
