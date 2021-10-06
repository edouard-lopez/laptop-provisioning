#!/usr/bin/make -sf

INTERACTIVE=true
REMOTE_USER ?= ${USER}

default: \
	install-requirements \
	install-dev-requirements


.PHONY: check-playbook
check-playbook:
	ansible-playbook \
		--ask-become-pass \
		--inventory inventories/dev.ini \
		--check \
		--user "${REMOTE_USER}" \
	./localhost.yml

.PHONY: deploy-ssh-key
deploy-ssh-key:
	ansible-playbook \
		--ask-pass \
		--ask-become-pass \
		--inventory inventories/dev.ini \
		--tags "ssh" \
	./localhost.yml


.PHONY: install-requirements
install-requirements: 
	python3 -m pip install \
		--requirement requirements.txt
	ansible-galaxy install \
		--role-file requirements.yml

.PHONY: install-dev-requirements
install-dev-requirements:
	sudo apt-get install --yes \
		python3-pip \
		libssl-dev
	python3 -m pip install \
		--upgrade \
		setuptools \
		testresources \
		"molecule[ansible]" \
		"molecule[lint]" \
		"ansible-lint[yamllint]"
		
.PHONY: lint-playbooks
lint-playbooks:
	ansible-lint \
		./localhost.yml
		
.PHONY: test-locally
test-locally:
	ansible-playbook \
		--ask-pass --ask-become-pass \
		--inventory inventories/tests \
		--user "${REMOTE_USER}" \
		-vv \
	./localhost.yml
		
.PHONY: configure-shells
configure-shells:
	ansible-playbook \
		--ask-pass --ask-become-pass \
		--inventory inventories/tests \
		--user "${REMOTE_USER}" \
		-vv \
	./localhost.yml --tags shell
		

.PHONY: configure-git
configure-git:
	ansible-playbook ./roles/configure_git/tasks/main.yml \
		--ask-become-pass

.PHONY: configure-nodejs
configure-nodejs:
	ansible-playbook ./roles/configure_nodejs/tasks/main.yml \
		--ask-become-pass
