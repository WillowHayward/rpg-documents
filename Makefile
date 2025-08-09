# --- config ---
LATEXMK := latexmk -lualatex -interaction=nonstopmode -halt-on-error -file-line-error

# --- docs ---
DOCS          := player-guide knights-of-carith example-book example-fancy-book example-article example-high-contrast
DOCSSRCDIR    := docs
DOCSBUILDDIR  := build
DOC_TEXINPUTS := $(abspath lib/5e-latex)//:$(abspath lib/5e-SRD)//:$(abspath utils)//:

.PHONY: all-docs $(DOCS) $(DOCS:%=%-printable) $(DOCS:%=%-all)

# Build all listed docs at once
all-docs: $(DOCS:%=$(DOCSBUILDDIR)/%/%.pdf) $(DOCS:%=$(DOCSBUILDDIR)/%/%-printable.pdf)

# --- PHONY shortcuts delegate to file targets (so .tree runs) ---
$(DOCS): %: $(DOCSBUILDDIR)/%/%.pdf
	@:

$(DOCS:%=%-printable): %-printable: $(DOCSBUILDDIR)/%/%-printable.pdf
	@:

$(DOCS:%=%-all): %-all:
	@$(MAKE) $* && $(MAKE) $*-printable

# --- file targets that actually build the PDFs ---
$(DOCSBUILDDIR)/%/%.pdf: $(DOCSSRCDIR)/%/main.tex | $(DOCSBUILDDIR)/%/.tree
	TEXINPUTS="$(DOC_TEXINPUTS)" \
	$(LATEXMK) -cd -jobname="$*" -output-directory="../../$(DOCSBUILDDIR)/$*" "$<"

$(DOCSBUILDDIR)/%/%-printable.pdf: $(DOCSSRCDIR)/%/main.tex | $(DOCSBUILDDIR)/%/.tree
	TEXINPUTS="$(DOC_TEXINPUTS)" RPG_PRINTABLE=1 \
	$(LATEXMK) -cd -jobname="$*-printable" -output-directory="../../$(DOCSBUILDDIR)/$*" "$<"

# --- ensure build/<doc>/... exists (mirror subdirs like sections/) ---
$(DOCSBUILDDIR)/%/.tree:
	mkdir -p "$(DOCSBUILDDIR)/$*"
	cd "$(DOCSSRCDIR)/$*" && find . -type d -print | while read d; do \
	  mkdir -p "$(abspath $(DOCSBUILDDIR))/$*/$${d#./}"; \
	done
	touch "$@"

# ---------- characters ----------
CHARS          := example
CHARSRCDIR     := chars
CHARBUILDDIR   := build/chars
CHAR_TEXINPUTS := $(abspath lib/5e-latex-character-sheet)//:$(abspath utils)//:

.PHONY: all-chars $(CHARS:%=character-%)

# Build all listed characters at once
all-chars: $(CHARS:%=$(CHARBUILDDIR)/%.pdf)

# Convenience: make character-<name>
$(CHARS:%=character-%): character-%: $(CHARBUILDDIR)/%.pdf
	@:

# chars/<name>.tex -> build/chars/<name>.pdf
$(CHARBUILDDIR)/%.pdf: $(CHARSRCDIR)/%.tex | $(CHARBUILDDIR)
	TEXINPUTS="$(CHAR_TEXINPUTS)" \
	$(LATEXMK) -cd -jobname="$*" -output-directory="../$(CHARBUILDDIR)" "$<"

# ensure build/chars exists
$(CHARBUILDDIR):
	mkdir -p "$@"

# --- all ---
.PHONY: all

all: $(DOCS:%=$(DOCSBUILDDIR)/%/%.pdf) $(DOCS:%=$(DOCSBUILDDIR)/%/%-printable.pdf) $(CHARS:%=$(CHARBUILDDIR)/%.pdf)

# --- clean ---
.PHONY: clean
clean:
	rm -rf "$(DOCSBUILDDIR)"

