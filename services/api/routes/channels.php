<?php

use App\Domain\Messaging\BuyerInboxChannel;
use App\Domain\Messaging\ConversationChannel;
use Illuminate\Support\Facades\Broadcast;

Broadcast::channel('conversation.{purpose}.{id}.{viewer}.{epoch}', ConversationChannel::class, ['guards' => ['api']]);
Broadcast::channel('buyer-inbox.{epoch}', BuyerInboxChannel::class, ['guards' => ['api']]);
Broadcast::channel('vendor-inbox.{epoch}', BuyerInboxChannel::class, ['guards' => ['api']]);
