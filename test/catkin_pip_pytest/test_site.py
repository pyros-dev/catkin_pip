from __future__ import absolute_import
from __future__ import print_function

import os
import sys
import site


def test_site():
    for p in site.getsitepackages():
        assert p in sys.path, "site packages directory {p} not found in {sys.path}".format(**locals())

# TODO : verify that site module behavior (HOW ? API limited,a nd sys.path is taken care of in another test file)

# TODO : verify that "python -m site" from the shell actually would return something, after sourcing setup.sh => HOW ?
