#!/usr/bin/env python3
#
# Filename: vm_0_setup.py
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
import hashlib
import os
import platform
import subprocess
from urllib.request import urlretrieve

# Python <3.11
# https://stackoverflow.com/questions/22058048/hashing-a-file-in-python
def sha256sum(filename):
    h  = hashlib.sha256()
    b  = bytearray(128*1024)
    mv = memoryview(b)
    with open(filename, 'rb', buffering=0) as f:
        while n := f.readinto(mv):
            h.update(mv[:n])
    return h.hexdigest()

def run(cmd):
    print(" ".join(cmd))
    return subprocess.run(cmd, capture_output=True, check=True)

setup_dir = os.path.dirname(__file__)
build_dir = os.path.join(setup_dir, "..", "build")
temp_dir = os.path.join(setup_dir, "..", "temp")
if not os.path.exists(temp_dir):
    os.makedirs(temp_dir)

url = "https://cloud-images.ubuntu.com/wsl/noble/20240905/ubuntu-noble-wsl-amd64-24.04lts.rootfs.tar.gz"
hash_expect = "a66c7d1db2a64e727d3cd13767ad8c543290abcc1311f2ae0e46dfc49c0c6277"
filename = os.path.join(temp_dir, "ubuntu-viasat.rootfs.tar.gz")
vm_name = "Ubuntu-Viasat"
vm_path = os.path.join(temp_dir, vm_name.lower())

# https://superuser.com/questions/1515246/how-to-add-second-wsl2-ubuntu-distro-fresh-install
win_version_expect = "10.0.18305"
win_version = platform.version()
if int(win_version.split('.')[2]) < int(win_version_expect.split('.')[2]):
    print("error: Windows Version out of range")
    print("expect: >= " + win_version_expect)
    print("actual:    " + win_version)
    quit()

try:
    vm_list = run(["wsl.exe", "--list"])
    if not vm_name in vm_list.stdout.decode('utf-16'):
        if not os.path.exists(filename):
            print("Downloading Ubuntu image...")
            path, headers = urlretrieve(url, filename)
            for name, value in headers.items():
                print(name, value)

        print("Verifying Ubuntu image...")
        hash_actual = sha256sum(filename)
        if hash_actual != hash_expect:
            print("error: Hash mismatch")
            print("expect: " + hash_expect)
            print("actual: " + hash_actual)
            quit()

        print("Importing Ubuntu image...")
        vm_import = run(["wsl.exe", "--import", vm_name, vm_path, filename])

except subprocess.CalledProcessError as e:
    print(e.stdout.decode(), e.stderr.decode())
