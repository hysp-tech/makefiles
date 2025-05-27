# Set NS as alias for NAMESPACE if NAMESPACE is not set
NAMESPACE ?= $(NS)

### Command of kube app deployment ###
kube-deploy: _kube-check-input ## Deploy kube app: make kube-deploy [NAMESPACE=nexus] APP=my_app [ENV=dev] [DRY_RUN=true]
	@if [ -n "$(NAMESPACE)" ]; then \
		make -C kube/$(NAMESPACE)/$(APP) deploy; \
	else \
		make -C kube/apps/$(APP) deploy; \
	fi

kube-upgrade: _kube-check-input ## Upgrade kube app: make kube-upgrade [NAMESPACE=nexus] APP=my_app [ENV=dev] [DRY_RUN=true] [TAG=latest]
	@if [ -n "$(NAMESPACE)" ]; then \
		make -C kube/$(NAMESPACE)/$(APP) upgrade; \
	else \
		make -C kube/apps/$(APP) upgrade; \
	fi

kube-delete: _kube-check-input ## Delete app: make kube-delete [NAMESPACE=nexus] APP=my_app [ENV=dev] [DRY_RUN=true]
	@if [ -n "$(NAMESPACE)" ]; then \
		make -C kube/$(NAMESPACE)/$(APP) delete; \
	else \
		make -C kube/apps/$(APP) delete; \
	fi

kube-show: _kube-check-input ## Show app yaml: make kube-show [NAMESPACE=nexus] APP=my_app [ENV=dev]
	@if [ -n "$(NAMESPACE)" ]; then \
		make -C kube/$(NAMESPACE)/$(APP) show; \
	else \
		make -C kube/apps/$(APP) show; \
	fi

_kube-check-input:
	@if [ -z "$(APP)" ]; then \
		echo "Invalid input: APP parameter is required"; \
		exit 1; \
	fi
	@if [ -n "$(NAMESPACE)" ]; then \
		if [ ! -f "kube/$(NAMESPACE)/$(APP)/Makefile" ]; then \
			echo "Invalid input: kube/$(NAMESPACE)/$(APP)/Makefile does not exist"; \
			exit 1; \
		fi \
	else \
		if [ ! -f "kube/apps/$(APP)/Makefile" ]; then \
			echo "Invalid input: kube/apps/$(APP)/Makefile does not exist"; \
			exit 1; \
		fi \
	fi
