#!/usr/bin/python

# here we need to validate that everything is properly done when running "make install" from the build environment.
import os
import subprocess


def test_install():
    # The devel environment should already be setup when calling for tests
    assert 'ROS_DISTRO' in os.environ
    cwd = os.getcwd()
    assert cwd
    installation = subprocess.check_output("make install", shell=True, cwd=cwd)
    # doing our best to catch a potential error, displaying the output if there is any problem
    assert 'error:' not in installation, installation
    assert 'CMake Error' not in installation, installation
    assert 'make: *** [install] Error ' not in installation, installation

