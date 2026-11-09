<?php

declare(strict_types=1);

namespace App\Domain\Projects;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Geography\BuyerProfiles;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\OutboxPublisher;
use App\Domain\Orders\OrderStates;
use Carbon\CarbonImmutable;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/** Workspace removal never cascades through immutable commercial or financial history. */
final class ProjectArchives
{
    public const PACKAGE_BLOCKER = 'This work package cannot be archived because it contains an ongoing order. Please complete or cancel all active orders first.';

    public const PROJECT_BLOCKER = 'This project cannot be archived because one or more work packages contain ongoing orders.';

    public function __construct(private readonly ProjectService $projects, private readonly CatalogAccess $keys) {}

    /** Covers direct, supplementary and missing-line purchases across every saved original. */
    public static function ongoing(string $projectId, ?string $packageId = null): bool
    {
        $packages = fn (): Builder => DB::table('work_packages')->select('id')->where('project_id', $projectId)
            ->when($packageId !== null, fn (Builder $q) => $q->where('id', $packageId));
        $versions = fn (): Builder => DB::table('work_package_versions')->select('id')->whereIn('work_package_id', $packages());

        return DB::table('orders as o')->whereNotIn('o.order_state', [...OrderStates::CLOSED_BEFORE_FULFILLMENT, OrderStates::COMPLETED])
            ->where(function (Builder $q) use ($packages, $versions): void {
                $q->whereIn('o.work_package_id', $packages())
                    ->orWhereIn('o.id', DB::table('work_package_missing_lines')->select('linked_order_id')->whereIn('work_package_version_id', $versions()))
                    ->orWhereIn('o.id', DB::table('order_lines as ol')->join('work_package_lines as l', 'l.id', '=', 'ol.work_package_line_id')->select('ol.order_id')->whereIn('l.work_package_version_id', $versions()))
                    ->orWhereIn('o.id', DB::table('project_procurement_draft_items')->select('order_id')->whereIn('work_package_version_id', $versions()));
            })->exists();
    }

    /** @return array<string, mixed> */
    public static function metadata(object $row, bool $project): array
    {
        $ongoing = self::ongoing($project ? $row->id : $row->project_id, $project ? null : $row->id);

        return ['archived_at' => $row->archived_at, 'delete_after' => $row->delete_after,
            'can_archive' => $row->archived_at === null && $row->deleted_at === null && ! $ongoing,
            'archive_blocker' => $ongoing ? ($project ? self::PROJECT_BLOCKER : self::PACKAGE_BLOCKER) : null];
    }

    /** @return array<string, mixed> */
    public function index(Request $r, string $type): array
    {
        $project = $type === 'PROJECT';
        $q = $project ? DB::table('projects as i')->where('i.buyer_profile_id', app(BuyerProfiles::class)->idFor($r))
            : DB::table('work_packages as i')->join('projects as p', 'p.id', '=', 'i.project_id')->where('p.buyer_profile_id', app(BuyerProfiles::class)->idFor($r))->whereNull('p.deleted_at');
        $page = $q->whereNotNull('i.archived_at')->whereNull('i.deleted_at')->orderByDesc('i.archived_at')->orderBy('i.id')->select('i.*')->paginate(25);
        $items = [];
        foreach ($page->items() as $row) {
            $parent = $project ? null : DB::table('projects')->where('id', $row->project_id)->first();
            $expired = CarbonImmutable::parse($row->delete_after)->lessThanOrEqualTo(now());
            $items[] = ['id' => $row->id, 'type' => $type, 'name' => $row->name, 'budget_centavos' => (int) $row->budget_centavos,
                'lock_version' => (int) $row->lock_version, 'project_id' => $project ? $row->id : $row->project_id,
                'project_name' => $parent?->name, 'parent_archived' => $parent?->status === 'ARCHIVED',
                'archived_at' => CarbonImmutable::parse($row->archived_at)->toISOString(), 'delete_after' => CarbonImmutable::parse($row->delete_after)->toISOString(),
                'remaining_days' => max(0, (int) ceil((CarbonImmutable::parse($row->delete_after)->getTimestamp() - now()->getTimestamp()) / 86400)),
                'can_restore' => ! $expired && ($parent === null || $parent->status !== 'ARCHIVED'),
                'can_delete' => ! self::ongoing($project ? $row->id : $row->project_id, $project ? null : $row->id)];
        }

        return ['items' => $items, 'page' => $page->currentPage(), 'has_more' => $page->hasMorePages()];
    }

