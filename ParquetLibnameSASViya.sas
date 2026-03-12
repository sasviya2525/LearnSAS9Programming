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

/* cannot insert or update existing parquet files,
so we create a new one with the original and additional data  */
proc sql;
    drop table myddpq.cars2;
    create table myddpq.cars2  as
    select * from myddpq.cars check
    union all
    select * from myddpq.cars where make='Ford';
quit;


data myddpq.class (replace=yes);
    set sashelp.class;
run;