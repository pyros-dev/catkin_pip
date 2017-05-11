^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Changelog for package catkin_pip
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

0.2.1 (2017-05-11)
------------------
* Merge pull request `#115 <https://github.com/asmodehn/catkin_pip/issues/115>`_ from asmodehn/distutils
  Implementing distutils support
* refining tests on install flow, to confirm which test framework is used.
  upgrading catkin package format to advised format 2.
* fixes to support distutils as well as setuptools.
* adding setuptools_setup test project and tests to validate package structure after installation.
* adding test to make sure "make install" does not trigger errors.
* adding a basic package to test distutils based setup.py
* Contributors: AlexV, yotabits

0.2.0 (2017-03-17)
------------------
* removing dependency on daemontools (not available on fedora)
* setlock -> flock
* Merge pull request `#95 <https://github.com/asmodehn/catkin_pip/issues/95>`_ from k-okada/install_data
  data should not install right under the CMAKE_INSTALL_PREFIX
* fixing syntax for ros distro autodetection when building this package.
* Merge pull request `#97 <https://github.com/asmodehn/catkin_pip/issues/97>`_ from asmodehn/gopher-devel
  Preparing next release 0.2
* install data
* Contributors: AlexV, Kei Okada, alexv

* Merge branch 'devel' into gopher-devel
* now using catkin_pip_runcmd to retrieve cookiecutter package samples.
* removing install envhook. seems to break things.
  we dont want the install envhook to be created for catkin_pip since the target build env does not exist.
* Merge pull request `#61 <https://github.com/asmodehn/catkin_pip/issues/61>`_ from asmodehn/refactor_envs
  Refactor envs
* adding docs to make decision clear regarding catkin / pyros_setup behavior.
* fixing up install devel command since we do not pass editable pkg path into pythonpath anymore.
* Merge branch 'gopher-devel' into refactor_envs
* Merge pull request `#76 <https://github.com/asmodehn/catkin_pip/issues/76>`_ from asmodehn/easyinstall_fix
  Easyinstall fix
* commenting install tests... we dont have any.
* always adding the catkin_pip_env path to pythonpath to be able to find basic tools from the first time around.
* envhooks now not adding to pythonpath from pth files. too confusing.
  envhooks now not adding non existent paths to pythonpath. maybe good idea to match site module behavior.
  fixing tests.
* improved tests. added test for check with pyros_setup and interractive debugging
* fixed broken tests. now needs pyros-setup to get .pth paths before workspaces.
  cosmetics.
* improved tests and fix all.
  added actual test for pytest to pipproject.
* cleaning up command args when running pip install --editable to clean python path and workaround pip bug...
* replacing CI_ROS_DISTRO var by ROS_DISTRO, to have it set for calls to rosdep.
* more exhaustive test for sys_path
* commenting echoes from script since it cannot echo without breaking things anyway.
* reviewing shell script to make them a tiny more robust...
* removed useless bash envhook, fixed easy-install parse to include last line even if no empty line at end of file.
* Merge pull request `#77 <https://github.com/asmodehn/catkin_pip/issues/77>`_ from asmodehn/pyup-update-pytest-3.0.5-to-3.0.6
  Update pytest to 3.0.6
* Merge pull request `#86 <https://github.com/asmodehn/catkin_pip/issues/86>`_ from asmodehn/pyup-update-cookiecutter-1.5.0-to-1.5.1
  Update cookiecutter to 1.5.1
* Update cookiecutter from 1.5.0 to 1.5.1
* moved rosdep install out of catkin_pip, only used for tests.
  temporarily skipping broken test because of pip behavior...
* improved concurrency handling for pip by using setlock from daemontools.
  improved status message output.
* adding libssl-dev as dependency forpypackage
* adding catkin_pip function to call rosdep install. attempting fix for pypackage tests.
* adding libffi-dev as build_depend for python_boilerplate
* API changed ! redesigned workflow by doing "pip install -e package" during make stage instead of configure. All tests passing.
* Update pytest from 3.0.5 to 3.0.6
* reverted to pip 8.1.2
  changes added in prevision of switching to pip 9.X when --ignore-installed working...
* added comment about sourcing install/setup.bash
* improved test cases to check the content of easy-install.pth
* adding cookiecutter pypackage-minimal for tests
* adding cookiecutter pypackage for tests
* adding cookiecutter pylibrary for testing
* adding result of investigation for unexpected dist-packages in sys.path tail... still WIP
* now handling environment setup only via catkin_env from env-hooks.
  made pure sh envhook to allow implementing other shells.
