# Tablicious Release Checklist

* Run all the tests.
  * `__run_test_suite__ ({fullfile(getenv('HOME'),'/repos/octave-tablicious/inst')}, {})`
  * `tblish_test_tablicious`
  * Wouldn't hurt to do `make clean && git status && make test` and manual-cleanup, just to be sure.
* Double-check the version number and date in `DESCRIPTION`.
* Update the `CHANGES.txt` file with the release date.
  * Use the current calendar date in UTC time, not your local time.
  * And check that it has a complete change list for the release. This _should_ be done as changes are committed, but we're not great about that.
* Update the installation instructions in README to use the upcoming release tarball URL.
  * Format is: `https://github.com/apjanke/octave-tablicious/releases/download/v<version>/tablicious-<version>.tar.gz`
* Update the generated doco
  * Regenerate the doco: `make doc; make gh-pages`
  * Make a versioned copy for this release: `mkdir -p docs/release/v<version>/user-guide; cd doc; cp -R html tablicious.html tablicious.pdf ../docs/release/v<version>/user-guide`
  * Add a section for the new release's doco to `docs/index.md`, and update the links in the main paragraph to point to it.
* Commit all the files changed by the above steps.
  * Use form: `git add -A; git commit -a -m '[release] v<version>'`
* Make sure your repo is clean: `git status` should show no local changes.
* Run `make dist` first to make sure it works.
  * This has to be done _after_ the commit, because it extracts from git history.
* Create a git tag and push it and the above changes to GitHub.
  * `git tag v<version>`
  * `git push; git push --tags`
* Create a new GitHub release from the tag.
  * Just use `<version>` as the name for the release, not `v<version>` or `v <version>`.
  * Copy and paste the changes for this release from the `CHANGES.txt` file into the GitHub Release description field.
  * Upload the dist tarball as a file for the release.
* Test installing the release using `pkg install` against the new release URL.
  * On macOS.
  * On Ubuntu.
  * _sigh_ I suppose, on Windows.
  * Do this by copy-and-pasting the `pkg install` example from the
    [live README page](https://github.com/apjanke/octave-tablicious/blob/master/README.md)
    on the GitHub repo. This makes sure the current install instructions are correct.
    * Don't short-circuit this and just edit an entry from your Octave command history! Open GitHub in a browser and actually copy-and-paste it!
  * `pkg test tablicious` should do it.
* Open development for next version
  * Update version number and date in `DESCRIPTION` to next patch or minor version, as appropriate.
    * Include a `-SNAPSHOT` suffix to indicate this is a work in progress.
  * Add a section to `CHANGES.txt` for the new upcoming release. Use `(in progress)` for its release date.
  * Rebuild the doco
    * `make doc; make gh-pages`
  * `git add -A; git commit -a -m 'Open development for next version'; git push`
* Close the GitHub Issues Milestone for this release.
  * Create a new Milestone for the next release, if one doesn't already exist.
* Post an announcement on the [Savannah bug for datetime support](https://savannah.gnu.org/bugs/index.php?47032) if this is a significant release with respect to the date/time classes.

* If there were any problems following these instructions exactly as written, report it as a bug.