    public function change(Request $r, string $id, bool $project, string $action, int $version): void
    {
        $key = $this->keys->requireIdempotencyKey($r);
        DB::transaction(function () use ($r, $id, $project, $action, $version, $key): void {
            // Every procurement writer takes the parent before the package lock.
            $parentId = $project ? $id : DB::table('work_packages')->where('id', $id)->value('project_id');
            $parent = DB::table('projects')->where('id', $parentId)->where('buyer_profile_id', app(BuyerProfiles::class)->idFor($r))->lockForUpdate()->first();
            if ($parent === null) {
                throw new AuthenticationException('PROJECT_NOT_FOUND', 'This Project is unavailable.', 404);
            }
            $endpoint = ($project ? 'PROJECT_' : 'WORK_PACKAGE_').$action;
            if ($this->keys->replayed($r, $endpoint, $key, $id)) {
                return;
            }
            if ($parent->deleted_at !== null) {
                throw new AuthenticationException('PROJECT_NOT_FOUND', 'This Project is unavailable.', 404);
            }
            $row = $project ? $parent : DB::table('work_packages')->where('id', $id)->whereNull('deleted_at')->lockForUpdate()->first();
            if ($row === null) {
                throw new AuthenticationException('WORK_PACKAGE_NOT_FOUND', 'This Work Package is unavailable.', 404);
            }
            ProjectService::version($row, $version);
            if ($action === 'ARCHIVE') {
                if ($row->archived_at !== null || (! $project && $parent->status === 'ARCHIVED')) {
                    throw new AuthenticationException('PROJECT_CLOSED', 'Restore the Project and Work Package before changing procurement.', 409);
                }
                $this->assertFinalized($row, $project);
                $at = CarbonImmutable::now('UTC');
                $update = ['archived_at' => $at, 'delete_after' => $at->addHours(720)];
                if ($project) {
                    $update += ['status' => 'ARCHIVED', 'archived_from_status' => $row->status];
                }
                foreach ($this->packages($row, $project) as $w) {
                    $this->projects->invalidate($w->id);
                }
            } else {
                if ($row->archived_at === null) {
                    throw new AuthenticationException('ITEM_NOT_ARCHIVED', 'Archive this item first.', 409);
                }
                if ($action === 'RESTORE') {
                    if (CarbonImmutable::parse($row->delete_after)->lessThanOrEqualTo(now())) {
                        throw new AuthenticationException('ARCHIVE_RETENTION_EXPIRED', 'The 30-day restoration period has ended.', 409);
                    }
                    if (! $project && $parent->status === 'ARCHIVED') {
                        throw new AuthenticationException('PARENT_PROJECT_ARCHIVED', 'Restore the parent project before restoring this work package.', 409);
                    }
                    $update = ['archived_at' => null, 'delete_after' => null];
                    if ($project) {
                        $update += ['status' => $row->archived_from_status ?? 'ACTIVE', 'archived_from_status' => null];
                    }
                } else {
                    $this->assertFinalized($row, $project);
                    $this->remove($row, $project);
                    $update = ['deleted_at' => now()];
                }
            }
            DB::table($project ? 'projects' : 'work_packages')->where('id', $id)->update($update + ['lock_version' => $row->lock_version + 1, 'updated_at' => now()]);
            $event = ($project ? 'PROJECT_' : 'WORK_PACKAGE_').match ($action) {
                'ARCHIVE' => 'ARCHIVED', 'RESTORE' => 'RESTORED', default => 'PERMANENTLY_DELETED',
            };
            $this->projects->record($r, $event, $id);
            $this->keys->claim($r, $endpoint, $key, $id, 200);
        }, 3);
    }

