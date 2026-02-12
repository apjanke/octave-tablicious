# README - "t/" directory in Tablicious

This directory contains unit tests that run under the [MP-Test unit testing framework](https://github.com/MATPOWER/mptest) from the developers

As of 2024-02, this is use of MP-Test is experimental. I don't know if I'm going to adopt it for the long term. (As of 2025-02, probably yes.) If adopted, it would be a supplement to the classic Octave style BISTs in Tablicious.

## Installation and Setup

You'll need the MP-Test library, which is installed separately, and is (I think) not available from Octave Forge. Clone it from the Git repo at <https://github.com/MATPOWER/mptest>, and add its `lib/` dir to your Octave path using `addpath()`.

## Usage

If you run the full Tablicious test suite by calling `tblish.internal.runtests` while MP-Test is loaded, it will automatically run these MP-Test tests as part of the test suite.

To run just these MP-Test tests, add this `inst/t` subdirectory to your Octave path, and call the `tblish_mptest_tablicious` function. (The `inst/t` directory is not loaded on the Octave path by default, even when you have loaded the Tablicious package using `pkg load`.) You'll also need MP-Test loaded, done by adding its `lib/` directory to the Octave path. `tblish_mptest_tablicious` does not do that automatically.

## Developer Notes

The tests in this directory assume that you have no other MP-Test directories on your path. They are in function files named `t_*.m`, with no other prefixing (i.e., no namespaces), and may collide with MP-Test files from other packages. If that happens, this may run the wrong tests, and you'll get incorrect test results.

## License

The files in this `t/` directory are licensed under the 3-Clause BSD License (BSD-3-clause), even though the bulk of Tablicious is GPL-3+. This is because some of these files originated from a contribution from MATPOWER and were licensed under BSD-3-clause, and I want to keep the licensing of this directory uniform so it's easy to accept additional contributions like that.
