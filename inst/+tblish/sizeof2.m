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
## @deftypefn {Function} {@var{out} =} tblish.sizeof2 (@var{x})
##
## Approximate size of an array in bytes, with object support.
##
## This is an alternative to Octave's @code{sizeof} function that tries to provide
## meaningful support for objects, including the classes defined in Tablicious. It is
## named "sizeof2" instead of "sizeof" to avoid a "shadowing core function" warning
## when loading Tablicious, because it seems that Octave does not consider packages
## (namespaces) when detecting shadowed functions.
##
## This may be supplemented or replaced by @code{sizeof} override methods on Tablicious's
## classes. I'm not sure whether Octave's @code{sizeof} supports extension by method
## overrides, so I'm not doing that yet. If that happens, this @code{sizeof2} function
## will stick around in a deprecated state for a while, and it will respect those override
## methods.
##
## For tables, this returns the sum of @code{sizeof} for all of its variables’
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
## See also: sizeof
##
## @end deftypefn
function out = sizeof2 (x)
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
  total_size += tblish.sizeof2 (x.Properties.VariableNames);
  for i = 1:width (x)
    total_size += tblish.sizeof2 (x.Properties.VariableValues{i});
  endfor
  total_size += tblish.sizeof2 (x.Properties.RowNames);
  out = total_size;
endfunction

function out = sizeof_string (x)
  out = 0;
  out += tblish.sizeof2 (x.strs);
  out += tblish.sizeof2 (x.tfMissing);
endfunction

function out = sizeof_categorical (x)
  out = 0;
  out += tblish.sizeof2 (x.code);
  out += tblish.sizeof2 (x.tfMissing);
  out += tblish.sizeof2 (x.cats);
  out += tblish.sizeof2 (x.isOrdinal);
  out += tblish.sizeof2 (x.isProtected);
endfunction

function out = sizeof_calendarDuration (x)
  out = 0;
  out += tblish.sizeof2 (x.Sign);
  out += tblish.sizeof2 (x.Years);
  out += tblish.sizeof2 (x.Months);
  out += tblish.sizeof2 (x.Days);
  out += tblish.sizeof2 (x.Time);
  out += tblish.sizeof2 (x.isNaN);
endfunction

function out = sizeof_duration (x)
  out = 0;
  out += tblish.sizeof2 (x.days);
  out += tblish.sizeof2 (x.Format);
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
  # FIXME: This may be replaceable by a call to Octave's built-in sizeof() function.
  # It seems to support structs and cells, just not user-defined objects (they are
  # deteted as 0 bytes). Need to recursively convert objects to structs in that case, within
  # structs and cells too, to get the right size. Might need to do that with this whos()
  # technique, for that matter.
  w = whos('x');
  if ! isscalar (w)
    error ('sizeof: internal error: expected scalar whos() output, but got %d-long', numel (w))
  endif
  out = w.bytes;
endfunction