* WIP refactoring how we setup configure / build / devel/ install enironments
* improved path_prepend shell script
* Contributors: AlexV, alexv, pyup-bot

* removing install envhook. seems to break things.
  we dont want the install envhook to be created for catkin_pip since the target build env does not exist.
* Merge pull request `#61 <https://github.com/asmodehn/catkin_pip/issues/61>`_ from asmodehn/refactor_envs
  Refactor envs
* adding docs to make decision clear regarding catkin / pyros_setup behavior.
* fixing up install devel command since we do not pass editable pkg path into pythonpath anymore.
* Merge branch 'gopher-devel' into refactor_envs
* Merge pull request `#76 <https://github.com/asmodehn/catkin_pip/issues/76>`_ from asmodehn/easyinstall_fix
  Easyinstall fix
* commenting install tests... we dont have any.
* always adding the catkin_pip_env path to pythonpath to be able to find basic tools from the first time around.
* envhooks now not adding to pythonpath from pth files. too confusing.
  envhooks now not adding non existent paths to pythonpath. maybe good idea to match site module behavior.
  fixing tests.
* improved tests. added test for check with pyros_setup and interractive debugging
* fixed broken tests. now needs pyros-setup to get .pth paths before workspaces.
  cosmetics.
* improved tests and fix all.
  added actual test for pytest to pipproject.
* cleaning up command args when running pip install --editable to clean python path and workaround pip bug...
* replacing CI_ROS_DISTRO var by ROS_DISTRO, to have it set for calls to rosdep.
* more exhaustive test for sys_path
* commenting echoes from script since it cannot echo without breaking things anyway.
* reviewing shell script to make them a tiny more robust...
* removed useless bash envhook, fixed easy-install parse to include last line even if no empty line at end of file.
* moved rosdep install out of catkin_pip, only used for tests.
  temporarily skipping broken test because of pip behavior...
* improved concurrency handling for pip by using setlock from daemontools.
  improved status message output.
* adding libssl-dev as dependency forpypackage
* adding catkin_pip function to call rosdep install. attempting fix for pypackage tests.
* adding libffi-dev as build_depend for python_boilerplate
* API changed ! redesigned workflow by doing "pip install -e package" during make stage instead of configure. All tests passing.
* reverted to pip 8.1.2
  changes added in prevision of switching to pip 9.X when --ignore-installed working...
* added comment about sourcing install/setup.bash
* improved test cases to check the content of easy-install.pth
* adding cookiecutter pypackage-minimal for tests
* adding cookiecutter pypackage for tests
* adding cookiecutter pylibrary for testing
* adding result of investigation for unexpected dist-packages in sys.path tail... still WIP
* now handling environment setup only via catkin_env from env-hooks.
  made pure sh envhook to allow implementing other shells.
* WIP refactoring how we setup configure / build / devel/ install enironments
* improved path_prepend shell script
* Contributors: AlexV, alexv

0.1.18 (2017-03-04)
-------------------
* Pin pytest to latest version 3.0.5
* Pin pytest-timeout to latest version 1.2.0
* Pin nose to latest version 1.3.7
* Pin pytest-cov to latest version 2.4.0
* Pin cookiecutter to latest version 1.5.0
* adding pyup checks for dependencies
* Contributors: AlexV, alexv, pyup-bot

0.1.17 (2017-01-13)
-------------------
* now always ignore-installed when installing requirements.
* pinned pip to 8.1.2 because of https://github.com/asmodehn/catkin_pip/issues/58
* Merge pull request `#57 <https://github.com/asmodehn/catkin_pip/issues/57>`_ from asmodehn/devel
  upgrading gopher_devel
* Merge pull request `#56 <https://github.com/asmodehn/catkin_pip/issues/56>`_ from asmodehn/gopher-devel
  drop some echoing
* drop some echoing
* Contributors: AlexV, Daniel Stonier, alexv

0.1.16 (2016-09-05)
-------------------
* now also checking for --system for pip > 6.0.0.
* small improvements for travis checks
* Contributors: AlexV, alexv

0.1.15 (2016-09-01)
-------------------
* now transferring paths from pth in devel site-packages to pythonpath shell env, to handle egg-link and workspace overlaying together...
* adding current devel space dist-packages via envhook to get it even if env not sourced... is it a good idea ?
* officially not supporting broken old pip on EOL saucy.
* Contributors: AlexV, alexv

