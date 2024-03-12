/* create a work dataset from datalines*/

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

/* define a permanent SAS library */
libname SASData '/home/u63610950/IntroToSAS/SASData';


/* save the dataset to a permanent SAS library */
data sasdata.cityTemps;
	input city $ tempinF;
	datalines;
Chicago 35
NewYork 41
Dallas 71
Miami 85
Seattle 60
;
run;


