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

function out = __eval_expr_with_table_vars_in_workspace__ (__tbl__, __expr__)

  % Set up workspace
  __tbl_vars__ = varnames (__tbl__);
  for __i_var__ = 1:numel (__tbl_vars__)
    eval (sprintf ('%s = __tbl__.%s;', __tbl_vars__{__i_var__}, __tbl_vars__{__i_var__}));
  endfor
  
  % Eval code
  out = eval (__expr__);
  
end