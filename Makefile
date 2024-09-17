
DIRECTORY_BASE_TARGET=..

DIRECTORY_PKG=$(DIRECTORY_BASE_TARGET)/package-multiarch-$(CONFIGURE_PKGNAME)

setup:
	mkdir -p $(DIRECTORY_PKG)
	cp -r bin template build $(DIRECTORY_PKG)/
	CONFIGURE_PKGNAME=$(CONFIGURE_PKGNAME) DIRECTORY_PKG=$(DIRECTORY_PKG) ./bin/setup.pl
	echo $(CONFIGURE_PKGNAME) > $(DIRECTORY_PKG)/build/.configureplus/global/CONFIGURE_PKGNAME
	cd $(DIRECTORY_PKG)/build && configureplus --detect-os && configureplus && make
	$(info ******** After install, you will have a build/platforms/$$CONFIGURE_OSTYPE folder. Proceed in this platform-specific build directory ***********)

platform-current:
	cd build/ && ./bin/configureplus --detect-os

test:
	btest t/

clean:
	-rm configure.sh
	-find . -name '*~' |zip -rm bak.zip -@
	-find . -name '*.bak' |zip -rm bak.zip -@
	-cd build/ && make clean
