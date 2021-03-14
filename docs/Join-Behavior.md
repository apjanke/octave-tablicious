This page describes the semantics and implementation of join-related stuff in Tablicious's `table` class, including its special "proxy keys" trick.

## Supported variable data types

Variables in `table` arrays may be of just about any Octave data type, including user-defined classes.

For basic structural operations, the type just needs to itself support basic structural operations:

* `()`-indexing
* `size` and `numel`
* `vertcat`

For relational operations, such as joins, `unique`, and other `table` methods to work, the variables used as keys in these operations must support the following small set of operations:

* `unique`
* `ismember`
* `eq`
* `isequal`
* `ismissing`, under certain conditions
* Maybe `(:)`-indexing to reshape to a column vector

A user-defined class only needs to define an `ismissing` method if it implements missing or NaN-like semantics, in which case it needs to define an `ismissing` that is consistent with its `eq`, `ismember`, and `unique` methods.

An exception is made for `table` itself: `table` does not support `(:)` for conversion to a column vector, and its `unique` method violates the general contract of the `unique` function, because it operates row-wise even when you do not specify its `'rows'` option. This is handled with special-case code for nested `table`s inside `table` itself.

The following functions or methods are optional, but if your type supports them, then `table` will respect that and enhance its behavior to use them. In particular, this allows you to define custom display formats for how your type is displayed when it is used as a variable in a `table`:

* `dispstrs()` and `reprstrs()`

TBD: We may require support for the `'rows'` option of `unique`. I'm still undecided on this. If we require this, then the requirement for `(:)` reshaping goes away.

TBD: We may require support for conversion from `missing` or some other way of specifing a default fill value. This is needed to support outer joins. Right now we're doing it with tricks using array expansion via `()`-indexing; unclear whether that's sufficient.

## Document conventions

In this document, we'll talk about example `table`s, which will be named `tbl`, `tblA`, `tblB`, and so on. nA is the number of rows in `tblA`; nB is the number of rows in `tblB`, and so on.

Many people may think of the data items in a `table` array as "columns" or "variables" interchangeably. But each variable in a `table` may actually have multiple columns. So in here, I'm careful to distinguish between "variables", which are the named things in a `table`, and "columns", which are the columns within a variable.

A "tuple" is a set of named values. It's the formal term from relational algebra for a row or record within a SQL table or result set, or any similar structure. A row in a `table` array can be considered a tuple.

The "cardinality" of an array is the number of unique values in it. Each missing or NaN value counts as a separate value. For example, the cardinality of `[1 1 2 2 NaN NaN NaN]` is 5. The cardinality of a `table` is the number of distinct tuple values in it.

## "Proxy Keys"

### Background

"Proxy keys" is a trick I came up with around 2004, and have used successfully in a couple implementations of `table` in Matlab back in the day before Matlab had its own `table` class. I think that's a good indication that it will work in Octave.

### What we need

The logic for most table operations, like `sort`, `unique`, and all the joins, boils down to doing ordering or equality tests on multi-column values that may have columns of heterogeneous types: a `table` array may have variables of any type, so the variables used as keys may have mixed types. We need to compare the value of "tuples" which are composed of the i-th rows from one or more variables, and either sort the tuples within a single `table`, or produce a list of matches between the tuples in two different `table`s.

For example, let's say you have this `tblA` and `tblB`:

`tblA`:

| k1 | k2 | v1 |
| -- | -- | -- |
| "foo" | 1 | 1.2 |
| "foo" | 2 | 3.4 |
| "bar" | 1 | 5.6 |
| "bar" | 2 | 7.8 |
| "baz" | 3 | 1.2 |

`tblB`:

| k1 | k2 | v2 | v3 |
| -- | -- | -- | -- |
| "foo" | 2 | 123 | "x" |
| "foo" | 1 | 234 | "xx" |
| "baz" | 4 | 345 | "y" |
| "baz" | 3 | 456 | "z" |
| "baz" | 1 | 567 | "a" |
| "qux" | 1 | 678 | "b" |
| "qux" | 2 | 789 | "c" |
| "scooby" | 42 | 123 | "d" |

The key variables or "join keys" are the variables which appear in both tables, identified by their variable names. You can reduce these tables to just "key tables" by subsetting them by variables to just the key variables. The "key tuples" are the tuples subsetted to just the key variables.

Two tuples (or rows) match if their key tuples are equal. Two tuples are equal if, for every variable v (in our example case, `k1` and `k2`), their values are equal for that row, as determined by `isequal(tblA.v(i,:), tblB.v(j,:))`.

For the various relational operations (joins, setdiffs, and so on), we need to compute some combination of:

* The list of all pairs of matching rows between `tblA` and `tblB`
* The list of rows in `tblA` that match no rows in `tblB`
* The list of rows in `tblB` that match no rows in `tblA`

This is tricky because if you want to Go Fast in Octave, you need to use vectorized operations, but Octave has no built-in efficient operations for the comparison of heterogenous tuple-like structures. There's no form of `ismember` or the like which takes multiple column vectors on either side. And even cell's `ismember` doesn't support non-cellstr cells.

A naive implementation of the key-tuple-matching logic in a `table` join might look something like the following. Assume the two `table`s to be joined are `tblA` with columns `k1`, `k2`, `k3`, `v1`, and `v2`, and `tblB` with columns `k1`, `k2`, `k3`, and `v3`.

```octave
keyVars = intersect(tblA.Properties.VariableNames, tblB.Properties.VariableNames);
keyTblA = tblA(:,keyVars);
keyTblB = tblB(:,keyVars);
keysA = table2cell(keyTblA);
keysB = table2cell(keyTblB);
ixMatches = NaN(0, 2);
for iA = 1:height(tblA)
  for iB = 1:height(tblB)
    tfRowsMatch = isequal(keysA(iA), keysB(iB));
    if tfRowsMatch
      ixMatches(end+1,:) = [iA iB];
    end
  end
end
```

