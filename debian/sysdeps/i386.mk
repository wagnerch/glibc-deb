GLIBC_PASSES += nptl i686
DEB_ARCH_REGULAR_PACKAGES += libc6-i686

i686_MIN_KERNEL_SUPPORTED = 2.4.18

# NPTL requires at least i486 assembly
nptl_configure_target=i486-linux
nptl_configure_build=i486-linux
nptl_LIBDIR = /tls

i686_configure_target=i686-linux
i686_configure_build=i686-linux
i686_LIBDIR = /i686

nptl_extra_cflags = -march=i686 -mcpu=i686
i686_extra_cflags = -march=i686 -mcpu=i686

i686_extra_config_options = $(extra_config_options) --disable-profile --enable-omitfp --with-tls --without-__thread

libc_extra_config_options = $(extra_config_options) --with-tls --without-__thread

i686_add-ons = linuxthreads $(add-ons)
