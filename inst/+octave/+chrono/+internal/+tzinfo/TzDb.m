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

classdef TzDb
  %TZDB Interface to the tzinfo database
  %
  % This class is an interface to the tzinfo database (AKA the Olson database)
  
  properties
    % Path to the zoneinfo directory
    path
  endproperties
  
  methods (Static)
    function out = instance ()
      %INSTANCE Shared global instance of TzDb
      persistent value
      if isempty (value)
        value = octave.chrono.internal.tzinfo.TzDb;
      endif
      out = value;
    endfunction
  endmethods

  methods
    function this = TzDb (path)
      %TZDB Construct a new TzDb object
      %
      % this = TzDb (path)
      %
      % path (char) is the path to the tzinfo database directory. If omitted or
      % empty, it defaults to the default path ('/usr/share/zoneinfo' on Unix,
      % and an error on Windows).
      if nargin < 1;  path = [];  endif
      if isempty (path)
        this.path = octave.chrono.internal.tzinfo.TzDb.defaultPath;
      else
        this.path = path;
      endif
    endfunction
    
    function out = dbVersion (this)
      %DBVERSION Version of the zoneinfo database this is reading
      %
      % out = dbVersion (this)
      %
      % Returns the zoneinfo database version as a string.
      versionFile = [this.path '/+VERSION'];
      txt = octave.chrono.internal.slurpTextFile (versionFile);
      out = strtrim (txt);
    endfunction
        
    function out = zoneTab (this)
      %ZONETAB Get the zone definition table
      %
      % This lists the metadata from the "zone.tab" file included in the
      % zoneinfo database.
      %
      % Returns a struct with fields:
      %   CountryCode
      %   Coordinates
      %   TZ
      %   Comments
      % Each of which contains a cellstr column vector.
      persistent data
      if isempty (data)
        data = this.readZoneTab;
      endif
      out = data;
    endfunction
    
    function out = definedZones (this)
      %DEFINEDZONES List defined zone IDs
      %
      % out = definedZones (this)
      persistent value
      if isempty (value)
        specialFiles = {'+VERSION', 'iso3166.tab', 'zone.tab', 'posixrules'};
        files = octave.chrono.internal.findFiles (this.path);
        if ispc
          files = strrep(files, '\', '/');
        endif
        value = setdiff (files', specialFiles);
      endif
      out = value;
    endfunction
    
    function out = zoneDefinition (this, zoneId)
      %ZONEDEFINITION Get the time zone definition for a given time zone
      %
      % out = zoneDefinition (this, zoneId)
      %
      % zoneId (char) is the time zone identifier in IANA format. For example,
      % 'UTC' or 'America/New_York'.
      %
      % Returns the zone definition as an object. (This is currently under
      % construction; it now returns a placeholder struct.)
      s = this.readZoneFile (zoneId);

      % We prefer the version 2 stuff
      out = octave.chrono.internal.tzinfo.TzInfo;
      if isfield (s, 'section2')
        defn_s = s.section2;
        defn_s.goingForwardPosixZone = s.goingForwardPosixZone;
      else
        defn_s = s.section1;
      endif
      defn_s.zoneId = zoneId;
      out = octave.chrono.internal.tzinfo.TzInfo (defn_s);
      out = calculateDerivedData (out);
    endfunction
  endmethods
  
  methods (Access = private)
    function out = readZoneTab (this)
      %READZONETAB Actually read and parse the zonetab file
      
      % Use the "deprecated" plain zone.tab because zone1970.tab is not present
      % on all systems.
      zoneTabFile = [this.path '/zone.tab'];
      
      txt = octave.chrono.internal.slurpTextFile (zoneTabFile);
      lines = strsplit (txt, sprintf('\n'));
      starts = regexp (lines, '^\s*#|^\s*$', 'start', 'once');
      tfComment = ~cellfun ('isempty', starts);
      lines(tfComment) = [];
      tfBlank = cellfun ('isempty', lines);
      lines(tfBlank) = [];
      pattern = '^(\w+)\s+(\S+)\s+(\S+)\s*(.*)';
      [match,tok] = regexp (lines, pattern, 'match', 'tokens');
      tfMatch = ~cellfun ('isempty', match);
      if ~all (tfMatch)
        ixBad = find (~tfMatch);
        error ('Failed parsing line in zone.tab file: "%s"', lines{ixBad(1)});
      endif
      tok = cat (1, tok{:});
      tok = cat (1, tok{:});
      
      out = struct;
      out.CountryCode = tok(:,1);
      out.Coordinates = tok(:,2);
      out.TZ = tok(:,3);
      out.Comments = tok(:,4);
    endfunction
    
    function out = readZoneFile (this, zoneId)
      %READZONEFILE Read and parse a zone definition file
      if ~ismember (zoneId, this.definedZones)
        error ("Undefined time zone: '%s'", zoneId);
      endif
      zoneFile = [this.path '/' zoneId];
      if ~exist (zoneFile)
        error (["tzinfo time zone file for zone %s does not exist: %s\n" ...
          "This is probably an error in the tzinfo database files."], ...
            zoneId, zoneFile);
      endif
      data = octave.chrono.internal.slurpBinaryFile (zoneFile);
      
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

  methods (Static)
    function out = defaultPath ()
      if ispc
        % Use the zoneinfo database bundled with Chrono, because Windows doesn't
        % supply one.
        this_dir = fileparts (mfilename ('fullpath'));
        out = fullfile (this_dir, 'resources', 'zoneinfo');
      else
        out = '/usr/share/zoneinfo';
      endif
    endfunction
  endmethods
endclassdef

