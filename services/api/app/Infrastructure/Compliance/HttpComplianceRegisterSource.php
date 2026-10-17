<?php

declare(strict_types=1);

namespace App\Infrastructure\Compliance;

use App\Domain\Compliance\ComplianceRegisterSource;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Contracts\Config\Repository;
use Illuminate\Http\Client\Factory;
use Throwable;

/**
 * Fetches a register snapshot from an HTTPS URL configured per register kind,
 * for example an export DTI-BPS publishes or authorizes. Only allow-listed
 * hosts are contacted, redirects are not followed and the body is size-bounded.
 * The URL is configuration, never user input, and is not logged in full.
 */
final class HttpComplianceRegisterSource implements ComplianceRegisterSource
{
    public function __construct(private readonly Repository $config, private readonly Factory $http) {}

    public function configured(string $kind): bool
    {
        return $this->url($kind) !== null;
    }

    public function fetch(string $kind): array
    {
        $url = $this->url($kind);
        if ($url === null) {
            throw new AuthenticationException('REGISTER_FEED_NOT_CONFIGURED', 'No authorized register feed is configured for this register.', 409);
        }
        $maxBytes = (int) $this->config->get('materyalph.compliance_registers.max_bytes', 31_457_280);
        $temporary = tempnam(sys_get_temp_dir(), 'compliance-register-');
        if ($temporary === false) {
            throw new AuthenticationException('REGISTER_FEED_UNAVAILABLE', 'The register feed could not be stored temporarily.', 503);
        }
        try {
            $response = $this->http->withOptions(['allow_redirects' => false])->timeout(60)->connectTimeout(10)
                ->accept('text/csv, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')->get($url);
            $body = $response->body();
            if (! $response->successful() || $body === '' || strlen($body) > $maxBytes || (int) $response->header('Content-Length') > $maxBytes) {
                throw new \RuntimeException('Register feed responded with status '.$response->status().'.');
            }
            if (file_put_contents($temporary, $body) === false) {
                throw new \RuntimeException('Register feed could not be stored.');
            }
            $type = strtolower((string) $response->header('Content-Type'));
            $extension = str_contains($type, 'spreadsheetml') || str_ends_with(strtolower((string) parse_url($url, PHP_URL_PATH)), '.xlsx') ? 'xlsx' : 'csv';
            $named = $temporary.'.'.$extension;
            if (! rename($temporary, $named)) {
                throw new \RuntimeException('Register feed could not be prepared.');
            }

            return ['path' => $named, 'extension' => $extension, 'source_reference' => 'Authorized feed '.parse_url($url, PHP_URL_HOST).' ('.$kind.')'];
        } catch (Throwable $exception) {
            @unlink($temporary);
            throw $exception instanceof AuthenticationException ? $exception
                : new AuthenticationException('REGISTER_FEED_UNAVAILABLE', 'The register feed could not be downloaded. The active snapshot stays in use.', 503);
        }
    }

    private function url(string $kind): ?string
    {
        $url = trim((string) $this->config->get('materyalph.compliance_registers.feeds.'.$kind, ''));
        if ($url === '' || parse_url($url, PHP_URL_SCHEME) !== 'https') {
            return null;
        }
        $hosts = array_filter(array_map('trim', explode(',', strtolower((string) $this->config->get('materyalph.compliance_registers.allowed_hosts', '')))));

        return in_array(strtolower((string) parse_url($url, PHP_URL_HOST)), $hosts, true) ? $url : null;
    }
}
