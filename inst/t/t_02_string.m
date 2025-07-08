# Covered by the 3-clause BSD License (see LICENSES/LICENSE-MATPOWER file for details).
#
# Copyright (c) 2025, Andrew Janke

function obj = t_02_string (quiet)
# Tests for string array.

if nargin < 1 || isempty (quiet);   quiet = false;  endif

verbose = ! quiet;

# Test fixtures

# strlength tests

# scalars: { str, strlen; ...}
fixture_1 = {
  ''      0
  'a'     1
  'aa'    2
  'aaa'   3
  'aaaa'  4
  'aaaaa'   5
};

# nonscalars: { strs, strlens; ...}
fixture_2 = {
  {''}      [0]
  {'a'}     [1]
  {'a', 'aa', 'aaa', ''}    [1, 2, 3, 0]
};

# Run strlength tests

t_begin (size (fixture_1, 1) + size (fixture_2, 1), quiet);

# scalar strlength tests

max_prec = 16;
for i_test = 1:size (fixture_1, 1)
  [str_c, exp_len] = fixture_1{i_test,:};
  str = string (str_c);
  t_is (strlength (str), exp_len, max_prec, sprintf ('strlength ("%s")\n', str_c));
endfor

# nonscalar strlength tests

for i_test = 1:size (fixture_2, 1)
  [strs_c, exp_len] = fixture_1{i_test,:};
  strs = string (strs_c);
  t_is (strlength (strs), exp_len, max_prec, sprintf ('strlength (<item %d>)\n', i_test));
endfor

# Wrap up

if nargout
  obj = T;
endif

t_end;

endfunction
