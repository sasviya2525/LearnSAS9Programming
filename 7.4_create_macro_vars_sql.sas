/* Use PROC SQL to create macro variables; */
PROC SQL noprint;
  select mean(height)
    into :mean_height 
    from sashelp.class
	where age=14;
	quit;

%put &=mean_height;

/* apply formats */
PROC SQL noprint;
  select mean(height) format 7.3
    into :mean_height
    from sashelp.class
	where age=14;
quit;

%put &=mean_height;


/* create multiple macro variables */
PROC SQL noprint;
  select mean(height), mean(weight) 
    into :mean_height , :mean_weight 
    from sashelp.class
	where age=14;
quit;

%put &=mean_height &=mean_weight;

/* separated by ,; */
PROC SQL noprint;
  select height
    into :all_heights214
    separated by ' '
    from sashelp.class
	where age=14;
quit;
%put &=all_heights214;


/* Create multiple macro variables */
PROC SQL noprint;
  select height
    into :all_heights1-:all_heights4
    from sashelp.class
	where age=14;
quit;
%put &=all_heights1;
%put &=all_heights2;
%put &=all_heights3;
%put &=all_heights4;


/* Create multiple macro variables */
PROC SQL noprint;
  select height
    into :all_heights11-
    from sashelp.class
	where age=14;
quit;
%put &=all_heights11;
%put &=all_heights12;
%put &=all_heights13;
%put &=all_heights14;


/* Using trimmed option; */
PROC SQL noprint;
  select mean(height)
    into :mean_height 
    from sashelp.class
	where age=14;
	quit;
%put &=mean_height;

/* remove leading and trailing blanks */
PROC SQL noprint;
  select mean(height)
    into :mean_height trimmed
    from sashelp.class
	where age=14;
	quit;
%put &=mean_height;


/* create multiple macro variables - notice separate trimmed/ no trim */
PROC SQL noprint;
  select mean(height), mean(weight) 
    into :mean_height trimmed, :mean_weight trimmed
    from sashelp.class
	where age=14;
quit;

%put &=mean_height &=mean_weight;
