/**********************************************************
Case Study - Class 13 - Exercise 1
Snack Manufacturer Study
STEP 5: Model Diagnostics - using Validation Data Sample
***********************************************************/

LIBNAME CS13 '/folders/myshortcuts/myfolder/SSCode/JigsawCaseStudy13Exercise1/Datasets';



/*************** Model Diagnostics based on Validation Data **/

/** PROC FREQ on Good for the Validation Dataset **/
PROC FREQ
	DATA=CS13.VALIDATION_SAMPLE_PRED;
	TABLE Good;
	TITLE1 "PROC FREQ on Good for the Validation Dataset";
RUN;


/** Marking the Predicted Good Records based on &Cut_Off_Ratio cutoff [VALIDATION DATASET] */
DATA CS13.VALIDATION_SAMPLE_PRED_CLEAN;
	SET CS13.VALIDATION_SAMPLE_PRED (
		KEEP=Good P_1 
		RENAME=(P_1=Predicted_Good_Probability) 
		);
	/** Selecting &Cut_Off_Ratio as the Cutoff percent for Probability based on C-TAble To get a Sensitivity of 84.1% */
	IF Predicted_Good_Probability < &Cut_Off_Ratio
		THEN Predicted_Good = 0;
		ELSE Predicted_Good = 1;
	IF Good = 1 AND Predicted_Good = 1
		THEN Good_And_Predicted_Good = 1;
		ELSE Good_And_Predicted_Good = 0;
RUN;
	

/** Creating the Gains Chart Data [VALIDATION DATASET] - Ranking the Probability into 10 Groups - Descending Order **/
PROC RANK
	DATA=CS13.VALIDATION_SAMPLE_PRED_CLEAN
	OUT=CS13.VALIDATION_DECILES
	GROUPS=10
	DESCENDING;
	VAR Predicted_Good_Probability;
	RANKS Decile;
RUN;

/** Sorting the Deciles for PROC MEANS Calculation **/
PROC SORT 
	DATA=CS13.VALIDATION_DECILES;
	BY Decile;	
RUN;


/** Finding out the 
- Sum of Actual Good
- Predicted Good Percentation which is the average Score
- No of Respondents per decile
**/
PROC MEANS NOPRINT
	DATA=CS13.VALIDATION_DECILES;
	BY Decile;
	OUTPUT
		OUT=CS13.VALIDATION_GAIN_CHART
		SUM(Good) = Good
		SUM(Good_And_Predicted_Good) = Good_And_Predicted_Good
		N(Good) = No_Of_Respondents
		SUM(Predicted_Good) = Predicted_Good;
RUN;


/** Calculating the Lift on Validation Dataset  **/
DATA CS13.VALIDATION_LIFT;
	SET CS13.VALIDATION_GAIN_CHART (DROP=_TYPE_ _FREQ_);
	/** Total ( Good / Total no of respondents) will give the expected 
	probabilty of getting a good from a random Sample) */
	Expected_Good = 0.2501 * No_Of_Respondents; 
	
	LIFT = 
		( Good_And_Predicted_Good * No_Of_Respondents )  / 
		( Expected_Good * Predicted_Good ); 
	
	/** to calculate Cumulative Numbers **/
	Expected_Good_Lag1 = LAG1(Expected_Good);
	Expected_Good_Lag2 = LAG2(Expected_Good);
	Expected_Good_Lag3 = LAG3(Expected_Good);
	Expected_Good_Lag4 = LAG4(Expected_Good);
	Expected_Good_Lag5 = LAG5(Expected_Good);
	Expected_Good_Lag6 = LAG6(Expected_Good);
	Expected_Good_Lag7 = LAG7(Expected_Good);
	Expected_Good_Lag8 = LAG8(Expected_Good);
	Expected_Good_Lag9 = LAG9(Expected_Good);
	
	Good_And_Predicted_Good_Lag1 = LAG1(Good_And_Predicted_Good);
	Good_And_Predicted_Good_Lag2 = LAG2(Good_And_Predicted_Good);
	Good_And_Predicted_Good_Lag3 = LAG3(Good_And_Predicted_Good);
	Good_And_Predicted_Good_Lag4 = LAG4(Good_And_Predicted_Good);
	Good_And_Predicted_Good_Lag5 = LAG5(Good_And_Predicted_Good);
	Good_And_Predicted_Good_Lag6 = LAG6(Good_And_Predicted_Good);
	Good_And_Predicted_Good_Lag7 = LAG7(Good_And_Predicted_Good);
	Good_And_Predicted_Good_Lag8 = LAG8(Good_And_Predicted_Good);
	Good_And_Predicted_Good_Lag9 = LAG9(Good_And_Predicted_Good);
	
	Cumulative_Expected_Good = SUM(OF Expected_Good_Lag1-Expected_Good_Lag9 Expected_Good);
	Cumulative_Predicted_Good =  SUM(OF Good_And_Predicted_Good_Lag1-Good_And_Predicted_Good_Lag9 Good_And_Predicted_Good);
	
	/** The Model has 4219 Good Feebacks in Total */
	Cumulative_Expected_Percent = Cumulative_Expected_Good / 1904 * 100;
	Cumulative_Predicted_Percent = Cumulative_Predicted_Good / 1904 * 100;
RUN;


/** Cleaning up the Lift / Gains Chart data [VALIDATION DATASET] for better outout **/
DATA CS13.VALIDATION_LIFT_CLEAN;
	RETAIN
		Good 
		Good_And_Predicted_Good
		Predicted_Good
		Expected_Good
		LIFT
		Cumulative_Predicted_Good
		Cumulative_Predicted_Percent
		Cumulative_Expected_Good
		Cumulative_Expected_Percent
		Decile;
	SET CS13.VALIDATION_LIFT 
		(KEEP=
			Good 
			Good_And_Predicted_Good
			Predicted_Good
			Expected_Good
			LIFT
			Cumulative_Predicted_Percent
			Cumulative_Expected_Percent
			Decile );
RUN;



/** Plotting the Lift Curve **/
PROC PLOT 
	DATA=CS13.VALIDATION_LIFT_CLEAN;
	PLOT 
		Cumulative_Predicted_Percent * Cumulative_Expected_Percent
		Cumulative_Expected_Percent * Cumulative_Expected_Percent;
	TITLE1 "[VALIDATION DATASET] Plotting the Gains Chart";
	TITLE2 "Cut Off Ratio=";
	TITLE3 &Cut_Off_Ratio;
RUN;



/** Printing the Gains Chart for Validation Dataset **/
PROC PRINT
	DATA=CS13.VALIDATION_LIFT_CLEAN;
	SUM 
		Good 
		Good_And_Predicted_Good
		Predicted_Good
		Expected_Good;
	TITLE1 "[VALIDATION DATASET] Printing out the Gains Chart Items";
	TITLE2 "Cut Off Ratio=";
	TITLE3 &Cut_Off_Ratio;
	
	

/** Exporting the Gains Chart Items **/
PROC EXPORT 
	DATA = CS13.VALIDATION_LIFT_CLEAN 
	OUTFILE = "/folders/myshortcuts/myfolder/SSCode/JigsawCaseStudy13Exercise1/CSVs/CaseStudy1302_Exercise1_GainsChartItems_Validation.CSV"
	DBMS = CSV 
	REPLACE;
RUN;