This is not going to be efficient: loops are slow, the conversion from table to cell will be inefficient because it breaks up any primitive variables into a bunch of cells containing scalars or single rows, and the repeated isequal() calls will have overhead.

Your next idea might be to do two-way `ismember` calls on each of the individual key variables, and then combine those results. But there's no easy way (that I know of) to compose this single-variable ismember results into the correct result that considers all the variables at once.

### How proxy keys work

Tablicious' approach to this problem is a trick I call "proxy keys". For an input key variable of any type, it transforms the values present in that array into a corresponding set of numeric values which have the same equality and ordering relationships as the original input values. (These numeric replacement values are the "proxy keys" for the original keys.) Then you can combine those numeric proxy key vectors into homogeneous numeric matrixes and do `ismember` and similar calls on them, which will be fast because they use the vectorized Octave built-ins defined for numerics.

The trick for efficiently and generically computing the proxy keys for any input type is to use the 3-argout form of `unique`:

```octave
[Y, I, J] = unique(X)
```

The output `Y` is the unique values from `X`, in sorted order. The output `I` is an index vector corresponding to `Y` indicating where in `X` they were found. The output `J` is an index vector the same size as `X` that indicates the index in `Y` that holds the unique value found in `X(i)`.

The numbers in that `J` output have the properties required of proxy keys!

For the proxy keys to be comparable across two inputs (i.e. for the key variable in the two input tables to a join operation), you need to compute the proxy keys for the values from both inputs together. To do this, you concatenate the two input variables and consider them together.

```octave
allVals = [tblA.k1; tblB.k1];
[~, ~, pkeys] = unique(allVals);
nA = height(tblA);
pkeysA = pkeys(1:nA);
pkeysB = pkeys(nA+1:end);
```

When you're operating on multiple key variables, compute the proxy keys for each variable, and then horzcat them together. This will produce a pair of multi-row proxy key matrixes.

```octave
nKeyVars = numel(keyVars);
pkeyBufA = cell(1, nKeyVars);
pkeyBufB = cell(1, nKeyVars);
nA = height(tblA);
for iKey = 1:nKeyVars
  keyA = tblA.(keyVars{iKey});
  keyB = tblB.(keyVars{iKey});
  keysTogether = [keyA; keyB];
  [~, ~, pkeys] = unique(keysTogether);
  pkeyA = pkeys(1:nA);
  pkeyB = pkeys(nA+1:end);
  pkeyBufA{iKey} = pkeyA;
  pkeyBufB{iKey} = pkeyB;
end
pkeysA = cat(2, pkeyBufA{:});
pkeysB = cat(2, pkeyBufB{:});
```

Now, do row-wise matching operations on the proxy key matrixes using `ismember(..., 'rows')`, `sortrows()`, `unique(..., 'rows')` and so on. If two rows in the proxy keys are equal, then the corresponding rows in the original input keys are equal. The order in which the rows in the proxy keys sort is the order in which the rows in the inputs should sort. And it's all done in the numeric domain with efficient vectorized Octave builtin functions.

You can go one step further than this, and do `unique(..., 'rows')` on the proxy key matrix itself to produce single-column proxy keys, where each distinct input tuple is represented by a distinct scalar numeric proxy key. This would make proxy key matching operations even faster, because they'd be done on scalar values instead of rows. But you'd have to pay the cost of that `unique()` to calculate them, which is probably O((nA+nB) * log (na+nB)). I don't know if that's worth it.

For a multi-column variable, you can produce proxy keys either by using the `[~,~,pkeys] = unique(x, 'rows')` calling form, or by reshaping the input variable to a column vector, using regular `[~,~,pkeys] = unique(x)` on that, and reshaping the resulting pkeys to match the original input. I haven't decided yet which approach is better. The `'rows'` approach results in scalar proxy keys instead of multi-column proxy keys, which is nicer, but it adds the requirement that the variable types support the `'rows'` option to `unique`, which not all types do. You could add some logic to do it either way, depending on whether the input supports the `unique(..., 'rows')` option. But there's no easy way to programmatically detect whether an input does or not.

### Proxy key type

Proxy keys are `double`s. It may be more efficient to represent them as `single` or an int type instead, possibly even choosing which type dynamically based on the type and cardinality of the input key values. TBD whether to do that. This would purely be about efficiency.

### Optimized proxy key calculation

For some types, you may be able to directly compute proxy key values in an efficient manner without doing the `unique` trick. Possibly much more efficiently.

For most numeric types, including `double`, `single`, and all integer values except `int64` and `uint64`, their values are _already_ valid proxy keys. So just cast them to `double` and you're done. `int64` and `uint64` may contain values that cannot be exactly or uniquely represented as `double`, so you need to do the `unique` trick on them.

Any other type that has an exact or distinct `double` representation can also be converted directly over. For example, Tablicious' `datetime` type is internally equivalent to a `double` datenum, so you can just use that. And `categorical` arrays already have a numeric form.

It would be possible to define an interface that allowed user-defined classdef types to provide an optimized proxy key conversion. To do this, we would need to specify the name and signature of a method that did that conversion; something like `proxykeys(x)`.

## What Matlab does

I have no idea what Matlab does in its `table` implementation to support heterogeneous-variable matching, or whether it's anything like my proxy keys trick. I have intentionally avoided learning about the internals of Matlab's `table` to avoid becoming tainted with MathWorks intellectual property in this area. If you know how Matlab's `table` works internally, please don't tell me.
