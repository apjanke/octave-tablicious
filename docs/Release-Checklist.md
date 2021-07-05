# TAblicious Release Checklist

* Run all the tests.
  * `make test`, duh.
    * TODO: Fix the `make test` target! ;)
  * Okay, so instead, run Octave, `cd` to the repo, and do `runtests .`.
  * Wouldn't hurt to do `make clean && git status && make test` and manual-cleanup, just to be sure.
* Double-check the version number and date in `DESCRIPTION`.
* Update the `CHANGES.txt` file with the release date.
  * And check that it has a complete change list for the release. This _should_ be done as changes are committed, but we're not great about that.
* Update the installation instructions in README to use the upcoming release tarball URL.
  * Format is: `https://github.com/apjanke/octave-tablicious/releases/download/v<version>/tablicious-<version>.tar.gz`
* Regenerate the doco.
  * `(cd doc; make maintainer-clean; make all)` if you had to change it.
* Commit all the files changed by the above steps.
  * Use form: `git commit -a -m 'Cut release v<version>'`
* Make sure your repo is clean: `git status` should show no local changes.
* Run `make dist` first to make sure it works.
* Create a git tag and push it and the above changes to GitHub.
  * `git tag v<version>`
  * `git push; git push --tags`
* Create a new GitHub release from the tag.
  * Just use `<version>` as the name for the release.
  * Copy and paste the changes for this release from the `CHANGES.txt` file into the GitHub Release description field.
  * Upload the dist tarball as a file for the release.
* Test installing the release using `pkg install` against the new release URL.
  * On macOS.
  * On Ubuntu.
  * *sigh* I suppose, on Windows.
  * Do this by copy-and-pasting the `pkg install` example from the 
    [live README page](https://github.com/apjanke/octave-tablicious/blob/master/README.md) 
    on the GitHub repo. This makes sure the current install instructions are correct.
    * Don't short-circuit this and just edit an entry from your Octave command history! Open GitHub in a browser and actually copy-and-paste it!
    * I wish there there was a `pkg test <package>` command to run all the BISTs from a package.
    * Barring that, do a manual `pkg ls`, copy and paste the Tablicious package path into a `cd('<package_path>')`, and then do `runtests .`
* Open development for next version
  * Update version number in `DESCRIPTION` to next patch or minor version, as appropriate.
    * Include a `-SNAPSHOT` suffix to indicate this is a work in progress.
  * Add a section to `CHANGES.txt` for the new upcoming release. Use `(in progress)` for its release date.
  * Rebuild the doco.
    * `(cd doc; make maintainer-clean; make all)`
  * `git commit -a -m 'Open development for v<version>'; git push`
* Close the GitHub Issues Milestone for this release.
  * Create a new Milestone for the next release, if one doesn't already exist.
* Post an announcement on the [Savannah bug for datetime support](https://savannah.gnu.org/bugs/index.php?47032) if this is a significant release with respect to the date/time classes.

* If there were any problems following these instructions exactly as written, report it as a bug.



