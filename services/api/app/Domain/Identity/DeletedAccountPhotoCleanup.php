<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Models\User;
use Illuminate\Support\Facades\Storage;
use RuntimeException;

/** Post-commit, retryable deletion of a personal avatar; never accepts commercial file keys. */
final class DeletedAccountPhotoCleanup
{
    public function delete(int $userId, string $disk, string $key): void
    {
        if (! preg_match('~^private/profile-photos/[0-9a-f-]{36}\.png$~D', $key)
            || ! is_array(config('filesystems.disks.'.$disk))) {
            throw new RuntimeException('Invalid personal photo cleanup scope.');
        }
        if (! User::query()->whereKey($userId)->where('account_status', 'DELETED')->exists()
            || User::query()->where('profile_photo_disk', $disk)->where('profile_photo_key', $key)->exists()) {
            return;
        }
        if (! Storage::disk($disk)->delete($key)) {
            throw new RuntimeException('Personal photo cleanup must be retried.');
        }
    }
}