0.1.14 (2016-08-30)
-------------------
* Merge pull request `#44 <https://github.com/asmodehn/catkin_pip/issues/44>`_ from asmodehn/pip_system
  Now checking for pip --system option before using.
* Now checking for pip --system option before using.
  cleanup some cmake status messages.
* improving pip detection
* Contributors: AlexV, alexv

0.1.13 (2016-08-28)
-------------------
* fixing install rule for moved script.
* getting rid of rospack dependency. didnt always work.
  moved pythonpath_prepend shell script to use it via cmake variable.
* now checking system pip version to choose command line arguments for setup
* Contributors: AlexV

0.1.12 (2016-08-27)
-------------------
* Merge pull request `#40 <https://github.com/asmodehn/catkin_pip/issues/40>`_ from asmodehn/env_hooks
  Env hooks
* Merge pull request `#39 <https://github.com/asmodehn/catkin_pip/issues/39>`_ from asmodehn/include_seq
  preventing multiple includes, reviewing variable scope.
* preventing multiple includes, reviewing variable scope.
* Merge branch 'devel' of https://github.com/asmodehn/catkin_pip into env_hooks
  # Conflicts:
  #	CMakeLists.txt
  #	cmake/catkin-pip.cmake.in
  #	cmake/env-hooks/42.site_packages.bash.develspace.in
* Updated README
* Merge pull request `#33 <https://github.com/asmodehn/catkin_pip/issues/33>`_ from asmodehn/install_no_deps
  first implementation of --no-deps to no install a package dependencie…
* Merge pull request `#35 <https://github.com/asmodehn/catkin_pip/issues/35>`_ from asmodehn/kinetic-devel
  fixing pip upgrade for kinetic, based on ROS_DISTRO env var.
* requirements now correctly loading catkin-pip build/catkin_pip_env.
  now avoiding to load catkin-pip-requirements by itself.
* fixing check of envvar ROS_DISTRO from cmake configure to decide which pip command to run
* fixing rospack call. passing travis matrix env vars via shell command since docker run vars break on exec call.
* now passing travis matrix env vars to container.
* adding apt-get update call. also install sudo as not installed by default on xenial and required by rosdep.
  cosmetics
* using docker cp instead of volume to workaround docker/travis bug.
* removing volume to $HOME in case it is the cause of docker breaks.
* travis_checks script now change to its directory as first step.
  fixed some docker commands.
* fixing ros image name, container_name.
  added rosdep comand to get dependencies.
* changing travis to use docker to test multiple distro.
* fixing pip upgrade for kinetic, based on ROS_DISTRO env var.
* Restructured documentation
* started new doc structure
* documentation improvements
* adding doc as reference for basic catkin build release flow
* first implementation of --no-deps to no install a package dependencies via pip. helps confirm rosdep dependencies
* now using simplified sh env_hook
* Contributors: AlexV, alexv

0.1.11 (2016-08-11)
-------------------
* added description of the catkin_pip build flow
* we might not need the install envhook after all.
  correct setuptools is found via path in install script.
  correct tools for test or other should be found via path in generated scripts, and used via catkin/make commands.
* added warning in pycharm setup doc.
* added first draft of pycharm setup doc
* improved workflow doc with pointer to example package repos.
* adding documentation for 3 ros-python workflows enabled by catkin_pip
* improving documentation
* disabling tests check from travis on install since mypippkg doesnt have any yet.
* fixing travis_checks to run our pytest version from catkin_pip_env
* cleaning up doc, installing ros-base in travis install step.
* adding specific script for travis checks.
  added basic doc structure.
* new travis build flow to split devel and install flow and avoid one unwanted interferences.
* Contributors: alexv

0.1.10 (2016-08-09)
-------------------
* added rospack dependency
* (Re)adding site-packages folder creation in devel workspace.
* setup of catkin_pip environment also adds the workspace site-packages to the python path to get it ready for use, even if envhook was not used before.
* Merge pull request `#28 <https://github.com/asmodehn/catkin_pip/issues/28>`_ from asmodehn/separate_catkin_pip_env
  separating catkin_pip environment with workspace environment.
* making sure env-hooks have all variables setup before adding.
* separating catkin_pip environment with workspace environment.
  added envhook for loading caktin_pip env on installspace.
  removing install script for python on windows for now (outdated).
* Contributors: AlexV, alexv

0.1.9 (2016-06-24)
------------------
* fixed site_packages env-hook.
  bash script seems to work fine after all, the problem was somewhere else.
  simplified the envhook flow between catkin, package, overlay.
