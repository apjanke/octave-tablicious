function runtests ()
  # Run the tests in the Tablicious test suite.
  #
  # This runs all the tests in the Tablicious package's test suite, and is the
  # main entry point for running tests.
  #
  # Test results are printed to the console. The results are not returned as
  # a data structure or status code.
  #
  # This will always run the BIST tests. In addition, if you have the MP-Test
  # library from MATPOWER loaded, it will run the MP-Test suite. If MP-Test
  # is not available, it will display a message and skip the MP-Test tests.
  #
  # Prerequisite: "make local" (octave_tablicious_make_local) must have been
  # run on this package. Otherwise, you will get failures in the tests on
  # datetime and other classes which depend on oct-files.

  run_bist_tests
  if is_mptest_loaded
    run_mptest_tests;
  else
    printf ('Skipped MP-Test tests because MP-Test is not loaded.\n');
  endif

endfunction

function run_bist_tests ()
  # Run the BIST tests in the Tablicious test suite.
  #
  # This is a quick & dirty hack to get the BIST test suite running again now
  # that runtests() has been removed in Octave 8.x. Only works on Linux/macOS
  # for now. Only runs the BISTs, not the MP-Test tests in t/.
  run_discoverable_bist_tests
  run_other_bist_tests
endfunction

function run_discoverable_bist_tests ()
  # Run the BIST tests that are discoverable by Octave's (o)runtests.
  #
  # This uses Octave's runtests() or oruntests(), which do not recurse in
  # to subdirs, and thus miss most of the BISTs. And they also don't return the
  # test results as a data structure, only printing to the console, so you can't
  # easily programmatically see if any tests failed and do something about that.
  #
  # See the dev-tools/runtests.sh wrapper script in the Tablicious repo for a
  # basic wrapper that will report test failures.
  #
  # TODO: Make my_runtests portable to Windows?
  # TODO: Replace (o)runtests with a custom function that recurses into subdirs,
  # displays a summary, and returns results as a data structure? The test()
  # function does return result status.
  printf ('Running discoverable BIST tests\n');
  inst_dir = fileparts (fileparts (fileparts (mfilename ('fullpath'))));
  w1 = which ('oruntests');
  w2 = which ('runtests');
  if ~isempty (w1)
    % Newer Octave which has runtests: use it
    oruntests (inst_dir);
  elseif ~isempty (w2)
    % Older Octave which has runtests: use it
    runtests (inst_dir);
  else
    % Neither oruntests or runtests: hack together our own runtests analog.
    % Don't know if any Octave versions actually lack both runtests functions,
    % but I already wrote this code so I think I'll leave it in place for now.
    % Will probably want to expand that later to a richer version of oruntests
    % that returns results as a data structure instead of just printing them,
    % and also recurses into subdirs for packages & classes, which oruntests
    % does not.
    if ~isunix
      error ('tblish.internal.runtests does not work on Windows on Octave 8.x and later. Sorry.')
    else
      my_runtests (inst_dir);
    endif
  endif
endfunction

function run_other_bist_tests ()
  # Run the BIST test which are not discoverable by (o)runtests.
  printf ('Running additional BIST tests\n');
  files_with_tests = {
    '@datetime/datetime.m'
    '@duration/duration.m'
    '@string/string.m'
  };
  for i = 1:numel (files_with_tests)
    file = files_with_tests{i};
    printf ('Testing %s\n', file);
    test (file)
  endfor
endfunction

function my_runtests (test_dir)
  orig_cd = pwd;
  unwind_protect
    # We can't use cd here, because cd-ing in and out of inst/ triggers the package
    # load/unload code in PKG_ADD/PKG_DEL, which is non reentrant, and will leave the
    # package unloaded when you go to actually run the tests.
    # cd (test_dir);
    [ok, txt] = system (sprintf ("find '%s' -type f -name '*.m'", test_dir));
    if ok ~= 0
      error (['tblish.internal.runtests failed locating files to test with `find`. ' ...
        'Exit status: %d. Error: %s'], ok, txt)
    endif
    mfiles = regexprep (strsplit (txt), '^\./', '');
    mfiles(end) = [];
    for i_file = 1:numel (mfiles)
      # Just use interactive mode, because capturing argouts suppresses result display
      # [n, nmax, nxfail, nbug, nskip, nrtskip, nregression] = test (mfiles{i_file});
      test (mfiles{i_file})
    endfor
  unwind_protect_cleanup
    cd (orig_cd);
  end_unwind_protect
endfunction

function run_mptest_tests ()
  printf ('Running MP-Test tests\n');

  if isempty (which ('tblish_mptest_tablicious'))
    mptest_t_dir = fullfile (tblish.internal.codebase.inst_root, 't');
    do_addpath = true;
  else
    do_addpath = false;
  endif

  unwind_protect
    if do_addpath
      addpath (mptest_t_dir);
    endif
    tblish_mptest_tablicious
  unwind_protect_cleanup
    if do_addpath
      rmpath (mptest_t_dir);
    endif
  end_unwind_protect

endfunction

function out = is_mptest_loaded ()
  out = ~isempty (which ('t_run_tests'));
endfunction
