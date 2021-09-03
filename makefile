#!/usr/bin/make -sf

INTERACTIVE=true

default: \
	install-requirements \
	install-dev-requirements


.PHONY: check-playbook
check-playbook:
	ansible-playbook \
		--ask-become-pass \
		--inventory inventories/dev.ini \
		--check \
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
		--user \
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
		--user \
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
		--extra-vars "ssh_user=ed8" \
		-vv \
	./localhost.yml
		