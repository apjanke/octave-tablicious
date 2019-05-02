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
## @deftp {Class} datetime
##
## Represents points in time using the Gregorian calendar.
##
## The underlying values are doubles representing the number of days since the
## Matlab epoch of "January 0, year 0". This has a precision of around nanoseconds
## for typical times.
##
## A @code{datetime} array is an array of date/time values, with each element
## holding a complete date/time. The overall array may also have a TimeZone and a
## Format associated with it, which apply to all elements in the array.
##
##
## This is an attempt to reproduce the functionality of Matlab's @code{datetime}. It
## also contains some Octave-specific extensions.
##
## @end deftp
##
## @deftypeivar datetime @code{double} dnums
##
## The underlying datenums that represent the points in time. These are always in UTC.
##
## This is a planar property: the size of @code{dnums} is the same size as the 
## containing @code{datetime} array object.
##
## @end deftypeivar
##
## @deftypeivar datetime @code{char} TimeZone
##
## The time zone this @code{datetime} array is in. Empty if this does not have a
## time zone associated with it (“unzoned”). The name of an IANA time zone if
## this does.
##
## Setting the @code{TimeZone} of a @code{datetime} array changes the time zone it
## is presented in for strings and broken-down times, but does not change the
## underlying UTC times that its elements represent.
##
## @end deftypeivar 
##
## @deftypeivar datetime @code{char} Format
##
## The format to display this @code{datetime} in. Currently unsupported.
##
## @end deftypeivar

