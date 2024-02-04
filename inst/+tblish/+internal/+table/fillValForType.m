## Copyright (C) 2019, 2023, 2024 Andrew Janke
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function} {@var{out} =} fillValForType (@var{typeName})
##
## Fill value for a given type within a table.
##
## Determines the fill value to use for a variable of a given type @var{typeName}
## when that value is used as a variable in a table that is involved in
## an outer join, an all-missing table is being constructed, or "missing"
## placeholder values are needed for other reasons.
##
## Typically, for types which support missing values, the fill value will be
## a missing value of that type. For integers, it will be zero; for cells it
## will be @code{{[]}}, for cellstrs it will be @code{{''}}, and for structs
## it will be @code{struct()}. Note that 'cellstr' is not a real type, but is
## included for pragmatic reasons. Also, the struct fill value will not work
## well in many cases, because structs with different sets of fields cannot
## be concatenated.
##
## The argument @var{typeName} is a char or string containing the name of a type.
## It must be a single string.
##
## Some types are not supported. These include: table.
##
## Returns a scalar value of the given type.

function out = fillValForType (typeName)

# Special cases are those for which the default approach of detecting the fill
# value through array expansion will not work, possibly for one of the following
# reasons:
#   * The type name is not a "real" type.
#   * The type name is not a zero-arg constructor, or the zero-arg constructor
#     does not return a scalar, or does not work for other reasons.
#   * The zero-arg constructor returns a value which cannot be used for array
#     expansion.
#   * Array expansion does not work.
#   * The zero-arg constructor or array expansion are difficult.
#   * The regular array expansion fill value is not what we want for a fill value
#     for use in tables.
persistent specialCases unsupportedTypes
if (isempty (specialCases))
  dummyTable = table (NaN);
  dummyTable = dummyTable(:,[]);
  specialCases = {
    % non-conforming zero-arg ctors
    'cellstr'     {''}
    'cell'        {[]}
    'char'        ' '
    'table'       dummyTable
    % reused single values for efficiency
    'struct'      struct
  };
  unsupportedTypes = {'table'};
endif

if (isstring (typeName))
  mustBeScalar (typeName);
  typeName = char (typeName);
endif
if (isempty (typeName))
  error ('typeName may not be an empty string')
endif
if (ismember (typeName, unsupportedTypes))
  error ('type is not supported for table fill value detection: %s', typeName)
endif

# Special cases
[tf,loc] = ismember (typeName, specialCases(:,1));
if (tf)
  out = specialCases{loc,2};
  return
endif

# General case: detect using ctor and array expansion
out = tblish.internal.table.fillValForTypeGeneric (typeName);

endfunction
