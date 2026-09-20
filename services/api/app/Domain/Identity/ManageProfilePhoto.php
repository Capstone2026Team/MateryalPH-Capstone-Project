<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

final class ManageProfilePhoto
{
    public function __construct(private readonly ProfilePhotoScanner $scanner, private readonly AuditRecorder $audit) {}

    public function upload(Request $request, UploadedFile $file, int $version): User
    {
        if (! function_exists('imagecreatefromstring')) {
            throw new AuthenticationException('PHOTO_PROCESSOR_UNAVAILABLE', 'Image processing is unavailable. Please try again later.', 503);
        }
        $this->scanner->assertClean($file->getRealPath());
        $image = @imagecreatefromstring((string) file_get_contents($file->getRealPath()));
        if ($image === false) {
            throw new AuthenticationException('PHOTO_INVALID', 'Choose a valid JPEG, PNG or WebP image.', 422);
        }
        $size = min(imagesx($image), imagesy($image));
        $output = imagecreatetruecolor(256, 256);
        imagefill($output, 0, 0, imagecolorallocate($output, 255, 255, 255));
        imagecopyresampled($output, $image, 0, 0, (int) ((imagesx($image) - $size) / 2), (int) ((imagesy($image) - $size) / 2), 256, 256, $size, $size);
        ob_start();
        imagepng($output);
        $bytes = (string) ob_get_clean();
        imagedestroy($image);
        imagedestroy($output);
        $disk = (string) config('materyalph.files.disk', 'local');
        $key = 'private/profile-photos/'.Str::uuid7().'.png';
        if (! Storage::disk($disk)->put($key, $bytes, 'private')) {
            throw new AuthenticationException('PHOTO_STORAGE_UNAVAILABLE', 'The photo could not be saved. Try again.', 503);
        }
        try {
            return DB::transaction(function () use ($request, $version, $disk, $key): User {
                $user = User::query()->whereKey($request->user()->getKey())->lockForUpdate()->firstOrFail();
                if ((int) $user->lock_version !== $version) {
                    throw new AuthenticationException('RESOURCE_VERSION_CONFLICT', 'Your profile changed. Refresh before uploading.', 409);
                }
                $user->forceFill(['profile_photo_key' => $key, 'profile_photo_disk' => $disk, 'lock_version' => $version + 1])->save();
                $this->audit->account($request, 'PROFILE_PHOTO_UPDATED', 'USER', $user->public_id, after: ['scan_state' => 'CLEAN', 'sanitized' => true]);

                return $user;
            });
        } catch (\Throwable $error) {
            Storage::disk($disk)->delete($key);
            throw $error;
        }
    }
}
