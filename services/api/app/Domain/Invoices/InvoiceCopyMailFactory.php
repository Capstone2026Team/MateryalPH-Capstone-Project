<?php

declare(strict_types=1);

namespace App\Domain\Invoices;

use App\Domain\Catalog\CatalogFileStore;
use App\Mail\InvoiceCopyMail;
use App\Models\User;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use RuntimeException;

/** Resolves the immutable sent version in the worker; never emails a draft or a storage URL. */
final class InvoiceCopyMailFactory
{
    public function make(User $buyer, string $recordId): ?InvoiceCopyMail
    {
        $record = DB::table('invoice_records')->where('id', $recordId)->first();
        $order = $record === null ? null : DB::table('orders')->where('id', $record->order_id)->first();
        if ($order === null || ! InvoiceAccess::canDownload($buyer, 'BUYER', $order)) {
            return null;
        }
        $file = DB::table('files')->where('id', $record->file_id)->where('owner_type', 'ORDER')->where('owner_id', $order->id)
            ->where('visibility', 'PRIVATE')->where('scan_state', 'CLEAN')->first();
        $extension = match ($file?->content_type) {
            'application/pdf' => 'pdf', 'image/jpeg' => 'jpg', 'image/png' => 'png', default => null,
        };
        if ($file === null || $extension === null) {
            return null;
        }
        $metadata = json_decode((string) $file->metadata, true) ?: [];
        $disk = is_string($metadata['disk'] ?? null) ? $metadata['disk'] : app(CatalogFileStore::class)->privateDisk();
        $stream = Storage::disk($disk)->readStream((string) $file->object_key);
        if (! is_resource($stream)) {
            throw new RuntimeException('The invoice attachment is temporarily unavailable.');
        }
        try {
            $bytes = stream_get_contents($stream, (int) $file->byte_size + 1);
        } finally {
            fclose($stream);
        }
        if (! is_string($bytes) || strlen($bytes) !== (int) $file->byte_size
            || ! hash_equals((string) $record->content_hash, hash('sha256', $bytes))
            || ! hash_equals((string) $file->checksum_sha256, hash('sha256', $bytes))) {
            throw new RuntimeException('The invoice attachment failed its integrity check.');
        }
        $snapshot = json_decode((string) $record->commercial_snapshot, true) ?: [];
        $tax = json_decode((string) $record->tax_breakdown, true) ?: [];
        $filename = 'invoice-'.Str::slug((string) $record->invoice_number_display).'.'.$extension;

        return new InvoiceCopyMail([
            'order_reference' => (string) $order->reference,
            'document_type' => $record->invoice_type === 'VENDOR_ADJUSTMENT_DOCUMENT' ? 'Adjustment document' : 'Sales invoice',
            'invoice_number' => (string) $record->invoice_number_display,
            'issuer' => (string) $record->issuer,
            'billing_name' => $snapshot['billing_details']['billing_name'] ?? null,
            'invoice_date' => CarbonImmutable::parse((string) $record->issued_on)->format('M j, Y'),
            'sent_at' => CarbonImmutable::parse((string) $record->created_at)->setTimezone('Asia/Manila')->format('M j, Y · g:i A').' (PHT)',
            'total' => self::money((int) $record->amount_centavos),
            'vat' => isset($tax['vat_centavos']) ? self::money((int) $tax['vat_centavos']) : null,
            'source' => match ($record->source_system) {
                'REGISTERED_CAS' => 'Registered CAS / accounting system', 'BIR_EIS' => 'BIR EIS',
                'LOOSE_LEAF_OR_PRINTED' => 'Loose-leaf or printed (ATP)', default => 'Other registered process',
            },
            'method' => Str::ucfirst(strtolower((string) $record->invoicing_method)),
            'is_demo' => $record->environment === 'TEST' || $record->document_origin === 'DEMO_SAMPLE',
            'is_correction' => $record->amends_invoice_record_id !== null,
            'filename' => $filename,
            'file_size' => number_format((int) ceil((int) $file->byte_size / 1024)).' KB',
            'file_type' => strtoupper($extension),
        ], $bytes, (string) $file->content_type);
    }

    private static function money(int $centavos): string
    {
        return '₱'.number_format(intdiv($centavos, 100), 0, '.', ',').'.'.str_pad((string) ($centavos % 100), 2, '0', STR_PAD_LEFT);
    }
}
