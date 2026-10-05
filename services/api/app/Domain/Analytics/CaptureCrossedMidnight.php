<?php

declare(strict_types=1);

namespace App\Domain\Analytics;

use RuntimeException;

/** Raised inside the capture transaction when local midnight passed before publication; the staging rolls back. */
final class CaptureCrossedMidnight extends RuntimeException {}
