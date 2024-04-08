proc format;
	value range low-20='Low MPG' 21-35='Good MPG' 36-HIGH='High MPG';
run;

data carsMod2;
	set sashelp.cars;

	if mod(_N_, 2)=0;
	cars_city_range=put(mpg_city, range.);
run;

/* Lets do some exploratory analysis */
proc sort data=cars;
	by make cars_city_range;
run;

proc print data=cars(obs=10);
	by make;
run;

proc univariate data=cars noprint;
	hist mpg_city;
run;

/* Bar chart -- grouped / stacked barchart */
PROC SGPLOT DATA=cars;
	VBAR origin / response=mpg_city stat=mean group=type;
	TITLE "Cars mpg_city by Origin";
RUN;

proc freq data=cars;
	tables make*cars_city_range / norow nocol nopercent;
run;

proc means data=cars;
	class make cars_city_range;
	var Cylinders Horsepower MPG_City;
run;

data sale_cars;
	set cars;

	if msrp>35000 then
		invoice=msrp*0.8;
	else if msrp>30000 then
		invoice=msrp*0.85;
	else
		invoice=msrp*0.85;
run;

proc sgplot data=sale_cars;
	histogram invoice;
	density invoice / lineattrs=(pattern=solid color=Red);
	keylegend / location=inside position=topright;
run;

proc ttest data=sale_cars H0=20000;
	var msrp;
run;

/*now lets say the input data  set has changed from cars to carsMod3;
/* how many places do you have to change it? */
/* can you find and replace? */

%let dsname=carsMod5;
%put dsname &dsname;

data &dsname;
	set sashelp.cars;

	if mod(_N_, 3)=0;
	cars_city_range=put(mpg_city, range.);
run;

proc sort data=&dsname;
	by make cars_city_range;
run;

proc print data=&dsname(obs=10);
	by make;
run;

proc univariate data=&dsname noprint;
	hist mpg_city;
run;

/* Bar chart -- grouped / stacked barchart */
PROC SGPLOT DATA=&dsname;
	VBAR origin / response=mpg_city stat=mean group=type;
	TITLE "&dsname mpg_city by Origin";
RUN;

proc freq data=&dsname;
	tables make*cars_city_range / norow nocol nopercent;
run;

proc means data=&dsname;
	class make cars_city_range;
	var Cylinders Horsepower MPG_City;
run;

data sale_&dsname;
	set &dsname;

	if msrp>35000 then
		invoice=msrp*0.8;
	else if msrp>30000 then
		invoice=msrp*0.85;
	else
		invoice=msrp*0.85;
run;

proc sgplot data=sale_&dsname;
	histogram invoice;
	density invoice / lineattrs=(pattern=solid color=Red);
	keylegend / location=inside position=topright;
run;

proc ttest data=sale_&dsname H0=20000;
	var msrp;
run;


/* now if you want to change the name to carsMod5, is it easy to change it? */