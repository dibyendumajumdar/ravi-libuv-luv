cmake_minimum_required(VERSION 2.8)

if(POLICY CMP0053)
  cmake_policy(SET CMP0053 NEW) # faster evaluation of variable references
endif()

project (luv C)

set(LUV_VERSION_MAJOR 1)
set(LUV_VERSION_MINOR 41)
set(LUV_VERSION_PATCH 0)
set(LUV_VERSION ${LUV_VERSION_MAJOR}.${LUV_VERSION_MINOR}.${LUV_VERSION_PATCH})

option(BUILD_MODULE "Build as module" ON)
option(BUILD_STATIC_LIBS "Build static library" OFF)
option(BUILD_SHARED_LIBS "Build shared library" OFF)
option(WITH_SHARED_LIBUV "Link to a shared libuv library instead of static linking" OFF)
option(USE_LUA53 "Controls whether the library will be for Lua 5.3 or Ravi, default is OFF" OFF)

if (MINGW)
  add_definitions(-D_WIN32_WINNT=0x0600)
endif (MINGW)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")

#include_directories(deps/libuv/include)
#add_subdirectory(deps/libuv EXCLUDE_FROM_ALL)
#  if (BUILD_MODULE)
#    add_definitions( -DBUILDING_UV_SHARED )
#  endif (BUILD_MODULE)
#set(LIBUV_LIBRARIES uv)

find_package(Lua REQUIRED)
find_package(LIBUV REQUIRED)
if (LIBUV_FOUND)
  include_directories(${LIBUV_INCLUDE_DIR})
endif (LIBUV_FOUND)

MESSAGE(STATUS "LUA_LIBDIR: " ${LUA_LIBDIR})
MESSAGE(STATUS "LUA_INCDIR: " ${LUA_INCDIR})
MESSAGE(STATUS "LUA: " ${LUA})

SET(LUA_EXECUTABLE "${LUA}")
SET(LUA_INCLUDE_DIR "${LUA_INCDIR}")
SET(LUA_PACKAGE_PATH "${LUADIR}")
SET(LUA_PACKAGE_CPATH "${LIBDIR}")

SET(INSTALL_LIB_DIR ${LIBDIR})

GET_FILENAME_COMPONENT(LUA_EXEC_NAME ${LUA_EXECUTABLE} NAME_WE)

include_directories(${LUA_INCLUDE_DIR})

if (BUILD_MODULE)
  add_library(luv MODULE src/luv.c)
  set_target_properties(luv PROPERTIES PREFIX "")
else (BUILD_MODULE)
  add_library(luv src/luv.c)
  if (BUILD_SHARED_LIBS)
    set_target_properties(luv
      PROPERTIES VERSION ${LUV_VERSION} SOVERSION ${LUV_VERSION_MAJOR})
  endif (BUILD_SHARED_LIBS)
endif (BUILD_MODULE)

if(APPLE)
  set(CMAKE_SHARED_MODULE_CREATE_C_FLAGS
    "${CMAKE_SHARED_MODULE_CREATE_C_FLAGS} -flat_namespace -undefined suppress"
  )
endif()

if(WIN32)
  add_definitions(-DLUA_BUILD_AS_DLL -DLUA_LIB)
  target_link_libraries(luv ${LIBUV_LIBRARIES} ${LUA_LIBRARIES} ws2_32)
elseif("${CMAKE_SYSTEM_NAME}" MATCHES "Linux")
  target_link_libraries(luv ${LIBUV_LIBRARIES} rt)
else()
  target_link_libraries(luv ${LIBUV_LIBRARIES} ${LUA_LIBRARIES})
endif()

if (CMAKE_INSTALL_PREFIX)
  install(TARGETS luv
    LIBRARY DESTINATION ${LIBDIR}
    RUNTIME DESTINATION ${LUA_BINDIR}
  )
  if (NOT BUILD_MODULE)
    install(
      FILES src/luv.h src/util.h src/lhandle.h src/lreq.h
      DESTINATION "${LUA_INCDIR}"
    )
  endif (NOT BUILD_MODULE)
endif (CMAKE_INSTALL_PREFIX)
