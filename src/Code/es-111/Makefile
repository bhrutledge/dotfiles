# TODO: Create, activate, update venv as needed
ifndef VIRTUAL_ENV
$(error Virtual environment not active)
endif

pth_file="$(VIRTUAL_ENV)/lib/python2.7/site-packages/es-site.pth"

# TODO: migrate
# TODO: Create config/site.json from template
# TODO: Check and/or set DJANGO_SETTINGS_MODULE
.PHONY: install
install: $(pth_file)
	pip install -U pip setuptools
	pip install --no-cache-dir -r es-site/conf/py/REQ-DEV

# Add entries to `sys.path` to allow `django-admin runserver`
# TODO: Use setup.py instead
$(pth_file):
	echo $(CURDIR)/es-site/es > $@
