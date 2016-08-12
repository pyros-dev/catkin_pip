==============
Catkin Package
==============

Ref : http://wiki.ros.org/ROS/Tutorials/catkin/CreatingPackage

We are focusing here only in python packages.
We will use the "catkin way of doing things" described here, as a reference when discussing improvements brought with catkin_pip.

Package Structure
=================

This is a generic example inspired by the pure catkin package from the Pyros dependencies : `pyros-test <https://github.com/asmodehn/pyros-test>`_


Files hierarchy
---------------


The source file hierarchy is::

    .
    ├── CHANGELOG.rst              # A changelog, usually generated from git commit with catkin_generate_changelog
    ├── CMakeLists.txt             # A CMakeLists, using Catkin macros
    ├── doc
    │   ├── changelog_link.rst     # Documentation link to existing changelog
    │   ├── conf.py                # Sphinx doc configuration
    │   ├── mydocs.rst             # Documentation for Sphinx
    │   └── readme_link.rst        # Documentation link to existing readme
    ├── nodes
    │   └── node1.py               # python script launching a ROS node
    ├── scripts
    │   └── script1.py             # python utility script
    ├── package.xml                # package.xml required by catkin
    ├── README.rst
    ├── setup.py                   # setup.py using distutils and catkin_pkg extension
    ├── src
    │   └── mypkg                  # mypkg python package
    │       ├── module1.py
    │       └── __init__.py
    ├── msg
    │   └── mymessage.msg          # ROS message definition
    └── srv
        └── myservice.srv          # ROS service definition


- package.xml looks like ::

    <?xml version="1.0"?>
    <package format="2">
      <name>mypkg</name>
      <version>0.0.4</version>
      <description>
        MyPkg description
      </description>

      <license>BSD</license>

      <url type="repository">https://github.com/author/mypkg</url>
      <url type="bugtracker">https://github.com/author/mypkg/issues</url>

      <author email="author@gmail.com">Author</author>
      <maintainer email="maintainer@gmail.com">Maintainer</maintainer>

      <buildtool_depend version_gte="0.6.18">catkin</buildtool_depend>

      <depend version_gte="1.11.19">rospy</depend>
      <depend version_gte="0.5.10">std_msgs</depend>

      <build_depend version_gte="0.2.10">message_generation</build_depend>
      <build_depend version_gte="0.10.0">roslint</build_depend>

      <exec_depend version_gte="0.4.12">message_runtime</exec_depend>

      <!-- these dependencies are only for testing -->
      <test_depend version_gte="1.11.19">rostest</test_depend>
      <test_depend version_gte="1.11.12">rosunit</test_depend>

      <!-- documentation dependencies -->
      <doc_depend version_gte="0.2.10">python-catkin-pkg</doc_depend>

    </package>



