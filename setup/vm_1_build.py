#!/usr/bin/env python3
#
# Filename: vm_1_build.py
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
import subprocess

def run(cmd):
    print(" ".join(cmd))
    return subprocess.run(cmd, capture_output=True, check=True)

setup_dir = os.path.dirname(__file__)
vm_name = "Ubuntu-Viasat"

try:
    vm_list = run(["wsl.exe", "--list"])
    if vm_name in vm_list.stdout.decode('utf-16'):
        print("Importing source ...")
        os.chdir(setup_dir)
        vm_input_shim = run(["wsl.exe", "-d", vm_name, "-e", "cp", "-r", "../build", "/root"])
        print("Building shim ...")
        vm_build_shim = run(["wsl.exe", "-d", vm_name, "--cd", "/root/build", "-e", "bash", "build.sh" ])
        print("Exporting output ...")
        os.chdir(setup_dir)
        vm_output_shim = run(["wsl.exe", "-d", vm_name, "-e", "cp", "-r", "/root/build/output/", "../build"])

except subprocess.CalledProcessError as e:
    print(e.stdout.decode(), e.stderr.decode())
