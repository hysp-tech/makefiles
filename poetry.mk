
requirements.txt: pyproject.toml ## Export requirements.txt from pyproject.toml
	poetry export --without-hashes --format=requirements.txt --output=requirements.txt

requirements-dev.txt: pyproject.toml ## Export requirements-dev.txt from pyproject.toml
	poetry export --dev --without-hashes --format=requirements.txt --output=requirements-dev.txt
