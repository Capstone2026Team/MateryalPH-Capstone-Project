<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Http\Requests\Vendor\VendorDocumentUploadRequest;
use Illuminate\Http\UploadedFile;
use Illuminate\Translation\ArrayLoader;
use Illuminate\Translation\Translator;
use Illuminate\Validation\Factory;
use PHPUnit\Framework\TestCase;

final class VendorDocumentUploadRequestTest extends TestCase
{
    public function test_multipart_metadata_is_normalized_and_validated(): void
    {
        $validator = new Factory(new Translator(new ArrayLoader, 'en'));
        foreach (['{}' => true, '{"document_number":"TEST-123"}' => true,
            'broken' => false, '[]' => false, '{"nested":{"value":"invalid"}}' => false,
            '{"value":"'.str_repeat('a', 256).'"}' => false, str_repeat('a', 65537) => false] as $json => $valid) {
            $request = VendorDocumentUploadRequest::create('/', 'POST', [], [], [
                'file' => UploadedFile::fake()->createWithContent('registration.pdf', '%PDF-1.4 test'),
                'metadata' => UploadedFile::fake()->createWithContent('blob', $json),
            ]);
            (new \ReflectionMethod($request, 'prepareForValidation'))->invoke($request);
            $this->assertSame($valid, $validator->make($request->all(), [
                'metadata' => $request->rules()['metadata'],
                'metadata.*' => $request->rules()['metadata.*'],
            ])->passes());
            if ($valid) {
                $this->assertSame(json_decode($json, true), $request->all()['metadata']);
                $this->assertFalse($request->hasFile('metadata'));
                $this->assertTrue($request->hasFile('file'));
                $this->assertSame('registration.pdf', $request->file('file')->getClientOriginalName());
            }
        }
    }
}
