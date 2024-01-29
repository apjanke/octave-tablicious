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
## @deftypefn {Function} {@var{out} =} plot_pairs (@var{data})
## @deftypefnx {Function} {@var{out} =} plot_pairs (@var{data}, @var{plot_type})
## @deftypefnx {Function} {@var{out} =} plot_pairs (@var{fig}, @dots{})
##
## Plot pairs of variables against each other.
##
## @var{data} is the data holding the variables to plot. It may be either a
## @code{table} or a struct. Each variable or field in the @code{table}
## or struct is considered to be one variable. Each must hold a vector, and
## all the vectors of all the variables must be the same size.
##
## @var{plot_type} is a charvec indicating what plot type to do in each subplot.
## (@code{"scatter"} is the default.) Valid @var{plot_type} values are:
##
## @table @code
## @item "scatter"
## A plain scatter plot.
## @item "smooth"
## A scatter plot + fitted line, like R's @code{panel.smooth} does.
## @end table
##
## @var{fig} is an optional figure handle to plot into. If omitted, a new
## figure is created.
##
## Returns the created figure, if the output is captured.
##
## @end deftypefn

function out = plot_pairs (varargin)
  args = varargin;
  fig = [];
  if isnumeric (args{1})
    fig = args{1};
    args(1) = [];
  endif
  data = args{1};
  if numel (args) > 1
    plot_type = args{2};
  else
    plot_type = 'scatter';
  endif
  
  if isstruct (data)
    data = struct2table (data);
  endif
  if ! istable (data)
    error ('plot_pairs: input data must be a table or struct');
  endif
  t = data;
  
  if isempty (fig)
    fig = figure;
  endif
  vars = t.Properties.VariableNames;
  n_vars = numel (vars);
  for i = 1:n_vars
    for j = 1:n_vars
      if i == j
        % TODO: Figure out how to put the variable name in big text in this axes
        continue
      endif
      ix_subplot = (n_vars*(j-1) + i);
      hax = subplot (n_vars, n_vars, ix_subplot);
      var_x = vars{i};
      var_y = vars{j};
      x = t.(var_x);
      y = t.(var_y); 
      switch plot_type
        case "scatter"
          scatter (hax, x, y, 10);
        case "smooth"
          smooth (hax, x, y, 10);
        otherwise
          error ("Invalid plot_type: '%s'", plot_type);
      endswitch
    endfor
  endfor

  if nargout > 0
    out = fig;
  endif
endfunction

function smooth (hax, x, y, marker_sz)
  scatter (hax, x, y, marker_sz);
  # TODO: Find out exactly what kind of fitted line R's panel.smooth is using, and
  # port that. For now, just use a cubic.
  hold on
  p = polyfit (x, y, 3);
  x_hat = unique(x);
  p_y = polyval (p, x_hat);
  plot (hax, x_hat, p_y, "r");
  hold off
endfunction
