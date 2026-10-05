<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Reviews\ReviewModerationService;
use App\Domain\Reviews\ReviewQueries;
use App\Domain\Reviews\ReviewRules;
use App\Domain\Reviews\ReviewService;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Symfony\Component\HttpFoundation\StreamedResponse;

/**
 * Verified-purchase reviews: Buyer and Vendor submission/correction, public review lists, reports and Admin moderation.
 * The controller validates transport and hands one use case to the domain, which authorizes again. There is no route
 * that deletes a review.
 */
final class ReviewController extends Controller
{
    public function __construct(private readonly ReviewService $reviews, private readonly ReviewQueries $queries, private readonly ReviewModerationService $moderation) {}

    public function buyerOrder(Request $request, string $orderId): JsonResponse
    {
        return ApiResponse::success($this->reviews->buyerOrder($request, $orderId));
    }

    public function buyerSubmit(Request $request, string $orderId): JsonResponse
    {
        $input = $request->validate([
            'display_name_choice' => ['required', Rule::in(ReviewRules::DISPLAY_CHOICES)],
            'vendor_rating' => ['sometimes', 'nullable', 'array'],
            'vendor_rating.service_quality' => ['required_with:vendor_rating', 'integer', 'between:1,5'],
            'vendor_rating.speed_rating' => ['required_with:vendor_rating', 'integer', 'between:1,5'],
            'vendor_rating.comment' => ['sometimes', 'nullable', 'string', 'max:'.ReviewRules::COMMENT_MAX],
            'product_reviews' => ['sometimes', 'array', 'max:100'],
            'product_reviews.*.order_line_id' => ['required', 'uuid'],
            'product_reviews.*.rating' => ['required', 'integer', 'between:1,5'],
            'product_reviews.*.comment' => ['sometimes', 'nullable', 'string', 'max:'.ReviewRules::COMMENT_MAX],
        ]);

        return ApiResponse::success($this->reviews->submitBuyer($request, $orderId, $input), status: 201);
    }

    public function buyerEdit(Request $request, string $reviewId): JsonResponse
    {
        return ApiResponse::success($this->reviews->edit($request, 'BUYER', $reviewId, $request->validate([
            'lock_version' => ['required', 'integer', 'min:1'], 'service_quality' => ['sometimes', 'integer', 'between:1,5'], 'speed_rating' => ['sometimes', 'integer', 'between:1,5'],
            'rating' => ['sometimes', 'integer', 'between:1,5'], 'comment' => ['sometimes', 'nullable', 'string', 'max:'.ReviewRules::COMMENT_MAX],
        ])));
    }

    public function addMedia(Request $request, string $reviewId): JsonResponse
    {
        $request->validate(['files' => ['required', 'array', 'min:1', 'max:'.ReviewRules::MEDIA_MAX], 'files.*' => ['file', 'max:5120']]);

        return ApiResponse::success($this->reviews->addMedia($request, $reviewId, array_values($request->file('files', []))));
    }

    public function removeMedia(Request $request, string $reviewId, string $mediaId): JsonResponse
    {
        return ApiResponse::success($this->reviews->removeMedia($request, $reviewId, $mediaId));
    }

    public function buyerFlag(Request $request, string $reviewId): JsonResponse
    {
        $this->reviews->flag($request, 'BUYER', $reviewId, $this->flagInput($request));

        return ApiResponse::success(['reported' => true], status: 201);
    }

    public function listingReviews(Request $request, string $listingId): JsonResponse
    {
        $page = $request->validate(['page' => ['sometimes', 'integer', 'between:1,500']]);
        $result = $this->queries->listingReviews($listingId, (int) ($page['page'] ?? 1));

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function storeReviews(Request $request, string $vendorId): JsonResponse
    {
        $page = $request->validate(['page' => ['sometimes', 'integer', 'between:1,500']]);
        $result = $this->queries->storeReviews($vendorId, (int) ($page['page'] ?? 1));

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function vendorIndex(Request $request): JsonResponse
    {
        $result = $this->queries->vendorReviews($request, $request->validate(['type' => ['sometimes', Rule::in([ReviewRules::VENDOR, ReviewRules::PRODUCT, ReviewRules::BUYER])], 'page' => ['sometimes', 'integer', 'between:1,500']]));

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function vendorOrder(Request $request, string $orderId): JsonResponse
    {
        return ApiResponse::success($this->reviews->vendorOrder($request, $orderId));
    }

    public function vendorSubmit(Request $request, string $orderId): JsonResponse
    {
        return ApiResponse::success($this->reviews->submitVendor($request, $orderId, $request->validate([
            'inquiry_seriousness' => ['required', 'integer', 'between:1,5'], 'communication_quality' => ['required', 'integer', 'between:1,5'],
            'payment_reliability' => ['required', 'integer', 'between:1,5'], 'comment' => ['sometimes', 'nullable', 'string', 'max:'.ReviewRules::COMMENT_MAX],
        ])), status: 201);
    }

    public function vendorEdit(Request $request, string $reviewId): JsonResponse
    {
        return ApiResponse::success($this->reviews->edit($request, 'VENDOR', $reviewId, $request->validate([
            'lock_version' => ['required', 'integer', 'min:1'], 'inquiry_seriousness' => ['sometimes', 'integer', 'between:1,5'], 'communication_quality' => ['sometimes', 'integer', 'between:1,5'],
            'payment_reliability' => ['sometimes', 'integer', 'between:1,5'], 'comment' => ['sometimes', 'nullable', 'string', 'max:'.ReviewRules::COMMENT_MAX],
        ])));
    }

    public function vendorFlag(Request $request, string $reviewId): JsonResponse
    {
        $this->reviews->flag($request, 'VENDOR', $reviewId, $this->flagInput($request));

        return ApiResponse::success(['reported' => true], status: 201);
    }

    public function moderationQueue(Request $request): JsonResponse
    {
        $result = $this->queries->moderationQueue($request, $request->validate(['state' => ['sometimes', Rule::in(['NEEDS_ACTION', 'ALL', 'FLAGGED', 'HIDDEN_PENDING_REVIEW', 'CORRECTION_REQUESTED', 'REMOVED', 'NONE'])],
            'page' => ['sometimes', 'integer', 'between:1,500']]));

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function moderationDetail(Request $request, string $reviewId): JsonResponse
    {
        return ApiResponse::success($this->queries->moderationDetail($request, $reviewId));
    }

    public function moderate(Request $request, string $reviewId): JsonResponse
    {
        return ApiResponse::success($this->moderation->decide($request, $reviewId, $request->validate([
            'action' => ['required', Rule::in(ReviewRules::MODERATION_ACTIONS)], 'reason' => ['required', 'string', 'min:10', 'max:2000'], 'lock_version' => ['required', 'integer', 'min:1'],
        ])));
    }

    public function media(Request $request, string $reviewId, string $mediaId): StreamedResponse
    {
        return $this->queries->media($request->user(), $reviewId, $mediaId);
    }

    /** @return array{reason_code: string, details?: ?string} */
    private function flagInput(Request $request): array
    {
        return $request->validate(['reason_code' => ['required', Rule::in(ReviewRules::FLAG_REASONS)], 'details' => ['sometimes', 'nullable', 'string', 'max:1000']]);
    }
}
