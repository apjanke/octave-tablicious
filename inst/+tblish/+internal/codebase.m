classdef codebase
  # Code for working with the Tablicious code base.

  methods (Static)

    function out = inst_root ()
      # The installation root dir of the Tablicious package.
      #
      # This is the inst/ directory in the source tree, or wherever the files
      # from inst/ ended up in the installed package.
      out = fileparts (fileparts (fileparts (mfilename ("fullpath"))));
    endfunction

  endmethods

endclassdef
