#*******************************************************************************
#
# Filename: CMakeLists.txt
# Classification: Commercial-In-Confidence
# Copyright © 2021-2025 Viasat UK
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
#*******************************************************************************
cmake_minimum_required(VERSION 3.14)
include(ExternalProject)

set(PACKAGE_NAME shim)
project(${PACKAGE_NAME})

option(BUILD_VIASAT "Whether to build Viasat shim" ON)

# Required otherwise VERBOSE=1 below does not work
set(CMAKE_VERBOSE_MAKEFILE ON)

if (BUILD_VIASAT)
	set(PKG_CERT_NAME viasatuk.der)
	set(PKG_SBAT_NAME sbat.viasat.csv)
	set(PKG_PATCH_COMMAND
		cp ${CMAKE_CURRENT_SOURCE_DIR}/${PKG_CERT_NAME} . &&
		cp ${CMAKE_CURRENT_SOURCE_DIR}/${PKG_SBAT_NAME} data/.)
	# gcc ... -DDEFAULT_LOADER='L"\\\\paex64.efi"' ...
	set(BUILD_ARGS
		VENDOR_CERT_FILE=${PKG_CERT_NAME}
		DEFAULT_LOADER=\\\\\\\\\\\\\\\\paex64.efi)
endif()
set(PKG_CONFIGURE_COMMAND export VERBOSE=1)
set(PKG_BUILD_COMMAND make ${BUILD_ARGS})
set(PKG_LOG_DIR ${CMAKE_CURRENT_BINARY_DIR}/LOG)
set(PKG_INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/INSTALL)
set(PKG_INSTALL_COMMAND cp shimx64.efi ${PKG_INSTALL_DIR})

ExternalProject_Add(${PACKAGE_NAME}
	URL https://github.com/rhboot/shim/releases/download/15.8/shim-15.8.tar.bz2
	URL_HASH SHA256=a79f0a9b89f3681ab384865b1a46ab3f79d88b11b4ca59aa040ab03fffae80a9
	LOG_BUILD 1
	LOG_DIR ${PKG_LOG_DIR}
	LOG_MERGED_STDOUTERR 1
	BUILD_IN_SOURCE 1
	UPDATE_COMMAND ""
	PATCH_COMMAND ${PKG_PATCH_COMMAND}
	CONFIGURE_COMMAND ${PKG_CONFIGURE_COMMAND}
	BUILD_COMMAND ${PKG_BUILD_COMMAND}
	INSTALL_COMMAND ${PKG_INSTALL_COMMAND}
	INSTALL_DIR ${PKG_INSTALL_DIR}
)
