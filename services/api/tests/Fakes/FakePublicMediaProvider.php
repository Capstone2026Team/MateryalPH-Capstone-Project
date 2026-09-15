<?php

declare(strict_types=1);

namespace Tests\Fakes;

use App\Domain\Vendors\PublicMediaProvider;
use Closure;

final class FakePublicMediaProvider implements PublicMediaProvider
{
    /** @var array<string, string> */
    private array $images = [];

    public ?Closure $afterUpload = null;

    public bool $failCleanup = false;

    public bool $failAfterUpload = false;

    public int $uploads = 0;

    public int $removals = 0;

    public function upload(string $path, string $key): array
    {
        $this->uploads++;
        $this->images[$key] = file_get_contents($path);
        if ($this->afterUpload !== null) {
            ($this->afterUpload)();
        }
        if ($this->failAfterUpload) {
            throw new \RuntimeException('TEST upload outcome unconfirmed');
        }

        return ['asset_id' => 'TEST-FIXTURE-'.hash('sha256', $key), 'format' => 'png'];
    }

    public function remove(string $key): void
    {
        $this->removals++;
        if ($this->failCleanup) {
            throw new \RuntimeException('TEST cleanup failure');
        }
        unset($this->images[$key]);
    }

    public function contents(string $key, string $format): string
    {
        return $this->images[$key];
    }
}
