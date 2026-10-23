#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
test_dir=$(mktemp -d)
trap 'rm -rf "$test_dir"' EXIT
mkdir "$test_dir/bin"
export INSTALLER_TEST_MARKER="$test_dir/compiled"

# Exercise failures before extraction/compilation without contacting any provider.
cat > "$test_dir/bin/curl" <<'SH'
#!/bin/sh
set -eu
if [ "$INSTALLER_TEST_FAILURE" = unavailable ]; then
    echo 'simulated download failure after retries' >&2
    exit 22
fi
while [ "$#" -gt 0 ]; do
    if [ "$1" = --output ]; then
        printf 'corrupted source archive\n' > "$2"
        exit 0
    fi
    shift
done
exit 1
SH
cat > "$test_dir/bin/docker-php-ext-install" <<'SH'
#!/bin/sh
touch "$INSTALLER_TEST_MARKER"
exit 99
SH
chmod +x "$test_dir/bin/curl" "$test_dir/bin/docker-php-ext-install"
export PATH="$test_dir/bin:$PATH"

for failure in corrupt unavailable; do
    export INSTALLER_TEST_FAILURE="$failure"
    if sh "$repo_root/infrastructure/docker/install-phpredis.sh" > "$test_dir/$failure.log" 2>&1; then
        echo "Installer accepted $failure source." >&2
        exit 1
    fi
    test ! -e "$INSTALLER_TEST_MARKER"
done
if ! grep -q 'FAILED' "$test_dir/corrupt.log" \
    || ! grep -q 'simulated download failure after retries' "$test_dir/unavailable.log"; then
    cat "$test_dir/corrupt.log" "$test_dir/unavailable.log" >&2
    exit 1
fi
echo 'Redis installer: corrupt archive and exhausted download fail before compilation.'
