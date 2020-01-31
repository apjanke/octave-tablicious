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

## -*- texinfo -*-
## @deftp {Class} matlab.io.spreadsheet.SpreadsheetImportOptions
##
## Options controlling how table data is imported from a spreadsheet.
##
## A SpreadsheetImportOptions object specifies the options for importing
## a single table of data from a spreadsheet file.
##
## @end deftp

classdef SpreadsheetImportOptions

  properties
    % The sheet where the data is located, as a name or number
    Sheet
    % Where the table data is located in the sheet
    DataRange
    % Where the variable names are located
    VariableNamesRange
    % Where the row names are located
    RowNamesRange
    % Where the variable units are located
    VariableUnitsRange
    % Where the variable descriptions are located
    VariableUnitsRange
    % Names of the variables in the file
    VariableNames
    % Names of the variables to be imported. If empty, defaults to all variables
    % in the file.
    SelectedVariableNames
    % The import types of the variables
    VariableTypes
    % Advanced options for variable import
    VariableOptions
    % Whether to convert variable names to valid Octave identifiers
    PreserveVariableNames = true
    % Rules for interpreting nonconvertible or bad data
    ImportErrorRule
    % Rules for interpreting missing or unavailable data
    MissingRule
  endproperties

  methods

    function this = SpreadsheetImportOptions(varargin)
    endfunction

  endmethods

endclassdef
