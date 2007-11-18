libc = libc6.1

# Requires Linux 2.6.9 for NPTL
libc_MIN_KERNEL_SUPPORTED = 2.6.9

# build an ev67 optimized library
#GLIBC_PASSES += ev67
#DEB_ARCH_REGULAR_PACKAGES += libc6.1-ev67
ev67_add-ons = nptl $(add-ons)
ev67_configure_target = alphaev67-linux
ev67_extra_cflags = -mcpu=ev67 -mtune=ev67 -g -O3
ev67_extra_config_options = $(extra_config_options) --disable-profile
ev67_rltddir = /lib/ev67
ev67_slibdir = /lib/ev67
