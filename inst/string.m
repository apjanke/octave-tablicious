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

classdef string
  %STRING A string array of Unicode strings
  %
  % A string object array is an array of strings.
  %
  % The string class represents strings, where:
  %   - Each element of a string array is a single string
  %   - A single string is a 1-dimensional row vector of Unicode characters
  %   - Those characters are encoded in UTF-8
  %
  % This should correspond pretty well to what people think of as strings, and
  % is pretty compatible with people's typical notion of strings.
  %
  % String arrays also have a special "missing" value, that is like the string
  % equivalent of NaN for doubles or "undefined" for categoricals, or SQL NULL.
  %
  % This is a slightly higher-level and more strongly-typed way of representing
  % strings than cellstrs are. (A cellstr array is of type cell, not a text-
  % specific type, and allows assignment of non-string data into it.)
  %
  % Be aware that while string arrays interconvert with Octave chars and cellstrs,
  % Octave char elements represent 8-bit UTF-8 code units, not Unicode code points.
  %
  % This class really serves three roles.
  %   - It is an object wrapper around Octave's base primitive char types. 
  %   - It adds ismissing() semantics.
  %   - And it introduces Unicode support. 
  % Not clear whether it's a good fit to have the Unicode support wrapped
  % up in this. Maybe it should just be a simple object wrapper
  % wrapper, and defer Unicode semantics to when core Octave adopts them for
  % char and cellstr. On the other hand, because Octave chars are UTF-8, not UCS-2,
  % some methods like strlength() and reverse() are just going to be wrong if
  % they delegate straight to chars.
  %
  % "Missing" string values work like NaNs. They are never considered equal,
  % less than, or greater to any other string, including other missing strings.
  % This applies to set membership and other equivalence tests.
  %
  % TODO: Need to decide how far to go with Unicode semantics, and how much to
  % just make this an object wrapper over cellstr and defer to Octave's existing
  % char/string-handling functions.
  %
  % TODO: demote_strings should probably be static or global, so that other
  % functions can use it to hack themselves into being string-aware.
  
  % Developer's note: The string manipulation and encoding methods are implemented
  % using Java here. This should be switched to use gnulib, ICU4C, or another 
  % C++ library before moving these into Octave core (or a popular package),
  % because not all Octaves are built with Java.
  
  properties
    % The underlying char data, as cellstr
    strs = {''};  % @planar
    % A logical mask indicating
    tfMissing
  endproperties
  
  methods
    function this = string(in, varargin)
      %STRING Construct a string array
      %
      % Constructs a new string array by converting various types of inputs.
      %   - chars and cellstrs are converted via cellstr()
      %   - numerics are converted via num2str()
      %   - datetimes are converted via datestr()
      %
      % TODO: Support a 'MapMissing' option to map "standard missing values"
      % (empty strings, NaN, NaT) to string missings.
      %
      % TODO: Maybe fall back to calling cellstr() on arbitrary input objects.
      if nargin == 0
        return;
      endif
      if isa(in, "string")
        % Copy properties, because I don't know if a full-array pass-through
        % works in Octave. -apj
        % this = in; % That is, don't do this.
        this.strs = in.strs;
        this.tfMissing = in.tfMissing;
        return
      endif
      if ischar (in)
        this.strs = cellstr (in);
        this.tfMissing = false (size (this.strs));
      elseif iscell (in)
        if ! iscellstr (in)
          error ('string: cell inputs must be cellstr');
        endif
        this.strs = in;
        this.tfMissing = false (size (this.strs));
      elseif isnumeric (in)
        this.strs = arrayfun (@(x) {num2str (x)}, in);
        this.tfMissing = false (size (this.strs));
      elseif isa (in, 'datetime')
        this.strs = arrayfun (@(x) {datestr (x)}, in);
        this.tfMissing = false (size (this.strs));
      elseif isa (in, 'duration') || isa (in, 'calendarDuration')
        error ('string: duration and calendarDuration conversion are not implemented yet. Sorry.');
      elseif isa (in, 'missing')
        this.strs = repmat ({''}, size (in));
        this.tfMissing = true (size (in));
      else
        error ('string: unsupported input type: %s', class (in));
      endif
    endfunction
    
    function out = isstring (this)
      %ISSTRING True if input is a string array
      %
      % This is always true for string arrays.
      %
      % Returns scalar logical.
      out = true;
    end

    function display (this)
      %DISPLAY Custom display
      in_name = inputname(1);
      if ~isempty(in_name)
        fprintf('%s =\n', in_name);
      end
      disp(this);
    end

    function disp (this)
      %DISP Custom display
      if isempty (this)
        fprintf ('Empty %s string\n', size2str (size (this)));
        return;
      end
      my_dispstrs = this.dispstrs;
      out = format_dispstr_array (my_dispstrs);
      fprintf("%s", out);
    end
    
    function out = dispstrs (this)
      %DISPSTRS Custom display strings
      %
      % out = dispstrs (this)
      %
      % Gets display strings for all the elements in this. These display strings
      % will either be the string contents of the element, enclosed in '"..."',
      % and with CR/LF characters replaced with '\r' and '\n' escape sequences,
      % or "<missing>" for missing values.
      %
      % Returns cellstr, for compatibility with the dispstr API.
      out = strcat ({'"'}, this.strs, {'"'});
      out = strrep (out, sprintf ("\r"), '\r');
      out = strrep (out, sprintf ("\n"), '\n');
      out(this.tfMissing) = "<missing>";
    endfunction
    
    function out = ismissing (this)
      %ISMISSING True for missing data
      %
      % out = ismissing (this)
      %
      % Indicates which values in this are missing.
      %
      % Returns a logical array the same size as this.
      out = this.tfMissing;
    endfunction
    
    function out = isnanny (this)
      %ISNANNY True for NaN-like values
      %
      % Missing values are considered nanny; any other string value is not.
      %
      % Returns a logical array the same size as this.
      out = ismissing (this);
    endfunction
    
    % Type conversion methods
    
    function out = cellstr (this)
      %CELLSTR Convert to cellstr
      %
      % out = cellstr (this)
      %
      % Converts this to a cellstr. Missing values are converted to ''.
      out = this.strs;
      % TODO: I don't know what the best conversion is here. Maybe it should
      % even error if any are missing? For now I'm using '', because that's the
      % "standard" missing value for cellstrs.
      out(this.tfMissing) = {''};
    end
    
    function out = cell (this)
      %CELL Convert to cell
      %
      % Converts this to a cell, which will be a cellstr. Missing values are
      % converted to ''.
      %
      % This method returns the same values as cellstr(this); it is just provided
      % for interface compatibility purposes.
      out = this.strs;
      out(tfMissing) = {[]};
    end      
    
    function out = char (this)
      %CHAR Convert to char
      if any (this.tfMissing)
        error ('string.char: Cannot convert missing string data to char');
      endif
      out = char(cellstr(this));
    end
      
    function out = demote_strings(varargin)
      %DEMOTE_STRINGS Turn all string arguments into chars
      %
      % This is for compatibility with functions that take chars or cellstrs,
      % but are not aware of string arrays.
      %
      % Scalar strings are turned into char row vectors. Nonscalar strings are
      % turned in to cellstrs. This might not actually be the right thing,
      % depending on what function you are calling!
      args = varargin;
      out = args;
      for i = 1:numel(args)
        if isa (args{i}, 'string')
          if isscalar (args{i})
            out{i} = char (args{i});
          else
            out{i} = cellstr (args{i});
          endif
        endif
      endfor
    endfunction
    
    % Encoding
    
    function out = encode (this, charsetName)
      %ENCODE Encode this string in a given encoding
      %
      % out = encode (this, charsetName)
      %
      % Encodes this string in a given encoding.
      %
      % This must be scalar.
      %
      % charsetName (char) is the name of a character encoding.
      %
      % Returns the encoded string as uint8 vector.
      %
      % See also: STRING.DECODE
      mustBeScalar (this);
      mustHavaJava ();
      if this.tfMissing
        error ('string.encode: cannot encode missing values');
      endif
      java_str = javaObject ('java.lang.String', this.strs{i});
      java_bytes = javaMethod ('getBytes', java_str, charsetName);
      out = typecast (java_bytes', 'uint8');
    endfunction
      
    % String manipulation methods
    
    function out = strlength_bytes (this)
      %STRLENGTH_BYTES String length in UTF-8 code units (bytes)
      %
      % Gets the length of each string, counted in Unicode UTF-8
      % code units (bytes). This is the same as numel(str) for the corresponding
      % Octave char vector for each string, but is probably not what you 
      % actually want to use. You probably want STRLENGTH instead.
      %
      % Returns double array of the same size as this. Returns NaNs for missing
      % strings.
      %
      % See also: STRING.STRLENGTH
      out = cellfun (@numel, this.strs);
      out(this.tfMissing) = NaN;
    endfunction
    
    function out = strlength(this)
      %STRLENGTH String length in Unicode characters (code points)
      %
      % Gets the length of each string, counted in Unicode characters (code
      % points). This is the string length method you probably want to use,
      % not STRLENGTH_BYTES.
      %
      % Returns double array of the same size as this. Returns NaNs for missing
      % strings.
      %
      % See also: STRING.STRLENGTH_BYTES
      mustHaveJava ();
      out = NaN (size(this));
      for i = 1:numel (out)
        if this.tfMissing(i)
          continue
        endif
        j_str = javaObject ('java.lang.String', this.strs{i});
        out(i) = javaMethod ('codePointCount', j_str, 0, numel (this.strs{i}));
      endfor
    endfunction
    
    function out = reverse_bytes (this)
      %REVERSE_BYTES Reverse string, byte-wise (not character-wise)
      %
      % out = reverse_bytes (this)
      %
      % Reverses the bytes in each string in this.
      %
      % This may well produce invalid strings as a result, because reversing a
      % UTF-8 byte sequence does not necessarily produce another valid UTF-8
      % byte sequence.
      %
      % You probably do not want to use this method. You probably want to use
      % string.reverse instead.
      %
      % Returns a string array the same size as this.
      %
      % See also: STRING.REVERSE
      out = this;
      for i = 1:numel (this)
        out.strs{i} = out.strs{i}(end:-1:1);
      endfor
    endfunction
    
    function out = reverse(this)
      %REVERSE Reverse string, character-wise
      out = this;
      % Transcode to UTF-32 (since UTF-32 is a fixed-width encoding), 
      % reverse that, and transcode back to original encoding
      bytess = encode (this, 'UTF-32LE');
      for i = 1:numel (this)
        bytes = bytess{i};
        utf32 = typecast (bytes, 'uint32');
        utf32_reverse = utf32(end:-1:1);
        bytes2 = typecast (utf32_reverse, 'uint8');
        java_str = javaObject ('java.lang.String', bytes2, 'UTF-32LE');
        reversed = char (java_str);
        out.strs{i} = reversed;
      endfor
    endfunction
    
    function out = strcat (varargin)
      %STRCAT Concatenate strings
      args = promotec (varargin);
      args_strs = cell (size (args));
      args_tfMissing = cell (size (args));
      for i = 1:numel (args2)
        args_strs{i} = args{i}.strs;
        args_tfMissing{i} = args{i}.tfMissing;
      endfor
      out = string (strcat (args_strs{:}));
      % TODO: I think this is wrong: it doesn't handle scalar expansion
      out.tfMissing = cat (2, args_tfMissing{:});
    endfunction

    function out = lower (this)
      %LOWER Convert to lower case
      %
      % out = lower (this)
      %
      % Converts all the characters in all the strings in this to lower case.
      %
      % Returns a string array the same size as this.
      out = this;
      % TODO: This lower() call is probably wrong: it relies on Octave's lower(),
      % which I think only does ASCII case conversion, not Unicode case conversion. -apj
      out.strs = lower (this.strs);
    endfunction
    
    function out = upper (this)
      %UPPER Convert to upper case
      %
      % out = upper (this)
      %
      % Converts all the characters in all the strings in this to upper case.
      %
      % Returns a string array the same size as this.
      out = this;
      % TODO: This upper() call is probably wrong: it relies on Octave's upper(),
      % which I think only does ASCII case conversion, not Unicode case conversion. -apj
      out.strs = upper (this.strs);
    endfunction
    
    function out = erase (this, match)
      %ERASE Erase matching substring
      %
      % out = erase (this, match)
      %
      % Erases the substrings in this which match the match input.
      %
      % Returns a string array the same size as this.
      [this, match] = promote (this, match);
      out = this;
      out.strs = strrep (this.strs, char(match), '');
    endfunction
    
    function out = strrep (this, match, replacement, varargin)
      %STRREP Replace occurrences of pattern with other string
      %
      % out = strrep (this, match, replacement, varargin)
      %
      % Replaces matching substrings with a given replacement string.
      %
      % The varargin is passed along to core Octave's strrep() function.
      %
      % Returns a string array the same size as this.
      [this, match, replacement] = promote (this, match, replacement);
      out = this;
      out.strs = strrep(this.strs, char(match), char(replacement), varargin{:});
    endfunction

    function out = strfind(this, pattern, varargin)
      %STRFIND Find pattern in string
      %
      % out = strfind(this, pattern, varargin)
      %
      % TODO: It's ambiguous whether a scalar this should result in a numeric
      % out or a cell array out.
      [this, pattern] = promote (this, pattern);
      out = strfind(this.strs, char(pattern), varargin{:});
      out(this.tfMissing) = {[]};
    endfunction
    
    function out = regexprep(this, pat, repstr, varargin)
      %REGEXPREP Replace regular expression patterns in string
      %
      % out = regexprep(this, pat, repstr, varargin)
      %
      % Replaces substrings matching a given regexp pattern with the given 
      % replacement text.
      [this, pat, repstr] = promote (this, pat, repstr);
      args = demote_strings(varargin);
      out = this;
      out.strs = regexprep(this.strs, char(pat), char(repstr), args{:});
    endfunction
    
    % Relational operations
    % TODO: Add Missing support for all these
    
    function out = eq(A, B)
      %EQ Equals.
      out = strcmp(A, B);
    endfunction
    
    function out = cmp(A, B)
      %CMP C-style strcmp, with -1/0/+1 return value
      %
      % out = cmp(A, B)
      %
      % TODO: What to do about missing values? Should missings sort to the end
      % (preserving total ordering over the full domain), or should their comparisons
      % result in a fourth "null"/"undef" return value?
      %
      % Returns a numeric array the same size as the scalar expansion of A and B.
      % Each value in it will be -1, 0, or 1.
      [A, B] = promote (A, B);
      % In production code, you wouldn't scalarexpand; you'd do a scalar test
      % and smarter indexing.
      % Though really, in production code, you'd want to implement this whole function
      % as a built-in or MEX file.
      [A, B] = scalarexpand (A, B);
      out = NaN (size (A));
      for i = 1:numel (A)
        a = A.strs{i};
        b = B.strs{i};
        if isequal (a, b)
          out(i) = 0;
        else
          tmp = [a b];
          [tmp2, ix] = sort (tmp);
          if ix(1) == 1
            out(i) = -1;
          else
            out(i) = 1;
          endif
        endif
      endfor
    endfunction
    
    function out = lt (A, B)
      %LT Less than.
      out = cmp (A, B) < 0;
    endfunction

    function out = le (A, B)
      %LE Less than or equal.
      out = cmp (A, B) <= 0;
    endfunction

    function out = gt(A, B)
      %GT Greater than.
      out = cmp (A, B) > 0;
    endfunction

    function out = ge (A, B)
      %GE Greater than or equal.
      out = cmp (A, B) >= 0;
    endfunction
    
    % TODO: max, min

    function [out, Indx] = ismember (a, b, varargin)
      %ISMEMBER True for set member.
      [a, b] = promote (a, b);
      [out, Indx] = ismember (a.strs, b.strs, varargin{:});
    endfunction
    
    function [out, Indx] = setdiff (a, b, varargin)
      %SETDIFF Set difference.
      [a, b] = promote (a, b);
      [s_out, Indx] = setdiff (a.strs, b.strs, varargin{:});
      out = string (s_out);
    endfunction

    function [out, ia, ib] = intersect (a, b, varargin)
      %INTERSECT Set intersection.
      [a, b] = promote (a, b);
      [s_out, ia, ib] = intersect (a.strs, b.strs, varargin{:});
      out = string (s_out);
    endfunction
    
    function [out, ia, ib] = union (a, b, varargin)
      %UNION Set union.
      [a, b] = promote (a, b);
      [s_out, ia, ib] = union (a.strs, b.strs, varargin{:});
      out = string (s_out);
    endfunction

    function [out, Indx] = unique (this, varargin)
      %UNIQUE Set unique.
      this = promote (this);
      [s_out, Indx] = unique (this.strs, varargin{:});
      out = string (s_out);
    endfunction

  endmethods
  
  methods (Hidden)
    % Compatibility shims
    
    function out = sprintf (fmt, varargin)
      %SPRINTF Like printf, but returns a string
      fmt = char (string (fmt));
      args = demote_strings (varargin);
      out = string (sprintf (fmt, args{:}));
    endfunction
    
    function out = fprintf (varargin)
      %FPRINTF Formatted output to stream or file handle
      args = demote_strings (varargin);
      out = fprintf (args{:});
      if nargout == 0
        clear out
      endif
    endfunction

    function out = printf (varargin)
      %PRINTF Formatted output
      args = demote_strings( varargin);
      printf (args{:});
      if nargout == 0
        clear out
      endif
    endfunction

    % TODO: fdisp, fputs, fwrite
    
    % plot() and related functions. Yuck.
    
    function out = plot (varargin)
      args = demote_strings (varargin);
      out = plot (args{:});
    endfunction
    
    function out = plotyy (varargin)
      args = demote_strings (varargin);
      out = plotyy (args{:});
    endfunction
    
    function out = loglog (varargin)
      args = demote_strings (varargin);
      out = loglog (args{:});
    endfunction
    
    function out = semilogy (varargin)
      args = demote_strings (varargin);
      out = semilogy (args{:});
    endfunction
    
    function out = bar (varargin)
      args = demote_strings (varargin);
      out = bar (args{:});
    endfunction
    
    function out = barh (varargin)
      args = demote_strings (varargin);
      out = barh (args{:});
    endfunction
    
    function varargout = hist (varargin)
      args = demote_strings (varargin);
      varargout = cell (1, nargout);
      [varargout{:}] = hist (args{:});
    endfunction
    
    function out = stemleaf (varargin)
      args = demote_strings (varargin);
      out = stemleaf (args{:});
    endfunction
    
    function out = stairs (varargin)
      args = demote_strings (varargin);
      out = stairs (args{:});
    endfunction
    
    function out = stem3 (varargin)
      args = demote_strings (varargin);
      out = stem3 (args{:});
    endfunction
    
    function out = scatter (varargin)
      args = demote_strings (varargin);
      out = scatter (args{:});
    endfunction
    
    function out = stem (varargin)
      args = demote_strings (varargin);
      out = stem (args{:});
    endfunction
    
    function out = surf (varargin)
      args = demote_strings (varargin);
      out = surf (args{:});
    endfunction
    
    function out = title (varargin)
      args = demote_strings (varargin);
      out = title (args{:});
    endfunction
    
    function out = legend (varargin)
      args = demote_strings (varargin);
      out = legend (args{:});
    endfunction
    
    % ... and so on, and so on, and so on ...
  endmethods
  
  % Planar structural stuff
  methods
    
    function out = size (this)
      %SIZE Size of array.
      out = size (this.strs);
    endfunction
    
    function out = numel (this)
      %NUMEL Number of elements in array.
      out = numel (this.strs);
    endfunction
    
    function out = ndims (this)
      %NDIMS Number of dimensions.
      out = ndims(this.strs);
    endfunction
    
    function out = isempty(this)
      %ISEMPTY True for empty array.
      out = isempty (this.strs);
    endfunction
    
    function out = isscalar (this)
      %ISSCALAR True if input is scalar.
      out = isscalar (this.strs);
    endfunction
    
    function out = isvector (this)
      %ISVECTOR True if input is a vector.
      out = isvector (this.strs);
    endfunction
      
    function out = iscolumn (this)
      %ISCOLUMN True if input is a column vector.
      out = iscolumn (this.strs);
    endfunction
    
    function out = isrow (this)
      %ISROW True if input is a row vector.
      out = isrow (this.strs);
    endfunction
    
    function out = ismatrix (this)
      %ISMATRIX True if input is a matrix.
      out = ismatrix (this.strs);
    endfunction
    
    function this = reshape (this, varargin)
      %RESHAPE Reshape array.
      this.strs = reshape (this.strs, varargin{:});
      this.tfMissing = reshape (this.tfMissing, varargin{:});
    endfunction
    
    function this = squeeze (this, varargin)
      %SQUEEZE Remove singleton dimensions.
      this.strs = squeeze (this.strs, varargin{:});
      this.tfMissing = squeeze (this.tfMissing, varargin{:});
    endfunction
      
    function this = circshift (this, varargin)
      %CIRCSHIFT Shift positions of elements circularly.
      this.strs = circshift (this.strs, varargin{:});
      this.tfMissing = circshift (this.tfMissing, varargin{:});
    endfunction
    
    function this = permute (this, varargin)
      %PERMUTE Permute array dimensions.
      this.strs = permute (this.strs, varargin{:});
      this.tfMissing = permute (this.tfMissing, varargin{:});
    endfunction
    
    function this = ipermute (this, varargin)
      %IPERMUTE Inverse permute array dimensions.
      this.strs = ipermute (this.strs, varargin{:});
      this.tfMissing = ipermute (this.tfMissing, varargin{:});
    endfunction
    
    function this = repmat (this, varargin)
      %REPMAT Replicate and tile array.
      this.strs = repmat (this.strs, varargin{:});
      this.tfMissing = repmat (this.tfMissing, varargin{:});
    endfunction
    
    function this = ctranspose (this, varargin)
      %CTRANSPOSE Complex conjugate transpose.
      this.strs = ctranspose (this.strs, varargin{:});
      this.tfMissing = ctranspose (this.tfMissing, varargin{:});
    endfunction
      
    function this = transpose (this, varargin)
      %TRANSPOSE Transpose vector or matrix.
      this.strs = transpose (this.strs, varargin{:});
      this.tfMissing = transpose (this.tfMissing, varargin{:});
    endfunction
    
    function [this, nshifts] = shiftdim( this, n)
      %SHIFTDIM Shift dimensions.
      if nargin > 1
        this.strs = shiftdim (this.strs, n);
        this.tfMissing = shiftdim (this.strs, n);
      else
        [this.strs, nshifts] = shiftdim (this.strs);
        [this.tfMissing, nshifts] = shiftdim (this.tfMissing);
      endif
    endfunction
    
    function out = cat (dim, varargin)
      %CAT Concatenate arrays.
      args = varargin;
      for i = 1:numel(args)
        if ~isa(args{i}, 'string')
          args{i} = string(args{i});
        end
      end
      out = args{1};
      fieldArgs1 = cellfun(@(obj) {obj.strs}, args);
      out.strs = cat(dim, fieldArgs1{:});
      fieldArgs2 = cellfun(@(obj) {obj.tfMissing}, args);
      out.strs = cat(dim, fieldArgs2{:});
    endfunction
      
    function out = horzcat (varargin)
      %HORZCAT Horizontal concatenation.
      out = cat (2, varargin{:});
    endfunction
    
    function out = vertcat (varargin)
      %VERTCAT Vertical concatenation.
      out = cat (1, varargin{:});
    endfunction
    
    function this = subsasgn(this, s, b)
      %SUBSASGN Subscripted assignment.
      
      % Chained subscripts
      if numel(s) > 1
        rhs_in = subsref(this, s(1));
        rhs = subsasgn(rhs_in, s(2:end), b);
      else
        rhs = b;
      endif
      
      % Base case
      switch s(1).type
        case '()'
          this = subsasgnParensPlanar(this, s(1), rhs);
        case '{}'
          % This works just like ()-assignment, and is only defined for
          % compatibility with cellstrs
          this = subsasgnParensPlanar(this, s(1), rhs);
        case '.'
          error ('string:BadOperation', '.-assignment is not defined for string arrays');
      endswitch
    endfunction
      
    function varargout = subsref(this, s)
    %SUBSREF Subscripted reference.
    
      % Base case
      switch s(1).type
        case '()'
          varargout = { subsrefParensPlanar(this, s(1)) };
        case '{}'
          % This pops out char arrays
          varargout = subsrefParensPlanar (this, s(1));
        case '.'
          error('string:BadOperation',...
              '.-subscripting is not supported for string arrays');
      endswitch
      
      % Chained reference
      if numel (s) > 1
        out = subsref (out, s(2:end));
      endif
    endfunction
  
  endmethods
    
  methods (Access=private)
  
    function this = subsasgnParensPlanar (this, s, rhs)
      %SUBSASGNPARENSPLANAR ()-assignment for planar object
      if ~isa (rhs, 'string')
        rhs = string (rhs);
      endif
      this.strs(s.subs{:}) = rhs.strs;
      this.tfMissing(s.subs{:}) = rhs.tfMissing;
    endfunction
    
    function out = subsrefParensPlanar(this, s)
      %SUBSREFPARENSPLANAR ()-indexing for planar object
      out = this;
      out.strs = this.strs(s.subs{:});
      out.tfMissing = this.tfMissing(s.subs{:});
    endfunction
    
    function out = parensRef(this, varargin)
      %PARENSREF ()-indexing, for this class's internal use
      out = subsrefParensPlanar (this, struct ('subs', {varargin}));
    endfunction
    
    function out = subset(this, varargin)
      %SUBSET Subset array by indexes.
      % This is what you call internally inside the class instead of doing 
      % ()-indexing references on the RHS, which don't work properly inside the class
      % because they don't respect the subsref() override.
      out = parensRef (this, varargin{:});
    endfunction
        
    function out = asgn(this, ix, value)
      %ASGN Assign array elements by indexes.
      % This is what you call internally inside the class instead of doing 
      % ()-indexing references on the LHS, which don't work properly inside
      % the class because they don't respect the subsasgn() override.
      if ~iscell(ix)
        ix = { ix };
      endif
      s.type = '()';
      s.subs = ix;
      out = subsasgnParensPlanar(this, s, value);
    endfunction
    
  endmethods
  
  methods (Static)
    function out = missing (sz)
      %MISSING Missing string value
      %
      % out = string.missing (sz)
      %
      % Constructs a string array of the given size with all missing values.
      %
      % Sz is the size of array to create. If sz is omitted, creates a scalar.
      %
      % Returns a string array whose values are all missing.
      if nargin < 2
        sz = [1 1];
      endif
      out = repmat (string, sz);
    endfunction
    
    function out = decode (bytes, charsetName)
      %DECODE Decode encoded text from bytes into a string object
      %
      % See also: STRING.ENCODE
      out = string (char (javaObject ('java.lang.String', bytes, charsetName)));
    end
  end

endclassdef

function varargout = promote (varargin)
  %PROMOTEC Promote arguments to strings
  varargout = varargin;
  for i = 1:numel (varargin)
    if ~ isa (varargin{i}, 'string')
      varargout{i} = string (varargin{i});
    endif
  endfor
endfunction


function out = promotec (args)
  %PROMOTEC Promote arguments to strings, cell-wise
  out = args;
  for i = 1:numel (args)
    if ~ isa (args{i}, 'string')
      out{i} = string (args{i});
    endif
  endfor
endfunction
