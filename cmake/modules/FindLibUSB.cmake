# FindLibUSB.cmake - Try to find the Hiredis library
# Once done this will define
#
#  LIBUSB_FOUND - System has libusb
#  LIBUSB_include_DIR - The libusb include directory
#  LIBUSB_LIBRARY - The libraries needed to use libusb
#  LIBUSB_DEFINITIONS - Compiler switches required for using libusb
#
#  Original from https://github.com/texane/stlink/blob/master/cmake/modules/FindLibUSB.cmake

if(WIN32 OR MINGW OR MSYS)
	set(LIBUSB_WIN_VERSION "1.0.20")
	set(LIBUSB_WIN_ARCHIVE libusb-${LIBUSB_WIN_VERSION}.7z)
	set(LIBUSB_WIN_ARCHIVE_PATH ${CMAKE_BINARY_DIR}/${LIBUSB_WIN_ARCHIVE})
	set(LIBUSB_WIN_OUTPUT_FOLDER ${CMAKE_BINARY_DIR}/libusb-${LIBUSB_WIN_VERSION})

	if (EXISTS ${LIBUSB_WIN_ARCHIVE_PATH})
		message(STATUS "libusb archive already in build folder")
	else ()
		file(DOWNLOAD
			https://sourceforge.net/projects/libusb/files/libusb-1.0/libusb-${LIBUSB_WIN_VERSION}/libusb-${LIBUSB_WIN_VERSION}.7z/download
			${LIBUSB_WIN_ARCHIVE_PATH}
			SHOW_PROGRESS)
	endif ()

	execute_process(COMMAND ${ZIP_LOCATION} x -y ${LIBUSB_WIN_ARCHIVE_PATH} -o ${LIBUSB_WIN_OUTPUT_FOLDER})
endif()

find_path(LIBUSB_include_DIR NAMES libusb.h
	HINTS
	/usr
	/usr/local
	/opt
	${LIBUSB_WIN_OUTPUT_FOLDER}/include
	PATH_SUFFIXES libusb-1.0
)

if (APPLE)
	set(LIBUSB_NAME libusb-1.0.a)
elseif(MSYS OR MINGW)
	set(LIBUSB_NAME usb-1.0)
elseif(WIN32)
	set(LIBUSB_NAME libusb-1.0.lib)
else()
	set(LIBUSB_NAME usb-1.0)
endif()

find_library(LIBUSB_LIBRARY NAMES ${LIBUSB_NAME}
	HINTS
	/usr
	/usr/local
	/opt
	${LIBUSB_WIN_OUTPUT_FOLDER}/MinGW32/static
	${LIBUSB_WIN_OUTPUT_FOLDER}/MinGW64/static
)

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Libusb DEFAULT_MSG LIBUSB_LIBRARY LIBUSB_include_DIR)

MARK_AS_ADVANCED(LIBUSB_include_DIR LIBUSB_LIBRARY)
