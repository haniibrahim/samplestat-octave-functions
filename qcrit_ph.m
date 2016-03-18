## -*- texinfo -*-
##
##@deftypefn {Function File} [@var{qcritval}] = qcrit_ph(@var{n}, @var{p})
##
##Returns the critical Q value (@var{qcritval}) for a given number of values (@var{n}) 
##of a sample distribution and a given confidence level (@var{p}) for the 
##Pearson-Hartley outlier test.
##
##In the Pearson-Hartley outlier test you compare @var{qcritval} with a 
##calculated Q value.
##
##@var{n} has to be between: 1 <= @var{n} <= 1000 bu should be > 30! @var{p} is 
##"95% or "99%".
##
##@example
##@group
##qcrit_ph(53, "95%")
##@result{} 3.0998
##
##The Q_crit value (@var{qcritval}) of @var{n}=53 and @var{p}="95%" is 3.0998.
##@end group
##@end example
##
##@seealso{pearsonhartley(), deandixon(), mean(), std(), min(), max()}
##@end deftypefn

# Author: Hani Andreas Ibrahim <hani.ibrahim@gmx.de>
# License: GPL 3.0
function qcritval = qcrit_ph(n, p)
  % Checking arguments
  if (nargin < 2 || nargin > 2); print_usage(); endif
  if (~isnumeric(n) || (n-floor(n) != 0)); error("First argument has to be a integer\n"); endif
  if (n < 1 || n > 1000); error("First value has to be greater or equal 1 and less or equal 1000"); endif
  if ~(strcmp(p,"95%") || strcmp(p,"99%"))
    error("Second argument is the statistical confidence level and has to be a string, as \"95%\", \"99%\" or \"99.9%\"");
  endif

  % qtable contains the critical values qcritval for N (number of values)
  % and alpha (niveau of significance)  
  % Column 1 : Number of values (N)
  % Column 2 : Q_crit, 95% confidence level
  % Column 3 : Q_crit, 99% confidence level
  qtable = [ ...
    1	  1.645	2.326; ...
    2	  1.955	2.575; ...
    3	  2.121	2.712; ...
    4	  2.234	2.806; ...
    5	  2.319	2.877; ...
    6	  2.386	2.934; ...
    7   2.438 2.978; ...
    8	  2.490	3.022; ...
    9   2.529 3.056; ...
    10	2.568	3.089; ...
    15	2.705	3.207; ...
    20	2.799	3.289; ...
    25	2.870	3.351; ...
    30	2.928	3.402; ...
    35	2.975	3.444; ...
    40	3.016	3.479; ...
    45	3.051	3.511; ...
    50	3.083	3.539; ...
    55	3.111	3.564; ...
    60	3.137	3.587; ...
    65	3.160	3.607; ...
    70	3.182	3.627; ...
    75  3.201 3.644; ...
    80	3.220	3.661; ...
    85  3.237 3.676; ...
    90	3.254	3.691; ...
    95  3.269 3.705; ...
    100	3.283	3.718; ...
    200	3.474	3.889; ...
    300	3.581	3.987; ...
    400	3.656	4.054; ...
    500	3.713	4.106; ...
    600	3.758	4.148; ...
    700	3.797	4.183; ...
    800	3.830	4.214; ...
    900	3.859	4.240; ...
    1000 3.884	4.264...
  ];
  
  % Set the proper column of the t-table, depending on confidence level
  switch(p)
    case("95%")
      j = 2;
    case("99%")
      j = 3;
    otherwise
      error();
  endswitch
  
  % Pick the appropriate Q_crit value, interpolate if necessary
  if (n >= 1 && n <= 10)
    qcritval = qtable(n,j);
  elseif (n >= 11  && n <= 100)
    i = 8 + floor(n/5); % Determine row, 27=correction factor
    qs = (qtable(i+1,j) - qtable(i,j))/5;
    mul = n - qtable(i,1); % Multiplicator for qs
    qcritval = qtable(i,j) + (mul * qs);
  elseif (n >=101 && n < 1000)
    i = 27 + floor(n/100); % Determine row, 8=correction factor
    qs = (qtable(i+1,j) - qtable(i,j))/100;
    mul = n - qtable(i,1); % Multiplicator for qs
    qcritval = qtable(i,j) + (mul * qs);
  else % for the last value (1000)
    i = 27 + floor(n/100); % Determine row, 6=correction factor
    qcritval = qtable(i,j);
  endif
  return;
endfunction