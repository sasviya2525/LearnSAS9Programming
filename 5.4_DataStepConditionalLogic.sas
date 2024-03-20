data classA classB;
	set class;
run;

/* Writing to multiple dataset outputs using conditional logic */
data asiaCars europeCars AmericaCars;
	set sashelp.cars;

	if upcase(origin)='ASIA' then
		output asiaCars;
	else if upcase(origin)='EUROPE' then
		output EuropeCars;
	else
		output AmericaCars;
run;

/* executing multiple statements for each condition */
data asiaCars europeCars AmericaCars;
	set sashelp.cars;
	if upcase(origin)='ASIA' then
		do;
			warranty='GREAT';
			output asiaCars;
		end;
	else if upcase(origin)='EUROPE' then
		do;
			warranty='OK';
			output EuropeCars;
		end;
	else
		do;
			warranty='GOOD';
			output AmericaCars;
		end;
run;