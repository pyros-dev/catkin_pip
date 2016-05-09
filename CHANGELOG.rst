^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Changelog for package catkin_pure_python
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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
* Merge pull request `#2 <https://github.com/asmodehn/catkin_pure_python/issues/2>`_ from asmodehn/install_rules
  Install rules
* improve pip finding. fixed install.
* restructuring to get install running same code as devel
* adding git ignore and cmake file for building mypippkg test
* removed ROS dependency on cookiecutter since we need to get it from pip.
* added travis build status
* fixing default argument for catkin_pip_package
  fixing catkin_pure_python test build.
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
