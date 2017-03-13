import io
from os import makedirs, path
from nbconvert import get_exporter


def nbconvert(to_format, os_path, contents_manager):
    """
    Convert notebook to .html, .py, etc.

    Saves files to 'html/', 'script/', etc. in notebook directory.

    http://jupyter-notebook.readthedocs.io/en/4.x/extending/savehooks.html
    """
    dname, fname = path.split(os_path)
    base, ext = path.splitext(fname)

    to_dname = path.join(dname, to_format)
    if not path.exists(to_dname):
        makedirs(to_dname)

    exporter = get_exporter(to_format)(parent=contents_manager)
    export, resources = exporter.from_filename(os_path)
    to_fname = base + resources.get('output_extension', '.txt')

    to_path = path.join(to_dname, to_fname)

    contents_manager.log.info('Saving %s', to_path)
    with io.open(to_path, 'w', encoding='utf-8') as f:
        f.write(export)


def post_save(model, os_path, contents_manager, **kwargs):
    if model['type'] != 'notebook':
        return

    nbconvert('script', os_path, contents_manager)
    nbconvert('html', os_path, contents_manager)


c.FileContentsManager.post_save_hook = post_save
