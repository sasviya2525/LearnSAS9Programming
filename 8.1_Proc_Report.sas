proc sort data=sashelp.heart out=heart; 
	by status sex AgeAtStart Height Weight; 
run;

proc contents data=heart; run;

proc print data=heart (obs=10); 
run;

options label;
/*simplest form - print the table - very similar to proc print - doesn't print obs/ row no*/
proc report data=heart (obs=10); 
run;

/* Selecting Variables to Display with a COLUMNS Statement */
proc report data=heart (obs=10); 
column status sex Height Weight AgeAtStart;/* this defines the order of the columns in the report output */
run;

/* Defining How Variables are Used with Define statement
 using type as display */
proc report data=heart (obs=10); 
column status sex Height Weight;
define status / display 'Alive or Dead' width=13;
define sex / display;
define height / display 'Height (inches)';
define weight / display 'Weight (lbs)';
run;


/* Defining How Variables are Used with Define statement
 using other types - 
analysis - Define the item on the report as an analysis variable.
group - Display the item on the report as a group variable (categories).
*/
proc report data=heart; 
column status sex Height Weight;
define status / group 'Alive or Dead' width=13;
define sex / group;
define height / analysis 'Mean Height (inches)' mean;
define weight / analysis 'Mean Weight (lbs)' mean;
run;

*add a format;
proc report data=heart; 
column status sex Height Weight;
define status / group 'Alive or Dead' width=13;
define sex / group;
define height / analysis 'Mean Height (inches)' mean format=7.2;
define weight / analysis 'Mean Weight (lbs)' mean format=7.2;
run;

*add a title;
title 'Reporting on sashelp.heart';
*add across type - transposes the column;
proc report data=heart; 
column status sex Height Weight BP_Status;
define status / group 'Alive or Dead' width=13;
define sex / group;
define height / analysis 'Mean Height (inches)' mean format=7.2;
define weight / analysis 'Mean Weight (lbs)' mean format=7.2;
define BP_Status / across 'BP Status with total counts'; /* shows the total count in each category */
run;

/*use order type; 
*/
proc report data=heart (obs=50); /* order variable causes individual records to be printed */
column status sex Height Weight BP_Status Cholesterol;
define status / group 'Alive or Dead' width=13;
define sex / group;
define height / analysis 'mean height' mean format=7.2;
define weight / analysis 'mean weight' mean format=7.2;
define BP_Status / across 'BP Status'; 
define Cholesterol/ order;
run;

/*add center option
*/
proc report data=heart (obs=50); /* order variable causes individual records to be printed */
column status sex Height Weight BP_Status Cholesterol;
define status / group 'Alive or Dead' width=13;
define sex / group;
define height / analysis 'mean height' mean format=7.2;
define weight / analysis 'mean weight' mean format=7.2;
define BP_Status / across 'BP Status'; 
define Cholesterol/ order center;
run;

/* add overall summary line using rbreak*/
proc report data=heart; * (obs=50); /* order variable causes individual records to be printed */
column status sex Height Weight BP_Status; *Cholesterol;
define status / group 'Alive or Dead' width=13;
define sex / group;
define height / analysis 'mean height' mean format=7.2;
define weight / analysis 'mean weight' mean format=7.2;
define BP_Status / across 'BP Status'; 
*define Cholesterol/ order center;
/* The RBREAK statement produces a default summary at the end of the report. 
SUMMARIZE sums the value of Sales for all observations in the report.*/
rbreak after / summarize style=[font_weight=bold]; 
/* note how meanheight and weight are averaged and BP_Status values are summed*/
run;


/* Rename the summary line as total */
proc report data=heart; * (obs=50); /* order variable causes individual records to be printed */
column status sex Height Weight BP_Status; *Cholesterol;
define status / group 'Alive or Dead' width=13;
define sex / group;
define height / analysis 'mean height' mean format=7.2;
define weight / analysis 'mean weight' mean format=7.2;
define BP_Status / across 'BP Status'; 
/* rename the summary line as total...
compute after - tells to add the value at the end of all the rows*/
compute after;
status = 'Total';
endcomp;
*define Cholesterol/ order center;
rbreak after / summarize style=[font_weight=bold]; 
/* note how meanheight and weight are averaged and BP_Status values are summed*/
run;

