# m68k cannot be compiled with >= 2.4.xx
MIN_KERNEL_SUPPORTED := 2.2.0

udeb_MIN_KERNEL_SUPPORTED = 2.4.1

libc_extra_config_options = $(extra_config_options) --without-__thread --disable-sanity-checks
