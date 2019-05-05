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
## @node splitapply
## @deftypefn {Function} {@var{out} =} splitapply (@var{func}, @var{X}, @var{G})
## @deftypefnx {Function} {@var{out} =} splitapply (@var{func}, @var{X1}, @dots{}, @var{XN}, @var{G})
## @deftypefnx {Function} {[@var{Y1}, @dots{}, @var{YM}] =} splitapply (@dots{})
##
## Split data into groups and apply function.
##
## @var{func} is a function handle to call on each group of inputs in turn.
##
## @var{X}, @var{X1}, @dots{}, @var{XN} are the input variables that are split into
## groups for the function calls. If @var{X} is a @code{table}, then its contained
## variables are “popped out” and considered to be the @var{X1} @dots{} @var{XN}
## input variables.
##
## @var{G} is the grouping variable vector. It contains a list of integers that
## identify which group each element of the @var{X} input variables belongs to.
## NaNs in @var{G} mean that element is ignored.
##
## Vertically concatenates the function outputs for each of the groups and returns them in
## as many variables as you capture.
##
## Returns the concatenated outputs of applying @var{func} to each group.
##
## See also: @ref{table.groupby}, @ref{table.splitapply}
##
## @end deftypefn

function varargout = splitapply (func, varargin)
  varargout = cell (1, nargout);
  [varargout{:}] = octave.internal.splitapply_impl (func, varargin{:});
endfunction
