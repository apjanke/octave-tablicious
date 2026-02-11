## Copyright (C) 2023, 2024 Andrew Janke
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function} {@var{out} =} todatetime (@var{x})
##
## Convert input to a Tablicious datetime array, with convenient interface.
##
## This is an alternative to the regular datetime constructor, with a signature
## and conversion logic that Tablicious's author likes better.
##
## This mainly exists because datetime's constructor signature does not accept
## datenums, and instead treats one-arg numeric inputs as datevecs. (For compatibility
## with Matlab's interface.) I think that's less convenient: datenums seem to be
## more common than datevecs in M-code, and it returns an object array that's not the
## same size as the input.
##
## Returns a datetime array whose size depends on the size and type of the input
## array, but will generally be the same size as the array of strings or numerics
## the input array "represents".
##
## @end deftypefn

function out = todatetime (x)

## Common and easy short-circuits first.
if isdatetime (x)
    out = x;
    return
elseif isnumeric (x)
    out = datetime (x, 'ConvertFrom', 'datenum');
    return
end

# String handling next, with format recognition hacks.
if isa (x, 'string') || ischar (x) || iscellstr (x)
    # char rep of empty string is a weird special case.
    if ischar(x) && isempty(x)
        out = NaT;
        return
    end
    x = string (x);
    if isempty (x)
        out = repmat (datetime, size (x));
        return
    end
    # TODO: Format recognition hacks
    out = datetime (x);
    return
end

# Unusual input types.
if isa (x, 'java.time.ZonedDateTime')
    nanosOfSecond = x.getNano;
    fractionalSecs = double (nanosOfSecond) / (10^9);
    out = datetime (x.getYear, x.getMonthValue, x.getDayOfMonth, ...
        x.getHour, x.getMinute, x.getSecond + fractionalSecs);
    out.TimeZone = string (x.getZone.getId);
    return
end

# General fallback case: delegate to datetime().
# TODO: Maybe this should also go in an `if isobject()` block higher up, as
# an optimization to avoid isa() calls for less-common types?
out = datetime (x);

end

