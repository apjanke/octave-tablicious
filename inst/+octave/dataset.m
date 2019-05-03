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

## -*- texinfo -*-
## @deftp {Class} dataset
##
## The @code{dataset} class provides convenient access to the various
## datasets included with Tablicious.
##
## This class just contains a bunch of static methods, each of which loads
## the dataset of that name. It’s provided so you can use tab completion
## on the dataset list.
##
## @end deftp
classdef dataset

  methods (Static)

    ## -*- texinfo -*-
    ## @node dataset.AirPassengers
    ## @deftypefn {Static Method} {@var{out} =} AirPassengers ()
    ##
    ## Monthly Airline Passenger Numbers 1949-1960
    ##
    ## @end deftypefn
    function out = AirPassengers ()
      name = 'AirPassengers';
      out = tablicious.datasets.load(name);
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.airmiles
    ## @deftypefn {Static Method} {@var{out} =} airmiles ()
    ##
    ## Passenger Miles on Commercial US Airlines, 1937-1960
    ##
    ## @end deftypefn
    function out = airmiles ()
      name = 'airmiles';
      out = tablicious.datasets.load(name);
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.beavers
    ## @deftypefn {Static Method} {@var{out} =} beavers ()
    ##
    ## Body Temperature Series of Two Beavers
    ##
    ## @end deftypefn
    function out = beavers ()
      name = 'beavers';
      out = tablicious.datasets.load(name);
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.iris
    ## @deftypefn {Static Method} {@var{out} =} iris ()
    ##
    ## The Fisher Iris set: measurements for various flowers
    ##
    ## @end deftypefn
    function out = iris ()
      name = 'iris';
      out = tablicious.datasets.load(name);
    endfunction

  endmethods

endclassdef