# Tablicious TODO

## For this document

* This TODO document is way out of date as of 2024. Review it and remove stuff that got done or WONTFIXed.

## Overall

* Convert internal dnums representation to UTC.
  * Math goes bad around DST and other zone transitions if you don't do that.
* Documentation
* Add more BISTs
* Consider using GNU FDL for the documentation license.
* Propagate NaN-filling fix for planargen back to Janklab.

* Report crash: giving duration a days method while it has a days property results in a crash.

## Unit tests

* Automatic MP-test detection is broken.
* A single M-code script to run both BISTs and MP-Test suite.
  * Doing what the `runtests.sh` shell wrapper does now, moving it in to M-code.

## Build and packaging

* Make the "versioned copy of doco" step of the release a script or `make target` instead of a big copy-pasted command.
* Rework the Release Checklist so that the generated doco building and capture is a separate commit from the "config" changes and headline doco changes for a release.

## Doco stuff

* Document my new class/namespace-supporting stuff.
  * Stick a README in the doc/ directory describing how my new stuff works, and detailing the texinfo conventions needed to work with it.
* Add support for namespaces/packages.
  * Recursively find files in `+blah` dirs under main source path dirs.
  * Establish node naming convention for things in namespaces.

## Areas

* `table`
  * summary
  * Description, Units, and CustomProperties for variables in table
  * `timetable`
  * More documentation for individual methods
  * File I/O
    * readtable, writetable
    * tableread
    * table.textscan, table.csvread, table.dlmread
    * Maybe pull in Apache FOP for this. Will need to write custom Java layer for acceptable performance.
      * But most Octave users don't want to use Java. Better to take a C/C++ dependency. Or even a Python one, these days, I think.
  * viewtable()
    * Takes single table or struct with tabular field contents
    * Doing this in Java would be easier; in Qt would be nicer
      * But doing it in Qt would require users installing the package to have Qt dev tools installed so the build can work. Yuck.
* `datetime`
  * Convert internal dnums representation to UTC
    * Math goes bad around DST and other zone transitions if you don't do that
    * I think this is actually done already?
  * Time zone support
    * Normalization of "nonexistent" times like between 02:00 and 03:00 on DST leap ahead days
  * Leap second conversion
  * `Format` support
    * Needs LDML format support, not datestr() format placeholders
  * between() - calendarDuration diffs between datetimes
  * caldiff
  * dateshift
  * week() - ISO calendar week-of-year calculation
  * isdst/isweekend
  * Additional `ConvertFrom` types
  * POSIX zone rule support for dates outside range of Olson database
    * This affects dates before around 1880 and after around 2038
    * It also affects current dates for time zones that don't use DST!
    * TODO: First, implement simplified no-DST POSIX time zones. That'll at least get us
      Tokyo time support. Sheesh.
* `TzDb`
  * timezones() function: add UTCOffset/DSTOffset
* `calendarDuration` and its associated functions
  * split()
  * Can different fields be mixed positive/negative, in addition to the overall Sign? Current
    arithmetic implementation can result in this. Should that be normalized? Maybe. Not sure it can be fully normalized.
  * proxykeys: pull isnan up to front of precedence? Maybe invert so NaNs sort to end?
  * Fix expansion filling?
    * e.g. `d = datetime; d(5) = d` produced bad `d(2:4)` before patch; this probably does similar now
    * It's in the expansion of numerics: their default value is 0, not NaN.
  * Refactor out promote()
* Plotting support
  * Maybe with just shims and conversion to datenums
* `duration`
  * `InputFmt` support
  * `Format` support
* Documentation
  * Keyword index, including all function and class names
  * Fix Travis CI doco build
  * Correct asciibetical ordering in Functions Alphabetically
  * Fix this: `warning: doc_cache_create: unusable help text found in file 'datetime'`
  * Get `help datetime` to recognize my datetime
    * Currently, `which datetime` gives `'datetime' is a built-in function` and `help datetime` gives `error: help: 'datetime' is not documented`
  * Get `mkdoc.pl` to ignore files in `+internal` namespaces.
* categorical stuff
  * summary
  * countcats
* Other "Missing Data" stuff
  * fillmissing()
  * <https://www.mathworks.com/help/matlab/data_analysis/missing-data-in-matlab.html>

## Examples stuff

* Lowess smoothing (several datasets)
* ANOVA display (`chickwts`)
* Linear model regression results plotting (`cars`, `chickwts`)
  * The thing that does a 2-by-2 grid with residuals, Q-Q, and Scale-Location plots
  * I think this comes from R’s `lm()` linear model function
* Equivalent of R’s `coplot()` (`DNase`)
* Equivalent of R’s “mosaic plot” (`esoph`)
  * Good luck on this one

## Wishlist and maybes

* MAT-file representation compatibility with Matlab?
* Documentation
  * A new Texinfo `@defmfcn` macro for Matlab's idiosyncratic function signatures
