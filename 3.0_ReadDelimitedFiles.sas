/* Example 10 */
/* Read file from a site */
/* filename statement is used to create a file reference to external files */
filename hmeqdisk '/home/u63610950/IntroToSAS/home_equity.csv';
filename hmeq url 'https://support.sas.com/documentation/onlinedoc/viya/exampledatasets/home_equity.csv';

/*read the external file to see what the file holds so we can read the values correctly*/
/* the entire line is read into the varialbe fulllines */
/*Note value of lrecl is higher incase the line size in the file is longer than 128 */
/* obs=2 in the infile statement says to read only the first 2 observations */
data hmeq;
	infile hmeq obs=2 lrecl=200 firstobs=1 truncover;
	input fulllines $ 1-200;
run;

/* missover option in the infile statement tells SAS not to go to the next line,
incase it doesn't find enough values for all the variables in a single data line */
/* Recall that the default behavior of SAS is to
go to the next line to fetch values if it is not available in a single dataline */
/* Notice the colon modifier.  */
/* Division :$25 tells SAS to read for 25 columns or until it encounters a delimiter,
which ever happens first */
/* format statement displays appdate in the specified date format when we print the data */
data hmeq;
	infile hmeq lrecl=200 missover dlm=',' dsd firstobs=2;
	input BAD LOAN MORTDUE VALUE REASON $
    JOB $
    YOJ DEROG DELINQ CLAGE NINQ CLNO DEBTINC APPDATE CITY :$25. STATE :$20. 
		DIVISION :$25. REGION :$15.;
	format appdate mmddyy9.;
run;

proc print data=hmeq (obs=15);
run;

/* Example 11 - proc import */

proc import datafile=hmeqdisk out=hmeqdisk dbms=csv replace;
	getnames=yes;
run;



/* Example: 11 import XLSX files */
proc setinit; run;

filename inputfl '/home/u63610950/IntroToSAS/cityTemps.xlsx';
proc import datafile=inputfl out=cityTemp dbms=xlsx replace;
	getnames=yes;
	sheet='Sheet2';
run;

proc print data=cityTemp; run;
