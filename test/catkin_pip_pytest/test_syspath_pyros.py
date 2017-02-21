from __future__ import absolute_import
from __future__ import print_function

import pytest
import sys

"""
This module is a test for catkin_pip, with pyros_setup.
It is expected to run DIRECTLY with pytest, from the build directory
Ex : If you ran ./travis_checks.bash that is /home/alexv/Projects/ros_pyros_ws/src/catkin_pip/testbuild

It is here to make testing/debugging sys.path issues from IDE easier :
- run ./travis_checks
- setup a test target (careful with the working directory)
- run it (and you can debug inside...)

Note however that this test module is run with catkin_pip tests as well
to make sure pyros_setup fixes our catkin import problems.
"""

from . import test_syspath

#
# Tests importing pyros_setup via fixture and automatically setting configuration
# All these should PASS in any case.
#


@pytest.mark.xfail(reason="this has no meaning without catkin_pip, since pyros_setup does not rely and has no knowledge of catkin_pip")
def test_catkin_pip_env_dir_in_sys_path(catkin_pip_env_dir):
    return test_syspath.test_catkin_pip_env_dir_in_sys_path(catkin_pip_env_dir)


def test_devel_site_in_sys_path(pyros, devel_space):
    return test_syspath.test_devel_site_in_sys_path(devel_space)


# this fails since dist-packages does not exists
@pytest.mark.xfail(reason="dist-packages does not exist in our example since all packages use catkin_pip")
def test_devel_dist_in_sys_path(pyros, devel_space):
    return test_syspath.test_devel_dist_in_sys_path(devel_space)


# this fails since dist-packages does not exists
@pytest.mark.xfail(strict=True, reason="dist-packages does not exist in our example since all packages use catkin_pip")
def test_devel_site_before_devel_dist_in_sys_path(pyros, devel_space):
    return test_syspath.test_devel_site_before_devel_dist_in_sys_path(devel_space)


@pytest.mark.xfail(reason="this has no meaning without catkin_pip, since pyros_setup does not rely and has no knowledge of catkin_pip")
def test_devel_site_before_catkin_pip_site_in_sys_path(pyros, catkin_pip_env_dir, devel_space):
    return test_syspath.test_devel_site_before_catkin_pip_site_in_sys_path(catkin_pip_env_dir, devel_space)


@pytest.mark.xfail(reason="this has no meaning without catkin_pip, since pyros_setup does not rely and has no knowledge of catkin_pip")
def test_devel_dist_before_catkin_pip_site_in_sys_path(pyros, catkin_pip_env_dir, devel_space):
    return test_syspath.test_devel_dist_before_catkin_pip_site_in_sys_path(catkin_pip_env_dir, devel_space)


# Using Pyros_setup is the only way to get this to work as expected.
# That is getting devel packages in sys.path before ROS workspaces from PYTHONPATH.
def test_sys_path_editable(pyros, git_working_tree, devel_space):
    return test_syspath.test_sys_path_editable(git_working_tree, devel_space)
