if (CMAKE_BUILD_TYPE STREQUAL "Debug")

  find_path(LIBUV_INCLUDE_DIR uv.h
    PATHS
    c:/work/vcpkg/installed/x64-windows/include
    /usr/local/include
    ~/local/include
  )

  find_library(LIBUV_LIBRARY
    NAMES libuv uv
    PATHS
    c:/work/vcpkg/installed/x64-windows/debug/lib
    /usr/local/lib
    ~/local/lib
  )

else()

  find_path(LIBUV_INCLUDE_DIR uv.h
    PATHS
    c:/work/vcpkg/installed/x64-windows/include
    /usr/local/include
    ~/local/include
  )

  find_library(LIBUV_LIBRARY
    NAMES libuv uv
    PATHS
    c:/work/vcpkg/installed/x64-windows/lib
    /usr/local/lib
    ~/local/lib
  )

endif()

set( LIBUV_INCLUDE_DIRS "${LIBUV_INCLUDE_DIR}" )
set( LIBUV_LIBRARIES "${LIBUV_LIBRARY}" )
