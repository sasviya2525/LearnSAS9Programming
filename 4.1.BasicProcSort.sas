/* SAS PROCEDURES - PROC SORT */
proc print data=sashelp.class;
run;

proc contents data=sashelp.class;
run;

proc sort data=sashelp.class 
out=class;
by sex;
run;

proc contents data=class;
run;

proc sort data=class 
out=class;
by sex age;
run;


proc sort data=class;
by sex descending age;
run;

proc sort data=class 
out=class1 nodupkey;
by sex;
run;

proc sort data=class 
out=class1 nodupkey;
by sex age;
run;

proc sort data=class 
out=class1 nodupkey dupout=class1dup;
by sex age;
run;


/* dataset options - where, keep and drop to subset rows and columns */

proc sort data=sashelp.class (where=(age=12))
out=class12;
by sex;
run;

proc sort data=sashelp.class (where=(age=12) keep=(name age sex))
out=class12;
by sex;
run;


proc sort data=sashelp.class (where=(age=12) keep=(name age sex))
out=class12 (drop=sex);
by sex;
run;
