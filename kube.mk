### Command of kube app deployment ###
kube-deploy: _kube-check-input ## Deploy kube app: make kube-deploy APP=my_app [ENV=dev] [DRY_RUN=true]
	@make -C kube/$(APP) deploy

kube-upgrade: _kube-check-input ## Upgrade kube app: make kube-upgrade APP=my_app [ENV=dev] [DRY_RUN=true] [TAG=latest]
	@make -C kube/$(APP) upgrade

kube-delete: _kube-check-input ## Delete app: make kube-delete APP=my_app [ENV=dev] [DRY_RUN=true]
	@make -C kube/$(APP) delete

kube-show: _kube-check-input ## Show app yaml: make kube-show APP=my_app [ENV=dev]
	@make -C kube/$(APP) show

_kube-check-input:
	@if [ -z "$(APP)" ] || [ ! -f "kube/$(APP)/Makefile" ]; then \
		echo "Invalid input: empty APP parameter or kube/$(APP)/Makefile does not exist"; \
		exit 1; \
	fi
