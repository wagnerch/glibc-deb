libc = libc6.1
libc_extra_config_options = $(extra_config_options) --without-__thread --disable-sanity-checks

# NPTL Config
GLIBC_PASSES += nptl
