#!/usr/bin/make -f

# Quantal is broken
RELEASES = precise trusty
IMAGES = $(foreach release,$(RELEASES),$(release)-desktop-i386 $(release)-desktop-amd64)
BOXES = $(foreach image,$(IMAGES),$(image))

.PHONY: init all $(BOXES)
.NOTPARALLEL: $(BOXES)

init:
	mkdir -p build

build-all: init $(BOXES)

$(BOXES): %: init
	vagrant up $*
	vagrant package $* --output build/$*.box
	vagrant destroy --force $*
	vagrant box add --force build/$*.box --name $*.box

.PHONY: clean clean-vagrant clean-build

clean: clean-vagrant clean-build

clean-vagrant:
	vagrant destroy --force

clean-build:
	rm -rf build
