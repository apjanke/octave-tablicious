## Copyright (C) 2019, 2023 Andrew Janke <floss@apjanke.net>
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
## @deftypefn {Function} {@var{out} =} istable (@var{x})
##
## True if input is a @code{table} array or other table-like type, false
## otherwise.
##
## Respects @code{istable} override methods on user-defined classes, even if
## they do not inherit from @code{table} or were known to Tablicious at
## authoring time.
##
## User-defined classes should only override @code{istable} to return true if
## they conform to the @code{table} public interface. That interface is not
## well-defined or documented yet, so maybe you don't want to do that yet.
##
## Returns a scalar logical.
##
## @end deftypefn

# Developers' note: Other packages that wish to support tables and be compatible
# with Tablicious, but not take a mandatory dependency on Tablicious, may want
# to use istable() to test for table inputs. This function is simple, well-defined,
# and likely stable enough for other packages to just copy-paste an exact copy
# of it in to their own `inst/` directory, so there will be an istable() available
# whether or not Tablicious is installed and loaded.

function out = istable (x)
  #ISTABLE True for table arrays or table-like arrays.
  if (isa (x, 'table'))
    # Main case: table arrays are tables.
    # This is actually redundant with the generic isobject/method test below,
    # but written separately for readability.
    out = true;
  elseif (isobject (x))
    # Respect istable methods on classes. Normally, those methods would "grab"
    # this call. We check for it here so that these method overrides are respected
    # even if this istable function was called through a function handle or
    # similar mechanism, bypassing the regular method dispatch mechanism.
    if (ismember ('istable', methods (x)))
      out = istable (x);
    else
      out = false;
    endif
  else
    out = false;
  endif
endfunction
