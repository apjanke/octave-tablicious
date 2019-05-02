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

classdef TzInfo
  %TZINFO Zone definition for a single time zone
  
  properties (Constant)
    utcZoneAliases = {'Etc/GMT' 'Etc/GMT+0' 'Etc/GMT-0' 'Etc/Greenwich' ...
      'Etc/UCT' 'Etc/UTC' 'Etc/Universal' 'GMT' 'GMT+0' 'GMT-0' 'GMT0' ...
      'Greenwich' 'UCT' 'UTC' 'Universal' 'Zulu'};
  endproperties
  
  properties
    id
    formatId
    % These fields are all parallel
    transitions
    transitionsLocal
    transitionsDatenum
    transitionsLocalDatenum
    timeTypes  % index into ttinfos.*(ix), 1-indexed
    % struct <gmtoff, isdst, abbrind, abbr, gmtoffDatenum>
    ttinfos
    leapTimes
    leapSecondTotals
    isStd
    isGmt
    goingForwardPosixZone
  endproperties
  
  methods
    function this = TzInfo(in)
      if nargin == 0
        return;
      end
      if isstruct (in)
        % Convert from TzDb's tzinfo struct
        s = in;
        this.id = s.zoneId;
        this.formatId = s.header.format_id;
        this.transitions = s.transitions;
        this.timeTypes = s.time_types + 1; % Convert C 0-indexing to octave 1-indexing
        this.ttinfos = s.ttinfos;
        this.leapTimes = s.leap_times;
        this.leapSecondTotals = s.leap_second_totals;
        this.isStd = s.is_std;
        this.isGmt = s.is_gmt;
        if isfield (s, 'goingForwardPosixZone')
          this.goingForwardPosixZone = s.goingForwardPosixZone;
          %this.goingForwardPosixZoneRule = octave.chrono.internal.tzinfo.PosixZoneRule(...
          %  this.goingForwardPosixZone);
        endif
        this = calculateDerivedData (this);
      else
        error ('Invalid input type: %s', class (in));
      endif
    endfunction
    
    function this = calculateDerivedData (this)
      %CALCULATEDERIVEDDATA Calculate this' derived data fields.
      this.ttinfos.gmtoff = double (this.ttinfos.gmtoff);
      this.ttinfos.gmtoffDatenum = octave.chrono.internal.tzinfo.TzInfo.secondsToDatenum (this.ttinfos.gmtoff);
      gmtoffsAtTransitions = this.ttinfos.gmtoff(this.timeTypes);
      this.transitionsLocal = this.transitions + gmtoffsAtTransitions;
      this.transitionsDatenum = datetime.posix2datenum (this.transitions);
      this.transitionsLocalDatenum = datetime.posix2datenum (this.transitionsLocal);
    endfunction
    
    % Display
    
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
        fprintf ('Empty %s %s\n', octave.chrono.internal.size2str (size (this)), class (this));
      elseif isscalar (this)
        fprintf ('TzInfo: %s\n', this.id);
        displayCommonInfo (this);
      else
        fprintf ('%s: %s\n', class (this), octave.chrono.internal.size2str (size (this)));
      endif
    endfunction
    
    function prettyprint (this)
      %PRETTYPRINT Display this' data in human-readable format.
      if ~isscalar (this)
        fprintf ('%s: %s\n', class (this), octave.chrono.internal.size2str (size (this)));
        return;
      endif
      fprintf ('TzInfo: %s\n', this.id);
      displayCommonInfo (this);
      fprintf ('transitions:\n');
      for i = 1:numel (this.transitions)
        dnum = datetime.posix2datenum (this.transitions(i));
        abbr = this.ttinfos.abbr{this.timeTypes(i)};
        fprintf ('  %d  %s  %d  => %s\n', this.transitions(i), datestr (dnum), ...
          this.timeTypes(i), abbr);
      endfor
      fprintf ('ttinfos:\n');
      fprintf ('  %12s %10s %5s %8s %-8s\n', 'gmtoff', 'gmtoffdn', 'isdst', 'abbrind', 'abbr');
      tti = this.ttinfos;
      for i = 1:numel (this.ttinfos.gmtoff)
        gmtoffDur = duration.ofDays (octave.chrono.internal.tzinfo.TzInfo.secondsToDatenum (this.ttinfos.gmtoff(i)));
        fprintf ('  %12d %10s %5d %8d %-8s\n', ...
          tti.gmtoff(i), char (gmtoffDur), tti.isdst(i), tti.abbrind(i), tti.abbr{i});
      endfor
      fprintf ('leap times:\n');
      if isempty (this.leapTimes)
        fprintf ('  <none>\n');
      else
        fprintf ('  %12s  %20s\n', 'time', 'leap seconds');
        for i = 1:numel (this.leapTimes)
          fprintf ('  %12d  %20d\n', this.leapTimes(i), this.leapSecondsTotal(i));
        endfor 
      endif
      fprintf ('is_std:\n');
      function out = num2cellstr (x)
        out = reshape (strtrim (cellstr (num2str (x(:)))), size (x));
      endfunction
      fprintf ('  %s\n', strjoin (num2cellstr (this.isStd), '  '));
      fprintf ('is_gmt:\n');
      fprintf ('  %s\n', strjoin (num2cellstr (this.isGmt), '  '));
      if ~isempty (this.goingForwardPosixZone)
        fprintf ('posix_zone:\n');
        fprintf ('  %s\n', this.goingForwardPosixZone);
      endif
    endfunction

    function out = localtimeToGmt (this, dnum)
      if ismember (this.id, octave.chrono.internal.tzinfo.TzInfo.utcZoneAliases)
        % Have to special-case this because it relies on POSIX zone rules, which
        % are not implemented yet
        offsets = zeros (size (dnum));
      else
        % The time zone record is identified by finding the last record whose start
        % time is less than or equal to the local time.
        % This is a slow implementation. Once proved correct, this should be
        % replaced by an oct-file that does a modified binary search to find
        % the right transition point. (It has to be a *modified* bin search
        % because the local times for transitions are not necessarily monotonic increasing.
        % I think.)
        tf = false (size (dnum));
        loc = NaN (size (dnum));
        for i_dnum = 1:numel(dnum)
          d = dnum(i_dnum);
          ix = find(this.transitionsLocalDatenum <= d, 1, "last");
          if ~isempty(ix)
            tf(i_dnum) = true;
            loc(i_dnum) = ix;
          endif
        endfor
        %[tf,loc] = octave.chrono.internal.algo.binsearch (dnum, this.transitionsLocalDatenum);
        ix = loc;
        tfOutOfRange = isnan(ix) | ix == numel (this.transitions);
        % In-range dates take their period's gmt offset
        offsets = NaN (size (dnum));
        offsets(~tfOutOfRange) = this.ttinfos.gmtoffDatenum(this.timeTypes(ix(~tfOutOfRange)));
        % Out-of-range dates are handled by the POSIX look-ahead zone
        if any (tfOutOfRange(:))
          % TODO: Implement this
          error ('POSIX zone rules are unimplemented');
        endif
      endif
      out = dnum - offsets;
    endfunction
    
    function out = gmtToLocaltime (this, dnum)
      if ismember(this.id, octave.chrono.internal.tzinfo.TzInfo.utcZoneAliases)
        % Have to special-case this because it relies on POSIX zone rules, which
        % are not implemented yet
        offsets = zeros( size (dnum));
      else
        [tf,loc] = octave.chrono.internal.algo.binsearch (dnum, this.transitionsDatenum);
        ix = loc;
        ix(~tf) = (-loc(~tf)) - 1; % ix is now index of the transition each dnum is after
        tfOutOfRange = ix == 0 | ix == numel(this.transitions);
        % In-range dates take their period's gmt offset
        offsets = NaN (size (dnum));
        offsets(~tfOutOfRange) = this.ttinfos.gmtoffDatenum(this.timeTypes(ix(~tfOutOfRange)));
        % Out-of-range dates are handled by the POSIX look-ehead zone
        if any (tfOutOfRange(:))
          % TODO: Implement this
          error ('POSIX zone rules are unimplemented');
        endif
      endif
      out = dnum + offsets;
    endfunction
    
  end
  
  methods (Access = private)
    function displayCommonInfo (this)
      %DISPLAYCOMMONINFO Info common to disp() and prettyprint()
      formatId = this.formatId;
      if formatId == 0
        formatId = '1';
      endif
      if ismember (this.formatId, {'2','3'})
        time_size = '64-bit';
      else
        time_size = '32-bit';
      endif
      fprintf ('  Version %s (%s time values)\n', this.formatId, time_size);
      fprintf ('  %d transitions, %d ttinfos, %d leap times\n', ...
        numel (this.transitions), numel (this.ttinfos.gmtoff), numel (this.leapTimes));
      fprintf ('  %d is_stds, %d is_gmts\n', ...
        numel (this.isStd), numel (this.isGmt));
      if ~isempty (this.goingForwardPosixZone)
        fprintf ('  Forward-looking POSIX zone: %s\n', this.goingForwardPosixZone);
      endif
    endfunction
  endmethods
  
  methods (Static)
    function out = secondsToDatenum (secs)
      out = double (secs) / (60 * 60 * 24);
    endfunction
  endmethods
endclassdef

