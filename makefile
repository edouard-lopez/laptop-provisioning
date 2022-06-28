#!/usr/bin/make -sf

INTERACTIVE=true
REMOTE_USER ?= ${USER}

default: \
	install-requirements \
	install-dependencies \
	install-dev-dependencies


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
	sudo  pip install \
		--upgrade \
		--user\
		ansible
	sudo apt install \
		--yes \
		python3.10 \
		python3-venv
	curl \
		--show-error \
		--silent \
		--location \
	https://install.python-poetry.org \
	| python3 -

.PHONY: install-dependencies
install-dependencies: 
	poetry install
	ansible-galaxy install \
		--role-file requirements.yml

.PHONY: install-dev-dependencies
install-dev-dependencies:
	sudo apt-get install --yes \
		libssl-dev
		
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


configure:
	ansible-playbook localhost.yml \
		--vault-password-file=.secret.txt \
		--tags "${TAGS}"

# Basic roles		
ROLES_PATH := ./roles/configure_*
AVAILABLE_ROLES = $(notdir $(wildcard $(ROLES_PATH)))
TARGET_ROLES = $(subst _,-,$(AVAILABLE_ROLES)) 
.PHONY: $(TARGET_ROLES)
$(TARGET_ROLES):
	ansible-playbook localhost.yml --tags "$(subst configure-,,$@)"
#	ansible-playbook ./roles/$(subst -,_,$@)/tasks/main.yml --ask-become-pass

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
