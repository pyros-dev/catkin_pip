#!/usr/bin/env python

from setuptools import setup

setup(name='setuptools_setup',
      version='0.0.1',
      description='A python package that manages setup.py with setuptools.',
      author='AlexV',
      author_email='asmodehn@gmail.com',
      install_requires=['pytest'],  # since we are using it for testing inside this package
      # It will be installed by rosdep, and installation on devel space will depend on --ignore-installed option,
      # but it would NOT be installed on install space.
      # Yet the travis check will work, by using the one installed previously on the system by rosdep.
      packages=['sstest', 'sstest.test'],
     )

