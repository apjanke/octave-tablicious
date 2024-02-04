## Copyright (C) 2019, 2023, 2024 Andrew Janke <floss@apjanke.net>
##
## This file is part of Tablicious.
##
## Octave is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## Octave is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with Octave; see the file COPYING.  If not, see
## <https://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @node tblish.sizeof
## @deftypefn {Function} {@var{out} =} sizeof (@var{x})
##
## Approximate size of an array in bytes.
##
## For tables, this returns the sume of @code{sizeof} for all of its variables’
## arrays, plus the size of the VariableNames and any other metadata stored in @var{obj}.
##
## This is currently broken for some types, because its implementation is in transition
## from overridden methods on Tablicious's objects to a separate function.
##
## This is not supported, fully or at all, for all input types, but it has support
## for the types defined in Tablicious, plus some Octave built-in types, and makes a
## best effort at figuring out user-defined classdef objects. It currently does not
## have extensibility support for customization by classdef classes, but that may be
## added in the future, in which case its output may change significantly for classdef
## objects in future releases.
##
## @var{x} is an array of any type.
##
## Returns a scalar numeric. Returns NaN for types that are known to not be supported,
## instead of raising an error. Raises an error if it fails to determine the size of an
## input of a type that it thought was supported.
##
## @end deftypefn
function out = sizeof (x)
  # FIXME: I think we can remove most of the special cases for Tablicious classes here
  # and just use the generic object.
  # if isa (x, 'table')
  #   out = sizeof_table (x);
  # elseif isa (x, 'string')
  #   out = sizeof_string (x);
  # elseif isa (x, 'categorical')
  #   out = sizeof_categorical (x);
  # elseif isa (x, 'calendarDuration')
  #   out = sizeof_calendarDuration (x);
  # elseif isa (x, 'duration')
  #   out = sizeof_duration (x);
  if isobject (x)
    out = sizeof_object_generic (x);
  else
    out = sizeof_generic (x);
  endif
endfunction

# Support for Tablicious types
#
# These implementations may depend on the internal implementation details of Tablicious
# classes, and do not reflect "proper" use of their public interfaces.

function out = sizeof_table (x)
  total_size = 0;
  total_size += tblish.sizeof (x.Properties.VariableNames);
  for i = 1:width (x)
    total_size += tblish.sizeof (x.Properties.VariableValues{i});
  endfor
  total_size += tblish.sizeof (x.Properties.RowNames);
  out = total_size;
endfunction

function out = sizeof_string (x)
  out = 0;
  out += tblish.sizeof (x.strs);
  out += tblish.sizeof (x.tfMissing);
endfunction

function out = sizeof_categorical (x)
  out = 0;
  out += tblish.sizeof (x.code);
  out += tblish.sizeof (x.tfMissing);
  out += tblish.sizeof (x.cats);
  out += tblish.sizeof (x.isOrdinal);
  out += tblish.sizeof (x.isProtected);
endfunction

function out = sizeof_calendarDuration (x)
  out = 0;
  out += tblish.sizeof (x.Sign);
  out += tblish.sizeof (x.Years);
  out += tblish.sizeof (x.Months);
  out += tblish.sizeof (x.Days);
  out += tblish.sizeof (x.Time);
  out += tblish.sizeof (x.isNaN);
endfunction

function out = sizeof_duration (x)
  out = 0;
  out += tblish.sizeof (x.days);
  out += tblish.sizeof (x.Format);
endfunction

function out = sizeof_object_generic (x)
warnId = 'Octave:classdef-to-struct';
origWarn = warning ('query', warnId);
warning ('off', warnId);
s = struct (x);
out = sizeof_generic (s);
warning (origWarn.state, warnId);
endfunction

function out = sizeof_generic (x)
  w = whos('x');
  if ! isscalar (w)
    error ('sizeof: internal error: expected scalar whos() output, but got %d-long', numel (w))
  endif
  out = w.bytes;
endfunction
