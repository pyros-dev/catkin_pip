from __future__ import absolute_import
from __future__ import print_function

import pytest

"""
This module is a test for catkin_pip, with pyros_setup.
It is expected to run DIRECTLY with pytest, from the build directory
Ex : If you ran ./travis_checks.bash that is /home/alexv/Projects/ros_pyros_ws/src/catkin_pip/testbuild

It is here to make testing/debugging sys.path issues from IDE easier :
- run ./travis_checks
- setup a test target (careful with the working directory)
- run it (and you can debug inside...)
"""

from . import test_syspath
from . import conftest

# IMPORTANT : Without pyros_setup configuration activated,
# the develop packages are set in sys.path AFTER the site-packages and dist-packages
# This is because of incompatibilities between ROS and python ways of handling PYTHONPATH.
# It is usually not a problem, unless :
#  - you are working in a devel space with catkin_pip and expect to use a editable package from there
#  - you have the same package installed somewhere else in the PYTHONPATH
#    And in that case it might end up being *before* the source dir in sys.path
#
# => Without pyros_setup, the installed version will be preferred
# This is the python (and tools) way of working, since PYTHONPATH purpose is to override file-based setup,
# like editable packages.
#
# => With pyros_setup, the devel version will be preferred
# This is the ROS way of working, since PYTHONPATH order determine the order of folder when looking for a package.
#
# Both will work fine in most cases, but one might want to keep this corner case in mind...

import pyros_setup

# Getting devel_space path using fixture by
devel_space = conftest.devel_space()

# We need to pass the proper workspace here
pyros_setup.configurable_import().configure({
    'WORKSPACES': [
        devel_space
    ],  # This should be the same as pytest devel_space fixture
    'DISTRO': pyros_setup.DETECTED_DISTRO,
}).activate()


#
# Tests after importing pyros_setup and automatically setting configuration
# All these should PASS in any case.
#


# this test would have no meaning with pyros_setup, since pyros_setup does not rely and has no knowledge of catkin_pip
# def test_catkin_pip_env_dir_in_sys_path(catkin_pip_env_dir):
#     return test_syspath.test_catkin_pip_env_dir_in_sys_path(catkin_pip_env_dir)


def test_devel_site_in_sys_path(devel_space):
    return test_syspath.test_devel_site_in_sys_path(devel_space)


# this fails since dist-packages does not exists
@pytest.mark.xfail(reason="dist-packages does not exist in our example since all packages use catkin_pip")
def test_devel_dist_in_sys_path(devel_space):
    return test_syspath.test_devel_dist_in_sys_path(devel_space)


# this fails since dist-packages does not exists
@pytest.mark.xfail(strict=True, reason="dist-packages does not exist in our example since all packages use catkin_pip")
def test_devel_site_before_devel_dist_in_sys_path(devel_space):
    return test_syspath.test_devel_site_before_devel_dist_in_sys_path(devel_space)

# this test would have no meaning with pyros_setup, since pyros_setup does not rely and has no knowledge of catkin_pip
# def test_devel_site_before_catkin_pip_site_in_sys_path(catkin_pip_env_dir, devel_space):
#     return test_syspath.test_devel_site_before_catkin_pip_site_in_sys_path(catkin_pip_env_dir, devel_space)

# this test would have no meaning with pyros_setup, since pyros_setup does not rely and has no knowledge of catkin_pip
# def test_devel_dist_before_catkin_pip_site_in_sys_path(catkin_pip_env_dir, devel_space):
#     return test_syspath.test_devel_dist_before_catkin_pip_site_in_sys_path(catkin_pip_env_dir, devel_space)


def test_sys_path_editable(git_working_tree, devel_space):
    return test_syspath.test_sys_path_editable(git_working_tree, devel_space)
