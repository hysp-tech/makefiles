NS ?= default

### Command of kube app deployment ###
kube-deploy: _kube-check-input ## Deploy kube app: make kube-deploy [NS=nexus] APP=my_app [ENV=dev] [DRY_RUN=true] [KUBE_CONFIG=kubeconfig/kubernetes-dashboard-admin.yaml]
	@make -C kube/$(NS)/$(APP) deploy

kube-upgrade: _kube-check-input ## Upgrade kube app: make kube-upgrade [NS=nexus] APP=my_app [ENV=dev] [DRY_RUN=true] [TAG=latest] [KUBE_CONFIG=kubeconfig/kubernetes-dashboard-admin.yaml]
	@make -C kube/$(NS)/$(APP) upgrade

kube-delete: _kube-check-input ## Delete app: make kube-delete [NS=nexus] APP=my_app [ENV=dev] [DRY_RUN=true] [KUBE_CONFIG=kubeconfig/kubernetes-dashboard-admin.yaml]
	@make -C kube/$(NS)/$(APP) delete

kube-show: _kube-check-input ## Show app yaml: make kube-show [NS=nexus] APP=my_app [ENV=dev]
	@make -C kube/$(NS)/$(APP) show

_kube-check-input:
	@if [ -z "$(APP)" ]; then \
		echo "Invalid input: APP parameter is required"; \
		exit 1; \
	fi
	@if [ ! -f "kube/$(NS)/$(APP)/Makefile" ]; then \
		echo "Invalid input: kube/$(NS)/$(APP)/Makefile does not exist"; \
		exit 1; \
	fi
