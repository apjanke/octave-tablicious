# Tablicious Developer Notes

See also:

* [Design and Justification](Design-and-Justification.html) for info on
the design of this library.
* [Join Behavior](Join-Behavior.html) for a description of the "proxy keys" and other stuff related to join semantics and implementation.
* [TODO](TODO.html)
* [Release Checklist](Release-Checklist.html)

## Code

Tablicious is a decent-sized package, though not as large as some other Octave Forge packages. As of February 2024, it's about 39,000 lines of code and documentation.

To get familiar with the library, you probably want to start with the main `table` class, and then `datetime` and `string`, and at least skim the documentation (the User Manual plus the `*.md` files in this directory) before diving in to reading the code.

## Code Style and Principles

* Standard [GNU Octave code style](https://wiki.octave.org/Octave_style_guide)
* In general, use reallyLongDescriptiveNames for non-standard-Matlab-or-Octave functions you are adding, to reduce chance of name collisions.

## No Matlab usage!

To avoid issues with the Matlab license's Non-Compete clause, this project needs to be developed entirely using Octave, and not using Matlab at all, including for testing or benchmarking purposes. Please do not submit any Matlab test or benchmark results, or any code produced using Matlab. And if you know anything about how the Matlab internals work, please do not tell me!

## Our Documentation

### Building the Docs

The texinfo format we use requires Texinfo 6.0 or newer. This is newer than the Texinfo that comes with macOS, which ships a 5.x Texinfo. To build the docs on Mac, you will need to install a newer Texinfo (e.g. with Homebrew) and then make sure that Texinfo is on your path ahead of the system Texinfo.

### Texinfo notes

The `mktexi.pl` tool we use doesn't have great support for classdefs; it is more function-oriented. You need to work around that a little bit.

For methods in classes, including the constructor, you need to manually add a `@node <class>.<method>` line in the texinfo block, right before the `@deftypefn` line. That's because mktexi.pl will auto-generate `@node` lines for free functions, but not for methods inside functions. Other things – free functions, classdefs, and scripts, including those inside packages (namespaces) – should not have explicit `@node` lines in the texinfo; those will be added automatically by `mktexi.pl`.

For functions and classes inside packages (namespaces), you should fully qualify their names in the `@deftypefn` or `@deftp` lines. This will get their node name generated correctly, and IMHO is also how they should look in the presented help, because that's their full name, and they need to be addressed that way in the code (with either a fully-qualified name, or an `import` statement). And it makes it unambiguous what you're looking at, in the case of multiple functions or classes with the same non-namespace-qualified name. This approach also makes it so in the texinfo we're not relying on implicit package qualification via the file's location in the repo directory tree, and these things can be placed anywhere in the source tree with the same contents, and not have to be edited manually when they change, and not have to have special support in the `mktexi.pl` tooling for package directories.

The support for packages (namespaces) and classes in `mktexi.pl` is a Tablicious customization we added, after copying that tool from another OF package. `mktexi.pl` is heavily modified in other ways, and doesn't closely match the "standard" one used by other OF packages.

You need TeX installed, along with some TeX packages like those supplied in the TeXLive distribution. I don't know specifically which packages. They're some packages (or other things) supplied by the full MacTeX TeXLive distribution, but not by the BasicTeX version. If you don't have them, then the `texi2*` calls inside the `make doc` target may fail with errors like `/usr/local/bin/texi2dvi: texinfo.tex appears to be broken. ... ! I can't find file 'texinfo.tex'`.

## Unit Tests

Tablicious doesn't have great unit test coverage, but it has some. It uses a combination of regular Octave style BISTs and [MP-Test](https://github.com/MATPOWER/mptest) ("mptest") tests. The BISTs and mptest suites are not integrated with each other, so you must run both to see full test results.

The BISTs are embedded in the various `*.m` source code files. To run them, use Octave's `oruntests`, running `oruntests(fullfile (getenv ('HOME'), 'repos/octave-tablicious/inst'))` (or whatever the path to your Tablicious repo or installation is). To see details, do `test <fcn> verbose`, e.g. `test string verbose`.

The MP-Test tests are in `inst/t`. To run them, you'll need MP-Test, which you get separately from [the MP-Test GitHub repo](https://github.com/MATPOWER/mptest). (I don't think it's available as an Octave Forge package.) Add the `lib/` dir from the MP-Test repo to your Octave path. Then add Tablicious' `inst/t/` dir to your path, as that's not done as part of loading the Tablicious package. Then run `tblish_test_tablicious()` to run all our tests, or a single test name like `t_01_table()` to run a single test. The single tests show detailed output by default.

The MP-Test test suites from Tablicious and other packages may interfere with each other, so you should only have one package's MP-Test test suite on the Octave path at a time.
