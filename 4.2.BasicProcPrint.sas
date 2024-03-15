/* create the dataset */
filename hmeq url 'https://support.sas.com/documentation/onlinedoc/viya/exampledatasets/home_equity.csv';

/* Create permanent sas library - sasdata */
libname sasdata '/home/u63610950/IntroToSAS/SASData';

data hmeq;
	infile hmeq lrecl=200 missover dlm=',' dsd firstobs=2;
	input BAD LOAN MORTDUE VALUE REASON $
    JOB $
    YOJ DEROG DELINQ CLAGE NINQ CLNO DEBTINC APPDATE CITY :$25. STATE :$20. 
	DIVISION :$25. REGION :$15.;
	format appdate mmddyy9.;
run;

/* sort by region and descending values of state */
proc sort data=hmeq out=hmeqSorted;
	by region descending state city;
run;


/* Basic SAS procedures; */
/* print the data */
proc print data=hmeqSorted;
run;

/* subset rows */
proc print data=hmeqSorted;
	where STATE='Virginia';
run;

/* limit number of observations */
proc print data=hmeqSorted (obs=25);
	where STATE='Virginia';
run;

/* subset columns using dataset keep option */
proc print data=hmeqSorted (keep=region state city loan);
	where STATE='Virginia';
run;

/* subset columns using VAR statement */
proc print data=hmeqSorted;
	where STATE='Virginia';
	var region state city loan;
run;

/* suppress the OBS number in the print output */
proc print data=hmeqSorted (obs=25) noobs;
	where STATE='Virginia';
run;

/* format your print output data */
proc print data=hmeqSorted (obs=25) noobs;
	where STATE='Virginia';
	format loan mortdue dollar12.2;
run;

/* Create sum values  */
proc print data=hmeqSorted (obs=25) noobs;
	where STATE='Virginia';
	sum loan mortdue value;
	format loan mortdue dollar12.2;
run;

/* sum all numeric variables */
proc print data=hmeqSorted (obs=25) noobs;
	where STATE='Virginia';
	sum _numeric_;
	format loan mortdue dollar14.2;
run;

proc print data=hmeqSorted (obs=20);
run;

/* add by statement */
proc print data=hmeqSorted (obs=20);
	by region;
run;

/* create sum for each by group */
proc print data=hmeqSorted (obs=200) noobs;
	by region descending state;
	sum loan mortdue value;
run;

/* Add ID - replace Noobs column with ID column */
proc print data=hmeqSorted (obs=25);
	by region descending state city;
	sum loan mortdue value;
	var city loan mortdue value;
	id state;
run;

/* Add some styles. */
proc print data=hmeqSorted(obs=25) noobs  
			   style(HEADER)={fontstyle=italic backgroundcolor=black foreground=white}
			   style(DATA)={backgroundcolor=lightblue foreground=purple};
run;

/* Add title and footnote - Putting it all together */
/* Add a title  */
Title 'Loan data for Virginia';
footnote 'Using HMEQ public dataset';
proc print data=hmeqSorted (obs=25) 
				style(HEADER)={fontstyle=italic backgroundcolor=black foreground=white}
				style(DATA)={backgroundcolor=lightgreen foreground=purple};
				where state='Virginia';
	by region descending state city;
	sum loan mortdue value;
	var city loan mortdue value;
	id state;
	format loan mortdue dollar12.2;
run;
