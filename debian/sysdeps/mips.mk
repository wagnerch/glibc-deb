udeb_MIN_KERNEL_SUPPORTED = 2.4.1
udeb_extra_cflags = -Os

libc_extra_config_options = $(extra_config_options) --without-__thread --disable-sanity-checks
libc_add-ons = ports $(add-ons)
