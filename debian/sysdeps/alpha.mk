libc = libc6.1

# disabled because alpha linuxthreads ex7, ex9, ex10, ex18 stopps eternally
# even if TIMEOUTSCALE is set - SIGALRM from the program is just ignored.
RUN_TESTSUITE = no

# work around to build on alpha, due to gcc-4.1 generating bad instructions.
CC = gcc-4.0
BUILD_CC = gcc-4.0

# disabled for static linked pthread programs.
libc_extra_config_options = $(extra_config_options) --without-__thread --disable-sanity-checks

# NPTL Config
GLIBC_PASSES += nptl
