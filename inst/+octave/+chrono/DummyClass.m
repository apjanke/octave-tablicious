## Copyright (C) 2019 Andrew Janke <floss@apjanke.net>
##
## This file is part of Octave.
##
## Octave is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## Octave is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with Octave; see the file COPYING.  If not, see
## <https://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftp {Class} DummyClass
##
## @code{DummyClass} is a do-nothing class just for testing the doco tools.
##
## Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur 
## ullamcorper pulvinar ligula, sit amet accumsan turpis dapibus at. 
## Ut sit amet quam orci. Donec vel mauris elementum massa pretium tincidunt. 
##
## @end deftp
##
## @deftypeivar DummyClass @code{double} x
##
## A x. Has no semantics.
##
## @end deftypeivar
##
## @deftypeivar DummyClass @code{double} y
##
## A y. Has no semantics.
##
## @end deftypeivar

classdef DummyClass

  properties
    x
    y
  endproperties

  methods
    ## -*- texinfo -*-
    ## @node DummyClass.DummyClass
    ## @deftypefn {Constructor} {@var{obj} =} octave.chrono.DummyClass ()
    ##
    ## Constructs a new scalar @code{DummyClass} with default values.
    ##
    ## @end deftypefn
    ##
    ## @deftypefn {Constructor} {@var{obj} =} octave.chrono.DummyClass (@var{x}, @var{y})
    ##
    ## Constructs a new @code{DummyClass} with the specified values.
    ##
    ## @end deftypefn
    function this = DummyClass (varargin)
    endfunction

    ## -*- texinfo -*-
    ## @node DummyClass.foo
    ## @deftypefn {Method} {@var{out} =} foo (@var{obj})
    ##
    ## Computes a foo value.
    ##
    ## Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur 
    ## ullamcorper pulvinar ligula, sit amet accumsan turpis dapibus at. 
    ## Ut sit amet quam orci. Donec vel mauris elementum massa pretium tincidunt.
    ##
    ## @end deftypefn
    function out = foo (this)
      out = this.x;
    endfunction
    
    ## -*- texinfo -*-
    ## @node DummyClass.bar
    ## @deftypefn {Method} {@var{out} =} bar (@var{obj})
    ##
    ## Computes a bar value.
    ##
    ## Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur 
    ## ullamcorper pulvinar ligula, sit amet accumsan turpis dapibus at. 
    ## Ut sit amet quam orci. Donec vel mauris elementum massa pretium tincidunt.
    ##
    ## @end deftypefn
    function out = bar (this)
      out = this.y;
    endfunction

  endmethods
endclassdef