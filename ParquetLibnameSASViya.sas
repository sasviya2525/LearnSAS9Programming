/* parquet libname connection */
libname mypq parquet '/innovationlab-export/innovationlab/homes/Vijay.Govindarajan@sas.com/parquetFiles';

data mypq.class;
    set sashelp.class;
run;

libname mypq clear;

/* duck db parquet connection */
libname myddpq duckdb file_type=parquet 
   file_path="/innovationlab-export/innovationlab/homes/Vijay.Govindarajan@sas.com/parquetFiles";


data myddpq.cars (replace=yes);
    set sashelp.cars;
run;

proc sql;
    select * from myddpq.cars where make='Ford';
quit;


data myddpq.class (replace=yes);
    set sashelp.class;
run;