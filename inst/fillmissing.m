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
## @deftypefn {Function} {[@var{out}, @var{tfFilled}] =} fillmissing (@var{X}, @var{method})
## @deftypefnx {Function} {[@var{out}, @var{tfFilled}] =} fillmissing (@var{X}, @code{'constant'}, @var{fill_val})
## @deftypefnx {Function} {[@var{out}, @var{tfFilled}] =} fillmissing (@var{X}, @var{movmethod}, @var{window})
##
## Fill missing values.
##
## Fills missing values in @var{X} according to the method specified by
## @var{method}.
##
## This method is only partially implemented.
##
## @var{method} may be:
##    @code{'constant'}
##    @code{'previous'}
##    @code{'next'}
##    @code{'nearest'}
##    @code{'linear'}
##    @code{'spline'}
##    @code{'pchip'}
## @var{movmethod} may be:
##    @code{'movmean'}
##    @code{'movmedian'}
##
## Returns @var{out}, which is @var{X} but with missing values filled in, and
## @var{tfFilled}, a logical array the same size as @var{X} which indicates
## which elements were filled.
##
## @end deftypefn
function [out, tfFilled] = fillmissing (X, method, varargin)
  narginchk (2, Inf);
  mustBeCharvec (method);
  [opts, args] = peelOffNameValueOptions (varargin);
  
  switch method
    case 'constant'
      if isempty (args)
        error ("fillmissing: You must supply a value for the 'constant' fill method");
      endif
      const_val = args{1};
      [out, tfFilled] = fillmissing_constant (X, const_val);
    case {'previous' 'next' 'nearest' 'linear' 'spline' 'pchip'}
      if numel (args) >= 1
        dim = args{1};
      else
        dim = [];
      endif
      [out, tfFilled] = fillmissing_interp (X, method, dim);
    case {'movmean' 'movmedian'}
      % TODO: Implement
      if numel (args) < 1
        error ("fillmissing: You must provide a window value for the %s method", method);
      endif
      window = args{1};
      if numel (args) >= 2
        dim = args{2};
      else
        dim = [];
      endif
      error ("fillmissing: The '%s' fill method is not yet implemented. Sorry.");
    otherwise
      error ("fillmissing: Invalid fill method: '%s'");
  endswitch
  
endfunction

function [out, tfFilled] = fillmissing_constant (X, fill_val)
  if isempty (fill_val)
    error ('fillmissing: constant fill_val may not be empty');
  endif
  if numel (fill_val) > 1
    % TODO: Implement
    error ('fillmissing: Non-scalar constant fill_val support is not yet implemented. Sorry.');
  endif
  
  tfFilled = ismissing (X);
  out = X;
  out(tfFilled) = fill_val;
endfunction

function [out, tfFilled] = fillmissing_interp (X, method, dim)
  if isempty (dim)
    dim = first_non_one_dimension (X);
  endif
  
  % Note: unfortunately, we can't just call interp1 on the whole of X, because
  % it doesn't fill in NaNs; it operates at points that you have to provide
  % separately.
  
  if dim > 1
    if isvector (X)    
      tfMissing = ismissing (X);      
      out = fill_vec_with_interp1 (X(:), method);
      out = reshape (out, size (X));
      tfStillMissing = ismissing (out);
      tfFilled = tfMissing & ! tfStillMissing;
      return
    else
      % TODO: Implement. Probably needs a generic vecfun() for support.
      error('fillmissing: interpolation along dimensions > 1 is not yet implemented. Sorry.');
    endif
  endif

  tfMissing = ismissing (X);
  
  out = colvecfun(@(y) fill_vec_with_interp1 (y, method), X);
  
  tfStillMissing = ismissing (out);
  tfFilled = tfMissing & ! tfStillMissing;
endfunction

function out = fill_vec_with_interp1 (Y, method)
  tfMissing = ismissing(Y);
  X = 1:numel (Y);
  X0 = X(!tfMissing);
  Y0 = Y(!tfMissing);
  Xi = X(tfMissing);
  Yi = interp1 (X0, Y0, Xi, method);
  out = Y;
  out(tfMissing) = Yi;
endfunction

function out = first_non_one_dimension (X)
  sz = size (X);
  for i = 1:numel (sz)
    if sz(i) != 1
      out = i;
      return
    endif
  endfor
  out = 1;
endfunction
