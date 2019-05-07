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
## @deftypefn {Function} {[@var{fig}, @var{hax}] =} coplot (@var{tbl}, @var{xvar}, @var{yvar}, @var{gvar})
## @deftypefn {Function} {[@var{fig}, @var{hax}] =} coplot (@var{fig}, @var{tbl}, @var{xvar}, @var{yvar}, @var{gvar})
##
## Conditioning plot.
##
## @code{coplot} produces conditioning plots. This is a kind of plot that breaks up the
## data into groups based on one or two grouping variables, and plots each group of data
## in a separate subplot.
##
## @var{tbl} is a @code{table} containing the data to plot.
##
## @var{xvar} is the name of the table variable within @var{tbl} to use as the X values.
## May be a variable name or index.
##
## @var{yvar} is the name of the table variable within @var{tbl} to use as the Y values.
## May be a variable name or index.
##
## @var{gvar} is the name of the table variable or variables within @var{tbl} to use as
## the grouping variable(s). The grouping variables split the data into groups based on
## the distinct values in those variables. @var{gvar} may specify either one or two
## grouping variables (but not more). It can be provided as a charvec, cellstr, or index
## array. Records with a missing value for their grouping variable(s) are ignored.
##
## @var{fig} is the figure handle to plot into. If @var{fig} is not provided, a new figure
## is created.
##
## Returns:
##   @var{fig} – the figure handle it plotted into
##   @var{hax} – array of axes handles to all the axes for the subplots

function [fig, hax] = coplot(varargin)
  narginchk (4, Inf);
  args = varargin;
  if isnumeric (args{1})
    fig = args{1};
    mustBeScalar (fig);
    figure (fig);
  else
    fig = figure;
  endif
  [tbl, xvar, yvar, gvar] = args{1:4};
  args = args(5:end);
  mustBeA (tbl, "table");

  [X, x_name] = getvar (tbl, xvar);
  [Y, y_name] = getvar (tbl, yvar);
  [g_ix, g_names] = resolveVarRef (tbl, gvar);
  if isscalar (g_ix)
    hax = coplot_one (fig, tbl, X, x_name, Y, y_name, g_ix, g_names);
  else
    hax = coplot_two (fig, tbl, X, x_name, Y, y_name, g_ix, g_names);
  endif
  if nargout < 1
    clear fig
  endif
endfunction

function hax = coplot_one (fig, tbl, X, x_name, Y, y_name, g_ix, g_names)
  
  G = getvar (tbl, g_ix);
  u_g = unique (G (!ismissing (G)));
  n_groups = numel (u_g);
  hax = NaN (1, n_groups);
  g_strs = dispstrs (u_g);
  
  % Arrange subplots in a square
  square_side = ceil (sqrt (n_groups));
  n_rows = square_side;
  n_cols = square_side;
  
  for i = 1:n_groups
    ix_row = ceil (i / n_cols);
    ix_col = 1 + rem (i, n_rows);
    ax = subplot (n_rows, n_cols, i);
    if ix_col == 1
    else
      set(ax, 'yticklabel', {});
    endif
    if ix_row == n_rows
    else
      set(ax, 'xticklabel', {});
    endif
    set(ax, 'position', get(ax, 'outerposition'));
    hax(i) = ax;
    tf_g = G == u_g(i);
    x_g = X(tf_g);
    y_g = Y(tf_g);
    plot (ax, x_g, y_g, "o");
  endfor
  
  linkaxes (hax, "xy");
  xlim (hax(1), [0 max(X)]);
  ylim (hax(1), [min(0, min(Y)) max(Y)]);
endfunction

function hax = coplot_two (fig, tbl, X, x_name, Y, y_name, g_ix, g_names)
  error('coplot_two is unimplemented');
endfunction

