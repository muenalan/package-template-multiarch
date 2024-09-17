# call before: ./configureplus/usr/local/bin/configureplus

include .configureplus/currentsession.mk

SYSTEM_PREFIX=/usr/local
DIR_TEMPLATE_PACKAGE_ROOT=$(CONFIGURE_PKGNAME)/$(SYSTEM_PREFIX)

.PHONY: prepare-package-folder-local prepare-package-folder-global fill-package-folder-local deb clean-package-folder-local install-userhome-config status test-installed

install-systemwide: prepare-package-folder-local fill-package-folder-local deb 
	sudo dpkg -i ../packages/$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).deb && make install-userhome-config

install-userhome-config:
	-mkdir -p ~/.config/$(CONFIGURE_PKGNAME)/
	configureplus
	-cp -r .configureplus ~/.config/$(CONFIGURE_PKGNAME)/

prepare-package-folder-local: clean-package-folder-local
	mkdir -p $(DIR_TEMPLATE_PACKAGE_ROOT)/bin
	mkdir -p $(DIR_TEMPLATE_PACKAGE_ROOT)/lib/$(CONFIGURE_PKGNAME)   
	mkdir -p $(DIR_TEMPLATE_PACKAGE_ROOT)/var/$(CONFIGURE_PKGNAME)   
	mkdir -p $(DIR_TEMPLATE_PACKAGE_ROOT)/share/doc/$(CONFIGURE_PKGNAME)   


clean-package-folder-local:
	@if [ -d $(CONFIGURE_PKGNAME)/usr ]; then \
		zip -rm9 package-bak.zip $(CONFIGURE_PKGNAME)/usr; \
	fi \

# Define the JSON file
json_file=".configureplus/session/$(CONFIGUREPLUS_SESSION).json"
debian_control=$(CONFIGURE_PKGNAME)/DEBIAN/controldyn

fill-package-folder-local: 

	cp -r ../../../$(CONFIGURE_DIR_TEMPLATE)/bin/* $(CONFIGURE_PKGNAME)/usr/local/bin/
	cp -r ../../../$(CONFIGURE_DIR_TEMPLATE)/lib/* $(CONFIGURE_PKGNAME)/usr/local/lib/
	cp -r ../../../$(CONFIGURE_DIR_TEMPLATE)/var/* $(CONFIGURE_PKGNAME)/usr/local/var/
	cp -r ../../../$(CONFIGURE_DIR_TEMPLATE)/share/* $(CONFIGURE_PKGNAME)/usr/local/share/

	echo Generate DEBIAN/control file

	>$(debian_control) echo 
	>>$(debian_control) echo Package: "$(CONFIGURE_PKGNAME)"
	>>$(debian_control) echo Version: "$(CONFIGURE_VERSION)"
	>>$(debian_control) echo Architecture: "$(CONFIGURE_DPKG_ARCHITECTURE)"
	>>$(debian_control) echo Maintainer: "$(CONFIGURE_DPKG_MAINTAINER)"
	>>$(debian_control) echo Installed-Size: "$(CONFIGURE_DPKG_INSTALLED_SIZE)"
	>>$(debian_control) echo Depends: "$(CONFIGURE_DPKG_DEPENDS)"
	>>$(debian_control) echo Section: "$(CONFIGURE_DPKG_SECTION)"
	>>$(debian_control) echo Priority: "$(CONFIGURE_DPKG_PRIORITY)"
	>>$(debian_control) echo Homepage: "$(CONFIGURE_DPKG_HOMEPAGE)"
	>>$(debian_control) echo Description: "$(CONFIGURE_DPKG_DESCRIPTION)"
	>>$(debian_control) echo " $(CONFIGURE_DPKG_LONG_DESCRIPTION)"

	echo "$(debian_control) file generated successfully."

	find $(CONFIGURE_PKGNAME) -type f |xargs chmod 755 
	find $(CONFIGURE_PKGNAME) -mindepth 1 -type d |xargs chmod 644 

install-userprofile:
	./bin/install-userprofile.sh

uninstall-userprofile:
	./bin/uninstall-userprofile.sh

uninstall-systemwide:
	$(info ****** uninstall-systemwide: Not implemented yet *******)

zip:
	mkdir ../packages
	zip -r9 ../packages/$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).zip .

archive-master:
	wget https://github.com/muenalan/configureplus/archive/master.tar.gz -o ../$(CONFIGURE_PKGNAME)-master.tar.gz

archive:
	git init
	git add .
	git commit -m "release"
	git tag v0.0.1
	git archive --format=tar.gz -o ../$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).tar.gz --prefix=v0.0.1/ master
	shasum -a 256 ../$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).tar.gz >../$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).tar.gz.sha256

package:
	mkdir ../packages
	mkdir -p  ../packages/$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE) && cp -r . ../packages/$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE)/
	mkdir -p  ../packages/$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE)-homebrew &&	cp -r $(CONFIGURE_PKGNAME)/.brew ../packages/$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE)-homebrew/

deb: prepare-package-folder-local
	dpkg-deb --build $(CONFIGURE_PKGNAME)
	mkdir -p ../packages
	mv $(CONFIGURE_PKGNAME).deb ../packages/$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).deb

status:
	test -d .configureplus && echo .configureplus dir exists

	! test -f .configureplus && echo .configureplus is not a file

test-here: status
	btest folder t

test-installed: status
	btest folder /usr/local/lib/$(CONFIGURE_PKGNAME)/t

install-deb: deb
	dpkg -i ../packages/$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).deb

uninstall-deb:
	dpkg --remove $(CONFIGURE_PKGNAME)

clean: clean-package-folder-local
	-find . -name '*~' |zip -rm $(CONFIGURE_MKTEMP)/$(CONFIGURE_PKGNAME)-bak.zip -@
	-find . -name '*.bak' |zip -rm $(CONFIGURE_MKTEMP)/$(CONFIGURE_PKGNAME)-bak.zip -@
	-rm -r .configureplus/session/$(CONFIGUREPLUS_SESSION)*



