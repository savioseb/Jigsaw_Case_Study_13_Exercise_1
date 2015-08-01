/**********************************************************
Case Study - Class 13 - Exercise 1
Snack Manufacturer Study
STEP 3: Model Creation
***********************************************************/

LIBNAME CS13 '/folders/myshortcuts/myfolder/SSCode/JigsawCaseStudy13Exercise1/Datasets';



/** Creating the Model **/
ODS OUTPUT CLASSIFICATION = CS13.CTABLE_DATA;
PROC LOGISTIC 
	DATA= CS13.DEVELOPMENT_SAMPLE DESCENDING
	/* to allow plotting */
	PLOTS(MAXPOINTS=NONE) 
	/**/ 
	OUTEST=CS13.LOG_MODEL; 
  	MODEL Good = X2 X9 X16 X30 
  		/ LACKFIT OUTROC=CS13.ROC_DATA CTABLE;
  	OUTPUT 
  		OUT = CS13.DEVELOPMENT_SAMPLE_PRED 
  		PREDICTED=Predicted_Good_Probability ;
  	SCORE 
  		DATA=CS13.VALIDATION_SAMPLE 
  		OUT=CS13.VALIDATION_SAMPLE_PRED;
  	TITLE1 "Logistic Model Development using Development Dataset";
RUN;


/** Printing out the Classification Table **/
PROC PRINT
	DATA=CS13.CTABLE_DATA;
	TITLE1 "Classification Table";
RUN;



/** Exporting the Classification Table **/
PROC EXPORT 
	DATA = CS13.CTABLE_DATA 
	OUTFILE = "/folders/myshortcuts/myfolder/SSCode/JigsawCaseStudy13Exercise1/CSVs/CaseStudy1302_Exercise1_ClassificationTable.CSV"
	DBMS = CSV 
	REPLACE;
RUN;




/** Creating the Model **
ANOTER WAY OF SPECIFYING DESCENDING OPTION
ODS OUTPUT CLASSIFICATION = CS13.CTABLE_DATA;
PROC LOGISTIC 
	DATA= CS13.DEVELOPMENT_SAMPLE
	OUTEST=CS13.LOG_MODEL;
	MODEL Good(event='1') = X2 X9 X16 X30 
  		/ LACKFIT OUTROC=CS13.ROC_DATA CTABLE;
  	OUTPUT 
  		OUT = CS13.DEVELOPMENT_SAMPLE_PRED 
  		PREDICTED=Predicted_Good ;
  	TITLE1 "Logistic Model Development using Development Dataset";
RUN;
*/