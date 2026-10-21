<?php

declare(strict_types=1);

use Illuminate\Contracts\Console\Kernel;
use Illuminate\Support\Facades\DB;

require '/app/services/api/vendor/autoload.php';
$app = require '/app/services/api/bootstrap/app.php';
$kernel = $app->make(Kernel::class);
$kernel->bootstrap();

if (! $app->environment('staging') || config('finance.live_commerce_enabled') || config('services.xendit.mode') !== 'TEST') {
    fwrite(STDERR, "The staging release command requires Staging and Xendit TEST with live commerce disabled.\n");
    exit(1);
}

// Only the API release step migrates. No runtime process modifies schema or seeds accounts.
$status = $kernel->call('migrate', ['--force' => true, '--no-interaction' => true]);
fwrite(STDOUT, $kernel->output());
if ($status !== 0) {
    exit($status);
}

// Seed required reference records only on an empty installation. Subsequent deploys preserve versions.
if (! DB::table('agreement_documents')->exists() && ! DB::table('users')->exists()) {
    $status = DB::transaction(function () use ($kernel): int {
        $result = $kernel->call('db:seed', ['--class' => 'Database\\Seeders\\SystemFoundationSeeder', '--force' => true, '--no-interaction' => true]);
        if ($result !== 0) {
            throw new RuntimeException('Initial staging reference-data setup failed.');
        }

        return $result;
    });
    fwrite(STDOUT, $kernel->output());
    if ($status !== 0) {
        exit($status);
    }
}

$bootstrapEmail = getenv('STAGING_BOOTSTRAP_ADMIN_EMAIL');
if (is_string($bootstrapEmail) && $bootstrapEmail !== ''
    && ! DB::table('admin_memberships')->exists()
    && ! DB::table('admin_invitations')->where('bootstrap', true)->exists()) {
    // Setting the optional variable explicitly requests the existing audited invitation flow.
    // No token, address or provider payload is returned in release logs.
    if ($kernel->call('materyalph:bootstrap-admin', ['email' => $bootstrapEmail, '--no-interaction' => true]) !== 0) {
        fwrite(STDERR, "Initial admin invitation failed. Check the staging bootstrap configuration.\n");
        exit(1);
    }
    fwrite(STDOUT, "The one-time staging admin invitation was queued.\n");
}

fwrite(STDOUT, "Staging schema release completed.\n");
