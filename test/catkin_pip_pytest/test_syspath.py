from __future__ import absolute_import
from __future__ import print_function

import os
import sys
import site


def test_sys_path(devel_space):
    print(sys.path)

    # Verifying relative path order
    if os.path.exists('/opt/ros/indigo/lib/python2.7/dist-packages'):
        assert '/opt/ros/indigo/lib/python2.7/dist-packages' in sys.path, "{p} not in {sp}".format(p='/opt/ros/indigo/lib/python2.7/dist-packages', sp=sys.path)
        # TODO : It seems env_cached.sh append dist-packages path at the end of python_path somehow... We should investigate.
        # HINT : only sourcing /opt/ros/indigo/setup.bash seems fine (dist-packages added at beginning of sys.path)
        # HINT : env_cached.sh seems fine... maybe it comes from the way nosetests/py.test is launched ?
        # HINT : following same process (building and running tests) with rospy_tutorials doesnt show the broken behavior. Something in catkin_pip breaking it ?
        #assert len(sys.path) == len(set(sys.path))  # check unicity of paths

    if os.path.exists(os.path.join(devel_space, 'lib/python2.7/dist-packages')):
        assert os.path.join(devel_space, 'lib/python2.7/dist-packages') in sys.path, "{p} not in {sp}".format(p=os.path.join(devel_space, 'lib/python2.7/dist-packages'), sp=sys.path)
        if os.path.exists('/opt/ros/indigo/lib/python2.7/dist-packages'):
            assert sys.path.index(os.path.join(devel_space, 'lib/python2.7/dist-packages')) < sys.path.index('/opt/ros/indigo/lib/python2.7/dist-packages'), "{p1} not before {p2} in {sp}".format(p1=os.path.join(devel_space, 'lib/python2.7/dist-packages'), p2='/opt/ros/indigo/lib/python2.7/dist-packages', sp=sys.path)

    if os.path.exists(os.path.join(devel_space, 'lib/python2.7/site-packages')):
        assert os.path.join(devel_space, 'lib/python2.7/site-packages') in sys.path, "{p} not in {sp}".format(p=os.path.join(devel_space, 'lib/python2.7/site-packages'), sp=sys.path)

        if os.path.exists(os.path.join(devel_space, 'lib/python2.7/dist-packages')):
            assert sys.path.index(os.path.join(devel_space, 'lib/python2.7/site-packages')) < sys.path.index(os.path.join(devel_space, 'lib/python2.7/dist-packages')), "{p1} not before {p2} in {sp}".format(p1=os.path.join(devel_space, 'lib/python2.7/site-packages'), p2=os.path.join(devel_space, 'lib/python2.7/dist-packages'), sp=sys.path)

        if os.path.exists('/opt/ros/indigo/lib/python2.7/dist-packages'):
            assert sys.path.index(os.path.join(devel_space, 'lib/python2.7/site-packages')) < sys.path.index('/opt/ros/indigo/lib/python2.7/dist-packages'), "{p1} not before {p2} in {sp}".format(p1=os.path.join(devel_space, 'lib/python2.7/site-packages'), p2='/opt/ros/indigo/lib/python2.7/dist-packages', sp=sys.path)


def test_sys_path_editable(git_working_tree, devel_space):
    print(sys.path)

    # Verifying the pip editable installed package location is in python path
    ss = os.path.join(git_working_tree, 'test', 'pipproject', 'mypippkg')

    if os.path.exists(ss):
        assert ss in sys.path, "{p} not in {sp}".format(p=ss, sp=sys.path)

        # Lets keep it simple and rely on python way of handling easy-install.pth and egg-link before we modify it...
        # It seems that by default the eggs path are aded after the pythonpaths...

        # if os.path.exists(os.path.join(devel_space, 'lib/python2.7/site-packages')):
        #     assert sys.path.index(ss) < sys.path.index(os.path.join(devel_space, 'lib/python2.7/site-packages')), "{p1} not before {p2}".format(p1=ss, p2=os.path.join(devel_space, 'lib/python2.7/site-packages'))
        #
        # if os.path.exists(os.path.join(devel_space, 'lib/python2.7/dist-packages')):
        #     assert sys.path.index(ss) < sys.path.index(os.path.join(devel_space, 'lib/python2.7/dist-packages')), "{p1} not before {p2}".format(p1=ss, p2=os.path.join(devel_space, 'lib/python2.7/dist-packages'))
        #
        # if os.path.exists('/opt/ros/indigo/lib/python2.7/dist-packages'):
        #     assert sys.path.index(ss) < sys.path.index('/opt/ros/indigo/lib/python2.7/dist-packages'), "{p1} not before {p2}".format(p1=ss, p2='/opt/ros/indigo/lib/python2.7/dist-packages')


    #TODO : verify the position of the catkin_pip_env paths (bin? and site-packages)
