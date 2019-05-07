## Copyright (C) 1995-2007 R Core Team
## Copyright (C) 2019 Andrew Janke
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; If not, see <http://www.gnu.org/licenses/>.

# This is based on the iris dataset from R’s datasets package

classdef iris < octave.internal.dataset
  % This is the classic Fisher Iris dataset.
  %
  % ## Source
  %
  %  http://archive.ics.uci.edu/ml/datasets/Iris
  %
  % ## References
  %
  % https://en.wikipedia.org/wiki/Iris_flower_data_set
  %
  % [1] Fisher,R.A. "The use of multiple measurements in taxonomic problems" 
  %        Annual Eugenics, 7, Part II, 179-188 (1936); also in "Contributions 
  %        to Mathematical Statistics" (John Wiley, NY, 1950).
  % [2] Duda,R.O., & Hart,P.E. (1973) Pattern Classification and Scene Analysis. 
  %        (Q327.D83) John Wiley & Sons. ISBN 0-471-22361-1. See page 218.

  methods

    function this = iris
      this.name = "iris";
      this.summary = "The Fisher Iris dataset: measurements of various flowers";
    endfunction

    function out = load (this)
      my_dir = fileparts (mfilename ("fullpath"));
      mat_file = fullfile (my_dir, "iris.mat");
      s = load (mat_file);
      tbl = struct2table (s.iris);
      out.iris = tbl;
    endfunction

    function regenerate_dataset
      %REGENERATE_DATASET Regenerate this dataset
      %
      % Reconstructs the Fisher Iris dataset.
      %
      % Source: http://archive.ics.uci.edu/ml/datasets/Iris
      %
      % References:
      %   https://en.wikipedia.org/wiki/Iris_flower_data_set
      
      csv_url = "http://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data";
      urlwrite (csv_url, "iris.csv");
      fid = fopen ("iris.csv");
      RAII.fid = onCleanup (@() fclose (fid));
      
      data = textscan (fid, "%f,%f,%f,%f,%s");
      
      species = strrep (data{5}, 'Iris-', '');
      
      s.Species = species;
      s.SepalLength = data{1};
      s.SepalWidth = data{2};
      s.PetalLength = data{3};
      s.PetalWidth = data{4};
      
      iris = s;
      
      my_dir = fileparts (mfilename ("fullpath"));
      mat_file = fullfile (my_dir, "iris.mat");
      if exist (mat_file, "file")
        delete (mat_file);
      endif
      save (mat_file, "iris");
    endfunction

  endmethods

endclassdef