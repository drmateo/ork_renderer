#.rst:
# FindOpenGL
# ----------
#
# FindModule for OpenGL and GLU.
#
# Result Variables
# ^^^^^^^^^^^^^^^^
#
# This module sets the following variables:
#
# ``OPENGL_FOUND``
#  True, if the system has OpenGL.
# ``OPENGL_XMESA_FOUND``
#  True, if the system has XMESA.
# ``OPENGL_GLU_FOUND``
#  True, if the system has GLU.
# ``OPENGL_INCLUDE_DIR``
#  Path to the OpenGL include directory.
# ``OPENGL_LIBRARIES``
#  Paths to the OpenGL and GLU libraries.
#
# If you want to use just GL you can use these values:
#
# ``OPENGL_gl_LIBRARY``
#  Path to the OpenGL library.
# ``OPENGL_glu_LIBRARY``
#  Path to the GLU library.
#
# OSX Specific
# ^^^^^^^^^^^^
#
# On OSX default to using the framework version of OpenGL. People will
# have to change the cache values of OPENGL_glu_LIBRARY and
# OPENGL_gl_LIBRARY to use OpenGL with X11 on OSX.


#=============================================================================
# Copyright 2001-2009 Kitware, Inc.
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)

set(_OpenGL_REQUIRED_VARS OPENGL_gl_LIBRARY)

if (CYGWIN)

  find_path(OPENGL_INCLUDE_DIR GL/gl.h )
  list(APPEND _OpenGL_REQUIRED_VARS OPENGL_INCLUDE_DIR)

  find_library(OPENGL_gl_LIBRARY opengl32 )

  find_library(OPENGL_glu_LIBRARY glu32 )

elseif (WIN32)

  if(BORLAND)
    set (OPENGL_gl_LIBRARY import32 CACHE STRING "OpenGL library for win32")
    set (OPENGL_glu_LIBRARY import32 CACHE STRING "GLU library for win32")
  else()
    set (OPENGL_gl_LIBRARY opengl32 CACHE STRING "OpenGL library for win32")
    set (OPENGL_glu_LIBRARY glu32 CACHE STRING "GLU library for win32")
  endif()

#elseif (APPLE)
#
  # The OpenGL.framework provides both gl and glu
#  find_library(OPENGL_gl_LIBRARY OpenGL DOC "OpenGL library for OS X")
#  find_library(OPENGL_glu_LIBRARY OpenGL DOC
#    "GLU library for OS X (usually same as OpenGL library)")
#  find_path(OPENGL_INCLUDE_DIR OpenGL/gl.h DOC "Include for OpenGL on OS X")
#  list(APPEND _OpenGL_REQUIRED_VARS OPENGL_INCLUDE_DIR)

else(UNIX)
  find_path(OPENGL_INCLUDE_DIR GL/gl.h
    /usr/X11/include
    /usr/X11R6/include
  )
  list(APPEND _OpenGL_REQUIRED_VARS OPENGL_INCLUDE_DIR)

  find_path(OPENGL_omesa_INCLUDE_DIR GL/osmesa.h
    /usr/X11/include
    /usr/X11R6/include
  )

  find_library(OPENGL_gl_LIBRARY
    NAMES GL 
    PATHS 
        /usr/X11/lib
        /usr/X11R6/lib
  )

  find_library(OPENGL_glu_LIBRARY
    NAMES GLU 
    PATHS ${OPENGL_gl_LIBRARY}
        /usr/X11/lib
        /usr/X11R6/lib
  )

  find_library(OPENGL_osmesa_LIBRARY
    NAMES OSMesa 
    PATHS ${OPENGL_gl_LIBRARY}
        /usr/X11/lib
        /usr/X11R6/lib
  )

endif ()

if(OPENGL_gl_LIBRARY)

    if(OPENGL_omesa_INCLUDE_DIR)
      set( OPENGL_OMESA_FOUND "YES" )
      set( OPENGL_LIBRARIES  ${OPENGL_gl_LIBRARY} ${OPENGL_LIBRARIES} ${OPENGL_osmesa_LIBRARY})
    else()
      set( OPENGL_OMESA_FOUND "NO" )
      set( OPENGL_LIBRARIES  ${OPENGL_gl_LIBRARY} ${OPENGL_LIBRARIES})
    endif()

    if(OPENGL_glu_LIBRARY)
      set( OPENGL_GLU_FOUND "YES" )
      if(NOT "${OPENGL_glu_LIBRARY}" STREQUAL "${OPENGL_gl_LIBRARY}")
        set( OPENGL_LIBRARIES ${OPENGL_glu_LIBRARY} ${OPENGL_LIBRARIES} )
      endif()
    else()
      set( OPENGL_GLU_FOUND "NO" )
    endif()

    # This deprecated setting is for backward compatibility with CMake1.4
    set (OPENGL_LIBRARY ${OPENGL_LIBRARIES})

endif()

# This deprecated setting is for backward compatibility with CMake1.4
set(OPENGL_INCLUDE_PATH ${OPENGL_INCLUDE_DIR})

# handle the QUIETLY and REQUIRED arguments and set OPENGL_FOUND to TRUE if
# all listed variables are TRUE
FIND_PACKAGE_HANDLE_STANDARD_ARGS(OpenGL REQUIRED_VARS ${_OpenGL_REQUIRED_VARS})
unset(_OpenGL_REQUIRED_VARS)

mark_as_advanced(
  OPENGL_INCLUDE_DIR
  OPENGL_omesa_INCLUDE_DIR
  OPENGL_glu_LIBRARY
  OPENGL_gl_LIBRARY
)
