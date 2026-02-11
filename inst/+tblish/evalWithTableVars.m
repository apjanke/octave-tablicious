## Copyright (C) 2019, 2023, 2024 Andrew Janke
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
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
## @deftypefn {Function} {@var{out} =} tblish.evalWithTableVars (@var{tbl}, @var{expr})
##
## Evaluate an expression against a table array’s variables.
##
## Evaluates the M-code expression @var{expr} in a workspace where all of @var{tbl}’s
## variables have been assigned to workspace variables.
##
## @var{expr} is a charvec containing an Octave expression.
##
## As an implementation detail, the workspace will also contain some variables
## that are prefixed and suffixed with "__". So try to avoid those in your
## table variable names.
##
## Returns the result of the evaluation.
##
## Examples:
##
## @example
## [s,p,sp] = tblish.examples.SpDb
## tmp = join (sp, p);
## shipment_weight = tblish.evalWithTableVars (tmp, "Qty .* Weight")
## @end example
##
## See also: @ref{table.restrict}
##
## @end deftypefn
function out = evalWithTableVars (this, expr)
  if (! ischar (expr))
    error ('table.evalWithTableVars: expr must be char; got a %s', class (expr));
  endif
  out = __eval_expr_with_table_vars_in_workspace__ (this, expr);
endfunction
