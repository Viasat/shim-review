#!/usr/bin/env bash -e
#
# Filename: build_shim.sh
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
build_dir="$(dirname "${BASH_SOURCE}")"
output_dir="${build_dir}/output"
redhat_dir="${build_dir}/_redhat"
viasat_dir="${build_dir}/_viasat"
# See also: DATA_DIR in CMakeLists.txt
data_dir="${build_dir}/data"

packages=(
    "bsdmainutils=12.1.8"
    "cmake=3.28.3-1build7"
    "dos2unix=7.5.1-1"
    "gcc=4:13.2.0-7ubuntu1"
    "g++=4:13.2.0-7ubuntu1"
    "git=1:2.43.0-1ubuntu7.2"
    "make=4.3-4.1build2"
    "pesign=116-7"
    "wget=1.21.4-1ubuntu4.1"
)

echo "Checking build environment ..."
release_expect="Ubuntu 24.04 LTS" 
release="$(lsb_release -d | cut -d':' -f2 | xargs)"
if [[ ! ${release} =~ ${release_expect} ]] ; then
    echo "error: Ubuntu version mismatch, expected '${release_expect}', got '${release}'"
    exit 1
fi

echo "Updating package information ..."
sudo apt update -y

echo "Installing required packages ..."
sudo apt install -y ${packages[@]}

echo "Cleaning ${output_dir} ..."
rm -rf "${output_dir}"
mkdir -p "${output_dir}"

echo "Building Red Hat shim ..."
cmake -S "${build_dir}" -B "${redhat_dir}" -D BUILD_VIASAT=OFF
cmake --build "${redhat_dir}"

echo "Building Viasat shim ..."
cmake -S "${build_dir}" -B "${viasat_dir}" -D BUILD_VIASAT=ON
cmake --build "${viasat_dir}"

echo "Comparing binaries ..."
hexdump -Cv \
    "${redhat_dir}/INSTALL/shimx64.efi" > \
    "${output_dir}/redhat_shim.hex"

hexdump -Cv \
    "${viasat_dir}/INSTALL/shimx64.efi" > \
    "${output_dir}/viasat_shim.hex"

diff -u \
    "${output_dir}/redhat_shim.hex" \
    "${output_dir}/viasat_shim.hex" > \
    "${output_dir}/diff_shim.hex" | true

echo "Extracting Viasat build log ..."
cp \
    "${viasat_dir}/LOG/shim-build.log" \
    "${output_dir}/viasat-shim-build.log"

echo "Extracting Viasat shim binary ..."
cp \
    "${viasat_dir}/INSTALL/shimx64.efi" \
    "${output_dir}/BOOTX64.EFI"

echo "Comparing Viasat shim binary to tagged release ..."
sha256sum \
    "${output_dir}/BOOTX64.EFI" \
    "${data_dir}/BOOTX64.EFI"

# https://learn.microsoft.com/en-us/windows/win32/api/winnt/ns-winnt-image_optional_header32
# IMAGE_DLLCHARACTERISTICS_NX_COMPAT: 0x0100
check_nx_bit() {
    file=$1
    [[ -n ${file} ]] || { echo >&2 "error: missing argument: file"; exit 1; }
    dll_chars=$(objdump -p ${file} | grep DllCharacteristics | cut -d$'\t' -f2)
    nx_bit=0x0100
    # Use bitwise AND (&) to read NX bit
    result=$([[ $((0x${dll_chars} & ${nx_bit})) -eq 0 ]] && echo "disabled" || echo "enabled")
    echo "File: ${file}" 
    echo "DllCharacteristics: 0x${dll_chars}"
    echo "NX bit ${nx_bit}: $result"
    exit 0
}

echo "Checking NX bit ..."
check_nx_bit ${data_dir}/BOOTX64.EFI
