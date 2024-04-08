/*List macro variables automatically defined by SAS*/
%put _automatic_;

/*list all user created macro variables - all scopes*/
%put _user_;


/* macro variable scope */

/*list macro variables in the global scope*/
%put _global_;

/*list macro variables in the local scope*/
%put _local_;


%let dsname=cars;

%put &dsname;

%put dataset name is &dsname;

%put &=dsname;

proc print data=sashelp.vmacro;
where upcase(name)='DSNAME';
run;

%put global scope=%SYMGLOBL(dsname);
%put local scope=%SYMLOCAL(dsname);


/* resolution: */

%let outdsname=class;
%let indsname=sashelp.class;

option nosymbolgen;

data &outdsname;
	set &indsname;
run;

/* add a prefix */
data copy_&outdsname;
	set &indsname.;
run;


/* add a suffix */
libname SASData '/home/u63610950/IntroToSAS/SASData';
%let libout=SASData;
data &libout..&outdsname;
	set &indsname;
run;

data &outdsname._copy;
	set &indsname;
run;


%let sport=cricket;
%let winner=5;
%let cricket1=MI;
%let cricket2=HSR;
%let cricket3=CSK;
%let cricket4=GT;
%let cricket5=DC;
%let football1=Pats;
%let football2=Chiefs;
%let football3=bucs;
%let football4=rams;

%put &sport.&winner.;

%put &&sport&winner;

%put &&&sport&winner;
