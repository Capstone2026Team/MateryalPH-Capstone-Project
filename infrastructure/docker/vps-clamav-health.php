<?php

declare(strict_types=1);

require '/app/services/api/vendor/autoload.php';

try {
    (new App\Infrastructure\Files\ClamAvDaemonFileMalwareScanner('tcp://127.0.0.1:3310', 3))->assertAvailable();
    exit(0);
} catch (Throwable) {
    exit(1);
}
