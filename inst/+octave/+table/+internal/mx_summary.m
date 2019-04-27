## Copyright (C) 2019 Andrew Janke
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; If not, see <http://www.gnu.org/licenses/>.

function out = mx_summary (x)
  %MX_SUMMARY "Summary" data for an arbitrary array, with specific type support
  %
  % TODO: This needs to be expanded to support tables of arbitrary columns, to
  % support things like summaries of distinct value frequencies in categorical
  % values.
  %
  % Returns a scalar struct.

  out = struct;
  out.Size = size (x);
  out.Type = class (x);

  if isnumeric (x)
  	out = mx_summary_numeric (x, out);
  elseif isa (x, 'datetime')
    out = mx_summary_datetime (x, out);
  elseif isa (x, 'duration')
    out = mx_summary_numeric (x, out); % Works because duration supports isnan()
  elseif islogical (x)
    out = mx_summary_logical (x, out);
  elseif isa (x, 'categorical')
    out = mx_summary_categorical (x, out);
  else
  	% nop: we've already got Size and Type; that's all that is supported
  endif
endfunction

function out = mx_summary_numeric (x, out)
  out.Min = min (x);
  out.Median = median (x);
  out.Max = max (x);
  out.NumMissing = numel (find (isnan (x)));
endfunction

function out = mx_summary_datetime (x, out)
  out.Min = min (x);
  out.Median = median (x);
  out.Max = max (x);
  out.NumMissing = numel (find (isnat (x))); % friggin' NaT; sigh...
end

function out = mx_summary_logical (x, out)
  out.True = numel (find (x));
  out.False = numel (find (~x));
end

function out = mx_summary_categorical (x, out)
  out.NumCategories = numel (categories (x));
endfunction