/*get multiple stats for variables*/
proc report data=heart; * (obs=50); /* order variable causes individual records to be printed */
column status sex (Sum Min Max Mean),Height (Sum Min Max Mean),Weight; 
define status / group 'Alive or Dead' width=13;
define sex / group;
define height / 'Height' format=7.2;
define weight / 'Weight' format=7.2;
run;

/*get multiple stats for variables and add page totals*/
proc report data=heart; * (obs=50); /* order variable causes individual records to be printed */
column status sex (Sum Min Max Mean),Height (Sum Min Max Mean),Weight; 
define status / group 'Alive or Dead' width=13 format=$10.;
define sex / group;
define height / 'Height' format=7.2;
define weight / 'Weight' format=7.2;
compute after;
status = 'Summary';
endcomp;
rbreak after/ summarize style=[font_weight=bold];
run;

/* Add summary after each status group value using BREAK */
/*get multiple stats for variables and add page totals*/
proc report data=heart; * (obs=50); /* order variable causes individual records to be printed */
column status sex (Sum Min Max Mean),Height (Sum Min Max Mean),Weight; 
define status / group 'Alive or Dead' width=20;
define sex / group;
define height / 'Height' format=7.2;
define weight / 'Weight' format=7.2;

compute after status;
status = 'Total';
endcomp;

compute after;
status = 'Total';
endcomp;
break after status / summarize
                        style=[font_style=italic];

rbreak after/ summarize style=[font_weight=bold];
run;

/*Add a computed column called BMI*/
proc report data=heart; * (obs=50); /* order variable causes individual records to be printed */
column status sex Height Weight BMI; *Cholesterol;
define status / group 'Alive or Dead' width=13;
define sex / group;
define height / analysis 'mean height' mean format=7.2;
define weight / analysis 'mean weight' mean format=7.2;
 define bmi / computed format=4.1 'Body Mass Index';
 compute bmi;
 bmi = weight.mean / (height.mean*height.mean) * 703;
 endcomp;
run;

/*  Using variable aliases to report on additional columns. */
title1 'Weight Min, Max and Range';
proc report data=heart;
 column sex ('Weight (lbs)' weight weight=maxWeight rangeWeight); /*  creating 2 more aliases for weight */
 define sex / group format=$1.;
 define weight / analysis min 'Min Weight (lbs)' format=7.2;
 define maxWeight / analysis max 'Max Weight (lbs)' format=7.2;
 define rangeWeight / computed 'Range' format=7.2;
 compute rangeWeight;
 rangeWeight = maxWeight - weight.min;
 endcomp;
 run;

/* recall using stats we can do the same thing. */
/*get multiple stats for variables and add page totals*/
proc report data=heart; * (obs=50); /* order variable causes individual records to be printed */
column sex (Min Max Range),Weight; 
define sex / group format=$1.;
define weight / 'Weight in lbs' format=7.2;
run;

/*Some other familiar statements*/
proc report data=heart ;
	by status; /*  separate the report into page sections by a variable(s) */
	where Height>65;
column status sex Height Weight BMI; *Cholesterol;
define status / group 'Alive or Dead' width=13;
define sex / group;
define height / analysis 'mean height' mean format=7.2;
define weight / analysis 'mean weight' mean format=7.2;
define bmi / computed format=4.1 'BMI';
compute bmi;
bmi = weight.mean / (height.mean*height.mean) * 703;
endcomp;
run;



/*Add a computed column called BMI... if you use display type variables you dont need to use
variable.statistic format */
proc report data=sashelp.class nowd;
 column name weight height BMI;
 define name / display;
 define weight / display;
 define height / display;
 define bmi / computed format=4.1 'BMI';
 compute bmi;
 bmi = weight / (height*height) * 703;
 endcomp;
 run;
 


