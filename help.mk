.PHONY:
.DEFAULT_GOAL := help
# print help annotations for each command in list of entries
define PRINT_HELP_PYSCRIPT
import re
import sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_.-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-30s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

PYTHON := $(shell command -v python3 2>/dev/null || command -v python 2>/dev/null)

.PHONY: help
help:
	@echo "===== All tasks ====="
	@cat $(MAKEFILE_LIST) | $(PYTHON) -c "$$PRINT_HELP_PYSCRIPT"

.PHONY: makefiles-git-pull
makefiles-git-pull:
	@cd makefiles && \
	git checkout master && \
	git pull origin master
	git add makefiles 
	echo "You may know commit the change on makefiles submodule"