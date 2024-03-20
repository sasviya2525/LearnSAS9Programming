/* use SET statement to read from an input dataset and create a new output dataset */
/* Example 1: read from sashelp.class and create work.class */
data work.class;
	set sashelp.class;
	BMI=700*weight/(height**2);
run;

/* Example 2 */
/* use SET statement to read from an input dataset and write to the same output dataset */
data class;
	set class;
	BMI=700*weight/(height**2);
	format BMI 6.2;
run;

/* Example 3 - creating a cumulative Total variable */
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

proc freq data=hmeq(where=(mortdue is missing));
	tables state;
run;

proc freq data=hmeq;
	tables state;
	where mortdue is missing;
run;

/* trying to create a cumulative sum using + operator */
data hmeq_wisc (keep=mortdue totalMortDue);
	set hmeq (where=(upcase(state)='WISCONSIN'));
	totalMortDue=totalMortDue+MortDue;
run;

/* trying to create a cumulative sum using sum function */
data hmeq_wisc (keep=mortdue totalMortDue);
	set hmeq (where=(upcase(state)='WISCONSIN'));
	totalMortDue=sum(totalMortDue, MortDue);
run;

/* trying to create a cumulative sum using retain statement and sum function */
data hmeq_wisc (keep=mortdue totalMortDue);
	set hmeq (where=(upcase(state)='WISCONSIN'));
	retain totalMortDue 0;
	totalMortDue=sum(totalMortDue, MortDue);
run;

/* Using a "sum statement" of the form (Variable + expression) */
/* When you use the sum statement, VARIABLE is automatically set to 0 at the beginning of the first iteration of
the DATA step execution and it is retained in following iterations. When EXPRESSION is evaluated to a missing value, it is treated as 0.
*/
data hmeq_wisc (keep=mortdue totalMortDue);
	set hmeq (where=(upcase(state)='WISCONSIN'));
	totalMortDue+MortDue;

	/* This form is called SUM statement */
run;

/* Example 4: stack datasets */
data hmeq_WI_neigbors;
	set hmeq (where=(upcase(state) in ('ILLINOIS', 'MINNESOTA', 'IOWA', 
		'MICHIGAN') ));
run;

data hmeq_WI_only;
	set hmeq (where=(upcase(state)='WISCONSIN'));
run;

/* stack datasets */
data hmeq_WI_and_neigbors;
	set hmeq_WI_only (obs=20) hmeq_WI_neigbors (obs=50);
run;

/* Example 5: Interleave data - input datasets must be sorted by the same variable for this */
proc sort data=hmeq_WI_neigbors;
	by city;
run;

proc sort data=hmeq_WI_only;
	by city;
run;

/* stack and interleave datasets */
data hmeq_interleave;
	set hmeq_WI_only (obs=20) hmeq_WI_neigbors (obs=50);
	by city;
run;

/* Example 6: Match merge */
/* create hobby dataset for class for different age groups. */
data hobbiesOneToOne;
	input age :3. hobby :$15.;
	cards;
10 Biking
11 Climbing
12 Baseball
13 Soccer
14 Volleyball
15 Hiking
;
run;

data hobbiesOneToMany;
	input age :3. hobby :$15.;
	cards;
10 Biking
10 Legos
11 Climbing
11 Tennis
12 Baseball
13 Soccer
14 Volleyball
14 Swimming
14 Hockey
15 Hiking
15 Lacrosse
;
run;

/* create a couple of duplicate obs in class  */
data classDups;
	set class;
	if mod(_N_, 6)=0;
	weight=weight-10;
	height=height+5;
	BMI=700*weight/(height**2);
run;

/* then illustrate one to one, one to many match merges. */
proc sort data=class;
	by age Name;
run;

proc sort data=classDups;
	by age Name;
run;

proc sort data=hobbiesonetomany;
	by age;
run;

proc sort data=hobbiesOneToOne;
	by age;
run;

/* one to one merge */
data classOnetoOne;
set class;
by age;
if first.age;
run;

data mergeOneToOne;
	merge classOnetoOne hobbiesOneToOne;
	by age;
run;

/* Many to One Merge; */
data example1;
	merge class hobbiesOneToOne;
	by age;
run;

/* Many to One Merge; */
Data classMany;
	set class classDups;
	by age Name;
run;

data ManyToOneMerge;
	merge classMany hobbiesOneToOne;
	by age;
run;

/* OneToMany */
data OneToManyMerge;
	merge class hobbiesOneToMany(in=inHobby);
	by age;
run;

/* ManyToMany - Do SQL join if you need cartesian product */
data ManyToManyMerge;
	merge class hobbiesOneToMany;
	by age;
run;

/* IN option to show left join, inner join and full join Show how to  */
/* left join */
data MergeLEFT;
	merge class (in=inClass) hobbiesOneToOne (in=inHobby);
	by age;
	if inClass;
run;

/* right join */
data MergeRIGHT;
	merge class (in=inClass) hobbiesOneToOne (in=inHobby);
	by age;
	if inHobby;
run;

/* inner join */
data MergeINNER;
	merge classMany (in=inClass) hobbiesOneToOne (in=inHobby);
	by age;

	if inClass and inHobby;
run;

/* inner join */
data MergeFULL;
	merge classMany (in=inClass) hobbiesOneToOne (in=inHobby);
	by age;
	if inClass or inHobby;
run;

/* merge summary stats with original dataset  */
proc means data=class;
	class age;
	var weight height;
	output out=summaryClass mean(weight height)=meanWeight meanHeight;
run;

data classMergeSummary;
	merge class (in=inClass) summaryClass (in=inSummary keep=age meanWeight 
		meanHeight);
	by age;
	if inClass;
run;

/* Update master data with lkup data using Update statement */
proc sort data=class;
	by name age;
run;

proc sort data=classDups;
	by name age;
run;

data classUpd;
update class classDups;
by name age;
run;

proc print; run;
proc print data=class; run;