    public static function assertProcurementOpen(object $w): void
    {
        $parent = DB::table('projects')->where('id', $w->project_id)->first();
        if ($w->archived_at !== null || $w->deleted_at !== null || $parent === null || $parent->status !== 'ACTIVE' || $parent->deleted_at !== null) {
            throw new AuthenticationException('PROCUREMENT_ARCHIVED', 'Restore the Project and Work Package before starting procurement or rescanning suppliers.', 409);
        }
    }

    private function assertFinalized(object $row, bool $project): void
    {
        if (self::ongoing($project ? $row->id : $row->project_id, $project ? null : $row->id)) {
            throw new AuthenticationException('ONGOING_ORDERS', $project ? self::PROJECT_BLOCKER : self::PACKAGE_BLOCKER, 409);
        }
    }

    /** @return Collection<int, \stdClass> */
    private function packages(object $row, bool $project): Collection
    {
        return DB::table('work_packages')->when($project, fn (Builder $q) => $q->where('project_id', $row->id), fn (Builder $q) => $q->where('id', $row->id))->orderBy('id')->lockForUpdate()->get();
    }

    private function remove(object $row, bool $project): void
    {
        foreach ($this->packages($row, $project) as $w) {
            if ($w->deleted_at !== null) {
                continue;
            }
            $this->projects->invalidate($w->id);
            DB::table('work_packages')->where('id', $w->id)->update(['status' => 'CANCELLED', 'deleted_at' => now(), 'lock_version' => $w->lock_version + 1, 'updated_at' => now()]);
        }
    }

    /** No queued snapshot is authoritative: re-read timestamps and eligibility under the same locks as restore. */
    public function sweep(): int
    {
        $count = 0;
        foreach (['projects', 'work_packages'] as $table) {
            $project = $table === 'projects';
            DB::table($table)->whereNull('deleted_at')->whereNotNull('archived_at')->where('delete_after', '<=', now())->orderBy('id')
                ->chunkById(100, function ($rows) use ($table, $project, &$count): void {
                    foreach ($rows as $candidate) {
                        $count += DB::transaction(function () use ($candidate, $table, $project): int {
                            $parent = DB::table('projects')->where('id', $project ? $candidate->id : $candidate->project_id)->lockForUpdate()->first();
                            $row = $project ? $parent : DB::table($table)->where('id', $candidate->id)->lockForUpdate()->first();
                            if ($row === null || $row->deleted_at !== null || $row->archived_at === null || $row->delete_after === null
                                || CarbonImmutable::parse($row->delete_after)->isFuture() || ($project && $row->status !== 'ARCHIVED')
                                || self::ongoing($project ? $row->id : $row->project_id, $project ? null : $row->id)) {
                                return 0;
                            }
                            $this->remove($row, $project);
                            if ($project) {
                                DB::table($table)->where('id', $row->id)->update(['deleted_at' => now(), 'lock_version' => $row->lock_version + 1, 'updated_at' => now()]);
                            }
                            $event = $project ? 'PROJECT_RETENTION_DELETED' : 'WORK_PACKAGE_RETENTION_DELETED';
                            DB::table('audit_logs')->insert(['id' => (string) Str::uuid7(), 'actor_role' => 'SYSTEM', 'action' => $event,
                                'resource_type' => 'PROJECT_PROCUREMENT', 'resource_id' => $row->id, 'before' => '{}', 'after' => json_encode(['workspace_removed' => true, 'commercial_history_retained' => true], JSON_THROW_ON_ERROR),
                                'correlation_id' => (string) Str::uuid7(), 'succeeded' => true, 'created_at' => now(), 'updated_at' => now()]);
                            app(OutboxPublisher::class)->publish($event, 'PROJECT_PROCUREMENT', $row->id, ['commercial_history_retained' => 1]);

                            return 1;
                        }, 3);
                    }
                });
        }

        return $count;
    }
}
