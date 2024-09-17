# call before: ./configureplus/usr/local/bin/configureplus

include .configureplus/currentsession.mk

SYSTEM_PREFIX=/usr/local
DIR_TEMPLATE_PACKAGE_ROOT=$(CONFIGURE_PKGNAME)/$(SYSTEM_PREFIX)

.PHONY: prepare-package-folder-local prepare-package-folder-global fill-package-folder-local deb clean-package-folder-local install-userhome-config status-local status-installed test-installed

install-systemwide: deb 
	sudo dpkg -i --debug=1 ../packages/$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).deb && make install-userhome-config

install-userhome-config:
	-mkdir -p ~/.config/$(CONFIGURE_PKGNAME)/
	configureplus
	-cp -r .configureplus ~/.config/$(CONFIGURE_PKGNAME)/
	-rsync -ru ../../../$(CONFIGURE_DIR_TEMPLATE)/_userhome/ ~/

prepare-package-folder-local: clean-package-folder-local
	mkdir -p $(DIR_TEMPLATE_PACKAGE_ROOT)/bin
	mkdir -p $(DIR_TEMPLATE_PACKAGE_ROOT)/lib/$(CONFIGURE_PKGNAME)   
	mkdir -p $(DIR_TEMPLATE_PACKAGE_ROOT)/var/$(CONFIGURE_PKGNAME)   
	mkdir -p $(DIR_TEMPLATE_PACKAGE_ROOT)/share/doc/$(CONFIGURE_PKGNAME)   


clean-package-folder-local:
	@if [ -d $(CONFIGURE_PKGNAME)/usr ]; then \
		zip -rm package-bak.zip $(CONFIGURE_DIR_TEMPLATE)/{bin,lib,var,share} $(debian_control_dir)/control; \
#		zip -rm9 package-bak.zip $(CONFIGURE_PKGNAME)/usr; \
	fi \

# Define the JSON file
json_file=".configureplus/session/$(CONFIGUREPLUS_SESSION).json"

debian_control_dir=$(CONFIGURE_PKGNAME)/DEBIAN

fill-package-folder-local: 

	install -v -d $(CONFIGURE_DIR_TEMPLATE)/{bin,lib,var,share}
	install -v -d $(CONFIGURE_PKGNAME)/usr/local/{bin,lib,var,share}
	install -v ../../../$(CONFIGURE_DIR_TEMPLATE)/bin/* $(CONFIGURE_PKGNAME)/usr/local/bin/
	install -v ../../../$(CONFIGURE_DIR_TEMPLATE)/lib/* $(CONFIGURE_PKGNAME)/usr/local/lib/
	install -v ../../../$(CONFIGURE_DIR_TEMPLATE)/var/* $(CONFIGURE_PKGNAME)/usr/local/var/
	install -v ../../../$(CONFIGURE_DIR_TEMPLATE)/share/* $(CONFIGURE_PKGNAME)/usr/local/share/

	echo Generate $(debian_control_dir)/control file

	mkdir -p $(debian_control_dir)

	echo Usage package name: ob-package-command-parseob
	>$(debian_control_dir)/control echo Package: ob-package-command-parseob
	>>$(debian_control_dir)/control echo Version: "$(CONFIGURE_VERSION)"
	>>$(debian_control_dir)/control echo Architecture: "$(CONFIGURE_DPKG_ARCHITECTURE)"
	>>$(debian_control_dir)/control echo Maintainer: "$(CONFIGURE_DPKG_MAINTAINER)"
	>>$(debian_control_dir)/control echo Installed-Size: "$(CONFIGURE_DPKG_INSTALLED_SIZE)"
	>>$(debian_control_dir)/control echo Depends: "$(CONFIGURE_DPKG_DEPENDS)"
	>>$(debian_control_dir)/control echo Section: "$(CONFIGURE_DPKG_SECTION)"
	>>$(debian_control_dir)/control echo Priority: "$(CONFIGURE_DPKG_PRIORITY)"
	>>$(debian_control_dir)/control echo Homepage: "$(CONFIGURE_DPKG_HOMEPAGE)"
	>>$(debian_control_dir)/control echo Description: "$(CONFIGURE_DPKG_DESCRIPTION)" 
	>>$(debian_control_dir)/control echo " $(CONFIGURE_DPKG_LONG_DESCRIPTION)" 

	echo "$(debian_control_dir)/control file generated successfully."

#	find $(CONFIGURE_PKGNAME) -type f |xargs chmod 755 
#	find $(CONFIGURE_PKGNAME) -mindepth 1 -type d |xargs chmod 644 


install-userprofile:
	./bin/install-userprofile.sh

uninstall-userprofile:
	./bin/uninstall-userprofile.sh

uninstall-systemwide:
	$(info ****** uninstall-systemwide: Not implemented yet *******)

zip:
	mkdir -p ../packages
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

deb: prepare-package-folder-local fill-package-folder-local
	dpkg-deb --build $(CONFIGURE_PKGNAME)
	mkdir -p ../packages
	mv $(CONFIGURE_PKGNAME).deb ../packages/$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).deb

status-local:
	@if [ -d .configureplus ]; then \
	 	echo .configureplus dir exists; \
	fi \

status-installed:
	@if [ -d "~/.config/$(CONFIGURE_PKGNAME)/" ]; then \
	 	echo "~/.config/$(CONFIGURE_PKGNAME)/" dir exists; \
	else \
	 	echo "~/.config/$(CONFIGURE_PKGNAME)/" dir does not exist; \
	fi \

test-here: status-local
	btest folder t

test-installed: status-local
	btest folder /usr/local/lib/$(CONFIGURE_PKGNAME)/t

install-deb: deb
	dpkg -i ../packages/$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).deb

uninstall-deb:
	dpkg --remove $(CONFIGURE_PKGNAME)

clean: clean-package-folder-local
	-find . -name '*~' |zip -rm $(CONFIGURE_MKTEMP)/$(CONFIGURE_PKGNAME)-bak.zip -@
	-find . -name '*.bak' |zip -rm $(CONFIGURE_MKTEMP)/$(CONFIGURE_PKGNAME)-bak.zip -@
	-rm -r .configureplus/session/$(CONFIGUREPLUS_SESSION)*



