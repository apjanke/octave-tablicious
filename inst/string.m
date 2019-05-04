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
## @deftp {Class} string
##
## A string array of Unicode strings.
##
## A string array is an array of strings, where each array element is a single
## string.
##
## The string class represents strings, where:
##   - Each element of a string array is a single string
##   - A single string is a 1-dimensional row vector of Unicode characters
##   - Those characters are encoded in UTF-8
##
## This should correspond pretty well to what people think of as strings, and
## is pretty compatible with people’s typical notion of strings in Octave.
##
## String arrays also have a special “missing” value, that is like the string
## equivalent of NaN for doubles or “undefined” for categoricals, or SQL NULL.
##
## This is a slightly higher-level and more strongly-typed way of representing
## strings than cellstrs are. (A cellstr array is of type cell, not a text-
## specific type, and allows assignment of non-string data into it.)
##
## Be aware that while string arrays interconvert with Octave chars and cellstrs,
## Octave char elements represent 8-bit UTF-8 code units, not Unicode code points.
##
## This class really serves three roles.
##   - It is an object wrapper around Octave’s base primitive character types. 
##   - It adds ismissing() semantics.
##   - And it introduces Unicode support. 
## Not clear whether it’s a good fit to have the Unicode support wrapped
## up in this. Maybe it should just be a simple object wrapper
## wrapper, and defer Unicode semantics to when core Octave adopts them for
## char and cellstr. On the other hand, because Octave chars are UTF-8, not UCS-2,
## some methods like strlength() and reverse() are just going to be wrong if
## they delegate straight to chars.
##
## “Missing” string values work like NaNs. They are never considered equal,
## less than, or greater to any other string, including other missing strings.
## This applies to set membership and other equivalence tests.
##
## The current implementation depends on Java for its Unicode and encoding
## support. This means your Octave session must be running Java to call those
## methods. This should be changed in the future to use a native C/C++ library
## and avoid the Java dependency, especially before this class is merged into
## core Octave.
##
## TODO: Need to decide how far to go with Unicode semantics, and how much to
## just make this an object wrapper over cellstr and defer to Octave's existing
## char/string-handling functions.
##
## TODO: demote_strings should probably be static or global, so that other
## functions can use it to hack themselves into being string-aware.
##
## @end deftp
classdef string
  
  % Developer's note: The string manipulation and encoding methods are implemented
  % using Java here. This should be switched to use gnulib, ICU4C, or another 
  % C++ library before moving these into Octave core (or a popular package),
  % because not all Octaves are built with Java.
  
  properties
    % The underlying char data, as cellstr
    strs = {''};  % planar
    % A logical mask indicating whether each element is a missing value
    tfMissing     % planar
  endproperties
  
  methods
    ## -*- texinfo -*-
    ## @node string.string
    ## @deftypefn {Constructor} {@var{obj} =} string ()
    ## @deftypefnx {Constructor} {@var{obj} =} string (@var{in})
    ##
    ## Construct a new string array.
    ##
    ## The zero-argument constructor creates a new scalar string array
    ## whose value is the empty string. TODO: Determine if this should
    ## actually return a “missing” string instead.
    ##
    ## The other constructors construct a new string array by converting
    ## various types of inputs.
    ##   - chars and cellstrs are converted via cellstr()
    ##   - numerics are converted via num2str()
    ##   - datetimes are converted via datestr()
    ##
    ## @end deftypefn
    function this = string(in, varargin)
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
    
    ## -*- texinfo -*-
    ## @node string.isstring
    ## @deftypefn {Method} {@var{out} =} isstring (@var{obj})
    ##
    ## Test if input is a string array.
    ##
    ## @code{isstring} is always true for @code{string} inputs.
    ##
    ## Returns a scalar logical.
    ##
    ## @end deftypefn
    function out = isstring (this)
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
    
    ## -*- texinfo -*-
    ## @node string.dispstrs
    ## @deftypefn {Method} {@var{out} =} dispstrs (@var{obj})
    ##
    ## Display strings for array elements.
    ##
    ## Gets display strings for all the elements in @var{obj}. These display strings
    ## will either be the string contents of the element, enclosed in @code{"..."},
    ## and with CR/LF characters replaced with @code{'\r'} and @code{'\n'} escape sequences,
    ## or @code{"<missing>"} for missing values.
    ##
    ## Returns a cellstr of the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = dispstrs (this)
      out = strcat ({'"'}, this.strs, {'"'});
      out = strrep (out, sprintf ("\r"), '\r');
      out = strrep (out, sprintf ("\n"), '\n');
      out(this.tfMissing) = "<missing>";
    endfunction
    
    ## -*- texinfo -*-
    ## @node string.sizeof
    ## @deftypefn {Method} {@var{out} =} sizeof (@var{obj})
    ##
    ## Size of array in bytes.
    ##
    ## @end deftypefn
    function out = sizeof (this)
      out = 0;
      out += sizeof (this.strs);
      out += sizeof (this.tfMissing);
    endfunction
    
    ## -*- texinfo -*-
    ## @node string.ismissing
    ## @deftypefn {Method} {@var{out} =} ismissing (@var{obj})
    ##
    ## Test whether array elements are missing.
    ##
    ## For @code{string} arrays, only the special “missing” value is
    ## considered missing. Empty strings are not considered missing, 
    ## the way they are with cellstrs.
    ##
    ## Returns a logical array the same size as @code{obj}.
    ##
    ## @end deftypefn
    function out = ismissing (this)
      out = this.tfMissing;
    endfunction
    
    ## -*- texinfo -*-
    ## @node string.isnannish
    ## @deftypefn {Method} {@var{out} =} isnannish (@var{obj})
    ##
    ## Test whether array elements are NaN-like.
    ##
    ## Missing values are considered nannish; any other string value is not.
    ##
    ## Returns a logical array of the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = isnannish (this)
      out = ismissing (this);
    endfunction
    
    % Type conversion methods
    
    ## -*- texinfo -*-
    ## @node string.cellstr
    ## @deftypefn {Method} {@var{out} =} cellstr (@var{obj})
    ##
    ## Convert to cellstr.
    ##
    ## Converts @var{obj} to a cellstr. Missing values are converted to @code{''}.
    ##
    ## Returns a cellstr array of the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = cellstr (this)
      out = this.strs;
      % TODO: I don't know what the best conversion is here. Maybe it should
      % even error if any are missing? For now I'm using '', because that's the
      % "standard" missing value for cellstrs.
      out(this.tfMissing) = {''};
    end
    
    ## -*- texinfo -*-
    ## @node string.cell
    ## @deftypefn {Method} {@var{out} =} cell (@var{obj})
    ##
    ## Convert to cell array.
    ##
    ## Converts this to a cell, which will be a cellstr. Missing values are
    ## converted to @code{''}.
    ##
    ## This method returns the same values as @code{cellstr(obj)}; it is just provided
    ## for interface compatibility purposes.
    ##
    ## Returns a cell array of the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = cell (this)
      out = this.strs;
      out(tfMissing) = {[]};
    end
    
    ## -*- texinfo -*-
    ## @node string.char
    ## @deftypefn {Method} {@var{out} =} char (@var{obj})
    ##
    ## Convert to char array.
    ##
    ## Converts @var{obj} to a 2-D char array. It will have as many rows
    ## as @var{obj} has elements.
    ##
    ## It is an error to convert missing-valued @code{string} arrays to
    ## char. (NOTE: This may change in the future; it may be more appropriate)
    ## to convert them to space-padded empty strings.)
    ##
    ## Returns 2-D char array.
    ##
    ## @end deftypefn
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
    
    ## -*- texinfo -*-
    ## @node string.encode
    ## @deftypefn {Method} {@var{out} =} encode (@var{obj}, @var{charsetName})
    ##
    ## Encode string in a given character encoding.
    ##
    ## @var{obj} must be scalar.
    ##
    ## @var{charsetName} (charvec) is the name of a character encoding.
    ## (TODO: Document what determines the set of valid encoding names.)
    ##
    ## Returns the encoded string as a @code{uint8} vector.
    ##
    ## See also: @ref{string.decode}.
    ##
    ## @end deftypefn
    function out = encode (this, charsetName)
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
    
    ## -*- texinfo -*-
    ## @node string.strlength_bytes
    ## @deftypefn {Method} {@var{out} =} strlength_bytes (@var{obj})
    ##
    ## String length in bytes.
    ##
    ## Gets the length of each string in @var{obj}, counted in Unicode UTF-8
    ## code units (bytes). This is the same as @code{numel(str)} for the corresponding
    ## Octave char vector for each string, but may not be what you 
    ## actually want to use. You may want @code{strlength} instead.
    ##
    ## Returns double array of the same size as @var{obj}. Returns NaNs for missing
    ## strings.
    ##
    ## See also: @ref{string.strlength}
    ##
    ## @end deftypefn
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
    
    ## -*- texinfo -*-
    ## @node string.strlength
    ## @deftypefn {Method} {@var{out} =} strlength (@var{obj})
    ##
    ## String length in characters.
    ##
    ## Gets the length of each string, counted in Unicode characters (code
    ## points). This is the string length method you probably want to use,
    ## not @code{strlength_bytes}.
    ##
    ## Returns double array of the same size as @var{obj}. Returns NaNs for missing
    ## strings.
    ##
    ## See also: @ref{string.strlength_bytes}
    ##
    ## @end deftypefn
    function out = strlength(this)
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
    
    ## -*- texinfo -*-
    ## @node string.reverse_bytes
    ## @deftypefn {Method} {@var{out} =} reverse_bytes (@var{obj})
    ##
    ## Reverse string, byte-wise.
    ##
    ## Reverses the bytes in each string in @var{obj}. This operates on bytes
    ## (Unicode code units), not characters.
    ##
    ## This may well produce invalid strings as a result, because reversing a
    ## UTF-8 byte sequence does not necessarily produce another valid UTF-8
    ## byte sequence.
    ##
    ## You probably do not want to use this method. You probably want to use
    ## @code{string.reverse} instead.
    ##
    ## Returns a string array the same size as @var{obj}.
    ##
    ## See also: @ref{string.reverse}
    ##
    ## @end deftypefn
    function out = reverse_bytes (this)
      out = this;
      for i = 1:numel (this)
        out.strs{i} = out.strs{i}(end:-1:1);
      endfor
    endfunction
    
    ## -*- texinfo -*-
    ## @node string.reverse
    ## @deftypefn {Method} {@var{out} =} reverse (@var{obj})
    ##
    ## Reverse string, character-wise.
    ##
    ## Reverses the characters in each string in @var{obj}. This operates on
    ## Unicode characters (code points), not on bytes, so it is guaranteed
    ## to produce valid UTF-8 as its output.
    ##
    ## Returns a string array the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = reverse(this)
      out = this;
      % Transcode to UTF-32 (since UTF-32 is a fixed-width encoding), 
      % reverse that, and transcode back to original encoding
      for i = 1:numel (this)
        if this.tfMissing(i)
          continue
        endif
        bytes = encode (this(i), 'UTF-32LE');
        utf32 = typecast (bytes, 'uint32');
        utf32_reverse = utf32(end:-1:1);
        bytes2 = typecast (utf32_reverse, 'uint8');
        java_str = javaObject ('java.lang.String', bytes2, 'UTF-32LE');
        reversed = char (java_str);
        out.strs{i} = reversed;
      endfor
    endfunction
    
    ## -*- texinfo -*-
    ## @node string.strcat
    ## @deftypefn {Method} {@var{out} =} strcat (@var{varargin})
    ##
    ## String concatenation.
    ##
    ## Concatenates the corresponding elements of all the input arrays,
    ## string-wise. Inputs that are not string arrays are converted to
    ## string arrays.
    ##
    ## The semantics of concatenating missing strings with non-missing
    ## strings has not been determined yet.
    ##
    ## Returns a string array the same size as the scalar expansion of its
    ## inputs.
    ##
    ## @end deftypefn
    function out = strcat (varargin)
      % TODO: Fix missing handling
      args = promotec (varargin);
      args_strs = cell (size (args));
      args_tfMissing = cell (size (args));
      for i = 1:numel (args2)
        args_strs{i} = args{i}.strs;
        args_tfMissing{i} = args{i}.tfMissing;
      endfor
      out = string (strcat (args_strs{:}));
      % TODO: I think this is wrong: it doesn't handle scalar expansion
      % TODO: Actually, this is completely wrong. Then inputs should be ORed
      % or something like that, not concatenated.
      out.tfMissing = cat (2, args_tfMissing{:});
    endfunction

    ## -*- texinfo -*-
    ## @node string.lower
    ## @deftypefn {Method} {@var{out} =} lower (@var{obj})
    ##
    ## Convert to lower case.
    ##
    ## Converts all the characters in all the strings in @var{obj} to lower case.
    ##
    ## This currently delegates to Octave’s own @code{lower()} function to
    ## do the conversion, so whatever character class handling it has, this
    ## has.
    ##
    ## Returns a string array of the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = lower (this)
      out = this;
      % TODO: This lower() call is probably wrong: it relies on Octave's lower(),
      % which I think only does ASCII case conversion, not Unicode case conversion. -apj
      out.strs = lower (this.strs);
    endfunction
    
    ## -*- texinfo -*-
    ## @node string.upper
    ## @deftypefn {Method} {@var{out} =} upper (@var{obj})
    ##
    ## Convert to upper case.
    ##
    ## Converts all the characters in all the strings in @var{obj} to upper case.
    ##
    ## This currently delegates to Octave’s own @code{upper()} function to
    ## do the conversion, so whatever character class handling it has, this
    ## has.
    ##
    ## Returns a string array of the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = upper (this)
      out = this;
      % TODO: This upper() call is probably wrong: it relies on Octave's upper(),
      % which I think only does ASCII case conversion, not Unicode case conversion. -apj
      out.strs = upper (this.strs);
    endfunction
    
    ## -*- texinfo -*-
    ## @node string.erase
    ## @deftypefn {Method} {@var{out} =} erase (@var{obj}, @var{match})
    ##
    ## Erase matching substring.
    ##
    ## Erases the substrings in @var{obj} which match the @var{match} input.
    ##
    ## Returns a string array of the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = erase (this, match)
      [this, match] = promote (this, match);
      out = this;
      out.strs = strrep (this.strs, char(match), '');
    endfunction
    
    ## -*- texinfo -*-
    ## @node string.strrep
    ## @deftypefn {Method} {@var{out} =} strrep (@var{obj}, @var{match}, @var{replacement})
    ## @deftypefnx {Method} {@var{out} =} strrep (@dots{}, @var{varargin})
    ##
    ## Replace occurrences of pattern with other string.
    ##
    ## Replaces matching substrings in @var{obj} with a given replacement string.
    ##
    ## @var{varargin} is passed along to the core Octave @code{strrep} function. This
    ## supports whatever options it does.
    ## TODO: Maybe document what those options are.
    ##
    ## Returns a string array of the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = strrep (this, match, replacement, varargin)
      [this, match, replacement] = promote (this, match, replacement);
      out = this;
      out.strs = strrep(this.strs, char(match), char(replacement), varargin{:});
    endfunction

    ## -*- texinfo -*-
    ## @node string.strfind
    ## @deftypefn {Method} {@var{out} =} strfind (@var{obj}, @var{pattern})
    ## @deftypefnx {Method} {@var{out} =} strfind (@dots{}, @var{varargin})
    ##
    ## Find pattern in string.
    ##
    ## Finds the locations where @var{pattern} occurs in the strings of @var{obj}.
    ##
    ## TODO: It’s ambiguous whether a scalar this should result in a numeric
    ## out or a cell array out.
    ##
    ## Returns either an index vector, or a cell array of index vectors.
    ##
    ## @end deftypefn
    function out = strfind(this, pattern, varargin)
      [this, pattern] = promote (this, pattern);
      out = strfind(this.strs, char(pattern), varargin{:});
      out(this.tfMissing) = {[]};
    endfunction
    
    ## -*- texinfo -*-
    ## @node string.regexprep
    ## @deftypefn {Method} {@var{out} =} regexprep (@var{obj}, @var{pat}, @var{repstr})
    ## @deftypefnx {Method} {@var{out} =} regexprep (@dots{}, @var{varargin})
    ##
    ## Replace based on regular expression matching.
    ##
    ## Replaces all the substrings matching a given regexp pattern @var{pat} with
    ## the given replacement text @var{repstr}.
    ##
    ## Returns a string array of the same size as @var{obj}.
    ##
    ## @end deftypefn
    function out = regexprep(this, pat, repstr, varargin)
      [this, pat, repstr] = promote (this, pat, repstr);
      args = demote_strings(varargin);
      out = this;
      out.strs = regexprep(this.strs, char(pat), char(repstr), args{:});
    endfunction
    
    % Relational operations
    
    function out = eq (A, B)
      %EQ Equals.
      out = strcmp (A, B);
    endfunction
    
    ## -*- texinfo -*-
    ## @node string.strcmp
    ## @deftypefn {Method} {@var{out} =} strcmp (@var{A}, @var{B})
    ##
    ## String comparison.
    ##
    ## Tests whether each element in A is exactly equal to the corresponding
    ## element in B. Missing values are not considered equal to each other.
    ##
    ## This does the same comparison as @code{A == B}, but is not polymorphic.
    ## Generally, there is no reason to use @code{strcmp} instead of @code{==}
    ## or @code{eq} on string arrays, unless you want to be compatible with
    ## cellstr inputs as well.
    ##
    ## Returns logical array the size of the scalar expansion of A and B.
    ##
    ## @end deftypefn
    function out = strcmp (A, B)
      [A, B] = promote (A, B);
      [A, B] = scalarexpand (A, B);
      out = strcmp (A.strs, B.strs);
      out(A.tfMissing | B.tfMissing) = false;
    endfunction
    
    ## -*- texinfo -*-
    ## @node string.cmp
    ## @deftypefn {Method} {[@var{out}, @var{outA}, @var{outB}] =} cmp (@var{A}, @var{B})
    ##
    ## Value ordering comparison, returning -1/0/+1.
    ##
    ## Compares each element of @var{A} and @var{B}, returning for
    ## each element @code{i} whether @code{A(i)} was less than (-1),
    ## equal to (0), or greater than (1) the corresponding @code{B(i)}.
    ##
    ## TODO: What to do about missing values? Should missings sort to the end
    ## (preserving total ordering over the full domain), or should their comparisons
    ## result in a fourth "null"/"undef" return value, probably represented by NaN?
    ## FIXME: The current implementation does not handle missings.
    ##
    ## Returns a numeric array @var{out} of the same size as the scalar expansion
    ## of @var{A} and @var{B}. Each value in it will be -1, 0, or 1.
    ##
    ## Also returns scalar-expanded copies of @var{A} and @var{B} as @var{outA} and
    ## @var{outB}, as a programming convenience.
    ##
    ## @end deftypefn
    function [out, A, B] = cmp(A, B)
      [A, B] = promote (A, B);
      % In production code, you wouldn't scalarexpand; you'd do a scalar test
      % and smarter indexing.
      % Though really, in production code, you'd probably want to implement this
      % whole function as a built-in or oct-file.
      [A, B] = scalarexpand (A, B);
      out = NaN (size (A));
      for i = 1:numel (A)
        a = A.strs{i};
        b = B.strs{i};
        if isequal (a, b)
          out(i) = 0;
        else
          % This implementation is gross, but it's the best I can do with what
          % the base language provides. - apj
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
      [cmpval, A, B] = cmp (A, B);
      out = cmpval < 0;
      out = propagate_missing (out, A, B);
    endfunction

    function out = le (A, B)
      %LE Less than or equal.
      [cmpval, A, B] = cmp (A, B);
      out = cmpval <= 0;
      out = propagate_missing (out, A, B);
    endfunction

    function out = gt(A, B)
      %GT Greater than.
      [cmpval, A, B] = cmp (A, B);
      out = cmpval > 0;
      out = propagate_missing (out, A, B);
    endfunction

    function out = ge (A, B)
      %GE Greater than or equal.
      [cmpval, A, B] = cmp (A, B);
      out = cmpval >= 0;
      out = propagate_missing (out, A, B);
    endfunction
    
    % TODO: max, min

    function [out, Indx] = ismember (a, b, varargin)
      %ISMEMBER True for set member.
      [a, b] = promote (a, b);
      [out, Indx] = ismember (a.strs, b.strs, varargin{:});
      out(a.tfMissing) = false;
      Indx(a.tfMissing) = 0;
    endfunction
    
    function [out, Indx] = setdiff (a, b, varargin)
      %SETDIFF Set difference.
      %
      % TODO: Handle missings.
      [a, b] = promote (a, b);
      [s_out, Indx] = setdiff (a.strs, b.strs, varargin{:});
      out = string (s_out);
    endfunction

    function [out, ia, ib] = intersect (a, b, varargin)
      %INTERSECT Set intersection.
      %
      % TODO: Handle missings.
      [a, b] = promote (a, b);
      [s_out, ia, ib] = intersect (a.strs, b.strs, varargin{:});
      out = string (s_out);
    endfunction
    
    function [out, ia, ib] = union (a, b, varargin)
      %UNION Set union.
      %
      % TODO: Handle missings.
      [a, b] = promote (a, b);
      [s_out, ia, ib] = union (a.strs, b.strs, varargin{:});
      out = string (s_out);
    endfunction

    function [out, Indx] = unique (this, varargin)
      %UNIQUE Set unique.
      %
      % TODO: Handle missings.
      this = promote (this);
      [s_out, Indx] = unique (this.strs, varargin{:});
      out = string (s_out);
    endfunction

  endmethods
  
  methods (Hidden)
    % Compatibility shims
    
    function out = sprintf (fmt, varargin)
      %SPRINTF Like printf, but returns a string
      %
      % TODO: Handle missings.
      fmt = char (string (fmt));
      args = demote_strings (varargin);
      out = string (sprintf (fmt, args{:}));
    endfunction
    
    function out = fprintf (varargin)
      %FPRINTF Formatted output to stream or file handle
      %
      % TODO: Handle missings.
      args = demote_strings (varargin);
      out = fprintf (args{:});
      if nargout == 0
        clear out
      endif
    endfunction

    function out = printf (varargin)
      %PRINTF Formatted output
      %
      % TODO: Handle missings.
      args = demote_strings( varargin);
      printf (args{:});
      if nargout == 0
        clear out
      endif
    endfunction

    % TODO: fdisp, fputs
    
    % Note: fwrite is not supported, because that is a low-level byte-oriented
    % I/O function, and string is character-oriented.
    
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
    
    function out = size (this, dim)
      %SIZE Size of array.
      if nargin == 1
        out = size (this.strs);
      else
        out = size (this.strs, dim);
      endif
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
      out.tfMissing = cat(dim, fieldArgs2{:});
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
    ## -*- texinfo -*-
    ## @node string.missing
    ## @deftypefn {Static Method} {@var{out} = } string.missing (@var{sz})
    ##
    ## Missing string value.
    ##
    ## Creates a string array of all-missing values of the specified size @var{sz}.
    ## If @var{sz} is omitted, creates a scalar missing string.
    ##
    ## Returns a string array of size @var{sz}.
    ##
    ## @end deftypefn
    function out = missing (sz)
      if nargin < 2
        sz = [1 1];
      endif
      out = repmat (string, sz);
    endfunction
    
    ## -*- texinfo -*-
    ## @node string.decode
    ## @deftypefn {Static Method} {@var{out} =} string.decode (@var{bytes}, @var{charsetName})
    ##
    ## Decode encoded text from bytes.
    ##
    ## Decodes the given encoded text in @var{bytes} according to the specified
    ## encoding, given by @var{charsetName}.
    ##
    ## Returns a scalar string.
    ##
    ## See also: @ref{string.encode}
    ##
    ## @end deftypefn
    function out = decode (bytes, charsetName)
      out = string (char (javaObject ('java.lang.String', bytes, charsetName)));
    end
  end

endclassdef

function out = propagate_missing (out, varargin)
  %PROPAGATE_MISSING Propagate missing values to single output
  %
  % Assumes all inputs are strings, and have been scalar-expanded, and have
  % congruent dimensions.
  for i = 1:numel (varargin)
    arg = varargin{i};
    out.tfMissing = out.tfMissing | arg.tfMissing;
  endfor
endfunction

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
