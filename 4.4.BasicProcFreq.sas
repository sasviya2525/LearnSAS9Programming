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

/* shows freq and cuml freq */
proc freq data=hmeqSorted;
	tables state;
run;

/* write to output table */
proc freq data=hmeqSorted;
	tables state / out=hmeqStateFreq;
run;


/* cross tabulation */
proc freq data=hmeqSorted;
	tables state*BAD;
run;

/* visualize */
proc freq data=hmeqSorted;
	tables state*BAD / plots=freqplot;
	where upcase(state)='ALABAMA';
run;


/* cross tabulation - list format*/
/* much better in my opinion */
proc freq data=hmeqSorted;
	tables state*BAD / list;
run;

/* use BY variable to produce a table for each group */
proc freq data=hmeqSorted;
	by city;
	where upcase(state)='ALABAMA';
	tables job*BAD/ list;
run;



/* cross tabulation - supress row and col percentages*/
/* this is not applicable to list format */
proc freq data=hmeqSorted;
	tables state*BAD / norow nocol;
run;


/* by default, missing values are not included in the tables output */
proc freq data=hmeqSorted;
	tables state*job/ list;
	where upcase(state)='ALABAMA';
run;

/* cross tabulation - include missing values in the freq stats */
proc freq data=hmeqSorted;
	tables state*job/ list missing;
	where upcase(state)='ALABAMA';
run;