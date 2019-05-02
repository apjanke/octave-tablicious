## Copyright (C) 2019 Andrew Janke <floss@apjanke.net>
##
## This file is part of Octave.
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
## @deftp {Class} duration
##
## Represents durations or periods of time as an amount of fixed-length
## time (i.e. fixed-length seconds). It does not care about calendar things
## like months and days that vary in length over time.
##
## This is an attempt to reproduce the functionality of Matlab's @code{duration}. It
## also contains some Octave-specific extensions.
##
## @end deftp
##
## @deftypeivar duration @code{double} days
##
## The underlying datenums that represent the durations, as number of (whole and
## fractional) days. These are uniform 24-hour days, not calendar days.
##
## This is a planar property: the size of @code{days} is the same size as the 
## containing @code{duration} array object.
##
## @end deftypeivar
##
## @deftypeivar duration @code{char} Format
##
## The format to display this @code{duration} in. Currently unsupported.
##
## @end deftypeivar
##
## @node duration.duration
## @subsubsection duration.duration
## @deftypefn {Constructor} {@var{obj} =} duration ()
##
## Constructs a new scalar @code{duration} of zero elapsed time.
##
## @end deftypefn
##
## @deftypefn {Constructor} {@var{obj} =} duration (@var{durationstrs})
## @deftypefnx {Constructor} {@var{obj} =} duration (@var{durationstrs}, @code{'InputFormat'}, @var{InputFormat})
## @deftypefnx {Constructor} {@var{obj} =} duration (@var{H}, @var{MI}, @var{S})
## @deftypefnx {Constructor} {@var{obj} =} duration (@var{H}, @var{MI}, @var{S}, @
##   @var{MS})
##
## Constructs a new @code{duration} array based on input values.
##
## @end deftypefn


classdef duration
  %DURATION Lengths of time in fixed-length units
  %
  % Duration values are stored as double numbers of days, so they are an
  % approximate type. In display functions, by default, they are displayed with
  % millisecond precision, but their actual precision is closer to nanoseconds
  % for typical times.
  
  properties
    % Duration length in whole and fractional days (double)
    days = 0 % planar
    % Display format (currently unsupported)
    Format = ''
  endproperties
  
  methods (Static)
    ## -*- texinfo -*-
    ## @node duration.ofDays
    ## @subsubsection duration.ofDays
    ## @deftypefn {Static Method} {@var{obj} =} duration.ofDays (@var{dnums})
    ##
    ## Converts a double array representing durations in whole and fractional days
    ## to a @code{duration} array. This is the method that is used for implicit conversion
    ## of numerics in many cases.
    ##
    ## Returns a @code{duration} array of the same size as the input.
    ##
    ## @end deftypefn
    function out = ofDays (dnums)
      %OFDAYS Convert days/datenums to durations
      out = duration (double (dnums), 'Backdoor');
    endfunction
  endmethods

  methods
    function this = duration (varargin)
      %DURATION Construct a new duration array
      args = varargin;
      % Peel off options
      knownOptions = {'InputFormat','Format'};
      opts = struct;
      while numel (args) >= 3 && isa (args{end-1}, 'char') ...
          && ismember (args{end-1}, knownOptions)
        opts.(args{end-1}) = args{end};
        args(end-1:end) = [];
      endwhile
      % Handle inputs
      switch numel (args)
        case 0
          return
        case 1
          in = args{1};
          if isnumeric (in)
            switch size (in, 2)
              case 3
                [H, MI, S] = deal (in(:,1), in(:,2), in(:,3));
                this.days = duration.hms2datenum (H, MI, S, 0);
              case 4
                [H, MI, S, MS] = deal (in(:,1), in(:,2), in(:,3), in(:,4));
                this.days = duration.hms2datenum (H, MI, S, MS);
              otherwise
                error ('Numeric inputs must be 3 or 4 columns wide.');
            endswitch
          else
            in = cellstr (in);
            if isfield (opts, 'InputFormat')
              this.days = duration.parseTimeStringsToDatenumWithFormat (in, opts.InputFormat);
            else
              this.days = duration.parseTimeStringsToDatenum (in);
            endif
          endif
        case 2
          % Undocumented calling form for internal use
          if ~isequal (args{2}, 'Backdoor')
            error ('Invalid number if inputs: %d', numel (args));
          endif
          if ~isnumeric (args{1})
            error ('Input must be numeric; got a %s', class (args{1}));
          endif
          this.days = double (args{1});
        case 3
          [H, MI, S] = args{:};
          this.days = duration.hms2datenum (H, MI, S, 0);
        case 4
          [H, MI, S, MS] = args{:};
          this.days = duration.hms2datenum (H, MI, S, MS);
        otherwise
          error ('Invalid number if inputs: %d', numel (args));
      endswitch
    endfunction
    
    function this = set.Format (this, x)
      error ('Changing the Format of duration is currently unimplemented.');
    endfunction
    
    ## -*- texinfo -*-
    ## @node duration.years
    ## @subsubsection duration.years
    ## @deftypefn {Method} {@var{out} =} years (@var{obj})
    ##
    ## Equivalent number of years.
    ##
    ## Gets the number of fixed-length 365.2425-day years that is equivalent
    ## to this duration.
    ##
    ## Returns double array the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = years (this)
      %YEARS Number of fixed-length years equivalent to this.
      out = this.days / 365.2425;      
    endfunction

    # Can't have a days() function as well as a days property or it will cause Octave to crash
    # At least, sometimes it does. And it's happened often enough that I don't want
    # to leave it in. If you can find out what conditions reproduce this, please
    # bug report. -apj
    
