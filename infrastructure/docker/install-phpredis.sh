#!/bin/sh
set -eu

# Match the release selected by PECL in the failed builds, without its download service.
# Upstream: https://github.com/phpredis/phpredis/releases/tag/6.3.0
version=6.3.0
sha256=cb8f81df1a275599e4f8ddcfec7e1f65ed1953e6f5673649149fd680ebff4cad
build_dir=$(mktemp -d)
trap 'rm -rf "$build_dir"' EXIT

curl --fail --silent --show-error --location \
    --proto '=https' --proto-redir '=https' --tlsv1.2 \
    --connect-timeout 15 --max-time 60 \
    --retry 4 --retry-all-errors --retry-delay 2 --retry-max-time 180 \
    --output "$build_dir/redis.tar.gz" \
    "https://codeload.github.com/phpredis/phpredis/tar.gz/refs/tags/$version"
printf '%s  %s\n' "$sha256" "$build_dir/redis.tar.gz" | sha256sum -c -

mkdir "$build_dir/source"
tar -xzf "$build_dir/redis.tar.gz" --strip-components=1 -C "$build_dir/source"
docker-php-ext-install "$build_dir/source"
php -r 'exit(extension_loaded("redis") && phpversion("redis") === $argv[1] ? 0 : 1);' "$version"
