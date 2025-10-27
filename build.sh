#!/usr/bin/env bash
set -e
docker system prune --volumes -af
docker build --no-cache --progress=plain -t shim . 2>&1 | tee logs/docker-build.log
docker create --name shim shim 
docker cp shim:/shim/_viasat/INSTALL/shimx64.efi .
docker cp shim:/shim/_viasat/LOG/shim-build.log logs/.
docker rm shim
