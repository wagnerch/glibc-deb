libc_add-ons = ports linuxthreads $(add-ons)
libc_extra_config_options = $(extra_config_options) --disable-sanity-checks

# hppa64 needs symlink /usr/hppa64-linux/include to /usr/include
# (See: Bug#239020)  In future we may drop this file with supporting hppa64.

define libc6-dev_extra_pkg_install
mkdir -p debian/$(curpass)/usr
mkdir -p debian/$(curpass)/usr/hppa64-linux
ln -sf /usr/include debian/$(curpass)/usr/hppa64-linux/include
mkdir -p debian/$(curpass)/usr/hppa64-linux-gnu
ln -sf /usr/include debian/$(curpass)/usr/hppa64-linux-gnu/include
endef

