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
    ## @subsubheading Description
    ## 
    ## The classic Box & Jenkins airline data. Monthly totals of international
    ## airline passengers, 1949 to 1960.
    ## 
    ## @subsubheading Source
    ## 
    ## Box, G. E. P., Jenkins, G. M. and Reinsel, G. C. (1976) @cite{Time Series
    ## Analysis, Forecasting and Control}. Third Edition. Holden-Day. Series G.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## ## TODO: This example needs to be ported from R.
    ## @end example
    ## 
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
    ## @node dataset.ChickWeight
    ## @deftypefn {Static Method} {@var{out} =} ChickWeight ()
    ##
    ## Weight versus age of chicks on different diets
    ##
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item weight
    ## a numeric vector giving the body weight of the chick (gm).
    ## @item Time
    ## a numeric vector giving the number of days since birth when the
    ## measurement was made.
    ## @item Chick
    ## an ordered factor with levels 18 < ... < 48 giving a unique
    ## identifier for the chick. The ordering of the levels groups chicks on the same
    ## diet together and orders them according to their final weight (lightest to
    ## heaviest) within diet.
    ## @item Diet
    ## a factor with levels 1, ..., 4 indicating which experimental diet
    ## the chick received.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Crowder, M. and Hand, D. (1990), @cite{Analysis of Repeated Measures}. Chapman and
    ## Hall (example 5.3)
    ## 
    ## Hand, D. and Crowder, M. (1996), @cite{Practical Longitudinal Data Analysis}. Chapman
    ## and Hall (table A.2)
    ## 
    ## Pinheiro, J. C. and Bates, D. M. (2000) @cite{Mixed-effects Models in S and S-PLUS}.
    ## Springer.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## # TODO: This example needs to be ported from R.
    ## @end example
    ## 
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
    ## @node dataset.airmiles
    ## @deftypefn {Static Method} {@var{out} =} airmiles ()
    ##
    ## Passenger Miles on Commercial US Airlines, 1937-1960
    ##
    ## @subsubheading Description
    ## 
    ## The revenue passenger miles flown by commercial airlines in the
    ## United States for each year from 1937 to 1960.
    ## 
    ## @subsubheading Source
    ## 
    ## @cite{F.A.A. Statistical Handbook of Aviation}.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.airmiles;
    ## plot (t.year, t.miles);
    ## title ("airmiles data");
    ## xlabel ("Passenger-miles flown by U.S. commercial airlines")
    ## ylabel ("airmiles");
    ## @end example
    ## 
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
    ## @node dataset.airquality
    ## @deftypefn {Static Method} {@var{out} =} airquality ()
    ##
    ## New York Air Quality Measurements from 1973
    ##
    ## @subsubheading Description
    ## 
    ## Daily air quality measurements in New York, May to September 1973.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item Ozone
    ## Ozone concentration (ppb)
    ## @item SolarR
    ## Solar R (lang)
    ## @item Wind
    ## Wind (mph)
    ## @item Temp
    ## Temperature (degrees F)
    ## @item Month
    ## Month (1-12)
    ## @item Day
    ## Day of month (1-31)
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## New York State Department of Conservation (ozone data) and the National
    ## Weather Service (meteorological data).
    ## 
    ## @subsubheading References
    ## 
    ## Chambers, J. M., Cleveland, W. S., Kleiner, B. and Tukey, P. A. (1983)
    ## @cite{Graphical Methods for Data Analysis}. Belmont, CA: Wadsworth.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.airquality
    ## # Plot a scatter-plot plus a fitted line, for each combination of measurements
    ## vars = @{"Ozone", "SolarR", "Wind", "Temp" "Month", "Day"@};
    ## n_vars = numel (vars);
    ## figure;
    ## for i = 1:n_vars
    ##   for j = 1:n_vars
    ##     if i == j
    ##       continue
    ##     endif
    ##     ix_subplot = (n_vars*(j - 1) + i);
    ##     hax = subplot (n_vars, n_vars, ix_subplot);
    ##     var_x = vars@{i@};
    ##     var_y = vars@{j@};
    ##     x = t.(var_x);
    ##     y = t.(var_y);
    ##     scatter (hax, x, y, 10);
    ##     # Fit a cubic line to these points
    ##     # TODO: Find out exactly what kind of fitted line R's example is using, and
    ##     # port that.
    ##     hold on
    ##     p = polyfit (x, y, 3);
    ##     x_hat = unique(x);
    ##     p_y = polyval (p, x_hat);
    ##     plot (hax, x_hat, p_y, "r");
    ##   endfor
    ## endfor
    ## 
    ## @end example
    ## 
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
    ## @subsubheading Description
    ## 
    ## Four sets of x/y pairs which have the same statistical properties, but are
    ## very different.
    ## 
    ## @subsubheading Format
    ## 
    ## The data comes in an array of 4 structs, each with fields as follows:
    ## 
    ## @table @code
    ## @item x
    ## The X values for this pair.
    ## @item y
    ## The Y values for this pair.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Tufte, Edward R. (1989). @cite{The Visual Display of Quantitative Information}.
    ## 13–14. Graphics Press.
    ## 
    ## @subsubheading References
    ## 
    ## Anscombe, Francis J. (1973). “Graphs in statistical analysis”. @cite{The
    ## American Statistician}, 27, 17–21. 
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## data = octave.dataset.anscombe
    ## 
    ## # Pick good limits for the plots
    ## all_x = [data.x];
    ## all_y = [data.y];
    ## x_limits = [min(0, min(all_x)) max(all_x)*1.2];
    ## y_limits = [min(0, min(all_y)) max(all_y)*1.2];
    ## 
    ## # Do regression on each pair and plot the input and results
    ## figure;
    ## haxs = NaN (1, 4);
    ## for i_pair = 1:4
    ##   x = data(i_pair).x;
    ##   y = data(i_pair).y;
    ##   # TODO: Port the anova and other characterizations from the R code
    ##   # TODO: Do a linear regression and plot its line
    ##   hax = subplot (2, 2, i_pair);
    ##   haxs(i_pair) = hax;
    ##   xlabel (sprintf ("x%d", i_pair));
    ##   ylabel (sprintf ("y%d", i_pair));
    ##   scatter (x, y, "r");
    ## endfor
    ## 
    ## # Fiddle with the plot axes parameters
    ## linkaxes (haxs);
    ## xlim(haxs(1), x_limits);
    ## ylim(haxs(1), y_limits);
    ## @end example
    ## 
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
    ## @subsubheading Description
    ## 
    ## Event data for 23 earthquakes in California, showing peak accelerations.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item event
    ## Event number
    ## @item mag
    ## Moment magnitude
    ## @item station
    ## Station identifier
    ## @item dist
    ## Station-hypocenter distance (km)
    ## @item accel
    ## Peak acceleration (g)
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Joyner, W.B., D.M. Boore and R.D. Porcella (1981). Peak horizontal acceleration
    ## and velocity from strong-motion records including records from the 1979
    ## Imperial Valley, California earthquake. USGS Open File report 81-365. Menlo
    ## Park, Ca.
    ## 
    ## @subsubheading References
    ## 
    ## Boore, D. M. and Joyner, W. B.(1982). The empirical prediction of ground
    ## motion, @cite{Bulletin of the Seismological Society of America}, 72, S269–S268.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## # TODO: Port the example code from R
    ## # It does coplot() and pairs(), which are higher-level plotting tools 
    ## # than core Octave provides. This could turn into a long example if we
    ## # just use base Octave here.
    ## @end example
    ## 
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
    ## @subsubheading Description
    ## 
    ## Aggregated data from a survey of clerical employees at a large financial
    ## organization.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item rating
    ## Overall rating.
    ## @item complaints
    ## Handling of employee complaints.
    ## @item privileges
    ## Does not allow special privileges.
    ## @item learning
    ## Opportunity to learn.
    ## @item raises
    ## Raises based on performance.
    ## @item critical
    ## Too critical.
    ## @item advance
    ## Advancement.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Chatterjee, S. and Price, B. (1977) @cite{Regression Analysis by Example}. New York:
    ## Wiley. (Section 3.7, p.68ff of 2nd ed.(1991).)
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.attitude
    ## 
    ## octave.examples.plot_pairs (t);
    ## 
    ## # TODO: Display table summary
    ## 
    ## # TODO: Whatever those statistical linear-model plots are that R is doing
    ## 
    ## 
    ## @end example
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
    ## @subsubheading Description
    ## 
    ## Numbers of Australian residents measured quarterly from March 1971 to March 1994.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item date
    ## The month of the observation.
    ## @item residents
    ## The number of residents.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## P. J. Brockwell and R. A. Davis (1996) @cite{Introduction to Time Series and
    ## Forecasting}. Springer
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.austres
    ## 
    ## plot (datenum (t.date), t.residents);
    ## datetick x
    ## xlabel ("Month"); ylabel ("Residents"); title ("Australian Residents");
    ## @end example
    ## 
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
    ## @subsubheading Description
    ## 
    ## Body temperature readings for two beavers.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item day
    ## Day of observation (in days since the beginning of 1990), December 12–13 (beaver1) 
    ## and November 3–4 (beaver2).
    ## @item time
    ## Time of observation, in the form 0330 for 3:30am
    ## @item temp
    ## Measured body temperature in degrees Celsius.
    ## @item activ
    ## Indicator of activity outside the retreat.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## P. S. Reynolds (1994) Time-series analyses of beaver body temperatures.
    ## Chapter 11 of Lange, N., Ryan, L., Billard, L., Brillinger, D., Conquest,
    ## L. and Greenhouse, J. eds (1994) @cite{Case Studies in Biometry}. New York: John Wiley
    ## and Sons.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## # TODO: This example needs to be ported from R.
    ## @end example
    ## 
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
    ## @node dataset.cupcake
    ## @deftypefn {Static Method} {@var{out} =} cupcake ()
    ##
    ## Google Search popularity for "cupcake", 2004-2019
    ##
    ## @subsubheading Description
    ## 
    ## Monthly popularity of worldwide Google search results for "cupcake", 2004-2019.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item Month
    ## Month when searches took place
    ## @item Cupcake
    ## An indicator of search volume, in unknown units
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## Google Trends, @url{https://trends.google.com/trends/explore?q=%2Fm%2F03p1r4&date=all},
    ## retrieved 2019-05-04 by Andrew Janke.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## t = octave.dataset.cupcake
    ## plot(datenum(t.Month), t.Cupcake)
    ## title ('“Cupcake” Google Searches'); xlabel ("Year"); ylabel ("Unknown popularity metric")
    ## 
    ## @end example
    ## 
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
    ## @node dataset.iris
    ## @deftypefn {Static Method} {@var{out} =} iris ()
    ##
    ## The Fisher Iris dataset: measurements of various flowers
    ##
    ## @subsubheading Description
    ## 
    ## This is the classic Fisher Iris dataset.
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item Species
    ## The species of flower being measured.
    ## @item SepalLength
    ## Length of sepals, in centimeters.
    ## @item SepalWidth
    ## Width of sepals, in centimeters.
    ## @item PetalLength
    ## Length of petals, in centimeters.
    ## @item PetalWidth
    ## Width of petals, in centimeters.
    ## @end table
    ## 
    ## @subsubheading Source
    ## 
    ## @url{http://archive.ics.uci.edu/ml/datasets/Iris}
    ## 
    ## @subsubheading References
    ## 
    ## @url{https://en.wikipedia.org/wiki/Iris_flower_data_set}
    ## 
    ## Fisher, R.A. “The use of multiple measurements in taxonomic problems”
    ## Annals of Eugenics, 7, Part II, 179-188 (1936); also in @cite{Contributions 
    ## to Mathematical Statistics} (John Wiley, NY, 1950).
    ## 
    ## Duda, R.O., & Hart, P.E. (1973) @cite{Pattern Classification and Scene Analysis}.
    ## (Q327.D83) John Wiley & Sons. ISBN 0-471-22361-1. See page 218.
    ## 
    ## The data were collected by Anderson, Edgar (1935). The irises of the Gaspe
    ## Peninsula, @cite{Bulletin of the American Iris Society}, 59, 2–5.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## # TODO: Port this example from R
    ## @end example
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
    ## @node dataset.mtcars
    ## @deftypefn {Static Method} {@var{out} =} mtcars ()
    ##
    ## Motor Trend 1974 Car Road Tests
    ##
    ## @subsubheading Description
    ## 
    ## The data was extracted from the 1974 Motor Trend US magazine, and
    ## comprises fuel consumption and 10 aspects of automobile design and
    ## performance for 32 automobiles (1973–74 models).
    ## 
    ## @subsubheading Format
    ## 
    ## @table @code
    ## @item mpg
    ## Fuel efficiency in miles/gallon
    ## @item cyl
    ## Number of cylinders
    ## @item disp
    ## Displacement (cu. in.)
    ## @item hp
    ## Gross horsepower
    ## @item drat
    ## Rear axle ratio
    ## @item wt
    ## Weight (1,000 lbs)
    ## @item qsec
    ## 1/4 mile time
    ## @item vs
    ## Engine type (0 = V-shaped, 1 = straight)
    ## @item am
    ## Transmission type (0 = automatic, 1 = manual)
    ## @item gear
    ## Number of forward gears
    ## @item carb
    ## Number of carburetors
    ## @end table
    ## 
    ## @subsubheading Note
    ## 
    ## Henderson and Velleman (1981) comment in a footnote to Table 1: “Hocking
    ## [original transcriber]’s noncrucial coding of the Mazda’s rotary engine
    ## as a straight six-cylinder engine and the Porsche’s flat engine as a V
    ## engine, as well as the inclusion of the diesel Mercedes 240D, have been
    ## retained to enable direct comparisons to be made with previous analyses.”
    ## 
    ## @subsubheading Source
    ## 
    ## Henderson and Velleman (1981), “Building multiple regression models
    ## interactively”. Biometrics, 37, 391–411.
    ## 
    ## @subsubheading Examples
    ## 
    ## @example
    ## # TODO: Port this example from R
    ## @end example
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
