<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Messaging\BuyerInboxChannel;
use App\Domain\Messaging\ConversationAccess;
use App\Domain\Messaging\ConversationChannel;
use App\Domain\Messaging\ConversationFiles;
use App\Domain\Messaging\ConversationService;
use App\Domain\Messaging\QuotationService;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Broadcast;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Symfony\Component\HttpFoundation\Response;

final class ConversationController extends Controller
{
    public function __construct(private readonly ConversationService $conversations, private readonly ConversationAccess $access) {}

    public function index(Request $request): JsonResponse
    {
        $request->validate(['page' => ['sometimes', 'integer', 'between:1,10000']]);

        return ApiResponse::success($this->conversations->inbox($request));
    }

    public function create(Request $request): JsonResponse
    {
        $input = $request->validate(['vendor_id' => ['required', 'uuid'], 'listing_variant_id' => ['nullable', 'uuid'], 'location_id' => ['nullable', 'uuid'], 'heavy_vehicle_restriction' => ['sometimes', 'in:UNANSWERED,NO,YES'], 'alternate_drop_off_location_id' => ['required_if:heavy_vehicle_restriction,YES', 'nullable', 'uuid', 'different:location_id'], 'access_instructions' => ['required_if:heavy_vehicle_restriction,YES', 'nullable', 'string', 'min:5', 'max:500'], 'context_type' => ['sometimes', 'in:ITEM_BASED,PROJECT_BASED']]);

        return ApiResponse::success(['id' => $this->conversations->create($request, $input)], [], 201);
    }

    public function show(Request $request, string $conversationId, QuotationService $quotations): JsonResponse
    {
        $c = $this->access->require($request->user(), $conversationId);
        $request->validate(['before' => ['sometimes', 'uuid'], 'page' => ['sometimes', 'integer', 'between:1,10000']]);

        return ApiResponse::success(['conversation' => $this->conversations->header($request, $c), 'messages' => $this->conversations->messages($request, $conversationId),
            'quotations' => $quotations->show($request, $conversationId)]);
    }

    public function send(Request $request, string $conversationId): JsonResponse
    {
        $input = $request->validate(['body' => ['required', 'string', 'max:5000', 'not_regex:/^\s*$/u'], 'client_message_id' => ['required', 'uuid']]);

        return ApiResponse::success(['id' => $this->conversations->send($request, $conversationId, $input['body'], $input['client_message_id'])], [], 201);
    }

    public function read(Request $request, string $conversationId): JsonResponse
    {
        $input = $request->validate(['through_message_id' => ['required', 'uuid']]);
        $this->conversations->read($request, $conversationId, $input['through_message_id']);

        return ApiResponse::success();
    }

    public function handlers(Request $request, string $conversationId): JsonResponse
    {
        $request->validate(['page' => ['sometimes', 'integer', 'between:1,10000']]);
        $page = $this->conversations->handlers($request, $conversationId);

        return ApiResponse::success($page['items'], ['page' => $page['page'], 'has_more' => $page['has_more']]);
    }

    public function transfer(Request $request, string $conversationId): JsonResponse
    {
        $input = $request->validate(['handler_user_id' => ['required', 'integer', 'min:1'], 'lock_version' => ['required', 'integer', 'min:1'], 'reason' => ['required', 'string', 'max:500']]);
        $this->conversations->transfer($request, $conversationId, $input['handler_user_id'], $input['lock_version'], $input['reason']);

        return ApiResponse::success();
    }

    public function draft(Request $request, string $conversationId, QuotationService $quotations): JsonResponse
    {
        $input = $request->validate(['lock_version' => ['required', 'integer', 'min:1'], 'draft' => ['required', 'array']]);
        $quotations->draft($request, $conversationId, $input['draft'], $input['lock_version']);

        return ApiResponse::success($quotations->show($request, $conversationId));
    }

    public function publish(Request $request, string $conversationId, QuotationService $quotations): JsonResponse
    {
        $input = $request->validate(['lock_version' => ['required', 'integer', 'min:1']]);
        $quotations->publish($request, $conversationId, $input['lock_version']);

        return ApiResponse::success($quotations->show($request, $conversationId));
    }

    public function decision(Request $request, string $conversationId, string $action, QuotationService $quotations): JsonResponse
    {
        $input = $request->validate(['version_id' => ['required', 'uuid'], 'content_hash' => ['required_if:action,accept', 'sometimes', 'string', 'size:64'],
            'reason' => [$action === 'counter' ? 'required' : 'nullable', 'string', 'min:3', 'max:2000'], 'nrpc_acknowledged' => ['sometimes', 'boolean'], 'nrpc_terms_version_id' => ['nullable', 'uuid']]);

        return ApiResponse::success(['order_id' => $quotations->decide($request, $conversationId, $action, $input)]);
    }

    public function upload(Request $request, string $conversationId, ConversationFiles $files): JsonResponse
    {
        $request->validate(['file' => ['required', 'file', 'max:10240'], 'client_message_id' => ['required', 'uuid']]);
        $files->upload($request, $conversationId, $request->file('file'), $request->string('client_message_id')->toString());

        return ApiResponse::success(null, [], 201);
    }

    public function download(Request $request, string $conversationId, string $attachmentId, ConversationFiles $files): Response
    {
        return $files->download($request, $conversationId, $attachmentId);
    }

    public function avatar(Request $request, string $conversationId, int $userId, ConversationFiles $files): Response
    {
        return $files->avatar($request, $conversationId, $userId);
    }

    public function authorizeChannel(Request $request): Response
    {
        $request->validate(['socket_id' => ['required', 'regex:/^\d+\.\d+$/'], 'channel_name' => ['required', 'string', 'max:240']]);
        $channel = (string) $request->input('channel_name');
        $parts = explode('.', $channel);
        if (count($parts) === 2 && $parts[0] === 'private-buyer-inbox') {
            abort_unless(app(BuyerInboxChannel::class)->join($request->user(), $parts[1]), 403);
        } else {
            if (count($parts) !== 5 || $parts[0] !== 'private-conversation' || ! Str::isUuid($parts[2])) {
                abort(403);
            }
            $c = DB::table('conversations')->where('id', $parts[2])->first();
            if ($c === null || ! $this->access->allows($request->user(), $c) || ! hash_equals('private-'.$this->access->channel($request->user(), $c), $channel)) {
                abort(403);
            }
        }
        if (config('broadcasting.default') !== 'reverb') {
            return ApiResponse::error('REALTIME_UNAVAILABLE', 'Realtime is unavailable. Messages synchronize through REST.', 503);
        }
        $broadcaster = Broadcast::connection('reverb');
        $broadcaster->channel('conversation.{purpose}.{id}.{viewer}.{epoch}', ConversationChannel::class, ['guards' => ['api']]);
        $broadcaster->channel('buyer-inbox.{epoch}', BuyerInboxChannel::class, ['guards' => ['api']]);

        return response()->json($broadcaster->auth($request));
    }

    public function realtime(Request $request): JsonResponse
    {
        return ApiResponse::success(['inbox_channel' => app(BuyerInboxChannel::class)->name($request->user()), 'enabled' => config('broadcasting.default') === 'reverb', 'key' => config('broadcasting.connections.reverb.key'),
            'host' => config('broadcasting.connections.reverb.options.host'), 'port' => config('broadcasting.connections.reverb.options.port'), 'scheme' => config('broadcasting.connections.reverb.options.scheme')]);
    }
}
