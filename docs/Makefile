# Makefile for Sphinx documentation
#

SPHINXOPTS		= -d $(BUILDDIR)/doctrees
BUILDBIN			= python3
BUILDOPTS			= -msphinx
SPHINXBUILD		= $(BUILDBIN) $(BUILDOPTS)
BUILDDIR			= ../public
PARSER_FILE			= parser.py

ifeq ($(shell which $(BUILDBIN) >/dev/null 2>&1; echo $$?), 1)
$(error The '$(SPHINXBUILD)' command was not found. Make sure you have Sphinx installed, then set the SPHINXBUILD make variable to point to the full path of the '$(SPHINXBUILD)' executable. Alternatively you can add the directory with the executable to your PATH. If you don't have Sphinx installed, grab it from http://sphinx-doc.org/)
endif

.PHONY: clean html

clean:
	rm -rf $(BUILDDIR)/*

html:
	mkdir -p $(BUILDDIR)
	$(BUILDBIN) $(PARSER_FILE) -i ../complots_client/scripts/core/ -o classes/core/ class_client_
	cp conf.py $(BUILDDIR)
	$(SPHINXBUILD) -b html $(SPHINXOPTS) . $(BUILDDIR)
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)."
