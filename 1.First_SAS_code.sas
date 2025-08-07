/* simple datastep */
data city_data x;
   cityName='Los Angeles';
   population=15000000;
run;

/* proc to print the dataset */
proc print data=city_data;
run;


/* proc to see the metadata for the dataset */
proc contents data=city_data;
run;

%put This line was updated from SAS Studio and pushed to Git;

%put This line was updated in the Git Editor;
