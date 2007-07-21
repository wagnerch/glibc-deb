# Build with gcc-4.2 causes regression
CC = gcc-4.1
CXX = g++-4.1
BUILD_CC = gcc-4.1

libc_extra_cflags = -march=i486 -mtune=i686 -g -O3

GLIBC_PASSES += i686
DEB_ARCH_REGULAR_PACKAGES += libc0.1-i686

# We use -march=i686 and glibc's i686 routines use cmov, so require it.
# A Debian-local glibc patch adds cmov to the search path.
i686_add-ons = ports linuxthreads $(add-ons)
i686_configure_target=i686-kfreebsd
i686_extra_cflags = -march=i686 -mtune=i686 -g -O3
i686_rtlddir = /lib
i686_slibdir = /lib/i686/cmov
i686_extra_config_options = $(extra_config_options) --disable-profile --disable-compatible-utmp
