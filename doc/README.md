# README for these package documentation tools

This is the README for the doco toolchain of this Octave package.
It goes with the files `mktexi.pl`, `OctTexiDoc.pm`, and `Makefile`, all of which should be found in the `doc/` subdirectory of an Octave package.

This is Andrew Janke’s summary of how the doco generation tools in this `doc/` directory work.

This is not the standard Octave Forge doco toolchain.
This is Andrew Janke’s enhancement of it to support classes and namespaces.
It first appeared in Andrew’s Tablicious package in April 2019.

## Requirements

This toolchain requires Texinfo version 6.0 or newer.
Versions 5.x and older will result in a lot of errors complaining about node relationships and whatnot.

Perl modules:

* `Moose`
* `Data::Dumper`
* `Date::Parse`
* `Text::Wrap`
* `IPC::Open3`

Sorry for the dependencies.

## How it works

### The files

Here’s a list of the files involved in the doco toolchain. In this document, `<pkg>` means the package name. E.g. `chrono` or `tablicious`.

User-maintained input files:

* `../DESCRIPTION`
* `../INDEX`
* `<pkg>.texi.in`
* `<pkg>.qhcp`

Doco toolchain script files:

* `mktexi.pl`
  * `OctTexiDoc.pm`
* `Makefile`

Generated intermediate files:

* `<pkg>.texi`
* `TIMESTAMP`
* `html/*`
* `*.dvi`
* `<pkg>.log`
* `<pkg>.qhp`

Generated output target files:

* `<pkg>.html`
* `<pkg>.info`
* `<pkg>.pdf`
* `<pkg>.qch`
* `<pkg>.qhc`

`html/*` is an intermediate file because it's just used for packaging up into `<pkg>.qch`, the QHelp collection file. It's not intended for users to read directly; the single-node `<pkg>.html` is for that. So it’s excluded from source control in `.gitignore`.

The `<pkg>.{html|info|pdf|qch|qhc}` files are checked in to source control so they are included in the package distribution. Technically, since they are entirely generated from the source and human-maintained index files, they could be re-generated as part of the `pkg install` step for this package. But that would require that users install heavyweight tools like Qt and TeX which are required for their generation, which is undesirable. So we just have the package maintainer generate them at package authoring time and include them in source control and the package distribution file.

#### Developer note

This toolchain used to have more steps, broken out into `mkdoc.pl`, `mktexi.pl`, and `mkqhp.pl`. `mkdoc.pl` would scan the source files and build a function index with the extracted texinfo blocks; `mktexi.pl` would take that function index and build `<pkg>.texi`, and `mkqhp.pl` would take `<pkg>.texi`, `../INDEX`, and the function index and build the `<pkg>.qhp` file. I changed the code to unify these three steps into a single `mktexi.pl` because I needed to use a multi-level function/topic index that didn’t fit into the existing function index file format, and doing everything in-memory in a single process simplified the code and resulted in faster execution times.

### The process

* You launch `make doc` using the `Makefile`. It causes the rest to happen.
* `mktexi.pl`:
  * Scans the source files (in `../inst` and `../src`) and extracts their embedded texinfo blocks
  * Combines that with `<pkg>.texi.in`, `../DESCRIPTION`, and `../INDEX` to produce the unified actual Texinfo document `<pkg>.texi`
    * Does some substitutions on stuff in `<pkg>.texi.in`
    * `@DOCSTRING(...)` gets special handling
    * `%%%%PACKAGE_VERSION%%%%` gets replaced with the version from `../DESCRIPTION`
  * Generates a `<pkg>.qhcp` index file that can be used to build a QHelp collection from the generated HTML help files
* The rest of `make doc` uses standard Texinfo and Qt tools to generate target help files in various formats
* You check the resulting files in to source control if they’re good

## Writing Octave Texinfo documentation

Here’s how to write the variant of Octave Texinfo doco that’s supported by this package’s doco toolchain.

Octave Texinfo doco is a way of writing embedded user documentation as part of Octave `.m` or `.cc` source files. It’s like Perldoc or Javadoc.

### Texinfo doco format

The Texinfo doco in a source file is comprised of one or more Texinfo comment blocks. A regular function file has exactly one Texinfo block. A classdef file can have multiple Texinfo blocks. A class method file has one Texinfo comment block.

Each Texinfo block becomes one topic or subtopic in the generated Texinfo documentation.

#### Texinfo in `.m` files

In `.m` files, a Texinfo block is comprised of a contiguous run of comment lines each starting with “`## `” (that’s two octothorps (`#`) followed by a space), with optional spaces before the first “`#`”. The first line in a Texinfo block must be “`## -*- texinfo -*-`”; that’s how the parser knows it’s a Texinfo block instead of a regular comment.

The Texinfo blocks contain Texinfo markup. Each block should contain the contents of a single node.

In a regular function `.m` file, there is a single Texinfo block that documents the function. It should be placed between the initial Copyright header and the `function` line. There is no need to have a `@node` statement in this block; it is generated implicitly.

In a classdef `.m` file, there is a main Texinfo block that documents the overall class, and then one or more additional Texinfo blocks that document individual methods, events, or other things within the class.

