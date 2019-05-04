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
    ## Box, G. E. P., Jenkins, G. M. and Reinsel, G. C. (1976) Time Series
    ## Analysis, Forecasting and Control. Third Edition. Holden-Day. Series G.
    ## 
    ##
    ## @end deftypefn
    function out = AirPassengers ()
      name = 'AirPassengers';
      out = octave.datasets.load(name);
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
    ## Crowder, M. and Hand, D. (1990), Analysis of Repeated Measures, Chapman and
    ## Hall (example 5.3)
    ## 
    ## Hand, D. and Crowder, M. (1996), Practical Longitudinal Data Analysis, Chapman
    ## and Hall (table A.2)
    ## 
    ## Pinheiro, J. C. and Bates, D. M. (2000) Mixed-effects Models in S and S-PLUS,
    ## Springer.
    ##
    ## @end deftypefn
    function out = ChickWeight ()
      name = 'ChickWeight';
      out = octave.datasets.load(name);
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
    ## F.A.A. Statistical Handbook of Aviation.
    ## 
    ##
    ## @end deftypefn
    function out = airmiles ()
      name = 'airmiles';
      out = octave.datasets.load(name);
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
    ## L. and Greenhouse, J. eds (1994) Case Studies in Biometry. New York: John Wiley
    ## and Sons.
    ## 
    ##
    ## @end deftypefn
    function out = beavers ()
      name = 'beavers';
      out = octave.datasets.load(name);
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
    ## Month - Month when searches took place
    ## 
    ## Cupcake - An indicator of search volume, in unknown units
    ## 
    ## @subsubheading Source
    ## 
    ## Google Trends, @url{https://trends.google.com/trends/explore?q=%2Fm%2F03p1r4&date=all},
    ## retrieved 2019-05-04 buy apjanke.
    ## 
    ## 
    ##
    ## @end deftypefn
    function out = cupcake ()
      name = 'cupcake';
      out = octave.datasets.load(name);
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
    ## @subsubheading Source
    ## 
    ## @url{http://archive.ics.uci.edu/ml/datasets/Iris}
    ## 
    ## @subsubheading References
    ## 
    ## @url{https://en.wikipedia.org/wiki/Iris_flower_data_set}
    ## 
    ## Fisher,R.A. “The use of multiple measurements in taxonomic problems”
    ## Annals of Eugenics, 7, Part II, 179-188 (1936); also in “Contributions 
    ## to Mathematical Statistics” (John Wiley, NY, 1950).
    ## 
    ## Duda,R.O., & Hart,P.E. (1973) Pattern Classification and Scene Analysis. 
    ## (Q327.D83) John Wiley & Sons. ISBN 0-471-22361-1. See page 218.
    ## 
    ## The data were collected by Anderson, Edgar (1935). The irises of the Gaspe
    ## Peninsula, Bulletin of the American Iris Society, 59, 2–5.
    ## 
    ##
    ## @end deftypefn
    function out = iris ()
      name = 'iris';
      out = octave.datasets.load(name);
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
    ## Henderson and Velleman (1981), Building multiple regression models
    ## interactively. Biometrics, 37, 391–411.
    ## 
    ##
    ## @end deftypefn
    function out = mtcars ()
      name = 'mtcars';
      out = octave.datasets.load(name);
    endfunction

  endmethods

endclassdef