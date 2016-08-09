^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Changelog for package catkin_pip
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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
