/**********************************************************
Case Study - Class 13 - Exercise 1
Snack Manufacturer Study
STEP 1: Getting the Data
***********************************************************/

LIBNAME CS13 '/folders/myshortcuts/myfolder/SSCode/JigsawCaseStudy13Exercise1/Datasets';



/** Importing the Dataset **/
PROC IMPORT
	Datafile='/folders/myshortcuts/myfolder/Foundation Exercises/Assignments/Class13 - Logistic Regression with SAS/goodforu-class13.csv'
	DBMS=CSV
	REPLACE
	OUT=CS13.SURVEY_DATA;
RUN;


/** Extracting only the Relevant Brand A Variables **/
DATA CS13.BRAND_A_DATA;
	SET CS13.SURVEY_DATA (KEEP= X2 X9 X16 X30  X23);
	IF X23 <6 THEN Good = 0; ELSE Good = 1;
RUN;
