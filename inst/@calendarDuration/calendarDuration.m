## Copyright (C) 2019, 2023, 2024 Andrew Janke <floss@apjanke.net>
##
## This file is part of Tablicious.
##
## Octave is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## Octave is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with Octave; see the file COPYING.  If not, see
## <https://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftp {Class} calendarDuration
##
## Durations of time using variable-length calendar periods, such as days,
## months, and years, which may vary in length over time. (For example, a
## calendar month may have 28, 30, or 31 days.)
##
## @end deftp
##
## @deftypeivar calendarDuration @code{char} Format
##
## The format to display this @code{calendarDuration} in. Currently unsupported.
##
## This is a single value that applies to the whole array.
##
## @end deftypeivar
classdef calendarDuration
  # planar precedence: (Months,Days,Time)

  properties (SetAccess = private)
    # Display format
    Format = 'ymdt'
  endproperties
  properties (Access = private)
    # Whole calendar months
    Months = 0   % planar
    # Whole calendar days
    Days = 0     % planar
    # Time as datenum-style double; will typically be a fractional value (<1.0)
    Time = 0     % planar
  endproperties

  methods

    ## -*- texinfo -*-
    ## @node calendarDuration.calendarDuration
    ## @deftypefn {Constructor} {@var{obj} =} calendarDuration ()
    ##
    ## Constructs a new scalar @code{calendarDuration} of zero elapsed time.
    ##
    ## @end deftypefn
    ##
    ## @deftypefn {Constructor} {@var{obj} =} calendarDuration (@var{Y}, @var{M}, @var{D})
    ## @deftypefnx {Constructor} {@var{obj} =} calendarDuration (@var{Y}, @var{M}, @
    ##   @var{D}, @var{H}, @var{MI}, @var{S})
    ##
    ## Constructs new @code{calendarDuration} arrays based on input values.
    ##
    ## @end deftypefn
    function this = calendarDuration (varargin)
      #CALENDARDURATION Construct a new calendar duration.
      #
      # this = calendarDuration (Y, M, D)
      # this = calendarDuration (Y, M, D, H, MI, S)
      # this = calendarDuration (Y, M, D, T)
      # this = calendarDuration (X)
      #
      # this = calendarDuration (..., 'Format', displayFormat)

      args = varargin;
      if (nargin == 1 && isa (args{1}, 'calendarDuration'))
        this = args{1};
        return
      endif

      # Peel off options
      knownOptions = {'Format'};
      opts = struct;
      while (numel (args) >= 3 && isa (args{end-1}, 'char') ...
          && ismember (args{end-1}, knownOptions))
        opts.(args{end-1}) = args{end};
        args(end-1:end) = [];
      endwhile
      # Parse inputs
      switch (numel (args))
        case 0
          return
        case 1
          X = args{1};
          Y = X(:,1);
          M = X(:,2);
          D = X(:,3);
          if (size (X, 2) == 3)
            T = zeros (size (Y));
          elseif (size (X, 2) == 4)
            T = X(:,4);
          elseif (size (X, 2) == 6)
            [h, mi, s] = deal (X(:,4), X(:,5), X(:,6));
            T = (h / 24) + (mi / (24 * 60)) + (s / (24 * 60 * 60));
          else
            error (['single-argument numeric input must have exactly 3, 4, or 6 columns; ' ...
              'had %d columns'], size (x, 2))
          endif
        case 3
          [Y, M, D] = args{:};
          T = zeros (size (Y));
        case 4
          [Y, M, D, T] = args{:};
        case 6
          [Y, M, D, h, mi, s] = args{:};
          T = (h / 24) + (mi / (24 * 60)) + (s / (24 * 60 * 60));
        otherwise
          error 'Invalid number of inputs');
      endswitch
      # Input validation
      Y = double (Y);
      M = double (M);
      D = double (D);
      T = double (T);
      tblish.internal.mustBeIntValOrNan (Y);
      tblish.internal.mustBeIntValOrNan (M);
      tblish.internal.mustBeIntValOrNan (D);
      [Y, M, D, T] = tblish.internal.chrono.scalarexpand (Y, M, D, T);
      # Construction
      totalMonths = (12 * Y) + M;
      this.Months = totalMonths;
      this.Days = D;
      this.Time = T;
      if (isfield (opts, 'Format'))
        this.Format = opts.Format;
      endif
      this = normalizeNaNs(this);
    endfunction

    function this = set.Format (this, Format)
      if (! isequal (Format, 'ymdt'))
        error ('Only Format ''ymdt'' is currently supported')
      endif
      this.Format = Format;
    endfunction

    # Structure

    function [keysA, keysB] = proxyKeys (a, b)
      #PROXYKEYS Proxy key values for sorting and set operations
      keysA = [a.Months(:) a.Days(:) a.Time(:)];
      keysB = [b.Months(:) b.Days(:) b.Time(:)];
    endfunction

    function out = calyears (this)
      out = fix (this.Months / 12);
    endfunction

    function out = calmonths (this)
      out = this.Months;
    endfunction

    # Arithmetic

    ## -*- texinfo -*-
    ## @node calendarDuration.uminus
    ## @deftypefn {Method} {@var{out} =} uminus (@var{obj})
    ##
    ## Unary minus. Negates the sign of @var{obj}, which is equivalent to negating each
    ## of its components.
    ##
    ## @end deftypefn
    function out = uminus (this)
      #UMINUS Unary minus.
      out = this;
      out.Months = -this.Months;
      out.Days = -this.Days;
      out.Time = -this.Time;
    endfunction

    ## -*- texinfo -*-
    ## @node calendarDuration.plus
    ## @deftypefn {Method} {@var{out} =} plus (@var{obj}, @var{B})
    ##
    ## Addition: add to a @code{calendarDuration}.
    ##
    ## All the calendar elements (properties) of the two inputs are added
    ## together. No normalization is done across the elements, aside from
    ## the normalization of NaNs.
    ##
    ## @var{B} may be a @code{calendarDuration}, @code{duration}, or numeric.
    ## If @var{B} is numeric, it is converted to a @code{calendarDuration}
    ## using @code{caldays(B)}.
    ##
    ## Returns a @code{calendarDuration}.
    ##
    ## @end deftypefn
    function out = plus (this, B)
      #PLUS Addition.
      if (! isa (this, 'calendarDuration'))
        error ('Left-hand side of + must be a calendarDuration');
      endif
      if (isnumeric (B))
        B = calendarDuration.ofDays (B);
      endif
      [this, B] = tblish.internal.chrono.scalarexpand (this, B);
      if (isa (B, 'calendarDuration'))
        out = this;
        out.Months = this.Months + B.Months;
        out.Days = this.Days + B.Days;
        out.Time = this.Time + B.Time;
      elseif (isa (B, 'duration'))
        out = this;
        out.Time = this.Time + B.days;
      else
        error ('Invalid input: B must be numeric, calendarDuration, or duration; got a %s', ...
          class (B));
      endif
      out = normalizeNaNs (out);
    endfunction

    ## -*- texinfo -*-
    ## @node calendarDuration.times
    ## @deftypefn {Method} {@var{out} =} times (@var{obj}, @var{B})
    ##
    ## Multiplication: Multiplies a @code{calendarDuration} by a numeric factor @var{B}.
    ##
    ## Returns a @code{calendarDuration}.
    ##
    ## @end deftypefn
    function out = times (this, B)
      #TIMES Array multiplication.
      if (isnumeric (this) && isa (B, 'calendarDuration'))
        out = times (B, this);
      endif
      #TODO: Change these messages to reflect the original input order/names
      if (! isa (this, 'calendarDuration'))
        error ('Left-hand side of * must be numeric or calendarDuration');
      endif
      if (! isnumeric (B))
        error ('B must be numeric; got a %s', class (B));
      endif
      out = this;
      out.Months = this.Months .* B;
      out.Days = this.Days .* B;
      out.Time = this.Time .* B;
      out = normalizeNaNs (out);
    endfunction

    ## -*- texinfo -*-
    ## @node calendarDuration.mtimes
    ## @deftypefn {Method} {@var{out} =} times (@var{obj}, @var{B})
    ##
    ## Multiplication: Multiplies a @code{calendarDuration} by a numeric factor.
    ##
    ## This does not do true matrix multiplication, so at least one of the input arguments
    ## must be scalar.
    ##
    ## Returns a @code{calendarDuration}.
    ##
    ## @end deftypefn
    function out = mtimes (this, B)
      if (! (isscalar (this) || isscalar (B)))
        error ('At least one of the arguments to .* must be scalar for calendarDuration.')
      endif
      out = times (this, B);
    endfunction

    ## -*- texinfo -*-
    ## @node calendarDuration.minus
    ## @deftypefn {Method} {@var{out} =} times (@var{A}, @var{B})
    ##
    ## Subtraction: Subtracts one @code{calendarDuration} from another.
    ##
    ## Returns a @code{calendarDuration}.
    ##
    ## @end deftypefn
    function out = minus (A, B)
      #MINUS Subtraction.
      out = A + (-B);
    endfunction

    # Display

    function display (this)
      #DISPLAY Custom display.
      in_name = inputname (1);
      if (! isempty (in_name))
        fprintf ('%s =\n', in_name);
      endif
      disp (this);
    endfunction

    function disp (this)
      #DISP Custom display.
      if (isempty (this))
        fprintf ('Empty %s %s\n', size2str (size (this)), class (this));
        return
      endif
      fprintf ('%s\n', tblish.internal.format_dispstr_array (dispstrs (this)));
    endfunction

    ## -*- texinfo -*-
    ## @node calendarDuration.dispstrs
    ## @deftypefn {Method} {@var{out} =} dispstrs (@var{obj})
    ##
    ## Get display strings for each element of @var{obj}.
    ##
    ## Returns a cellstr the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = dispstrs (this)
      #DISPSTRS Custom display strings.
      out = cell (size (this));
      for i = 1:numel (this)
        out{i} = dispstrScalar (subset (this, i));
      endfor
    endfunction
  endmethods

  methods (Access = private)

    function out = dispstrScalar (this)
      tblish.internal.chrono.mustBeScalar (this);
      if (ismissing (this))
        out = 'NaN';
        return
      endif
      els = {};
      [y, m] = this.wholeYM;
      if isequal (this.Format, 'ymdt')
        if (y != 0)
          els{end+1} = sprintf ('%dy', y);
        endif
        if (m != 0)
          els{end+1} = sprintf ('%dmo', m);
        endif
        if (this.Days != 0)
          els{end+1} = sprintf ('%dd', this.Days);
        endif
        if (this.Time != 0)
          time_str = dispstrs (duration.ofDays (this.Time));
          time_str = time_str{1};
          els{end+1} = time_str;
        endif
      else
        error ('invalid Format property for calendarDuration: ''%s''', this.Format)
      endif
      if (isempty (els))
        els = {'0d'};
      endif
      out = strjoin (els, ' ');
    endfunction

    function out = sprintf (fmt, varargin)
      args = varargin;
      for i = 1:numel (args)
        if (isa (args{i}, 'calendarDuration'))
          args{i} = dispstr (args{i});
        endif
      endfor
      out = sprintf (fmt, args{:});
    endfunction

    function out = fprintf (varargin)
      args = varargin;
      for i = 1:numel (args)
        if (isa (args{i}, 'calendarDuration'))
          args{i} = dispstr (args{i});
        endif
      endfor
      out = fprintf (args{:});
      if nargout == 0
        clear out
      endif
    endfunction

    function this = normalizeNaNs (this)
      tfNaN = isnan (this.Months) | isnan (this.Days) |isnan (this.Time);
      if any (tfNaN(:))
        this.Months(tfNaN) = NaN;
        this.Days(tfNaN) = NaN;
        this.Time(tfNaN) = NaN;
      endif
    endfunction

  endmethods

  # Planar boilerplate stuff

  methods

    function out = numel (this)
      #NUMEL Number of elements in array.
      out = numel (this.Months);
    endfunction

    function out = ndims (this)
      #NDIMS Number of dimensions.
      out = ndims (this.Months);
    endfunction

    function out = size (this, dim)
      #SIZE Size of array.
      if (nargin == 1)
        out = size (this.Months);
      else
        out = size (this.Months, dim);
      endif
    endfunction

    function out = end (this, k, n)
      if n == 1
        out = numel (this);
      else
        out = size (this, k);
      endif
    endfunction

    function out = isempty (this)
      #ISEMPTY True for empty array.
      out = isempty (this.Months);
    endfunction

    function out = isscalar (this)
      #ISSCALAR True if input is scalar.
      out = isscalar (this.Months);
    endfunction

    function out = isvector (this)
      #ISVECTOR True if input is a vector.
      out = isvector (this.Months);
    endfunction

    function out = iscolumn (this)
      #ISCOLUMN True if input is a column vector.
      out = iscolumn (this.Months);
    endfunction

    function out = isrow (this)
      #ISROW True if input is a row vector.
      out = isrow (this.Months);
    endfunction

    function out = ismatrix (this)
      #ISMATRIX True if input is a matrix.
      out = ismatrix (this.Months);
    endfunction

    ## -*- texinfo -*-
    ## @node calendarDuration.isnan
    ## @deftypefn {Method} {@var{out} =} isnan (@var{obj})
    ##
    ## True if input elements are NaN.
    ##
    ## This is equivalent to @code{ismissing}, and is provided for compatibility
    ## and polymorphic programming purposes.
    ##
    ## Returns logical array the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = isnan (this)
      #ISNAN True for Not-a-Number.
      out = ismissing (this);
    endfunction

    ## -*- texinfo -*-
    ## @node calendarDuration.ismissing
    ## @deftypefn {Method} {@var{out} =} ismissing (@var{obj})
    ##
    ## True if input elements are missing.
    ##
    ## This is equivalent to @code{ismissing}.
    ##
    ## Returns logical array the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = ismissing (this)
      # NaNs are normalized, so we can test just one field.
      out = isnan (this.Months);
    endfunction

    function this = reshape (this, varargin)
      #RESHAPE Reshape array.
      this.Months = reshape (this.Months, varargin{:});
      this.Days = reshape (this.Days, varargin{:});
      this.Time = reshape (this.Time, varargin{:});
    endfunction

    function this = squeeze (this, varargin)
      #SQUEEZE Remove singleton dimensions.
      this.Months = squeeze (this.Months, varargin{:});
      this.Days = squeeze (this.Days, varargin{:});
      this.Time = squeeze (this.Time, varargin{:});
    endfunction

    function this = circshift (this, varargin)
      #CIRCSHIFT Shift positions of elements circularly.
      this.Months = circshift (this.Months, varargin{:});
      this.Days = circshift (this.Days, varargin{:});
      this.Time = circshift (this.Time, varargin{:});
    endfunction

    function this = permute (this, varargin)
      #PERMUTE Permute array dimensions.
      this.Months = permute (this.Months, varargin{:});
      this.Days = permute (this.Days, varargin{:});
      this.Time = permute (this.Time, varargin{:});
    endfunction

    function this = ipermute (this, varargin)
      #IPERMUTE Inverse permute array dimensions.
      this.Months = ipermute (this.Months, varargin{:});
      this.Days = ipermute (this.Days, varargin{:});
      this.Time = ipermute (this.Time, varargin{:});
    endfunction

    function this = repmat (this, varargin)
      #REPMAT Replicate and tile array.
      this.Months = repmat (this.Months, varargin{:});
      this.Days = repmat (this.Days, varargin{:});
      this.Time = repmat (this.Time, varargin{:});
    endfunction

    function this = ctranspose (this, varargin)
      #CTRANSPOSE Complex conjugate transpose.
      this.Months = ctranspose (this.Months, varargin{:});
      this.Days = ctranspose (this.Days, varargin{:});
      this.Time = ctranspose (this.Time, varargin{:});
    endfunction

    function this = transpose (this, varargin)
      #TRANSPOSE Transpose vector or matrix.
      this.Months = transpose (this.Months, varargin{:});
      this.Days = transpose (this.Days, varargin{:});
      this.Time = transpose (this.Time, varargin{:});
    endfunction

    function [this, nshifts] = shiftdim (this, n)
      #SHIFTDIM Shift dimensions.
      if nargin > 1
        [this.Months, nshifts] = shiftdim (this.Months, n);
        this.Days = shiftdim (this.Days, n);
        this.Time = shiftdim (this.Time, n);
      else
        [this.Months, nshifts] = shiftdim (this.Months);
        this.Days = shiftdim (this.Days);
        this.Time = shiftdim (this.Time);
      endif
    endfunction

    function out = cat (dim, varargin)
      #CAT Concatenate arrays.
      args = varargin;
      for i = 1:numel (args)
        if (! isa (args{i}, 'calendarDuration'))
          args{i} = calendarDuration (args{i});
        endif
      endfor
      out = args{1};
      fieldArgs = cellfun (@(obj) obj.Months, args, 'UniformOutput', false);
      out.Months = cat (dim, fieldArgs{:});
      fieldArgs = cellfun (@(obj) obj.Days, args, 'UniformOutput', false);
      out.Days = cat (dim, fieldArgs{:});
      fieldArgs = cellfun (@(obj) obj.Time, args, 'UniformOutput', false);
      out.Time = cat (dim, fieldArgs{:});
    endfunction

    function out = horzcat (varargin)
      #HORZCAT Horizontal concatenation.
      out = cat (2, varargin{:});
    endfunction

    function out = vertcat (varargin)
      #VERTCAT Vertical concatenation.
      out = cat (1, varargin{:});
    endfunction

    function this = subsasgn (this, s, b)
      #SUBSASGN Subscripted assignment.

      # Chained subscripts
      if (numel (s) > 1)
        rhs_in = subsref (this, s(1));
        rhs = subsasgn (rhs_in, s(2:end), b);
      else
        rhs = b;
      endif

      # Base case
      switch (s(1).type)
        case '()'
          this = subsasgnParensPlanar (this, s(1), rhs);
        case '{}'
          error ('{}-subscripting is not supported for class %s', class (this));
        case '.'
          this.(s(1).subs) = rhs;
      endswitch
    endfunction

    function out = subsref (this, s)
      #SUBSREF Subscripted reference.

      # Base case
      switch (s(1).type)
        case '()'
          out = subsrefParensPlanar (this, s(1));
        case '{}'
          error('{}-subscripting is not supported for class %s', class(this));
        case '.'
          out = this.(s(1).subs);
      endswitch

      # Chained reference
      if (numel (s) > 1)
        out = subsref (out, s(2:end));
      endif
    endfunction

    function [out, Indx] = sort (this)
      #SORT Sort array elements.
      if (isvector (this))
        isRow = isrow (this);
        this = subset (this, ':');
        # NaNs sort stably to end, so handle them separately
        tfNan = isnan (this);
        nans = subset (this, tfNan);
        nonnans = subset (this, !tfNan);
        ixNonNan = find (!tfNan);
        proxy = proxyKeys (nonnans);
        [~,ix] = sortrows (proxy);
        # Can't have a space after "subset" or you get a syntax error
        out = [subset(nonnans, ix); nans];
        Indx = [ixNonNan(ix); find(tfNan)];
        if isRow
          out = out';
        endif
      elseif (ismatrix (this))
        out = this;
        Indx = NaN (size (out));
        for iCol = 1:size (this, 2)
          [sortedCol,Indx(:,iCol)] = sort (subset (this, ':', iCol));
          out = asgn (out, {':', iCol}, sortedCol);
        endfor
      else
        # I believe this multi-dimensional implementation is correct,
        # but have not tested it yet. Use with caution.
        out = this;
        Indx = NaN (size (out));
        sz = size (this);
        nDims = ndims (this);
        # Can't have a space after "repmat" or you get a syntax error
        ixs = [{':'} repmat({1}, [1 nDims-1])];
        while (true)
          col = subset (this, ixs{:});
          [sortedCol,sortIx] = sort (col);
          Indx(ixs{:}) = sortIx;
          out = asgn (out, ixs, sortedCol);
          ixs{end} = ixs{end}+1;
          for iDim = nDims:-1:3
            if (ixs{iDim} > sz(iDim))
              ixs{iDim-1} = ixs{iDim-1} + 1;
              ixs{iDim} = 1;
            endif
          endfor
          if (ixs{2} > sz(2))
            break
          endif
        endwhile
      endif
    endfunction

    function [out, Indx] = unique (this, varargin)
      #UNIQUE Set unique.
      flags = setdiff (varargin, {'rows'});
      if (ismember ('rows', varargin))
        [~,proxyIx] = unique (this);
        proxyIx = reshape (proxyIx, size (this));
        [~,Indx] = unique (proxyIx, 'rows', flags{:});
        out = subset (this, Indx, ':');
      else
        isRow = isrow (this);
        this = subset (this, ':');
        tfNaN = isnan (this);
        nans = subset (this, tfNaN);
        nonnans = subset (this, !tfNaN);
        ixNonnan = find (!tfNaN);
        keys = proxyKeys (nonnans);
        if (isa (keys, 'table'))
          [~,ix] = unique (keys, flags{:});
        else
          [~,ix] = unique (keys, 'rows', flags{:});
        endif
        out = [subset(nonnans, ix); nans];
        Indx = [ixNonnan(ix); find(tfNaN)];
        if (isRow)
          out = out';
        endif
      endif
    endfunction

    function [out, Indx] = ismember (a, b, varargin)
      #ISMEMBER True for set member.
      if (ismember ('rows', varargin))
        error ('ismember(..., ''rows'') is unsupported');
      endif
      if (! isa (a, 'calendarDuration'))
        a = calendarDuration (a);
      endif
      if (! isa (b, 'calendarDuration'))
        b = calendarDuration (b);
      endif
      [proxyA, proxyB] = proxyKeys (a, b);
      [out, Indx] = ismember (proxyA, proxyB, 'rows');
      out = reshape (out, size (a));
      Indx = reshape (Indx, size (a));
    endfunction

    function [out, Indx] = setdiff (a, b, varargin)
      #SETDIFF Set difference.
      if (ismember ('rows', varargin))
        error ('setdiff(..., ''rows'') is unsupported');
      endif
      [tf, ~] = ismember (a, b);
      out = parensRef (a, !tf);
      Indx = find (!tf);
      [out, ix] = unique (out);
      Indx = Indx(ix);
    endfunction

    function [out,ia,ib] = intersect (a, b, varargin)
      #INTERSECT Set intersection.
      if (ismember ('rows', varargin))
        error ('intersect(..., ''rows'') is unsupported');
      endif
      [proxyA, proxyB] = proxyKeys (a, b);
      [~,ia,ib] = intersect (proxyA, proxyB, 'rows');
      out = parensRef (a, ia);
    endfunction

    function [out,ia,ib] = union (a, b, varargin)
      #UNION Set union.
      if (ismember ('rows', varargin))
        error ('union(..., ''rows'') is unsupported');
      endif
      [proxyA, proxyB] = proxyKeys (a, b);
      [~,ia,ib] = union (proxyA, proxyB, 'rows');
      aOut = parensRef (a, ia);
      bOut = parensRef (b, ib);
      # Can't have a space after "parensRef" or you get a syntax error
      out = [parensRef(aOut, ':'); parensRef(bOut, ':')];
    endfunction

  endmethods

  methods (Access = private)

    function this = subsasgnParensPlanar (this, s, rhs)
      #SUBSASGNPARENSPLANAR ()-assignment for planar object
      if (isnumeric (rhs) && isequal (size (rhs), [0 0]))
        # Special `x(ix) = []` deletion form
        this.Months(s.subs{:}) = [];
        this.Days(s.subs{:}) = [];
        this.Time(s.subs{:}) = [];
        return
      endif
      if (! isa (rhs, 'calendarDuration'))
        rhs = calendarDuration (rhs);
      endif
      this.Months(s.subs{:}) = rhs.Months;
      this.Days(s.subs{:}) = rhs.Days;
      this.Time(s.subs{:}) = rhs.Time;
    endfunction

    function out = subsrefParensPlanar (this, s)
      #SUBSREFPARENSPLANAR ()-indexing for planar object
      out = this;
      out.Months = this.Months(s.subs{:});
      out.Days = this.Days(s.subs{:});
      out.Time = this.Time(s.subs{:});
    endfunction

    function out = parensRef (this, varargin)
      #PARENSREF ()-indexing, for this class's internal use
      out = subsrefParensPlanar (this, struct ('subs', {varargin}));
    endfunction

    function out = subset (this, varargin)
      #SUBSET Subset array by indexes.
      # This is what you call internally inside the class instead of doing
      # ()-indexing references on the RHS, which don't work properly inside the class
      # because they don't respect the subsref() override.
      out = parensRef (this, varargin{:});
    endfunction

    function out = asgn (this, ix, value)
      #ASGN Assign array elements by indexes.
      # This is what you call internally inside the class instead of doing
      # ()-indexing references on the LHS, which don't work properly inside
      # the class because they don't respect the subsasgn() override.
      if (! iscell (ix))
        ix = { ix };
      endif
      s.type = '()';
      s.subs = ix;
      out = subsasgnParensPlanar (this, s, value);
    endfunction

    function [y, m] = wholeYM (this)
      % This's Months, converted to whole years and remaining months
      y = fix (this.Months / 12);
      m = rem (this.Months, 12);
    endfunction

  endmethods

endclassdef

