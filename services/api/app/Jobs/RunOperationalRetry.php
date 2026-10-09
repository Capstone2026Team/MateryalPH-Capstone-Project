<?php

declare(strict_types=1);

namespace App\Jobs;

use App\Domain\Analytics\Geo\GeoFactsBuilder;
use App\Domain\Analytics\MaterialPriceCaptureService;
use Carbon\CarbonImmutable;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;

/** An authorized, idempotent re-run of a daily analytics job requested from Integration and Job Health. */
final class RunOperationalRetry implements ShouldQueue
{
    use Dispatchable;
    use InteractsWithQueue;
    use Queueable;

    public int $tries = 1;

    public function __construct(public readonly string $target, public readonly ?int $userId) {}

    public function handle(GeoFactsBuilder $geo, MaterialPriceCaptureService $prices): void
    {
        match ($this->target) {
            'GEO_FACTS_RUN' => $geo->build('ADMIN_RETRY', $this->userId),
            // A retry of an already published day returns the same revision (MAT-04 run uniqueness).
            'MATERIAL_SNAPSHOT' => $prices->capture(CarbonImmutable::now()),
            default => null,
        };
    }
}
