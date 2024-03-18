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

/* By default, generates N	Mean	Std Dev	Minimum	Maximum */
proc means data=hmeqSorted;
	by region descending state; /* create statistics for each group of the by variables */
	var loan mortdue; /* variables to be listed in the analysis */
run;

/* If VAR statement is not provided, then the stats are created for all the numeric variables */
proc means data=hmeqSorted;
	by region descending state; /* create statistics for each group of the by variables */
run;

/* Select mean, stdev, median and sum instead for statistics */
proc means data=hmeqSorted mean stddev median sum;
	by region descending state;
	var loan mortdue;
run;

/* What happens if I try to use BY region state , instead of desc state */
proc means data=hmeqSorted mean stddev median sum;
	by region state;
	var loan mortdue;
run;

/* not sorted.. no problem! Use CLASS statement instead of BY */
/* Select mean, stdev, median and sum instead for statistics */
proc means data=hmeqSorted mean stddev median sum;
	class region state; /* remember sort is done by descending state not ascending */
	var loan mortdue;
run;
/* Notice how class produces more compact output */

/* for comparison run together with class statement*/
proc means data=hmeqSorted mean stddev median sum;
	by region descending state;
	var loan mortdue;
run;



/* Add a title */
title 'Summary using proc means';
/* subset data using WHERE statement */
proc means data=hmeqSorted mean stddev median sum;
	class region state; /* remember sort is done by descending state not ascending */
	var loan mortdue;
	where region='Midwest';
run;


/* a gentle intro to SAS functions here */
proc means data=hmeqSorted mean stddev median sum;
	class region state; /* remember sort is done by descending state not ascending */
	var loan mortdue;
	where upcase(region)='MIDWEST';
run;

/* creating output dataset  */
proc means data=hmeqSorted mean stddev median sum;
	class region state; /* remember sort is done by descending state not ascending */
	var loan mortdue;
	where upcase(region)='MIDWEST';
	output out=hmeqMeans mean(loan mortdue)=meanLoan meanMortgage
						 sum(loan mortdue)=sumLoan  sumMortgage;
run;

/* Note that _type_ and _freq_ are created for each level automatically in the output dataset*/

/* Only create output, supress the report using NOPRINT*/
/* also dont have to list the statistics required in the proc means option */
proc means data=hmeqSorted noprint;
	class region state; /* remember sort is done by descending state not ascending */
	var loan mortdue;
	where upcase(region)='MIDWEST';
	output out=hmeqMeans mean(loan mortdue)=meanLoan meanMortgage
						 sum(loan mortdue)=sumLoan  sumMortgage;
run;


/* drop the automatic variables from the output*/
proc means data=hmeqSorted noprint;
	class region state; /* remember sort is done by descending state not ascending */
	var loan mortdue;
	where upcase(region)='MIDWEST';
	output out=hmeqMeans(drop=_freq_ _type_) mean(loan mortdue)=meanLoan meanMortgage
						 sum(loan mortdue)=sumLoan  sumMortgage;
run;

/* print formatted output */
proc print data=hmeqMeans;
	format meanLoan meanMortgage dollar14.2 sumLoan  sumMortgage dollar14.2;
run;