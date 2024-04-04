/*
user defined formats using proc format 
create, view, use formats
check existing formats in a catalog
write out format values to a dataset
create a format from a dataset
*/

/* using if then else */
data class;
	set sashelp.class;
	length sex1 $6.;

	if sex='M' then
		sex1='Male';
	else if sex='F' then
		sex1='Female';
	else sex1='Unk';
	put '2.' sex1=;
run;

proc freq data=class;
	tables sex1;
run;

/* user defined format */
proc format;
	value $gendr 'M'='Male'
		'F'='Female'
		Other='Unk'
	;
run;

/* applying formats - example - dont have to read the entire dataset in a datastep */
proc freq data=sashelp.class;
	format sex $gendr.;
	tables sex;
run;

/* more user defined formats */
proc format;
	value $states 
		'WI'='WISCONSIN'
		'UT'='UTAH'
		'NC'='NORTH CAROLINA'
		'DE'='DELAWARE'
		'MA'='MASSACHUSETTS'
		'PA'='PENNSYLVANIA'
		OTHER='Other'
	;
run;

/* numeric format */
proc format;
	value mpgcity
		LOW -< 10 ='VERY LOW MPG'
		10 -< 20 ='LOW MPG'
		20 - 30='GOOD MPG'
		30 - HIGH ='EXCELLENT MPG'
	;
run;

proc freq data=sashelp.cars;
	format mpg_city mpgcity.;
	tables mpg_city;
run;

/* numeric format */
proc format;
	value bmi
		LOW -< 18.5 ='UNDER WEIGHT'
		18.5 - 24.9 ='NORMAL WEIGHT'
		25 - 29.9='OVER WEIGHT'
		30 - HIGH ='OBESE'
	;
run;

data b;
	input bmi 5.2;
	cards;
15.2
24.1
38.5
22.0
40.1
18.5
;
run;

proc print data=b; run;

/*using format */
proc print data=b;
	format bmi bmi.;
run;

/* check format library */
proc format library=work fmtlib;
run;

/* select specific formats */
proc format library=work fmtlib;
	select $states;
run;

/*Permanent formats - create format in different library */
libname permloc '/home/u63610950/IntroToSAS/myFormat';

proc format lib=permloc;
	value $states 
		'WI'='WIS'
		'UT'='UTA'
		'NC'='NOR CAR'
		'DE'='DEL'
		'MA'='MAS'
		'PA'='PEN'
		OTHER='Other'
	;
run;

proc format library=permloc.formats fmtlib;
run;

data a;
	input states $15.;
	cards;
XX
MA
RR
UT
NC
PP
DE
;
run;

proc print data=a;
	format states $states.;
run;

/* what is you want to use the format from the temp format catalog?? */
options fmtsearch = (permloc.formats work); /* order is important */

proc print data=a;
	format states $states.;
run;

/* lets reverse it again */
options fmtsearch = (work permloc.formats); /* order is important */

proc print data=a;
	format states $states.;
run;

/* assigning multiple values to a format */
proc format;
	value phasecd
		1,2,3,4,5,6,7='Treatment'
		8,9,10,11,12='Follow-up'
		.='Missing'
		Other='NA'
	;
run;

data c;
	input code 3.;
	cards;
1
2
8
.
3
4
.
5
12
13
11
;
run;

data _null_;
	set c;
	new_code=put(code,phasecd.);
	put code= new_code=;
run;

/* create a dataset from a format */
proc format library=work cntlout=fmts;
run;

proc print data=fmts;
run;

/* select specific formats - create a dataset from a format */
proc format library=work cntlout=fmts_select1;
	select bmi $states;
run;

proc print data=fmts_select1;
run;

/* check the format catalog before ctnlin */
proc format lib=permloc fmtlib;
run;

/* create format from a dataset */
proc format library=permloc cntlin=fmts_select1;
run;

proc format lib=permloc fmtlib;
run;
