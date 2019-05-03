Chrono Release Checklist
========================

* Run all the tests.
  * `make test`, duh.
  * Wouldn't hurt to do `make clean && git status && make test`/manual-cleanup, just to be sure.
* Double-check the version number and date in `DESCRIPTION`
* Update the installation instructions in README to use the upcoming release tarball URL.
  * Format is: `https://github.com/apjanke/octave-chrono/releases/download/v<version>/chrono-<version>.tar.gz`
* Regenerate the doco
  * `(cd doc; make maintainer-clean; make all)` if you had to change it.
* Commit all the files changed by the above steps.
  * Use form: `git commit -a -m "Cut release v<version>"`
* Make sure your repo is clean: `git status` should show no local changes.
* Run `make dist` first to make sure it works.
* Create a git tag and push it and the changes to GitHub.
  * `git tag v<version>`
  * `git push; git push --tags`
* Create a new GitHub release from the tag.
  * Just use `<version>` as the name for the release.
  * Upload the dist tarball as a file for the release.
* Test installing the release using `pkg install` against the new release URL.
  * On macOS.
  * On Ubuntu.
  * *sigh* I suppose, on Windows.
  * Try this by copy-and-pasting the `pkg install` example from the 
    [live README page](https://github.com/apjanke/octave-chrono/blob/master/README.md) 
    on the GitHub repo. This makes sure the current install instructions are correct.
    * Don't short-circuit this and just edit an entry from your Octave command history! Open GitHub in a browser and actually copy-and-paste it!
    * I wish there there was a `pkg test <package>` command to run all the BISTs from a package.
    * Barring that, do a manual `pkg ls`, copy and paste the Chrono package path into a `cd('<package_path>')`, and then do `runtests .`
  * Aw crap, looks like Octave 4.2 and earlier don't support URLs as arguments to `pkg install`; only filenames?
    * Sigh. Manually download the release tarball (with `wget`, using the URL copy-and-pasted from the live project README page) and install from there.
      * In Octave, you need to use `system('wget ...')`, not `!wget ...`.
    * This affects both Ubuntu 16.x Xenial and Ubuntu 18.04 Bionic (Octave 4.2.2).
  * ANY failure borks the release once we get near 1.0!
    * Let ’em go for now so we can get code out for review.
    * TODO: Decide on policy on what to do then. Can git tags/GitHub Releases be removed?
* Post an announcement comment on the ["Updates" issue](https://github.com/apjanke/octave-chrono/issues/2).
* Post an announcement on the [Savannah bug for datetime support](https://savannah.gnu.org/bugs/index.php?47032) if this is a significant release.
* Open development for next version
  * Update version number in `DESCRIPTION` to next patch or minor version, as appropriate.
  * Rebuild the doco.
    * `(cd doc; make maintainer-clean; make all)`
  * `git commit -a -m 'Open development for v<version>'; git push`

* If there were any problems following these instructions exactly as written, report it as a bug.



