<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Mail\FinanceNoticeMail;
use App\Mail\OrderNoticeMail;
use App\Mail\ProductComplianceNoticeMail;
use App\Mail\SupportNoticeMail;
use App\Mail\VendorInventoryNoticeMail;
use App\Mail\VendorOnboardingNoticeMail;
use Illuminate\Mail\Mailable;
use PHPUnit\Framework\Attributes\DataProvider;
use Tests\TestCase;

final class MailPresentationTest extends TestCase
{
    /** @param class-string<Mailable> $class
     * @param  list<string>  $arguments
     */
    #[DataProvider('purposeEmails')]
    public function test_email_content_is_escaped_and_the_action_describes_its_purpose(string $class, array $arguments, string $label): void
    {
        $mail = new $class(...$arguments);
        $html = $mail->with('noticeUrl', 'https://portal.example.test/purpose')->render();
        self::assertStringContainsString($label, $html);
        self::assertStringContainsString('https://portal.example.test/purpose', $html);
        self::assertStringNotContainsString('Open notification', $html);
        self::assertStringNotContainsString('<script>', $html);
        self::assertStringContainsString('&lt;script&gt;', $html);
        self::assertStringContainsString('Sign in to your MateryalPH account', $html);
    }

    public static function purposeEmails(): array
    {
        $body = 'Review the update <script>sample</script>';

        return [
            'order' => [OrderNoticeMail::class, ['Order accepted', $body], 'View order'],
            'support' => [SupportNoticeMail::class, ['Support request update', $body, 'VENDOR'], 'View support request'],
            'finance' => [FinanceNoticeMail::class, ['Statement available', $body], 'View finance details'],
            'inventory' => [VendorInventoryNoticeMail::class, ['Stock review', $body], 'Review inventory'],
            'onboarding' => [VendorOnboardingNoticeMail::class, [$body], 'Review store setup'],
            'compliance' => [ProductComplianceNoticeMail::class, [$body], 'Review products'],
        ];
    }
}
