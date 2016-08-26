===========
Pip Package
===========

Ref : https://packaging.python.org/

There have been historically many ways to package and distribute python code.
While many of these are still usable, we are focusing here on the python packaging authority way to package python code.


Package Structure
=================

This is a generic example inspired by the pure pip package from Pyros dependencies: `pyros-setup <https://github.com/asmodehn/pyros-setup>`_


Files hierarchy
---------------


The source file hierarchy is::

    .
    ├── CHANGELOG.rst              # A changelog, usually generated from git commit with gitchangelog
    ├── doc
    │   ├── changelog_link.rst     # Documentation link to existing changelog
    │   ├── conf.py                # Sphinx doc configuration
    │   ├── mydocs.rst             # Documentation for Sphinx
    │   └── readme_link.rst        # Documentation link to existing readme
    ├── requirements.txt
    ├── MANIFEST.in
    ├── pyros_setup
    │   ├── __init__.py
    │   └── module1.py
    ├── README.rst
    ├── setup.cfg
    ├── setup.py
    └── tox.ini


Dependencies
------------

Dependencies are manage with pip, usually installed in a virtual environment.

There are two kinds of dependencies :
- The dependencies needed for the installed pacakge to work (in setuptools.setup install_requires parameter)
- The dependencies needed for the developer to work with the package (in requirements.txt)

For more detail about these, you should refer to : https://packaging.python.org/requirements/


Package Development Workflow
============================

This is a description of the generic python workflow to develop, build, test and release a python based package.
We will use pyros-setup project as an example.
**TODO : travis check these with doctest + running these in isolation in container**

- Get the Source ie. clone a Repo::

    $ git clone https://github.com/asmodehn/pyros-setup.git
    Cloning into 'pyros-setup'...
    remote: Counting objects: 718, done.
    remote: Compressing objects: 100% (64/64), done.
    remote: Total 718 (delta 29), reused 0 (delta 0), pack-reused 654
    Receiving objects: 100% (718/718), 134.89 KiB | 0 bytes/s, done.
    Resolving deltas: 100% (433/433), done.
    Checking connectivity... done.


- Create a virtual environment and activate it (here using virtualenvwrapper). We also want a virtualenvironment that can use the ROS & system packages::

    $ mkvirtualenv pyros-setup --system-site-packages
    New python executable in /home/alexv/.virtualenvs/pyros-setup/bin/python
    Installing setuptools, pip, wheel...done.


- Install with pip::

    $ pip install .
    Processing /home/alexv/doctest/pyros-setup
    Collecting six (from pyros-setup==0.1.2)
    /home/alexv/.virtualenvs/pyros-setup/local/lib/python2.7/site-packages/pip/_vendor/requests/packages/urllib3/util/ssl_.py:318: SNIMissingWarning: An HTTPS request has been made, but the SNI (Subject Name Indication) extension to TLS is not available on this platform. This may cause the server to present an incorrect TLS certificate, which can cause validation failures. You can upgrade to a newer version of Python to solve this. For more information, see https://urllib3.readthedocs.org/en/latest/security.html#snimissingwarning.
      SNIMissingWarning
    /home/alexv/.virtualenvs/pyros-setup/local/lib/python2.7/site-packages/pip/_vendor/requests/packages/urllib3/util/ssl_.py:122: InsecurePlatformWarning: A true SSLContext object is not available. This prevents urllib3 from configuring SSL appropriately and may cause certain SSL connections to fail. You can upgrade to a newer version of Python to solve this. For more information, see https://urllib3.readthedocs.org/en/latest/security.html#insecureplatformwarning.
      InsecurePlatformWarning
      Using cached six-1.10.0-py2.py3-none-any.whl
    Collecting pyros_config>=0.1.2 (from pyros-setup==0.1.2)
      Using cached pyros_config-0.1.3-py2-none-any.whl
    Collecting pytest>=2.5.1 (from pyros-setup==0.1.2)
      Using cached pytest-2.9.2-py2.py3-none-any.whl
    Collecting py>=1.4.29 (from pytest>=2.5.1->pyros-setup==0.1.2)
      Using cached py-1.4.31-py2.py3-none-any.whl
    Building wheels for collected packages: pyros-setup
      Running setup.py bdist_wheel for pyros-setup ... done
      Stored in directory: /home/alexv/.cache/pip/wheels/39/50/33/ab49df5cef0ef2ce4e23dabd0c9ea5d81f9af131c80d4b2523
    Successfully built pyros-setup
    Installing collected packages: six, py, pytest, pyros-config, pyros-setup
    Successfully installed py-1.4.31 pyros-config-0.1.3 pyros-setup-0.1.2 pytest-2.9.2 six-1.10.0



