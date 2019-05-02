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

function out = detect_system_timezone
  try
    out = do_detection ();
    tzdb = octave.chrono.internal.tzinfo.TzDb;
    if ~ismember (out, tzdb.definedZones)
      warning ('System time zone ''%s'' is not defined in the tzinfo database.', ...
        out);
    endif
  catch err
    warning (['Failed detecting system time zone: %s\n'...
      'Falling back to '''''], ...
      err.message);
    out = '';
  end
endfunction

function out = do_detection ()
  %DO_DETECTION Actual detection logic
  
  % Let TZ env var take precedence
  tz_env = getenv ('TZ');
  if ~isempty (tz_env)
    out = tz_env;
  else
    % Get actual system default
    out = [];
    if exist ('/etc/localtime', 'file')
      % This exists on macOS and RHEL/CentOS 7/some Fedora
      [target,err,msg] = readlink ('/etc/localtime');
      if err
        error ('Can''t determine time zone: Failed reading /etc/localtime: %s', ...
          msg);
      end
      out = regexprep (target, '.*/zoneinfo/', '');
    elseif exist ('/etc/timezone')
      % This exists on Debian
      out = strtrim (octave.chrono.internal.slurpTextFile ('/etc/timezone'));
    endif
    if isempty (out) && ispc
      % Newer Windows can do it with PowerShell
      win_zone = detect_timezone_using_powershell;
      if ~isempty (win_zone)
        converter = octave.chrono.internal.tzinfo.WindowsIanaZoneConverter;
        out = converter.windows2iana (win_zone);
      endif
    endif
    if isempty (out)
      % Fall back to Java if nothing else worked
      if ~usejava ('jvm')
        error ('Detecting time zone on this OS requires Java, which is not available in this Octave.');
      endif
      zone = javaMethod ('getDefault', 'java.util.TimeZone');
      out = char (zone.getID());
    endif
  endif
endfunction

function out = detect_timezone_using_powershell ()
  % This only works on Windows Vista or newer. Windows 7 and older lack the
  % Get-TimeZone command.
  [status, txt] = system ('powershell -Command Get-TimeZone');
  if status ~= 0
    out = [];
    return
  endif
  info = parse_powershell_get_timezone_output (txt);
  if isempty (info)
    out = [];
    return
  endif
  out = info.Id;
end

function out = parse_powershell_get_timezone_output (str)
  str = strrep (str, "\r\n", "\n");
  [match,tok] = regexp (str, '^(\w+)\s*:\s*(\S.*?)(?=\n|$)', ...
    'match', 'tokens', 'lineanchors');
  if isempty (match)
    out = [];
  else
    tok = cat(1, tok{:});
    out = cell2struct(tok(:,2), tok(:,1));
  endif
endfunction