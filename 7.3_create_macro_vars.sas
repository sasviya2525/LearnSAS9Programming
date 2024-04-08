data cityTemps;
	input city $ tempinF tempinC;
	datalines;
Chicago 35 1.67
NewYork 41 5
Dallas 71 21.67
Miami 85 29.4
Seattle 60 15.5
;
run;

/* Assign dataset values to a macro variable; */
data _null_;
	set cityTemps (where=(upcase(city)='CHICAGO'));
	%let tempMV=tempinF;
run;

%put &=tempMV;







/* call symptux x 2 parameters */
data _null_;
	set cityTemps (where=(upcase(city)='CHICAGO'));
	call symputx('tempMV', tempinF);
run;

%put &=tempMV;

data _null_;
	set cityTemps (where=(upcase(city)='CHICAGO'));
	call symputx('tempC', tempinC);
	call symputx('tempF', tempinF);
run;

%put &=tempC &=tempF;

proc print data=sashelp.vmacro;
	where upcase(name) like 'TEMP%';
run;

/* call symput x third option */
%macro x;
	data _null_;
		set cityTemps (where=(upcase(city)='CHICAGO'));
		call symputx('tempCinX', tempinC, 'G');
		call symputx('tempFinX', tempinF, 'L');
		call symputx('tempCity', city);
	run;

	proc print data=sashelp.vmacro;
		where upcase(name) like 'TEMP%';
	run;

%mend;

%x

/* delete macro variables */
%symdel tempCinX tempFinX tempcity tempC tempf tempmv;

/* Notice how call symputX creates tempCity in the local symbol table this time! */
/* call symput x third option */
%macro x;
	data _null_;
		set cityTemps (where=(upcase(city)='CHICAGO'));
		call symputx('tempCinX', tempinC, 'G');
		call symputx('tempCity', city);
		call symputx('tempFinX', tempinF, 'L');
	run;

	proc print data=sashelp.vmacro;
		where upcase(name) like 'TEMP%';
	run;

%mend;

%x

/* delete macro variables */
%symdel tempCinX tempFinX tempcity tempinF;

/* Apply formats while creating macro variables */
data _null_;
	set cityTemps (where=(upcase(city)='CHICAGO'));
	call symputx('tempCinX', put(tempinC, 7.3));
run;

proc print data=sashelp.vmacro;
	where upcase(name) like 'TEMP%';
run;

/* macro variable in global and local scope. - same name */
%let tempinF=99;

%macro x;
	%let tempinF=33;
	%put global scope=%SYMGLOBL(tempinF), local scope=%SYMLOCAL(tempinF) &=tempinF;
%mend;

%x
%put global scope=%SYMGLOBL(tempinF), local scope=%SYMLOCAL(tempinF) &=tempinF;


%macro x;
	%let tempinF999=33;
	%put global scope=%SYMGLOBL(tempinF999), local scope=%SYMLOCAL(tempinF999) 
	&=tempinF999;
%mend;

%x


/* macro variable in global and local scope. - same name.. forcing local scope */
/* better to use local scope to prevent inadvertant over writing of macro variables in global scope */
%let tempinF=99;

%macro x;
	%local tempinF; %let tempinF=33;
	%put global scope=%SYMGLOBL(tempinF), local scope=%SYMLOCAL(tempinF) &=tempinF;
%mend;

%x
%put global scope=%SYMGLOBL(tempinF), local scope=%SYMLOCAL(tempinF) &=tempinF;