The main (class-level) Texinfo block should precede the `classdef` line. It should not have a `@node` statement. The additional (method-level) Texinfo blocks may be placed anywhere throughout the file, but typically should immediately precede the definition of the method or other thing they are documenting. The additional Texinfo blocks _must_ have a `@node` statement as their first line. The node name must be the class-qualified method name in format `<class>.<method>`. For classes that are within a namespace (package), the node name must _not_ include the namespace as a qualification.

For method definition files inside a `@<class>` directory, there should be a single top-level Texinfo block, immediately preceding the method definition. As with a function definition file, it should not have a `@node` statement.

Neither the top-level nor additional blocks should include `@section`, `@subsection`, or `@subsubsection` statements. Those are added implicitly by the doco generation tools. Currently, each top-level block is turned into a `@subsection` and each method-level block is turned into a `@subsubsection`, but that may change.

#### Texinfo in `.cc` files

Texinfo blocks in oct-file `.cc` source files are included in comment strings inside the `DEFUN_DLD` macro call.

#### Formatting Texinfo elements

These are the conventions that Andrew settled on while documenting the Chrono package. They seem to work okay.

Functions should be documented with `@deftypefn` and optionally `@deftypefnx` statements.

Top-level class Texinfo blocks should contain:

* a `@deftp {Class} <class>` that documents the overall class
* `@deftypeivar <class> <type> <property>` items that document the user-visible properties

Method-level Texinfo blocks should have `@deftypefn {<type>} <signature>` items that document the method, with optional `@deftypefnx {<type>} <signature>` items to document alternate calling forms. The `<type>` should be:

* `{Constructor}` for constructors
* `{Method}` for instance methods
* `{Static Method}` for static methods

Use `@var{...}` for input and ouptut function parameters. Use `@code{...}` for class, method, and function names.

For functions that take trailing name/value option pairs, use a `@deftypefnx` with the signature form `(@dots{}, @code{'Option'}, @var{Option})` to document them.

The first thing in each function, class, or method doco block should be a one-sentence summary of what it does. This sentence will be extracted and used in other places in the final documentation.

In class doco, use “`obj`” as the conventional name for the method dispatch object in the documentation, even though you might use “`this`” or something else as the parameter in the actual code.
Documentation is viewed from the caller’s perspective, not the implementation’s perspective, so “`this`” makes less sense.

### Examples

#### Example: Function documentation

Here’s what documentation of the regular (global) function `foonly` should look like.

```octave
## Copyright (C) 2019 John Doe <jdoe@example.com>
##
## [...]

## -*- texinfo -*-
## @deftypefn {Function} {@var{out} =} foonly (@var{x}, @var{y})
## @deftypefn {Function} {@var{out} =} foonly (@var{x}, @var{y}, @var{dim})
## @deftypefn {Function} {@var{out} =} foonly (@dots{}, @code{'Format'}, @var{Format})
##
## Do the foonly computation on given inputs.
##
## Peforms the foonly computation on inputs @var{x} and @var{y}, optionally along
## dimension @var{dim}.
##
## If the option @var{Format} is supplied, it controls the output format.
##
## @end deftypefn

function out = foonly (x, y, varargin)
  % [...]
endfunction
```

#### Example: Class documentation

Here’s what documentation of a classdef class named `Example` should look like.

```octave
## Copyright (C) 2019 Jane Doe <jdoe@example.com>
##
## [...]

## -*- texinfo -*-
## @deftp {Class} datetime
##
## An example class that does nothing.
##
## Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur 
## ullamcorper pulvinar ligula, sit amet accumsan turpis dapibus at. 
## Ut sit amet quam orci. Donec vel mauris elementum massa pretium tincidunt. 
##
## @end deftp
##
## @deftypeivar Example @code{double} x
##
## The x property. Has no semantics.
##
## @end deftypeivar
##
## @deftypeivar Example @code{charvec} format
##
## The format to display @code{x} in. The name of the format this
## defined somewhere else.
##
## @end deftypeivar

classdef Example

  properties
    x = NaN
    format = 'default'
  endproperties

  methods

    ## -*- texinfo -*-
    ## @node Example.Example
    ## @deftypefn {Constructor} {@var{obj} =} Example ()
    ##
    ## Constructs a new scalar Example with the default values.
    ##
    ## @end deftypefn
    ##
    ## @deftypefn {Constructor} {@var{obj} =} Example (@var{x})
    ## @deftypefnx {Constructor} {@var{obj} =} Example (@var{x}, @var{format})
    ##
    ## Constructs a new Example with the given @var{x} and @var{format}
    ## values.
    ##
    ## @end deftypefn
    function this = Example (varargin)
      % ...
    endfunction

    ## -*- texinfo -*-
    ## @node Example.foo
    ## @deftypefn {Method} {[@var{a}, @var{b}] =} foo (@var{obj})
    ##
    ## Performs a foo calculation.
    ##
    ## @end deftypefn
    function [a, b] = foo (this)
      % ...
    endfunction

  endmethods
endclassdef
```

Note the use of a `@node` line in the method and constructor documentation but _not_ in the class-level documentation. This is required.
