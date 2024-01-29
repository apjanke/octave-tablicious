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

## This class exists for Octave 4.2 compatibility: something about having a 
## method with nested closures (my old implementation approach) is causing it
## to break, with an undefined function input even though one was supplied
## by the caller.
classdef ZoneFileSectionParser < handle

  properties
    sectionFormat
    data
    ix = 1 % A "cursor" index into data
  endproperties
  
  methods
    function out = take_byte (this, n)
      if nargin < 2; n = 1; end
      n = double (n);
      out = this.data(this.ix:this.ix + n - 1);
      this.ix = this.ix + n;
    endfunction

    function out = take_int (this, n)
      if nargin < 2; n = 1; end
      n = double (n);
      out = this.get_int (this.data(this.ix:this.ix + (4*n) - 1));
      this.ix = this.ix + 4*n;
    endfunction

    function out = take_int64 (this, n)
      if nargin < 2; n = 1; end
      n = double (n);
      out = this.get_int64 (this.data(this.ix:this.ix+(8*n)-1));
      this.ix = this.ix + 8*n;
    endfunction

    function out = take_timeval (this, n)
      if this.sectionFormat == 1
        out = this.take_int (n);
      else
        out = this.take_int64 (n);
      endif
    endfunction

    function out = get_int (this, my_bytes)
      out = swapbytes (typecast (my_bytes, 'int32'));
    endfunction

    function out = get_int64 (this, my_bytes)
      out = swapbytes (typecast (my_bytes, 'int64'));
    endfunction

    function out = get_null_terminated_string (this, my_bytes)
      my_ix = 1;
      while my_bytes(my_ix) ~= 0
        my_ix = my_ix + 1;
      end
      out = char (my_bytes(1:my_ix - 1));
    endfunction

    function [out, nBytesRead] = parseZoneSection (this)
      %PARSEZONESECTION Parse one section of a tzinfo file
      
      % "get" functions read/convert data; "take" functions read/convert and
      % advance the cursor

      % Header
      h.magic = this.take_byte (4);
      h.magic_char = char (h.magic);
      format_id_byte = this.take_byte;
      h.format_id = char (format_id_byte);
      h.reserved = this.data(this.ix:this.ix+15-1);
      this.ix = this.ix + 15;
      h.counts_vals = this.take_int (6);
      counts_vals = h.counts_vals;
      h.n_ttisgmt = counts_vals(1);
      h.n_ttisstd = counts_vals(2);
      h.n_leap = counts_vals(3);
      h.n_time = counts_vals(4);
      h.n_type = counts_vals(5);
      h.n_char = counts_vals(6);
      
      % Body
      transitions = this.take_timeval (h.n_time);
      time_types = this.take_byte (h.n_time);
      ttinfos = struct ('gmtoff', int32 ([]), 'isdst', uint8 ([]), 'abbrind', uint8 ([]));
      function out = take_ttinfo ()
        ttinfos.gmtoff(end+1) = this.take_int;
        ttinfos.isdst(end+1) = this.take_byte;
        ttinfos.abbrind(end+1) = this.take_byte;
      endfunction
      for i = 1:h.n_type
        take_ttinfo;
      endfor
      % It's not clearly documented, but following the ttinfo section are a
      % series of null-terminated strings which hold the abbreviations. There's 
      % no length indicator for them, so we have to scan for the null after the 
      % last string.
      abbrs = {};
      if ~isempty (ttinfos.abbrind)
        last_abbrind = max (ttinfos.abbrind);
        ix_end = this.ix + double (last_abbrind);
        while this.data(ix_end) ~= 0
          ix_end = ix_end + 1;
        endwhile
        abbr_section = this.data(this.ix:ix_end);
        for i = 1:numel (ttinfos.abbrind)
          section_bytes_left = abbr_section(ttinfos.abbrind(i)+1:end);
          abbrs{i} = this.get_null_terminated_string (section_bytes_left);
        endfor
        this.ix = ix_end + 1;
      endif
      ttinfos.abbr = abbrs;
      if this.sectionFormat == 1
        leap_times = repmat (uint32 (0), [h.n_leap 1]);
      else
        leap_times = repmat (uint64 (0), [h.n_leap 1]);
      endif
      leap_second_totals = repmat (uint32 (0), [h.n_leap 1]);
      for i = 1:h.n_leap
        leap_times(i) = this.take_timeval (1);
        leap_second_totals(i) = this.take_int (1);
      endfor
      is_std = this.take_byte (h.n_ttisstd);
      is_gmt = this.take_byte (h.n_ttisgmt);

      out.header = h;
      out.transitions = transitions;
      out.time_types = time_types;
      out.ttinfos = ttinfos;
      out.leap_times = leap_times;
      out.leap_second_totals = leap_second_totals;
      out.is_std = is_std;
      out.is_gmt = is_gmt;
      nBytesRead = this.ix - 1;
    endfunction
  endmethods

endclassdef