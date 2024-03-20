/* data set options */

data cars;
set sashelp.cars (keep=make model);
run;

data cars (drop=make);
set sashelp.cars (keep=make model);
run;

data cars (keep=make model rename=(make=Company model=Name) );
set sashelp.cars (obs=20 firstobs=10 where=(mpg_city>12));
run;
