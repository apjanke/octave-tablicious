Contributing to Tablicious for GNU Octave
=========================================

## Introduction

Thank you for considering contributing to this project. Any contribution
is extremely welcome and appreciated.

These guidelines are designed to help all contributors understand how to
work and interact within this project.

## Basics

### No MATLAB!
Do not use MATLAB to develop this project!
That could be a violation of your MATLAB license terms, because the Matlab license includes a Non-Compete clause.

* Only use Octave and reference to the [publicly-available MATLAB documentation](https://www.mathworks.com/help/matlab/) to develop this project.
* This includes using MATLAB for testing or benchmarking purposes. Please do not submit any contributions that include MATLAB test or benchmark results. They will be politely but summarily deleted.

### Other basics

* Bug reports and merge requests via GitHub are very welcome.
* Contributions include testing, writing more tests, documentation,
  submitting bug reports, and proposing new features and tests.
* Issues and changes should be small and focused on a particular topic.
* Contributors are expected to abide by the [code of conduct](CODE_OF_CONDUCT.md).
* Problems with documentation (including stuff that’s just missing) are considered bugs,
  and bug reports against it are welcome.

## Community

All project interaction takes place on GitHub.
The project community is essentially the original author (Andrew Janke) at the moment.
However, this project exists within the greater GNU Octave community.
It is the author's hope that at some point in the future, this project's components will be merged into GNU Octave and cease to be developed in an independent project.

The GitHub home for this project is <https://github.com/apjanke/octave-tablicious>.

## Code conventions

Use GNU Octave code style.

### Naming conventions

Anything in a namespace with `internal` in its name is for the internal use of this package, and is not intended for use by user code.
