### Concourse ###
concourse-apply: _concourse_check_login ## Apply a concourse pipeline: make concourse-apply TEAM=nexus APP=botchan
	@if [ -z "$(TEAM)" ] || [ -z "$(APP)" ] || [ ! -d "concourse/$(TEAM)/$(APP)" ]; then \
		echo "Error: concourse/$(TEAM)/$(APP) does not exist or APP/TEAM is empty"; \
		exit 1; \
	fi
	@if [ -f "concourse/$(TEAM)/$(APP)/Makefile" ]; then \
		echo "Using customized Makefile under the $(APP) folder;" \
		cd concourse/$(TEAM)/$(APP) && make apply; \
	else \
		fly -t main set-pipeline --team $(TEAM) --pipeline $(APP) \
			--config concourse/$(TEAM)/$(APP)/pipeline.yaml ; \
	fi

_concourse_check_login:
	fly -t main status || fly -t main login -c $(CONCOURSE_URL)

concourse-delete: _concourse_check_login
	@if [ -z "$(TEAM)" ] || [ -z "$(APP)" ] || [ ! -d "concourse/$(TEAM)/$(APP)" ]; then \
		echo "Error: concourse/$(TEAM)/$(APP) does not exist or APP/TEAM is empty"; \
		exit 1; \
	fi
	fly -t main destroy-pipeline --team $(TEAM) --pipeline $(APP)

concourse-new-team: _concourse_check_login ## Create a new Concourse team: make concourse-new-team TEAM=new-team
	@if [ -z "$(TEAM)" ]; then \
		echo "Error: TEAM parameter is empty"; \
		exit 1; \
	fi
	@echo "Creating new team: $(TEAM)"
	fly -t main set-team --team-name $(TEAM) --local-user admin
	@echo "Team $(TEAM) created successfully. You can now login with:"
	@echo "fly -t $(TEAM) login -c $(CONCOURSE_URL) -n $(TEAM)"