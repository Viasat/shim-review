#!/usr/bin/env bash
# https://learn.microsoft.com/en-us/windows/win32/api/winnt/ns-winnt-image_optional_header32
# IMAGE_DLLCHARACTERISTICS_NX_COMPAT: 0x0100
set -e
main() {
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

main $@