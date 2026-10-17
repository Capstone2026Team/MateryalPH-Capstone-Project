<?php

use App\Domain\Messaging\BuyerInboxChannel;
use App\Domain\Messaging\ConversationChannel;
use App\Domain\Notifications\NotificationChannel;
use Illuminate\Support\Facades\Broadcast;

Broadcast::channel('conversation.{purpose}.{id}.{viewer}.{epoch}', ConversationChannel::class, ['guards' => ['api']]);
Broadcast::channel('buyer-inbox.{epoch}', BuyerInboxChannel::class, ['guards' => ['api']]);
Broadcast::channel('vendor-inbox.{epoch}', BuyerInboxChannel::class, ['guards' => ['api']]);
Broadcast::channel('notifications.{epoch}', NotificationChannel::class, ['guards' => ['api']]);
