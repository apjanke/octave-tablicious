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
## @deftp {Class} missing
##
## Generic auto-converting missing value.
##
## @code{missing} is a generic missing value that auto-converts to other 
## types.
##
## A @code{missing} array indicates a missing value, of no particular type. It auto-
## converts to other types when it is combined with them via concatenation or
## other array combination operations.
##
## This class is currently EXPERIMENTAL. Use at your own risk.
##
## Note: This class does not actually work for assignment. If you do this:
##
## @example
##   x = 1:5
##   x(3) = missing
## @end example
##
## It’s supposed to work, but I can’t figure out how to do this in a normal
## classdef object, because there doesn’t seem to be any function that’s implicitly
## called for type conversion in that assignment. Darn it.
##
## @end deftp
classdef missing

  properties
    data = NaN
  endproperties
  
  methods
    ## -*- texinfo -*-
    ## @node missing.missing
    ## @deftypefn {Constructor} {@var{obj} =} missing ()
    ##
    ## Constructs a scalar @code{missing} array.
    ##
    ## The constructor takes no arguments, since there’s only one
    ## @code{missing} value.
    ##
    ## @end deftypefn
    function display (this)
      %DISPLAY Custom display.
      in_name = inputname (1);
      if ~isempty (in_name)
        fprintf ('%s =\n', in_name);
      endif
      disp (this);
    endfunction
    
    function disp (this)
      disp (dispstr (this));      
    endfunction

    function out = dispstr (this)
      if isscalar (this)
        out = '<missing>';
      else
        out = sprintf ('%s <missing>', size2str (size (this)));
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node missing.dispstrs
    ## @deftypefn {Method} {@var{out} =} dispstrs (@var{obj})
    ##
    ## Display strings.
    ##
    ## Gets display strings for each element in @var{obj}.
    ##
    ## For @code{missing}, the display strings are always @code{'<missing>'}.
    ##
    ## Returns a cellstr the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = dispstrs (this)
      out = repmat ({'<missing>'}, size (this));
    endfunction
    
    % Semantics
    
    ## -*- texinfo -*-
    ## @node missing.ismissing
    ## @deftypefn {Method} {@var{out} =} ismissing (@var{obj})
    ##
    ## Test whether elements are missing values.
    ##
    ## @code{ismissing} is always true for @code{missing} arrays.
    ##
    ## Returns a logical array the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = ismissing (this)
      out = true (size (this));
    endfunction
    
    ## -*- texinfo -*-
    ## @node missing.isnan
    ## @deftypefn {Method} {@var{out} =} isnan (@var{obj})
    ##
    ## Test whether elements are NaN.
    ##
    ## @code{isnan} is always true for @code{missing} arrays.
    ##
    ## Returns a logical array the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = isnan (this)
      out = true (size (this));
    endfunction
    
    ## -*- texinfo -*-
    ## @node missing.isnannish
    ## @deftypefn {Method} {@var{out} =} isnannish (@var{obj})
    ##
    ## Test whether elements are NaN-like.
    ##
    ## @code{isnannish} is always true for @code{missing} arrays.
    ##
    ## Returns a logical array the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = isnannish (this)
      out = true (size (this));
    endfunction
    
    function out = eq (A, B)
      sz = missing.size_scalar_expand (A, B);
      out = false (sz);
    endfunction
    
    function out = ne (A, B)
      sz = missing.size_scalar_expand (A, B);
      out = true (sz);
    endfunction
    
    function out = gt (A, B)
      sz = missing.size_scalar_expand (A, B);
      out = false (sz);
    endfunction
    
    function out = ge (A, B)
      sz = missing.size_scalar_expand (A, B);
      out = false (sz);
    endfunction
    
    function out = lt (A, B)
      sz = missing.size_scalar_expand (A, B);
      out = false (sz);
    endfunction
    
    function out = le (A, B)
      sz = missing.size_scalar_expand (A, B);
      out = false (sz);
    endfunction
    
    function out = ismember (A, B)
      sz = missing.size_scalar_expand (A, B);
      out = false (sz);      
    endfunction
    
    % Conversion stuff
    
    function out = double (this)
      out = this.data;
    endfunction
    
    function out = single (this)
      out = single (this.data);
    endfunction
    
    function out = uint64 (this)
      out = uint64 (this.data);
    endfunction
    
    function out = int64 (this)
      out = int64 (this.data);
    endfunction
    
    function out = uint32 (this)
      out = uint32 (this.data);
    endfunction
    
    function out = int32 (this)
      out = int32 (this.data);
    endfunction
    
    function out = uint16 (this)
      out = uint16 (this.data);
    endfunction
    
    function out = int16 (this)
      out = int16 (this.data);
    endfunction
    
    function out = uint8 (this)
      out = uint8 (this.data);
    endfunction
    
    function out = int8 (this)
      out = int8 (this.data);
    endfunction
    
    function out = char (this)
      out = repmat (' ', size (this));
    endfunction
    
    function out = cellstr (this)
      out = repmat ({' '}, size (this));
    endfunction
    
    function out = cell (this)
      out = repmat ({' '}, size (this));
    endfunction
    
    function out = datetime (this)
      out = NaT (size (this));
    endfunction
    
    function out = duration (this)
      out = duration (NaN (size (this)));
    endfunction
    
    function out = calendarDuration (this)
      out = calendarDuration (NaN (size (this)));
    endfunction

    % Arithmetic
    
    function out = plus (A, B)
      args = missing.demote ({A B});
      out = plus(args{1}, args{2});
    endfunction

    function out = minus (A, B)
      args = missing.demote ({A B});
      out = minus(args{1}, args{2});
    endfunction

    function out = times (A, B)
      args = missing.demote ({A B});
      out = times(args{1}, args{2});
    endfunction

    function out = mtimes (A, B)
      args = missing.demote ({A B});
      out = mtimes(args{1}, args{2});
    endfunction

    function out = divide (A, B)
      args = missing.demote ({A B});
      out = divide(args{1}, args{2});
    endfunction

    function out = rdivide (A, B)
      args = missing.demote ({A B});
      out = rdivide(args{1}, args{2});
    endfunction

    function out = power (A, B)
      args = missing.demote ({A B});
      out = power(args{1}, args{2});
    endfunction

    function out = mpower (A, B)
      args = missing.demote ({A B});
      out = mpower(args{1}, args{2});
    endfunction

    % Auto-conversion stuff
    
    function out = cat (dim, varargin)
      %CAT Concatenate arrays.
      args = missing.demote (varargin);
      out = cat (dim, args{:});
    endfunction

  endmethods
      
  % Planar boilerplate stuff
  
  methods

    function out = numel (this)
      %NUMEL Number of elements in array.
      out = numel (this.data);
    endfunction
    
    function out = ndims (this)
      %NDIMS Number of dimensions.
      out = ndims (this.data);
    endfunction
    
    function out = size (this)
      %SIZE Size of array.
      out = size (this.data);
    endfunction
    
    function out = isempty (this)
      %ISEMPTY True for empty array.
      out = isempty (this.data);
    endfunction
    
    function out = isscalar (this)
      %ISSCALAR True if input is scalar.
      out = isscalar (this.data);
    endfunction
    
    function out = isvector (this)
      %ISVECTOR True if input is a vector.
      out = isvector (this.data);
    endfunction
    
    function out = iscolumn (this)
      %ISCOLUMN True if input is a column vector.
      out = iscolumn (this.data);
    endfunction
    
    function out = isrow (this)
      %ISROW True if input is a row vector.
      out = isrow (this.data);
    endfunction
    
    function out = ismatrix (this)
      %ISMATRIX True if input is a matrix.
      out = ismatrix (this.data);
    endfunction
        
    function this = reshape (this, varargin)
      %RESHAPE Reshape array.
      this.data = reshape (this.data, varargin{:});
    endfunction
    
    function this = squeeze (this, varargin)
      %SQUEEZE Remove singleton dimensions.
      this.data = squeeze (this.data, varargin{:});
    endfunction
    
    function this = circshift (this, varargin)
      %CIRCSHIFT Shift positions of elements circularly.
      this.data = circshift (this.data, varargin{:});
    endfunction
    
    function this = permute (this, varargin)
      %PERMUTE Permute array dimensions.
      this.data = permute (this.data, varargin{:});
    endfunction
    
    function this = ipermute (this, varargin)
      %IPERMUTE Inverse permute array dimensions.
      this.data = ipermute (this.data, varargin{:});
    endfunction
    
    function this = repmat (this, varargin)
      %REPMAT Replicate and tile array.
      this.data = repmat (this.data, varargin{:});
    endfunction
    
    function this = ctranspose (this, varargin)
      %CTRANSPOSE Complex conjugate transpose.
      this.data = ctranspose (this.data, varargin{:});
    endfunction
    
    function this = transpose (this, varargin)
      %TRANSPOSE Transpose vector or matrix.
      this.data = transpose (this.data, varargin{:});
    endfunction
    
    function [this, nshifts] = shiftdim (this, n)
      %SHIFTDIM Shift dimensions.
      if nargin > 1
        this.data = shiftdim (this.data, n);
      else
        [this.data, nshifts] = shiftdim (this.data);
      endif
    endfunction
    
    function out = horzcat (varargin)
      %HORZCAT Horizontal concatenation.
      out = cat (2, varargin{:});
    endfunction
    
    function out = vertcat (varargin)
      %VERTCAT Vertical concatenation.
      out = cat (1, varargin{:});
    endfunction

  endmethods

  methods (Static)
    function out = demote (args)
      %DEMOTE Internal implementation method
      %
      % This will become private before octave-table release 1.0.
      found_type = [];
      for i = 1:numel (args)
        if isa (args{i}, 'missing')
          continue
        elseif isnumeric (args{i}) || isa (args{i}, 'duration') ...
            || isa (args{i}, 'calendarDuration')
          % These all take NaNs.
          found_type = 'numeric';
        elseif iscell (args{i})
          found_type = 'cell';
        elseif ischar (args{i})
          found_type = 'char';
        elseif isa (args{i}, 'datetime')
          found_type = 'datetime';
        else
          error ('missing:InvalidInput', ['missing: Unsupported type: %s. ' ...
            'Cannot combine with ''missing'' object.'], ...
            class (args{i}));
        endif
      endfor
      out = args;
      for i = 1:numel (args)
        if isa (args{i}, 'missing')
          switch found_type
            case 'numeric'
              out{i} = NaN (size (args{i}));
            case 'cell'
              out{i} = repmat({''}, size (args{i}));
            case 'char'
              out{i} = repmat(' ', size (args{i}));
            case 'datetime'
              args{i} = repmat(NaT, size (args{i}));
          endswitch
        endif
      endfor
    endfunction
    
    function out = size_scalar_expand (A, B)
      %SIZE_SCALAR_EXPAND Internal implementation method
      if isscalar (A)
        out = size (B);
      else
        out = size (A);
      endif
    endfunction
  endmethods
endclassdef
