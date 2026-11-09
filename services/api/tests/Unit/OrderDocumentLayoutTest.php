<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Reporting\DocumentRenderer;
use App\Domain\Reporting\OrderDocumentLayout;
use Tests\TestCase;

final class OrderDocumentLayoutTest extends TestCase
{
    /** @return array<string, mixed> */
    private function snapshot(): array
    {
        return ['title' => 'MateryalPH Purchase Order', 'generated_at' => '2026-11-04 20:52:12', 'source_hash' => str_repeat('a', 64), 'rows' => [
            ['Order', 'SAMPLE-ORDER-1'], ['Order status', 'COMPLETED'], ['Commercial status', 'Accepted'],
            ['Materials gross PHP', '285.50'], ['Commercial total PHP', '285.50'], ['Materials vat PHP', '30.59'],
            ['Item', 'Rerolled steel bar', '10 mm / 6 m', 'Piece'], ['Quantity', '1.2500', 'Unit price PHP', '285.50'],
        ]];
    }

    public function test_layout_reuses_frozen_values_without_recalculating_or_modifying_the_snapshot(): void
    {
        $snapshot = $this->snapshot();
        $snapshot['captured_at'] = '2026-11-04 19:00:00';
        $before = serialize($snapshot);
        $layout = OrderDocumentLayout::present($snapshot);
        self::assertSame('285.50', $layout['amounts']['commercial total php']['value']);
        self::assertSame('30.59', $layout['amounts']['materials vat php']['value']);
        self::assertSame('1.25', $layout['items'][0]['quantity']);
        self::assertSame('10 mm / 6 m', $layout['items'][0]['variant']);
        self::assertSame('285.50', $layout['items'][0]['price']);
        self::assertSame('04 Nov 2026, 07:00 PM', $layout['captured']);
        self::assertSame('123,456,789,012,345,678.99', OrderDocumentLayout::money('123456789012345678.99'));
        self::assertSame($before, serialize($snapshot));
    }

    public function test_payment_layout_distinguishes_vendor_records_and_provider_amounts_and_escapes_content(): void
    {
        $snapshot = $this->snapshot();
        $snapshot['title'] = 'MateryalPH payment confirmation';
        $snapshot['rows'][] = ['Payment', 'SAMPLE-PAYMENT-1', 'FULL_ORDER_PAYMENT', '293.05', '2026-10-02 10:26:43+00', 'XENDIT_TEST'];
        $snapshot['rows'][] = ['Vendor-recorded physical payment', 'SAMPLE-PHYSICAL-1', '100.00', '2026-10-02 11:00:00+00', 'PHYSICAL_PAYMENT_RECORDED'];
        $snapshot['rows'][] = ['Unrecognized source field', '<script>alert(1)</script>'];
        $layout = OrderDocumentLayout::present($snapshot);
        self::assertSame('293.05', $layout['payments'][0]['amount']);
        self::assertSame('285.50', $layout['amounts']['commercial total php']['value']);
        self::assertSame('02 Oct 2026, 06:26 PM', $layout['payments'][0]['date']);
        self::assertSame('TEST provider record', $layout['payments'][0]['evidence']);
        self::assertTrue($layout['payments'][1]['physical']);
        self::assertStringStartsWith('Vendor-recorded', $layout['payments'][1]['evidence']);
        $html = view('reports.order-document', ['document' => $snapshot, 'layout' => $layout])->render();
        self::assertStringContainsString('&lt;script&gt;alert(1)&lt;/script&gt;', $html);
        self::assertStringNotContainsString('<script>', $html);
    }

    public function test_purchase_order_displays_buyer_contacts_and_methods_with_escaped_party_details(): void
    {
        $snapshot = $this->snapshot();
        $snapshot['order_details'] = ['captured_at' => '2026-11-04T12:52:12+00:00',
            'buyer' => ['name' => '<script>Sample Buyer</script>', 'billing_name' => '', 'address' => '', 'email' => 'buyer@example.invalid', 'phone' => '+639170000001'],
            'vendor' => ['name' => 'Sample Vendor', 'legal_name' => 'Sample Vendor', 'address' => 'Sample address', 'email' => '', 'phone' => ''],
            'payment_method' => 'Cash on delivery', 'fulfillment_method' => 'Site Delivery', 'fulfillment_address' => 'Sample delivery address'];
        $layout = OrderDocumentLayout::present($snapshot);
        $html = view('reports.order-document', ['document' => $snapshot, 'layout' => $layout])->render();
        foreach (['buyer@example.invalid', '+639170000001', 'Cash on delivery', 'Site Delivery', 'Sample delivery address', '&lt;script&gt;Sample Buyer&lt;/script&gt;'] as $expected) {
            self::assertStringContainsString($expected, $html);
        }
        self::assertStringNotContainsString('<script>', $html);
        $snapshot['order_details']['buyer']['phone'] = '';
        $html = view('reports.order-document', ['document' => $snapshot, 'layout' => OrderDocumentLayout::present($snapshot)])->render();
        self::assertStringContainsString('Mobile number not provided', $html);
    }

    public function test_long_order_pdf_paginates_without_dropping_items_or_required_notices(): void
    {
        $snapshot = $this->snapshot();
        $snapshot['rows'] = array_slice($snapshot['rows'], 0, 6);
        for ($index = 0; $index < 70; $index++) {
            $snapshot['rows'][] = ['Item', sprintf('MATERIAL-%03d', $index), str_repeat('Long material specification ', 4), 'Bundle'];
            $snapshot['rows'][] = ['Quantity', '100.0000', 'Unit price PHP', '1000000.50'];
        }
        $pdf = app(DocumentRenderer::class)->render($snapshot, 'PDF');
        self::assertStringStartsWith('%PDF-', $pdf);
        self::assertGreaterThan(1, preg_match_all('~/Type\s*/Page\b~', $pdf));
        preg_match_all('~stream\n(.*?)\nendstream~s', $pdf, $streams);
        $contents = '';
        foreach ($streams[1] as $stream) {
            $contents .= @gzuncompress($stream) ?: $stream;
        }
        foreach (['MATERIAL-000', 'MATERIAL-069', 'NOT A TAX INVOICE'] as $expected) {
            self::assertStringContainsString(mb_convert_encoding($expected, 'UTF-16BE', 'UTF-8'), $contents);
        }
    }
}
