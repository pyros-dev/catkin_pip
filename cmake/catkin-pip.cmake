macro(catkin_pip_install_requirements)

    #TODO : check requirements.txt exists
    message(STATUS "    ... Installing Pip requirements :")
    message(STATUS "    ...    /usr/bin/pip install -r ${CMAKE_CURRENT_SOURCE_DIR}/requirements.txt -t ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_PYTHON_DESTINATION}")

    execute_process(
      COMMAND /usr/bin/pip install -r ${CMAKE_CURRENT_SOURCE_DIR}/requirements.txt -t ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_PYTHON_DESTINATION}
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
      RESULT_VARIABLE PIP_RESULT
      OUTPUT_VARIABLE PIP_VARIABLE
    )

    message(STATUS "    ... Done.. [${PIP_RESULT}]: ${PIP_VARIABLE}")

endmacro()


# TODO :
# venv for easy pip install : investigate https://github.com/KitwareMedical/TubeTK/blob/master/CMake/TubeTKVirtualEnvSetup.cmake
# CPACK to deb : investigate https://cmake.org/pipermail/cmake/2011-February/042687.html
#