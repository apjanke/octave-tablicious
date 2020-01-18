Tablicious Developer Notes
==========================

See also [Design and Justification](Design-and-Justification.html) for info on
the design of this library.

# TODO

* table
  * summary
* categorical stuff
  * summary
  * countcats
* Other "Missing Data" stuff
  * fillmissing()
  * https://www.mathworks.com/help/matlab/data_analysis/missing-data-in-matlab.html
* Get subsasgn assignment to work in table
  * It's currently erroring: `error: invalid dot name structure assignment because the structure array is empty.  Specify a subscript on the structure array to resolve.`
* Validation: enforce that all variables in a table have the same height
* Description, Units, and CustomProperties for variables in table
* timetable
* More documentation for individual methods
* File I/O
  * readtable, writetable
  * tableread
  * table.textscan, table.csvread, table.dlmread
  * Probably pull in Apache FOP for this. Will need to write custom Java layer for acceptable performance.
* viewtable()
  * Takes single table or struct with tabular field contents
  * Doing this in Java would be easier; in Qt would be nicer
    * But doing it in Qt would require users installing the package to have Qt dev tools installed. Yuck.
* Various TODOs scattered throughout the code

# Code Style and Principles

* Standard [GNU Octave code style](https://wiki.octave.org/Octave_style_guide)
* In general, use reallyLongDescriptiveNames for non-standard-Matlab-or-Octave functions you are adding, to reduce chance of name collisions.

# Building the Docs

The texinfo format we use requires Texinfo 6.0 or newer. This is newer than the Texinfo that comes with macOS, which ships a 5.x Texinfo. To build the docs on Mac, you will need to install a newer Texinfo (e.g. with Homebrew) and then make sure that Texinfo is on your path ahead of the system Texinfo.

# Release Checklist

* Update release version and date in `DESCRIPTION`
* Update download instructions version in `README.md`
* `git commit -a -m <version>`
* Regenerate the docs
  * `cd doc; make maintainer-clean; make all`
* `git commit -a -m 'regenerate doco'`
* Do `make dist` to make sure that it works
* `git tag v<version>`
* `git push; git push --tags`
* Create GitHub release
  * Draft a release from the `v<version>` tag
  * Check the “This is a pre-release” box
  * Upload the dist file resulting from that `make dist` you did
* Update release in `DESCRIPTION` to `<version>+` to open development on next release
* `git commit -a; git push`
