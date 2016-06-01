Valdating catkin_pip
============================

This directory aims at gathering tests to validate the behavior of catkin_pip by :
* working with __unmodified__ state of the art python packages
* "building" them (in catkin terminology) 
* make sure we can use them (somehow - run tests)

TODO : We should also use cookiecutter to get pure python package structure and make sure it also works with catkin.
If not we should provide here the required tools to make it so (not attempt to modify the python package structure).

Project examples to use :
* [cookiecutter-pipproject](https://github.com/wdm0006/cookiecutter-pipproject)
* [cookiecutter-pypackage-minimal](https://github.com/kragniz/cookiecutter-pypackage-minimal) 
* [cookiecutter-pypa](https://github.com/audreyr/cookiecutter-pypackage)
*
* TODO : find more python package references
* TODO : add a ros package to prove it doesnt disturb normal ros process either (at least not too much...).

More tests will be added when we find more use cases that fit catkin_pip purpose



