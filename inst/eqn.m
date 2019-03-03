function out = eqn (A, B)
  %EQN Determine element-wise equality, treating NaNs as equal
  %
  % out = eqn (A, B)
  %
  % EQN is just like EQ (the function that implements the == operator), except
  % that it considers NaN and NaN-like values to be equal. This is the element-wise
  % equivalent of ISEQUALN.
  %
  % EQN uses ISNANNY to test for NaN and NaN-like values, which means that NaNs
  % and NaTs are considered to be NaN-like, and it is still TBD whether string
  % and categorical objects' "missing" values will be considered equal.
  %
  % This is an Octave extension.
  %
  % See also: EQ, ISEQUALN, ISNANNY
  
  % Developer's note: the name is a little unfortunate because "eqn" could also
  % be an abbreviation for "equation", but this name follows the ISEQUALN pattern
  % of appending an "N" to the corresponding non-NaN-aware function.
  
  out = A == B;
  out(isnanny (A) & isnany (B)) = true;

endfunction
