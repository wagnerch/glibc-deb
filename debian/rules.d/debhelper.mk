# This is so horribly wrong.  libc-pic does a whole pile of gratuitous
# renames.  There's very little we can do for now.  Maybe after
# Sarge releases we can consider breaking packages, but certainly not now.

$(stamp)binaryinst_$(libc)-pic:: $(stamp)debhelper
	@echo Running special kludge for $(libc)-pic
	dh_testroot
	dh_installdirs -p$(curpass)
	install --mode=0644 build-tree/$(DEB_HOST_ARCH)-libc/libc_pic.a debian/$(libc)-pic/usr/lib/.
	install --mode=0644 build-tree/$(DEB_HOST_ARCH)-libc/libc.map debian/$(libc)-pic/usr/lib/libc_pic.map
	install --mode=0644 build-tree/$(DEB_HOST_ARCH)-libc/elf/soinit.os debian/$(libc)-pic/usr/lib/libc_pic/soinit.o
	install --mode=0644 build-tree/$(DEB_HOST_ARCH)-libc/elf/sofini.os debian/$(libc)-pic/usr/lib/libc_pic/sofini.o

	install --mode=0644 build-tree/$(DEB_HOST_ARCH)-libc/math/libm_pic.a debian/$(libc)-pic/usr/lib/.
	install --mode=0644 build-tree/$(DEB_HOST_ARCH)-libc/libm.map debian/$(libc)-pic/usr/lib/libm_pic.map
	install --mode=0644 build-tree/$(DEB_HOST_ARCH)-libc/resolv/libresolv_pic.a debian/$(libc)-pic/usr/lib/.
	install --mode=0644 build-tree/$(DEB_HOST_ARCH)-libc/libresolv.map debian/$(libc)-pic/usr/lib/libresolv_pic.map


$(patsubst %,binaryinst_%,$(DEB_ARCH_REGULAR_PACKAGES) $(DEB_INDEP_REGULAR_PACKAGES)) :: binaryinst_% : $(stamp)binaryinst_%
$(patsubst %,$(stamp)binaryinst_%,$(DEB_ARCH_REGULAR_PACKAGES) $(DEB_INDEP_REGULAR_PACKAGES)):: $(stamp)debhelper
	@echo Running debhelper for $(curpass)
	dh_testroot
	dh_installdirs -p$(curpass)
	dh_install -p$(curpass)
	dh_installman -p$(curpass)
	dh_installinfo -p$(curpass)
	dh_installdebconf -p$(curpass)
	dh_installchangelogs -p$(curpass)
	dh_installinit -p$(curpass)
	dh_installdocs -p$(curpass) 
	dh_link -p$(curpass)

	if [ ! $(NOSTRIP_$(curpass)) ]; then \
	  dh_strip -p$(curpass); \
	fi

	dh_compress -p$(curpass)
	dh_fixperms -p$(curpass) -X lib/ld
	dh_makeshlibs -p$(curpass)

	dh_installdeb -p$(curpass)
	# dh_shlibdeps -p$(curpass)
	dh_gencontrol -p$(curpass)
	dh_md5sums -p$(curpass)
	dh_builddeb -p$(curpass)

	touch $@

# We may eventually want $(libc)-udeb instead of libc-udeb.
$(patsubst %,binaryinst_%,$(DEB_UDEB_PACKAGES)) :: binaryinst_% : $(stamp)binaryinst_%
$(patsubst %,$(stamp)binaryinst_%,$(DEB_UDEB_PACKAGES)): $(stamp)debhelper
	@echo Running debhelper for $(curpass)
	dh_testroot
	dh_installdirs -p$(curpass)
	dh_install -p$(curpass)
	dh_compress -p$(curpass)
	dh_fixperms -p$(curpass) -X lib/ld
	dh_makeshlibs -p$(curpass)
	dh_installdeb -p$(curpass)
	# dh_shlibdeps -p$(curpass)
	dh_gencontrol -p$(curpass) -fdebian/files~
	dpkg-distaddfile $(curpass)_$(DEB_VERSION)_$(DEB_BUILD_ARCH).udeb debian-installer required
	dh_builddeb -p$(curpass) --filename=$(curpass)_$(DEB_VERSION)_$(DEB_BUILD_ARCH).udeb



#Ugly kludge:
# I'm running out of time to get this sorted out properly.  Basically
# the problem is that nptl is like an optimised library, but not quite.
# So we'll filter it out of the passes list and deal with it specifically.
#
# Ideally, there should be some way of having an optimisation pass and
# say "include this in the main library" by setting a variable.
# But after 10 hours of staring at this thing, I can't figure it out.

OPT_PASSES = $(filter-out libc nptl,$(GLIBC_PASSES))
NPTL = $(filter nptl,$(GLIBC_PASSES))

debhelper: $(stamp)debhelper
$(stamp)debhelper:
	for x in `find debian/debhelper.in -type f -maxdepth 1`; do \
	  y=debian/`basename $$x`; \
	  z=`echo $$y | sed -e 's#/libc#/$(libc)#'`; \
	  cp $$x $$z; \
	  sed -e "s#TMPDIR#debian/tmp-libc#" -i $$z; \
	  sed -e "s#DEB_SRCDIR#$(DEB_SRCDIR)#" -i $$z; \
	  case $$z in \
	    *.install) sed -e "s/^#.*//" -i $$z ;; \
	  esac; \
	done  

# This little bit of fun works around the bug that libc-udeb is misnamed:
# It doesn't have the version number attached to it.  We'll piss off the
# d-i folks *after* sarge has release by fixing this.  In the mean time
# we suck it up and deal.

	for x in `find debian/debhelper.in -type f -maxdepth 1`; do \
	  y=debian/`basename $$x`; \
	  z=`echo $$y | sed -e 's#/libc#/$(libc)#'`; \
	  cp $$x $$z; \
	  sed -e "s#TMPDIR#debian/tmp-libc#" -i $$z; \
	  sed -e "s#DEB_SRCDIR#$(DEB_SRCDIR)#" -i $$z; \
	  case $$z in \
	    *.install) sed -e "s/^#.*//" -i $$z ;; \
	  esac; \
	done

	for x in $(OPT_PASSES); do \
	  z=debian/$(libc)-$$x.install; \
	  cp debian/debhelper.in/libc-otherbuild.install $$z; \
	  sed -e "s#TMPDIR#debian/tmp-$$x#" -i $$z; \
	  sed -e "s#DEB_SRCDIR#$(DEB_SRCDIR)#" -i $$z; \
	  sed -e "s#DESTLIBDIR#$$x#" -i $$z; \
	  case $$z in \
	    *.install) sed -e "s/^#.*//" -i $$z ;; \
	  esac; \
	done

	# We use libc-otherbuild for this, since it's just a special case of
	# an optimised library that needs to wind up in /lib/tls
	# FIXME: We do not cover the case of processor optimised 
	# nptl libraries, like /lib/i686/tls
	# We probably don't care for now.
	for x in $(NPTL); do \
	  z=debian/$(libc).install; \
	  cat debian/debhelper.in/libc-otherbuild.install >>$$z; \
	  sed -e "s#TMPDIR#debian/tmp-$$x#" -i $$z; \
	  sed -e "s#DEB_SRCDIR#$(DEB_SRCDIR)#" -i $$z; \
	  sed -e "s#DESTLIBDIR#tls#" -i $$z; \
	  case $$z in \
	    *.install) sed -e "s/^#.*//" -i $$z ;; \
	  esac; \
	done

	touch $(stamp)debhelper

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
	rm -f debian/*.dirs

	rm -f $(stamp)binaryinst*
