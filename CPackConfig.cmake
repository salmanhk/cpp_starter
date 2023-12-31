#[[####################################################################
                    INSTALLATION AND PACKAGING
######################################################################]]

#set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/install)
#install(TARGETS console
#  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}  
#  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
#  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
#)

#set(CPACK_BINARY_NSIS OFF)
#set(CPACK_BINARY_ZIP OFF)
#set(CPACK_BINARY_TBZ2 OFF)
set(CPACK_PACKAGE_DESCRIPTION ${PROJECT_DESCRIPTION})
set(CPACK_PACKAGE_VENDOR ${PROJECT_VENDOR})
set(CPACK_PACKAGE_VERSION_MAJOR "${PROJECT_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${PROJECT_VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${PROJECT_VERSION_PATCH}")
set(CPACK_PACKAGE_VERSION ${PROJECT_VERSION})  
set(CPACK_PACKAGE_INSTALL_DIRECTORY ${PROJECT_NAME})
set(CPACK_PACKAGE_CONTACT ${PROJECT_CONTACT})
set(CPACK_PACKAGE_HOMEPAGE_URL ${PROJECT_HOMEPAGE_URL})
set(CPACK_RESOURCE_FILE_README ${CMAKE_SOURCE_DIR}/README.md)
set(CPACK_RESOURCE_FILE_LICENSE ${CMAKE_SOURCE_DIR}/LICENSE)
set(CPACK_PACKAGE_CHECKSUM SHA512)
#set(CPACK_PACKAGE_ICON "${CMAKE_SOURCE_DIR}/cmake/nsis/nsis_branding.bmp")

if(CMAKE_HOST_WIN32)
  message("-- CPack NSIS Windows")
  set(CPACK_GENERATOR "NSIS")
  set(CPACK_BINARY_NSIS ON)
  set(CPACK_BINARY_ZIP ON)

  set(CPACK_NSIS_MODIFY_PATH ON)  # show option add to path page
  set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES64")
  set(CPACK_NSIS_DISPLAY_NAME ${PROJECT_NAME})
  set(CPACK_NSIS_UNINSTALL_NAME uninstall)
  set(CPACK_NSIS_CONTACT ${CPACK_PACKAGE_CONTACT})
  set(CPACK_NSIS_ENABLE_UNINSTALL_BEFORE_INSTALL ON)
  set(CPACK_NSIS_HELP_LINK ${PROJECT_HOMEPAGE_URL})

elseif(CMAKE_HOST_APPLE)
  message("PING B")
  set(CPACK_BINARY_TBZ2 ON)
else()
  message("PING C")
  set(CPACK_BINARY_TBZ2 ON)
endif()

install(FILES ${CPACK_RESOURCE_FILE_README} ${CPACK_RESOURCE_FILE_LICENSE}
    DESTINATION share/docs
)
install(TARGETS console DESTINATION bin)
install(
    FILES 
        ${CMAKE_BINARY_DIR}/source/duckdb.dll 
    DESTINATION 
        bin)

include(CPack)
