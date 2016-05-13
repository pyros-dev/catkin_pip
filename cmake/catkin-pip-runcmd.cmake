
message(STATUS "Loading ${CMAKE_CURRENT_LIST_FILE}... ")

# Generic setup
# Setting required policies (for install)
# FOREACH(policy CMP0011 CMP0012 CMP0013 CMP0014)
#     IF(POLICY ${policy})
#       CMAKE_POLICY(SET ${policy} NEW)
#     ENDIF()
# ENDFOREACH()


macro(catkin_pip_runcmd)

    set(PIP_PACKAGE_INSTALL_COMMAND ${CATKIN_PIP} ${ARGN})

    string(REPLACE ";" " " PIP_PACKAGE_INSTALL_CMDSTR "${PIP_PACKAGE_INSTALL_COMMAND}")
    message(STATUS "    ... Running ${PIP_PACKAGE_INSTALL_CMDSTR} ...")

    execute_process(
      COMMAND ${PIP_PACKAGE_INSTALL_COMMAND}
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
      RESULT_VARIABLE PIP_RESULT
      OUTPUT_VARIABLE PIP_VARIABLE
      ERROR_VARIABLE PIP_ERROR
    )

    message(STATUS "    ... Done ... [${PIP_RESULT}]: ${PIP_VARIABLE}")
    if (PIP_RESULT)
        message(STATUS "Command ${PIP_PACKAGE_INSTALL_CMDSTR} FAILED !")
        message(FATAL_ERROR "${PIP_ERROR}")
    endif()
endmacro()