* changed site-packages env-hook to have .sh extension.
  moving prepend function into catkin-pip package itself.
* Contributors: alexv

0.1.8 (2016-06-06)
------------------
* fix nose and pytest test runners to launch from pip latest install by catkin-pip.
* fix PYTHONPATH manipulation to prepend a path.
  not adding /opt/ros/<distro> to the path since original catkin will take care of that.
* Contributors: AlexV

0.1.7 (2016-06-05)
------------------
* fixed site-packages env-hook to install with catkin-pip and not built project, and to be activated only in devel space.
* Contributors: AlexV

0.1.6 (2016-06-05)
------------------
* improving python_install templates to match original version more...
* improving python install script to pass only one --root option
* Contributors: AlexV, alexv

0.1.5 (2016-06-03)
------------------
* removing subdir in cfg_extra because of https://github.com/ros/catkin/issues/805
* Contributors: alexv

0.1.4 (2016-06-02)
------------------
* adding pytest as a test runner.
  now using our nose in nosetests (instead of sytem one)
  small fixes.
* now travis building on jade as well
* Contributors: AlexV, alexv

0.1.3 (2016-06-01)
------------------
* renaming catkin_pure_python to catkin_pip for clarity
* Contributors: alexv

0.1.2 (2016-05-30)
------------------
* fixing python_setuptools_install templates location and permissions
* Contributors: alexv

0.1.1 (2016-05-30)
------------------
* fixing catkin_pip_runcmd for package, hopefully.
* Contributors: AlexV

0.1.0 (2016-05-29)
------------------
* separating catkin_pip_setup and catkin_package macros.
* now ignoring installed pip packaging when fetching requirements for pipproject.
* removing debug output for shell envhook
* fixing install procedure to get same structure as the distutils version.
* now catkin-pip package is using normal catkin_package(), and installs fine, although with setuptools, which might break packaging...
* refactoring cmake include and configure. test project devel space ok. the rest is still broken...
* small improvement to do less configuration
* now using an envhook to modify pythonpath instead of hacking catkin's _setup_util.py
* _setup_util.py hack now done in cmake binary dir instead of final workspace.
* Contributors: AlexV, alexv

0.0.8 (2016-05-10)
------------------
* not writing cmake files into workspace anymore. instead in build directory of each package.
* added doc about pip/ros dependency handling.
* Contributors: alexv

0.0.7 (2016-05-09)
------------------
* removing --ignore-installed for editable package, to allow requirements to satisfy setup.py dependencies.
* changing package to format v2
* Contributors: alexv

0.0.6 (2016-04-29)
------------------
* adding --ignore-installed to avoid pip picking up local editable package when installing.
* informative comments
* better fix for catkin-pip requirements not found in workspace path
* fixing travis to run tests for catkin-pip
* Contributors: alexv

0.0.5 (2016-04-26)
------------------
* fix catkin-pip requirements not found in workspace path
* typo
* Contributors: alexv

0.0.4 (2016-04-08)
------------------
* Merge remote-tracking branch 'origin/indigo' into indigo
* now prepending site-packages path. also for install space.
* Contributors: alexv

0.0.3 (2016-04-07)
------------------
* small refactor to improve cmake messages
* now specifying source director and exists-action backup when installing requirements.
  restored previous behavior to check for installed packages before installing current package. this avoid reinstalling dependencies satisfied by requirements.
* always cleaning cache for catkin_pip for safety.
* added --ignore-installed so pip doesnt try to remove old packages from system.
  quick Readme Roadmap
* Contributors: alexv

0.0.2 (2016-04-04)
------------------
* cleaning up cmake ouput. fixing install sys pip path and pippkg path.
* Merge pull request `#2 <https://github.com/asmodehn/catkin_pip/issues/2>`_ from asmodehn/install_rules
  Install rules
* improve pip finding. fixed install.
* restructuring to get install running same code as devel
* adding git ignore and cmake file for building mypippkg test
* removed ROS dependency on cookiecutter since we need to get it from pip.
* added travis build status
* fixing default argument for catkin_pip_package
  fixing catkin_pip test build.
* attempting to fix nose and tests...
* improved environment detection and setup.
* improved readme
* fixed changelog
* Contributors: AlexV

0.0.1 (2016-03-31)
------------------
* fixing install rules.
  improving pip download by using cache for catkin-pip requirements.
* now devel workspace populated with latest pip.
* first version of package. still trying stuff out...
* Contributors: AlexV
