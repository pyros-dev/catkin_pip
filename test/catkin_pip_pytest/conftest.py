import os
import sys
import pytest


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
