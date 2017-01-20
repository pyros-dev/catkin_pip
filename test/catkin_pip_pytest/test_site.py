from __future__ import absolute_import
from __future__ import print_function

import os
import sys
import site


# TODO : is this really useful ?
# we are not using any feature of site module itself (currently at least, and API is quite limited...)
def test_site():
    for p in site.getsitepackages():
        assert p in sys.path, "site packages directory {p} not found in {sys.path}".format(**locals())
