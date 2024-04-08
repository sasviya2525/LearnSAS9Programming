/* Set up input data */
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

/* simple select statement */
proc sql;
select * from sashelp.class;
quit;

/* get more feedback in the log */
proc sql feedback;
select * from sashelp.class;
quit;

/* find the unique values; */
proc sql;
select distinct age from sashelp.class;
quit;

/* you can write multiple statements in one proc sql - quit block */
proc sql;
title 'sashelp.class';
select * from sashelp.class;
title 'sashelp.shoes';
select * from sashelp.shoes;
quit;


/* limit number of obs being read from input tables */
proc sql inobs=10;
select * from sashelp.class;

select * from sashelp.heart;
quit;



/* create a new table or dataset from an existing table */
proc sql;
create table class as
select * from sashelp.class;
quit;

/* sometimes you might not want to print the results in the results window or lst file */
proc sql noprint;
create table class as
select * from sashelp.class (obs=10);
quit;


/* create a new data from an existing dataset using a subset of rows */
proc sql noprint;
create table classMale as
select * from sashelp.class
where sex='M';
quit;

/* multiple conditions */
proc sql noprint;
create table classMale12 as
select * from sashelp.class
where sex='M' and age=12;
quit;

/* using contains */
proc sql noprint;
create table classMale12 as
select * from sashelp.class
where sex='M' and upcase(name) contains 'A';
quit;


/* another way to write contains */
proc sql noprint;
create table classMale12 as
select * from sashelp.class
where sex='M' and upcase(name) ? 'A';
quit;


proc contents data =classMale12;
run;

/* missing values and null values */
proc sql;
select * from hmeq where mortdue is missing;
quit;

proc sql;
select * from hmeq where mortdue is null;
quit;

/* Alternate way - is missing */
proc sql;
select * from hmeq where mortdue=.;
quit;

/* or for char columns */
proc sql;
select * from hmeq where reason='';
quit;


/* using like operator */
proc sql noprint;
create table classMale12 as
select * from sashelp.class
where sex='M' and 
lowcase(name) like '%a%s';
quit;

/* sounds like operator */
data names;
input fname $ lname $;
cards;
john smith
james smit
terry schmit
My pony
tom shmit
tom brady
;
run;

proc sql;
select * from names where lname =* 'smith';
quit;


/* create empty table from scratch*/
proc sql;
create table newClass
(name char(8),
age num,
sex char(1),
height num,
weight num
);
quit;


/* insert values */
proc sql;
insert into newClass
    values('Brady',45,'M',185,215);
quit;

proc print; run;

/* insert 3 rows from a dataset */
proc sql inobs=3 feedback;
insert into newClass
select * from sashelp.class where sex='M';
quit;

/* what is the issue? */
proc sql inobs=3;
insert into newClass (name,sex,age,height,weight)
select * from sashelp.class where sex='M';
quit;

proc print; run;


/* what is the issue? */
proc sql inobs=3;
insert into newClass 
select name,age,sex,height,weight from sashelp.class where sex='M';
quit;

proc print; run;


/*update values */
proc sql;
update newClass 
set weight=weight+5 
where sex='M' and age>30;
quit;

proc print; run;

/* limit number of variables in select statement */
proc sql;
select name, age from newClass;
quit;


/* print row number in its own column; */
proc sql number;
select name, age from newClass where mod(age,3)=0;
quit;


/* create empty new dataset from an existing dataset */
proc sql noprint;
create table classEmpty as
select * from sashelp.class
where 1=0;
quit;


/* say you want get all the sas datasets that have the column 'AGE' */
proc sql outobs=5;
select * from sashelp.vcolumn where upcase(name)='AGE';
quit;

/* turn off labels so you get the column names */
options nolabel;
proc sql outobs=5;
select * from sashelp.vcolumn where upcase(name)='AGE';
quit;


/* sql sub queries */
proc sql;
select * from sashelp.vcolumn where memname in (
select memname from sashelp.vcolumn where upcase(name)='AGE'
);
quit;

/* check infor for bmimen from age 11 to 16 */
proc sql;
select * from sashelp.bmimen where age>=11 and age<=16;
quit;

/* inner join - one - many */
proc sql;
select a.*, b.bmi
from
sashelp.class a
inner join
sashelp.bmimen b
on 
a.age=round(b.age);
quit;


/* inner join - another way to write the query*/
proc sql;
select a.*, b.bmi
from
sashelp.class a,
sashelp.bmimen b
where
a.age=round(b.age);
quit;

