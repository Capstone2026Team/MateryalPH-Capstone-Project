<?php

declare(strict_types=1);

namespace App\Domain\Reporting;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Notifications\NotificationService;
use App\Models\User;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;

final class TaxReminderService
{
    public function sweep(): int
    {
        $count = 0;
        DB::table('tax_report_packages')->whereNotNull('nominal_due_date')->orderBy('id')->chunkById(100, function ($packages) use (&$count): void {
            foreach ($packages as $package) {
                $due = $package->actual_due_date ?? $package->nominal_due_date;
                $days = (int) CarbonImmutable::now('Asia/Manila')->startOfDay()->diffInDays(CarbonImmutable::parse($due, 'Asia/Manila'), false);
                if (! in_array($days, [15, 7, 1], true) && $days >= 0) {
                    continue;
                }
                $key = $package->id.':'.$package->lock_version.':'.($days < 0 ? 'OVERDUE' : (string) $days);
                $body = $package->due_date_reviewer_id === null ? 'DUE_DATE_REVIEW_REQUIRED. Review the cited calendar source and assign an independent finance reviewer.' : 'A reviewed demo tax deadline needs attention. Export does not close filing evidence or reconciliation tasks.';
                User::query()->where('account_type', 'ADMIN')->where('account_status', 'ACTIVE')->chunkById(100, function ($users) use ($package, $key, $body, &$count): void {
                    foreach ($users as $user) {
                        try {
                            $allowed = app(AccountAccess::class)->allows($user, 'finance.review_tax');
                        } catch (AuthenticationException) {
                            continue;
                        }
                        if (! $allowed) {
                            continue;
                        }
                        app(NotificationService::class)->record((int) $user->getKey(), 'FINANCE_MANDATORY', 'Tax reporting deadline', $body, 'TAX_REPORT_PACKAGE', $package->id, $key);
                        $count++;
                    }
                });
            }
        }, 'id');

        return $count;
    }
}
