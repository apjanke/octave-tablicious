function ok = tblish_mptest_tablicious(verbose, exit_on_fail)
#TBLISH_MPTEST_TABLICIOUS Run all the Tablicious MP-Test tests (not the BISTs).
#
# ok = tblish_mptest_tablicious(verbose, exit_on_fail)
#
# See also: T_RUN_TESTS, TBLISH.INTERNAL.RUNTESTS.

if nargin < 1 || isempty (verbose);      verbose = false;      endif
if nargin < 2 || isempty (exit_on_fail); exit_on_fail = false; endif

my_t_dir = fileparts (mfilename ('fullpath'));

tests = list_mpower_tests_in_dirs (my_t_dir);
all_ok = t_run_tests (tests, verbose);

# Handle success/failure
if ~all_ok
  # Emit all-caps "FAIL" so Tablicious's runtests.sh parsing can detect failure.
  printf ('FAILED: Failed some MP-Test tests\n')
  if exit_on_fail
    exit (1)
  endif
endif

if nargout
  success = all_ok;
endif

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