- CMakeLists.txt looks like ::

    cmake_minimum_required(VERSION 2.8.3)
    project(mypkg)

    # Minimal Python module setup
    find_package(catkin REQUIRED COMPONENTS
        roslint
        rospy
        std_msgs
        message_generation
    )

    catkin_python_setup()

    add_message_files(DIRECTORY msg
        FILES
        mymessage.msg
    )
    add_service_files(DIRECTORY srv
        FILES
        myservice.srv
    )
    generate_messages(DEPENDENCIES std_msgs)

    catkin_package( CATKIN_DEPENDS message_runtime std_msgs)

    install(
        PROGRAMS
            nodes/node1.py
        DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
        )

    install(
        PROGRAMS
            scripts/script1.py
        DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
        )

    # Lint Python modules
    file(GLOB_RECURSE ${PROJECT_NAME}_PY_SRCS
         RELATIVE ${PROJECT_SOURCE_DIR} src/pyros_test/*.py)
    roslint_python(${${PROJECT_NAME}_PY_SRCS})


- setup.py looks like::

    from distutils.core import setup
    from catkin_pkg.python_setup import generate_distutils_setup

    # ROS PACKAGING
    # using distutils : https://docs.python.org/2/distutils
    # fetch values from package.xml
    setup_args = generate_distutils_setup(
        packages=[
            'mypkg',
        ],
        package_dir={
            'mypkg': 'src/mypkg',
        }
    )
    setup(**setup_args)


Dependencies
------------

Dependencies are expressed via rosdep keys in the package.xml file.

Note these rosdep keys can refer to pip packages (check the rosdistro repository, you will find pip keys) but AFAIK:

- there are no guarantees that these pip packages will play nice along the rest of your ROS distro.
- there are little information on how rosdep handle pip dependencies (version requirements ?)
- there is no clear visibility on rosdep pip support in the long term.

If you think I am mistaken please open an issue on catkin_pip repository, and share the information you have regarding these topics.


Package Development Workflow
============================

This is a description of the generic ROS catkin workflow to retrieve, develop, build, test and release a catkin-based package.
We will use pyros-test project as an example.
**TODO : travis check these with doctest + running these in isolation in container**

- Retrieve the project::

    $ mkdir -p catkin_ws/src
    $ cd catkin_ws/src/
    $ wstool init
    Writing /home/alexv/doctest/catkin_ws/src/.rosinstall

    update complete.

    $ wstool set pyros-test https://github.com/asmodehn/pyros-test.git --git

         Add new elements:
      pyros-test   	git  https://github.com/asmodehn/pyros-test.git

    Continue: (y)es, (n)o: y
    Overwriting /home/alexv/doctest/catkin_ws/src/.rosinstall
    Config changed, remember to run 'wstool update pyros-test' to update the folder from git

    $ wstool update pyros-test
    [pyros-test] Fetching https://github.com/asmodehn/pyros-test.git (version None) to /home/alexv/doctest/catkin_ws/src/pyros-test
    Cloning into '/home/alexv/doctest/catkin_ws/src/pyros-test'...
    remote: Counting objects: 87, done.
    remote: Total 87 (delta 0), reused 0 (delta 0), pack-reused 87
    Unpacking objects: 100% (87/87), done.
    Checking connectivity... done.
    [pyros-test] Done.


- Source your ROS environment::

    $ source /opt/ros/indigo/setup.bash

- Build with catkin_make::

    $ catkin_make
    Base path: /home/alexv/doctest/catkin_ws
    Source space: /home/alexv/doctest/catkin_ws/src
    Build space: /home/alexv/doctest/catkin_ws/build
    Devel space: /home/alexv/doctest/catkin_ws/devel
    Install space: /home/alexv/doctest/catkin_ws/install
    Creating symlink "/home/alexv/doctest/catkin_ws/src/CMakeLists.txt" pointing to "/opt/ros/indigo/share/catkin/cmake/toplevel.cmake"
    ####
    #### Running command: "cmake /home/alexv/doctest/catkin_ws/src -DCATKIN_DEVEL_PREFIX=/home/alexv/doctest/catkin_ws/devel -DCMAKE_INSTALL_PREFIX=/home/alexv/doctest/catkin_ws/install -G Unix Makefiles" in "/home/alexv/doctest/catkin_ws/build"
    ####
    -- The C compiler identification is GNU 4.8.4
    -- The CXX compiler identification is GNU 4.8.4
    -- Check for working C compiler: /usr/bin/cc
    -- Check for working C compiler: /usr/bin/cc -- works
    -- Detecting C compiler ABI info
    -- Detecting C compiler ABI info - done
    -- Check for working CXX compiler: /usr/bin/c++
    -- Check for working CXX compiler: /usr/bin/c++ -- works
    -- Detecting CXX compiler ABI info
    -- Detecting CXX compiler ABI info - done
    -- Using CATKIN_DEVEL_PREFIX: /home/alexv/doctest/catkin_ws/devel
    -- Using CMAKE_PREFIX_PATH: /opt/ros/indigo
    -- This workspace overlays: /opt/ros/indigo
    -- Found PythonInterp: /usr/bin/python (found version "2.7.6")
    -- Using PYTHON_EXECUTABLE: /usr/bin/python
    -- Using Debian Python package layout
    -- Using empy: /usr/bin/empy
    -- Using CATKIN_ENABLE_TESTING: ON
    -- Call enable_testing()
    -- Using CATKIN_TEST_RESULTS_DIR: /home/alexv/doctest/catkin_ws/build/test_results
    -- Looking for include file pthread.h
    -- Looking for include file pthread.h - found
    -- Looking for pthread_create
    -- Looking for pthread_create - not found
    -- Looking for pthread_create in pthreads
    -- Looking for pthread_create in pthreads - not found
    -- Looking for pthread_create in pthread
    -- Looking for pthread_create in pthread - found
    -- Found Threads: TRUE
    -- Found gtest sources under '/usr/src/gtest': gtests will be built
    -- Using Python nosetests: /usr/bin/nosetests-2.7
    -- catkin 0.6.18
    -- BUILD_SHARED_LIBS is on
    -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    -- ~~  traversing 1 packages in topological order:
    -- ~~  - pyros_test
    -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    -- +++ processing catkin package: 'pyros_test'
    -- ==> add_subdirectory(pyros-test)
    -- Using these message generators: gencpp;genlisp;genpy
    -- pyros_test: 0 messages, 1 services
    -- Configuring done
    -- Generating done
    -- Build files have been written to: /home/alexv/doctest/catkin_ws/build
    ####
    #### Running command: "make -j8 -l8" in "/home/alexv/doctest/catkin_ws/build"
    ####
    Scanning dependencies of target std_msgs_generate_messages_cpp
    Scanning dependencies of target std_msgs_generate_messages_py
    Scanning dependencies of target _pyros_test_generate_messages_check_deps_StringEchoService
    Scanning dependencies of target std_msgs_generate_messages_lisp
    [  0%] [  0%] Built target std_msgs_generate_messages_cpp
    [  0%] Built target std_msgs_generate_messages_py
    Built target std_msgs_generate_messages_lisp
    [  0%] Built target _pyros_test_generate_messages_check_deps_StringEchoService
    Scanning dependencies of target pyros_test_generate_messages_cpp
    Scanning dependencies of target pyros_test_generate_messages_lisp
    Scanning dependencies of target pyros_test_generate_messages_py
    [ 75%] [ 75%] [ 75%] Generating Lisp code from pyros_test/StringEchoService.srv
    Generating C++ code from pyros_test/StringEchoService.srv
    Generating Python code from SRV pyros_test/StringEchoService
    [100%] Generating Python srv __init__.py for pyros_test
    [100%] Built target pyros_test_generate_messages_lisp
    [100%] Built target pyros_test_generate_messages_py
    [100%] Built target pyros_test_generate_messages_cpp
    Scanning dependencies of target pyros_test_generate_messages
    [100%] Built target pyros_test_generate_messages




- Source devel space::

    $ source devel/setup.bash


- Run tests with catkin_make test::

    $ catkin_make test
    Base path: /home/alexv/doctest/catkin_ws
    Source space: /home/alexv/doctest/catkin_ws/src
    Build space: /home/alexv/doctest/catkin_ws/build
    Devel space: /home/alexv/doctest/catkin_ws/devel
    Install space: /home/alexv/doctest/catkin_ws/install
    ####
    #### Running command: "make cmake_check_build_system" in "/home/alexv/doctest/catkin_ws/build"
    ####
    ####
    #### Running command: "make test -j8 -l8" in "/home/alexv/doctest/catkin_ws/build"
    ####
    Running tests...
    Test project /home/alexv/doctest/catkin_ws/build
    No tests were found!!!


- Debug tests with catkin_make run_tests::

    $ catkin_make run_tests
    Base path: /home/alexv/doctest/catkin_ws
    Source space: /home/alexv/doctest/catkin_ws/src
    Build space: /home/alexv/doctest/catkin_ws/build
    Devel space: /home/alexv/doctest/catkin_ws/devel
    Install space: /home/alexv/doctest/catkin_ws/install
    ####
    #### Running command: "make cmake_check_build_system" in "/home/alexv/doctest/catkin_ws/build"
    ####
    ####
    #### Running command: "make run_tests -j8 -l8" in "/home/alexv/doctest/catkin_ws/build"
    ####
    Scanning dependencies of target run_tests
    Built target run_tests



From a different shell to not have your environment polluted with devel space:


- Source your ROS environment::

    $ source /opt/ros/indigo/setup.bash

- Install with catkin_make install::

    $ catkin_make install
    Base path: /home/alexv/doctest/catkin_ws
    Source space: /home/alexv/doctest/catkin_ws/src
    Build space: /home/alexv/doctest/catkin_ws/build
    Devel space: /home/alexv/doctest/catkin_ws/devel
    Install space: /home/alexv/doctest/catkin_ws/install
    ####
    #### Running command: "make cmake_check_build_system" in "/home/alexv/doctest/catkin_ws/build"
    ####
    ####
    #### Running command: "make install -j8 -l8" in "/home/alexv/doctest/catkin_ws/build"
    ####
    [  0%] [  0%] [  0%] Built target std_msgs_generate_messages_lisp
    Built target std_msgs_generate_messages_py
    Built target std_msgs_generate_messages_cpp
    [  0%] Built target _pyros_test_generate_messages_check_deps_StringEchoService
    [100%] [100%] [100%] Built target pyros_test_generate_messages_lisp
    Built target pyros_test_generate_messages_cpp
    Built target pyros_test_generate_messages_py
    [100%] Built target pyros_test_generate_messages
    Install the project...
    -- Install configuration: ""
    -- Installing: /home/alexv/doctest/catkin_ws/install/_setup_util.py
    -- Installing: /home/alexv/doctest/catkin_ws/install/env.sh
    -- Installing: /home/alexv/doctest/catkin_ws/install/setup.bash
    -- Installing: /home/alexv/doctest/catkin_ws/install/setup.sh
    -- Installing: /home/alexv/doctest/catkin_ws/install/setup.zsh
    -- Installing: /home/alexv/doctest/catkin_ws/install/.rosinstall
    + cd /home/alexv/doctest/catkin_ws/src/pyros-test
    + mkdir -p /home/alexv/doctest/catkin_ws/install/lib/python2.7/dist-packages
    + /usr/bin/env PYTHONPATH=/home/alexv/doctest/catkin_ws/install/lib/python2.7/dist-packages:/home/alexv/doctest/catkin_ws/build/lib/python2.7/dist-packages:/opt/ros/indigo/lib/python2.7/dist-packages CATKIN_BINARY_DIR=/home/alexv/doctest/catkin_ws/build /usr/bin/python /home/alexv/doctest/catkin_ws/src/pyros-test/setup.py build --build-base /home/alexv/doctest/catkin_ws/build/pyros-test install --install-layout=deb --prefix=/home/alexv/doctest/catkin_ws/install --install-scripts=/home/alexv/doctest/catkin_ws/install/bin
    running build
    running build_py
    creating /home/alexv/doctest/catkin_ws/build/pyros-test/lib.linux-x86_64-2.7
    creating /home/alexv/doctest/catkin_ws/build/pyros-test/lib.linux-x86_64-2.7/pyros_test
    copying src/pyros_test/echo_node.py -> /home/alexv/doctest/catkin_ws/build/pyros-test/lib.linux-x86_64-2.7/pyros_test
    copying src/pyros_test/__init__.py -> /home/alexv/doctest/catkin_ws/build/pyros-test/lib.linux-x86_64-2.7/pyros_test
    running install
    running install_lib
    creating /home/alexv/doctest/catkin_ws/install/lib/python2.7/dist-packages/pyros_test
    copying /home/alexv/doctest/catkin_ws/build/pyros-test/lib.linux-x86_64-2.7/pyros_test/echo_node.py -> /home/alexv/doctest/catkin_ws/install/lib/python2.7/dist-packages/pyros_test
    copying /home/alexv/doctest/catkin_ws/build/pyros-test/lib.linux-x86_64-2.7/pyros_test/__init__.py -> /home/alexv/doctest/catkin_ws/install/lib/python2.7/dist-packages/pyros_test
    byte-compiling /home/alexv/doctest/catkin_ws/install/lib/python2.7/dist-packages/pyros_test/echo_node.py to echo_node.pyc
    byte-compiling /home/alexv/doctest/catkin_ws/install/lib/python2.7/dist-packages/pyros_test/__init__.py to __init__.pyc
    running install_egg_info
    Writing /home/alexv/doctest/catkin_ws/install/lib/python2.7/dist-packages/pyros_test-0.0.4.egg-info
    -- Installing: /home/alexv/doctest/catkin_ws/install/share/pyros_test/srv/StringEchoService.srv
    -- Installing: /home/alexv/doctest/catkin_ws/install/share/pyros_test/cmake/pyros_test-msg-paths.cmake
    -- Installing: /home/alexv/doctest/catkin_ws/install/include/pyros_test
    -- Installing: /home/alexv/doctest/catkin_ws/install/include/pyros_test/StringEchoServiceResponse.h
    -- Installing: /home/alexv/doctest/catkin_ws/install/include/pyros_test/StringEchoServiceRequest.h
    -- Installing: /home/alexv/doctest/catkin_ws/install/include/pyros_test/StringEchoService.h
    -- Installing: /home/alexv/doctest/catkin_ws/install/share/common-lisp/ros/pyros_test
    -- Installing: /home/alexv/doctest/catkin_ws/install/share/common-lisp/ros/pyros_test/srv
    -- Installing: /home/alexv/doctest/catkin_ws/install/share/common-lisp/ros/pyros_test/srv/_package.lisp
    -- Installing: /home/alexv/doctest/catkin_ws/install/share/common-lisp/ros/pyros_test/srv/pyros_test-srv.asd
    -- Installing: /home/alexv/doctest/catkin_ws/install/share/common-lisp/ros/pyros_test/srv/StringEchoService.lisp
    -- Installing: /home/alexv/doctest/catkin_ws/install/share/common-lisp/ros/pyros_test/srv/_package_StringEchoService.lisp
    Listing /home/alexv/doctest/catkin_ws/devel/lib/python2.7/dist-packages/pyros_test ...
    Compiling /home/alexv/doctest/catkin_ws/devel/lib/python2.7/dist-packages/pyros_test/__init__.py ...
    Listing /home/alexv/doctest/catkin_ws/devel/lib/python2.7/dist-packages/pyros_test/srv ...
    Compiling /home/alexv/doctest/catkin_ws/devel/lib/python2.7/dist-packages/pyros_test/srv/_StringEchoService.py ...
    Compiling /home/alexv/doctest/catkin_ws/devel/lib/python2.7/dist-packages/pyros_test/srv/__init__.py ...
    -- Installing: /home/alexv/doctest/catkin_ws/install/lib/python2.7/dist-packages/pyros_test
    -- Installing: /home/alexv/doctest/catkin_ws/install/lib/python2.7/dist-packages/pyros_test/srv
    -- Installing: /home/alexv/doctest/catkin_ws/install/lib/python2.7/dist-packages/pyros_test/srv/_StringEchoService.pyc
    -- Installing: /home/alexv/doctest/catkin_ws/install/lib/python2.7/dist-packages/pyros_test/srv/_StringEchoService.py
    -- Installing: /home/alexv/doctest/catkin_ws/install/lib/python2.7/dist-packages/pyros_test
    -- Installing: /home/alexv/doctest/catkin_ws/install/lib/python2.7/dist-packages/pyros_test/srv
    -- Installing: /home/alexv/doctest/catkin_ws/install/lib/python2.7/dist-packages/pyros_test/srv/__init__.pyc
    -- Installing: /home/alexv/doctest/catkin_ws/install/lib/python2.7/dist-packages/pyros_test/srv/__init__.py
    -- Installing: /home/alexv/doctest/catkin_ws/install/lib/pkgconfig/pyros_test.pc
    -- Installing: /home/alexv/doctest/catkin_ws/install/share/pyros_test/cmake/pyros_test-msg-extras.cmake
    -- Installing: /home/alexv/doctest/catkin_ws/install/share/pyros_test/cmake/pyros_testConfig.cmake
    -- Installing: /home/alexv/doctest/catkin_ws/install/share/pyros_test/cmake/pyros_testConfig-version.cmake
    -- Installing: /home/alexv/doctest/catkin_ws/install/share/pyros_test/package.xml
    -- Installing: /home/alexv/doctest/catkin_ws/install/lib/pyros_test/echo.py
    -- Installing: /home/alexv/doctest/catkin_ws/install/lib/pyros_test/emptyService.py
    -- Installing: /home/alexv/doctest/catkin_ws/install/lib/pyros_test/slowService.py
    -- Installing: /home/alexv/doctest/catkin_ws/install/lib/pyros_test/triggerService.py
    -- Installing: /home/alexv/doctest/catkin_ws/install/lib/pyros_test/common.py
    -- Installing: /home/alexv/doctest/catkin_ws/install/lib/pyros_test/string_pub_node.py
    -- Installing: /home/alexv/doctest/catkin_ws/install/lib/pyros_test/string_pubnot_node.py
    -- Installing: /home/alexv/doctest/catkin_ws/install/lib/pyros_test/string_slow_node.py
    -- Installing: /home/alexv/doctest/catkin_ws/install/lib/pyros_test/string_sub_node.py



- Source the install space::

    $ source install/setup.bash


- Run tests as a final user would::

    **TODO**

Release

- Change to the project directory you want to release::

    $ cd src/pyros-test/

- Generate the changelog::

    $ catkin_generate_changelog
    Found packages: pyros_test
    Querying commit information since latest tag...
    Updating forthcoming section of changelog files...
    - updating './CHANGELOG.rst'
    Done.
    Please review the extracted commit messages and consolidate the changelog entries before committing the files!


- Prepare the release::

    $ catkin_prepare_release

- bloom-release --rosdistro indigo --track indigo pyros_test



**If this is not accurate, if I missed a step, or if there is a better way to do the same, please open a PullRequest or an issue on the catkin_pip repository with the related information so this doc can be corrected**

**TODO : review this with the new catkin tools coming up (ie catkin build)**



Continuous Testing Workflow
===========================

Because no software works until it has been tested, you should configure travis on your repository to run test with each commit and pull request.

Catkin testing can be done with a simple `.travis.yml` file and a small shell script.


