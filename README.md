# Tablicious for GNU Octave

Tablicious provides tabular data structures for Octave.

| WARNING: This library is currently beta quality. Do not use it in any production or business code! Seriously!! |
| ---- |

This package attempts to provide a set of mostly-Matlab-compatible implementations of the table class and related structures and functions.
It provides:

* `table` and related construction/conversion functions
* Missing Data support
  * `ismissing` and friends: `rmmissing`, `standardizeMissing`
  * `@missing`
  * `fillmissing` is not implemented yet, because that requires some actual math.
* `eqn` and `isnannish`
  * These are experimental Octave extensions for dealing with NaN-like values. They are used by `table`, `ismissing`, and friends, but should be generally useful, and need to be global so they can be overridden by user-defined classes.
* `string`
* `categorical`

It currently does not provide, but we would like to add:

* `timetable`
* Table I/O, such as `readtable`, `writetable`, and `csvread`/`dlmread` `table` support

The `string` and `categorical` support are incomplete, and less mature than the rest of the package.

## Installation and usage

### Quick start

To get started using or testing this project, install it using Octave's `pkg` function:

```octave
pkg install https://github.com/apjanke/octave-tablicious/releases/download/v0.3.4/tablicious-0.3.4.tar.gz
pkg load tablicious
```

### Installation for development

If you want to hack on the Tablicious code itself, set it up like this:

* Clone the repo
  * `git clone https://github.com/apjanke/octave-tablicious`
* Add the `inst/` directory from the repo to your Octave path.

## Documentation

Once you have Tablicious installed, the user manual will show up in the Octave GUI’s documentation browser.
You can also run `help <foo>` or `doc <foo>` for any of the classes or functions in Tablicious.

The documentation for the latest development version can be viewed online at <https://apjanke.github.io/octave-tablicious/doc/tablicious.html>.

See the `doc-project/` directory for notes on this project, especially for [Developer Notes](doc-project/Developer-Notes.md) and [Design and Justification](doc-project/Design-and-Justification.md), which discusses how and why this library is written.
Also see [CONTRIBUTING](CONTRIBUTING.md) if you would like to contribute to this project.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for more details.

### No Matlab usage!

To avoid issues with the Matlab license's Non-Compete clause, this project needs to be developed entirely using Octave, and not using Matlab at all, including for testing or benchmarking purposes. Please do not submit any Matlab test or benchmark results, or any code produced using Matlab.

## Author and Acknowledgments

Tablicious is created by [Andrew Janke](https://apjanke.net).

Thanks to [Polkadot Stingray](https://polkadotstingray-official.jimdo.com/) for [powering](https://www.youtube.com/watch?v=3ad4NsEy1tg) [my](https://www.youtube.com/watch?v=-zlq6eMycLA) [coding](https://www.youtube.com/watch?v=1z4RosaB-UQ) [sessions](https://www.youtube.com/watch?v=p6oVXuLsbxM).

Shout out to [Mike Miller](https://mtmxr.com/) for showing me how to properly structure an Octave package repo, and encouraging me to contribute.

Thanks to [Sebastian Schöps](https://github.com/schoeps) for getting me more involved in Octave development in the first place, via his [Octave.app](https://octave-app.org) project.
