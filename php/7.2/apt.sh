#!/bin/bash

echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup
echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache

DEBIAN_FRONTEND=noninteractive
  dpkg-reconfigure -f noninteractive tzdata \
  && apt-get update \
  && apt-get upgrade -y \
  &&  DEBIAN_FRONTEND=noninteractive apt-get install -yqq \
      sudo \
      unzip \
      git \
      --no-install-recommends
