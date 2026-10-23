#!/usr/bin/env bash
# Run only on the confirmed fresh Ubuntu VPS, over verified operator-key SSH.
set -euo pipefail
umask 077
[[ "$(id -u)" = 0 ]] || { echo 'Run through the protected administrator.' >&2; exit 1; }
source /etc/os-release
[[ "$ID" = ubuntu && "$VERSION_ID" = 24.04 ]] || { echo 'Ubuntu 24.04 LTS is required.' >&2; exit 1; }

if [[ "${1:-}" = secure-ssh ]]; then
    # Invoke only after a second, non-root key-authenticated session has succeeded.
    id materyalph >/dev/null
    test -s /home/materyalph/.ssh/authorized_keys
    cat > /etc/ssh/sshd_config.d/00-materyalph.conf <<'SSH'
PubkeyAuthentication yes
PasswordAuthentication no
KbdInteractiveAuthentication no
PermitRootLogin prohibit-password
SSH
    /usr/sbin/sshd -t
    systemctl reload ssh
    /usr/sbin/sshd -T | awk '/^(passwordauthentication|kbdinteractiveauthentication|pubkeyauthentication|permitrootlogin) /'
    exit
fi

export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq ca-certificates curl python3 util-linux sudo fail2ban unattended-upgrades
if ! command -v docker >/dev/null; then
    install -m 0755 -d /etc/apt/keyrings
    curl --fail --silent --show-error --location https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    chmod 0644 /etc/apt/keyrings/docker.asc
    cat > /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: noble
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
    apt-get update -qq
    apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi
systemctl enable --now docker fail2ban

if ! id materyalph >/dev/null 2>&1; then
    adduser --disabled-password --gecos '' materyalph
    install -d -m 0700 -o materyalph -g materyalph /home/materyalph/.ssh
    install -m 0600 -o materyalph -g materyalph /root/.ssh/authorized_keys /home/materyalph/.ssh/authorized_keys
fi
test -s /home/materyalph/.ssh/authorized_keys
# This is the authorized deployment administrator, with root-equivalent Docker/sudo access.
printf 'materyalph ALL=(ALL:ALL) NOPASSWD:ALL\n' > /etc/sudoers.d/materyalph
chmod 0440 /etc/sudoers.d/materyalph
visudo -cf /etc/sudoers.d/materyalph
install -d -m 0700 /srv/materyalph /srv/materyalph/private /srv/materyalph/recovery /srv/materyalph/releases
cat > /etc/apt/apt.conf.d/20auto-upgrades <<'UPDATES'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
UPDATES
cat > /etc/apt/apt.conf.d/52materyalph-security <<'UPDATES'
Unattended-Upgrade::Automatic-Reboot "false";
UPDATES
docker --version
docker compose version
printf 'Bootstrap complete. Verify a second SSH session as materyalph before secure-ssh.\n'
