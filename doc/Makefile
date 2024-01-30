# Makefile for Tablicious Octave package documentation
#
# (Custom Tablicious modification of the standard OF docgen tools.)
#
# See README.md for more info.
#
# This setup uses the convention that "*-in.texi" files are the human-editable
# input files, and corresponding "*.texi" files are processed intermediate
# files, where feasible.
#
# This Makefile is generic enough that it could be dropped without modification
# in the doc/ directory of any package that follows the Octave Forge conventions,
# as modified by Tablicious. You need to include its dependencies: mktexi.pl,
# OctTexiDoc.pm, and README.md. And then create a src/<pkg>.qhcp modified for your
# package.
#
# And make sure that your texinfo doc strings follow these conventions:
#   - each @node must be followed immediately by a @chapter/@section/@subsection/@subsubsection
#
# Notes:
# - You need to have Qt 5.x or newer installed, and its tools available on the path.
# - Mac: This requires a newer version of Texinfo that ships with macOS. 4.8 and 5.2 are too
#   old. 6.x or newer is required; I have tested on 6.6 and 7.0. You must get the new texinfo
#   tools on your path in front of the system Texinfo before running these make targets.
#   With Homebrew, you can do `brew install texinfo` and manually add 
#   `$(brew --prefix texinfo)/bin` to the FRONT of your $PATH. I do this by running
#   `PATH="$(brew --prefix texinfo)/bin:$PATH" when I start working with this code.
# - On Ubuntu, don't forget to `apt-get install qt5-defaults`!
# - On Mac, `brew install findutils`
#
# This Makefile originates from the Tablicious package (https://github.com/apjanke/octave-tablicious)
# and is based on the one from the Octave Forge communications package
# (https://octave.sourceforge.io/communications/index.html).

# TODO:
#   * I'd like to put the generated output files in a subdir, to keep them separated
#     from the toolchain files in this dir, but I don't know if that works with OF
#     conventions.

## Some basic tools (can be overriden using environment variables)
SED ?= sed
TAR ?= tar
GREP ?= grep
CUT ?= cut

## Note the use of ':=' (immediate set) and not '=' (lazy set).
## http://stackoverflow.com/a/448939/1609556
package := $(shell $(GREP) "^Name: " ../DESCRIPTION | $(CUT) -f2 -d" ")
version := $(shell $(GREP) "^Version: " ../DESCRIPTION | $(CUT) -f2 -d" ")

DVIPS = dvips
LN_S = ln -s
PERL = perl

ifndef OCTAVE
OCTAVE := octave
endif
OCTAVE := $(OCTAVE) --no-gui --silent --norc

UNAME=$(shell uname)
ifeq ($(UNAME),Darwin)
	FIND = gfind
else
	FIND = find
endif

MAKEINFO = makeinfo
TEXI2DVI = texi2dvi
TEXI2HTML = makeinfo --html
TEXI2PDF = texi2pdf

# This discovery of the Qt tools is hacky BS. Help wanted with
# a better way to do this.
# As of 2023-ish, the plain "qt" brew formula is Qt 6, but Octave still
# uses Qt 5, which the "qt@5" versioned formula will give.
BREW=$(shell which brew 2>/dev/null)
ifneq ($(BREW),)
	BREW_QT = $(shell brew --prefix qt@5)
	ifeq ($(wildcard $(BREW_QT)/bin/qhelpgenerator),)
		QHELPGENERATOR = $(BREW_QT)/bin/qcollectiongenerator
	else
		QHELPGENERATOR = $(BREW_QT)/bin/qhelpgenerator
	endif
else ifneq ($(wildcard /usr/bin/qtchooser),)
	# Probe for actual qhelpgenerator implementation existence
	# Gotta do this because the /usr/bin/qt{help,collection}generator shim always
	# exists regardless of whether the installed Qts provide them
	ifneq ($(shell qhelpgenerator -qt5 2>/dev/null),)
		QHELPGENERATOR = qhelpgenerator -qt5
	else
		QHELPGENERATOR = qcollectiongenerator -qt5
	endif
