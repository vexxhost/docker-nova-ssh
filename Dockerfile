# syntax=docker/dockerfile:1.4

ARG FROM

FROM ${FROM}
RUN <<EOF
  set -xe
  apt-get update
  apt-get install -y --no-install-recommends \
    openssh-server \
    openssh-client
  apt-get clean
  rm -rf /var/lib/apt/lists/*
EOF
RUN <<EOF
  groupadd -g 42424 nova
  useradd -r -u 42424 -g nova -d /var/lib/nova -c "Nova user" nova
  chown -R nova: /etc/ssh
  mkdir /var/run/sshd
  chmod 0755 /var/run/sshd
EOF
