# Caddy JOSE security backport

`go-jose-v3-rsa-bounds.patch` backports the RSA public/private JWK validation
from [go-jose v4.1.6](https://github.com/go-jose/go-jose/releases/tag/v4.1.6),
specifically upstream commit
[`a0111f82742fa92bceec9ede40845e73319e6230`](https://github.com/go-jose/go-jose/commit/a0111f82742fa92bceec9ede40845e73319e6230).
The original source retains its Apache 2.0 copyright and license headers.

The [CVE-2026-116587 advisory](https://github.com/go-jose/go-jose/security/advisories/GHSA-mgcc-cww5-fp2q)
lists v3 through 3.0.5 as affected, with no patched v3 release. Standard Caddy
2.11.7 modules still use it through Smallstep. Updating only go-jose/v4 leaves
that vulnerable code in the binary.

The builder downloads checksum-verified v3.0.5 through Go modules, copies it to
`/opt/go-jose-v3`, applies this patch without fuzzy matching, and runs the
regression tests before xcaddy links that local replacement. The patch rejects
RSA moduli above 4096 bits and rejects inconsistent or oversized primes before
`crypto/rsa.PrivateKey.Validate`, matching upstream's default size limit and
consistency checks. Both standalone JWK and JWKS parsing are tested, alongside
valid public/private RSA round trips. Caddy's separate go-jose/v4 dependency is
pinned to upstream v4.1.6.

Patch files must retain LF line endings. The repository's `.gitattributes`
enforces this for Windows checkouts and `git archive` release exports; with
`core.autocrlf=true`, an unmarked patch is exported with CRLF context and
`git apply --check` fails against the downloaded Linux source. The packaging
tests exercise that Windows archive setting. Commit the attribute rule and
obtain CI acceptance on the new staging commit before rerunning the release;
packaging exports the selected commit, so a working-tree edit alone is not used.

The v3 replacement is local source, not an upstream fixed version. Go build
metadata records `github.com/go-jose/go-jose/v3 v3.0.5 => /opt/go-jose-v3`;
version-only scanners cannot establish its patch status. The checked-in patch
and mandatory build-time tests are the evidence for this dependency. Trivy
continues to scan the resulting image with HIGH/CRITICAL findings fatal; no
ignore entries or severity changes are added.

Remove the local replacement and its tests when upstream Caddy/Smallstep uses
a patched supported JOSE release throughout. Revalidate Caddy configuration,
the standard module list, and the exact runtime image with Trivy whenever
updating these dependencies.
