function unload_tablicious
  % Unload the Tablicious library
  
  pkg_name = "Tablicious";
  
  this_dir = fileparts (fullfile (mfilename ("fullpath")));
  inst_dir = fileparts (fileparts (this_dir));
  shims_dir = fullfile (inst_dir, "shims", "compat");

  % Unregister doco
  
  if exist (fullfile (inst_dir, "doc", [pkg_name ".qch"]), "file")
    qhelp_file = fullfile (inst_dir, "doc", [pkg_name ".qch"]);
  elseif exist (fullfile (fileparts (inst_dir), "doc", [pkg_name ".qch"]), "file")
    qhelp_file = fullfile (fileparts (inst_dir), "doc", [pkg_name ".qch"]);
  else
    % Couldn't find doc file. Oh well.
    qhelp_file = [];
  endif
  
  if ! isempty (qhelp_file)
    if compare_versions (version, "4.4.0", ">=") && compare_versions (version, "6.0.0", "<")
      __octave_link_unregister_doc__ (qhelp_file);
    elseif compare_versions (version, "6.0.0", ">=") && compare_versions (version, "7.1.0", "<")
      __event_manager_unregister_doc__ (qhelp_file);
    elseif compare_versions (version, "7.1.0", ">=")
      __event_manager_unregister_documentation__ (qhelp_file);
    endif
  endif
  
  % Unload compatibility shims
  
  rmpath (fullfile (shims_dir, 'all'));
  if compare_versions (version, "5.0.0", "<")
    rmpath (fullfile (shims_dir, "pre-5.0.0"));
  endif
  if compare_versions (version, "6.0.0", "<")
    rmpath (fullfile (shims_dir, "pre-6.0.0"));
  endif
    
endfunction
