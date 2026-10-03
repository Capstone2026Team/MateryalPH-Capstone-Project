<?php

declare(strict_types=1);

namespace App\Domain\Messaging;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Vendors\EvidenceContentValidator;
use App\Domain\Vendors\VendorFileScanner;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Symfony\Component\HttpFoundation\StreamedResponse;

final class ConversationFiles
{
    public function __construct(private readonly ConversationAccess $access) {}

    public function upload(Request $request, string $id, UploadedFile $file, string $clientId): void
    {
        $c = $this->access->require($request->user(), $id);
        app(ConversationService::class)->requireCurrent($c);
        FulfillmentThreadService::requireWritable($c);
        if ($c->purpose === 'FULFILLMENT' && $file->getMimeType() === 'application/pdf') {
            throw new AuthenticationException('ATTACHMENT_NOT_PERMITTED', 'Fulfillment threads accept coordination photos only.', 422);
        }
        app(EvidenceContentValidator::class)->validate($file);
        app(VendorFileScanner::class)->assertClean($file->getRealPath());
        $disk = (string) config('materyalph.files.disk', 'local');
        $fileId = (string) Str::uuid7();
        $key = 'conversations/'.$id.'/'.$fileId;
        if (Storage::disk($disk)->putFileAs('conversations/'.$id, $file, $fileId, ['visibility' => 'private']) === false) {
            throw new AuthenticationException('FILE_STORAGE_UNAVAILABLE', 'The attachment could not be saved. Please retry.', 503);
        }
        try {
            $created = DB::transaction(function () use ($request, $id, $file, $clientId, $disk, $fileId, $key): bool {
                $c = $this->access->require($request->user(), $id, true);
                $previous = DB::table('messages')->where('conversation_id', $id)->where('client_message_id', $clientId)->first();
                if ($previous !== null) {
                    $checksum = DB::table('message_attachments as a')->join('files as f', 'f.id', '=', 'a.file_id')->where('a.message_id', $previous->id)->value('f.checksum_sha256');
                    if ((int) $previous->sender_user_id !== (int) $request->user()->id || $checksum !== hash_file('sha256', $file->getRealPath())) {
                        throw new AuthenticationException('IDEMPOTENCY_CONFLICT', 'Use a new message identifier for a different attachment.', 409);
                    }

                    return false;
                }
                $message = app(ConversationService::class)->append($c, $request->user(), 'Attachment', 'ATTACHMENT', $clientId);
                DB::table('files')->insert(['id' => $fileId, 'owner_type' => 'CONVERSATION', 'owner_id' => $id, 'purpose' => 'CHAT_'.$c->purpose,
                    'visibility' => 'PRIVATE', 'content_type' => $file->getMimeType(), 'byte_size' => $file->getSize(), 'checksum_sha256' => hash_file('sha256', $file->getRealPath()),
                    'scan_state' => 'CLEAN', 'object_key' => $key, 'retention_class' => 'COMMERCIAL_HISTORY', 'created_at' => now(), 'updated_at' => now()]);
                DB::table('message_attachments')->insert(['id' => (string) Str::uuid7(), 'message_id' => $message, 'file_id' => $fileId, 'scan_state' => 'CLEAN',
                    'disk' => $disk, 'storage_key' => $key, 'media_type' => $file->getMimeType(), 'size_bytes' => $file->getSize(),
                    'display_name' => 'Attachment.'.$file->extension(), 'purpose' => $c->purpose, 'created_at' => now(), 'updated_at' => now()]);

                return true;
            });
            if (! $created) {
                Storage::disk($disk)->delete($key);
            }
        } catch (\Throwable $e) {
            Storage::disk($disk)->delete($key);
            throw $e;
        }
    }

    public function download(Request $request, string $id, string $attachmentId): StreamedResponse
    {
        $c = $this->access->require($request->user(), $id);
        $file = DB::table('message_attachments as a')->join('files as f', 'f.id', '=', 'a.file_id')->where('f.visibility', 'PRIVATE')->where('f.scan_state', 'CLEAN')
            ->join('messages as m', 'm.id', '=', 'a.message_id')->where('m.conversation_id', $id)->where('a.id', $attachmentId)
            ->where('a.purpose', $c->purpose)->where('a.scan_state', 'CLEAN')->first(['a.*']);
        if ($file === null || ($c->purpose === 'FULFILLMENT' && ! in_array($file->media_type, ['image/png', 'image/jpeg'], true))) {
            throw new AuthenticationException('FILE_NOT_FOUND', 'This attachment is unavailable.', 404);
        }

        return Storage::disk($file->disk)->download($file->storage_key, $file->display_name, ['Content-Type' => $file->media_type, 'Cache-Control' => 'private, no-store', 'X-Content-Type-Options' => 'nosniff']);
    }

    public function avatar(Request $request, string $id, int $userId): StreamedResponse
    {
        $this->access->require($request->user(), $id);
        $known = DB::table('conversation_participants')->where('conversation_id', $id)->where('user_id', $userId)->exists()
            || DB::table('messages')->where('conversation_id', $id)->where('sender_user_id', $userId)->exists();
        $profile = $known ? DB::table('users')->where('id', $userId)->first() : null;
        if ($profile?->profile_photo_key === null) {
            throw new AuthenticationException('FILE_NOT_FOUND', 'This avatar is unavailable.', 404);
        }

        return Storage::disk($profile->profile_photo_disk)->response($profile->profile_photo_key, null, ['Cache-Control' => 'private, no-store', 'X-Content-Type-Options' => 'nosniff']);
    }
}
