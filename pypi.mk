.PHONY: pypi-build-wheel pypi-publish-wheel


pypi-build-wheel: setup.py  ## Build PYPI package wheel
	python setup.py sdist bdist_wheel

pypi-publish-wheel:  ## Publish PYPI package wheel
	twine upload dist/*