$(patsubst %,binaryinst_%,$(DEB_ARCH_REGULAR_PACKAGES) $(DEB_INDEP_REGULAR_PACKAGES)) :: binaryinst_% : $(stamp)binaryinst_%
$(patsubst %,$(stamp)binaryinst_%,$(DEB_ARCH_REGULAR_PACKAGES) $(DEB_INDEP_REGULAR_PACKAGES)): $(stamp)debhelper
	@echo Running debhelper for $(curpass)
	dh_testroot
	dh_installdirs -p$(curpass)
	dh_install -p$(curpass)
	dh_installman -p$(curpass)
	dh_installinfo -p$(curpass)
	dh_installdebconf -p$(curpass)
	dh_installchangelogs -p$(curpass)
	dh_installinit -p$(curpass)
	dh_link -p$(curpass)

	dh_strip -p$(curpass)
	dh_compress -p$(curpass)
	dh_fixperms -p$(curpass)
	dh_makeshlibs -p$(curpass)

	dh_installdeb -p$(curpass)
	dh_shlibdeps -p$(curpass)
	dh_gencontrol -p$(curpass)
	dh_md5sums -p$(curpass)
	dh_builddeb -p$(curpass)

	touch $@

debhelper: $(stamp)debhelper
$(stamp)debhelper:
	for x in `find debian/debhelper.in -type f -maxdepth 1`; do \
	 y=debian/`basename $$x`; \
	 z=`echo $$y | sed -e 's#/libc#/$(libc)#'`; \
	 cp $$x $$z; \
	 sed -e 's#TMPDIR#debian/tmp-libc#' -i $$z; \
	 sed -e 's#DEB_SRCDIR#$(DEB_SRCDIR)#' -i $$z; \
	done  

debhelper-clean:
	dh_clean 

	rm -f debian/*.install
	rm -f debian/*.manpages
	rm -f debian/*.links
	rm -f debian/*.postinst
	rm -f debian/*.preinst
	rm -f debian/*.postinst
	rm -f debian/*.prerm
	rm -f debian/*.postrm
	rm -f debian/*.info
	rm -f debian/*.init
	rm -f debian/*.config
	rm -f debian/*.templates
