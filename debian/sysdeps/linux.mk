GLIBC_OVERLAYS ?= $(shell ls nptl* glibc-linuxthreads*)
MIN_KERNEL_SUPPORTED := 2.2.0
libc = libc6

# By default we just do linuxthreads.
GLIBC_PASSES=linuxthreads
threads = yes

ifndef LINUX_SOURCE
  LINUX_SOURCE := $(CURDIR)/linux-kernel-headers
endif

# Minimum Kernel supported
with_headers = --with-headers=$(LINUX_SOURCE)/include --enable-kernel=$(MIN_KERNEL_SUPPORTED)

# NPTL Config
nptl_add-ons = nptl $(add-ons)
nptl_extra_config_options = $(extra_config_options) --with-tls --disable-profile --enable-omitfp
nptl_MIN_KERNEL_SUPPORTED = 2.6.0

# Linuxthreads Config
linuxthreads_add-ons = linuxthreads $(add-ons)
