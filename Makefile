# path to the config space shoud be absolute, see fai.conf(5)

DESTDIR = .

help:
	@echo "To run this makefile, run:"
	@echo "   make image-<DIST>-<CLOUD>-<ARCH>"
	@echo "  WHERE <DIST> is bullseye, buster, stretch or sid"
	@echo "    And <CLOUD> is azure, ec2, gce, generic, genericcloud, nocloud, vagrant"
	@echo "    And <ARCH> is amd64, arm64, ppc64el"
	@echo "Set DESTDIR= to write images to given directory."

image-%:
	umask 022; \
	./bin/debian-cloud-images build \
	  $(subst -, ,$*) \
	  --build-id manual \
	  --version $(shell date '+%Y%m%d%H%M') \
	  --localdebs \
	  --output $(DESTDIR) \
	  --override-name image-$*

boxed-%.box:
	$(MAKE) $*
	utils/vagrant/libvirt/create-vagrant-libvirt-box.sh $*.raw

clean:
	rm -rf image-*.* boxed-*.box
