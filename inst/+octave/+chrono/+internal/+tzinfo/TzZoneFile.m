## Copyright (C) 2020 Andrew Janke <floss@apjanke.net>
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
## @deftp {Class} TzZoneFile
##
## This class knows how to read the zone files in the tzinfo database.
## A single object is attached to a single zone file. You must supply
## the path to the zone file; it does not know about the tzdb layout;
## that is handled by the TzDb class.
##
## @end deftp

classdef TzZoneFile

  properties (SetAccess = private)
    % Path to the zone file
    file
  endproperties

  methods

    function this = TzZoneFile (file)
      if nargin == 0
        return
      endif
      if ~isfile(file)
        error('octave:chrono:NoSuchFile', ...
          'Cannot read TZ zone file: no such file: %s', file);
      endif
      this.file = file;
    endfunction

    function out = readZoneFile (this)
      %READZONEFILE Read and parse a zone definition file

      if ~exist (this.file)
        % This shouldn't happen unless the file has been moved on disk since
        % object construction.
        error('No such file: %s', this.file);
      endif
      data = octave.chrono.internal.slurpBinaryFile (this.file);
      
      % Parse tzinfo format file
      ix = 1;
      section_data = data(ix:end);
      [section1, n_bytes_read] = this.parseZoneSection (section_data, 1);
      out.section1 = section1;
      
      % Version 2 stuff
      if ismember (section1.header.format_id, {'2','3'})
        % A whole nother header/data, except using 8-byte transition/leap times
        ix = ix + n_bytes_read;
        % Scan for the magic cookie to double-check our parsing.
        magic_ixs = strfind (char (data(ix:end)), 'TZif');
        if isempty (magic_ixs)
          % No second section found
        else
          % Advance to where we found the magic cookie
          if magic_ixs(1) ~= 1
            warning (['Unexpected extra data at end of section in tzinfo file for %s.\n' ...
              'Possible bug in chrono''s parsing code.'], zoneId);
          endif
          ix = ix + magic_ixs(1) - 1;
          section_data = data(ix:end);
          [out.section2, n_bytes_read_2] = this.parseZoneSection (section_data, 2);
          ix = ix + n_bytes_read_2;
          % And then there's the going-forward zone at the end.
          % The first LF should be the very next byte.
          data_left = data(ix:end);
          ixLF = find (data_left == uint8 (sprintf ('\n')));
          if numel (ixLF) >= 2
            out.goingForwardPosixZone = char (data_left(ixLF(1)+1:ixLF(2)-1));
          endif
        endif
      endif
    endfunction
    
    function [out, n_bytes_read] = parseZoneSection(this, data, sectionFormat)
      parser = octave.chrono.internal.tzinfo.ZoneFileSectionParser;
      parser.data = data;
      parser.sectionFormat = sectionFormat;
      [out, n_bytes_read] = parser.parseZoneSection;
    endfunction

  endmethods

endclassdef