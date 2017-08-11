catkin_pip release process
==========================

1) Check travis builds are passing

2) `catkin_generate_changelog`

3) git commit -m "updating changelog"

4) `catkin_prepare_release` and optionally bump minor (or major)

5) Double check travis builds are passing

6) `bloom-release` to all the supported ROS distros

7) There is no check enabled on the release repo, since it is just a copy of the source repo.

8) Done ! You can start to use the new version (dont forget to configure your apt to get packages from ros-shadow-fixed)

