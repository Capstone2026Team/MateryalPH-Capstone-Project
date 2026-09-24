<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Vendors\EvidenceContentValidator;
use Illuminate\Config\Repository;
use Illuminate\Container\Container;
use Illuminate\Http\UploadedFile;
use PHPUnit\Framework\TestCase;

final class EvidenceContentValidatorTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();
        $container = new Container;
        $container->instance('config', new Repository(['materyalph' => ['files' => ['max_document_kb' => 10240]]]));
        Container::setInstance($container);
    }

    protected function tearDown(): void
    {
        Container::setInstance(null);
        parent::tearDown();
    }

    public function test_technical_validation_accepts_supported_images_and_pdf(): void
    {
        foreach (['jpg', 'jpeg', 'png'] as $extension) {
            $file = UploadedFile::fake()->image('fictional.'.$extension, 32, 32);
            (new EvidenceContentValidator)->validate($file);
            self::assertGreaterThan(0, $file->getSize());
        }
        (new EvidenceContentValidator)->validate(UploadedFile::fake()->createWithContent('fictional.pdf', "%PDF-1.4\n1 0 obj << /Type /Catalog >> endobj\n%%EOF\n"));
        self::addToAssertionCount(1);
    }

    public function test_declared_mime_cannot_disagree_with_detected_content(): void
    {
        $png = UploadedFile::fake()->image('document.png', 32, 32);
        $this->expectException(AuthenticationException::class);
        (new EvidenceContentValidator)->validate(new UploadedFile($png->getRealPath(), 'document.png', 'application/pdf', null, true));
    }

    public function test_invalid_bytes_extensions_empty_oversize_and_active_pdf_are_rejected(): void
    {
        $png = UploadedFile::fake()->image('fictional.png', 32, 32)->getContent();
        $pdf = "%PDF-1.4\n1 0 obj << /Type /Catalog >> endobj\n%%EOF\n";
        foreach ([['fake.jpg', $pdf], ['fake.png', $pdf], ['fake.pdf', $png], ['fake.txt', $png], ['empty.pdf', ''], ['corrupt.pdf', '%PDF-1.4 incomplete'], ['active.pdf', str_replace('/Catalog', '/Catalog /JavaScript', $pdf)], ['large.pdf', '%PDF-1.4'.str_repeat('x', 10 * 1024 * 1024)]] as [$name, $bytes]) {
            try {
                (new EvidenceContentValidator)->validate(UploadedFile::fake()->createWithContent($name, $bytes));
                self::fail('An invalid file passed technical validation.');
            } catch (AuthenticationException $exception) {
                self::assertSame('FILE_VALIDATION_FAILED', $exception->errorCode);
            }
        }
    }
}
