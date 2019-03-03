function out = isnanny (x)
  %ISNANNY Test if elements are NaN or NaN-like
  %
  % Tests if input elements are NaN, NaT, or otherwise NaN-like. This is true
  % if isnan() or isnat() returns true, and is false for types that do not support
  % isnan() or isnat().
  %
  % This function only exists because:
  %
  % a) Matlab decided to call their NaN values for datetime "NaT" instead, and
  % test for them with a different "isnat()" function, and
  % b) isnan() errors out for some types that do not support isnan(), like cells.
  %
  % isnanny() smooths over those differences so you can call it polymorphically on
  % any input type.
  %
  % Under normal operation, isnanny() should not throw an error for any type or
  % value of input.
  %
  % The function name "isnanny" should be read as "is NaN-y" (that is, "is like a
  % NaN"), not "is nanny" (that is, "is like someone who is hired to take care of
  % young children").
  %
  % See also: ISNAN, ISNAT, ISMISSING, EQN, ISEQUALN
  
  if isnumeric (x)
    out = isnan (x);
  elseif isa (x, 'datetime')
    out = isnat (x);
  elseif isa (x, 'duration') || isa (x, 'calendarDuration')
    out = isnan (x);
  elseif isobject (x)
    % A check using ismember ('isnan', methods (x)) is currently broken because 
    % methods() doesn't work right on classdef objects. So use an ugly try/catch
    % instead.
    % TODO: Maybe we could use meta.class.fromName() and check its methods list
    % instead?
    try
      out = isnan (x);
      return
    catch
      % quash
    end_try_catch
    try
      out = isnat (x);
      return
    catch
      % quash
    end_try_catch
    out = false (size (x));
  else
    out = false (size (x));
  endif
endfunction
