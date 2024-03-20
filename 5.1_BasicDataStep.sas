/* Datastep example - illustrate _ERROR_ and _N_  */
data ds_example1;
	infile '/home/u63610950/IntroToSAS/DS_example1.txt';
	input name $ 1-7 height 9-10 weight 12-14;
	BMI=700*weight/(height**2);
	output;
run;
/* What happens to calculations on missing values? */

/* changes after explicit output */
data ds_example1;
	infile '/home/u63610950/IntroToSAS/DS_example1.txt';
	input name $ 1-7 height 9-10 weight 12-14;
	BMI=700*weight/(height**2);
	output;
	BMI=1000;
run;


/* remove explicit output */
data ds_example1;
	infile '/home/u63610950/IntroToSAS/DS_example1.txt';
	input name $ 1-7 height 9-10 weight 12-14;
	BMI=700*weight/(height**2);
	*output;
	BMI=1000;
run;