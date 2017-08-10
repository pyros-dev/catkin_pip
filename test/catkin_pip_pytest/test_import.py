from __future__ import absolute_import
from __future__ import print_function

import os
import sys
import importlib


# If all package dependencies are in the sys.path, we can import them
def test_dynamic_import_devel_space_pkgs():
    importlib.import_module('click')  # dependency from python_boilerplate


# If all packages are in the sys.path, we can import them
def test_dynamic_import_devel_pkg():
    importlib.import_module('mypippkg')
    importlib.import_module('nameless')
    importlib.import_module('python_boilerplate')
    importlib.import_module('cookiecutter_pypackage_minimal')


# If all catkin_pip dependencies are in the sys.path, we can import them
def test_dynamic_import_catkin_pip_env_pkgs():
    importlib.import_module('setuptools')
    importlib.import_module('pip')
    importlib.import_module('nose')
    importlib.import_module('pytest')
