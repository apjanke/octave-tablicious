classdef PosixZoneRule
  %POSIXZONERULE A POSIX-style time zone rule
  
  properties
    local_timezone
    std_name
    dst_name
    gmt_offset_hours
    dst_start_rule
    dst_end_rule
  endproperties
  
  methods (Static)
    function out = parseZoneRule (str)
      out = octave.chrono.internal.algo.PosixZoneRule;
      if ~isrow (in)
        error ('in must be charvec; got non-row char');
      endif
      els = strsplit (in, ',');
      if numel (els ~= 3)
        error ('Invalid POSIX time zone rule specification: ''%s''', in);
      endif
      out.local_timezone = els{1};
      out.dst_start_rule = els{2};
      out.dst_end_rule = els{3};
      tok = regexp (out.local_timezone, '^([A-Za-z]+)(\d+)([A-Za-z]+)$', 'tokens');
      tok = tok{1};
      if numel (tok) ~= 3
        error ('Failed parsing POSIX zone name: ''%s''', out.local_timezone);
      endif
      out.std_name = tok{1};
      out.gmt_offset_hours = str2double(tok{2});
      out.dst_name = tok{3};
    endfunction
  endmethods

  methods
    function this = PosixZoneRule(in)
      if nargin == 0
        return
      endif
      if ischar (in)
        this = octave.chrono.internal.tzinfo.PosixZoneRule.parseZoneRule(in);
      endif
    endfunction
    
    function out = gmtToLocalDatenum (this, dnums)
      error ('Unimplemented');
    endfunction
    
    function out = localToGmtDatenum (this, dnums, isDst)
      error ('Unimplemented');
    endfunction
  endmethods
endclassdef
