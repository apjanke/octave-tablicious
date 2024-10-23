# Tablicious Release Checklist

Here's the process for doing a Tablicious release.

1. Run all the tests.
    1. `addpath(fullfile(getenv('HOME'),'repos', 'octave-tablicious', 'inst'))`
    1. `__run_test_suite__ ({fullfile(getenv('HOME'),'/repos/octave-tablicious/inst')}, {})`
    1. `tblish_test_tablicious`
    1. Wouldn't hurt to do `make clean && git status && make test` and manual-cleanup, just to be sure.
1. Update the version info in the repo.
    1. Update the version number and date in `DESCRIPTION`.
        1. Remove the `-SNAPSHOT` suffix from the version number.
    1. Update the `CHANGES.txt` file with the release date.
        1. Use the current calendar date in UTC time, not your local time. Or use your local time; who really cares.
        1. And check that it has a complete change list for the release. This _should_ be done as changes are committed, but we're not great about that.
1. Update the installation instructions in README to use the upcoming release tarball URL.
    1. Format is: `https://github.com/apjanke/octave-tablicious/releases/download/v<version>/tablicious-<version>.tar.gz`
    1. As of 2024-10, this is just in the "Quick start" section.
1. Update the generated doco.
    1. Regenerate the doco: `make doc; make gh-pages`
    1. Make a versioned copy for this release:
        * `ver=$(grep ^Version DESCRIPTION | cut -d ' ' -f 2); mkdir -p docs/release/v${ver}/user-guide; cd doc; cp -R html tablicious.html tablicious.pdf ../docs/release/v${ver}/user-guide`
        1. What is wrong with you, Andrew? Make this a `make` target instead of a 200-character-long bash cut-and-paste command.
    1. Add a section for the new release's doco to `docs/index.md`, and update the links in the main paragraph to point to it.
1. Commit all the files changed by the above steps.
    1. Use form: `git add -A; git commit -a -m '[release] v<version>'`
1. Make sure your repo is clean: `git status` should show no local changes.
1. Run `make dist` first to make sure it works.
    1. This has to be done _after_ the commit, because it extracts from git history.
1. Create a git tag and push it and the above changes to GitHub.
    1. `git tag v<version>; git push; git push --tags`
1. Create a new GitHub release from the tag.
    1. Just use `<version>` as the name for the release, not `v<version>` or `v <version>`.
    1. Copy and paste the changes for this release from the `CHANGES.txt` file into the GitHub Release description field.
    1. Upload the dist tarball as a file for the release.
1. Test installing the release using `pkg install` against the new release URL.
    1. On macOS.
    1. On Ubuntu.
    1. _sigh_ I suppose, on Windows.
    1. Do this by copy-and-pasting the `pkg install` example from the [live README page](https://github.com/apjanke/octave-tablicious/blob/master/README.md) on the GitHub repo. This makes sure the current install instructions are correct.
        1. Don't short-circuit this and just edit an entry from your Octave command history! Open GitHub in a browser and actually copy-and-paste it!
    1. `pkg test tablicious` should do it.
1. Open development for next version
    1. Update version number and date in `DESCRIPTION` to next patch or minor version, as appropriate.
        1. Include a `-SNAPSHOT` suffix to indicate this is a work in progress.
    1. Add a section to `CHANGES.txt` for the new upcoming release, at the top. Use `(unreleased)` for its release date.
    1. Rebuild the doco
        1. `make doc; make gh-pages`
    1. `git add -A; git commit -a -m 'Open development for next version'; git push`
1. Close the GitHub Issues Milestone for this release.
    1. Create a new Milestone for the next release, if one doesn't already exist.
1. Announce the release.
    1. Update the OF packages index info in the gnu-octave/packages repo.
        1. Put in a PR to the [`gnu-octave/packages` repo](https://github.com/gnu-octave/packages) to update `packages/tablicious.yaml`.
            1. Add a new item to its `versions` section for this new release.
            1. See example: [Tablicious index update for 0.3.7 - 0.4.2](https://github.com/gnu-octave/packages/pull/401).
    1. Add a comment to the [Tablicious News issue](https://github.com/apjanke/octave-tablicious/issues/131) with a link to the new release.
    1. Post an announcement on the [Savannah bug for datetime support](https://savannah.gnu.org/bugs/index.php?47032) if this is a significant release with respect to the date/time classes.

If there were any problems following these instructions exactly as written, please report it as a bug.
