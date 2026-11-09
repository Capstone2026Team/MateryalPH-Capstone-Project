<?php

declare(strict_types=1);

namespace App\Domain\Reporting;

use App\Domain\Catalog\CatalogFileStore;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Invoices\InvoiceAccess;
use App\Domain\Operations\OutboxPublisher;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Symfony\Component\HttpFoundation\StreamedResponse;

/** Issued order documents are durable commercial records, independent of expiring user-requested report copies. */
final class OrderDocumentService
{
    public const EVENT = 'ORDER_DOCUMENT_REQUESTED';

    public const TITLES = ['PURCHASE_ORDER' => 'MateryalPH Purchase Order'];

    public function prepare(string $orderId): int
    {
        return DB::transaction(function () use ($orderId): int {
            $order = DB::table('orders')->where('id', $orderId)->lockForUpdate()->first();
            if ($order === null || $order->accepted_snapshot_version === null) {
                return 0;
            }
            $count = 0;
            foreach (array_keys(self::TITLES) as $kind) {
                if (DB::table('order_documents')->where('order_id', $orderId)->where('kind', $kind)->exists()) {
                    continue;
                }
                $capture = app(DocumentSnapshot::class)->order($kind, $orderId);
                $hash = hash('sha256', json_encode($capture, JSON_THROW_ON_ERROR));
                $snapshot = ['title' => self::TITLES[$kind], 'generated_at' => now('Asia/Manila')->format('Y-m-d H:i:s'), 'source_hash' => $hash, ...$capture];
                $id = (string) Str::uuid7();
                DB::table('order_documents')->insert(['id' => $id, 'order_id' => $orderId, 'kind' => $kind, 'state' => 'QUEUED',
                    'source_snapshot' => json_encode($snapshot, JSON_THROW_ON_ERROR), 'source_hash' => $hash, 'created_at' => now(), 'updated_at' => now()]);
                app(OutboxPublisher::class)->publish(self::EVENT, 'ORDER_DOCUMENT', $id, ['document_id' => $id]);
                $count++;
            }

            return $count;
        });
    }

    /** Backfill already accepted/completed orders without generating anything during a read or download. */
    public function sweep(int $limit = 200): int
    {
        $ids = DB::table('orders')->whereNotNull('accepted_snapshot_version')
            ->whereNotExists(fn (Builder $docs) => $docs->selectRaw('1')->from('order_documents')
                ->whereColumn('order_documents.order_id', 'orders.id')->where('kind', 'PURCHASE_ORDER'))
            ->orderBy('id')->limit($limit)->pluck('id');
        $count = 0;
        foreach ($ids as $id) {
            $count += $this->prepare((string) $id);
        }
        // Existing issued files stay immutable; prepare a new presentation from their frozen source.
        $legacy = DB::table('order_documents')->where('state', 'READY')->where('kind', 'PURCHASE_ORDER')
            ->whereNotExists(fn (Builder $query) => $query->selectRaw('1')->from('order_document_renditions')
                ->whereColumn('order_document_renditions.order_document_id', 'order_documents.id')->where('layout_version', OrderDocumentLayout::VERSION))
            ->orderBy('id')->limit($limit)->pluck('id');
        foreach ($legacy as $id) {
            $count += DB::transaction(function () use ($id): int {
                DB::table('order_documents')->where('id', $id)->lockForUpdate()->first();
                if (DB::table('order_document_renditions')->where('order_document_id', $id)->where('layout_version', OrderDocumentLayout::VERSION)->exists()
                    || DB::table('outbox_events')->where('event_type', self::EVENT)->where('aggregate_id', $id)->whereNull('processed_at')->exists()) {
                    return 0;
                }
                app(OutboxPublisher::class)->publish(self::EVENT, 'ORDER_DOCUMENT', (string) $id, ['document_id' => (string) $id]);

                return 1;
            });
        }

        return $count;
    }

