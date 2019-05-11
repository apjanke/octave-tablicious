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
    ## @node dataset.airmiles
    ## @deftypefn {Static Method} {@var{out} =} airmiles ()
    ##
    ## Passenger Miles on Commercial US Airlines, 1937-1960
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = airmiles ()
      name = 'airmiles';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.AirPassengers
    ## @deftypefn {Static Method} {@var{out} =} AirPassengers ()
    ##
    ## Monthly Airline Passenger Numbers 1949-1960
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = AirPassengers ()
      name = 'AirPassengers';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.airquality
    ## @deftypefn {Static Method} {@var{out} =} airquality ()
    ##
    ## New York Air Quality Measurements from 1973
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = airquality ()
      name = 'airquality';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.anscombe
    ## @deftypefn {Static Method} {@var{out} =} anscombe ()
    ##
    ## Anscombe’s Quartet of “Identical” Simple Linear Regressions
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = anscombe ()
      name = 'anscombe';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.attenu
    ## @deftypefn {Static Method} {@var{out} =} attenu ()
    ##
    ## Joyner-Boore Earthquake Attenuation Data
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = attenu ()
      name = 'attenu';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.attitude
    ## @deftypefn {Static Method} {@var{out} =} attitude ()
    ##
    ## The Chatterjee-Price Attitude Data
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = attitude ()
      name = 'attitude';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.austres
    ## @deftypefn {Static Method} {@var{out} =} austres ()
    ##
    ## Australian Population
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = austres ()
      name = 'austres';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.beavers
    ## @deftypefn {Static Method} {@var{out} =} beavers ()
    ##
    ## Body Temperature Series of Two Beavers
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = beavers ()
      name = 'beavers';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.BJsales
    ## @deftypefn {Static Method} {@var{out} =} BJsales ()
    ##
    ## Sales Data with Leading Indicator
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = BJsales ()
      name = 'BJsales';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.BOD
    ## @deftypefn {Static Method} {@var{out} =} BOD ()
    ##
    ## Biochemical Oxygen Demand
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = BOD ()
      name = 'BOD';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.cars
    ## @deftypefn {Static Method} {@var{out} =} cars ()
    ##
    ## Speed and Stopping Distances of Cars
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = cars ()
      name = 'cars';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.ChickWeight
    ## @deftypefn {Static Method} {@var{out} =} ChickWeight ()
    ##
    ## Weight versus age of chicks on different diets
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = ChickWeight ()
      name = 'ChickWeight';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.chickwts
    ## @deftypefn {Static Method} {@var{out} =} chickwts ()
    ##
    ## Chicken Weights by Feed Type
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = chickwts ()
      name = 'chickwts';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.co2
    ## @deftypefn {Static Method} {@var{out} =} co2 ()
    ##
    ## Mauna Loa Atmospheric CO2 Concentration
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = co2 ()
      name = 'co2';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.crimtab
    ## @deftypefn {Static Method} {@var{out} =} crimtab ()
    ##
    ## Student’s 3000 Criminals Data
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = crimtab ()
      name = 'crimtab';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.cupcake
    ## @deftypefn {Static Method} {@var{out} =} cupcake ()
    ##
    ## Google Search popularity for "cupcake", 2004-2019
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = cupcake ()
      name = 'cupcake';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.discoveries
    ## @deftypefn {Static Method} {@var{out} =} discoveries ()
    ##
    ## Yearly Numbers of Important Discoveries
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = discoveries ()
      name = 'discoveries';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.DNase
    ## @deftypefn {Static Method} {@var{out} =} DNase ()
    ##
    ## Elisa assay of DNase
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = DNase ()
      name = 'DNase';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.esoph
    ## @deftypefn {Static Method} {@var{out} =} esoph ()
    ##
    ## Smoking, Alcohol and Esophageal Cancer
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = esoph ()
      name = 'esoph';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.euro
    ## @deftypefn {Static Method} {@var{out} =} euro ()
    ##
    ## Conversion Rates of Euro Currencies
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = euro ()
      name = 'euro';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.eurodist
    ## @deftypefn {Static Method} {@var{out} =} eurodist ()
    ##
    ## Distances Between European Cities and Between US Cities
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = eurodist ()
      name = 'eurodist';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.EuStockMarkets
    ## @deftypefn {Static Method} {@var{out} =} EuStockMarkets ()
    ##
    ## Daily Closing Prices of Major European Stock Indices
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = EuStockMarkets ()
      name = 'EuStockMarkets';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.faithful
    ## @deftypefn {Static Method} {@var{out} =} faithful ()
    ##
    ## Old Faithful Geyser Data
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = faithful ()
      name = 'faithful';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.Formaldehyde
    ## @deftypefn {Static Method} {@var{out} =} Formaldehyde ()
    ##
    ## Determination of Formaldehyde
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = Formaldehyde ()
      name = 'Formaldehyde';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.freeny
    ## @deftypefn {Static Method} {@var{out} =} freeny ()
    ##
    ## Freeny's Revenue Data
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = freeny ()
      name = 'freeny';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.HairEyeColor
    ## @deftypefn {Static Method} {@var{out} =} HairEyeColor ()
    ##
    ## Hair and Eye Color of Statistics Students
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = HairEyeColor ()
      name = 'HairEyeColor';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.Harman23cor
    ## @deftypefn {Static Method} {@var{out} =} Harman23cor ()
    ##
    ## Harman Example 2.3
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = Harman23cor ()
      name = 'Harman23cor';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.Harman74cor
    ## @deftypefn {Static Method} {@var{out} =} Harman74cor ()
    ##
    ## Harman Example 7.4
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = Harman74cor ()
      name = 'Harman74cor';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.Indometh
    ## @deftypefn {Static Method} {@var{out} =} Indometh ()
    ##
    ## Pharmacokinetics of Indomethacin
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = Indometh ()
      name = 'Indometh';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.infert
    ## @deftypefn {Static Method} {@var{out} =} infert ()
    ##
    ## Infertility after Spontaneous and Induced Abortion
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = infert ()
      name = 'infert';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.InsectSprays
    ## @deftypefn {Static Method} {@var{out} =} InsectSprays ()
    ##
    ## Effectiveness of Insect Sprays
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = InsectSprays ()
      name = 'InsectSprays';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.iris
    ## @deftypefn {Static Method} {@var{out} =} iris ()
    ##
    ## The Fisher Iris dataset: measurements of various flowers
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = iris ()
      name = 'iris';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.islands
    ## @deftypefn {Static Method} {@var{out} =} islands ()
    ##
    ## Areas of the World's Major Landmasses
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = islands ()
      name = 'islands';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

    ## -*- texinfo -*-
    ## @node dataset.mtcars
    ## @deftypefn {Static Method} {@var{out} =} mtcars ()
    ##
    ## Motor Trend 1974 Car Road Tests
    ##
    ## <no description available>
    ##
    ## @end deftypefn
    function out = mtcars ()
      name = 'mtcars';
      data = octave.datasets.load(name);
      if nargout == 0
        if isstruct (data)
          s = data;
          vars = fieldnames (s);
          for i = 1:numel (vars)
            assignin ('caller', vars{i}, s.(vars{i}));
          endfor
          loaded_vars = vars;
        else
          assignin ('caller', name, data);
          loaded_vars = { name };
        endif
        printf ('Loaded ''%s''. Variables: %s\n', name, strjoin (loaded_vars, ', '));
      else
        out = data;
      endif
    endfunction

  endmethods

endclassdef
