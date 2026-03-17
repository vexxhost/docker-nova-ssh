# SPDX-FileCopyrightText: © 2025 VEXXHOST, Inc.
# SPDX-License-Identifier: GPL-3.0-or-later

FROM ubuntu:24.04@sha256:d1e2e92c075e5ca139d51a140fff46f84315c0fdce203eab2807c7e495eff4f9
RUN groupadd -g 42424 nova && \
    useradd -u 42424 -g 42424 -M -d /var/lib/nova -s /bin/bash -c "Nova User" nova && \
    mkdir -p /etc/nova /var/log/nova /var/lib/nova /var/cache/nova && \
    chown -Rv nova:nova /etc/nova /var/log/nova /var/lib/nova /var/cache/nova
RUN apt-get update -qq && \
    apt-get install -qq -y --no-install-recommends \
        iproute2 \
        openssh-server \
        openssh-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN chown -R nova: /etc/ssh && \
    mkdir /var/run/sshd && \
    chmod 0755 /var/run/sshd
COPY <<EOF /etc/ssh/sshd_config.d/00-hardening.conf
Ciphers aes256-ctr,aes192-ctr
MACs hmac-sha2-512,hmac-sha2-256
KexAlgorithms diffie-hellman-group-exchange-sha256
HostKeyAlgorithms ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521
MaxAuthTries 3
EOF
