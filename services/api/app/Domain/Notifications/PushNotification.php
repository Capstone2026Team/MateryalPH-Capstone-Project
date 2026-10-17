<?php

declare(strict_types=1);

namespace App\Domain\Notifications;

use Illuminate\Support\Str;

/** Recipient-authorized display copy, bounded below the FCM payload limit. */
final readonly class PushNotification
{
    public string $title;

    public string $body;

    public function __construct(public string $id, string $title, string $body)
    {
        $this->title = self::preview($title, 255);
        $this->body = self::preview($body);
    }

    public static function preview(string $text, int $limit = 320): string
    {
        $preview = Str::squish(preg_replace('/\p{Cc}+/u', ' ', $text) ?? '');

        return mb_strwidth($preview, 'UTF-8') > $limit ? Str::limit($preview, $limit - 1, '…') : $preview;
    }
}
