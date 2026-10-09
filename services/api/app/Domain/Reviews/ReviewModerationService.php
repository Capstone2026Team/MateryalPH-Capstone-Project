<?php

declare(strict_types=1);

namespace App\Domain\Reviews;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Product Review Moderation Queue decisions. Every action needs a written reason, appends an immutable moderation
 * entry and an audit record, and never alters the review content or its revisions. Dismiss Flag keeps the review
 * public; Hide Pending Review and Request Correction (one author correction within 7 days) hide it; Remove is final;
 * Restore returns a hidden review to public view. There is no delete path for anyone.
 */
final class ReviewModerationService
{
    /** @var array<string, array{from: list<string>, to: string}> */
    private const TRANSITIONS = [
        'DISMISS_FLAG' => ['from' => ['FLAGGED', 'NONE'], 'to' => 'NONE'],
        'HIDE_PENDING_REVIEW' => ['from' => ['NONE', 'FLAGGED'], 'to' => 'HIDDEN_PENDING_REVIEW'],
        'REQUEST_CORRECTION' => ['from' => ['NONE', 'FLAGGED', 'HIDDEN_PENDING_REVIEW'], 'to' => 'CORRECTION_REQUESTED'],
        'REMOVE' => ['from' => ['NONE', 'FLAGGED', 'HIDDEN_PENDING_REVIEW', 'CORRECTION_REQUESTED'], 'to' => 'REMOVED'],
        'RESTORE' => ['from' => ['HIDDEN_PENDING_REVIEW', 'CORRECTION_REQUESTED'], 'to' => 'NONE'],
    ];

    public function __construct(private readonly ReviewAccess $access, private readonly CatalogAccess $keys, private readonly AuditRecorder $audit, private readonly ReviewQueries $queries) {}

    /** @return list<string> */
    public static function actionsFor(string $state): array
    {
        return array_keys(array_filter(self::TRANSITIONS, static fn (array $rule): bool => in_array($state, $rule['from'], true)));
    }

    /**
     * @param  array{action: string, reason: string, lock_version: int}  $input
     * @return array<string, mixed>
     */
    public function decide(Request $request, string $reviewId, array $input): array
    {
        $scope = $this->access->admin($request, ReviewAccess::MODERATE);
        $key = $this->keys->requireIdempotencyKey($request);
        DB::transaction(function () use ($request, $reviewId, $input, $scope, $key): void {
            if ($this->keys->replayed($request, 'REVIEW_MODERATE', $key, $reviewId)) {
                return;
            }
            $review = DB::table('reviews')->where('id', ReviewAccess::uuid($reviewId))->whereNotNull('submitted_at')->lockForUpdate()->first();
            if ($review === null) {
                throw new AuthenticationException('REVIEW_NOT_FOUND', 'This review is unavailable.', 404);
            }
            if ((int) $review->lock_version !== (int) $input['lock_version']) {
                throw new AuthenticationException('REVIEW_VERSION_CONFLICT', 'This review changed since you opened it. Refresh before deciding.', 409);
            }
            $rule = self::TRANSITIONS[$input['action']] ?? null;
            if ($rule === null || ! in_array($review->moderation_state, $rule['from'], true)) {
                throw new AuthenticationException('MODERATION_ACTION_UNAVAILABLE', 'This action is not available for the review\'s current state.', 409, ['moderation_state' => $review->moderation_state]);
            }
            $update = ['moderation_state' => $rule['to'], 'lock_version' => (int) $review->lock_version + 1, 'updated_at' => now()];
            if ($input['action'] === 'REQUEST_CORRECTION') {
                $update += ['correction_due_at' => now()->addDays(ReviewRules::correctionDays()), 'corrected_at' => null];
            }
            DB::table('reviews')->where('id', $review->id)->update($update);
            DB::table('review_flags')->where('review_id', $review->id)->where('state', 'OPEN')
                ->update(['state' => $input['action'] === 'DISMISS_FLAG' ? 'DISMISSED' : 'ACTIONED', 'resolved_by_user_id' => $request->user()->getKey(), 'resolved_at' => now(), 'updated_at' => now()]);
            DB::table('review_moderation')->insert(['id' => (string) Str::uuid7(), 'review_id' => $review->id, 'actor_user_id' => $request->user()->getKey(), 'action' => $input['action'],
                'from_state' => $review->moderation_state, 'to_state' => $rule['to'], 'reason' => $input['reason'], 'actor_role' => $scope['role'],
                'payload' => json_encode(['correction_due_at' => isset($update['correction_due_at']) ? $update['correction_due_at']->toIso8601String() : null], JSON_THROW_ON_ERROR),
                'correlation_id' => (string) $request->attributes->get('correlation_id'), 'created_at' => now(), 'updated_at' => now()]);
            $this->keys->claim($request, 'REVIEW_MODERATE', $key, $reviewId, 200);
            $this->audit->account($request, 'REVIEW_MODERATED', 'REVIEW', (string) $review->id, ['moderation_state' => $review->moderation_state], ['moderation_state' => $rule['to'], 'action' => $input['action']], reason: $input['reason']);
        });

        return $this->queries->moderationDetail($request, $reviewId);
    }
}
