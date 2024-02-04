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
## Fill value for a given type within a table, in the style of the
## 'Size'/'VariableTypes' table constructor. (Aka the "preallocation
## constructor".)
##
## This is like fillValForType, except it uses the fill values used by the
## @var{table} constructor's @code{table('Size', sz, 'VariableTypes', t)}
## calling form, also known as the "preallocation constructor". These fill
## values differ from the fill values used by array expansion or table
## outer-join filling, and for many types are not missing values.
##
## The argument @var{typeName} is a char or string containing the name of a
## type or pseudotype recognized by the table constructor. This includes the
## special pseudotypes 'cellstr', 'doublenan', and 'singlenan'. The pseudotypes
## 'doubleNaN' and 'singleNaN' are aliases for 'doublenan' and 'singlenan', and
## are case sensitive.
##
## Some types are not supported. These include: table.
##
## Returns a scalar value of the given type.
function out = fillValForTypeCtorStyle (typeName)

persistent ctorSpecialCases specialCases intTypes unsupportedTypes
if (isempty (ctorSpecialCases))
  dummyTable = table (NaN);
  dummyTable = dummyTable(:,[]);
  # ctorSpecialCases are those for which the preallocation constructor defines a fill
  # value that differs from the array expansion fill value, or are special pseudotypes.
  ctorSpecialCases = {
    'double'      0
    'single'      single(0)
    'doublenan'   NaN
    'doubleNaN'   NaN
    'singlenan'   single(NaN)
    'singleNaN'   single(NaN)
    'datetime'    NaT
    'duration'    duration
    'calendarDuration'  calendarDuration
    'string'      string('')
    'cellstr'     {''}
    'cell'        {[]}
    'char'        {''}
    'table'       dummyTable
  };
  # specialCases are those for which detection via array expansion does not work, for
  # various reasons, or we want to reuse a single value for efficiency reasons.
  specialCases = {
    % non-conforming zero-arg ctors
    'categorical' NaC
    % reused single values for efficiency
    'struct'      struct
  };
  intTypes = {'int8', 'int16', 'int32', 'int64', 'uint8', 'uint16', 'uint32', 'uint64'};
  unsupportedTypes = {};
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
if (ismember (typeName, intTypes))
  out = zeros ([1 1], typeName);
end
[tf,loc] = ismember (typeName, ctorSpecialCases(:,1));
if (tf)
  out = ctorSpecialCases{loc,2};
  return
endif
[tf,loc] = ismember (typeName, specialCases(:,1));
if (tf)
  out = specialCases{loc,2};
  return
endif

# General case: detect using ctor and array expansion
out = tblish.internal.table.fillValForTypeGeneric (typeName);

endfunction
