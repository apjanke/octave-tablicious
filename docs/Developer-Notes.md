# Tablicious Developer Notes

See also [Design and Justification](Design-and-Justification.html) for info on
the design of this library.

See [Join Behavior](Join-Behavior.html) for a description of the "proxy keys" and other stuff related to join semantics and implementation.

See also:

* [TODO](TODO.html)
* [Release Checklist](Release-Checklist.html)

## Code Style and Principles

* Standard [GNU Octave code style](https://wiki.octave.org/Octave_style_guide)
* In general, use reallyLongDescriptiveNames for non-standard-Matlab-or-Octave functions you are adding, to reduce chance of name collisions.

## Building the Docs

The texinfo format we use requires Texinfo 6.0 or newer. This is newer than the Texinfo that comes with macOS, which ships a 5.x Texinfo. To build the docs on Mac, you will need to install a newer Texinfo (e.g. with Homebrew) and then make sure that Texinfo is on your path ahead of the system Texinfo.
