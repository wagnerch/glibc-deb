GLIBC_OVERLAYS ?= $(shell ls nptl* glibc-linuxthreads*)
MIN_KERNEL_SUPPORTED := 2.2.0
libc = libc6

# Support multiple makes at once based on number of processors
NJOBS=$(shell if [ -f /proc/cpuinfo ] ; then echo `cat /proc/cpuinfo | grep 'processor' | wc -l` ; else echo 1 ; fi)

# Linuxthreads Config
threads = yes
libc_add-ons = linuxthreads $(add-ons)

ifndef LINUX_SOURCE
  LINUX_HEADERS := /usr/include
else
  LINUX_HEADERS := $(LINUX_SOURCE)/include
endif

# Minimum Kernel supported
with_headers = --with-headers=$(shell pwd)/debian/include --enable-kernel=$(call xx,MIN_KERNEL_SUPPORTED)

# NPTL Config
nptl_add-ons = nptl $(add-ons)
nptl_extra_config_options = $(extra_config_options) --with-tls --with-__thread --disable-profile --enable-omitfp
nptl_MIN_KERNEL_SUPPORTED = 2.6.0

LINUX_HEADER_DIR = $(stamp)mkincludedir
$(stamp)mkincludedir:
	rm -rf debian/include
	mkdir debian/include
	ln -s $(LINUX_HEADERS)/linux debian/include
	ln -s $(LINUX_HEADERS)/asm-generic debian/include
	ln -s $(LINUX_HEADERS)/asm debian/include

	# To make configure happy if libc6-dev is not installed.
	touch debian/include/assert.h

	touch $@

# Also to make configure happy.
export CPPFLAGS = -isystem $(shell pwd)/debian/include

# This round of ugliness decomposes the Linux kernel version number
# into an integer so it can be easily compared and then does so.
kernel_check = $(shell minimum=$$((`echo $(1) | sed 's/\([0-9]*\)\.\([0-9]*\)\.\([0-9]*\).*/\1 \* 65536 + \2 \* 256 + \3/'`)); \
current=$$((`echo $(CURRENT_KERNEL_VERSION) | sed 's/\([0-9]*\)\.\([0-9]*\)\.\([0-9]*\).*/\1 \* 65536 + \2 \* 256 + \3/'`)); \
if [ $$current -ge $$minimum ]; then \
  echo ""; \
  else \
    echo '$$(error You must running at least kernel version $(1) to compile this)'; \
fi)
