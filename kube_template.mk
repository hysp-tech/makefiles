
# For customized kube
#KUBECONFIG := ${HOME}/.kube/config
#KUBECTL := $(KUBECTL_CMD) --kubeconfig=$(KUBECONFIG)
#HELM := $(HELM_CMD) --kubeconfig=$(KUBECONFIG)
KUBECTL := kubectl
HELM := helm

# default params for local helm chart
HELM_REPO_URL ?= .
HELM_CHART ?= chart
ENV ?= dev
TAG ?= undefined
USE_OCI ?= true

# Define repo path based on USE_OCI
HELM_REPO := $(if $(filter true,$(USE_OCI)),$(HELM_REPO_URL),$(HELM_REPO_NAME))

# Shared target
.PHONY: init
init:  ## Add helm repo
	@echo "init $(APP)"
	if [ "$(USE_OCI)" = true ]; then \
		echo "OCI doesn't need init"; \
	else \
		$(HELM) repo add $(HELM_REPO_NAME) $(HELM_REPO_URL); \
	fi


.PHONY: deploy
deploy: init ## deploy release with helm
	@echo "deploy $(APP) in $(ENV) env"
	$(HELM) install $(APP)-$(ENV) $(HELM_REPO)/$(HELM_CHART) -f values-$(ENV).yaml


.PHONY: upgrade
upgrade:  ## upgrade release with helm
	@echo "upgrade $(APP) in $(ENV) env"
	if [ "$(TAG)" != "undefined" ] ; then \
		$(HELM) upgrade $(APP)-$(ENV) $(HELM_REPO)/$(HELM_CHART) -f values-$(ENV).yaml --set image.tag=$(TAG); \
	else \
		$(HELM) upgrade $(APP)-$(ENV) $(HELM_REPO)/$(HELM_CHART) -f values-$(ENV).yaml ; \
	fi

.PHONY: show
show:  ## Show release with helm
	@echo "show $(APP) in $(ENV) env"
	$(HELM) template $(APP)-$(ENV) $(HELM_REPO)/$(HELM_CHART) -f values-$(ENV).yaml


.PHONY: delete
delete:  ## Delete release with helm
	@if [ "$(NO_INTERACTION)" != "YES" ] ; then \
		read -p "Do you want to delete $(APP) in $(ENV) env? [y/N]: " answer; \
		if [ "$$answer" != "y" ]; then \
			echo "Aborted."; exit 1; \
		fi \
	fi 
	if $(HELM) status $(APP)-$(ENV) > /dev/null 2>&1; then \
        $(HELM) uninstall $(APP)-$(ENV); \
    else \
        echo "$(APP) in $(ENV) env is not deployed. Nothing to delete."; \
    fi