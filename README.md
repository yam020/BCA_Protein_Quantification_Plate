# BCA_Protein_Quantification_Plate
This R script is for BCA protein quantification and reorientation. 

## Input 
Input dataset is limited to 9 rows and 12 columns as shown in the [sample dataset](https://github.com/yam020/BCA_Protein_Quantification_Plate/tree/main/sample%20dataset). <br/>
For input dataset smaller than the size of limitation, fill the extra cells with 0 before uploading the dataset. <br/>
The script can only run one plate data everytime. <br/>
The desired input format is csv or excel. <br/>

## Output 
The script will produce three outcomes:
1. Plot of concentration with equation y = mx+b and R sq value (output name: concentration.pdf)
2. CSV file contains measurement of protein in ug in plate format with reorientated order (output name: results.csv)
3. Line chart of quantified protein result in reorientated order (output name: fraction.pdf)
There is a [sample output file](https://github.com/yam020/BCA_Protein_Quantification_Plate/tree/main/sample%20output) for reference. 

## When running the script 
Please install these three packages: **ggplot2**, **dplyr**, **tidyr**, **stringr** before running the code.  
Please set the working direcotry before running the code.  
Output will be saved in the choosen working directory.  
Please click **"source"** when running the code.  
A window will open for users to select its input file.  
Then users can input the standard position and concentration, as well as volume in each fraction.  
Viola! All done!  
