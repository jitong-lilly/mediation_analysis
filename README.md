# Mediation Analysis Shiny App Documentation #

This README contains all the necessary documentation and instructions corresponding to the Mediation Analysis R Shiny App. 

## Key Files ##
1. `mediation_app.R`: This is the R script file used to create and generate the app. All app related code are in this file.
2. `functions.R`: This is th e R script file used to store all necessary functions used in the Shiny App. This file has functions to conduct the following:
    1. `my_cmest`: Used to fit all mediation analysis
    2. `estimates`: Used to run single mediator mediation analysis, generate path estimates table, and generate forest plot visulization for the estimates. Example of how to access contents `estimates <- function(....)`: 
       * `estimates$table`: To access path estimates summary table
       * `estimates$plot`: To access single mediator path effects forest plot
       * `estimates$pm`: To access proportion mediated estimate
       * `estimates$summary`: To access summary output of mediation analysis model fit
