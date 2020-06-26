#!/bin/sh

cp /secrets/tls.crt /usr/local/share/ca-certificates
update-ca-certificates
registry serve /etc/docker/registry/config.yml
