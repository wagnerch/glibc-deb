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

	rm -f $(stamp)binaryinst*