else
	ifneq ($(shell which qcollectiongenerator 2>/dev/null),)
		QHELPGENERATOR = qcollectiongenerator
    else
		QHELPGENERATOR = qhelpgenerator
	endif
endif

# We depend on all files in the input source directories
SRCDIRS := ../inst
SRCFILES := $(shell find $(SRCDIRS) -type f)

INFODOC = $(package).info
DVIDOC = $(patsubst %.info,%.dvi,$(INFODOC))
PSDOC = $(patsubst %.info,%.ps,$(INFODOC))
PDFDOC = $(patsubst %.info,%.pdf,$(INFODOC))
TEXIDOC = $(patsubst %.info,%.texi,$(INFODOC))
INDEX = ../INDEX

default: all
all: info html pdf qhelp
info: $(INFODOC)
dvi: $(DVIDOC)
pdf: $(PDFDOC)
ps: $(PSDOC)
qhelp: $(package).qhc

# TIMESTAMP holds the POSIX time of the last mtime of any source file
TIMESTAMP: $(SRCFILES)
	$(FIND) $(SRCDIRS) -type f -printf '%T@\n' | cut -d '.' -f 1 | sort -n | tail -1 > TIMESTAMP

# This target generates <pkg>.texi and also <pkg>.qhp as a side effect
.PRECIOUS: tablicious.texi
tablicious.texi : src/tablicious.texi mktexi.pl $(SRCFILES) TIMESTAMP
	export SOURCE_DATE_EPOCH=`cat TIMESTAMP`; \
	$(PERL) ./mktexi.pl $< $(INDEX) $@ $(package).qhp $(SRCDIRS)

check-texinfo-version:
	$(PERL) ./mktexi.pl --check-texinfo-version

%.dvi: %.texi check-texinfo-version
	$(TEXI2DVI) --quiet --clean -o $@ $<

%.info: %.texi check-texinfo-version
	$(MAKEINFO) --no-split -o $@ $<

%.pdf: %.texi TIMESTAMP check-texinfo-version
	export SOURCE_DATE_EPOCH=`cat TIMESTAMP`; \
	$(TEXI2PDF) --quiet --clean -o $@ $<

%.ps: %.dvi
	$(DVIPS) -o $@ $<

$(package).qhc: $(package).qhcp $(package).qhp TIMESTAMP
	$(QHELPGENERATOR) $(package).qhcp -o $(package).qhc

$(package).html: $(package).texi
	$(TEXI2HTML) --no-split -o $(package).html $<

# "html" is a phony target, not the actual html/ directory
html: $(package).texi $(package).html check-texinfo-version
	rm -rf html
	$(TEXI2HTML) -o html $<

# Auxiliary make file defines build rules for generated images for the manual
-include images.mk
images.mk: images.sh
	$(SHELL) $< > $@

$(DVIDOC): $(IMAGES_EPS)
$(PDFDOC): $(IMAGES_PDF)

HTMLDIR_IMAGES = $(addprefix $(HTMLDOC)/,$(IMAGES_PNG))
$(HTMLDIR_IMAGES): $(IMAGES_PNG) | $(HTMLDOC)
	cp $(@F) $@

html: $(HTMLDIR_IMAGES)

# The images included in the HTML manual must be present before the makeinfo
# command is invoked or it will fall back on incorrect file names.
$(HTMLDOC): $(IMAGES_PNG)

# The texi2dvi script (used to create both PDF and DVI output formats)
# uses some fixed temporary file names.  In order to avoid a race condition
# the DVI and PDF builds are forced to run serially through a Makefile rule.
$(PDFDOC): $(DVIDOC)


maintainer-clean: 
	rm -rf html *.dvi *.eps *.html *.info *.pdf *.ps *.png *.texi *.qhp *.qch *.qhc *.tmp images.mk TIMESTAMP

# I like a plain "clean" target, bc I keep forgetting that maintainer-clean exists -apj
clean: maintainer-clean

.PHONY: default all clean maintainer-clean dvi html info pdf ps qhelp check-texinfo-version
