import os

def test_content():
    # make sure we are installed
    file_abs_path = __file__
    test_pkg_abs_path = os.path.dirname(file_abs_path)
    pkg_abs_path = os.path.dirname(test_pkg_abs_path)
    assert 'lib/python2.7/site-packages' or 'lib/python2.7/dist-packages' in pkg_abs_path
    assert os.path.exists(os.path.join(pkg_abs_path, '__init__.py'))
    assert os.path.exists(os.path.join(test_pkg_abs_path, '__init__.py'))

    # check we have an *.egg-info along side us (it means we are not inside an egg)
    assert os.path.exists(os.path.join(os.path.dirname(pkg_abs_path), 'distutils_setup-0.0.1.egg-info'))

    # check there is no eays_install.pth or site.py, like for a normal install
    assert not os.path.exists(os.path.join(os.path.dirname(pkg_abs_path), 'easy-install.pth'))
    assert not os.path.exists(os.path.join(os.path.dirname(pkg_abs_path), 'site.py'))

    # TODO : add more, enough to make sure our package is installed as catkin expects it (without pip tracking version we should be useing --single-version-externally-managed)