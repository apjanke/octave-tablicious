# README - "t/" directory in Tablicious

This directory contains unit tests that run under the [MP-Test unit testing framework](https://github.com/MATPOWER/mptest) from the developers

As of 2024-02, this is use of MP-Test is experimental. I don't know if I'm going to adopt it for the long term. If adopted, it would be a supplement to the classic Octave style BISTs in Tablicious.

## Installation and Setup

You'll need the MP-Test library, which is installed separately, and is (I think) not available from Octave Forge. Clone it from the Git repo at <https://github.com/MATPOWER/mptest>, and add its `lib/` dir to your Octave path. By default, if autodiscovery is enabled, Tablicious will look for MP-Test at `~/repos/mptest` and `~/repos/octave-repos/mptest`. (Those are apjanke's favorite places to put things, not a standard GNU Octave convention.)

## Usage

To run the tests, add this `inst/t` subdirectory to your Octave path, and call the `tblish_test_tablicious` function. (The `inst/t` directory is not loaded on the Octave path by default, even when you have loaded the Tablicious package.) You'll also need MP-Test available, done by adding its `lib/` directory to the Octave path.

## Developer Notes

The tests in this directory assume that you have no other MP-Test directories on your path. They are in function files named `t_*.m`, with no other prefixing, and may collide with MP-Test files from other packages.