classdef datetime
  
  properties (Constant)
    PosixEpochDatenum = datenum (1970, 1, 1);
    SystemTimeZone = octave.chrono.internal.detect_system_timezone;
  endproperties

  properties (Access = private)
    % The underlying datenum values, always in UTC
    dnums = NaN % planar
  endproperties
  properties
    % Time zone code as charvec. This governs how display strings and broken-down
    % times are calculated.
    TimeZone = ''
    % Format to display these dates in. Changing the format is currently unimplemented.
    Format = 'default'
  endproperties
  properties (Dependent = true)
    Year
    Month
    Day
    Hour
    Minute
    Second
  endproperties

  methods
    ## -*- texinfo -*-
    ## @node datetime.datetime
    ## @deftypefn {Constructor} {@var{obj} =} datetime ()
    ##
    ## Constructs a new scalar @code{datetime} containing the current local time, with
    ## no time zone attached.
    ##
    ## @end deftypefn
    ##
    ## @deftypefn {Constructor} {@var{obj} =} datetime (@var{datevec})
    ## @deftypefnx {Constructor} {@var{obj} =} datetime (@var{datestrs})
    ## @deftypefnx {Constructor} {@var{obj} =} datetime (@var{in}, @code{'ConvertFrom'}, @var{inType})
    ## @deftypefnx {Constructor} {@var{obj} =} datetime @
    ##   (@var{Y}, @var{M}, @var{D}, @var{H}, @var{MI}, @var{S})
    ## @deftypefnx {Constructor} {@var{obj} =} datetime @
    ##   (@var{Y}, @var{M}, @var{D}, @var{H}, @var{MI}, @var{MS})
    ## @deftypefnx {Constructor} {@var{obj} =} datetime @
    ##   (@dots{}, @code{'Format'}, @var{Format}, @code{'InputFormat'}, @var{InputFormat}, @
    ##    @code{'Locale'}, @var{InputLocale}, @code{'PivotYear'}, @var{PivotYear}, @
    ##    @code{'TimeZone'}, @var{TimeZone})
    ##
    ## Constructs a new @code{datetime} array based on input values.
    ##
    ## @end deftypefn
    function this = datetime (varargin)
      %DATETIME Construct a new datetime array.
      %
      % datetime ()
      % datetime (datevec)
      % datetime (datestrs)
      % datetime (in, 'ConvertFrom', ConvertFrom)
      % datetime (Y, M, D)
      % datetime (Y, M, D, H, MI, S)
      % datetime (..., 'Format', Format, 'InputFormat', InputFormat, ...
      %    'PivotYear', PivotYear, 'TimeZone', TimeZone)
      %
      % datetime constructs a new datetime array.
      
      % Peel off options
      args = varargin;
      knownOptions = {'Format','InputFormat','Locale','PivotYear','TimeZone'};
      opts = struct;
      while numel (args) >= 3 && isa (args{end-1}, 'char') ...
          && ismember (args{end-1}, knownOptions)
        opts.(args{end-1}) = args{end};
        args(end-1:end) = [];
      endwhile
      
      % Handle inputs
      timeZone = '';
      if isfield (opts, 'TimeZone')
        timeZone = opts.TimeZone;
      endif
      switch numel (args)
        case 0
          dnums = now;
        case 1
          x = args{1};
          if isnumeric (x)
            % Convert date vectors
            dnums = datenum (x);
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
                  dnums = now;
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
              if isfield (opts, 'TimeZone')
                timeZone = opts.TimeZone;
              endif
              if isfield (opts, 'InputFormat')
                dnums = datenum (x, opts.InputFormat);
              else
                dnums = datenum (x);
              endif
              dnums = reshape (dnums, size(x));
            endif
          elseif isstruct (x)
            error ('datetime: struct to datetime conversion has not been spec''ed or implemented yet');
          elseif ismember (class (x), {'java.util.Date', 'java.util.Date[]', 'java.time.TemporalAccessor', ...
                                       'java.time.TemporalAccessor[]'})
            error ('datetime: Java date conversion is not implemented yet. Sorry.');
          else
            error ('datetime: Invalid input type: %s', class (x));
          endif
        case 2
          % Undocumented calling form for Chrono's internal use
          if ~isequal (args{2}, 'Backdoor')
            error ('Invalid number of inputs (excluding options): %d', numel (args));
          endif
          dnums = args{1};
        case 3
          [in1, in2, in3] = args{:};
          if isequal (in2, 'ConvertFrom')
            switch in3
              case 'datenum'
                dnums = double (in1);
              case 'posixtime'
                dnums = datetime.posix2datenum (in1);
                timeZone = 'UTC';
              otherwise
                error ('Unsupported ConvertFrom format: %s', in3);
                % TODO: Implement more formats
            endswitch
          elseif isnumeric (in2)
            [Y, M, D] = varargin{:};
            dnums = datenum (Y, M, D);
          else
            error ('Invalid inputs: 3 non-option inputs, but arg 2 is not numeric');
          endif
        case 4
          error ('Invalid number of inputs: %d', nargin);
        case 5
          error ('Invalid number of inputs: %d', nargin);
        case 6
          [Y, M, D, H, MI, S] = varargin{:};
          dnums = datenum (Y, M, D, H, MI, S);
        case 7
          [Y, M, D, H, MI, S, MS] = varargin{:};
          dnums = datenum (Y, M, D, H, MI, S, MS);
        otherwise
          error ('Invalid number of inputs: %d', nargin);
      endswitch
      
      % Construct
      if ~isempty (timeZone)
        this.TimeZone = timeZone;
        if ~isequal (timeZone, 'UTC')
          dnums = datetime.convertDatenumTimeZone(dnums, timeZone, 'UTC');
        endif
      endif
      this.dnums = dnums;
      if isfield (opts, 'Format')
        this.Format = opts.Format;
      endif
    endfunction
  endmethods
  
  methods (Static)
    ## -*- texinfo -*-
    ## @node datetime.ofDatenum
    ## @deftypefn {Static Method} {@var{obj} =} datetime.ofDatenum (@var{dnums})
    ##
    ## Converts a datenum array to a datetime array.
    ##
    ## Returns an unzoned @code{datetime} array of the same size as the input.
    ##
    ## @end deftypefn
    function out = ofDatenum (dnums)
      out = datetime (dnums, 'ConvertFrom', 'datenum');
    endfunction
    
    ## -*- texinfo -*-
    ## @node datetime.ofDatestruct
    ## @deftypefn {Static Method} {@var{obj} =} datetime.ofDatestruct (@var{dstruct})
    ##
    ## Converts a datestruct to a datetime array.
    ##
    ## A datestruct is a special struct format used by Chrono that has fields 
    ## Year, Month, Day, Hour, Minute, and Second. It is not a standard Octave datatype.
    ##
    ## Returns an unzoned @code{datetime} array.
    ##
    ## @end deftypefn
    function out = ofDatestruct (dstruct)
      dnums = datetime.datestruct2datenum (dstruct);
      out = datetime (dnums, 'ConvertFrom', 'datenum');
    endfunction
    
    function out = datestruct2datenum (dstruct)
      sz = size (dstruct.Year);
      n = numel (dstruct.Year);
      dvec = NaN (n, 6);
      dvec(:,1) = dstruct.Year(:);
      dvec(:,2) = dstruct.Month(:);
      dvec(:,3) = dstruct.Day(:);
      dvec(:,4) = dstruct.Hour(:);
      dvec(:,5) = dstruct.Minute(:);
      dvec(:,6) = dstruct.Second(:);
      out = datenum (dvec);
    endfunction
    
    ## -*- texinfo -*-
    ## @node datetime.NaT
    ## @deftypefn {Static Method} {@var{out} =} datetime.NaT ()
    ## @deftypefnx {Static Method} {@var{out} =} datetime.NaT (@var{sz})
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
    ## @end deftypefn
    function out = NaT ()
      out = datetime (NaN, 'Backdoor');
    endfunction
        
    ## -*- texinfo -*-
    ## @node datetime.posix2datenum
    ## @deftypefn {Static Method} {@var{dnums} =} datetime.posix2datenum (@var{pdates})
    ##
    ## Converts POSIX (Unix) times to datenums
    ##
    ## Pdates (numeric) is an array of POSIX dates. A POSIX date is the number
    ## of seconds since January 1, 1970 UTC, excluding leap seconds. The output
    ## is implicitly in UTC.
    ##
    ## @end deftypefn
    function out = posix2datenum (pdates)
      out = (double (pdates) / (24 * 60 * 60)) + datetime.PosixEpochDatenum;
    endfunction
    
    ## -*- texinfo -*-
    ## @node datetime.datenum2posix
    ## @deftypefn {Static Method} {@var{out} =} datetime.datenum2posix (@var{dnums})
    ##
    ## Converts Octave datenums to Unix dates.
    ##
    ## The input datenums are assumed to be in UTC.
    ##
    ## Returns a double, which may have fractional seconds.
    ##
    ## @end deftypefn
    function out = datenum2posix (dnums)
      out = (dnums - datetime.PosixEpochDatenum) * (24 * 60 * 60);
    endfunction
  endmethods

  methods
        
    ## -*- texinfo -*-
    ## @node datetime.proxyKeys
    ## @deftypefn {Method} {[@var{keysA}, @var{keysB}] =} proxyKeys (@var{a}, @var{b})
    ##
    ## Computes proxy key values for two datetime arrays. Proxy keys are numeric
    ## values whose rows have the same equivalence relationships as the elements of
    ## the inputs.
    ##
    ## This is primarily for Chrono's internal use; users will typically not need to call
    ## it or know how it works.
    ##
    ## Returns two 2-D numeric matrices of size n-by-k, where n is the number of elements
    ## in the corresponding input.
    ##
    ## @end deftypefn
    function [keysA, keysB] = proxyKeys (a, b)
      %PROXYKEYS Proxy key values for sorting and set operations
      keysA = a.dnums(:);
      keysB = b.dnums(:);
    endfunction

    function this = set.TimeZone (this, x)
      if !ischar (x) || ! (isrow (x) || isempty (x))
        error ('TimeZone must be a char row vector; got a %s %s', ...
          size2str (size (x)), class (x));
      endif
      tzdb = octave.chrono.internal.tzinfo.TzDb.instance;
      if ! isempty (x) && ! ismember (x, tzdb.definedZones)
        error ('Undefined TimeZone: %s', x);
      endif
      if isempty (this.TimeZone) && ! isempty (x)
        this.dnums = datetime.convertDatenumTimeZone (this.dnums, x, 'UTC');
      elseif ! isempty (this.TimeZone) && isempty (x)
        this.dnums = datetime.convertDatenumTimeZone (this.dnums, 'UTC', this.TimeZone);
      endif
      this.TimeZone = x;
    endfunction
    
    function this = set.Format (this, x)
      error ('Changing datetime format is currently unimplemented');
    endfunction
    
    function out = get.Year (this)
      s = datestruct (this);
      out = s.Year;
    endfunction
    
    function this = set.Year (this, x)
      s = datestruct (this);
      s.Year(:) = x;
      this.dnums = datetime.datestruct2datenum (s);
    endfunction
      
    function out = get.Month (this)
      s = datestruct (this);
      out = s.Month;
    endfunction
    
    function this = set.Month (this, x)
      s = datestruct (this);
      s.Month(:) = x;
      this.dnums = datetime.datestruct2datenum (s);
    endfunction
      
    function out = get.Day (this)
      s = datestruct (this);
      out = s.Day;
    endfunction
    
    function this = set.Day (this, x)
      s = datestruct (this);
      s.Day(:) = x;
      this.dnums = datetime.datestruct2datenum (s);
    endfunction
      
    function out = get.Hour (this)
      s = datestruct (this);
      out = s.Hour;
    endfunction
    
    function this = set.Hour (this, x)
      s = datestruct (this);
      s.Hour(:) = x;
      this.dnums = datetime.datestruct2datenum (s);
    endfunction
      
    function out = get.Minute (this)
      s = datestruct (this);
      out = s.Minute;
    endfunction
    
    function this = set.Minute (this, x)
      s = datestruct (this);
      s.Minute(:) = x;
      this.dnums = datetime.datestruct2datenum (s);
    endfunction
      
    function out = get.Second (this)
      s = datestruct (this);
      out = s.Second;
    endfunction
    
    function this = set.Second (this, x)
      s = datestruct (this);
      s.Second(:) = x;
      this.dnums = datetime.datestruct2datenum (s);
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
      
    function out = hour (this)
      out = this.Hour;
    endfunction
      
    function out = minute (this)
      out = this.Minute;
    endfunction
      
    function out = second (this)
      out = this.Second;
    endfunction
    
    function out = quarter (this)
      out = ceil (this.Month / 3);
    endfunction
    
    ## -*- texinfo -*-
    ## @node datetime.ymd
    ## @deftypefn {Method} {[@var{y}, @var{m}, @var{d}] =} ymd (@var{obj})
    ##
    ## Get the Year, Month, and Day components of @var{obj}.
    ##
    ## For zoned @code{datetime}s, these will be local times in the associated time zone.
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
    
    ## -*- texinfo -*-
    ## @node datetime.hms
    ## @deftypefn {Method} {[@var{h}, @var{m}, @var{s}] =} hms (@var{obj})
    ##
    ## Get the Hour, Minute, and Second components of a @var{obj}.
    ##
    ## For zoned @code{datetime}s, these will be local times in the associated time zone.
    ##
    ## Returns double arrays the same size as @code{obj}.
    ##
    ## @end deftypefn
    function [h, m, s] = hms (this)
      st = datestruct (this);
      h = st.Hour;
      m = st.Minute;
      s = st.Second;
    endfunction
    
    ## -*- texinfo -*-
    ## @node datetime.ymdhms
    ## @deftypefn {Method} {[@var{y}, @var{m}, @var{d}, @var{h}, @var{mi}, @var{s}] =} ymdhms @
    ##   (@var{obj})
    ##
    ## Get the Year, Month, Day, Hour, Minute, and Second components of a @var{obj}.
    ##
    ## For zoned @code{datetime}s, these will be local times in the associated time zone.
    ##
    ## Returns double arrays the same size as @code{obj}.
    ##
    ## @end deftypefn
    function [y, m, d, h, mi, s] = ymdhms (this)
      %YMDHMS Get the year, month, day, etc components of this.
      %
      % This is an Octave extension.
      ds = datestruct (this);
      y = ds.Year;
      m = ds.Month;
      d = ds.Day;
      h = ds.Hour;
      mi = ds.Minute;
      s = ds.Second;
    endfunction
    
    ## -*- texinfo -*-
    ## @node datetime.timeofday
    ## @deftypefn {Method} {@var{out} =} timeofday (@var{obj})
    ##
    ## Get the time of day (elapsed time since midnight).
    ##
    ## For zoned @code{datetime}s, these will be local times in the associated time zone.
    ##
    ## Returns a @code{duration} array the same size as @code{obj}.
    ##
    ## @end deftypefn
    function out = timeofday (this)
      % Use mod, not rem, so negative dates give correct result
      local_dnums = datetime.convertDatenumTimeZone (this.dnums, 'UTC', this.TimeZone);
      out = duration.ofDays (mod (local_dnums, 1));
    endfunction
    
    ## -*- texinfo -*-
    ## @node datetime.week
    ## @deftypefn {Method} {@var{out} =} week (@var{obj})
    ##
    ## Get the week of the year.
    ##
    ## This method is unimplemented.
    ##
    ## @end deftypefn
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
        if ~isempty (this.TimeZone)
          str = [str ' ' this.TimeZone];
        endif
        fprintf (' %s\n', str);
      else
        txt = octave.chrono.internal.format_dispstr_array (dispstrs (this));
        fprintf ('%s\n', txt);
        if ~isempty (this.TimeZone)
          fprintf ('  %s\n', this.TimeZone);
        endif
      endif
    endfunction
    
    ## -*- texinfo -*-
    ## @node datetime.dispstrs
    ## @deftypefn {Method} {@var{out} =} dispstrs (@var{obj})
    ##
    ## Get display strings for each element of @var{obj}.
    ##
    ## Returns a cellstr the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = dispstrs (this)

      % TODO: Uh oh; TimeZone isn't included in the output here!
      if isempty (this.TimeZone)
        local_dnums = this.dnums;
      else
        local_dnums = datetime.convertDatenumTimeZone (this.dnums, 'UTC', this.TimeZone);
      endif
      out = cell (size (this));
      tfNaN = isnan (local_dnums);
      out(tfNaN) = {'NaT'};
      if any(~tfNaN(:))
        out(~tfNaN) = cellstr (datestr (local_dnums(~tfNaN)));
      endif
    endfunction
    
    ## -*- texinfo -*-
    ## @node datetime.datestr
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
    ## @node datetime.datestrs
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
    ## @node datetime.datestruct
    ## @deftypefn {Method} {@var{out} =} datestruct (@var{obj})
    ##
    ## Converts this to a "datestruct" broken-down time structure.
    ##
    ## A "datestruct" is a format of struct that Chrono came up with. It is a scalar
    ## struct with fields Year, Month, Day, Hour, Minute, and Second, each containing
    ## a double array the same size as the date array it represents.
    ##
    ## The values in the returned broken-down time are those of the local time
    ## in this' defined time zone, if it has one.
    ##
    ## Returns a struct with fields Year, Month, Day, Hour, Minute, and Second.
    ## Each field contains a double array of the same size as this.
    ##
    ## @end deftypefn
    function out = datestruct (this)
      if isempty (this.TimeZone)
        local_dnums = this.dnums;
      else
        local_dnums = datetime.convertDatenumTimeZone (this.dnums, 'UTC', this.TimeZone);
      endif
      dvec = datevec (local_dnums);
      sz = size (this);
      out.Year = reshape (dvec(:,1), sz);
      out.Month = reshape (dvec(:,2), sz);
      out.Day = reshape (dvec(:,3), sz);
      out.Hour = reshape (dvec(:,4), sz);
      out.Minute = reshape (dvec(:,5), sz);
      out.Second = reshape (dvec(:,6), sz);
    endfunction
    
    ## -*- texinfo -*-
    ## @node datetime.posixtime
    ## @deftypefn {Method} {@var{out} =} posixtime (@var{obj})
    ##
    ## Converts this to POSIX time values (seconds since the Unix epoch)
    ##
    ## Converts this to POSIX time values that represent the same time. The
    ## returned values will be doubles that may include fractional second values.
    ## POSIX times are, by definition, in UTC.
    ##
    ## Returns double array of same size as this.
    ##
    ## @end deftypefn
    function out = posixtime (this)
      out = datetime.datenum2posix (this.dnums);
    endfunction
    
    ## -*- texinfo -*-
    ## @node datetime.datenum
    ## @deftypefn {Method} {@var{out} =} datenum (@var{obj})
    ##
    ## Convert this to datenums that represent the same local time
    ##
    ## Returns double array of same size as this.
    ##
    ## @end deftypefn
    function out = datenum (this)
      dnums = this.dnums;
      if !isempty (this.TimeZone) && !isequal (this.TimeZone, 'UTC')
        dnums = datetime.convertDatenumTimeZone (dnums, 'UTC', this.TimeZone);
      endif
      out = dnums;
    endfunction

    ## -*- texinfo -*-
    ## @node datetime.gmtime
    ## @deftypefn {Method} {@var{out} =} gmtime (@var{obj})
    ##
    ## Convert to TM_STRUCT structure in UTC time.
    ##
    ## Converts @var{obj} to a TM_STRUCT style structure array. The result is in
    ## UTC time. If @var{obj} is unzoned, it is assumed to be in UTC time.
    ##
    ## Returns a struct array in TM_STRUCT style.
    ##
    ## @end deftypefn
    function out = gmtime (this)
      if isempty (this)
        tm_struct = gmtime (time ());
        out = reshape (repmat (tm_struct, [0 0]), size (this));
        return
      endif
      posix = posixtime (this);
      out = gmtime (posix(1));
      for i = 2:numel (this)
        out(i) = gmtime (posix(i));
      endfor
      out = reshape (out, size (this));
    endfunction
    
    ## -*- texinfo -*-
    ## @node datetime.localtime
    ## @deftypefn {Method} {@var{out} =} localtime (@var{obj})
    ##
    ## Convert to TM_STRUCT structure in UTC time.
    ##
    ## Converts @var{obj} to a TM_STRUCT style structure array. The result is a
    ## local time in the system default time zone. Note that the system default
    ## time zone is always used, regardless of what TimeZone is set on @var{obj}.
    ##
    ## If @var{obj} is unzoned, it is assumed to be in UTC time.
    ##
    ## Returns a struct array in TM_STRUCT style.
    ##
    ## Example:
    ## @example
    ## dt = datetime;
    ## dt.TimeZone = datetime.SystemTimeZone;
    ## tm_struct = localtime (dt);
    ## @end example
    ##
    ## @end deftypefn
    function out = localtime (this)
      if isempty (this)
        tm_struct = localtime (time ());
        out = reshape (repmat (tm_struct, [0 0]), size (this));
        return
      endif
      posix = posixtime (this);
      out = localtime (posix(1));
      for i = 2:numel (this)
        out(i) = localtime (posix(i));
      endfor
      out = reshape (out, size (this));
    endfunction

    ## -*- texinfo -*-
    ## @node datetime.isnat
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
    ## @node datetime.isnan
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

    ## -*- texinfo -*-
    ## @node datetime.lt
    ## @deftypefn {Method} {@var{out} =} lt (@var{A}, @var{B})
    ##
    ## True if @var{A} is less than @var{B}. This defines the @code{<} operator
    ## for @code{datetime}s.
    ##
    ## Inputs are implicitly converted to @code{datetime} using the one-arg
    ## constructor or conversion method.
    ##
    ## Returns logical array the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = lt (A, B)
      %LT Less than.
      [A, B] = datetime.promote (A, B);
      out = A.dnums < B.dnums;
    endfunction

    ## -*- texinfo -*-
    ## @node datetime.le
    ## @deftypefn {Method} {@var{out} =} le (@var{A}, @var{B})
    ##
    ## True if @var{A} is less than or equal to@var{B}. This defines the @code{<=} operator
    ## for @code{datetime}s.
    ##
    ## Inputs are implicitly converted to @code{datetime} using the one-arg
    ## constructor or conversion method.
    ##
    ## Returns logical array the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = le (A, B)
      %LE Less than or equal.
      [A, B] = datetime.promote (A, B);
      out = A.dnums <= B.dnums;
    endfunction

    ## -*- texinfo -*-
    ## @node datetime.ne
    ## @deftypefn {Method} {@var{out} =} ne (@var{A}, @var{B})
    ##
    ## True if @var{A} is not equal to @var{B}. This defines the @code{!=} operator
    ## for @code{datetime}s.
    ##
    ## Inputs are implicitly converted to @code{datetime} using the one-arg
    ## constructor or conversion method.
    ##
    ## Returns logical array the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = ne (A, B)
      %NE Not equal.
      [A, B] = datetime.promote (A, B);
      out = A.dnums ~= B.dnums;
    endfunction

    ## -*- texinfo -*-
    ## @node datetime.eq
    ## @deftypefn {Method} {@var{out} =} eq (@var{A}, @var{B})
    ##
    ## True if @var{A} is equal to @var{B}. This defines the @code{==} operator
    ## for @code{datetime}s.
    ##
    ## Inputs are implicitly converted to @code{datetime} using the one-arg
    ## constructor or conversion method.
    ##
    ## Returns logical array the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = eq (A, B)
      %EQ Equals.
      [A, B] = datetime.promote (A, B);
      out = A.dnums == B.dnums;
    endfunction

    ## -*- texinfo -*-
    ## @node datetime.ge
    ## @deftypefn {Method} {@var{out} =} ge (@var{A}, @var{B})
    ##
    ## True if @var{A} is greater than or equal to @var{B}. This defines the @code{>=} operator
    ## for @code{datetime}s.
    ##
    ## Inputs are implicitly converted to @code{datetime} using the one-arg
    ## constructor or conversion method.
    ##
    ## Returns logical array the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = ge (A, B)
      %GE Greater than or equal.
      [A, B] = datetime.promote (A, B);
      out = A.dnums >= B.dnums;
    endfunction

    ## -*- texinfo -*-
    ## @node datetime.gt
    ## @deftypefn {Method} {@var{out} =} gt (@var{A}, @var{B})
    ##
    ## True if @var{A} is greater than @var{B}. This defines the @code{>} operator
    ## for @code{datetime}s.
    ##
    ## Inputs are implicitly converted to @code{datetime} using the one-arg
    ## constructor or conversion method.
    ##
    ## Returns logical array the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = gt (A, B)
      %GT Greater than.
      [A, B] = datetime.promote (A, B);
      out = A.dnums > B.dnums;
    endfunction

    % Arithmetic
    
    ## -*- texinfo -*-
    ## @node datetime.plus
    ## @deftypefn {Method} {@var{out} =} plus (@var{A}, @var{B})
    ##
    ## Addition (@code{+} operator). Adds a @code{duration}, @code{calendarDuration},
    ## or numeric @var{B} to a @code{datetime} @var{A}.
    ##
    ## @var{A} must be a @code{datetime}.
    ##
    ## Numeric @var{B} inputs are implicitly converted to @code{duration} using
    ## @code{duration.ofDays}.
    ##
    ## Returns @code{datetime} array the same size as @var{A}.
    ##
    ## @end deftypefn
    function out = plus (A, B)
      %PLUS Addition.

      % TODO: Maybe support `duration/calendarDuration + datetime` form by just swapping the
      % arguments.
      if ~isa (A, 'datetime')
        error ('datetime.plus: Expected left-hand side of A + B to be a datetime; got a %s', ...
          class (A));
      endif
      if isa (B, 'duration')
        out = A;
        out.dnums = A.dnums + B.days;
      elseif isa (B, 'calendarDuration')
        [A, B] = octave.chrono.internal.scalarexpand (A, B);
        out = A;
        for i = 1:numel (A)
          out = asgn(out, i, plusScalarCalendarDuration (subset(A, i), B(i)));
        endfor
      elseif isnumeric (B)
        out = A + duration.ofDays (B);
      else
        error ('datetime.plus: Invalid input type: %s', class (B));
      endif
    endfunction

    function out = plusScalarCalendarDuration (this, dur)
      ds = datestruct (this);
      out = this;
      if dur.Sign < 0
        ds.Year = ds.Year - dur.Years;
        ds.Month = ds.Month - dur.Months;
        ds.Day = ds.Day - dur.Days;
        tmp = datetime.ofDatestruct (ds);
        tmp.dnums = tmp.dnums - dur.Time;
        out.dnums = tmp.dnums;
      else
        ds.Year = ds.Year + dur.Years;
        ds.Month = ds.Month + dur.Months;
        ds.Day = ds.Day + dur.Days;
        tmp = datetime.ofDatestruct (ds);
        tmp.dnums = tmp.dnums + dur.Time;
        out.dnums = tmp.dnums;
      endif
    endfunction
    
    ## -*- texinfo -*-
    ## @node datetime.minus
    ## @deftypefn {Method} {@var{out} =} minus (@var{A}, @var{B})
    ##
    ## Subtraction (@code{-} operator). Subtracts a @code{duration}, 
    ## @code{calendarDuration} or numeric @var{B} from a @code{datetime} @var{A},
    ## or subtracts two @code{datetime}s from each other.
    ##
    ## If both inputs are @code{datetime}, then the output is a @code{duration}.
    ## Otherwise, the output is a @code{datetime}.
    ##
    ## Numeric @var{B} inputs are implicitly converted to @code{duration} using
    ## @code{duration.ofDays}.
    ##
    ## Returns an array the same size as @var{A}.
    ##
    ## @end deftypefn
    function out = minus (A, B)
      %MINUS Subtraction.
      if isa (A, 'datetime') && isa (B, 'datetime')
        [A, B] = datetime.promote(A, B);
        out = duration.ofDays (A.dnums - B.dnums);
      else
        out = A + -B;
      endif
    endfunction
    
    ## -*- texinfo -*-
    ## @node datetime.diff
    ## @deftypefn {Method} {@var{out} =} diff (@var{obj})
    ##
    ## Differences between elements.
    ##
    ## Computes the difference between each successive element in @var{obj}, as a
    ## @code{duration}.
    ##
    ## Returns a @code{duration} array the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = diff (this)
      %DIFF Differences between elements
      out = duration.ofDays (diff (this.dnums));
    endfunction
    
    ## -*- texinfo -*-
    ## @node datetime.isbetween
    ## @deftypefn {Method} {@var{out} =} isbetween (@var{obj}, @var{lower}, @var{upper})
    ##
    ## Tests whether the elements of @var{obj} are between @var{lower} and
    ## @var{upper}.
    ##
    ## All inputs are implicitly converted to @code{datetime} arrays, and are subject
    ## to scalar expansion.
    ##
    ## Returns a logical array the same size as the scalar expansion of the inputs.
    ##
    ## @end deftypefn
    function out = isbetween (this, lower, upper)
      %ISBETWEEN Whether elements are within a time interval
      [this, lower, upper] = datetime.promote (this, lower, upper);
      out = lower.dnums <= this.dnums && this.dnums <= upper.dnums;
    endfunction
    
    function out = colon (this, varargin)
      narginchk (2, 3);
      switch nargin
        case 2
          limit = varargin{1};
          increment = 1;
        case 3
          increment = varargin{1};
          limit = varargin{2};
      endswitch
      if isnumeric (increment)
        increment = duration.ofDays (increment);
      endif
      if ~isa (increment, 'duration')
        error ('increment must be a duration object');
      endif
      if ~isscalar (this) || ~isscalar (limit)
        error ('base and limit must both be scalar');
      endif
      out = this;
      out.dnums = this.dnums:increment.days:limit.dnums;
    endfunction
    
    ## -*- texinfo -*-
    ## @node datetime.linspace
    ## @deftypefn {Method} {@var{out} =} linspace (@var{from}, @var{to}, @var{n})
    ##
    ## Linearly-spaced values in date/time space.
    ##
    ## Constructs a vector of @code{datetime}s that represent linearly spaced points
    ## starting at @var{from} and going up to @var{to}, with @var{n} points in the
    ## vector.
    ##
    ## @var{from} and @var{to} are implicitly converted to @code{datetime}s.
    ##
    ## @var{n} is how many points to use. If omitted, defaults to 100.
    ##
    ## Returns an @var{n}-long @code{datetime} vector.
    ##
    ## @end deftypefn
    function out = linspace (from, to, n)
      %LINSPACE Linearly-spaced values
      narginchk (2, 3);
      if nargin < 3; n = 100; endif
      if isnumeric (from)
        from = datetime.ofDatenum (from);
      endif
      [from, to] = datetime.promote (from, to);
      if ~isscalar (from) || ~isscalar (to)
        error ('Inputs must be scalar');
      endif
      out = from;
      out.dnums = linspace (from.dnums, to.dnums, n);
    endfunction
  endmethods

  % Planar boilerplate stuff
  
  methods

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
      args = datetime.promotec (varargin);
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
      if ~isa (a, 'datetime')
        a = datetime (a);
      endif
      if ~isa (b, 'datetime')
        b = datetime (b);
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
      if ~isa (rhs, 'datetime')
        rhs = datetime (rhs);
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

    ## -*- texinfo -*-
    ## @node datetime.convertDatenumTimeZone
    ## @deftypefn {Static Method} {@var{out} =} datetime.convertDatenumTimeZone @
    ##  (@var{dnum}, @var{fromZoneId}, @var{toZoneId})
    ##
    ## Convert a datenum from one time zone to another.
    ##
    ## @var{dnum} is a datenum array to convert.
    ##
    ## @var{fromZoneId} is a charvec containing the IANA Time Zone identifier for
    ## the time zone to convert from.
    ##
    ## @var{toZoneId} is a charvec containing the IANA Time Zone identifier for
    ## the time zone to convert to.
    ##
    ## Returns a datenum array the same size as @var{dnum}.
    ##
    ## @end deftypefn
    function out = convertDatenumTimeZone (dnum, fromZoneId, toZoneId)
      %CONVERTDATENUMTIMEZONE Convert time zone on datenums
      narginchk (3, 3);
      tzdb = octave.chrono.internal.tzinfo.TzDb;
      fromZone = tzdb.zoneDefinition (fromZoneId);
      toZone = tzdb.zoneDefinition (toZoneId);
      dnumUtc = fromZone.localtimeToGmt (dnum);
      out = toZone.gmtToLocaltime (dnumUtc);
    endfunction
    
    function out = promotec (args)
      %PROMOTEC Promote inputs to be compatible, cell version
      out = cell(size(args));
      [out{:}] = promote(args{:});
    endfunction

    function varargout = promote (varargin)
      %PROMOTE Promote inputs to be compatible
      args = varargin;
      for i = 1:numel (args)
        if ~isa (args{i}, 'datetime')
          args{i} = datetime (args{i});
        endif
      endfor
      tz0 = args{1}.TimeZone;
      for i = 2:numel (args)
        if ~isequal (args{i}.TimeZone, tz0)
          if isempty (tz0) || isempty (args{i}.TimeZone)
            error('Cannot mix zoned and zoneless datetimes.');
          else
            args{i}.TimeZone = tz0;
          endif
        endif
      endfor
      varargout = args;
    endfunction

  endmethods

endclassdef

%!test datetime;
%!test datetime ('2011-03-07');
%!test datetime ('2011-03-07 12:34:56', 'TimeZone','America/New_York');
%!test
%!  d = datetime;
%!  d.TimeZone = 'America/New_York';
%!  d2 = d;
%!  d2.TimeZone = 'America/Chicago';
%!  assert (abs(d.dnums - d2.dnums), (1/24), .0001)
