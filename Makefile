# load local defaults, these file does not get commited
include .defaults

EXTRAS?=

base:
	cd ansible; \
	ansible-playbook \
		--extra-vars hosts=home01 \
		$(EXTRAS) \
		playbook/base.yml

deps: dependencies
dependencies:
	cd ansible; \
	ansible-galaxy install --ignore-errors -r roles.yml

.defaults:
	echo "" > .defaults
