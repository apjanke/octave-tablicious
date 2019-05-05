Tablicious Design and Justifications
====================================

This document describes the design choices I made in Tablicious, and some
justifications for them and why I think they should be allowed into core
Octave, or at least an Octave Forge package

# Design

## Objects

### Copy constructors

Each data object has a copy constructor calling form. The Matlab trick
of doing this:

```
function this = Foo(x)
  if isa (x, 'Foo')
    this = x;
    return
  end
  [...]
end
```

doesn’t seem to be supported in Octave; or at least it seemed to lead to
some instability when I tried it. Besides, it introduces the problem 
that the output of the constructor might be a subclass instead of an
object of the exact type of the constructor.

So I wrote out copy-constructor forms for most of the classes. The rest
should be filled in, too; their absence is a bug.

### Planar-organized classes

The data classes like `datetime` are implemented as planar-organized
classes for efficiency. This lets them represent their arrays as
arrays of primitives on which vectorized operations can be performed.

“Planar-organized” is opposed to “struct-organized”, which is the
default organization for Octave/Matlab classes. In struct-organized
classes, arrays are represented by arrays of struct-y objects, each
of which contains a single element/record’s data in its fields.

Planar-organized classes are the only way to go fast with objects
in Octave/Matlab.

For example, an M-by-N `datetime` array is a single object wrapper
around an M-by-N double array in the `dnums` property. Instead of it
being an M-by-N array of blessed structs, each of which holds a 
scalar `dnums`.

The downside is that implementing a planar-organized class requires
you to write a _lot_ of boilerplate code. I went ahead and did that,
though, because the performance gain is worth it.

## Namespaces

### The `+internal` namespace

Any namespace with `+internal` as one of its components is considered
to be an internal, private, implementation detail of a library itself.
The language doesn’t enforce any access rules on this; it’s just a naming
convention. But I think it’s become a reasonably well-established
convention in other languages: Java supports it, and I think Matlab
does too. I think Octave would do well to adopt it.

Tablicious’ doco generation tools support `+internal` by excluding
any `+internal` namespace from the generation of the API Reference
section of the manual. So code in there is hidden from the user view
at the documentation level.

### The `+octave/+examples` namespace

I’m sticking example code in the `octave.examples` namespace. This makes
it readily available to anyone with the package loaded (as opposed to
requiring them to `cd` into a specific `examples/` directory or manually
add it to the path), but keeps them out of the global namespace and the
Octave and Tablicious public APIs.

The `+examples` namespace is a suitable place to throw code that might be
useful for users, but we don’t want in the actual package API for some reason.
This includes:

* Collecting code that’s used in multiple examples, like in the `octave.datasets` example data sets, into one place
* Making available code that users can model their own code on, or reuse directly, but isn’t good enough for “production” code yet
* Throwing examples where we don’t know what we want the permanent API to look like

The stuff in `+examples` can be lower quality than main code, in the sense that:

* It can be “toy” code that gets the happy path right, but doesn’t bother doing input validation or error handling
* They can go without tests
* Bugs here are lower impact
* No need to keep things from changing between versions; no need to preserve back-compatibility

## `datetime`

### `datetime` constructor for numeric inputs

The single-arg `datetime(x)` constructor, when called on numeric inputs,
treats them as a datevec instead of as datenums. I think that’s a design
mistake; datenums are closer to the “canonical” representation for dates
in pre-`datetime` Matlab/Octave. And datenums seem to me to be what you‘d
want the implicit conversion behavior to do in the case of mixed-type
arithmetic, concatenation, or other combining operations.

But datevecs is what Matlab picked, so we’re stuck with that, for
compatibility.

I’m thinking about adding a global `todatetime(x)` function that will
treat its numeric inputs as datenums, for convenience.

## Example Datasets

### API

The `octave.datasets` class provides functions for listing and loading all the
example datasets this library provides.

The `octave.dataset` class provides a list of all the individual
examples, so you can use tab-completion on them (or at least you’ll be able
to, once Octave supports tab completion for static methods on classes inside
namespaces). This class is also how the
Texinfo doco for the datasets finds its way into the generated user manual.

This is done as two separate classes to keep the “list of data sets”
separate from the “API for accessing datasets”. I think that makes it easier
for users to find what they’re looking for; otherwise the generic methods
in `octave.datasets` would get lost in the big list of individual example
datasets.

You run `octave.internal.generate_datasets_list` to generate the
`octave.dataset` file from the individual example classes. This only needs to
be done at code authoring time, not by the user.

### Organization

The Example code sections in the `description.texi` for the example
datasets are stored separately as scripts so that you can view them
as M-code in an editor (with syntax highlighting, indentation
assistance, and so on) and conveniently run them to test them
(instead of having to copy-and-paste them from a view of the 
helptext, which would require you to go through the doco building
cycle each time you made a change and wanted to run the code to test it).

I’m thinking about breaking the `load` step out into separate `load_raw`
and `munge` steps, to make it easier for users to view the example
dataset code and see how the data-packaging classes like `table` are used.

