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


function varargout = splitapply_impl (func, varargin)
  % The non-polymorphic actual implementation of splitapply. This is broken out
  % as a separate function of a different name to prevent nested tables from causing
  % the table.splitapply method to be called recursively, which we don't want.
  mustBeA (func, 'function_handle');
  narginchk (3, Inf);
  G = varargin{end};
  if ! isnumeric (G)
    error ('splitapply: G, the last input argument, must be numeric; got a %s', ...
      class (G));
  endif
  x_vars = varargin(1:end-1);
  n_x_vars = numel (x_vars);
  u_g = unique (G);
  u_g(isnan (u_g)) = [];
  n_g = max (u_g);
  n_outs = nargout;
  
  bufs = repmat ({cell (n_g, 1)}, [1 n_outs]);
  
  for i_group = 1:n_g
    tf = G == i_group;
    x_args = cell (n_x_vars, 1);
    for i_x_var = 1:n_x_vars
      x_args{i_x_var} = x_vars{i_x_var}(tf);
    endfor
    argouts = cell (1, n_outs);
    [argouts{:}] = func (x_args{:});
    for i_out_var = 1:n_outs
      bufs{i_out_var}{i_group} = argouts{i_out_var};
    endfor
  endfor

  varargout = cell (size (x_vars));
  for i_out_var = 1:n_outs
    varargout{i_out_var} = cat (1, bufs{i_out_var}{:});
  endfor
endfunction
