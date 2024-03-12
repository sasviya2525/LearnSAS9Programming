/* Example: 1 */
/* datalines example to enter data manually */
data cityTemps;
	input city $ tempinF;
	datalines;
Chicago 35
NewYork 41
Dallas 71
Miami 85
Seattle 60
;
run;

option nofullstimer;

/* Example 2: */
/* simple external file read */
data cricketAverages;
	infile '/home/u63610950/IntroToSAS/topTestBatsmenLast1Year.txt';
	input firstname $ lastname $ innings battingAvg;
run;

/* Example: 3 */
/* long name and next line
check log to see how SAS went to next line to get the input */
data BatsmenLongName;
	infile '/home/u63610950/IntroToSAS/BatsmenLongName.txt' lrecl=128;
	input firstname $ lastname $ innings battingAvg;
run;

/* proc contents to see the length of variables created */
proc contents data=BatsmenLongName;
run;

/* Note how both char and num are created with length 8 and this doesn't read the full first name of Srikanth */
/* how to read it correctly??.. we will come back to that.. hang on */
/* Example 4: */
/* read column wise data */
/* when data is specified in columns */
data BatsmenColumnRead;
	infile '/home/u63610950/IntroToSAS/BatsmenColumnReadDecimals.txt' lrecl=128;
	input firstname $ 1-15 lastname $ 16-24 innings 25-28 battingAvg 29-33;
run;

/* creates length based on the length of input values provided in the input statement */
proc contents;
run;

/* Example 5: */
/* informats - Readng data not in standard format */
/* Informats tells SAS how to read non standard data */
/* example: Dates and salary with comma separated values */
data BatsmenReadInformats;
	infile '/home/u63610950/IntroToSAS/BatsmenColumnReadInformats.txt' lrecl=128;
	input firstname $14. +1 lastname $8. +1 innings 3. +1 battingAvg 5.2 +1 dob 
		ddmmyy10. +1 pay comma11.;

	/* 	first name is 15 columns wide */
	/* +1 means skip one column or dont read the space between the first and last name */
	/* last name is $8. or 8 columns wide */
	/* +1 means skip one column or dont read the space between the last name and innings */
	/* innings is 3. meaning it is numeric and 3 columns wide */
	/* +1 means skip one column or dont read the space between innings and batting average */
	/* battingAvg has an informat of 5.2 - meaning it is numeric,
	has total length of 5 including the period and has 2 numbers after the decimal point */
	/* again +1 means skip a column */
	/* dob ddmmyy10. means it is of format 30/12/1987 with a total width of 10 including the slashes */
	/* again +1 means skip a column */
	/* pay comma11. means the value has one or more commas and tells SAS not to read the comma as part of the number */
run;

proc contents; run;

/* note how the dates are printed.. they are the number of days elapsed since 1st jan 1960 */
/* in order to render/ display the values correctly in SAS, we will apply something called as formats to the variables */
/* Example 6: */
/* read data with informats and not in column format */
/* no standard length of data in the input file from one row to next. */
/* use colon to tell SAS to read until the length specified or the next separator, which ever happens first */
data BatsmenBadColumnReadInformats;
	infile '/home/u63610950/IntroToSAS/BatsmenBadColumnReadInformats.txt' 
		lrecl=128;
	input firstname :$14. lastname :$8. innings :3. battingAvg 5.2 +1 dob 
		ddmmyy10. +1 pay comma11.;

	/* 	notice how the : operator skips the space automatically and and you dont have to do it manually */
	/* however, when you dont use it for battingAvg, you have to do it manually */
run;

/* proc contents to see the length of variables created */
proc contents data=BatsmenBadColumnReadInformats;
run;

/* Example 7: */
/* More Messy data @ operator -- searches for the string and lets you start reading past it */
data BatsmenMoreMessyData;
	infile '/home/u63610950/IntroToSAS/BatsmenMoreMessyData.txt' lrecl=128;
	input @'Player Info:' firstname :$14. lastname :$8. innings :3. battingAvg 
		5.2 +1 dob ddmmyy10. +1 pay comma11.;

	/* 	notice how the : operator skips the space automatically and and you dont have to do it manually */
	/* however, when you dont use it for battingAvg, you have to do it manually */
run;

/* Example: 8 - the double trailing @@ */
/* Multiple records in a single data line in the input file? */
data BatsmenMultipleRecordsInALine;
	infile '/home/u63610950/IntroToSAS/BatsmenMultipleRecordsInALine.txt' 
		lrecl=128;
	input firstname :$14. lastname :$8. innings :3. battingAvg 5.2 +1 dob 
		ddmmyy10. +1 pay comma11.;
run;

/*this does not read the data for Shubman Gill */
/* if a single input data line has multiple records use @@ as shown below to hold the line and read it again  */
data BatsmenMultipleRecordsInALine;
	infile '/home/u63610950/IntroToSAS/BatsmenMultipleRecordsInALine.txt' 
		lrecl=128;
	input firstname :$14. lastname :$8. innings :3. battingAvg 5.2 +1 dob 
		ddmmyy10. +1 pay comma11. @@;
run;

/* Example 9: */
/* the Trailing @ in the input statement - read specific value to determine if you want to read all of the data line */
data BatsmenConditionalRead;
	infile '/home/u63610950/IntroToSAS/BatsmenConditionalRead.txt' lrecl=200;

	/* notice the update to lrecl */
	input @'format:' gamefmt :$4. @;

	if gamefmt='T20' then
		input @'Player Info:' firstname :$14. lastname :$8. innings :3. battingAvg 
			5.2 +1 dob ddmmyy10. +1 pay comma11.;
	else
		delete;
run;

/* the single trailing @ holds the record for the next input statement but releases the line at the end of the datastep */
/* the double trailing @@ holds the record even past that iteration for the next iteration of the input statement */
