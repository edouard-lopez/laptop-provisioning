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

# Basic roles		
ROLES_PATH := ./roles/configure_*
AVAILABLE_ROLES = $(notdir $(wildcard $(ROLES_PATH)))
TARGET_ROLES = $(subst _,-,$(AVAILABLE_ROLES)) 
.PHONY: $(TARGET_ROLES)
$(TARGET_ROLES):
	ansible-playbook ./roles/$@/tasks/main.yml \
	--ask-become-pass

# Specific roles
.PHONY: configure-shell-fish
configure-shell-fish:
	ansible-playbook ./roles/configure_shells/tasks/main.yml \
		--ask-become-pass \
		--tags fish

.PHONY: configure-shell-zsh
configure-shell-zsh:
	ansible-playbook ./roles/configure_shells/tasks/main.yml \
		--ask-become-pass \
		--tags zsh