/* change inner join to left join - so easy */
proc sql;
select a.*, b.bmi
from
sashelp.class a
left join
sashelp.bmimen b
on 
a.age=round(b.age);
quit;

/* summarize the data - calculate mean BMI using group by */
proc sql;
select name, age, sex, weight, height, mean(bmi) as meanBmi from
(select a.*, b.bmi
from
sashelp.class a
left join
sashelp.bmimen b
on 
a.age=round(b.age))
group by 1,2,3,4,5;
quit;


/* save to new table and sort output by BMI */
proc sql;
create table classBMI as
select name, age, sex, weight, height, mean(bmi) as meanBmi from
(select a.*, b.bmi
from
sashelp.class a
left join
sashelp.bmimen b
on 
a.age=round(b.age))
group by 1,2,3,4,5
order by meanBMI;
quit;


/* Format the meanBMI column */
proc sql;
create table classBMI as
select name, age, sex, weight, height, mean(bmi) as meanBmi format=5.2 from
(select a.*, b.bmi
from
sashelp.class a
left join
sashelp.bmimen b
on 
a.age=round(b.age))
group by 1,2,3,4,5
order by 6;
quit;


/* simple calculation */
proc sql inobs=20;
select make, model, mpg_city+mpg_highway as mpg_all
from sashelp.cars;
quit;

/* use the calculated column */
proc sql inobs=20;
select make, model, mpg_city+mpg_highway as mpg_all
from sashelp.cars
where
calculated mpg_all>45;
quit;


/* having - subset on column not used in the group by clause*/
proc sql;
select make, cylinders, count(*) as cnt
from sashelp.cars
group by 1,2;
quit;

proc sql;
select make, cylinders, count(*) as cnt
from sashelp.cars
group by 1,2
having cnt>10;
quit;

/* correlated subqueries */

/* create 2 datasets with related data */
proc sql;
create table classAll as 
select * from sashelp.class;

insert into classAll values
('Taylor','M',14,150,100);

insert into classAll values
('Taylor','F',12,120,90);


insert into classAll values
('Taylor','F',13,130,95);

quit;

/* undocumented _N_ -> monotonic() */
proc sql;
create table fieldTripConfirmed as
select * from classAll
where mod(monotonic(),5)=0;
quit;

/* Now let us try to find out who in ClassAll hasn't confirmed for the field trip */
/* clearly, we cant just compare by just name */

proc sql;
select a.* from classAll a
where not exists
(select * from fieldTripConfirmed b
where a.name=b.name and
a.age=b.age and
a.sex=b.sex);
quit;


/* validate your syntax without running the query */
proc sql;
validate
select a.* from classAll a
where not exists
(select * from fieldTripConfirmed b
where a.name=b.name and
a.age=b.age and
a.sex=b.sex);
quit;


/* coalesce */
/* set up the datasets */

/* create 2 datasets with related data */
proc sql;
create table classMissingValues as 
select * from sashelp.class
where 1=0;

insert into classMissingValues values
('Taylor','M',14,.,100);

insert into classMissingValues values
('Taylor','F',12,120,.);


insert into classMissingValues values
('Taylor','',13,130,95);

quit;

proc sql;
select a.name, a.age, coalesce(a.sex,b.sex) as sex, coalesce(a.height,b.height) as height
, coalesce(a.weight,b.weight) as weight
from
classMissingValues a
inner join
classAll b
on
a.name=b.name and 
a.age=b.age;
quit;



/* union and union all */
proc sql number;
select * from classAll
union
select * from fieldTripConfirmed;
quit;


/* union all - does not remove duplicates */
proc sql number;
select * from classAll
union all
select * from fieldTripConfirmed;
quit;


/* except */
proc sql number;
select * from classAll
except
select * from fieldTripConfirmed;
quit;


/* except all */
/* first lets create a duplicate in the first dataset */
proc sql; 
insert into classAll
select * from sashelp.class where name like 'J%';
quit;


/* now check except all vs except */
proc sql number;
select * from classAll
except all
select * from fieldTripConfirmed;
quit;

/* removes duplicates */
proc sql number;
select * from classAll
except
select * from fieldTripConfirmed;
quit;


/* Intersect*/
proc sql number;
select * from classAll
intersect all
select * from fieldTripConfirmed;
quit;


/* describe a table */
proc sql;
describe table classAll;
quit;