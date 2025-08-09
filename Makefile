DOCS := player-guide knights-of-carith example-book example-fancy-book example-article example-high-contrast

SRCDIR := docs
BUILDDIR := build
LATEXMK := latexmk -lualatex -interaction=nonstopmode -halt-on-error -file-line-error
TEXINPUTS := $(abspath lib/5e-latex)//:$(abspath lib/5e-SRD)//:$(abspath utils)//:
export TEXINPUTS

.PHONY: all clean $(DOCS) $(DOCS:%=%-printable) $(DOCS:%=%-all)

# Build ALL docs, both flavours, straight into ./build
all: $(DOCS:%=$(BUILDDIR)/%/%.pdf) $(DOCS:%=$(BUILDDIR)/%/%-printable.pdf)

# Per-doc shortcuts
$(DOCS): %: $(BUILDDIR)/%/%.pdf
$(DOCS:%=%-printable): %-printable: $(BUILDDIR)/%/%-printable.pdf
$(DOCS:%=%-all): %-all: $(BUILDDIR)/%/%.pdf $(BUILDDIR)/%/%-printable.pdf

# Per-doc shortcuts delegate to the file targets
$(DOCS):
	$(MAKE) $(BUILDDIR)/$@/$@.pdf

$(DOCS:%=%-printable):
	$(MAKE) $(BUILDDIR)/$*/$*-printable.pdf

# Normal build -> build/<doc>/<doc>.pdf
$(BUILDDIR)/%/%.pdf: $(SRCDIR)/%/main.tex | $(BUILDDIR)/%/.tree
	$(LATEXMK) -cd -jobname="$*" -output-directory="../../$(BUILDDIR)/$*" $<

# Printable build -> build/<doc>/<doc>-printable.pdf
$(BUILDDIR)/%/%-printable.pdf: $(SRCDIR)/%/main.tex | $(BUILDDIR)/%/.tree
	RPG_PRINTABLE=1 $(LATEXMK) -cd -jobname="$*-printable" -output-directory="../../$(BUILDDIR)/$*" $<


# Ensure build/<doc> exists and mirror subdirs from docs/<doc> (e.g., sections/)
$(BUILDDIR)/%/.tree:
	mkdir -p "$(BUILDDIR)/$*"
	cd "$(SRCDIR)/$*" && find . -type d -print | while read d; do \
	  mkdir -p "$(abspath $(BUILDDIR))/$*/$${d#./}"; \
	done
	touch "$@"


clean:
	latexmk -C -output-directory="$(BUILDDIR)"
	rm -rf "$(BUILDDIR)"

