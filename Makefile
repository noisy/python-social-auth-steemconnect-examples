DEFAULT_IFACE := 0.0.0.0
DEFAULT_PORT := 8001

check-local-settings:
	@ test -f ${example_path}/local_settings.py || ( \
		echo "====================================================================\n"; \
		echo "         Missing ${example_path}/local_settings.py\n"; \
		echo "===================================================================="; \
		exit 1; \
	)

install-dependencies:
	@ pip install -r ${example_path}/requirements.txt

run-django:
	@ ${MAKE} check-local-settings example_path=example-django/example
	@ ${MAKE} install-dependencies example_path=example-django
	@ python example-django/manage.py migrate
	@ python example-django/manage.py runserver $(DEFAULT_PORT)

run-flask:
	@ ${MAKE} check-local-settings example_path=example-flask/example
	@ ${MAKE} install-dependencies example_path=example-flask
	@ python example-flask/manage.py syncdb
	@ python example-flask/manage.py runserver -p $(DEFAULT_PORT)

run-tornado:
	@ ${MAKE} check-local-settings example_path=example-tornado/example
	@ ${MAKE} install-dependencies example_path=example-tornado
	@ python example-tornado/manage.py syncdb
	python example-tornado/manage.py $(DEFAULT_IFACE):$(DEFAULT_PORT)

clean:
	@ find . -name '*.py[co]' -delete
	@ find . -name '__pycache__' -delete
	@ find . -name '*.sqlite3' -delete
