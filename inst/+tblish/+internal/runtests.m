function runtests ()
  # Run the BIST tests in the Tablicious test suite.
  #
  # This is a quick & dirty hack to get the BIST test suite running again now
  # that runtests() has been removed in Octave 8.x. Only works on Linux/macOS
  # for now. Only runs the BISTs, not the MP-Test tests in t/. Has a bug in that
  # it uses Octave's runtests() or oruntests(), which do not recurse in to
  # subdirs, and thus miss most of the BISTS
  #
  # TODO: Make portable to Windows.
  # TODO: Replace (o)runtests with a custom function that recurses into subdirs,
  # displays a summary, and returns results as a data structure.
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
