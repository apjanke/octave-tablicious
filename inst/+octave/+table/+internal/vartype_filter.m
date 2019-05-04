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

classdef vartype_filter
  %VARTYPE_FILTER A thing that indicates filtering by variable type
  
  properties
    type
  endproperties
  
  methods
    function this = vartype_filter(type)
      mustBeCharvec(type);
      this.type = type;
    endfunction
    
    function out = matches (this, variable_value)
      if isequal (this.type, 'cellstr')
        out = iscellstr (variable_value);
      else
        out = isa (variable_value, this.type);
      endif
    endfunction
  endmethods
  
endclassdef
