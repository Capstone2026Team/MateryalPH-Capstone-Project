<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Reporting\DocumentRenderer;
use PHPUnit\Framework\TestCase;

final class TabularDocumentRendererTest extends TestCase
{
    public function test_full_audit_limit_is_paginated_without_dropping_the_first_or_last_row(): void
    {
        $rows = [['Recorded (Manila)', 'Actor', 'Role', 'Action', 'Resource', 'Resource ID', 'Organization', 'Result', 'Reason', 'Correlation ID']];
        for ($i = 0; $i < 5000; $i++) {
            $rows[] = ['2026-10-27 12:00:00', 'Vendor ...580dbb', 'OWNER', 'PRODUCT_COMPLIANCE_EVIDENCE_UPLOADED', 'COMPLIANCE_EVIDENCE',
                sprintf('ROW-%04d', $i), 'Sample construction supply', 'Succeeded', "Review completed\nUnicode: ₱ and ñ", '01a17c22-0dae-72f2-9102-afedc8afb20a'];
        }
        $pdf = (new DocumentRenderer)->render(['title' => 'Audit log', 'generated_at' => '2026-10-27 12:00:00', 'source_hash' => str_repeat('a', 64), 'rows' => $rows], 'PDF');
        self::assertStringStartsWith('%PDF-', $pdf);
        self::assertGreaterThan(1, preg_match_all('~/Type\s*/Page\b~', $pdf));
        // CPDF uses LF delimiters; a CR at the end of compressed bytes is part of the stream.
        preg_match_all('~stream\n(.*?)\nendstream~s', $pdf, $streams);
        $contents = '';
        foreach ($streams[1] as $stream) {
            $contents .= @gzuncompress($stream) ?: $stream;
        }
        foreach (['ROW-0000', 'ROW-4999', 'Unicode: ₱ and ñ'] as $expected) {
            self::assertStringContainsString(mb_convert_encoding($expected, 'UTF-16BE', 'UTF-8'), $contents);
        }
        self::assertSame(5000, substr_count($contents, mb_convert_encoding('ROW-', 'UTF-16BE', 'UTF-8')));
    }
}
