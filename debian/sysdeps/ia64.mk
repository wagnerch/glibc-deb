GLIBC_PASSES += nptl

libc = libc6.1

libc_extra_config_options = $(extra_config_options) --without-__thread --disable-sanity-checks
