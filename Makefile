Version=16.06-devel

PREFIX = /usr/local
SYSCONFDIR = /etc

BIN = \
	bin/manjaro-live \
	bin/mhwd-live

LIBS = \
	lib/util-live.sh

SHARED = \
	kbd-model-map

RC = \
	init/rc/gnupg-mount \
	init/rc/manjaro-live \
	init/rc/mhwd-live \
	init/rc/pacman-init

SD = \
	init/sd/etc-pacman.d-gnupg.mount \
	init/sd/manjaro-live.service \
	init/sd/mhwd-live.service \
	init/sd/pacman-init.service

all: $(BIN)

edit = sed -e "s|@datadir[@]|$(DESTDIR)$(PREFIX)/share/manjaro-tools|g" \
	-e "s|@libdir[@]|$(DESTDIR)$(PREFIX)/lib/manjaro-tools|g"

%: %.in Makefile
	@echo "GEN $@"
	@$(RM) "$@"
	@m4 -P $@.in | $(edit) >$@
	@chmod a-w "$@"
	@chmod +x "$@"

clean:
	rm -f $(BIN)
	rm -rf man

install_base:
	install -dm0755 $(DESTDIR)$(PREFIX)/bin
	install -m0755 ${BIN} $(DESTDIR)$(PREFIX)/bin

	install -dm0755 $(DESTDIR)$(PREFIX)/lib/manjaro-tools
	install -m0644 ${LIBS} $(DESTDIR)$(PREFIX)/lib/manjaro-tools

	install -dm0755 $(DESTDIR)$(PREFIX)/share/manjaro-tools
	install -m0644 ${SHARED} $(DESTDIR)$(PREFIX)/share/manjaro-tools

install_rc:
	install -dm0755 $(DESTDIR)$(SYSCONFDIR)/init.d
	install -m0644 ${SYSCONF} $(DESTDIR)$(SYSCONFDIR)/init.d

install_sd:
	install -dm0755 $(DESTDIR)$(SYSCONFDIR)/manjaro-tools
	install -m0644 ${SYSCONF} $(DESTDIR)$(PREFIX)/lib/systemd/system

uninstall:
	for f in ${BIN}; do rm -f $(DESTDIR)$(PREFIX)/bin/$$f; done
	for f in ${SHARED}; do rm -f $(DESTDIR)$(PREFIX)/share/manjaro-tools/$$f; done
	for f in ${LIBS}; do rm -f $(DESTDIR)$(PREFIX)/lib/manjaro-tools/$$f; done

uninstall_rc:
	for f in ${RC}; do rm -f $(DESTDIR)$(SYSCONFDIR)/init.d/$$f; done

uninstall_sd:
	for f in ${SD}; do rm -f $(DESTDIR)$(PREFIX)/lib/systemd/system/$$f; done

install: install_base install_rc install_sd

uninstall: uninstall_base uninstall_rc uninstall_sd

dist:
	git archive --format=tar --prefix=manjaro-tools-livecd-$(Version)/ $(Version) | gzip -9 > manjaro-tools-livecd-$(Version).tar.gz
	gpg --detach-sign --use-agent manjaro-tools-livecd-$(Version).tar.gz

.PHONY: all clean install uninstall dist
