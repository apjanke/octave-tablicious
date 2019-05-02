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
## @deftypefn {Function} {@var{out} =} timezones ()
## @deftypefnx {Function} {@var{out} =} timezones (@var{area})
##
## List all the time zones defined on this system.
##
## This lists all the time zones that are defined in the IANA time zone database
## used by this Octave. (On Linux and macOS, that will generally be the system
## time zone database from @file{/usr/share/zoneinfo}. On Windows, it will be
## the database redistributed with the Chrono package.
##
## If the return is captured, the output is returned as a table if your Octave
## has table support, or a struct if it does not. It will have fields/variables
## containing column vectors:
##
## @table @code
## @item Name
## The IANA zone name, as cellstr.
## @item Area
## The geographical area the zone is in, as cellstr.
## @end table
##
## Compatibility note: Matlab also includes UTCOffset and DSTOffset fields in
## the output; these are currently unimplemented.
##
## @end deftypefn

function out = timezones (area)
  %TIMEZONES List time zones
  %
  % timezones
  % timezones (area)
  % out = (...)
  %
  % Lists all the time zones available on this system.
  %
  % If the return is captured, the list is returned as a table if your Octave
  % has table support, or a struct if it does not. It will have fields/variables:
  %   Name
  %   Area
  %
  % Compatibility note: Matlab also includes UTCOffset and DSTOffset fields in
  % the output; these are currently unimplemented here.
  
  tzdb = octave.chrono.internal.tzinfo.TzDb;
  ids = tzdb.definedZones;
  ids = ids(:);
  areas = cell (size (ids));
  for i = 1:numel (ids)
    if any (ids{i} == '/')
      area = regexprep (ids{i}, '/.*', '');
    else
      area = '';
    endif
    areas{i} = area;
  endfor
  
  if nargin > 0
    tf = strcmp (out.Area, area);
    ids = ids(tf);
    areas = areas(tf);
  endif

  if octave_has_table
    out = table (ids, areas, 'VariableNames',{'Name','Area'});
  else
    out = struct;
    out.Name = ids;
    out.Area = areas;
  endif
  
  if nargout == 0
    if octave_has_table
      % This assumes you're using apjanke's octave-addons-table implementation
      prettyprint (out);
    else
      fmt = '  %-32s  %-20s\n';
      fprintf (fmt, 'Name', 'Area');
      fprintf (fmt, repmat ('-', [1 32]), repmat ('-', [1 20]));
      for i = 1:numel (out.Name)
        fprintf (fmt, out.Name{i}, out.Area{i});
      endfor
    endif
    clear out
  endif
  
endfunction

function out = octave_has_table
  persistent cache
  if isempty (cache)
    try
      t = table;
      cache = isa (t, 'table');
    catch
      cache = false;
    end
  endif
  out = cache;
endfunction
