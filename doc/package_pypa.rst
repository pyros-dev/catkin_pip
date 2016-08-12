Package structure for Python
============================

Ref : https://packaging.python.org/

There have been historically many ways to package and distribute python code.
While many of these are still usable, we are focusing here on the python packaging authority way to package python code.

Files hierarchy
---------------


Dependencies
------------

Workflow
--------

This is a description of the generic python workflow to develop, build, test and release a python based package.

- Get the Source ie. clone a Repo.

- Install with pip

- Run tests in current environment with nose or pytest.

- Run tests on multiple python environments with tox.

- Build a distribution

- Release on Pypi with twine

