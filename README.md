# Docker image for nsd-checkzone

[![Drone CI/CD](https://ci.rspamd.com/api/badges/citrin/checkzone-docker/status.svg)](https://ci.rspamd.com/citrin/checkzone-docker)
[![Docker Image Size](https://img.shields.io/microbadger/image-size/citrinru/checkzone.svg)](https://hub.docker.com/r/citrinru/checkzone/)

Small Docker image for [nsd-checkzone(8)](https://www.nlnetlabs.nl/documentation/nsd/nsd-checkzone/) - DNS zone file syntax checker.

Based on [Alpine](https://alpinelinux.org/), but contains only nsd-checkzone, busybox and required dynamic libraries.