# Justification

## Why does `table` display differently than in Matlab?

In Matlab, doing `disp()` on a `table` will result in its printing the
entire table contents in tabular form, as it does with primitives and
cells. I think that, for any more than a few rows, this spams the
console, and is not useful output. In interactive use, it’s much nicer
to get a short summary of the table as its default display: tables
have enough structure that a short summary is still useful, and it
won’t spam your scrollback.

I’ve spent years working with `table`-style objects that operate
each way, and found the summary style to be much more usable.

## Justify all these new top-level functions

Tablicious defines several new top-level (global, not in namespaces or
`private/` directories) functions. Many of them are ports of Matlab
functions, which should be self-justifying. But some of them are not.
Here are reasons for the new ones I made up.

I call the top-level namespace that’s not in any explicit namespace
the “global” namespace. I don’t know if that’s actually the correct term.

### Justify `colvecfun`

Could easily go in the `+octave` namespace; there’s no real reason for
it to be global, aside from easy discovery and analogy with the global
`cellfun`, `arrayfun`, and so on.

### Justify `dispstr` and `dispstrs`

Many modern programming languages provide a generic, polymorphic way of
converting an arbitrary input to a string for user/developer presentation.
E.g. Java has `toString`, Ruby has `to_str`, and Python has `str` and
`repr`. Octave could really use one of those.

Needs to be global so user-defined classes can override it with object
methods.

Because of Octave’s pervasive array nature, we need both a variant for
“one string describing the entire array” (`dispstr`) and “N strings
describing each of the array’s elements” (`dispstrs`).

### Justify `eqn`

This is a straightforward extension if `isequaln` behavior to the element-wise
case.

Needs to be global so user-defined classes can override it with object
methods.

### Justify `isnannish`

For some reason, Matlab chose to name the NaN values for `datetime` objects
“NaT” instead, and define a new `isnat()` function to work with them. So
you can’t write generic polymorphic code that works on both numerics and
`datetime`s when testing for NaN-ness. Sigh.

The new `ismissing()` function doesn’t fit the bill, because it’s too
broad: it also considers empty strings and blank characters to be missing,
and you may not want that broadness in a NaN-ness test. `isnannish()`
smooths over the NaN/NaT difference without becoming as broad as
`ismissing()`.

I made this a global function so that user-defined classes could override
it with object methods. Without `methods(klass)` working for classdef
objects, it’d be hard to detect whether a user-defined object supports
`isnan()` and/or `isnat()`, so classes might want to override
`isnannish` itself. This is not ideal; I'm still thinking about whether
this is the best approach.

### Justify these extra `mustBeXxx` functions

Many of the `mustBeXxx()` functions are just ports of Matlab’s existing
validator functions. But I added a few new ones:

* `makeItBeA`
* `mustBeA`
* `mustBeCellstr`
* `mustBeCharvec`
* `mustBeSameSize`
* `mustBeScalar`
* `mustBeScalarLogical`
* `mustBeVector`

These all see a lot of use in my experience, so they’d be useful to provide.
And I think their semantics and implementation are obvious enough that we
don’t need to be trepidatious about adding them to the public API.

### Justify `pp`

If you end up working with tables or other complex structures that support
`prettyprint`, you end up calling `prettyprint` a lot, so it’s nice to
have a shortcut for it, especially one with the char-interpreting command
style. Needs to be have a super short name so users can quickly bang it
out at the command line. Namespace would make this inconvenient.

However, `pp` is only ever called directly by end users; it doesn’t need
to be available to other code in the library. So this could just be
provided as an example function, and require users to copy it into their
default path (like at `~/Documents/octave`) to have it take effect.

### Justify `proxykeysForMatrixes`

This one is ugly to have hanging around in the global namespace, but it’s
necessary in order to allow user-defined classes to override it with
object methods.

### Justify `scalarexpand`

This one is really useful. I use it in the input handling for a lot of 
functions, and I think it should exist.

This one could probably go in the `+octave` namespace, though. It does not
need to be overridden by anything.

### Justify `size2str`

I use this one a lot in generating error and progress messages. It gets used
often enough that I think it could belong in core Octave. It's trivial to
implement. But it's useful enough that I think it deserves a home in a
library or core Octave. This would make it
both convenient for users to use, and easier for code readers to recognize
and understand if there were a single core, conventional name for this
operation.

Its behavior is simple enough that its interface is unlikely to change. Though
the format could change: maybe you’d want to do “AxBxC” instead of
“A-by-B-by-C”, or something like that. In which case that’s another reason
to prefer an established, central function to do this.

### Justify `tableOuterFillValue`

Having this be global is necessary in order to allow user-defined classes to
override it with object methods.

This ugliness could probably be hacked around by not having a global function,
and just having `table.outerjoin` test its variable values to see if they are
objects which define a `tableOuterFillValue`, and only call that if they are
defined. But this will be hard because Octave currently doesn’t support calling
`methods` on user-defined classes.

