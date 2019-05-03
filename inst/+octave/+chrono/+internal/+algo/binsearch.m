function [tf, loc] = binsearch (needles, haystack)
  %BINSEARCH Binary search
  %
  % [tf, loc] = binsearch (needles, haystack)
  %
  % Searches for needles in haystack. Needles and haystack must both be doubles.
  % Haystack must be a sorted vector. (The sortedness is not checked, for speed:
  % if it is not sorted, you will just get wrong answers instead of raising an
  % error.
  %
  % This does the same thing as ismember(), but is faster for large inputs, with
  % an additional restriction that the array to search through must be sorted.
  %
  % The input type must have a total ordering over the values present in needles
  % and haystack. That means you can't pass in NaNs or anything that behaves 
  % like them.
  %
  % Returns arrays the same size as needles. tf is a logical array indicating
  % whether each element was found. loc is an array of indexes, either where it
  % was found, or if not found, -1 * the index of the element where it should be
  % inserted; that is, the index of the first element larger than it, or one past
  % the end of the array if it is larger than all the elements in the haystack.
  
  if ~isvector (haystack) && ~isempty (haystack)
    error ('haystack must be a vector or empty');
  end
  if ~isequal (class (needles), class (haystack))
    error ('needles and haystack must be same type; got %s and %s', ...
      class (needles), class (haystack));
  end
  
  % Use exact type test to avoid false-positives from objects overriding isnumeric()
  numeric_types = {'double' 'single' 'int8' 'int16' 'int32' 'int64' ...
    'uint8' 'uint16' 'uint32' 'uint64'};
  is_numeric = ismember (class (needles), numeric_types);
  
  if is_numeric
    if iscomplex (needles) || iscomplex (haystack)
      error ('Complex values are not supported');
    end
    loc = double (__oct_time_binsearch__ (needles, haystack));
  else
    loc = binsearch_mcode (needles, haystack);
  end
  tf = loc > 0;
end

function out = binsearch_mcode (vals, arr)
  %BINSEARCH_MCODE Native M-code implementation of binsearch
  out = NaN (size (vals));
  for i_val = 1:numel (vals)
    val = vals(i_val);
    low = 1;
    high = numel (arr);
    found = false;
    while low <= high
      mid = floor ((low + high) / 2);
      if arr(mid) > val
        high = mid - 1;
      elseif arr(mid) < val
        low = mid + 1;
      elseif arr(mid) == val
          found = true;
          out(i) = mid;
          break;
      else
        error('Total ordering violation: neither <, >, nor == was true for this value.');
      end
    end
    if ~found
      out(i) = -1 * low;
    end
  end
end
