function out = ismissing (x, indicator)
  %ISMISSING Find missing values
  %
  % tf = ismissing (x)
  % tf = ismissing (x, indicator)
  %
  % Determines which elements of x contain missing values. If an indicator input is
  % not provided, standard missing values depending on the input type of x are
  % used.
  %
  % Standard missing values depend on the data type:
  %   * NaN for double, single
  %   * NaT for datetime
  %   * ' ' for char
  %   * {''} for cellstrs
  %   * Integer types have no standard missing value; they are not considered missing.
  %   * Other types have no standard missing value; it is currently an error to
  %     call ismissing() on them.
  %     * TODO: Determine whether this should really be an error, or if it should
  %       default to never considering those types as missing.
  %   * TODO: Decide whether, for classdef objects, ismissing() should polymorphically
  %     detect isnan()/isnat()/isnanny() methods and use those, or whether we should
  %     require classes to override ismissing() itself.
  %
  % If indicator is supplied, it is an array containing multiple values of the same
  % type as x, all of which are considered to be missing values.
  % TODO: The comparison method for indicator is currently not implemented, because
  % of the complication of testing for NaN and similar values using generic functions
  % like eq or ismember.
  % 
  % Table defines its own ismissing() methods which respects individual variables'
  % data types; see TABLE.ISMISSING.
  
  % Developer's note: This is very similar in semantics to isnanny(); see if they
  % can be reconciled and/or merged.
  
  if nargin > 1
    error ('ismissing: indicator option support is not implemented');
  endif
  
  out = ismissing_standard (x);
  
endfunction

function out = ismissing_standard (x)
  if isnumeric (x)
    out = isnan (x);
  elseif isa (x, 'datetime')
    out = isnat (x);
  elseif isa (x, 'duration') || isa (x, 'calendarDuration')
    out = isnan (x);
  elseif ischar (x)
    %TODO: Is this right? Or should it treat char arrays as lists of strings and
    %do blank-padding-aware string comparisons?
    out = x == ' ';
  elseif iscell (x)
    if iscellstr (x)
      out = strcmp (x, {''});
    else
      error ('ismissing: cells which are not cellstrs are not supported');
    endif
  else
    error ('ismissing: input type %s is not supported', class (x));
  endif
endfunction
