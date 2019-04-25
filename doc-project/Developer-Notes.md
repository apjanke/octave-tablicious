Table Developer Notes
=====================

# TODO

* table.outerjoin
* Get subsasgn assignment to work
 * It's currently erroring: `error: invalid dot name structure assignment because the structure array is empty.  Specify a subscript on the structure array to resolve.`
* timetable
* More documentation for individual methods
* Texinfo documentation
* QHelp documentation
* Once implementation is finished, clean up interface by making methods private/protected
* File I/O
  * readtable, writetable
  * tableread
  * table.textscan, table.csvread, table.dlmread
  * Probably pull in Apache FOP for this. Will need to write custom Java layer for acceptable performance.
* viewtable()
  * Takes single table or struct with tabular field contents

# Release Checklist

* Update release in `DESCRIPTION`
* Update download instructions version in `README.md`
* `git commit`
* Do `make dist` to make sure that it works
* `git tag v<version>`
* `git push; git push --tags`
* Create GitHub release
  * Draft a release from the `v<version>` tag
  * Check the “This is a pre-release” box
  * Upload the dist file resulting from that `make dist` you did
* Update release in `DESCRIPTION` to `<version>+` to open development on next release
* `git commit -a; git push`
