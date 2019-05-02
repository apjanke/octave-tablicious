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

classdef WindowsIanaZoneConverter
  %WINDOWSIANAZONECONVERTER Converts between Windows and IANA zone ids
  
  methods
    function out = windows2iana (this, winZoneId)
      map = getZoneMap (this);
      ix = find (strcmp (winZoneId, map.Windows));
      if isempty (ix)
        error ('Unrecognized Windows time zone ID: ''%s''', winZoneId);
      endif
      territories = map.Territory(ix);
      ianas = map.Iana(ix);
      if isscalar (ix)
        out = ianas{1};
      else
        [tf,loc] = ismember ('001', territories);
        if ~tf
          out = ianas{1};
          warning (['No "001" territory found for Windows time zone ''%s'' in map file. ' ...
            'Guessing IANA zone randomly as ''%s''.'], ...
            winZoneId, out);
        else
          out = ianas{loc};
        endif
      endif
    endfunction
    
    function out = iana2windows (this, ianaZoneId)
      map = getZoneMap (this);
      [tf,loc] = ismember (ianaZoneId, map.Iana);
      if ~tf
        error ('Unrecognized IANA time zone ID: ''%s''', ianaZoneId);
      endif
      out = map.Windows{loc};
    endfunction

    function out = getZoneMap (this)
      persistent cache
      if isempty (cache)
        cache = readWindowsZonesFile (this);
      endif
      out = cache;
    endfunction
    
    function out = readWindowsZonesFile (this)
      this_dir = fileparts (mfilename ('fullpath'));
      zones_file = fullfile (this_dir, 'resources', 'windowsZones', 'windowsZones.xml');
      txt = octave.chrono.internal.slurpTextFile (zones_file);
      % Base Octave doesn't have XML reading, so we'll kludge it with regexps
      pattern = '<mapZone +other="([^"]*)" +territory="([^"]*)" type="([^"]*)" */>';
      [starts,tok] = regexp (txt, pattern, 'start', 'tokens');
      tok = cat (1, tok{:});
      out.Windows = tok(:,1);
      out.Territory = tok(:,2);
      out.Iana = tok(:,3);
    endfunction
  endmethods
endclassdef

