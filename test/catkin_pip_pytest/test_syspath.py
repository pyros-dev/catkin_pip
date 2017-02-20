from __future__ import absolute_import
from __future__ import print_function

import os
import sys
import pytest
import importlib


def in_sys_path_ordered(*arg_paths):
    """
    asserts that path1 is before path2 in sys.path
    :param arg_paths: the arguments are a list of path
    :return: True if all paths appear in sys.path, and in the arguments order. False otherwise.
    """
    return all(p in sys.path for p in arg_paths) and \
           all([sys.path.index(p) < sys.path.index(q) for p, q in zip(arg_paths,arg_paths[1:])]
               if len(arg_paths) else True)


def test_devel_space_in_sys_path(devel_space):
    print(sys.path)

    # Verifying relative path order
    assert in_sys_path_ordered(
        os.path.join(devel_space, 'lib/python2.7/site-packages'),
        os.path.join(devel_space, 'lib/python2.7/dist-packages'),
    ), "{site_pkgs} not appearing before {dist_pkgs} in sys.path".format(
        site_pkgs=os.path.join(devel_space, 'lib/python2.7/site-packages'),
        dist_pkgs=os.path.join(devel_space, 'lib/python2.7/dist-packages')
    )


def test_catkin_pip_env_dir_in_sys_path(catkin_pip_env_dir):
    print(sys.path)

    # Verifying relative path order
    assert in_sys_path_ordered(
        os.path.join(catkin_pip_env_dir, 'lib/python2.7/site-packages'),
    ), "{site_pkgs} not appearing in sys.path".format(
        site_pkgs=os.path.join(catkin_pip_env_dir, 'lib/python2.7/site-packages')
    )


def test_sys_path_editable(git_working_tree, devel_space):
    print(sys.path)

    def pkg_path_in_sys_path(pkg_path, before=[]):
        assert os.path.exists(pkg_path), "{pkg_path} does not exist".format(**locals())

        # By default the egg-links path are added after the pythonpaths.
        # We need opposite behavior for ROS python (due to how devel workspace works)
        # this is handle by both catkin_pip for ROS usage and pyros_setup for python usage.

        assert in_sys_path_ordered(*([pkg_path] + before)),\
            "paths not appearing in sys.path in the expected order : {p}".format(p=([pkg_path] + before))

    # Verifying the pip editable installed package location is in python path
    for python_pkg in [
        os.path.join('pipproject', 'mypippkg'),
        os.path.join('pylibrary', 'python-nameless', 'src'),
        os.path.join('pypackage', 'python_boilerplate'),
        os.path.join('pypackage-minimal', 'cookiecutter_pypackage_minimal'),
    ]:

        ss = os.path.join(git_working_tree, 'test', python_pkg)

        pkg_path_in_sys_path(ss, [
            os.path.join(devel_space, 'lib/python2.7/site-packages'),
            os.path.join(devel_space, 'lib/python2.7/dist-packages')
        ])
