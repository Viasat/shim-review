#!/usr/bin/env python3
#
# Filename: vm_2_clean.py
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
import os
import shutil
import subprocess

current_dir = os.path.dirname(__file__)
temp_dir = os.path.join(current_dir, "..", "temp")
vm_name = "Ubuntu-Viasat"

try:
    vm_remove = subprocess.run(["wsl.exe", "--unregister", vm_name], check=True)
except subprocess.CalledProcessError as e:
    print(e.stdout.decode(), e.stderr.decode())

shutil.rmtree(temp_dir)
