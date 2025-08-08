DOCS := player-guide

SRCDIR := docs
BUILDDIR := build
LATEXMK := latexmk -lualatex -interaction=nonstopmode -halt-on-error -file-line-error
TEXINPUTS := $(abspath lib)//:
export TEXINPUTS

.PHONY: all clean $(DOCS) $(DOCS:%=%-printable) $(DOCS:%=%-all)

# Build ALL docs, both flavours, straight into ./build
all: $(DOCS:%=$(BUILDDIR)/%.pdf) $(DOCS:%=$(BUILDDIR)/%-printable.pdf)

# Per-doc shortcuts
$(DOCS): %: $(BUILDDIR)/%.pdf
$(DOCS:%=%-printable): %-printable: $(BUILDDIR)/%-printable.pdf
$(DOCS:%=%-all): %-all: $(BUILDDIR)/%.pdf $(BUILDDIR)/%-printable.pdf

# Normal build -> ./build/document-x.pdf (+ aux/logs also in ./build)
$(BUILDDIR)/%.pdf: $(SRCDIR)/%/main.tex | $(BUILDDIR)
	$(LATEXMK) -cd -jobname="$*" -output-directory="../../$(BUILDDIR)" $<

# Printable build -> ./build/document-x-printable.pdf (+ aux/logs also in ./build)
$(BUILDDIR)/%-printable.pdf: $(SRCDIR)/%/main.tex | $(BUILDDIR)
	export RPG_PRINTABLE=true && $(LATEXMK) -cd -jobname="$*-printable" -output-directory="../../$(BUILDDIR)" $<

# Ensure ./build exists
$(BUILDDIR):
	mkdir -p "$@"

clean:
	latexmk -C -output-directory="$(BUILDDIR)"
	rm -rf "$(BUILDDIR)"

