EGLIBC_SVN = svn://svn.eglibc.org
EGLIBC_BRANCH = branches/eglibc-$(shell echo $(EGLIBC_VERSION) | sed -e 's/\([0-9]\+\)\.\([0-9]\+\).*/\1_\2/')
EGLIBC_CHECKOUT = eglibc-checkout
EGLIBC_DIR = eglibc-$(EGLIBC_VERSION)
DEB_ORIG = ../eglibc_$(EGLIBC_VERSION).orig.tar.gz

get-orig-source: $(DEB_ORIG)
$(DEB_ORIG):
	svn co $(EGLIBC_SVN)/$(EGLIBC_BRANCH) $(EGLIBC_CHECKOUT)
	svn export $(EGLIBC_CHECKOUT)/libc $(EGLIBC_DIR)
	svn export $(EGLIBC_CHECKOUT)/linuxthreads/linuxthreads $(EGLIBC_DIR)/linuxthreads
	svn export $(EGLIBC_CHECKOUT)/linuxthreads/linuxthreads_db $(EGLIBC_DIR)/linuxthreads_db
	svn export $(EGLIBC_CHECKOUT)/ports $(EGLIBC_DIR)/ports
	svn status -v $(EGLIBC_CHECKOUT)/libc/ChangeLog | sed '1,1s/^ \+\([0-9]\+\).*/\1/g' > $(EGLIBC_DIR)/.svn-revision
	rm -fr $(EGLIBC_DIR)/manual
	tar -zcf $(DEB_ORIG) $(EGLIBC_DIR)
	rm -rf $(EGLIBC_DIR) $(EGLIBC_CHECKOUT)