##    function out = days (this)
##      %DAYS Number of fixed-length days equivalent to this.
##      out = this.days;
##    endfunction

    ## -*- texinfo -*-
    ## @node duration.hours
    ## @subsubsection duration.hours
    ## @deftypefn {Method} {@var{out} =} hours (@var{obj})
    ##
    ## Equivalent number of hours.
    ##
    ## Gets the number of fixed-length 60-minute hours that is equivalent
    ## to this duration.
    ##
    ## Returns double array the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = hours (this)
      %HOURS Number of hours equivalent to this.
      out = this.days * 24;
    endfunction
    
    ## -*- texinfo -*-
    ## @node duration.minutes
    ## @subsubsection duration.minutes
    ## @deftypefn {Method} {@var{out} =} minutes (@var{obj})
    ##
    ## Equivalent number of minutes.
    ##
    ## Gets the number of fixed-length 60-second minutes that is equivalent
    ## to this duration.
    ##
    ## Returns double array the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = minutes (this)
      %MINUTES Number of minutes equivalent to this.
      out = this.days * (24 * 60);
    endfunction
    
    ## -*- texinfo -*-
    ## @node duration.seconds
    ## @subsubsection duration.seconds
    ## @deftypefn {Method} {@var{out} =} seconds (@var{obj})
    ##
    ## Equivalent number of seconds.
    ##
    ## Gets the number of seconds that is equivalent
    ## to this duration.
    ##
    ## Returns double array the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = seconds (this)
      %SECPMDS Number of seconds equivalent to this.
      out = this.days * (24 * 60 * 60);
    endfunction
    
    ## -*- texinfo -*-
    ## @node duration.milliseconds
    ## @subsubsection duration.milliseconds
    ## @deftypefn {Method} {@var{out} =} milliseconds (@var{obj})
    ##
    ## Equivalent number of milliseconds.
    ##
    ## Gets the number of milliseconds that is equivalent
    ## to this duration.
    ##
    ## Returns double array the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = milliseconds (this)
      %MILLISECONDS Number of milliseconds equivalent to this.
      out = this.days * (24 * 60 * 60 * 1000);
    endfunction

    function [keysA, keysB] = proxyKeys (a, b)
      %PROXYKEYS Proxy key values for sorting and set operations
      keysA = a.days(:);
      keysB = b.days(:);
    endfunction

    function display (this)
      %DISPLAY Custom display.
      in_name = inputname (1);
      if ~isempty (in_name)
        fprintf ('%s =\n', in_name);
      endif
      disp (this);
    endfunction

    function disp (this)
      %DISP Custom display.
      if isempty (this)
        fprintf ('Empty %s %s\n', size2str (size (this)), class (this));
        return;
      endif
      out = octave.chrono.internal.format_dispstr_array (dispstrs (this));
      fprintf ('%s\n', out);
    endfunction
    
    ## -*- texinfo -*-
    ## @node duration.dispstrs
    ## @subsubsection duration.dispstrs
    ## @deftypefn {Method} {@var{out} =} duration (@var{obj})
    ##
    ## Get display strings for each element of @var{obj}.
    ##
    ## Returns a cellstr the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = dispstrs (this)
      %DISPSTRS Custom display strings.
      % This is an Octave extension.
      out = cell (size (this));
      for i = 1:numel (this)
        d = this.days(i);
        if isnan (d)
          out{i} = 'NaT';
          continue
        endif
        str = '';
        if d < 0
          str = [str '-'];
          d = abs(d);
        endif
        if d > 1
          str = [str sprintf('%d days ', floor(d))];
          d = mod (d,1);
        endif
        millis = round (d * (24 * 60 * 60 * 1000));
        sec = millis / 1000;
        fracSec = rem (sec,1);
        x = floor (sec);
        hours = floor (x / (60 * 60));
        x = rem (x, (60 * 60));
        minutes = floor (x / 60);
        x = rem (x, 60);
        seconds = x;
        msec = round (fracSec * 1000);
        if msec == 1000
          seconds = seconds + 1;
          msec = 0;
        endif
        str = [str sprintf('%02d:%02d:%02d', hours, minutes, seconds)];
        if msec >= 1
          str = [str '.' sprintf('%03d', msec)];
        endif
        out{i} = str;
      endfor
    endfunction
    
    ## -*- texinfo -*-
    ## @node duration.char
    ## @subsubsection duration.char
    ## @deftypefn {Method} {@var{out} =} char (@var{obj})
    ##
    ## Convert to char. The contents of the strings will be the same as
    ## returned by @code{dispstrs}.
    ##
    ## This is primarily a convenience method for use on scalar @var{obj}s.
    ##
    ## Returns a 2-D char array with one row per element in @var{obj}.
    ##
    ## @end deftypefn
    function out = char (this)
      %CHAR Convert to char.
      %
      % This is an Octave extension.
      out = char (dispstrs (subset (this, ':')));
    endfunction
    
    % Relational operations

    function out = lt (A, B)
      %LT Less than.
      [A, B] = duration.promote (A, B);
      out = A.days < B.days;
    endfunction

    function out = le (A, B)
      %LE Less than or equal.
      [A, B] = duration.promote (A, B);
      out = A.days <= B.days;
    endfunction

    function out = ne (A, B)
      %NE Not equal.
      [A, B] = duration.promote (A, B);
      out = A.days ~= B.days;
    endfunction

    function out = eq (A, B)
      %EQ Equals.
      [A, B] = duration.promote (A, B);
      out = A.days == B.days;
    endfunction

    function out = ge (A, B)
      %GE Greater than or equal.
      [A, B] = duration.promote (A, B);
      out = A.days >= B.days;
    endfunction

    function out = gt (A, B)
      %GT Greater than.
      [A, B] = duration.promote (A, B);
      out = A.days > B.days;
    endfunction

    % Arithmetic
    
    function out = times (A, B)
      %TIMES Multiplication
      if isnumeric (A)
        out = B;
        out.days = out.days .* A;
      elseif isnumeric (B)
        out = A;
        out.days = out.days .* B;
      else
        error ('Invalid inputs to times: %s * %s', class (A), class (B));
      endif
    endfunction

    function out = mtimes (A, B)
      %MTIMES Multiplication
      if isnumeric (A)
        out = B;
        out.days = out.days * A;
      elseif isnumeric (B)
        out = A;
        out.days = out.days * B;
      else
        error ('Invalid inputs to mtimes: %s * %s', class (A), class (B));
      endif
    endfunction
  
    function out = rdivide (A, B)
      %RDIVIDE Element-wise right division
      if ~isa (A, 'duration')
        error ('When dividing using duration, the left-hand side must be a duration; got a %s', ...
          class (A));
      endif
      if isa (B, 'duration')
        out = A.days ./ B.days;
      elseif isa (B, 'double')
        out = A;
        out.days = A.days ./ B;
      else
        error ('Invalid input: RHS must be duration or double; got a %s', class (B));
      endif
    endfunction
    
    function out = mrdivide (A, B)
      %MRDIVIDE Matrix right division
      if ~isa (A, 'duration')
        error ('When dividing using duration, the left-hand side must be a duration; got a %s', ...
          class (A));
      endif
      if isa (B, 'double')
        out = A;
        out.days = A.days / B;
      else
        error ('Invalid input: RHS must be double; got a %s', class (B));      
      endif
    endfunction
  
    function out = plus (A, B)
      %PLUS Addition
      if isa (A, 'datetime') && isa (B, 'duration')
        out = A;
        out.dnums = out.dnums + B.days;
      elseif isa (A, 'duration') && isa (B, 'datetime')
        out = B + A;
      elseif isa (A, 'duration') && isa (B, 'duration')
        out = A;
        out.days = A.days + B.days;
      elseif isa (A, 'duration') && isa (B, 'double')
        out = A;
        out.days = A.days + B;
      elseif isa (A, 'double') && isa (B, 'duration')
        out = B + A;
      endif
    endfunction
    
    function out = minus (A, B)
      %MINUS Subtraction
      out = A + (-1 * B);
    endfunction
    
    function out = uminus (A)
      %UMINUS Unary minus
      out = A;
      out.days = -1 * A.days;
    endfunction
    
    function out = uplus (A)
      %UPLUS Unary plus
      out = A;
    endfunction
    
    function out = colon (varargin)
      %COLON Generate range for colon expression
      narginchk (2, 3);
      if nargin == 2;
        [from, to] = varargin{:};
        increment = 1;
      else
        [from, increment, to] = varargin{:};
      endif
      [from, increment, to] = duration.promote (from, increment, to);
      out = from;
      out.days = from.days:increment.days:to.days;
    endfunction
    
    ## -*- texinfo -*-
    ## @node duration.linspace
    ## @subsubsection duration.linspace
    ## @deftypefn {Method} {@var{out} =} linspace (@var{from}, @var{to}, @var{n})
    ##
    ## Linearly-spaced values in time duration space.
    ##
    ## Constructs a vector of @code{duration}s that represent linearly spaced points
    ## starting at @var{from} and going up to @var{to}, with @var{n} points in the
    ## vector.
    ##
    ## @var{from} and @var{to} are implicitly converted to @code{duration}s.
    ##
    ## @var{n} is how many points to use. If omitted, defaults to 100.
    ##
    ## Returns an @var{n}-long @code{datetime} vector.
    ##
    ## @end deftypefn
    function out = linspace (A, B, n)
      %LINSPACE Linearly spaced elements between two values
      narginchk (2, 3);
      if nargin < 3; n = 100; end
      [A, B] = duration.promote (A, B);
      out = A;
      out.days = linspace (A.days, B.days, n);
    endfunction
  endmethods
  
  methods (Static, Access = private)
    function out = hms2datenum (H, MI, S, MS)
      if nargin < 4; MS = 0; endif
      [H, MI, S, MS] = deal (double(H), double(MI), double(S), double(MS));
      out = (H / 24) + (MI / (24 * 60)) + (S / (24 * 60 * 60)) ...
        + (MS / (24 * 60 * 60 * 1000));
    endfunction
    
    function out = parseTimeStringsToDatenum (strs)
      strs = cellstr (strs);
      out = NaN (size (strs));
      for i = 1:size (strs)
        strIn = strs{i};
        str = strIn;
        ixDot = find (str == '.');
        if numel (ixDot) > 1
          error ('Invalid TimeString: ''%s''', strIn);
        elseif ~isempty (ixDot)
          fractionalSecStr = str(ixDot+1:end);
          str(ixDot:end) = [];
          nFracs = str2double (fractionalSecStr);
          fractionalSec = nFracs / (10^numel (fractionalSecStr));
          MS = fractionalSec * 1000;          
        else
          MS = 0;
        endif
        els = strsplit (str, ':');
        if numel (els) == 3
          D = 0;
          [H, MI, S] = deal (str2double (els{1}), str2double (els{2}), ...
            str2double (els{3}));
        elseif numel(els) == 4
          [D, H, MI ,S] = deal(str2double (els{1}), str2double (els{2}), ...
            str2double (els{3}), str2double (els{4}));
        else
          error ('Invalid TimeString: ''%s''', strIn);
        endif
        out(i) = duration.hms2datenum (D * 24 + H, MI, S, MS);
      endfor
    endfunction
    
    function out = parseTimeStringsToDatenumWithFormat (strs)
      error ('InputFormat support for time strings is unimplemented');
    endfunction

  end
 
  % Planar boilerplate stuff
  
  methods
  
    function out = numel (this)
      %NUMEL Number of elements in array.
      out = numel (this.days);
    endfunction
    
    function out = ndims (this)
      %NDIMS Number of dimensions.
      out = ndims (this.days);
    endfunction
    
    function out = size (this)
      %SIZE Size of array.
      out = size (this.days);
    endfunction
    
    function out = isempty (this)
      %ISEMPTY True for empty array.
      out = isempty (this.days);
    endfunction
    
    function out = isscalar (this)
      %ISSCALAR True if input is scalar.
      out = isscalar (this.days);
    endfunction
    
    function out = isvector (this)
      %ISVECTOR True if input is a vector.
      out = isvector (this.days);
    endfunction
    
    function out = iscolumn (this)
      %ISCOLUMN True if input is a column vector.
      out = iscolumn (this.days);
    endfunction
    
    function out = isrow (this)
      %ISROW True if input is a row vector.
      out = isrow (this.days);
    endfunction
    
    function out = ismatrix (this)
      %ISMATRIX True if input is a matrix.
      out = ismatrix (this.days);
    endfunction
    
    function out = isnan (this)
      %ISNAN True for Not-a-Number.
      out = isnan (this.days);
    endfunction
    
    function this = reshape (this, varargin)
      %RESHAPE Reshape array.
      this.days = reshape (this.days, varargin{:});
    endfunction
    
    function this = squeeze (this, varargin)
      %SQUEEZE Remove singleton dimensions.
      this.days = squeeze (this.days, varargin{:});
    endfunction
    
    function this = circshift (this, varargin)
      %CIRCSHIFT Shift positions of elements circularly.
      this.days = circshift (this.days, varargin{:});
    endfunction
    
    function this = permute (this, varargin)
      %PERMUTE Permute array dimensions.
      this.days = permute (this.days, varargin{:});
    endfunction
    
    function this = ipermute (this, varargin)
      %IPERMUTE Inverse permute array dimensions.
      this.days = ipermute (this.days, varargin{:});
    endfunction
    
    function this = repmat (this, varargin)
      %REPMAT Replicate and tile array.
      this.days = repmat (this.days, varargin{:});
    endfunction
    
    function this = ctranspose (this, varargin)
      %CTRANSPOSE Complex conjugate transpose.
      this.days = ctranspose (this.days, varargin{:});
    endfunction
    
    function this = transpose (this, varargin)
      %TRANSPOSE Transpose vector or matrix.
      this.days = transpose (this.days, varargin{:});
    endfunction
    
    function [this, nshifts] = shiftdim (this, n)
      %SHIFTDIM Shift dimensions.
      if nargin > 1
          this.days = shiftdim (this.days, n);
      else
          [this.days, nshifts] = shiftdim (this.days);
      endif
    endfunction
    
    function out = cat (dim, varargin)
      %CAT Concatenate arrays.
      args = varargin;
      for i = 1:numel (args)
          if ~isa (args{i}, 'duration')
              args{i} = duration (args{i});
          endif
      endfor
      out = args{1};
      fieldArgs = cellfun (@(obj) obj.days, args, 'UniformOutput', false);
      out.days = cat (dim, fieldArgs{:});
    endfunction
    
    function out = horzcat (varargin)
      %HORZCAT Horizontal concatenation.
      out = cat (2, varargin{:});
    endfunction
    
    function out = vertcat (varargin)
      %VERTCAT Vertical concatenation.
      out = cat (1, varargin{:});
    endfunction
    
    function this = subsasgn (this, s, b)
      %SUBSASGN Subscripted assignment.
      
      % Chained subscripts
      if numel (s) > 1
        rhs_in = subsref (this, s(1));
        rhs = subsasgn (rhs_in, s(2:end), b);
      else
        rhs = b;
      endif
      
      % Base case
      switch s(1).type
        case '()'
          this = subsasgnParensPlanar (this, s(1), rhs);
        case '{}'
          error ('{}-subscripting is not supported for class %s', class (this));
        case '.'
          this.(s(1).subs) = rhs;
      endswitch
    endfunction
    
    function out = subsref (this, s)
      %SUBSREF Subscripted reference.
      
      % Base case
      switch s(1).type
        case '()'
          out = subsrefParensPlanar (this, s(1));
        case '{}'
          error ('{}-subscripting is not supported for class %s', class (this));
        case '.'
          out = this.(s(1).subs);
      endswitch
      
      % Chained reference
      if numel(s) > 1
        out = subsref (out, s(2:end));
      endif
    endfunction
        
    function [out,Indx] = sort (this)
      %SORT Sort array elements.
      if isvector (this)
        isRow = isrow (this);
        this = subset (this, ':');
        % NaNs sort stably to end, so handle them separately
        tfNan = isnan (this);
        nans = subset (this, tfNan);
        nonnans = subset (this, ~tfNan);
        ixNonNan = find (~tfNan);
        proxy = proxyKeys (nonnans);
        [~, ix] = sortrows (proxy);
        out = [subset(nonnans, ix); nans];
        Indx = [ixNonNan(ix); find(tfNan)];
        if isRow
          out = out';
        endif
      elseif ismatrix (this)
        out = this;
        Indx = NaN (size (out));
        for iCol = 1:size(this, 2)
          [sortedCol, Indx(:,iCol)] = sort (subset (this, ':', iCol));
          out = asgn (out, {':', iCol}, sortedCol);
        endfor
      else
        % I believe this multi-dimensional implementation is correct,
        % but have not tested it yet. Use with caution.
        out = this;
        Indx = NaN (size (out));
        sz = size (this);
        nDims = ndims (this);
        ixs = [{':'} repmat({1}, [1 nDims-1])];
        while true
          col = subset (this, ixs{:});
          [sortedCol, sortIx] = sort (col);
          Indx(ixs{:}) = sortIx;
          out = asgn (out, ixs, sortedCol);
          ixs{end} = ixs{end}+1;
          for iDim=nDims:-1:3
            if ixs{iDim} > sz(iDim)
              ixs{iDim-1} = ixs{iDim-1} + 1;
              ixs{iDim} = 1;
            endif
          endfor
          if ixs{2} > sz(2)
            break;
          endif
        endwhile
      endif
    endfunction
    
    function [out,Indx] = unique (this, varargin)
      %UNIQUE Set unique.
      flags = setdiff (varargin, {'rows'});
      if ismember ('rows', varargin)
        [~, proxyIx] = unique (this);
        proxyIx = reshape (proxyIx, size (this));
        [~, Indx] = unique (proxyIx, 'rows', flags{:});
        out = subset (this, Indx, ':');
      else
        isRow = isrow (this);
        this = subset (this, ':');
        tfNaN = isnan (this);
        nans = subset (this, tfNaN);
        nonnans = subset (this, ~tfNaN);
        ixNonnan = find (~tfNaN);
        keys = proxyKeys (nonnans);
        if isa (keys, 'table')
          [~,ix] = unique (keys, flags{:});
        else
          [~,ix] = unique (keys, 'rows', flags{:});
        endif
        out = [subset(nonnans, ix); nans];
        Indx = [ixNonnan(ix); find(tfNaN)];
        if isRow
          out = out';
        endif
      endif
    endfunction
    
    function [out, Indx] = ismember (a, b, varargin)
      %ISMEMBER True for set member.
      if ismember ('rows', varargin)
        error ('ismember(..., ''rows'') is unsupported');
      endif
      if ~isa (a, 'duration')
        a = duration (a);
      endif
      if ~isa (b, 'duration')
        b = duration (b);
      endif
      [proxyA, proxyB] = proxyKeys (a, b);
      [out,Indx] = ismember (proxyA, proxyB, 'rows');
      out = reshape (out, size(a));
      Indx = reshape (Indx, size(a));
    endfunction
    
    function [out,Indx] = setdiff (a, b, varargin)
      %SETDIFF Set difference.
      if ismember ('rows', varargin)
        error ('setdiff(..., ''rows'') is unsupported');
      endif
      [tf,~] = ismember (a, b);
      out = parensRef (a, ~tf);
      Indx = find (~tf);
      [out,ix] = unique (out);
      Indx = Indx(ix);
    endfunction
    
    function [out, ia, ib] = intersect (a, b, varargin)
      %INTERSECT Set intersection.
      if ismember ('rows', varargin)
        error ('intersect(..., ''rows'') is unsupported');
      endif
      [proxyA, proxyB] = proxyKeys (a, b);
      [~,ia,ib] = intersect (proxyA, proxyB, 'rows');
      out = parensRef (a, ia);
    endfunction
    
    function [out, ia, ib] = union (a, b, varargin)
      %UNION Set union.
      if ismember ('rows', varargin)
        error ('union(..., ''rows'') is unsupported');
      endif
      [proxyA, proxyB] = proxyKeys (a, b);
      [~,ia,ib] = union (proxyA, proxyB, 'rows');
      aOut = parensRef (a, ia);
      bOut = parensRef (b, ib);
      out = [parensRef(aOut, ':'); parensRef(bOut, ':')];
    endfunction
      
  endmethods
  
  methods (Access=private)
  
    function out = subsasgnParensPlanar (this, s, rhs)
      %SUBSASGNPARENSPLANAR ()-assignment for planar object
      if ~isa (rhs, 'duration')
        rhs = duration (rhs);
      endif
      out = this;
      out.days = octave.chrono.internal.prefillNewSizeForSubsasgn(this.days, s.subs, NaN);
      out.days(s.subs{:}) = rhs.days;
    endfunction
    
    function out = subsrefParensPlanar (this, s)
      %SUBSREFPARENSPLANAR ()-indexing for planar object
      out = this;
      out.days = this.days(s.subs{:});
    endfunction
    
    function out = parensRef (this, varargin)
      %PARENSREF ()-indexing, for this class's internal use
      out = subsrefParensPlanar (this, struct ('subs', {varargin}));
    endfunction
    
    function out = subset (this, varargin)
      %SUBSET Subset array by indexes.
      % This is what you call internally inside the class instead of doing 
      % ()-indexing references on the RHS, which don't work properly inside the class
      % because they don't respect the subsref() override.
      out = parensRef (this, varargin{:});
    endfunction
    
    function out = asgn (this, ix, value)
      %ASGN Assign array elements by indexes.
      % This is what you call internally inside the class instead of doing 
      % ()-indexing references on the LHS, which don't work properly inside
      % the class because they don't respect the subsasgn() override.
      if ~iscell (ix)
        ix = { ix };
      endif
      s.type = '()';
      s.subs = ix;
      out = subsasgnParensPlanar (this, s, value);
    endfunction
  
  endmethods
  
  methods (Static)
    function varargout = promote (varargin)
      %PROMOTE Promote inputs to be compatible
      args = varargin;
      for i = 1:numel(args)
        if ~isa (args{i}, 'duration')
          % Sigh. We can't use a simple constructor call because of its weird
          % signature.
          if isnumeric (args{i})
            args{i} = duration.ofDays (args{i});
          else
            args{i} = duration (args{i});
          endif
        endif
      endfor
      varargout = args;
    endfunction
  endmethods
endclassdef


%!test duration;
%!test duration (1, 2, 3);
%!test assert (duration (1, 2, 3) < duration (1, 2, 4))

