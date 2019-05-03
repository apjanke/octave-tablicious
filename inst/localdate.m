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
## @deftp {Class} localdate
##
## Represents a complete day using the Gregorian calendar.
##
## This class is useful for indexing daily-granularity data or representing
## time periods that cover an entire day in local time somewhere. The major
## purpose of this class is "type safety", to prevent time-of-day values
## from sneaking in to data sets that should be daily only. As a secondary
## benefit, this uses less memory than datetimes.
##
## @end deftp
##
## @deftypeivar localdate @code{double} dnums
##
## The underlying datenum values that represent the days. The datenums are at
## the midnight that is at the start of the day it represents.
##
## These are doubles, but
## they are restricted to be integer-valued, so they represent complete days, with
## no time-of-day component.
##
## @end deftypeivar
##
## @deftypeivar localdate @code{char} Format
##
## The format to display this @code{localdate} in. Currently unsupported.
##
## @end deftypeivar

classdef localdate

  properties (Access = private)
    % The underlying datenums, zoneless, always int-valued (midnights)
    dnums = NaN % planar
  endproperties
  properties
    % Format to display these dates in. Changing the format is currently unimplemented.
    Format = 'default'
  endproperties
  properties (Dependent = true)
    Year
    Month
    Day
  endproperties

  methods
    ## -*- texinfo -*-
    ## @node localdate.localdate
    ## @deftypefn {Constructor} {@var{obj} =} localdate ()
    ##
    ## Constructs a new scalar @code{localdate} containing the current local date.
    ##
    ## @end deftypefn
    ##
    ## @deftypefn {Constructor} {@var{obj} =} localdate (@var{datenums})
    ## @deftypefnx {Constructor} {@var{obj} =} localdate (@var{datestrs})
    ## @deftypefnx {Constructor} {@var{obj} =} localdate (@var{Y}, @var{M}, @var{D})
    ## @deftypefnx {Constructor} {@var{obj} =} localdate (@dots{}, @code{'Format'}, @var{Format})
    ##
    ## Constructs a new @code{localdate} array based on input values.
    ##
    ## @end deftypefn
    function this = localdate (varargin)
      %LOCALDATE Construct a new localdate array
      %
      % localdate ()
      % localdate (datenums)
      % localdate (datestrs)
      % localdate (Y, M, D)
      % localdate (..., 'Format', Format)
      %
      % localdate constructs a new localdate array.

      % Peel off options
      args = varargin;
      knownOptions = {'Format','InputFormat','Locale','PivotYear'};
      opts = struct;
      while numel (args) >= 3 && isa (args{end-1}, 'char') ...
          && ismember (args{end-1}, knownOptions)
        opts.(args{end-1}) = args{end};
        args(end-1:end) = [];
      endwhile
      
      % Handle inputs
      switch numel (args)
        case 0
          dnums = floor (now);
        case 1
          x = args{1};
          if isnumeric (x)
            % Convert datenums
            mustBeIntOrNanOrInf (x, 'input');
            dnums = double (x);
          elseif ischar (x) || iscellstr (x) || isa (x, 'string')
            x = cellstr (x);
            tfRelative = ismember (x, {'today','tomorrow','yesterday','now'});
            if all (tfRelative)
              if ~isscalar (x)
                error ('Multiple arguments not allowed for relativeDay format');
              endif
              switch x{1}
                case 'yesterday'
                  dnums = floor (now) - 1;
                case 'today'
                  dnums = floor (now);
                case 'tomorrow'
                  dnums = floor (now) + 1;
                case 'now'
                  dnums = floor (now);
              endswitch
            else
              % They're datestrs
              % TODO: Support Locale option
              if isfield (opts, 'Locale')
                error ('Locale option is unimplemented');
              endif
              % TODO: Support PivotYear option
              if isfield (opts, 'PivotYear')
                error ('PivotYear option is unimplemented');
              endif
              if isfield (opts, 'InputFormat')
                dnums = datenum (x, opts.InputFormat);
              else
                dnums = datenum (x);
              endif
              tf = isIntOrNanOrInf (dnums);
              if ! all (tf)
                error ('localdate: input datestrs may not have nonzero time-of-day parts');
              end
              dnums = reshape (dnums, size (x));
            endif
          elseif isstruct (x)
            error ('localdate: struct to localdate conversion has not been spec''ed or implemented yet');
          elseif ismember (class (x), {'java.util.Date', 'java.util.Date[]', 'java.time.TemporalAccessor', ...
                                       'java.time.TemporalAccessor[]'})
            error ('localdate: Java date conversion is not implemented yet. Sorry.');
          elseif isa (x, 'datetime')
            error ('localdate: datetime to localdate conversion semantics have not been decided yet. Sorry.');
          else
            error ('localdate: Invalid input type: %s', class (x));
          endif
        case 2
          % Undocumented calling form for Chrono's internal use
          if ~isequal (args{2}, 'Backdoor')
            error ('Invalid number of inputs (excluding options): %d', numel (args));
          endif
          dnums = args{1};
          mustBeIntOrNanOrInf (dnums, 'backdoor constructor input');
        case 3
          [Y, M, D] = args{:};
          mustBeIntOrNanOrInf (Y);
          mustBeIntOrNanOrInf (Y);
          mustBeIntOrNanOrInf (Y);
          dnums = datenum (Y, M, D);
        otherwise
          error ('Invalid number of inputs: %d', nargin);
      endswitch

      % Construct
      this.dnums = dnums;
      if isfield (opts, 'Format')
        this.Format = opts.Format;
      endif
      this.validate;
    endfunction
  endmethods

  methods (Static)

    ## -*- texinfo -*-
    ## @node localdate.NaT
    ## @deftypefn {Static Method} {@var{out} =} localdate.NaT ()
    ## @deftypefnx {Static Method} {@var{out} =} localdate.NaT (@var{sz})
    ##
    ## “Not-a-Time”: Creates NaT-valued arrays.
    ## 
    ## Constructs a new @code{datetime} array of all @code{NaT} values of
    ## the given size. If no input @var{sz} is given, the result is a scalar @code{NaT}.
    ##
    ## @code{NaT} is the @code{datetime} equivalent of @code{NaN}. It represents a missing
    ## or invalid value. @code{NaT} values never compare equal to, greater than, or less
    ## than any value, including other @code{NaT}s. Doing arithmetic with a @code{NaT} and
    ## any other value results in a @code{NaT}.
    ##
    ## This static method is provided because the global @code{NaT} function creates
    ## @code{datetime}s, not @code{localdate}s
    ##
    ## @end deftypefn
    function out = NaT ()
      out = localdate (NaN);
    endfunction

    function out = datestruct2datenum (dstruct)
      sz = size (dstruct.Year);
      n = numel (dstruct.Year);
      dvec = NaN (n, 6);
      dvec(:,1) = dstruct.Year(:);
      dvec(:,2) = dstruct.Month(:);
      dvec(:,3) = dstruct.Day(:);
      if isfield (dstruct, 'Hour')
        mustBeIntOrNanOrInf (dstruct.Hour, 'Hour field of datestruct');
      endif
      if isfield (dstruct, 'Hour')
        mustBeIntOrNanOrInf (dstruct.Minute, 'Minute field of datestruct');
      endif
      if isfield (dstruct, 'Hour')
        mustBeIntOrNanOrInf (dstruct.Second, 'Second field of datestruct');
      endif
      dvec(:,4) = 0;
      dvec(:,5) = 0;
      dvec(:,6) = 0;
      out = datenum (dvec);
    endfunction
    
  endmethods

  methods

    function validate (this)
      mustBeNumeric (this.dnums, 'datenum values');
    endfunction

    function [keysA,keysB] = proxyKeys (a, b)
      %PROXYKEYS Proxy key values for sorting and set operations
      keysA = a.dnums(:);
      keysB = b.dnums(:);
    endfunction

    function this = set.Format (this, x)
      error ('Changing localdate format is currently unimplemented');
    endfunction
    
    function out = get.Year (this)
      s = datestruct (this);
      out = s.Year;
    endfunction
    
    function this = set.Year (this, x)
      s = datestruct (this);
      s.Year(:) = x;
      this.dnums = localdate.datestruct2datenum (s);
    endfunction
      
    function out = get.Month (this)
      s = datestruct (this);
      out = s.Month;
    endfunction
    
    function this = set.Month (this, x)
      s = datestruct (this);
      s.Month(:) = x;
      this.dnums = localdate.datestruct2datenum (s);
    endfunction
      
    function out = get.Day (this)
      s = datestruct (this);
      out = s.Day;
    endfunction
    
    function this = set.Day (this, x)
      s = datestruct (this);
      s.Day(:) = x;
      this.dnums = localdate.datestruct2datenum (s);
    endfunction
      
    function out = year (this)
      out = this.Year;
    endfunction
      
    function out = month (this)
      out = this.Month;
    endfunction
      
    function out = day (this)
      out = this.Day;
    endfunction
      
    function out = quarter (this)
      out = ceil (this.Month / 3);
    endfunction
    
    ## -*- texinfo -*-
    ## @node localdate.ymd
    ## @deftypefn {Method} {[@var{y}, @var{m}, @var{d}] =} ymd (@var{obj})
    ##
    ## Get the Year, Month, and Day components of @var{obj}.
    ##
    ## Returns double arrays the same size as @code{obj}.
    ##
    ## @end deftypefn
    function [y, m, d] = ymd (this)
      s = datestruct (this);
      y = s.Year;
      m = s.Month;
      d = s.Day;
    endfunction
    
    function out = week (this)
      error('week() is unimplemented');
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
      elseif isscalar (this)
        str = dispstrs (this);
        str = str{1};
        fprintf (' %s\n', str);
      else
        txt = octave.chrono.internal.format_dispstr_array (dispstrs (this));
        fprintf ('%s\n', txt);
      endif
    endfunction
    
    ## -*- texinfo -*-
    ## @node localdate.dispstrs
    ## @deftypefn {Method} {@var{out} =} dispstrs (@var{obj})
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
      local_dnums = this.dnums;
      tfNaN = isnan (local_dnums);
      out(tfNaN) = {'NaT'};
      if any(~tfNaN(:))
        out(~tfNaN) = cellstr (datestr (local_dnums(~tfNaN)));
      endif
    endfunction
    
    ## -*- texinfo -*-
    ## @node localdate.datestr
    ## @deftypefn {Method} {@var{out} =} datestr (@var{obj})
    ## @deftypefnx {Method} {@var{out} =} datestr (@var{obj}, @dots{})
    ##
    ## Format @var{obj} as date strings. Supports all arguments that core Octave's
    ## @code{datestr} does.
    ##
    ## Returns date strings as a 2-D char array.
    ##
    ## @end deftypefn
    function out = datestr (this, varargin)
      %DATESTR Format as date string.
      out = datestr (this.dnums, varargin{:});
    endfunction
    
    ## -*- texinfo -*-
    ## @node localdate.datestrs
    ## @deftypefn {Method} {@var{out} =} datestrs (@var{obj})
    ## @deftypefnx {Method} {@var{out} =} datestrs (@var{obj}, @dots{})
    ##
    ## Format @var{obj} as date strings, returning cellstr.
    ## Supports all arguments that core Octave's @code{datestr} does.
    ##
    ## Returns a cellstr array the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = datestrs (this, varargin)
      %DATESTSRS Format as date strings.
      %
      % Returns cellstr.
      %
      % This is an Octave extension.
      s = datestr (this);
      c = cellstr (s);
      out = reshape (c, size (this));
    endfunction
    
    ## -*- texinfo -*-
    ## @node localdate.datestruct
    ## @deftypefn {Method} {@var{out} =} datestruct (@var{obj})
    ##
    ## Converts this to a "datestruct" broken-down time structure.
    ##
    ## A "datestruct" is a format of struct that Chrono came up with. It is a scalar
    ## struct with fields Year, Month, and Day, each containing
    ## a double array the same size as the date array it represents. This format
    ## differs from the "datestruct" used by @code{datetime} in that it lacks
    ## Hour, Minute, and Second components. This is done for efficiency.
    ##
    ## The values in the returned broken-down time are those of the local time
    ## in this' defined time zone, if it has one.
    ##
    ## Returns a struct with fields Year, Month, and Day.
    ## Each field contains a double array of the same size as this.
    ##
    ## @end deftypefn
    function out = datestruct (this)
      dvec = datevec (this.dnums);
      sz = size (this);
      out.Year = reshape (dvec(:,1), sz);
      out.Month = reshape (dvec(:,2), sz);
      out.Day = reshape (dvec(:,3), sz);
    endfunction
    
    ## -*- texinfo -*-
    ## @node localdate.posixtime
    ## @deftypefn {Method} {@var{out} =} posixtime (@var{obj})
    ##
    ## Converts this to POSIX time values for midnight of @var{obj}’s days.
    ##
    ## Converts this to POSIX time values that represent the same date. The
    ## returned values will be doubles that will not include fractional second values.
    ## The times returned are those of midnight UTC on @var{obj}’s days.
    ##
    ## Returns double array of same size as this.
    ##
    ## @end deftypefn
    function out = posixtime (this)
      %POSIXTIME Convert this to POSIX time values (seconds since the Unix epoch)
      %
      % Converts this to POSIX time values that represent the same time. The
      % returned values will be doubles that may include fractional second values.
      % POSIX times are, by definition, in UTC.
      %
      % Returns double array of same size as this.
      %
      % This is an Octave extension.

      % Yes, this call to datetime instead of localdate is intentional
      out = datetime.datenum2posix (this.dnums);
    endfunction

    ## -*- texinfo -*-
    ## @node localdate.datenum
    ## @deftypefn {Method} {@var{out} =} datenum (@var{obj})
    ##
    ## Convert this to datenums that represent midnight on @var{obj}’s days.
    ##
    ## Returns double array of same size as this.
    ##
    ## @end deftypefn
    function out = datenum (this)
      out = this.dnums;
    endfunction

    ## -*- texinfo -*-
    ## @node localdate.isnat
    ## @deftypefn {Method} {@var{out} =} isnat (@var{obj})
    ##
    ## True if input elements are NaT.
    ##
    ## Returns logical array the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = isnat (this)
      %ISNAT True if input is NaT.
      out = isnan (this.dnums);
    endfunction
    
    ## -*- texinfo -*-
    ## @node localdate.isnan
    ## @deftypefn {Method} {@var{out} =} isnan (@var{obj})
    ##
    ## True if input elements are NaT. This is an alias for @code{isnat}
    ## to support type compatibility and polymorphic programming.
    ##
    ## Returns logical array the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = isnan (this)
      %ISNAN Alias for isnat.
      %
      % This is an Octave extension
      out = isnat (this);
    endfunction
    
    % Relational operations

    function out = lt (A, B)
      %LT Less than.
      [A, B] = localdate.promote (A, B);
      out = A.dnums < B.dnums;
    endfunction

    function out = le (A, B)
      %LE Less than or equal.
      [A, B] = localdate.promote (A, B);
      out = A.dnums <= B.dnums;
    endfunction

    function out = ne (A, B)
      %NE Not equal.
      [A, B] = localdate.promote (A, B);
      out = A.dnums ~= B.dnums;
    endfunction

    function out = eq (A, B)
      %EQ Equals.
      [A, B] = localdate.promote (A, B);
      out = A.dnums == B.dnums;
    endfunction

    function out = ge (A, B)
      %GE Greater than or equal.
      [A, B] = localdate.promote (A, B);
      out = A.dnums >= B.dnums;
    endfunction

    function out = gt (A, B)
      %GT Greater than.
      [A, B] = localdate.promote (A, B);
      out = A.dnums > B.dnums;
    endfunction

    % Arithmetic
    
    % TODO: Implement arithmetic
    % TBD what the arguments are. Should we take durations and calendarDurations,
    % and just restrict them to have zero time-of-day components?
    
    % Planar boilerplate stuff
  
    function out = numel (this)
      %NUMEL Number of elements in array.
      out = numel (this.dnums);
    endfunction
    
    function out = ndims (this)
      %NDIMS Number of dimensions.
      out = ndims (this.dnums);
    endfunction
    
    function out = size (this)
      %SIZE Size of array.
      out = size (this.dnums);
    endfunction
    
    function out = isempty (this)
      %ISEMPTY True for empty array.
      out = isempty (this.dnums);
    endfunction
    
    function out = isscalar (this)
      %ISSCALAR True if input is scalar.
      out = isscalar (this.dnums);
    endfunction
    
    function out = isvector (this)
      %ISVECTOR True if input is a vector.
      out = isvector (this.dnums);
    endfunction
    
    function out = iscolumn (this)
      %ISCOLUMN True if input is a column vector.
      out = iscolumn (this.dnums);
    endfunction
    
    function out = isrow (this)
      %ISROW True if input is a row vector.
      out = isrow (this.dnums);
    endfunction
    
    function out = ismatrix (this)
      %ISMATRIX True if input is a matrix.
      out = ismatrix (this.dnums);
    endfunction
        
    function this = reshape (this, varargin)
      %RESHAPE Reshape array.
      this.dnums = reshape (this.dnums, varargin{:});
    endfunction
    
    function this = squeeze (this, varargin)
      %SQUEEZE Remove singleton dimensions.
      this.dnums = squeeze (this.dnums, varargin{:});
    endfunction
    
    function this = circshift (this, varargin)
      %CIRCSHIFT Shift positions of elements circularly.
      this.dnums = circshift (this.dnums, varargin{:});
    endfunction
    
    function this = permute (this, varargin)
      %PERMUTE Permute array dimensions.
      this.dnums = permute (this.dnums, varargin{:});
    endfunction
    
    function this = ipermute (this, varargin)
      %IPERMUTE Inverse permute array dimensions.
      this.dnums = ipermute (this.dnums, varargin{:});
    endfunction
    
    function this = repmat (this, varargin)
      %REPMAT Replicate and tile array.
      this.dnums = repmat (this.dnums, varargin{:});
    endfunction
    
    function this = ctranspose (this, varargin)
      %CTRANSPOSE Complex conjugate transpose.
      this.dnums = ctranspose (this.dnums, varargin{:});
    endfunction
    
    function this = transpose (this, varargin)
      %TRANSPOSE Transpose vector or matrix.
      this.dnums = transpose (this.dnums, varargin{:});
    endfunction
    
    function [this, nshifts] = shiftdim (this, n)
      %SHIFTDIM Shift dimensions.
      if nargin > 1
        this.dnums = shiftdim (this.dnums, n);
      else
        [this.dnums, nshifts] = shiftdim (this.dnums);
      endif
    endfunction
    
    function out = cat (dim, varargin)
      %CAT Concatenate arrays.
      args = localdate.promotec (varargin);
      out = args{1};
      fieldArgs = cellfun (@(obj) obj.dnums, args, 'UniformOutput', false);
      out.dnums = cat (dim, fieldArgs{:});
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
      if numel(s) > 1
        rhs_in = subsref (this, s(1));
        rhs = subsasgn (rhs_in, s(2:end), b);
      else
        rhs = b;
      endif
      
      % Base case
      switch s(1).type
        case '()'
          this = subsasgnParensPlanar (this, s(1), rhs);
          %TODO: Correct value of vivified indexes to NaN; right now it's zero.
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
      if numel (s) > 1
        out = subsref (out, s(2:end));
      endif
    endfunction
        
    function [out, Indx] = sort (this)
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
        Indx = [ixNonNan(ix); find (tfNan)];
        if isRow
            out = out';
        endif
      elseif ismatrix (this)
        out = this;
        Indx = NaN (size(out));
        for iCol = 1:size (this, 2)
          [sortedCol, Indx(:,iCol)] = sort (subset (this, ':', iCol));
          out = asgn (out, {':', iCol}, sortedCol);
        endfor
      else
        [out, Indx] = sortND (this);
      endif
    endfunction

    function [out, Indx] = sortND (this)
      %SORTND N-dimensional sort implementation
      
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
    endfunction
    
    function [out, Indx] = unique (this, varargin)
      %UNIQUE Set unique.
      flags = setdiff (varargin, {'rows'});
      if ismember('rows', varargin)
        [~,proxyIx] = unique (this);
        proxyIx = reshape (proxyIx, size (this));
        [~,Indx] = unique (proxyIx, 'rows', flags{:});
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
        Indx = [ixNonnan(ix); find (tfNaN)];
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
      if ~isa (a, 'localdate')
        a = localdate (a);
      endif
      if ~isa (b, 'localdate')
        b = localdate (b);
      endif
      [proxyA, proxyB] = proxyKeys (a, b);
      [out, Indx] = ismember (proxyA, proxyB, 'rows');
      out = reshape (out, size(a));
      Indx = reshape (Indx, size(a));
    endfunction
    
    function [out, Indx] = setdiff (a, b, varargin)
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
      if ~isa (rhs, 'localdate')
        rhs = localdate (rhs);
      endif
      out = this;
      out.dnums = octave.chrono.internal.prefillNewSizeForSubsasgn(this.dnums, s.subs, NaN);
      out.dnums(s.subs{:}) = rhs.dnums;
    endfunction
    
    function out = subsrefParensPlanar (this, s)
      %SUBSREFPARENSPLANAR ()-indexing for planar object
      out = this;
      out.dnums = this.dnums(s.subs{:});
    endfunction
    
    function out = parensRef (this, varargin)
      %PARENSREF ()-indexing, for this class's internal use
      out = subsrefParensPlanar(this, struct ('subs', {varargin}));
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
  
  methods (Static = true)

    function out = promotec (args)
      %PROMOTEC Promote inputs to be compatible, cell version
      out = cell(size(args));
      [out{:}] = promote(args{:});
    endfunction

    function varargout = promote (varargin)
      %PROMOTE Promote inputs to be compatible
      args = varargin;
      for i = 1:numel (args)
        if ~isa (args{i}, 'localdate')
          args{i} = localdate (args{i});
        endif
      endfor
      varargout = args;
    endfunction

  endmethods

endclassdef


function out = isIntOrNanOrInf (x)
  tfInt = floor (x) == x;
  out = tfInt | isnan (x) | isinf (x);
endfunction

function mustBeNumeric (x, label)
  if nargin < 2; label = []; endif
  if isnumeric (x)
    return
  end
    if isempty (label)
      label = inputname (1);
    endif
    if isempty (label)
      label = "input";
    endif
    error ("localdate: %s must be numeric; but got a %s", ...
      label, class (x));
endfunction

function x = mustBeIntOrNanOrInf (x, label)
  if nargin < 2; label = []; endif
  if isinteger (x) || islogical (x)
    return
  endif
  but = [];
  if ! isnumeric (x)
    but = sprintf ("it was non-numeric (got a %s)", class (x));
  elseif ! isreal (x)
    but = "it was complex";
  elseif ! all (floor (x) == x)
    but = "it had fractional values in some elements";
  end
  if ! isempty (but)
    if isempty (label)
      label = inputname (1);
    endif
    if isempty (label)
      label = "input";
    endif
    error ("localdate: %s must be integer-valued; but %s", ...
      label, but);
  endif
endfunction
