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
## @deftypefn {Function} {@var{T} =} readtable (@var{filename})
## @deftypefnx {Function} {@var{T} =} readtable (@var{filename}, @var{opts})
## @deftypefnx {Function} {@var{T} =} readtable (@dots{}, @code{'OptionName'}, @var{OptionValue}, @dots{})
##
## Read tabular data from a file into a table array.
##
## @code{readtable} eads tabular data from the file @var{filename} into a single
## table array @var{T}.
## The input file may be a delimited text file (CSV, TSV, space-delimited, etc.)
## or a spreadshet file in Microsoft Excel or OpenOffice (ODS) format.
##
## Options may be specified using an @var{opts} object, or pairs of name/value arguments.
##
## @code{readtable} does not currently support detecting and converting date values
## in the input data. For now, they'll come back as numerics or strings, and you'll
## need to convert them yourself.
##
## @end deftypefn

function out = readtable (filename, varargin)

    # Parse inputs
    # TODO: See if opts object and name/val options can be combined
    nv_opts = struct;
    opts = [];
    i = 1;
    while i <= numel (varargin)
        if isa (varargin{i}, "whatever_options_type_it_is")
            if ! isempty (opts)
                error ("readtable: only one opts object may be supplied");
            endif
            opts = varargin{i};
            i = i + 1;
        else
            # Must be a name/value pair
            if i == numel (varargin)
                error ("readtable: invalid number of inputs; name/value options must come in pairs");
            endif
            if ! isempty (opts)
                error ("readtable: cannot supply both options object and name/value options");
            endif
            nv_opts.(varargin{i}) = varargin{i+1};
            i = i + 2;
        endif
    endwhile

    # Determine input file type
    [parent, basename, extension] = fileparts (filename);
    switch lower (extension)
        case ".csv"
            file_type = "delimited";
            delim = ",";
        case ".tsv"
            file_type = "delimited";
            delim = "\t";
        case {".xls" ".xlsx" ".xlsm" "xlsb"}
            file_type = "excel";
        case {".ods"}
            file_type = "openoffice";
        otherwise
            error ("readtable: could not determine file type from extension: %s", filename);
    endswitch

    ## Do the reading and package it up
    if ! isfile (filename)
        error ("readtable: file not found: %s", filename);
    endif
    switch file_type
        case "excel"
            out = readtable_excel (filename, opts)
        otherwise
            error("readtable: BUG: file_type %s is not implemented yet", file_type);
    endswitch

endfunction

function out = readtable_excel (filename, opts)
    [num, txt, raw, limits] = xlsread (filename);

    keyboard
    col_names = txt(1,:);
    # num does not need to be stripped - looks like it gets stripped
    # automatically in xlsread ???
    #num = num(2:end,:);
    txt = txt(2:end,:);
    raw = raw(2:end,:);

    n_rows = size (num, 1);
    n_cols = size (num, 2);
    col_data = cell (1, n_cols);
    is_numeric = false (1, n_cols);
    for i_col = 1:n_cols
        if ! any (isnan (num(:,i_col)))
            is_numeric(i_col) = true;
            continue;
        endif
        this_one_looks_numeric = true;
        for i_row = 1:n_rows
            if ! isnumeric (raw{i_row,i_col})
                this_one_looks_numeric = false;
                break;
            endif
        endfor
        is_numeric(i_col) = this_one_looks_numeric;
    endfor
    for i_col = 1:n_cols
        if is_numeric(i_col)
            col_data{i_col} = num(:,i_col);
        else
            x = raw(:,i_col);
            if iscellstr (x)
                x = string (x);
            endif
            col_data{i_col} = x;
        endif
    endfor

    out = table(col_data{:}, "VariableNames", col_names);
endfunction