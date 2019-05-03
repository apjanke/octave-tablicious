Chrono TODO
===========

# Overall

* Convert internal dnums representation to UTC
  * Math goes bad around DST and other zone transitions if you don't do that
* Documentation
* Add more BISTs
* Consider using GNU FDL for the documentation license
* Propagate NaN-filling fix for planargen back to Janklab

* Report crash: giving duration a days method while it has a days property results in a crash.

# Doco stuff

* Document my new class/namespace-supporting stuff
  * Stick a README in the doc/ directory describing how my new stuff works, and detailing the texinfo conventions needed to work with it.
* Add support for namespaces
  * Recursively find files
  * Establish node naming convention for things in namespaces

# Areas

* `datetime`
  * Convert internal dnums representation to UTC
    * Math goes bad around DST and other zone transitions if you don't do that
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
  * SystemTimeZone detection on pre-Vista Windows without using Java
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
* Miscellaneous
  * Reproduce crash - double setter/getters cause it? (Had duplicates for datetime.Month.)
* Documentation
  * Keyword index, including all function and class names
  * Fix Travis CI doco build
  * Figure out how to get `doc/chrono.texi.in` to draw its version number from `DESCRIPTION`
  * Correct asciibetical ordering in Functions Alphabetically
  * Fix this:
```
warning: doc_cache_create: unusable help text found in file 'datetime'
```
  * Make my Texinfo documentation work with Octave's `doc` command
    * Expose it as QHelpEngine file?
  * Get `help datetime` to recognize my datetime
```
>> which datetime
'datetime' is a built-in function
>> help datetime
error: help: 'datetime' is not documented
```
  * Get `mkdoc.pl` to ignore files in `+internal` namespaces.
  * Get `mkdoc.pl` to include namespaces in class/function definition items.

# Wishlist and maybes

* MAT-file representation compatibility with Matlab?
* Documentation
  * A new Texinfo `@defmfcn` macro for Matlab's idiosyncratic function signatures
