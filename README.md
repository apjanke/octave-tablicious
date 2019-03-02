Table
======

Tabular data structure for Octave.

This package attempts to provide a set of mostly-Matlab-compatible implementation of the table class.

All the code in here is currently experimental. Do not use it in any production code!

## Installation and usage

### Quick start

To get started using or testing this project, install it using Octave's `pkg` function:

```
pkg install https://github.com/apjanke/octave-addons-table/archive/master.zip
pkg load table
```

### Installation for development

* Clone the repo
  * `git clone https://github.com/apjanke/octave-addons-table`
* Add the `inst/` directory from the repo to your Octave path.

## Documentation

See the `doc-project/` directory for notes on this project, especially for [Developer Notes](doc-project/Developer-Notes.md). Also see [CONTRIBUTING](CONTRIBUTING.md) if you would like to contribute to this project.

Real user documentation is hopefully coming soon.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for more details.

### No Matlab usage!

To avoid issues with the Matlab license's Non-Compete clause, this project needs to be developed entirely using Octave, and not using Matlab at all, including for testing or benchmarking purposes. Please do not submit any Matlab test or benchmark results, or any code produced using Matlab.

### Naming conventions

Anything in a namespace with `internal` in its name is for the internal use of this package, and is not intended for use by user code.


## Author

Table is created by [Andrew Janke](https://apjanke.net).

## Acknowledgments

Thanks to [Polkadot Stingray](https://polkadotstingray-official.jimdo.com/) for [powering](https://www.youtube.com/watch?v=3ad4NsEy1tg) [my](https://www.youtube.com/watch?v=-zlq6eMycLA) [coding](https://www.youtube.com/watch?v=1z4RosaB-UQ) [sessions](https://www.youtube.com/watch?v=p6oVXuLsbxM).
