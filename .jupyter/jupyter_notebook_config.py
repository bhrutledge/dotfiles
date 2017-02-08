from os import environ, makedirs, path
from subprocess import check_call

#--- nbextensions configuration ---
import sys
sys.path.append('/Users/brian/Library/Jupyter/extensions')
#--- nbextensions configuration ---


environ.setdefault('ES_OUTPUT_DIR', '/Volumes/config/reports')


def nbconvert(os_path, to):
    dname, fname = path.split(os_path)

    to_dname = path.join(dname, to)
    if not path.exists(to_dname):
        makedirs(to_dname)

    check_call([
        'jupyter', 'nbconvert', '--to', to, '--output-dir', to_dname, fname
    ], cwd=dname)


def post_save(model, os_path, contents_manager):
    """
    post-save hook for converting notebooks to .html, .py, etc.

    https://gist.github.com/jbwhit/eeb669e37c16b28700b7
    """
    if model['type'] != 'notebook':
        return

    nbconvert(os_path, 'html')
    nbconvert(os_path, 'script')


c.FileContentsManager.post_save_hook = post_save
