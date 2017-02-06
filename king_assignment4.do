capture log close
log using "king_assignment4.log", replace

//PhD Practicum, Spring 2017
//Robb King
//02/01/17

local gtype eps

clear

/*1. Create a dataset that includes two independent variables, an error term, and
 a dependent variable that is a linear function of the two independent 
 variables. The two independent variables should be correlated with one another.*/

local reg_example_1=1

local my_corr=.05
local mymeans 12 15
local mysds 3 5
local error_sd 10
local pop_size 8000
local sample_size 100
local nreps 1000

drawnorm x1 x2, means(`mymeans') sds(`mysds') corr(1,`my_corr'\`my_corr',1) n(`pop_size') cstorage(lower)

drawnorm e, means(0) sds(`error_sd')

local beta_0=22

local beta_1=2

local beta_2=4

gen y=`beta_0'+`beta_1'*x1+`beta_2'*x2+e

/*2 & 3. Repeatedly sample from that population. In each sample calculate the 
value of the regression coefficients.*/

if `reg_example_1'==1 {

postfile buffer beta_0 beta_1 beta_2 using reg_a, replace

forvalues i=1/`nreps' {
	preserve
	quietly sample `sample_size', count
	quietly reg y x1 x2
	post buffer (_b[_cons]) (_b[x1]) (_b[x2])
	restore
	} //close forvalues

postclose buffer

use reg_a, clear

kdensity beta_1, xline(`beta_1')

graph export ovb.`gtype', replace
} //close if reg_example_1

/*4. Report the empirical sampling distribution generated for the constant and both variables.*/
mean beta_0
mean beta_1
mean beta_2

clear

/*5. Now, create a correlation between the error term and one of the 
coefficients. Discuss what happens to your parameter estimates when there is a 
correlation between one of the coefficients and the error term.*/ 

local my_corr=.05
local mymeans 12 0
local error_sd 10
local mysds 3 `error_sd'
local mymean2 15
local mysd2 5
local pop_size 8000
local sample_size 100
local nreps 500

drawnorm x1 e, means(`mymeans') sds(`mysds') corr(1,`my_corr'\`my_corr',1) n(`pop_size') cstorage(lower)

drawnorm x2, means(`mymean2') sds(`mysd2')

local beta_0=22

local beta_1=2

local beta_2=4

gen y=`beta_0'+`beta_1'*x1+`beta_2'*x2+e

if `reg_example_1'==1 {

postfile buffer beta_0 beta_1 beta_2 using reg_b, replace

forvalues i=1/`nreps' {
	preserve
	quietly sample `sample_size', count
	quietly reg y x1 x2
	post buffer (_b[_cons]) (_b[x1]) (_b[x2])
	restore
	} //close forvalues

postclose buffer

use reg_b, clear

kdensity beta_1, xline(`beta_1')

graph export ovb2.`gtype', replace
} //close if reg_example_1

mean beta_0
mean beta_1
mean beta_2

/* Increase the strength of the correlation between the independent variable 
and the error term and discuss what happens then.*/

clear

local mymeans 12 0
local error_sd 10
local mysds 3 `error_sd'
local mymean2 15
local mysd2 5
local pop_size 8000
local sample_size 100
local nreps 500

local j=1

foreach my_corr of numlist .05(.05).95 {

drawnorm x1 e, means(`mymeans') sds(`mysds') corr(1,`my_corr'\`my_corr',1) n(`pop_size') cstorage(lower)

drawnorm x2, means(`mymean2') sds(`mysd2')

local beta_0=22

local beta_1=2

local beta_2=4

gen y=`beta_0'+`beta_1'*x1+`beta_2'*x2+e

if `reg_example_1'==1 {

postfile buffer beta_0 beta_1 beta_2 using reg_1, replace

forvalues i=1/`nreps' {
	preserve
	quietly sample `sample_size', count
	quietly reg y x1 x2
	post buffer (_b[_cons]) (_b[x1]) (_b[x2])
	restore
	} //close forvalues

postclose buffer

use reg_1, clear

kdensity beta_1, xline(`beta_1')

graph export ovb2.`gtype', replace
} //close if reg_example_1

mean beta_0
mean beta_1
mean beta_2

save "run_`j'", replace

local j=`j'+1

} //close foreach my_corr

/* Comments: Based on the results of my code, a correlation between the error term
and one of the coefficients decreases the intercept and changes the mean of the coefficient 
that is correlated with the error term. The uncorrelated coefficient remains close 
to the mean. As you increase the correlation, the intercept continues to decrease and
the mean of the correlated coefficient increases.*/

log close
exit
