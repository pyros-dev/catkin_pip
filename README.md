catkin_pure_python
==================

Provides catkin extension (cmake hooks) to work with pure python packages in catkin workspaces.
Because [idiomatic python](http://jeffknupp.com/blog/2013/08/16/open-sourcing-a-python-project-the-right-way/) should be working with catkin.

* catkin_npm_update_target()
* catkin_npm_update_once()

* Example
```
...
find_package(catkin REQUIRED catkin_pure_python)

catkin_npm_update_once()

catkin_package()
...
```