    public function process(string $id): void
    {
        Cache::lock('order-document:'.$id, 120)->block(5, function () use ($id): void {
            $document = DB::table('order_documents')->where('id', $id)->first();
            if ($document === null || ! isset(self::TITLES[$document->kind]) || ! in_array($document->state, ['QUEUED', 'READY'], true)
                || DB::table('order_document_renditions')->where('order_document_id', $id)->where('layout_version', OrderDocumentLayout::VERSION)->exists()) {
                return;
            }
            $snapshot = json_decode($document->source_snapshot, true, flags: JSON_THROW_ON_ERROR);
            $previousContext = DB::table('order_document_renditions')->where('order_document_id', $id)->whereNotNull('context_snapshot')->orderBy('layout_version')->value('context_snapshot');
            $context = $snapshot['order_details'] ?? ($previousContext === null ? PurchaseOrderDetails::capture((string) $document->order_id) : json_decode($previousContext, true, flags: JSON_THROW_ON_ERROR));
            $context = PurchaseOrderDetails::withBuyerContact((string) $document->order_id, $context);
            $snapshot['order_details'] = $context;
            $contextHash = PurchaseOrderDetails::hash($context);
            $bytes = app(DocumentRenderer::class)->render($snapshot, 'PDF');
            if (! str_starts_with($bytes, '%PDF-')) {
                throw new \RuntimeException('ORDER_DOCUMENT_RENDER_FAILED');
            }
            $disk = app(CatalogFileStore::class)->privateDisk();
            $fileId = (string) Str::uuid7();
            $key = 'private/order-documents/'.app()->environment().'/'.$document->order_id.'/'.$fileId.'.pdf';
            if (! Storage::disk($disk)->put($key, $bytes, ['visibility' => 'private'])) {
                throw new \RuntimeException('ORDER_DOCUMENT_STORAGE_UNAVAILABLE');
            }
            DB::transaction(function () use ($document, $id, $fileId, $key, $disk, $bytes, $context, $contextHash): void {
                $checksum = hash('sha256', $bytes);
                DB::table('files')->insert(['id' => $fileId, 'owner_type' => 'ORDER', 'owner_id' => $document->order_id,
                    'purpose' => 'ORDER_DOCUMENT', 'visibility' => 'PRIVATE', 'content_type' => 'application/pdf', 'byte_size' => strlen($bytes),
                    'checksum_sha256' => $checksum, 'scan_state' => 'CLEAN', 'object_key' => $key, 'retention_class' => 'COMMERCIAL_RECORD',
                    'original_name' => $this->filename($document), 'metadata' => json_encode(['source' => 'GENERATED_SNAPSHOT', 'disk' => $disk, 'layout_version' => OrderDocumentLayout::VERSION], JSON_THROW_ON_ERROR),
                    'created_at' => now(), 'updated_at' => now()]);
                DB::table('order_documents')->where('id', $id)->where('state', 'QUEUED')->update(['state' => 'READY', 'file_id' => $fileId, 'generated_at' => now(), 'updated_at' => now()]);
                DB::table('order_document_renditions')->insert(['id' => (string) Str::uuid7(), 'order_document_id' => $id,
                    'layout_version' => OrderDocumentLayout::VERSION, 'file_id' => $fileId, 'generated_at' => now(),
                    'context_snapshot' => json_encode($context, JSON_THROW_ON_ERROR), 'context_hash' => $contextHash]);
                DB::table('audit_logs')->insert(['id' => (string) Str::uuid7(), 'actor_role' => 'SYSTEM', 'action' => $document->state === 'READY' ? 'ORDER_DOCUMENT_LAYOUT_GENERATED' : 'ORDER_DOCUMENT_GENERATED',
                    'resource_type' => 'ORDER_DOCUMENT', 'resource_id' => $id, 'before' => '{}',
                    'after' => json_encode(['order_id' => $document->order_id, 'kind' => $document->kind, 'sha256' => $checksum, 'source_hash' => $document->source_hash, 'context_hash' => $contextHash, 'layout_version' => OrderDocumentLayout::VERSION], JSON_THROW_ON_ERROR),
                    'correlation_id' => (string) Str::uuid7(), 'succeeded' => true, 'created_at' => now(), 'updated_at' => now()]);
            });
        });
    }

