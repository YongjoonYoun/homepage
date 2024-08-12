This is the replication package for "Intergenerational Dilemma: Balancing Windfalls and Burdens of Public Transfers in Korea" 
by Harrison Yongjoon Youn (youn.62@osu.edu)

The package contains 3 subfolders:

1) Raw Data - Includes raw data of the Korean Longitudinal Study of Aging (KLoSA) surveys. Note that the data are written in Korean.

- str01-09: raw data from wave 1 (str01) to wave 9 (str09)
(The user can download the same data from here: https://survey.keis.or.kr/index.jsp)

2) Firgures: Includes Figures presented in Section 3 with the original data. 

3) Code: Includes codes from the raw data process to the result outputs. Instead of making a shall to run everything at once, 
	 I divided them into separate files. Also, instead of using some system codes that often mask logic, I coded with intuitive 
	 commands so that anyone can replicate and follow the step. 

- 1. Data_Construction_KLoSA: Imports, corrects some variable name errors given to harmonize 9 waves, and keeps necessary variables. 

- 2. BP_Construction_KLoSA: Constructs Basic Pension benefits for treatments. 

- 3. Transfer_Construction_KLoSA: Constructs financial transfers variables 

- 4. Sample_Construction_KLoSA: Constructs analytical sample of types of households.

- 5. Variable_Cleaning_KLoSA: Creates necessary variables.

- 6. Summary_Statistics_KLoSA: Creates Tables and Figures. 

- 7. Main_Analysis_KLoSA: Runs Section 6 results. 

- Appendix.TWFE: Runs Extended TWFE of Wooldridge (2021). 

To run, it is recommended to: 
- Create a data folder and put raw data into the folder.
- Set the directory to the data folder for each do.file. 

Thank you. 