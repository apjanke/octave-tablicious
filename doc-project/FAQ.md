Chrono FAQ
==========

## General

### Is this code ready for production use?

*NO!* This is alpha code, not even in a beta release yet. Do *NOT* use this for your business or production code needs yet!

## Build issues

###

Like this?

```
$ make doc                                                                                                                                         master ✱
cd doc && make maintainer-clean && make all
rm -rf *.tmp
rm -rf *.dvi *.eps *.html *.info *.pdf *.ps *.png *.texi *.qhp *.qch *.qhc images.mk
perl ./mkdoc.pl DOCSTRINGS.texi.tmp ../inst ../src
perl ./mktexi.pl chrono.texi.in DOCSTRINGS.texi.tmp ../INDEX chrono.texi
makeinfo --no-split -o chrono.info chrono.texi
chrono.texi:10: warning: unrecognized encoding name `UTF-8'.
chrono.texi:31: warning: undefined flag: VERSION.
chrono.texi:53: warning: undefined flag: VERSION.
chrono.texi:79: warning: undefined flag: VERSION.
chrono.texi:729: warning: undefined flag: VERSION.
/Users/janke/local/repos/octave-chrono/doc//chrono.texi:389: `Functions Alphabetically' has no Up field (perhaps incorrect sectioning?).
/Users/janke/local/repos/octave-chrono/doc//chrono.texi:335: `Funtions by Category' has no Up field (perhaps incorrect sectioning?).
/Users/janke/local/repos/octave-chrono/doc//chrono.texi:243: `Defined Time Zones' has no Up field (perhaps incorrect sectioning?).
/Users/janke/local/repos/octave-chrono/doc//chrono.texi:148: `datenum Compatibility' has no Up field (perhaps incorrect sectioning?).
/Users/janke/local/repos/octave-chrono/doc//chrono.texi:335: warning: unreferenced node `Funtions by Category'.
/Users/janke/local/repos/octave-chrono/doc//chrono.texi:243: warning: unreferenced node `Defined Time Zones'.
/Users/janke/local/repos/octave-chrono/doc//chrono.texi:148: warning: unreferenced node `datenum Compatibility'.
makeinfo: Removing output file `chrono.info' due to errors; use --force to preserve.
make[1]: *** [chrono.info] Error 1
make: *** [doc] Error 2
```

Your Texinfo is too old. Get a newer one.

On macOS, you can do this with Homebrew.

```
brew install texinfo
PATH="$(brew --prefix texinfo)/bin:$PATH" make doc
```


### I'm getting weird `sed: ...@documenten...` warnings in the `make doc` step?

Like this?

```
$ make doc
[...]
/usr/local/opt/texinfo/bin/texi2pdf --quiet --clean -o chrono.pdf chrono.texi
sed: 2: "s/\(^\|.* \)@documenten ...": whitespace after branch
sed: 4: "s/\(^\|.* \)@documenten ...": whitespace after label
sed: 6: "s/\(^\|.* \)@documenten ...": undefined label 'found
[...]
```

Those warnings are produced by older Texinfo programs, like Texinfo 4.8, which is the default on macOS 10.13 and 10.14. [Install a newer Texinfo using Homebrew](https://github.com/apjanke/octave-chrono/issues/17) and pull that in explicitly for your build.

```
brew install texinfo
PATH="$(brew --prefix texinfo)/bin:$PATH" make doc
```
