/* simple datastep */
data city_data x;
   cityName='Los Angeles';
   population=16000000;
run;

/* proc to print the dataset */
proc print data=city_data;
run;


/* proc to see the metadata for the dataset */
proc contents data=city_data;
run;

/*change added from SAS Studio */
%put this line was added in SAS Studio;

/*change 2 from SAS Studio */
%put this line 2 was added in SAS Studio;