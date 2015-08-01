/**********************************************************
Case Study - Class 13 - Exercise 1
Snack Manufacturer Study
STEP 2: Data Exploration
***********************************************************/

LIBNAME CS13 '/folders/myshortcuts/myfolder/SSCode/JigsawCaseStudy13Exercise1/Datasets';



/** Running a PROC MEANS with NMISS to find out the Missing Variables for Data Prep */
PROC MEANS N NMISS MEAN
	DATA=CS13.BRAND_A_DATA;
	Title1 "PROC Means output of the data - to find if there are any Missing Variables";
	TITLE2 "There are no Missing Variables";
RUN;

/** Exploring the Data Via PROC FREQ to understand the distribution */
PROC FREQ
	DATA=CS13.BRAND_A_DATA;
	TITLE1 "Exploring the Data Via PROC FREQ to understand the distribution";
RUN;



/** Splitting the Data into Development and Validation Samples **/
DATA CS13.DEVELOPMENT_SAMPLE CS13.VALIDATION_SAMPLE ;
	SET CS13.BRAND_A_DATA;
	IF RANUNI(100) < 0.7 
		THEN 
			OUTPUT CS13.DEVELOPMENT_SAMPLE; 
		ELSE 
			OUTPUT CS13.VALIDATION_SAMPLE;
RUN;


/** Exploring the Data Via PROC FREQ to understand the distribution */
PROC FREQ
	DATA=CS13.DEVELOPMENT_SAMPLE;
	TABLE Good;
	TITLE1 "Exploring the Good Variable Distribution in The Training Dataset";
RUN;