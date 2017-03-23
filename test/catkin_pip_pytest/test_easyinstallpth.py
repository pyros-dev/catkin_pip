from __future__ import absolute_import
from __future__ import print_function

import os


def test_easyinstall_content(devel_space, git_working_tree):
    easy_install_pth_path = os.path.join(devel_space, 'lib', 'python2.7', 'site-packages', 'easy-install.pth')
    assert os.path.exists(easy_install_pth_path)
    with open(easy_install_pth_path) as easy_install_pth:
        editable_paths = easy_install_pth.read().splitlines()
        print(editable_paths)
        for python_pkg in [
            os.path.join('pipproject', 'mypippkg'),
            os.path.join('pylibrary', 'python-nameless', 'src'),
            os.path.join('pypackage', 'python_boilerplate'),
            os.path.join('pypackage-minimal', 'cookiecutter_pypackage_minimal'),
        ]:
            assert os.path.join(git_working_tree, 'test', python_pkg) in editable_paths, "{0} not in easy-install.pth".format(os.path.join(git_working_tree, 'test', python_pkg))

        # Note if not in the file, it means it s already in PYTHONPATH : Ref https://github.com/pypa/pip/issues/4261
        # Fix this test for it, at least until pip fixes goes in...
