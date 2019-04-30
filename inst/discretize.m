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
## @deftypefn {Function} {[@var{Y}, @var{E}] =} discretize (@var{X}, @var{n})
## @deftypefnx {Function} {[@var{Y}, @var{E}] =} discretize (@var{X}, @var{edges})
## @deftypefnx {Function} {[@var{Y}, @var{E}] =} discretize (@var{X}, @var{dur})
## @deftypefnx {Function} {[@var{Y}, @var{E}] =} discretize (@dots{}, @code{'categorical'})
## @deftypefnx {Function} {[@var{Y}, @var{E}] =} discretize (@dots{}, @code{'IncludedEdge'}, @var{IncludedEdge})
##
## Group data into discrete bins or categories.
##
## @var{n} is the number of bins to group the values into.
##
## @var{edges} is an array of edge values defining the bins.
##
## @var{dur} is a @code{duration} value indicating the length of time of each
## bin.
##
## If @code{'categorical'} is specified, the resulting values are a @code{categorical}
## array instead of a numeric array of bin indexes.
##
## Returns:
##  @var{Y} - the bin index or category of each value from @var{X}
##  @var{E} - the list of bin edge values
##
## @end deftypefn
function [Y, E] = discretize (X, arg1, varargin)
  
  % Input handling
  do_categorical = false;
  display_format = [];
  category_names = [];
  [opts, args] = peelOffNameValueOptions (varargin, {'IncludedEdge'});
  if numel (args) >= 1 && isequal (args{end}, 'categorical')
    do_categorical = true;
    args(end) = [];
  endif
  if numel (args) >= 2 && isequal (args{end-1}, 'categorical')
    do_categorical = true;
    categorical_arg = args{end};
    if isa (X, 'datetime') || isa (X, 'duration') && ischar (categorical_arg)
      display_format = categorical_arg;
    else
      category_names = cellstr (categorical_arg);
    endif
    args(end-1:end) = [];
  endif
  if numel (args) > 1
    error ('discretize: too many arguments');
  endif
  value_map = [];
  if ! isempty (args)
    value_map = args{i};
  endif
    
  if isa (arg1, 'duration')
    error ('discretize: duration-valued bin size is not yet implemented. Sorry.');
  elseif isscalar (arg1)
    mustBeNumeric (arg1);
    n_bins = arg1;
    min_x = min (X(:));
    max_x = max (X(:));
    bin_size = (max_x - min_x) / n_bins;
    edges = min_x:bin_size:max_x;
    if numel (edges) < n_bins + 1
      edges(end+1) = max_x;
    else
      edges(end) = max_x;
    endif
  else
    edges = arg1;
    n_bins = numel (edges) - 1;
  endif

  cat_names = cell (1, n_bins);  
  Y = NaN (size (X));
  for i_bin = 1:(n_bins-1)
    tf = edges(i_bin) <= X & X < edges(i_bin+1);
    Y(tf) = i_bin;
    cat_names{i_bin} = gen_category_name (edges(i_bin), edges(i_bin+1), 0);
  endfor
  % The last bin is closed on the upper edge
  tf = edges(end-1) <= X & X <= edges(end);
  Y(tf) = n_bins;
  cat_names{n_bins} = gen_category_name (edges(i_bin), edges(i_bin+1), 1);
  if isempty (category_names)
    category_names = cat_names;
  endif
  
  if do_categorical
    codes = Y;
    Y = categorical.from_codes (codes, category_names, 'Ordinal', true);
  endif

  if nargout > 1
    E = edges;
  endif
endfunction

function out = gen_category_name (lo, hi, is_closed_on_right)
  edge_strs = dispstrs ([lo hi]);
  if is_closed_on_right
    out = sprintf ('[%s, %s)', edge_strs{1}, edge_strs{2});
  else
    out = sprintf ('[%s, %s]', edge_strs{1}, edge_strs{2});    
  endif
endfunction
