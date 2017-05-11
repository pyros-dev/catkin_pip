import os
import pytest


def test_pytest():
    # making sure we use pytest from system packages, installed by rosdep for install tests
    if os.environ.get('ROS_FLOW') == 'install':
        assert pytest.__file__ == '/usr/lib/python2.7/dist-packages/pytest.pyc', pytest.__file__
    else:
        # and the one installed in devel space otherwise
        assert 'devel/lib/python2.7/site-packages/pytest.pyc' in pytest.__file__


def test_content():
    # makes sure everything is there
    file_abs_path = __file__
    test_pkg_abs_path = os.path.dirname(file_abs_path)
    pkg_abs_path = os.path.dirname(test_pkg_abs_path)

    assert 'lib/python2.7/site-packages' or 'lib/python2.7/dist-packages' in pkg_abs_path
    assert os.path.exists(os.path.join(pkg_abs_path, '__init__.py'))
    assert os.path.exists(os.path.join(test_pkg_abs_path, '__init__.py'))


def test_installed():
    # make sure we are installed properly
    file_abs_path = __file__
    test_pkg_abs_path = os.path.dirname(file_abs_path)
    pkg_abs_path = os.path.dirname(test_pkg_abs_path)
    if not any(pkgdir in pkg_abs_path for pkgdir in ['site-packages', 'dist-packages']):  # we assume we are in an installed package
        raise pytest.xfail("this is not an installed package")

    # check we have an *.egg-info along side us (it means we are not inside an egg)
    assert os.path.exists(os.path.join(os.path.dirname(pkg_abs_path), 'setuptools_setup-0.0.1-py2.7.egg-info'))

    # check there is no easy_install.pth or site.py, like for a normal install
    assert not os.path.exists(os.path.join(os.path.dirname(pkg_abs_path), 'easy-install.pth'))
    assert not os.path.exists(os.path.join(os.path.dirname(pkg_abs_path), 'site.py'))

    # TODO : add more, enough to make sure our package is installed as catkin expects it (without pip tracking version we should be useing --single-version-externally-managed)