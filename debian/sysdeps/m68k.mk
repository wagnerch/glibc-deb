MIN_KERNEL_SUPPORTED := 2.4.1

udeb_MIN_KERNEL_SUPPORTED = 2.4.1

libc_extra_config_options = $(extra_config_options) --without-tls --disable-sanity-checks
libc_add-ons = ports linuxthreads $(add-ons)
