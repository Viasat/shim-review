#!/usr/bin/env bash -e
#
# Filename: build.sh
# Classification: Commercial-In-Confidence
# Copyright © 2024 Viasat UK
#
# All rights reserved
# The information in this software is subject to change without notice and
# should not be construed as a commitment by Viasat UK.
#
# Viasat Proprietary
# The Proprietary information provided herein is proprietary to Viasat UK and
# must be protected from further distribution and use.  Disclosure to others,
# use or copying without express written authorisation of Viasat UK, is strictly
# prohibited.
#
# $ProjectSpecificAdditionalRequirements$
#
bash build_shim.sh | tee build_shim.log
cp build_shim.log output/
