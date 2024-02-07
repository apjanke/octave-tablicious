## Copyright (C) 2019, 2023, 2024 Andrew Janke
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
## @deftypefn {Function} {@var{x} =} mustBeMember (@var{x}, @var{valid}, @var{label})
##
## Requires that input is a member of a set of given valid values.
##
## Raises an error if any element of the input @var{x} is not a member
## of @var{valid}, as determined by @code{ismember (x)}.
##
## Note that char inputs may behave weirdly, because of the interaction between
## chars and cellstrs when calling ismember() on them. But it will probably
## "do what you mean" if you just use it naturally.
##
## @var{label} is an optional input that determines how the input will be described in
## error messages. If not supplied, @code{inputname (1)} is used, and if that is
## empty, it falls back to "input". The @var{label} argument is a Tablicious extension,
## and is not part of the standard interface of this function.
##
## This definition of @code{mustBeMember} is supplied by Tablicious, and is a
## compatibility shim for versions of Octave which do not provide one. It is only loaded
## in Octaves older than 6.0.0.
##
## @seealso{ismember}
##
## @end deftypefn

function x = mustBeMember (x, valid, label)
  if (nargin < 2); label = []; endif
  tf = ismember (x, valid);
  if (! all (tf))
    if (isempty (label))
      label = inputname (1);
    endif
    if (isempty (label))
      label = "input";
    endif
    n_bad = numel (find (! tf));
    # TODO: Fancy inclusion of bad & valid values in the error message.
    # Probably need dispstrs() for that.
    error ("%s must be one of the specified valid values; got %d elements that weren't", ...
      label, n_bad);
  endif
endfunction
