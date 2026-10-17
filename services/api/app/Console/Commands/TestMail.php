<?php

declare(strict_types=1);

namespace App\Console\Commands;

use App\Domain\Notifications\MailDeliveryException;
use App\Domain\Notifications\MailDeliveryPolicy;
use App\Domain\Notifications\MailProvider;
use App\Mail\MailTestMail;
use Illuminate\Console\Command;

final class TestMail extends Command
{
    protected $signature = 'materyalph:mail-test {--to= : Mailbox you control for this delivery test}';

    protected $description = 'Send one local SMTP delivery test without displaying credentials or message contents';

    public function handle(MailProvider $provider, MailDeliveryPolicy $policy): int
    {
        if (! app()->environment(['local', 'development', 'testing'])) {
            $this->error('Mail testing is available only in local development.');

            return self::FAILURE;
        }
        $recipient = $this->option('to');
        if (! is_string($recipient) || filter_var($recipient, FILTER_VALIDATE_EMAIL) === false) {
            $this->error('Provide --to with a valid mailbox you control.');

            return self::INVALID;
        }
        if (config('mail.default') !== 'smtp') {
            $this->error('The mail test requires MAIL_MAILER=smtp.');

            return self::FAILURE;
        }

        try {
            if (! $policy->allows(now()->toIso8601String())) {
                $this->error('Mail testing is unavailable before the configured activation time.');

                return self::FAILURE;
            }
            $provider->send($recipient, new MailTestMail);
        } catch (MailDeliveryException $exception) {
            $this->error($exception->errorCode.': '.$exception->getMessage());

            return self::FAILURE;
        }
        $this->info('SMTP accepted the test message. Check the recipient mailbox to confirm delivery.');

        return self::SUCCESS;
    }
}