    /** @return list<array<string, mixed>> */
    public function references(object $order, string $audience, bool $files = true): array
    {
        $documents = DB::table('order_documents')->where('order_id', $order->id)->get()->keyBy('kind');
        $prefix = strtolower($audience) === 'buyer' ? 'buyers' : strtolower($audience);
        $items = [];
        foreach (self::TITLES as $kind => $title) {
            $document = $documents->get($kind);
            $items[] = ['kind' => $kind, 'title' => $title, 'not_tax_invoice' => true, 'label' => 'Not a tax invoice',
                'availability' => $document->state ?? 'AFTER_ACCEPTANCE',
                'generated_at' => $document?->generated_at, 'checksum' => $document === null ? null : $this->file($document)?->checksum_sha256,
                'download_url' => $files && $document?->state === 'READY' ? url('/api/v1/'.$prefix.'/orders/'.$order->id.'/documents/'.$kind.'/download') : null];
        }

        return $items;
    }

    public function authorize(Request $request, string $orderId, string $kind = 'PURCHASE_ORDER'): object
    {
        $order = Str::isUuid($orderId) ? DB::table('orders')->where('id', $orderId)->first() : null;
        $allowed = $order !== null && ($request->user()->account_type === 'ADMIN'
            ? InvoiceAccess::canDownload($request->user(), 'ADMIN', $order)
            : app(ExportAccess::class)->allows($request->user(), $kind, $orderId));
        if ($order === null || ! isset(self::TITLES[$kind]) || ! $allowed) {
            throw new AuthenticationException('ORDER_DOCUMENT_UNAVAILABLE', 'This order document is unavailable to your current account.', 404);
        }

        return $order;
    }

    public function download(Request $request, string $orderId, string $kind): StreamedResponse
    {
        $this->authorize($request, $orderId, $kind);
        $document = DB::table('order_documents')->where('order_id', $orderId)->where('kind', $kind)->first();
        if ($document === null || $document->state !== 'READY') {
            throw new AuthenticationException('ORDER_DOCUMENT_NOT_READY', 'This document is not ready to download yet. Refresh its status.', 409);
        }
        $file = $this->file($document);
        $disk = $file === null ? null : (json_decode($file->metadata, true)['disk'] ?? null);
        if (! is_string($disk) || ! Storage::disk($disk)->exists($file->object_key)) {
            throw new AuthenticationException('ORDER_DOCUMENT_FILE_UNAVAILABLE', 'This document file is temporarily unavailable.', 503);
        }
        $bytes = Storage::disk($disk)->get($file->object_key);
        if (! is_string($bytes) || ! hash_equals($file->checksum_sha256, hash('sha256', $bytes))) {
            throw new AuthenticationException('ORDER_DOCUMENT_CHECKSUM_FAILED', 'This document could not be verified.', 409);
        }
        // A membership/assignment can change while private storage is being read.
        $this->authorize($request, $orderId, $kind);
        app(AuditRecorder::class)->account($request, 'ORDER_DOCUMENT_DOWNLOADED', 'ORDER_DOCUMENT', $document->id, after: ['order_id' => $orderId, 'kind' => $kind, 'sha256' => $file->checksum_sha256]);

        return response()->streamDownload(static function () use ($bytes): void {
            echo $bytes;
        }, $this->filename($document),
            ['Content-Type' => 'application/pdf', 'Cache-Control' => 'private, no-store', 'X-Content-Type-Options' => 'nosniff']);
    }

    private function filename(object $document): string
    {
        return 'materyalph-'.strtolower($document->kind).'-'.$document->order_id.'.pdf';
    }

    private function file(object $document): ?object
    {
        $fileId = DB::table('order_document_renditions')->where('order_document_id', $document->id)
            ->where('layout_version', OrderDocumentLayout::VERSION)->value('file_id') ?? $document->file_id;

        return DB::table('files')->where('id', $fileId)->where('visibility', 'PRIVATE')->where('scan_state', 'CLEAN')->first();
    }
}
