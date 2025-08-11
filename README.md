# Mediation Analysis Shiny App Documentation #

This README contains all the necessary documentation and instructions corresponding to the Mediation Analysis R Shiny App. 

## Key Files ##
1. **mediation_app.R**: This is the R script file used to create and generate the app. All app related code are in this file.
2. **functions.R**: This is th e R script file used to store all necessary functions used in the Shiny App. This file has functions to conduct the following:
    1. `my_cmest`: Used to fit all mediation analysis.
    2. `estimates`: Used to run single mediator mediation analysis, generate path estimates table, and generate forest plot visulization for the estimates. Example of how to access contents `estimates <- function(....)`: 
       * `estimates$table`: To access path estimates summary table
       * `estimates$plot`: To access single mediator path effects forest plot
       * `estimates$pm`: To access proportion mediated estimate
       * `estimates$summary`: To access summary output of mediation analysis model fit
    3. `generate_stacked_estimate_plots`: Used to generate stacked forest plot for multiple mediation analysis.
    4. `file_of_estimates`: Used to extract raw estimate values from summary output to save to an Excel file.
    5. `run_multiple_mediator_models`: Used to run joint and marginal models for multiple mediation analysis.
    6. `generate_interpretation_text`: Used to generate sample interpretations on mediation analysis results.
    7. `generate_dag_plot`: Used to generate DAG plot.

## Supplemenatry Files ##
1. **User_guide_single_fix.Rmd**: This is the User Guide Rmd file.
2. **report_template_sf.Rmd** and **report_template_mf.Rmd**: These are the report templates used to allow users to download a report of the analysis results using the Shiny App. sf is the single mediator fixed time point template and mf is the multiple mediator fixed time point template.

## Important Folders ##
1. **www**: This is the folder containing the rendered html User Guide as well as the Lilly logo image. Shiny requires external files added to the app to be in a folder titled “www” so don’t change the name or remove this folder. The app will not generate the Lilly Logo or the User Guide if this folder is removed or renamed
2. **renv** / **renv.lock**: For publishing app on Posit Connect. More information [here](https://collab.lilly.com/:w:/r/sites/Intern2025-MediationAnalysis/Shared%20Documents/Zoe/Mediation%20App/Documentations%20and%20Instructions/Publishing%20App%20on%20Posit%20Connect%20Instructions.docx?d=w56f667d26a954b21ad09074803a1b815&csf=1&web=1&e=cIAYZI)
