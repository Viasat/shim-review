#***************************************************************************
#
# Filename: CMakeLists.txt
# Classification: UNCLASSIFIED
# Description: CMake file for Shim
#
# Copyright (C) 2021 Viasat, UK Limited.
# All rights reserved.
# The information in this software is subject to change without notice and
# should not be construed as a commitment by Viasat, UK Limited.
#
# Viasat Proprietary
# The Proprietary Information provided herein is proprietary to Viasat and
# must be protected from further distribution and use. Disclosure to others,
# use or copying without express written authorization of Viasat, is strictly
# prohibited.
#
#***************************************************************************
cmake_minimum_required(VERSION 3.14)
include(ExternalProject)

set(PACKAGE_NAME shim)
project(${PACKAGE_NAME})

option(BUILD_VIASAT "Whether to build Viasat shim" ON)

# Required otherwise VERBOSE=1 below does not work
set(CMAKE_VERBOSE_MAKEFILE ON)

# Custom platform specific rules
if(UNIX)
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
endif()

# External project settings
# This project differs from the other cots projects as it links back to the git repo where we got the code
# thus allowing us to easily pick up improvements in the future.
ExternalProject_Add(${PACKAGE_NAME}
	GIT_REPOSITORY https://github.com/rhinstaller/shim.git
	GIT_TAG "15.5"
	GIT_SHALLOW 1
	GIT_CONFIG advice.detachedHead=false
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
