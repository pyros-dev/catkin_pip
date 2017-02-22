from __future__ import absolute_import
from __future__ import print_function

import os
import pytest
import sys


"""
This module is a test for catkin_pip.
It is expected to run FROM CMAKE with pytest, from the build directory
Ex : If you ran ./travis_checks.bash that is /home/alexv/Projects/ros_pyros_ws/src/catkin_pip/testbuild
"""


def in_sys_path_ordered(*arg_paths):
    """
    Checks if arg_paths are listed int he same order as in sys.path
    :param arg_paths: the arguments are a list of path
    :return: True if all paths appear in sys.path, and in the arguments order. False otherwise.
    """
    return all(p in sys.path for p in arg_paths) and \
           all([sys.path.index(p) < sys.path.index(q) for p, q in zip(arg_paths, arg_paths[1:])]
               if len(arg_paths) else True)


#
# TESTS
#

def test_catkin_pip_env_dir_in_sys_path(catkin_pip_env_dir):
    print(sys.path)
    assert in_sys_path_ordered(
        os.path.join(catkin_pip_env_dir, 'lib/python2.7/site-packages'),
    ), "{site_pkgs} not appearing in sys.path".format(
        site_pkgs=os.path.join(catkin_pip_env_dir, 'lib/python2.7/site-packages')
    )


def test_devel_site_in_sys_path(devel_space):
    print(sys.path)
    assert in_sys_path_ordered(
        os.path.join(devel_space, 'lib/python2.7/site-packages'),
    ), "{site_pkgs} not in sys.path".format(
        site_pkgs=os.path.join(devel_space, 'lib/python2.7/site-packages')
    )


@pytest.mark.xfail(strict=True, reason="dist-packages does not exist in our example since all packages use catkin_pip")
def test_devel_dist_in_sys_path(devel_space):
    print(sys.path)
    assert in_sys_path_ordered(
        os.path.join(devel_space, 'lib/python2.7/dist-packages'),
    ), "{dist_pkgs} in sys.path".format(
        dist_pkgs=os.path.join(devel_space, 'lib/python2.7/dist-packages')
    )
    1/0


@pytest.mark.xfail(strict=True, reason="dist-packages does not exist in our example since all packages use catkin_pip")
def test_devel_site_before_devel_dist_in_sys_path(devel_space):
    print(sys.path)

    # Verifying relative path order
    assert in_sys_path_ordered(
        os.path.join(devel_space, 'lib/python2.7/site-packages'),
        os.path.join(devel_space, 'lib/python2.7/dist-packages'),
    ), "{site_pkgs} not appearing before {dist_pkgs} in sys.path".format(
        site_pkgs=os.path.join(devel_space, 'lib/python2.7/site-packages'),
        dist_pkgs=os.path.join(devel_space, 'lib/python2.7/dist-packages')
    )


def test_devel_site_before_catkin_pip_site_in_sys_path(catkin_pip_env_dir, devel_space):
    print(sys.path)
    assert in_sys_path_ordered(
        os.path.join(devel_space, 'lib/python2.7/site-packages'),
        os.path.join(catkin_pip_env_dir, 'lib/python2.7/site-packages'),
    ), "{site_pkgs} not appearing before {catkin_pkgs} in sys.path".format(
        site_pkgs=os.path.join(devel_space, 'lib/python2.7/site-packages'),
        catkin_pkgs=os.path.join(catkin_pip_env_dir, 'lib/python2.7/site-packages')
    )


@pytest.mark.xfail(strict=True, reason="dist-packages does not exist in our example since all packages use catkin_pip")
def test_devel_dist_before_catkin_pip_site_in_sys_path(catkin_pip_env_dir, devel_space):
    print(sys.path)
    assert in_sys_path_ordered(
        os.path.join(devel_space, 'lib/python2.7/dist-packages'),
        os.path.join(catkin_pip_env_dir, 'lib/python2.7/site-packages'),
    ), "{dist_pkgs} not appearing before {catkin_pkgs} in sys.path".format(
        dist_pkgs=os.path.join(devel_space, 'lib/python2.7/dist-packages'),
        catkin_pkgs=os.path.join(catkin_pip_env_dir, 'lib/python2.7/site-packages')
    )

