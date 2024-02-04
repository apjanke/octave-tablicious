function ok = tblish_test_tablicious(verbose, exit_on_fail)
#TBLISH_TEST_TABLICIOUS Run all Tablicious MP-Test tests (not the BISTs).
#
# ok = tblish_test_tablicious(verbose, exit_on_fail)
#
# See also: T_RUN_TESTS.

if nargin < 1 || isempty (verbose);      verbose = false;      endif
if nargin < 2 || isempty (exit_on_fail); exit_on_fail = false; endif

my_t_dir = fileparts (mfilename ('fullpath'));

tests = list_mpower_tests_in_dirs (my_t_dir)
all_ok = t_run_tests (tests, verbose);

# Handle success/failure
if exit_on_fail && ~all_ok
    exit (1)
end
if nargout
    success = all_ok;
end

endfunction


function out = list_mpower_tests_in_dirs (dirs)
  # List tests in a dir set, assuming they're functions named "t_*"
  fcns = list_fcns_in_dirs (dirs);
  out = fcns(startsWith (fcns, 't_'));
endfunction

function out = list_fcns_in_dirs (dirs)
  # Lists functions (or classes) implied by M-files in a set of directories.
  dirs = cellstr (dirs);
  out = {};
  for i = 1:numel (dirs)
    d = dirs{i};
    mfiles = list_mfiles_in_dir (d);
    names = regexprep (mfiles, '\.m$', '');
    out = [out; names];
  endfor
endfunction

function out = list_mfiles_in_dir (f)
  files = readdir (f);
  out = files (endsWith (files, '.m'));
endfunction

function emit (fmt, varargin)
  fprintf ([fmt '\n'], varargin{:});
endfunction