- Run tests in current environment with nose or pytest. Note that to avoid import conflict, and for tests to pass, you might need to move to a directory where the module is not accessible from current working directory ( https://github.com/asmodehn/pyros-setup/issues/27 ) ::

    $ pyros_setup --pytest
    ============================= test session starts ==============================
    platform linux2 -- Python 2.7.6, pytest-2.9.2, py-1.4.31, pluggy-0.3.1
    rootdir: /home/alexv/doctest/pyros-setup, inifile:
    collected 3 items

    .. ...

    =========================== 3 passed in 0.06 seconds ===========================



- Run tests on multiple python environments with tox::

    $ tox
    GLOB sdist-make: /home/alexv/doctest/pyros-setup/setup.py
    py27 create: /home/alexv/doctest/pyros-setup/.tox/py27
    py27 inst: /home/alexv/doctest/pyros-setup/.tox/dist/pyros_setup-0.1.2.zip
    py27 installed: alembic==0.6.2,amqp==1.3.3,ansible==2.1.0.0,anyjson==0.3.3,apt-xapian-index==0.45,argh==0.26.1,args==0.1.0,autopep8==0.9.1,Babel==1.3,backports.ssl-match-hostname==3.5.0.1,beautifulsoup4==4.2.1,billiard==3.3.0.15,binaryornot==0.2.0,blinker==1.3,bloom==0.5.21,bzr==2.1.4,catkin-pkg==0.2.10,catkin-sphinx==0.2.2,catkin-tools==0.4.2,celery==3.1.6,chardet==2.0.1,Cheetah==2.4.4,cl==0.0.3,clint==0.5.1,cobbler==2.4.1,colorama==0.2.5,command-not-found==0.3,configobj==4.7.2,cookiecutter==0.6.4,coverage==3.7.1,debtagshw==0.1,defer==1.0.6,dirspec==13.10,distro-info==0.12,Django==1.6.1,docker-py==1.8.1,dockerpty==0.3.4,docopt==0.6.2,docutils==0.11,dulwich==0.9.4,empy==3.1,enum34==0.9.23,epydoc==3.0.1,fastimport==0.9.2,fig==1.0.1,Flask==0.10.1,futures==2.1.6,gbp==0.6.9,git-remote-helpers==0.1.0,gitchangelog==2.3.0,gunicorn==17.5,html5lib==0.999,httplib2==0.8,importlib==1.0.3,iotop==0.6,ipaddress==1.0.16,itsdangerous==0.22,Jinja2==2.7.2,jsonpickle==0.9.2,keyring==3.5,kitchen==1.1.1,kombu==3.0.7,launchpadlib==1.10.2,lazr.restfulclient==0.13.3,lazr.uri==1.0.3,libvirt-python==1.2.2,lxml==3.3.3,mailer==0.7,Mako==0.9.1,MarkupSafe==0.18,matplotlib==1.3.1,meld3==0.6.10,mercurial==1.4.2,mock==1.0.1,mod-python==3.3.1,MySQL-python==1.2.3,netaddr==0.7.10,netifaces==0.8,nose==1.3.1,numpy==1.8.2,oauth==1.0.1,oauthlib==0.6.1,oneconf==0.3.7.14.4.1,osrf-pycommon==0.1.2,PAM==0.4.2,paramiko==1.10.1,passlib==1.5.3,pathtools==0.1.2,pep8==1.4.6,pexpect==3.1,Pillow==2.3.0,piston-mini-client==0.7.5,pkginfo==1.3.2,pluggy==0.3.1,progressbar==2.3,protobuf==2.5.0,psutil==1.2.1,py==1.4.31,pyasn1==0.1.7,pycrypto==2.6.1,pycups==1.9.66,pycurl==7.19.3,pydot==1.0.28,pyflakes==0.8.1,Pygments==1.6,pygobject==3.12.0,pygpgme==0.3,pygraphviz==1.2,pyinotify==0.9.4,pymongo==2.6.3,PyOpenGL==3.0.2,pyOpenSSL==0.13,pyparsing==2.0.1,pyros-config==0.1.3,pyros-setup==0.1.2,pyserial==2.6,pysmbc==1.0.14.1,pytest==2.9.2,python-apt===0.9.3.5ubuntu2,python-dateutil==1.5,python-debian===0.1.21-nmu2ubuntu2,python-memcached==1.53,pytz==2012rc0,pyxdg==0.25,PyYAML==3.10,pyzmq==14.0.1,redis==2.7.2,reportlab==3.0,requests==2.10.0,requests-toolbelt==0.7.0,roman==2.0.0,ros-buildfarm==1.1.0,rosdep==0.11.5,rosdistro==0.4.7,rospkg==1.0.39,SecretStorage==2.0.0,sessioninstaller==0.0.0,simplejson==3.3.1,six==1.10.0,software-center-aptd-plugins==0.0.0,Sphinx==1.2.2,sphinx-rtd-theme==0.1.7,sphinxcontrib-plantuml==0.6,SQLAlchemy==0.8.4,ssh-import-id==3.21,stevedore==0.14.1,supervisor==3.0b2,termcolor==1.1.0,testfixtures==4.7.0,texttable==0.8.3,tornado==3.1.1,tox==2.3.1,transitions==0.2.7,trollius==2.1,twine==1.8.1,Twisted==13.2.0,Twisted-Conch==13.2.0,Twisted-Core==13.2.0,Twisted-Lore==13.2.0,Twisted-Mail==13.2.0,Twisted-Names==13.2.0,Twisted-News==13.2.0,Twisted-Runner==13.2.0,Twisted-Web==13.2.0,Twisted-Words==13.2.0,urlgrabber==3.9.1,urllib3==1.7.1,vboxapi==1.0,vcstools==0.1.38,virtinst==0.600.4,virtualenv==15.0.2,virtualenv-clone==0.2.4,virtualenvwrapper==4.1.1,VTK==5.8.0,wadllib==1.3.2,watchdog==0.8.3,websocket-client==0.37.0,Werkzeug==0.9.4,wstool==0.1.13,wstools==0.4.3,WTForms==1.0.1,wxPython==2.8.12.1,wxPython-common==2.8.12.1,xdot==0.5,yujin-tools==0.4.24,zenmap==6.40,zope.interface==4.0.5
    py27 runtests: PYTHONHASHSEED='473323988'
    py27 runtests: commands[0] | py.test --pyargs pyros_setup
    WARNING:test command found but not installed in testenv
      cmd: /home/alexv/.virtualenvs/pyros-setup/bin/py.test
      env: /home/alexv/doctest/pyros-setup/.tox/py27
    Maybe you forgot to specify a dependency? See also the whitelist_externals envconfig setting.
    ================================================================ test session starts ================================================================
    platform linux2 -- Python 2.7.6, pytest-2.9.2, py-1.4.31, pluggy-0.3.1
    rootdir: /home/alexv/doctest/pyros-setup, inifile:
    collected 3 items

    pyros_setup/tests/test_setup.py ...

    ============================================================= 3 passed in 0.06 seconds ==============================================================
    ___________________________________ summary ____________________________________
      py27: commands succeeded
      congratulations :)



- Build a distribution

- Release on Pypi with twine (you can also code a specific detailed workflow in your setup.py)


Continuous Testing Workflow
===========================

Because no software works until it has been tested, you should configure travis on your repository to run test with each commit and pull request.

Catkin testing can be done with a simple `.travis.yml` file and a small shell script.

A matrix build can be setup to test behavior in multiple python virtualenvs.
Using tox for this is generally a good idea, an example is there <TODO>.