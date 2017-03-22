import os
import sys
import pytest

# Imports CANNOT be in fixtues (pytest would cleanup modules, preventing re-import...)
import pyros_setup


def pytest_addoption(parser):
    parser.addoption("--build-dir", action="store", default="build", help="the build directory")


@pytest.fixture
def build_dir(request):
    return request.config.getoption("--build-dir")


@pytest.fixture
def build_dir(request):
    # current dir should be the build directory (binary dir for cmake)
    # otherwise cmake tests commands are broken
    return os.getcwd()


@pytest.fixture
def catkin_pip_env_dir(request):
    # lets find catkin_pip_env space in current dir (cwd should be the build directory)
    # expected setup.sh
    cpe = os.path.join(build_dir(request), 'catkin_pip_env')
    return cpe


@pytest.fixture
def git_working_tree(request):

    mod_path_split = os.path.abspath(__file__).split(os.sep)
    # file should be absolute : we replace the first term
    if mod_path_split[0] == '':
        mod_path_split[0] = os.sep
    #print(mod_path_split)

    last_idx = len(mod_path_split) - 2
    #print(mod_path_split[:-last_idx])

    # lets find the git working tree
    while not os.path.exists(os.path.join(*(mod_path_split[:-last_idx] + ['.git']))) and last_idx > 0:
        last_idx -= 1

    assert last_idx > 0, "No git working tree found while walking up to {0}".format(os.path.join(*mod_path_split))
    gs = os.path.join(*(mod_path_split[:-last_idx]))

    return gs


@pytest.fixture
def devel_space():
    # lets find devel space in current dir (cwd should be the build directory)
    # expected setup.sh
    assert os.path.exists(os.path.abspath(os.path.join('devel', 'setup.sh'))), "devel/setup.bash not found in {0}".format(os.getcwd())
    ws = os.path.abspath('devel')
    return ws


@pytest.fixture
def install_space():
    # lets find devel space in current dir (cwd should be the build directory)
    # expected setup.sh
    assert os.path.exists(os.path.abspath(os.path.join('install', 'setup.sh'))), "install/setup.bash not found in {0}".format(os.getcwd())
    ws = os.path.abspath('install')
    return ws

@pytest.fixture
def pyros():
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

    print("sys.path before pyros_setup {pyros_setup.__file__} :\n{sys.path}".format(**globals()))

    # We need to pass the proper workspace here
    pyros_setup.configurable_import().configure({
        'WORKSPACES': [
            devel_space()
        ],  # This should be the same as pytest devel_space fixture
        'DISTRO': pyros_setup.DETECTED_DISTRO,
    }).activate()

    # We cannot move pyros_setup outside the fixture (pytest would clean it up and break module imports)
