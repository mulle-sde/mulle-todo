cmake_minimum_required( VERSION 3.15...99.99)

project( mulle-todo VERSION 0.2.1 LANGUAGES NONE)

#
# Primarily used for packaging on Linux
#
# Debian:
#
# ```
# mkdir package
# cd package
# cmake ..
# cpack -G DEB
# ```
#

execute_process( COMMAND ./mulle-todo version
                 WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
                 OUTPUT_VARIABLE MULLE_DISPENSE_VERSION
                 OUTPUT_STRIP_TRAILING_WHITESPACE)
message( STATUS "MULLE_DISPENSE_VERSION is ${MULLE_DISPENSE_VERSION} according to mulle-todo")


set( PROJECT_VERSION "${MULLE_DISPENSE_VERSION}")


set( SCRIPTS
mulle-todo
)



INSTALL( FILES ${SCRIPTS}
PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ
            GROUP_EXECUTE GROUP_READ
            WORLD_EXECUTE WORLD_READ
DESTINATION "bin")


######
#
# must be after CPACK_PACKAGE_VERSION
include( CMakePackage.cmake)
include( CPack)
