# Tablicious Developer Notes

See also:

* [Design and Justification](Design-and-Justification.html) for info on
the design of this library.
* [Join Behavior](Join-Behavior.html) for a description of the "proxy keys" and other stuff related to join semantics and implementation.
* [TODO](TODO.html)
* [Release Checklist](Release-Checklist.html)

## Code

Tablicious is a fairly large package. As of March 2021, it's about 33,000 lines of code and documentation.

## Code Style and Principles

* Standard [GNU Octave code style](https://wiki.octave.org/Octave_style_guide)
* In general, use reallyLongDescriptiveNames for non-standard-Matlab-or-Octave functions you are adding, to reduce chance of name collisions.

## No Matlab usage!

To avoid issues with the Matlab license's Non-Compete clause, this project needs to be developed entirely using Octave, and not using Matlab at all, including for testing or benchmarking purposes. Please do not submit any Matlab test or benchmark results, or any code produced using Matlab. And if you know anything about how the Matlab internals work, please do not tell me!

## Building the Docs

The texinfo format we use requires Texinfo 6.0 or newer. This is newer than the Texinfo that comes with macOS, which ships a 5.x Texinfo. To build the docs on Mac, you will need to install a newer Texinfo (e.g. with Homebrew) and then make sure that Texinfo is on your path ahead of the system Texinfo.
