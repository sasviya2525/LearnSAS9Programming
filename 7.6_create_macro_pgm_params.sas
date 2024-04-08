%macro macroParameters(dsname999);
	data &dsname999;
		set sashelp.cars;

		if mod(_N_, 3)=0;
		cars_city_range=put(mpg_city, range.);
	run;

	proc sort data=&dsname999;
		by make cars_city_range;
	run;

	proc print data=&dsname999(obs=10);
		by make;
	run;

%mend;

%macroParameters(cars)







/* multiple positional parameters */
%macro macroParameters(dsname,obsno,sortoptions,sortvars);
	data &dsname;
		set sashelp.cars;

		if mod(_N_, 3)=0;
		cars_city_range=put(mpg_city, range.);
	run;

	proc sort data=&dsname &sortoptions;
		by &sortvars;
	run;

	proc print data=&dsname(obs=&obsno);
		by &sortvars;
	run;

%mend;

%macroParameters(cars,10,,make cars_city_range)



/* multiple keyword parameters */
%macro keyWordParameters(dsname=class,obsno=10,sortvars=name age);
	data &dsname;
		set sashelp.&dsname;

		if mod(_N_, 3)=0;
	run;

	proc sort data=&dsname;
		by &sortvars;
	run;

	proc print data=&dsname(obs=&obsno);
		by &sortvars;
	run;

%mend;

/* no parameter call */
%keyWordParameters

%keyWordParameters(obsno=3)

/* some parameters in the call - order mixed up */
%keyWordParameters(sortvars=make model,dsname=cars);

/* all parameters in the call */
%keyWordParameters(dsname=cars,obsno=4,sortvars=make model);


/* combination */
/* multiple positional parameters */
%macro comboParameters(dsname,sortvars,obsno=10);
	data &dsname;
		set sashelp.&dsname;

		if mod(_N_, 3)=0;
	run;

	proc sort data=&dsname;
		by &sortvars;
	run;

	proc print data=&dsname(obs=&obsno);
		by &sortvars;
	run;

%mend;

%comboParameters(cars,make,obsno=4);
%comboParameters(cars,make);


/* Nested macros */
%macro create_print(dsname,sortvars,histvar,obsno=10);
	data &dsname;
		set sashelp.&dsname;

		if mod(_N_, 3)=0;
	run;

	%sortds(&dsname,&sortvars)

	%histds(dsname=&dsname, histvar=&histvar)
%mend;

%macro sortds(dsname,sortvars);
	proc sort data=&dsname;
		by &sortvars;
	run;
	
	%printds(obsno=10,sortvars=&sortvars)
%mend;

%macro printds(obsno=max,sortvars=);
	proc print data=&dsname(obs=&obsno);
		by &sortvars;
	run;
%mend;

%macro histds(dsname=, histvar=);
	proc univariate data=&dsname noprint;
		hist &histvar;
	run;	
%mend;

options nomprintnest nomlogicnest;
%create_print(cars,make,mpg_city,obsno=10);


options mprintnest mlogicnest;
%create_print(cars,make,mpg_city,obsno=10);


/* call execute */
proc sql;
create table class as select distinct age from sashelp.class;
run;

%macro print_report_direct(age);
	title "List of members in age group &age";
	proc print data=sashelp.class (where=(age=&age));
	run;
%mend;


data _null_;
	set class; /*recall class has distinct values of age */
	call execute('%print_report_direct('||age||')');  
run;