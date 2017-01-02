from __future__ import absolute_import
from __future__ import print_function

import os
import sys
import site


def test_site():
    for p in site.getsitepackages():
        assert p in sys.path, "site packages directory {p} not found in {sys.path}".format(**locals())


def test_extra_paths():
    #print(__file__)
    mod_path_split = os.path.abspath(__file__).split(os.sep)
    # file should be absolute : we replace the first term
    if mod_path_split[0] == '':
        mod_path_split[0] = os.sep
    #print(mod_path_split)

    last_idx = len(mod_path_split) - 2
    #print(mod_path_split[:-last_idx])

    # lets find the git working tree
    while not os.path.exists(os.path.join(*(mod_path_split[:-last_idx] + ['.git']))) and last_idx > 0:
        last_idx -= 1

    assert last_idx > 0, "No git working tree found while walking up to {0}".format(os.path.join(*mod_path_split))
    gs = os.path.join(*(mod_path_split[:-last_idx]))
    # expected the testbuild folder (from travis check script)
    assert os.path.exists(os.path.join(gs, 'testbuild')), "testbuild folder not found in {0}".format(gs)

    assert os.path.exists(os.path.join(gs, 'testbuild', 'devel', 'setup.bash')), "devel/setup.bash not found in {0}".format(gs)
    ws = os.path.join(gs, 'testbuild', 'devel')
    #print(ws)

    print(sys.path)

    # Verifying relative path order
    if os.path.exists('/opt/ros/indigo/lib/python2.7/dist-packages'):
        assert '/opt/ros/indigo/lib/python2.7/dist-packages' in sys.path, "{p} not in {sp}".format(p='/opt/ros/indigo/lib/python2.7/dist-packages', sp=sys.path)
        # TODO : It seems env_cached.sh append dist-packages path at the end of python_path somehow... We should investigate.
        # HINT : only sourcing /opt/ros/indigo/setup.bash seems fine (dist-packages added at beginning of sys.path)
        # HINT : env_cached.sh seems fine... maybe it comes from the way nosetests/py.test is launched ?
        # HINT : following same process (building and running tests) with rospy_tutorials doesnt show the broken behavior. Something in catkin_pip breaking it ?
        #assert len(sys.path) == len(set(sys.path))  # check unicity of paths

    if os.path.exists(os.path.join(ws, 'lib/python2.7/dist-packages')):
        assert os.path.join(ws, 'lib/python2.7/dist-packages') in sys.path, "{p} not in {sp}".format(p=os.path.join(ws, 'lib/python2.7/dist-packages'), sp=sys.path)
        if os.path.exists('/opt/ros/indigo/lib/python2.7/dist-packages'):
            assert sys.path.index(os.path.join(ws, 'lib/python2.7/dist-packages')) < sys.path.index('/opt/ros/indigo/lib/python2.7/dist-packages'), "{p1} not before {p2} in {sp}".format(p1=os.path.join(ws, 'lib/python2.7/dist-packages'), p2='/opt/ros/indigo/lib/python2.7/dist-packages', sp=sys.path)

    if os.path.exists(os.path.join(ws, 'lib/python2.7/site-packages')):
        assert os.path.join(ws, 'lib/python2.7/site-packages') in sys.path, "{p} not in {sp}".format(p=os.path.join(ws, 'lib/python2.7/site-packages'), sp=sys.path)

        if os.path.exists(os.path.join(ws, 'lib/python2.7/dist-packages')):
            assert sys.path.index(os.path.join(ws, 'lib/python2.7/site-packages')) < sys.path.index(os.path.join(ws, 'lib/python2.7/dist-packages')), "{p1} not before {p2} in {sp}".format(p1=os.path.join(ws, 'lib/python2.7/site-packages'), p2=os.path.join(ws, 'lib/python2.7/dist-packages'), sp=sys.path)

        if os.path.exists('/opt/ros/indigo/lib/python2.7/dist-packages'):
            assert sys.path.index(os.path.join(ws, 'lib/python2.7/site-packages')) < sys.path.index('/opt/ros/indigo/lib/python2.7/dist-packages'), "{p1} not before {p2} in {sp}".format(p1=os.path.join(ws, 'lib/python2.7/site-packages'), p2='/opt/ros/indigo/lib/python2.7/dist-packages', sp=sys.path)

    # Verifying the pip editable installed package location is in python path
    ss = os.path.join(gs, 'test', 'pipproject', 'mypippkg')

    if os.path.exists(ss):
        assert ss in sys.path, "{p} not in {sp}".format(p=ss, sp=sys.path)

        # Lets keep it simple and rely on python way of handling easy-install.pth and egg-link before we modify it...
        # if os.path.exists(os.path.join(ws, 'lib/python2.7/site-packages')):
        #     assert sys.path.index(ss) < sys.path.index(os.path.join(ws, 'lib/python2.7/site-packages')), "{p1} not before {p2} in {sp}".format(p1=ss, p2=os.path.join(ws, 'lib/python2.7/site-packages'), sp=sys.path)
        #
        # if os.path.exists(os.path.join(ws, 'lib/python2.7/dist-packages')):
        #     assert sys.path.index(ss) < sys.path.index(os.path.join(ws, 'lib/python2.7/dist-packages')), "{p1} not before {p2} in {sp}".format(p1=ss, p2=os.path.join(ws, 'lib/python2.7/dist-packages'), sp=sys.path)
        #
        # if os.path.exists('/opt/ros/indigo/lib/python2.7/dist-packages'):
        #     assert sys.path.index(ss) < sys.path.index('/opt/ros/indigo/lib/python2.7/dist-packages'), "{p1} not before {p2} in {sp}".format(p1=ss, p2='/opt/ros/indigo/lib/python2.7/dist-packages', sp=sys.path)


    #TODO : verify the position of the catkin_pip_env paths (bin? and site-packages)
