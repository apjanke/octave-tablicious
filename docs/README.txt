# README - Tablicious docs/

This `docs/` dir is the project documentation, for online and local consumption. This is the whole project web site, not just the doco for one particular release.

This is (currently) a GitHub Pages site. So this folder needs to be named exactly `docs`, and when you push changes to the `main` branch, they get published on GH Pages automatically.

This file is internal developer documentation, not really meant for presentation on the website, but it doesn't matter if users or the public see it anyway.

## Dir structure

* `/` - The main web site!
  * `*.md` - Articles and pages that apply across multiple versions, or are about the project as a whole.
  * `release/` - Package doco for released versions (frozen).
    * `v<X.Y.Z>/` - Package doco for a specific version (frozen).
  * `devel/` - Package doco for the in-development version on `main` ("living"/unstable).
  * `index.md` - The front page that gets displayed when a user goes to the site.
  * `CNAME` - GH Pages config file for using a custom domain name (may not exist, auto-managed).
  * `Gemfile`, `_config.yml` - GH Pages configuration for both deployment and local use.

Under each package doco dir, either a `release/v<X.Y.Z>/` or `devel/`, we have:

* `<version>/`
  * `user-guide/`
    * `html/` - Multi-page version of the User Guide.
    * `tablicious.html` - Single-page version of the User Guide.
    * `tablicious.pdf` - PDF version of the User Guide.

Yep, that's it for now.

TODO: Add an index.md or index.html for those, at the top level, with a brief info, links to the various formats of the user guide, and a link to the main project site.
