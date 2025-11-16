# For customized kube/helm in .envrc
KUBECTL ?= kubectl
HELM ?= helm

KUBECONFIG ?= $(shell git rev-parse --show-toplevel)/kubeconfig/kubernetes-dashboard-admin.yaml

# default params for local helm chart
HELM_REPO_URL ?= $(shell git rev-parse --show-toplevel)/helm
# for local helm chart, name should be same as APP
HELM_CHART ?= $(APP)
# for local helm chart, repo is the url of the chart
HELM_REPO ?= $(HELM_REPO_URL)

ENV ?= dev
TAG ?= undefined
USE_LOCAL_CHART ?= true
DRY_RUN ?= false
VERSION ?= 
TAG ?= undefined
TIMEOUT ?= 300s

# Define dry run flag based on DRY_RUN value
HELM_DRY_RUN := $(if $(filter true,$(DRY_RUN)),--dry-run,)

# Define version and tag config strings
VERSION_CFG := $(if $(VERSION),--version $(VERSION),)
TAG_CFG := $(if $(filter-out undefined,$(TAG)),--set image.tag=$(TAG),)


# Shared target
.PHONY: init
init:  ## Add helm repo
	@echo "init $(APP)"
	@if [ "$(USE_LOCAL_CHART)" = true ]; then \
		echo "Local repo doesn't need init"; \
	else \
		$(HELM) repo add $(HELM_REPO) $(HELM_REPO_URL) || $(HELM) repo update $(HELM_REPO); \
	fi


.PHONY: deploy
deploy: _check_kubeconfig init ## deploy release with helm
	@echo "deploy $(APP) in $(ENV) env with version $(VERSION) $(if $(filter true,$(DRY_RUN)),[DRY RUN],)"
	$(HELM) --kubeconfig $(KUBECONFIG) -n $(NS) install $(APP)-$(ENV) $(VERSION_CFG) $(HELM_REPO)/$(HELM_CHART) -f values-$(ENV).yaml $(HELM_DRY_RUN) --wait --timeout=$(TIMEOUT)


.PHONY: upgrade
upgrade:  _check_kubeconfig ## upgrade release with helm
	@echo "upgrade $(APP) in $(ENV) env with version $(VERSION) $(if $(filter true,$(DRY_RUN)),[DRY RUN],)"
	$(HELM) --kubeconfig $(KUBECONFIG) -n $(NS) upgrade $(APP)-$(ENV) $(VERSION_CFG) $(HELM_REPO)/$(HELM_CHART) -f values-$(ENV).yaml $(TAG_CFG) --wait --timeout=$(TIMEOUT) $(HELM_DRY_RUN)

.PHONY: show
show: init ## Show release with helm
	@echo "show $(APP) in $(ENV) env"
	$(HELM) template $(APP)-$(ENV) $(HELM_REPO)/$(HELM_CHART) -f values-$(ENV).yaml


.PHONY: delete
delete:  _check_kubeconfig ## Delete release with helm
	@if [ "$(NO_INTERACTION)" != "YES" ] ; then \
		echo $(HELM) -n $(NS) uninstall $(APP)-$(ENV) $(HELM_DRY_RUN); \
		read -p "Do you want to delete $(APP) in $(ENV) env? [y/N]: " answer; \
		if [ "$$answer" != "y" ]; then \
			echo "Aborted."; exit 1; \
		fi \
	fi
	@if $(HELM) --kubeconfig $(KUBECONFIG) -n $(NS) status $(APP)-$(ENV) > /dev/null 2>&1; then \
		$(HELM) --kubeconfig $(KUBECONFIG) -n $(NS) uninstall $(APP)-$(ENV) $(HELM_DRY_RUN); \
	else \
		echo "$(APP) in $(ENV) env is not deployed. Nothing to delete."; \
	fi

.PHONY: _check_kubeconfig
_check_kubeconfig:
	@if [ ! -f "$(KUBECONFIG)" ]; then \
		echo "Error: KUBECONFIG file does not exist at $(KUBECONFIG)"; \
		echo "Please set the KUBECONFIG environment variable to point to your kubeconfig file."; \
		echo "You can set it with abs_path like this: export KUBECONFIG=/abs_path/to/your/kubeconfig.yaml"; \
		exit 1; \
	fi
	@echo "Using KUBECONFIG: $(KUBECONFIG)"
	$(KUBECTL) --kubeconfig $(KUBECONFIG) version