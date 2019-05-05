## Copyright (C) 2019 Andrew Janke
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
## @deftypefn {Function} {@var{out} =} ismissing (@var{X})
## @deftypefnx {Function} {@var{out} =} ismissing (@var{X}, @var{indicator})
##
## Find missing values.
##
## Determines which elements of @var{X} contain missing values. If an indicator input is
## not provided, standard missing values depending on the input type of @var{X} are
## used.
##
## Standard missing values depend on the data type:
## @itemize @bullet
## @item
## NaN for double, single, duration, and calendarDuration
## @item
## NaT for datetime
## @item
## @code{' '} for char
## @item
## @code{@{''@}} for cellstrs
## @item
## Integer numeric types have no standard missing value; they are never 
## considered missing.
## @item
## Structs are never considered missing.
## @item
## Logicals are never considered missing.
## @item
## Other types have no standard missing value; it is currently an error to
## call @code{ismissing} on them without providing an indicator.
## @itemize @minus
## @item
## This includes cells which are not cellstrs; calling @code{ismissing} on them
## results in an error.
## @item
## TODO: Determine whether this should really be an error, or if it should
## default to never considering those types as missing.
## @item
## TODO: Decide whether, for classdef objects, @code{ismissing} should polymorphically
## detect isnan()/isnat()/isnannish() methods and use those, or whether we should
## require classes to override ismissing() itself.
## @end itemize
## @end itemize
##
## If @var{indicator} is supplied, it is an array containing multiple values, all of
## which are considered to be missing values. Only indicator values that are
## type-compatible with the input are considered; other indicator value types are
## silently ignored. This is by design, so you can pass an indicator that holds
## sentinel values for disparate types in to @code{ismissing()} used for any type, or
## for compound types like table.
##
## Indicators are currently not supported for struct or logical inputs. This is
## probably a bug.
##
## Table defines its own @code{ismissing()} method which respects individual variables’
## data types; see @ref{table.ismissing}.
##
## @end deftypefn
function out = ismissing (x, indicator)
  if nargin == 1
    out = ismissing_standard (x);
  else
    out = ismissing_indicator (x, indicator);
  endif
endfunction

function out = ismissing_standard (x)
  if isnumeric (x)
    out = isnan (x);
  elseif islogical (x);
    out = false (size (x));
  elseif isa (x, 'datetime')
    out = isnat (x);
  elseif isa (x, 'duration') || isa (x, 'calendarDuration')
    out = isnan (x);
  elseif ischar (x)
    out = x == ' ';
  elseif iscell (x)
    if iscellstr (x)
      out = strcmp (x, {''});
    else
      error ('ismissing: cells which are not cellstrs are not supported');
    endif
  elseif isstruct (x)
    out = false (size (x));
  else
    error ('ismissing: input type %s is not supported', class (x));
  endif
endfunction

function out = ismissing_with_indicator (x, indicator)
  indicator = octave.internal.parse_ismissing_indicator (indicator);
  if isnumeric (x)
    out = ismissing_numeric (x, indicator);
  elseif iscell (x)
    if iscellstr (x)
      out = ismissing_cellstr (x, indicator);
    else
      error ('ismissing: non-cellstr cells are not supported');  
    endif
  elseif isobject (x)
    % This isobject case also handles datetime, duration, and calendarDuration,
    % because it uses eqn(), which supports them. There might be subtleties with
    % its isa() test for eq-compatibility that we need to address, though.
    out = ismissing_object (x, indicator);
  else
    error ('ismissing: unsupported input type: %s', class (x));
  endif
endfunction

function out = ismissing_numeric (x, indicator)
out = false (size (x));
for i = 1:numel (indicator)
  indicator_i = indicator{i};
  if ~isnumeric (indicator_i)
    continue;
  endif
  tf = eqn (x, indicator_i);
  out = out | tf;
endfor
endfunction

function out = ismissing_object (x, indicator)
out = false (size (x));
for i = 1:numel (indicator)
  indicator_i = indicator{i};
  % This type-eq-compatibility test is kind of a hack; not sure if it's correct
  is_type_eq_compatible = isa (indicator_i, class (x)) || isa (x, class (indicator_i));
  if ~is_type_eq_compatible
    continue
  endif
  tf = eqn (x, indicator_i);
  out = out | tf;
endfor
endfunction

function out = ismissing_cellstr (x, indicator)
out = false (size (x));
for i = 1:numel (indicator)
  indicator_i = indicator{i};
  if ~ischar (indicator_i)
    continue;
  endif
  tf = strcmp (x, {indicator_i});
  out = out | tf;
endfor
endfunction

function out = ismissing_char (x, indicator)
out = false (size (x));
for i = 1:numel (indicator)
  indicator_i = indicator{i};
  if ~(ischar (indicator_i) && isscalar (indicator_i))
    continue;
  endif
  tf = x == indicator_i;
  out = out | tf;
endfor
endfunction
