PROG=daedalus-project-mysql-utils

prefix = /usr/local
bindir = $(prefix)/bin
sharedir = $(prefix)/share
mandir = $(sharedir)/man
man1dir = $(mandir)/man1

TEST_DIR=$(PWD)/tests

all: build

test:
	@echo "executing $(PROG) unit tests"
	@echo "- messages"
	( $(TEST_DIR)/01-test_messages.sh )
	@echo "- connection variables"
	( $(TEST_DIR)/02-test_connection-variables.sh )


cover:
	./get_coverage tests


build:
	( cp -R lib clean_lib )
	( find clean_lib -type f -exec sed -i '/^\#.*$$/d' {} \; )
	( find clean_lib -type f -exec sed -i '/source .*$$/d' {} \; )
	( perl -pe 's/source lib\/(.*)$$/`cat clean_lib\/$$1`/e' src/$(PROG) > $(PROG) )
	( chmod 755 $(PROG) )
	( rm -rf clean_lib )

clean:
	( rm -f $(PROG) )
	( rm -rf coverage )
	( rm -rf clean_lib )

install:
	install $(PROG) $(DESTDIR)$(bindir)

uninstall:
	( rm $(DESTDIR)$(bindir)$(PROG) )
