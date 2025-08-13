# Call R script with all functions
source("functions.R")

# Regression types
# outcome_reg_types = c("linear", "logistic", "loglinear", "poisson",
#                       "quasipoisson", "negbin", "multinomial", "ordinal", 
#                       "coxph", "aft_exp", "aft_weibull")
# 
# mediator_reg_types = c("linear", "logistic", "loglinear", "poisson",
#                        "quasipoisson", "negbin", "multinomial", "ordinal")
# 
# mediator_model_types = c("rb", "ne", "gformula")

# FOR TESTING PURPPOSES
outcome_reg_types = c("linear", "logistic")

mediator_reg_types = c("linear", "logistic")

mediator_model_types = c("rb", "gformula")

# UI -------------------------------------------------------------------------------------------------------------------------------
ui <- dashboardPage(
  dashboardHeader(title = "Mediation Analysis"),
  
  # Dashboard tabs
  dashboardSidebar(sidebarMenu(
    id = "tabs",
    
    # Welcome Tab
    menuItem("Welcome", tabName = "welcome", icon = icon("home")),
    
    # User Guide Tab
    menuItem(
      "User Guide",
      tabName = "guide_single",
      icon = icon("book")
    ),
    
    # Mediation Analysis Tabs
    menuItem(
      "Mediation Analysis",
      icon = icon("chart-bar"),
      menuSubItem("Single Mediator Fixed Time", tabName = "single_fixed"),
      menuSubItem("Multiple Mediator Fixed Time", tabName = "multiple_fixed")
    )
  )), 
  
  dashboardBody(
    tags$head(
      # serif font
      tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css2?family=Playfair+Display:wght@500;700&display=swap"),
      # Animate.css
      tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css")
    ),
    
    useWaiter(),
    
    # Custom CSS for color theme (can ignore; just for design purposed) ----------------------------------------------------------------------------
    tags$head(tags$style(
      HTML("/* Logo */
                .main-header .logo {
                  background-color: #b3ccd1 !important;
                    color: #3C4748 !important;
                    font-size: 23px;
                  text-align: center;
                }
              /* HEADER */
                .main-header .navbar {
                  background-color: #b3ccd1 !important;
                }
              /* SIDEBAR */
                .main-sidebar {
                  background-color: #4A5859 !important;
                }
              /* BODY BACKGROUND */
                .content-wrapper {
                  background-color: #fefdfc;
                }
              /* ACTIVE SIDEBAR TAB */
                .skin-blue .main-sidebar .sidebar .sidebar-menu .active a {
                  background-color: #4A5859 !important;
                    color: white !important;
                }
              /* SIDEBAR LINKS */
                .sidebar-menu a {
                  color: white !important;
                }
              
              /* ACTIVE submenu tab — make it darker */
                .skin-blue .main-sidebar .sidebar-menu .treeview-menu > li.active > a {
                  background-color: #2f393a !important;  /* darker than #4A5859 */
                    color: white !important;
                }
              
              /* INACTIVE submenu tabs — lighter or neutral */
                .skin-blue .main-sidebar .sidebar-menu .treeview-menu > li > a {
                  background-color: #4A5859 !important;
                    color: white !important;
                }
              
              /* Box header colors */
                .box.box-solid.box-primary > .box-header {
                  background-color: #ede8f0 !important;
                    color: black !important;
                  font-weight: bold;}"
      )
    )),
    
    # Page Contents -------------------------------------------------------------------------------------
    tabItems(
      # Welcome page contents ---------------------------------------------------------------------------
      tabItem(
        tabName = "welcome",
        fluidPage(
          ### Welcome banner -----------------------------------------------------------------------------
          fluidRow(
            column(
              width = 12,
              
              # Outer gradient border wrapper
              tags$div(
                style = "background: linear-gradient(120deg, #b3d7f2, #ffdae0);
                                                     padding: 15px;
                                                     border-radius: 25px;
                                                     margin-bottom: 25px;",
                
                # Inner white banner container
                tags$div(class = "animate__animated animate__fadeInDown",
                         style = "display: flex;
                                                     justify-content: center;                 
                                                     padding: 50px 30px;
                                                     background-color: white;
                                                     border-radius: 16px;
                                                     box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);",
                         
                         # Inner wrapper: text + logo unit
                         tags$div(
                           style = "display: flex;
                                                     align-items: center;
                                                     flex-wrap: wrap;
                                                     gap: 20px;
                                                     max-width: 1000px;
                                                     width: 100%;
                                                     justify-content: center;",
                           
                           # Text Block (left)
                           tags$div(
                             style = "flex: 1 1 600px; min-width: 300px;",
                             tags$h1(
                               "Mediation Analysis Shiny App",
                               style = "font-family: 'Playfair Display', serif;
                                                     font-size: 44px;
                                                     font-weight: 600;
                                                     color: #2c3e50;
                                                       margin-bottom: 20px;"
                             ),
                             # Banner Caption
                             tags$p(
                               "Welcome to the mediation analysis shiny app! Conduct causal mediation analysis with ease using the CMAverse R package here!",
                               style = "font-size: 20px; color: #555; line-height: 1.6;"
                             )
                           ),
                           
                           # Logo Block (right)
                           tags$div(
                             style = "flex: 0 0 220px; min-width: 160px; text-align: center;",
                             tags$img(
                               src = "lilly_logo.png",
                               style = "width: 100%;
                height: auto;
                object-fit: contain;
                vertical-align: middle;
                margin: 0;"
                             )
                           )
                         )
                )
              )
            )
          ), 
          
          br(),
          
          ### App Feature section -------------------------------------------------------------------------
          fluidRow(
            column(
              width = 12,
              tags$div(
                style = "background-color: white; padding: 30px; border-radius: 12px; box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);",
                HTML("<h2 style='
                     font-weight: 600;
                     font-size: 26px;
                     padding-bottom: 8px;
                     background-image: linear-gradient(120deg, #b3d7f2, #ffdae0);
                                                       background-repeat: no-repeat;
                                                       background-position: 0 100%;
                                                       background-size: 100% 3px;
                                                       '>
                                                       What this App Can Currently Do
               </h2>
                
                <p style='font-size: 16px; line-height: 1.7; margin-bottom: 20px;'>
                This interactive tool is designed to make causal mediation analysis more accessible for anyone at Lilly looking to conduct mediation analysis. 
                Whether you're exploring causal mechanisms, validating mediation pathways, or presenting
                findings to collaborators, this app provides a clean interface powered by the <b>CMAverse</b> R package!
                </p>
                
                <ul style='font-size: 17px; line-height: 1.8; margin-left: 20px;'>
                <li>Fit <b>single</b> and <b>multiple mediator</b> models at fixed time points</li>
                <li>Support a wide range of <b>outcome</b> and <b>mediator types</b></li>
                <li>Handle <b>missing data</b> via complete-case or multiple imputation</li>
                <li>Estimate <b>various path effects (total, direct, and indirect effects)</b> and <b>proportion mediated</b> using <code>cmest()</code></li>
                <li>Visualizations of <b>DAGs</b> and <b>path estimates</b> </li>
                <li>Generate <b>sample interpretations</b> of mediation results
                <li>Export clean results and share with collaborators</li>
                <li>Use for <b>research</b>, <b>validation</b>, or <b>scientific communication</b></li>
                </ul>
                
                <p style='font-size: 15px; color: #555; margin-top: 10px; margin-left: 20px;'>
                <i>For technical details, model assumptions, and background on causal mediation,
                please visit the <a href='#guide'><b>User Guide</b></a> section of this app.</i>
                </p>")
              )
            )
          ),
          
          br(), 
          br(),
          
          ### About CMAverse section -------------------------------------------------------------------------------
          fluidRow(
            column(
              width = 12,
              tags$div(
                style = "background-color: white; padding: 30px; border-radius: 12px; box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);",
                HTML("<h2 style='
                     font-weight: 600;
                     font-size: 26px;
                     padding-bottom: 8px;
                     background-image: linear-gradient(120deg, #b3d7f2, #ffdae0);
                                                       background-repeat: no-repeat;
                                                       background-position: 0 100%;
                                                       background-size: 100% 3px;
                                                       '>
                                                       About CMAverse
               </h2>
                <p style='font-size: 16px; line-height: 1.8; margin-bottom: 15px;'>
                   <b>CMAverse</b> is a comprehensive R package for reproducible causal mediation analysis. This app currently uses these select functions:
               </p>
               
               <ul style='font-size: 16px; line-height: 1.8; margin-left: 20px;'>
                  <li><code>cmest()</code> — fits mediation models with:
                  <ul style='margin-top: 5px; margin-bottom: 5px;'>
                    <li>Support for continuous, binary, count, and survival outcomes</li>
                    <li>Regression-based, weighting-based, natural effect models, and g-formula methods</li>
                    <li>Estimates total, direct, indirect effects and proportion mediated</li>
                    <li>Supports multiple imputation for missing data via <code>multimp = TRUE</code></li>
              </ul>
              </li>
              </ul>
              
              <h3 style='font-size: 18px; font-weight: bold; margin-top: 30px;'>Supported Data Types and Functionalities</h3>
              <div style='overflow-x: auto; margin-top: 10px;'>
                <table style='border-collapse: collapse; font-size: 14px;'>
                   <thead>
                   <tr style='background-color: #eaeaea; border-bottom: 1px solid #ccc;'>
                     <th style='padding: 6px 10px; text-align: left;'>Feature</th>
                     <th style='padding: 6px 10px; text-align: center;'>rb</th>
                     <th style='padding: 6px 10px; text-align: center;'>wb</th>
                     <th style='padding: 6px 10px; text-align: center;'>iorw</th>
                     <th style='padding: 6px 10px; text-align: center;'>ne</th>
                     <th style='padding: 6px 10px; text-align: center;'>msm</th>
                     <th style='padding: 6px 10px; text-align: center;'>gformula</th>
                  </tr>
                  </thead>
                  <tbody>
                    <tr style='border-bottom: 1px solid #ddd;'>
                      <td style='padding: 6px 10px;'>Continuous Y</td>
                      <td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td>
                      <td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td>
                  </tr>
                  <tr style='border-bottom: 1px solid #ddd;'>
                    <td style='padding: 6px 10px;'>Binary Y</td>
                    <td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td>
                    <td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td>
                 </tr>
                 <tr style='border-bottom: 1px solid #ddd;'>
                   <td style='padding: 6px 10px;'>Count Y</td>
                   <td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td>
                   <td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td>
                 </tr>
                <tr style='border-bottom: 1px solid #ddd;'>
                   <td style='padding: 6px 10px;'>Survival Y</td>
                   <td style='text-align: center;'>✓</td><td style='text-align: center;'>×</td><td style='text-align: center;'>✓</td>
                   <td style='text-align: center;'>×</td><td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td>
               </tr>
               <tr style='border-bottom: 1px solid #ddd;'>
                 <td style='padding: 6px 10px;'>Continuous M</td>
                 <td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td>
                 <td style='text-align: center;'>✓</td><td style='text-align: center;'>×</td><td style='text-align: center;'>✓</td>
              </tr>
                <tr style='border-bottom: 1px solid #ddd;'>
                <td style='padding: 6px 10px;'>Binary M</td>
                <td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td>
                <td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td>
             </tr>
                <tr style='border-bottom: 1px solid #ddd;'>
                <tr style='border-bottom: 1px solid #ddd;'>
                <td style='padding: 6px 10px;'>Count M</td>
                <td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td>
                <td style='text-align: center;'>✓</td><td style='text-align: center;'>×</td><td style='text-align: center;'>✓</td>
             </tr>
             <tr style='border-bottom: 1px solid #ddd;'>
                <td style='padding: 6px 10px;'>Binary A</td>
                <td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td>
                <td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td>
             </tr>
             <tr style='border-bottom: 1px solid #ddd;'>
                <td style='padding: 6px 10px;'>Mediator-outcome Confounder(s) Affected by A</td>
                <td style='text-align: center;'>×</td><td style='text-align: center;'>×</td><td style='text-align: center;'>×</td>
                <td style='text-align: center;'>×</td><td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td>
             </tr>
                <tr style='border-bottom: 1px solid #ddd;'>
                <td style='padding: 6px 10px;'>Estimation: Closed-form Parameter Function</td>
                <td style='text-align: center;'>✓</td><td style='text-align: center;'>×</td><td style='text-align: center;'>×</td>
                <td style='text-align: center;'>×</td><td style='text-align: center;'>×</td><td style='text-align: center;'>×</td>
             </tr>
             <tr style='border-bottom: 1px solid #ccc;'>
                <td style='padding: 6px 10px;'>Estimation: Direct Counterfactual Imputation</td>
                <td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td>
                <td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td>
             </tr>
                <tr style='border-bottom: 1px solid #ccc;'>
                <td style='padding: 6px 10px;'>Inference: Bootstrapping</td>
                <td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td>
                <td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td><td style='text-align: center;'>✓</td>
            </tr>
            </tbody>
            </table>
            </div>

            <div style='font-size: 13px; color: #666; margin-top: 12px; line-height: 1.6;'>
            <div>• <b>rb</b>: regression-based approach</div>
            <div>• <b>ne</b>: natural effect model</div>
            <div>• <b>gformula</b>: g-formula approach</div>
            <div>• <b>Y</b>: outcome; <b>A</b>: exposure; <b>M</b>: mediator(s); <b>C</b>: confounder(s) not affected by A</div>
            <div>• Closed-form parameter function estimation only supports a single mediator</div>
            <div>• Delta method inference is available only when closed-form estimation is used</div>
            <div>• Marginal effects are estimated when direct counterfactual imputation is used</div>
            <div>• Conditional effects are estimated when closed-form parameter estimation is used</div>
            <div style='color: #b30000; font-weight: 500;'>
                 • Not all functionalities from <code> cmest</code> are implemented in this app. Additional features to be added in the future!
            </div>
            </div>

            <h3 style='font-size: 18px; font-weight: bold; margin-top: 30px;'>Installation</h3>
            <p style='font-size: 16px; line-height: 1.8;'>
            <code>devtools::install_github(\"BS1125/CMAverse\")</code><br/>
            <code>library(CMAverse)</code>
            </p>

            <h3 style='font-size: 18px; font-weight: bold; margin-top: 30px;'>More Resources on CMAverse</h3>
            <ul style='font-size: 16px; line-height: 1.8; margin-left: 20px;'>
            <li><a href='https://bs1125.github.io/CMAverse/articles/overview.html#summary-of-supported-data-types' target='_blank'>Overview: Summary of Supported Data Types</a></li>
            <li><a href='https://bs1125.github.io/CMAverse/index.html' target='_blank'>CMAverse Documentation</a></li>
            <li><a href='https://github.com/BS1125/CMAverse' target='_blank'>GitHub Repository</a></li>
            </ul>")
              )
            )
          ), 
          
          br(), 
          
          ### References section -------------------------------------------------------------------------------
          fluidRow(column(
            width = 12,
            tags$div(
              style = "
                background-color: white;
                padding: 30px;
                border-radius: 12px;
                margin-top: 20px;
                margin-bottom: 40px;
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);",
              HTML("<h2 style='
                     font-weight: 600;
                     font-size: 26px;
                     padding-bottom: 8px;
                     background-image: linear-gradient(120deg, #b3d7f2, #ffdae0);
                                                       background-repeat: no-repeat;
                                                       background-position: 0 100%;
                                                       background-size: 100% 3px;
                                                       '>
                                                       Select References
               </h2>

               <p style='font-size: 16px; line-height: 1.8; color: #444; margin-bottom: 25px;'>
               Want to learn more about mediation analysis and its applications in clinical settings?
               Check out these selected references!
               </p>

               <h3 style='font-size: 20px; font-weight: bold; color: #1a4d8f; margin-bottom: 10px;'>Informational References</h3>
               <ul style='font-size: 16px; line-height: 1.9; color: #2b2b2b; margin-left: 20px;'>

               <li>
               <b><i><a href='https://pmc.ncbi.nlm.nih.gov/articles/PMC2819368/' target='_blank' style='color: #1a4d8f; text-decoration: none;'>Mediation Analysis</a></i></b><br/>
               MacKinnon DP, Fairchild AJ, Fritz MS. <i>Annu Rev Psychol.</i> 2007;58:593–614.
               </li>

              <li style='margin-top: 20px;'>
                 <b><i><a href='https://pmc.ncbi.nlm.nih.gov/articles/PMC4402024/' target='_blank' style='color: #1a4d8f; text-decoration: none;'>Causal Mediation Analysis with Multiple Mediators</a></i></b><br/>
                 Daniel RM, De Stavola BL, Cousens SN, Vansteelandt S. <i>Biometrics.</i> 2015 Mar;71(1):1–14.
              </li>

              <li style='margin-top: 20px;'>
                 <b><i><a href='https://pmc.ncbi.nlm.nih.gov/articles/PMC3659198/' target='_blank' style='color: #1a4d8f; text-decoration: none;'>Mediation Analysis Allowing for Exposure–Mediator Interactions and Causal Interpretation</a></i></b><br/>
                 Valeri L, VanderWeele TJ. <i>Psychol Methods.</i> 2013 Jun;18(2):137–150.
              </li>

              <li style='margin-top: 20px;'>
                <b><i><a href='https://pmc.ncbi.nlm.nih.gov/articles/PMC5285457/' target='_blank' style='color: #1a4d8f; text-decoration: none;'>Parametric Mediational g-Formula Approach to Mediation Analysis</a></i></b><br/>
                Lin SH, Young J, Logan R, Tchetgen Tchetgen EJ, VanderWeele TJ. <i>Epidemiology.</i> 2017 Mar;28(2):266–274.
              </li>

             <li style='margin-top: 20px;'>
                <b><i><a href='https://jamanetwork.com/journals/jama/fullarticle/2784353' target='_blank' style='color: #1a4d8f; text-decoration: none;'>A Guideline for Reporting Mediation Analyses of Randomized Trials and Observational Studies</a></i></b><br/>
                 Lee H, Cashin AG, Lamb SE, et al. <i>JAMA.</i> 2021;326(11):1045–1056.
             </li>

             <li style='margin-top: 20px;'>
                <b><i><a href='https://pmc.ncbi.nlm.nih.gov/articles/PMC8190553/' target='_blank' style='color: #1a4d8f; text-decoration: none;'>Introduction to Mediation Analysis and Examples of Its Application to Real-world Data</a></i></b><br/>
                Jung SJ. <i>J Prev Med Public Health.</i> 2021 May;54(3):166–172.
             </li>

             </ul>

             <h3 style='font-size: 20px; font-weight: bold; color: #1a4d8f; margin-top: 40px; margin-bottom: 10px;'>Clinical Applications</h3>
             <ul style='font-size: 16px; line-height: 1.9; color: #2b2b2b; margin-left: 20px;'>

             <li>
               <b><i><a href='https://dom-pubs.pericles-prod.literatumonline.com/doi/10.1111/dom.15333' target='_blank' style='color: #1a4d8f; text-decoration: none;'>
               Gastrointestinal adverse events and weight reduction in people with type 2 diabetes treated with tirzepatide in the SURPASS clinical trials
             </a></i></b><br/>
               Patel H, Khunti K, Rodbard HW, et al. <i>Diabetes Obes Metab.</i> 2024;26(2):473–481.
             </li>

             <li style='margin-top: 20px;'>
                <b><i><a href='https://pmc.ncbi.nlm.nih.gov/articles/PMC10039543/' target='_blank' style='color: #1a4d8f; text-decoration: none;'>
                 Systolic blood pressure reduction with tirzepatide in patients with type 2 diabetes: insights from SURPASS clinical program
               </a></i></b><br/>
               Lingvay I, Mosenzon O, Brown K, Cui X, O'Neill C, Fernández Landó L, Patel H. <i>Cardiovasc Diabetol.</i> 2023 Mar 24;22(1):66.
             </li>

             <li style='margin-top: 20px;'>
                 <b><i><a href='https://pmc.ncbi.nlm.nih.gov/articles/PMC9440529/' target='_blank' style='color: #1a4d8f; text-decoration: none;'>
                 Impact of semaglutide on high-sensitivity C-reactive protein: exploratory patient-level analyses of SUSTAIN and PIONEER randomized clinical trials
                 </a></i></b><br/>
                 Mosenzon O, Capehorn MS, De Remigis A, Rasmussen S, Weimers P, Rosenstock J. <i>Cardiovasc Diabetol.</i> 2022 Sep 2;21(1):172.
             </li>

             <li style='margin-top: 20px;'>
                 <b><i><a href='https://jamanetwork.com/journals/jama/fullarticle/2784353' target='_blank' style='color: #1a4d8f; text-decoration: none;'>
                  Effect of Subcutaneous Semaglutide vs Placebo on Body Weight in Adults With Overweight or Obesity: The STEP 1 Randomized Clinical Trial
                  </a></i></b><br/>
                  Wilding JPH, Batterham RL, Calanna S, et al. <i>JAMA.</i> 2021;325(14):1403–1413.
            </li>

            <li style='margin-top: 20px;'>
                 <b><i><a href='https://pmc.ncbi.nlm.nih.gov/articles/PMC9118507/' target='_blank' style='color: #1a4d8f; text-decoration: none;'>
                 Association between high-sensitivity C-reactive protein, functional disability, and stroke recurrence in patients with acute ischaemic stroke: A mediation analysis
                 </a></i></b><br/>
                 Gu HQ, Yang KX, Lin JX, et al. <i>EBioMedicine.</i> 2022 Jun;80:104054.
            </li>

            <li style='margin-top: 20px;'>
              <b><i><a href='https://pmc.ncbi.nlm.nih.gov/articles/PMC6786903/' target='_blank' style='color: #1a4d8f; text-decoration: none;'>
              Mediation analysis of the alcohol-postmenopausal breast cancer relationship by sex hormones in the EPIC Cohort
              </a></i></b><br/>
              Assi N, Rinaldi S, Viallon V, et al. <i>Int J Cancer.</i> 2020 Feb 1;146(3):759–768.
             </li>

            </ul>"
              )
            )
          )
          ), 
          
          ### Contact section -----------------------------------------------------------
          fluidRow(
            column(
              width = 12,
              tags$div(
                style = "
                background-color: white;
                padding: 35px 40px;
                border-radius: 14px;
                margin-top: 20px;
                margin-bottom: 40px;
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);",
                HTML("
                <h2 style='
                     font-weight: 600;
                     font-size: 26px;
                     padding-bottom: 8px;
                     background-image: linear-gradient(120deg, #b3d7f2, #ffdae0);
                                                       background-repeat: no-repeat;
                                                       background-position: 0 100%;
                                                       background-size: 100% 3px;
                                                       '>
                                                       Have Questions or Concerns?
                     </h2>

                     <p style='font-size: 16px; line-height: 1.8; color: #333; margin-bottom: 10px;'>
                     If you have any questions, encounter bugs, or have suggestions for improvement, feel free to contact the below:
                     </p>
                
                     <ul style='list-style: none; padding-left: 0; font-size: 16px; line-height: 2.2; color: #1d3557;'>
                     <li>📧 <b>Jitong Lou</b> — <a href='mailto:lou_jitong@lilly.com' style='color: #1a4d8f;'>lou_jitong@lilly.com</a></li>
                     <li>📧 <b>Zoe Lu</b> — <a href='mailto:zoe.lu@lilly.com' style='color: #1a4d8f;'>zoe.lu@lilly.com</a></li>
                     </ul>"
                )
              )
            )
          ),
          br()
        )
      ),
      
      # User Guide page contents ------------------------------------------------------------------
      tabItem(
        tabName = "guide_single",
        tags$iframe(
          src = "User_guide_single_fix.html",
          width = "100%",
          height = "1200px", 
          style = "border:none; overflow:auto;"
        )
      ), 
      
      # Single mediator fixed time point page contents --------------------------------------------------
      tabItem(
        tabName = "single_fixed",
        h2("Single Mediator at Fixed Time Point"),
        
        p("This page is for conducting mediation analysis when you have a single mediator at a fixed time point.
          Please make sure to select the correct regression types corresponding to your mediator/ outcome type!"
        ),
        
        ## Model User Inputs and Results Output ----------------------------------------------------------
        fluidRow(
          # Sidebar-like box with inputs
          column(
            width = 4,
            box(
              # Data input
              title = "Model Inputs",
              width = 12,
              solidHeader = TRUE,
              id = "analysis-options-box",
              class = "box-solid",
              status = "primary",
              collapsible = TRUE,
              collapsed = FALSE,
              
              fileInput("single_fixed_file", "Upload Fully Cleaned Data File (csv only)", accept = ".csv"),
              
              # Exposure input
              selectizeInput(
                inputId = "exposure_sf",
                "Exposure (Coded as 0 = Control, 1 = Active)",
                choices = NULL
              ),
              
              # Mediator Variable Input
              selectizeInput(inputId = "mediator_sf", "Mediator", choices = NULL),
              selectizeInput(
                inputId = "mreg_sf",
                "Mediator Model",
                choices = c(NULL, mediator_reg_types)
              ),
              
              # Outcome variable input
              selectizeInput(inputId = "outcome_sf", "Outcome", choices = NULL),
              selectizeInput(
                inputId = "yreg_sf",
                "Outcome Model",
                choices = c(NULL, outcome_reg_types)
              ),
              
              # uiOutput("eventvar_ui_sf"),  
              
              # Baseline confounder input
              selectizeInput(
                inputId = "basec_sf",
                "Baseline Covariates/ Confounders",
                multiple = TRUE,
                label = tagList(
                  strong("Baseline Covariates/ Confounders"),
                  tags$br(),
                  tags$small("Leave empty if there are no baseline confounders.", style = "font-style: italic; font-weight: 500; font-size: 13px; color: #de7073;")
                ),
                choices = NULL
              ),
              
              # Post exposure confounders
              selectizeInput(
                inputId = "postc_sf",
                multiple = TRUE,
                label = tagList(
                  strong("Post Exposure Confounders"),
                  tags$br(),
                  tags$small("Leave empty if there are no post exposure confounders.", style = "font-style: italic; font-weight: 500; font-size: 13px; color: #de7073;")
                ),
                choices = c(NULL)
              ),
              
              # Corresponding model for postc if needed
              uiOutput("postcreg_ui_sf"),
              
              # interactions input
              radioButtons(
                inputId = "Emint_sf",
                "Include Exposure-Mediator Interactions",
                choices = c(TRUE, FALSE), 
                selected = TRUE
              ),
              
              # Mediation model type
              selectizeInput(
                inputId = "model_sf",
                label = tagList(
                  strong("Choose a Mediation Analysis Model Type"),
                  tags$br(),
                  tags$small(
                    "Refer to the User Guide for a better understanding of model types. 
                    Most common is 'rb' if no post exposure confounding. If you have post exposure confounders, select 'gformula'",
                    style = "font-style: italic; font-weight: 500; font-size: 13px; color: #de7073;"
                  )
                ),
                choices = mediator_model_types
              ),
              
              # Missing data handling
              conditionalPanel(
                condition = "output.show_missing_ui_sf == true",
                uiOutput("missing_handling_ui_sf"),
                uiOutput("mi_number_input_sf")
              ), 
              
              # Estimation Method Input
              radioButtons(
                inputId = "estimation_sf",
                label = tagList(
                  strong("Estimation Method for Path Effects"),
                  tags$br(),
                  tags$small(
                    "Only choose Closed Form Solution if you have continuous outcome /rare binary outcome and want a closed form solution. 
                    All other outcome types choose Bootstrap Solution",
                    style = "font-style: italic; font-weight: 500; font-size: 13px; color: #de7073;"
                  )
                ),
                choices = c(
                  "Bootstrap Solution" = "imputation",
                  "Closed Form Solution" = "paramfunc"
                ),
                selected = "imputation"
              ),
              
              # Show Bootstrap input only if 'imputation' is selected
              conditionalPanel(
                condition = "input.estimation_sf == 'imputation'",
                numericInput(
                  inputId = "nboot_sf",
                  label = "Bootstrap Reps for Path Estimates",
                  value = 200,
                  min = 100
                )
              ),
              
              # Seed input
              numericInput(
                inputId = "seed_sf",
                "Set a Seed",
                value = 2025,
                min = 1
              ),
              actionButton(inputId = "run_single_fixed", "Run Analysis")
            ), 
            
            # Download Estimstes button
            box(
              title = "Download All Mediation Analysis Estimates",
              width = 12,
              solidHeader = TRUE,
              id = "analysis-options-box",
              class = "box-solid",
              status = "primary",
              collapsible = TRUE,
              collapsed = FALSE,
              style = "overflow-x: auto;",
              withSpinner(
                downloadButton("estimates_download_sf", "Click Here to Download!"),
                type = 7,
                color = "#b3ccd1"
              )
            ), 
            
            # Download report button
            box(
              title = "Download Report of Analysis",
              width = 12,
              solidHeader = TRUE,
              status = "primary",
              collapsible = TRUE,
              collapsed = FALSE,
              style = "overflow-x: auto;",
              withSpinner(
                downloadButton("pdf_report_sf", "Click Here to Download Word Report"),
                type = 7,
                color = "#b3ccd1"
              )
            )
          ), 
          
          ## Output section stacked in right column -----------------------------------------------------
          column(
            width = 8,
            box(
              title = "Directed Acyclic Graph (DAG)",
              width = 12,
              solidHeader = TRUE,
              id = "analysis-options-box",
              class = "box-solid",
              status = "primary",
              collapsible = TRUE,
              collapsed = FALSE,
              withSpinner(
                tagList(
                  plotOutput("dag_plot_sf", height = "400px"),
                  br(),  # adds vertical space
                  div(
                    style = "font-size: 18px; margin-top: 10px;",
                    textOutput("dag_annotation_sf")
                  )
                ),
                type = 7,
                color = "#b3ccd1"
              )
              
            ),
            ## Path effect table box -----------------------------------------------------------
            box(
              title = "Path Effect Estimates",
              width = 12,
              solidHeader = TRUE,
              id = "analysis-options-box",
              class = "box-solid",
              status = "primary",
              collapsible = TRUE,
              collapsed = FALSE,
              style = "overflow-x: auto;",
              withSpinner(
                DTOutput("path_table_sf"),
                type = 7,
                color = "#b3ccd1"
              ),
              uiOutput("estimate_table_note")
            ),
            
            ## Path estimate plot box----------------------------------------------------------
            box(
              title = "Path Effects Visualization",
              width = 12,
              solidHeader = TRUE,
              id = "analysis-options-box",
              class = "box-solid",
              status = "primary",
              collapsible = TRUE,
              collapsed = FALSE,
              style = "overflow-x: auto;",
              withSpinner(
                plotOutput("path_plot_sf", height = "380px"),
                type = 7,
                color = "#b3ccd1"
              )
            ),
            
            ## Proportion mediator box ---------------------------------------------------------
            box(
              title = "Proportion Mediated",
              width = 12,
              solidHeader = TRUE,
              id = "analysis-options-box",
              class = "box-solid",
              status = "primary",
              collapsible = TRUE,
              collapsed = FALSE,
              style = "overflow-x: auto;",
              withSpinner(
                tagList(
                  uiOutput("pm_sf"),
                  uiOutput("pm_warning_note_sf")
                ),
                type = 7,
                color = "#b3ccd1"
              )
            ),
            
            ## Sample interpretation box ------------------------------------------------------
            box(
              title = "Sample Interpretations",
              width = 12,
              solidHeader = TRUE,
              id = "analysis-options-box",
              class = "box-solid",
              status = "primary",
              collapsible = TRUE,
              collapsed = FALSE,
              style = "overflow-x: auto;",
              withSpinner(
                tagList(
                  uiOutput("sample_interpretation_sf"),
                  br(),
                  uiOutput("interpretation_note")
                ),
                type = 7,
                color = "#b3ccd1"
              )
            ), 
            
            ## Raw output box --------------------------------------------------------------------
            box(
              title = "Raw Output- Click to Expand!",
              width = 12,
              solidHeader = TRUE,
              id = "analysis-options-box",
              class = "box-solid",
              status = "primary",
              collapsible = TRUE,
              collapsed = TRUE,
              style = "overflow-x: auto;",
              withSpinner(
                verbatimTextOutput("cmest_summary_sf"),
                type = 7,
                color = "#b3ccd1"
              )
            )
          )
        )
      ),
      
      # Multiple mediator fixed time page contents ------------------------------------------------------------------------------------------------
      tabItem(
        tabName = "multiple_fixed",
        h2("Multiple Mediator at Fixed Time Point"),
        p("This page is for conducting mediation analysis when you have multiple mediators at a fixed time point.
          Please make sure to select the correct regression types corresponding to your mediator/ outcome type!"
        ),
        
        ## Model User Inputs and Results Output ---------------------------------------------------------------------------------------------------
        fluidRow(
          # Sidebar-like box with inputs
          column(
            width = 4,
            box(
              title = "Model Inputs",
              width = 12,
              solidHeader = TRUE,
              id = "analysis-options-box",
              class = "box-solid",
              status = "primary",
              collapsible = TRUE,
              collapsed = FALSE,
              
              # File input
              fileInput("multiple_fixed_file", "Upload Fully Cleaned Data File (csv only)", accept = ".csv"),
              
              # Exposure variable input
              selectizeInput(
                inputId = "exposure_mf",
                "Exposure (Coded as 0 = Control, 1 = Active)",
                choices = NULL
              ),
              
              # Mediator variable input
              selectizeInput(
                inputId = "mediator_mf",
                "Mediator",
                choices = NULL,
                multiple = TRUE
              ),
              
              # mediator regression input
              uiOutput("mreg_ui_mf"),
              
              # outcome variable input
              selectizeInput(inputId = "outcome_mf", "Outcome", choices = NULL),
              selectizeInput(
                inputId = "yreg_mf",
                "Outcome Model",
                choices = c(NULL, outcome_reg_types)
              ),
              
              # outcome regression input
              uiOutput("eventvar_ui_mf"),
              
              # Baseline confounder inputs
              selectizeInput(
                inputId = "basec_mf",
                "Baseline Covariates/ Confounders",
                multiple = TRUE,
                choices = NULL
              ),
              
              # Post exposure confounder inputs
              selectizeInput(
                inputId = "postc_mf",
                multiple = TRUE,
                label = tagList(
                  strong("Post Exposure Confounders"),
                  tags$br(),
                  tags$small("Leave empty if there are no post exposure confounders.", style = "font-style: italic; font-weight: 500; font-size: 13px; color: #de7073;")
                ),
                choices = c(NULL)
              ),
              
              # Post exposure regression if needed
              uiOutput("postcreg_ui_mf"),
              
              # Interactions input
              radioButtons(
                inputId = "Emint_mf",
                "Include Exposure-Mediator Interactions",
                choices = c(TRUE, FALSE)
              ),
              
              # Mediation anaysis type model
              selectizeInput(
                inputId = "model_mf",
                label = tagList(
                  strong("Choose a Mediation Analysis Model Type"),
                  tags$br(),
                  tags$small(
                    "Refer to the User Guide for a better understanding of model types. 
                    Most common is 'rb' if no post exposure confounding. If you have post exposure confounders, choose 'gformula'",
                    style = "font-style: italic; font-weight: 500; font-size: 13px; color: #de7073;"
                  )
                ),
                choices = mediator_model_types
              ),
              
              # MIssing data
              conditionalPanel(
                condition = "output.show_missing_ui_mf == true",
                uiOutput("missing_handling_ui_mf"),
                uiOutput("mi_number_input_mf")
              ),
              
              # Bootstrap reps
              numericInput(
                inputId = "nboot_mf",
                "Bootstrap Reps for Path Estimates",
                value = 200,
                min = 100
              ),
              
              # Seed input
              numericInput(
                inputId = "seed_mf",
                "Set a Seed",
                value = 2025,
                min = 1
              ),
              actionButton(inputId = "run_multiple_fixed", "Run Analysis")
            ),
            
            ## Download estimatnds button --------------------------------------------------------------------------------------------------------------------
            box(
              title = "Download All Mediation Analysis Estimates",
              width = 12,
              solidHeader = TRUE,
              class = "box-solid",
              status = "primary",
              collapsible = TRUE,
              collapsed = FALSE,
              uiOutput("all_model_download_mf"),
              type = 7,
              color = "#b3ccd1"
            ), 
            
            ## Download report button --------------------------------------------------------------------------------------------------------------------
            box(
              title = "Download Report of Analysis",
              width = 12,
              solidHeader = TRUE,
              status = "primary",
              collapsible = TRUE,
              collapsed = FALSE,
              withSpinner(
                uiOutput("pdf_report_button_mf"),
                type = 7,
                color = "#b3ccd1"
              )
            )
          ),
          
          ## Right Column Outputs ----------------------------------------------------------------------------------------------------------------------
          column(
            width = 8,
            ## DAG plot box -----------------------------------------------------------------------------------------------------------------------------
            box(
              title = "Directed Acyclic Graph (DAG) by Model",
              width = 12,
              solidHeader = TRUE,
              class = "box-solid",
              status = "primary",
              collapsible = TRUE,
              collapsed = FALSE,
              uiOutput("all_model_dag_mf")
              # withSpinner(uiOutput("all_model_dag_mf"), type = 7, color = "#b3ccd1")
            ),
            
            ## Path estimates table tab box ------------------------------------------------------------------------------------------------------
            box(
              title = "All Path Effect Estimates by Model",
              width = 12,
              solidHeader = TRUE,
              class = "box-solid",
              status = "primary",
              collapsible = TRUE,
              collapsed = FALSE,
              withSpinner(
                uiOutput("all_model_table_mf"),
                type = 7,
                color = "#b3ccd1"
              )
            ),
            
            ## Proportion mediated tab box ----------------------------------------------------------------------------------------------------------
            box(
              title = "Proportion Mediated (PM) by Model",
              width = 12,
              solidHeader = TRUE,
              class = "box-solid",
              status = "primary",
              collapsible = TRUE,
              collapsed = FALSE,
              withSpinner(
                uiOutput("all_model_pm_mf"),
                type = 7,
                color = "#b3ccd1"
              )
            ),
            
            ## Sample interpretation tab box ----------------------------------------------------------------------------------------------------------
            box(title = "Sample Interpretation by Model", width = 12,
                solidHeader = TRUE, class = "box-solid", status = "primary",
                collapsible = TRUE, collapsed = FALSE,
                withSpinner(uiOutput("all_model_interpretation_mf"), type = 7, color = "#b3ccd1")
            ), 
            
            ## Path estimates combined plot box----------------------------------------------------------------------------------------------------------
            box(
              title = "All Path Effect Plot by Model",
              width = 12,
              solidHeader = TRUE,
              class = "box-solid",
              status = "primary",
              collapsible = TRUE,
              collapsed = FALSE,
              withSpinner(
                plotOutput("combined_plot_mf", height = "auto"),
                type = 7,
                color = "#b3ccd1"
              )
            ),
            
            ## All model summary outputs ------------------------------------------------------------------------------------------------------
            box(
              title = "Raw Outputs by Model - Click to Expand!",
              width = 12,
              solidHeader = TRUE,
              class = "box-solid",
              status = "primary",
              collapsible = TRUE,
              collapsed = TRUE,
              style = "overflow-x: auto;",
              withSpinner(
                uiOutput("all_model_summary_mf"),
                type = 7,
                color = "#b3ccd1"
              )
            )
          )
        ) 
      )
    )
  )
)

# Server -------------------------------------------------------------------------------------------------------------------------------------------------
server <- function(input, output) {
  # Checking/ Requirements for analysis to be ran 
  last_yreg_sf <- reactiveVal(NULL)
  pval_note_mf <- reactiveVal(NULL)
  last_yreg_mf <- reactiveVal(NULL)           
  mediators_snapshot_mf <- reactiveVal(NULL)
  
  # Single mediator fixed time server page ----------------------------------------------------------------------------------------------------------
  ### Rendering one selectInput for each postc confouner regression type --------------------------------------------------------------------------------
  output$postcreg_ui_sf <- renderUI({
    req(input$postc_sf)
    
    lapply(seq_along(input$postc_sf), function(i) {
      selectInput(
        inputId = paste0("postcreg_", i),
        label = paste("Model for", input$postc_sf[i]),
        choices = mediator_reg_types,
        selected = "linear"
      )
    })
  })
  
  ### Handling missing data (input shows if missind data is detected) -----------------------------------------------------------------------------
  output$missing_handling_ui_sf <- renderUI({
    req(has_missing_in_selected_sf())
    percent_missing <- missing_percent_sf()
    
    radioButtons(
      inputId = "mi_handling_choice_sf",
      label = strong(
        paste0(
          percent_missing, "% of your selected data is missing.",
          " How would you like to handle it?"
        )
      ),
      choices = c(
        "Use complete data (remove rows with missing values)" = "complete", 
        "Use multiple imputation" = "imputation"
      ),
      selected = "complete"
    )
  })
  
  ## Event input if outocme is time to event type -----------------------------------------------------------------------------
  # output$eventvar_ui_sf <- renderUI({
  #   req(input$yreg_sf)
  #   if (input$yreg_sf %in% c("coxph", "aft_exp", "aft_weibull")) {
  #     selectizeInput(
  #       inputId = "eventvar_sf",
  #       label = "Event Variable (1 = Event, 0 = No Event)",
  #       choices = names(uploaded_data_sf()),
  #       selected = NULL
  #     )
  #   }
  # })
  
  ### Conditionally show number of imputations input if missing data is TRUE -----------------------------------------------------------------------------
  output$mi_number_input_sf <- renderUI({
    req(input$mi_handling_choice_sf == "imputation")
    
    numericInput(
      inputId = "mi_number_sf",
      label = tagList(
        strong("Number of Multiple Imputations"),
        tags$br(),
        tags$small(
          "Note: Analysis may take a while to run.",
          style = "font-style: italic; font-weight: 500; font-size: 13px; color: #de7073;"
        )
      ),
      value = 20,
      min = 2
    )
  })
  
  ### Read in uploaded data file ---------------------------------------------------------------------------------
  uploaded_data_sf <- reactive({
    req(input$single_fixed_file)
    
    ext <- tools::file_ext(input$single_fixed_file$name)
    
    if (ext != "csv") {
      showModal(modalDialog(
        title = "❌ Invalid File Type",
        HTML("Please upload a <b>.csv</b> file only."),
        easyClose = TRUE,
        footer = modalButton("OK")
      ))
      return(NULL)
    }
    
    read.csv(input$single_fixed_file$datapath)
  })
  
  
  ### Observe the data input to generate model input choices ---------------------------------------------------------------------------------
  observe({
    data <- uploaded_data_sf()
    choices <- names(data)
    
    updateSelectizeInput(inputId = "exposure_sf",
                         choices = choices,
                         server = TRUE)
    updateSelectizeInput(inputId = "mediator_sf",
                         choices = choices,
                         server = TRUE)
    updateSelectizeInput(inputId = "outcome_sf",
                         choices = choices,
                         server = TRUE)
    updateSelectizeInput(inputId = "basec_sf",
                         choices = choices,
                         server = TRUE)
    updateSelectizeInput(inputId = "postc_sf",
                         choices = choices,
                         server = TRUE)
    
  })
  
  ### Using user input to fit mediation analysis function -------------------------------------------------------------------------------
  cmest_results_sf <- reactiveVal()
  
  # Subset data based on selected columns 
  selected_data_sf <- reactive({
    req(uploaded_data_sf(), input$exposure_sf, input$mediator_sf,
        input$outcome_sf)
    
    selected_cols <- c(
      input$exposure_sf,
      input$mediator_sf,
      input$outcome_sf,
      input$basec_sf,
      input$postc_sf
    )
    
    # Add event variable to data if survival model selected
    if (input$yreg_sf %in% c("coxph", "aft_exp", "aft_weibull")) {
      selected_cols <- unique(c(selected_cols, input$eventvar_sf))
    }
    
    uploaded_data_sf()[, selected_cols, drop = FALSE]
  })
  
  
  # Checking if subset data has any missing
  has_missing_in_selected_sf <- reactive({
    anyNA(selected_data_sf())
  })
  
  # Percentage of rows with any missing values in selected data
  missing_percent_sf <- reactive({
    data <- selected_data_sf()
    n_total <- nrow(data)
    n_missing <- sum(!complete.cases(data))
    round(n_missing / n_total, 3) * 100
  })
  
  output$show_missing_ui_sf <- reactive({
    has_missing_in_selected_sf()
  })
  outputOptions(output, "show_missing_ui_sf", suspendWhenHidden = FALSE)
  
  observeEvent(input$run_single_fixed, {
    # Show loading screen
    waiter_show(html = tagList(
      spin_flower(),
      br(),
      h4(
        "Calculating mediation estimates...this may take a while... 🧑‍💻👩‍💻📊",
        style = "color: black; font-size: 22px;"
      )
    ),
    color = "#ede8f0")
    
    isolate({
      req(uploaded_data_sf())
      # last_yreg_sf(input$yreg_sf)
      
      # Check for duplicate variable selections
      all_vars_selected <- c(
        input$exposure_sf,
        input$mediator_sf,
        input$outcome_sf,
        input$basec_sf,
        input$postc_sf
      )
      
      # Flatten in case basec or postc are multiselect
      all_vars_flat <- unlist(all_vars_selected)
      
      # Check for duplicates
      duplicate_vars <- all_vars_flat[duplicated(all_vars_flat)]
      
      if (length(duplicate_vars) > 0) {
        waiter_hide()
        
        showModal(modalDialog(
          title = div(style = "color: black; background-color: #EFD5E1; padding: 10px; border-radius: 4px; text-align: center;",
                      "❌ Input Error: Duplicate Variable Selected ❌"), 
          div(style = "padding: 10px; font-size: 16px;",
              HTML(paste0(
                "The following variable(s) are selected in multiple input fields:<br><br>",
                "<b>", paste(unique(duplicate_vars), collapse = ", "), "</b><br><br>",
                "Please revise your selections so that each variable is assigned to only one field, then re-run the analysis."
              ))),
          easyClose = TRUE,
          footer = modalButton("OK")
        ))
        
        return(NULL)
      }
      
      # If post exposure confounders selected, require gformula or msm model
      if (!is.null(input$postc_sf) && !(input$model_sf %in% c("gformula", "msm"))) {
        waiter_hide()
        
        showModal(modalDialog(
          title = div(style = "color: black; background-color: #EFD5E1; padding: 10px; border-radius: 4px; text-align: center;",
                      "❌ Model Mismatch ❌ "), 
          div(style = "padding: 10px; font-size: 16px;",
              HTML("You've included <b>post-exposure confounders</b>, so you must select <b>gformula</b> or <b>msm</b> as the model type.")),
          easyClose = TRUE,
          footer = modalButton("OK")
        ))
        
        return(NULL)
      }
      
      # Collect postcreg model types
      postcreg_models <- lapply(seq_along(input$postc_sf), function(i) {
        input[[paste0("postcreg_", i)]]
      })
      
      # Determine missing data strategy
      use_mi <- if (!has_missing_in_selected_sf()) {
        FALSE
      } else {
        input$mi_handling_choice_sf == "imputation"
      }
      num_mi <- if (use_mi) input$mi_number_sf else NULL
      
      # Determine which dataset to use
      data_for_model <- if (use_mi) uploaded_data_sf() else na.omit(selected_data_sf())
      
      # Fit model
      result <- tryCatch({
        my_cmest(
          data = data_for_model,
          model = input$model_sf,
          outcome = input$outcome_sf,
          yreg = input$yreg_sf,
          event = if (input$yreg_sf %in% c("coxph", "aft_exp", "aft_weibull")) input$eventvar_sf else NULL,
          mediator = input$mediator_sf,
          mreg = list(input$mreg_sf),
          mval = list(length(input$mediator_sf)),
          exposure = input$exposure_sf,
          basec = input$basec_sf,
          postc = input$postc_sf,
          postcreg = postcreg_models,
          EMint = as.logical(input$Emint_sf),
          estimation = input$estimation_sf,
          inference = ifelse(input$estimation_sf == "imputation","bootstrap","delta"),
          nboot = if (input$estimation_sf == "imputation") input$nboot_sf else NULL,
          multimp = use_mi,
          m = num_mi,
          seed = input$seed_sf
        )
      }, error = function(e) {
        waiter_hide()
        showModal(modalDialog(
          title = div(
            style = "color: black; background-color: #EFD5E1; padding: 10px; border-radius: 4px; text-align: center;",
            "❌ Model Fitting Error❌"         
            ),
          size = "l",
          easyClose = TRUE,
          footer = modalButton("OK"),
          div(
            style = "padding: 10px; font-size: 16px; line-height: 1.5;",
            HTML(paste0(
              "<b>What happened?</b><br/>",
              "There is an error with the model fitting process. This commonly occurs when a <b>logistic</b> model is used with a <b>non-binary</b> variable, ",
              "but it can also result from other specification issues. Please check the raw error for debugging.<br/><br/>",
              "<b>Raw error:</b>"
            )),
            tags$div(
              style = paste(
                "margin-top: 8px;",
                "background-color: #f9f9f9;",
                "border: 1px solid #ddd;",
                "border-radius: 6px;",
                "padding: 10px;",
                "font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, 'Liberation Mono', 'Courier New', monospace;",
                "white-space: pre-wrap;",
                "word-break: break-word;"
              ),
              paste(capture.output(print(e)), collapse = "\n")
            )
          )
        ))
        return(NULL)
      })
      
      if (is.null(result)) return(NULL)
      cmest_results_sf(result)
      last_yreg_sf(input$yreg_sf)
      
      dag_result_sf(
        generate_dag_plot(
          effect_table = estimates(result)$table,
          exposure_var = input$exposure_sf,
          mediator_var = input$mediator_sf,
          outcome_var = input$outcome_sf,
          basec_vars = input$basec_sf,
          postc_vars = input$postc_sf
        )
      )
    })
    
    # Hide loading screen
    waiter_hide()
  })
  
  
  
  ### Output path estimate table ---------------------------------------------------------------------------------
  output$path_table_sf <- renderDT({
    req(cmest_results_sf(), last_yreg_sf())
    estimates(cmest_results_sf())$table
  })
  
  ### Output Path Estimate table note ---------------------------------------------------------------------------------
  output$estimate_table_note <- renderUI({
    req(cmest_results_sf(), last_yreg_sf())
    
    if (last_yreg_sf() == "logistic") {
      HTML("
      <div style='color: #5582B1;'>
        <b>Note:</b> <i>For logistic regression, p-value is calculated as </i>
        <code>2 * (pnorm(|log(estimate) / (SE / estimate)|, lower.tail = FALSE))</code>
      </div>
      <i>*For a full list of all path/regression effect estimates, download the Excel file below.</i>
    ")
    } else if (last_yreg_sf() == "linear") {
      HTML("
      <div style='color: #5582B1;'>
        <b>Note:</b> <i>For linear regression, p-value is calculated as </i>
        <code>2 * (pnorm(|estimate / SE|, lower.tail = FALSE))</code>
      </div>
      <i>*For a full list of all path/regression effect estimates, download the Excel file below.</i>
    ")
    } else {
      HTML("<i>*For a full list of all path/regression effect estimates, download the Excel file below.</i>")
    }
  })
  
  ### Output path estimate plot ---------------------------------------------------------------------------------
  output$path_plot_sf <- renderPlot({
    req(cmest_results_sf(), last_yreg_sf())
    estimates(cmest_results_sf(), yreg_type = last_yreg_sf())$plot()
  })
  
  ### Output model Summary-----------------------------------------------------------------------------
  output$cmest_summary_sf <- renderPrint({
    cmest_results_sf()
  })
  
  ### Generating DAG plot ---------------------------------------------------------------------------------
  dag_result_sf <- reactiveVal()
  
  output$dag_plot_sf <- renderPlot({
    req(dag_result_sf())
    dag_result_sf()
  })
  
  # Output Dag Annotation
  output$dag_annotation_sf <- renderText({
    req(cmest_results_sf())
    req(dag_result_sf())
    
    effect_tbl <- estimates(cmest_results_sf())$table
    total <- round(effect_tbl$Estimate[effect_tbl$Path == "Total Effect"], 3)
    pm    <- round(100 * effect_tbl$Estimate[effect_tbl$Path == "Proportion Mediated"], 1)
    
    paste0("• Total Effect: ", total," | Proportion Mediated: ", pm, "%")
  })
  
  
  ### Excel File Download ---------------------------------------------------------------------------------
  output$estimates_download_sf <- downloadHandler(
    filename = function() {
      paste0("mediation_results_", input$mediator_sf, ".xlsx")
    },
    
    content = function(file) {
      req(cmest_results_sf())
      
      file_of_estimates(
        model = cmest_results_sf(),
        mreg_name = input$mediator_sf,
        postcreg_name = input$postc_sf,
        outcome = input$outcome_sf,
        multimp = input$mi_handling_choice_sf == "imputation",  
        path = file
      )
    }
  )
  
  ### PDF Report of Results Download ---------------------------------------------------------------------------------
  output$pdf_report_sf <- downloadHandler(
    filename = function() {
      paste0("mediation_report_single_mediator.docx")
    },
    
    content = function(file) {
      req(cmest_results_sf())
      
      # Save DAG and path plots as temp images
      dag_file_path <- file.path(tempdir(), "dag_sf.png")
      path_plot_file_path <- file.path(tempdir(), "path_plot_sf.png")
      
      ggsave(
        dag_file_path, 
        plot = dag_result_sf(), 
        width = 14, height = 6
        )
      
      ggsave(
        path_plot_file_path,
        plot = estimates(cmest_results_sf(), html_output = FALSE, yreg_type = last_yreg_sf())$plot(),
        width = 14, height = 6
        )
      
      # Capture raw summary
      model_output <- capture.output(print(cmest_results_sf()))
      
      # Construct post exposure model types
      postcreg_type <- if (!is.null(input$postc_sf) && length(input$postc_sf) > 0) {
        lapply(seq_along(input$postc_sf), function(i) {
          paste0(input$postc_sf[i], ": ", input[[paste0("postcreg_", i)]])
        }) |> unlist()
      } else {
        NULL
      }
      
      # Generate proportion mediated summary
      effect_tbl <- estimates(cmest_results_sf())$table
      pm_row <- effect_tbl[effect_tbl$Path == "Proportion Mediated", ]
      pm_percent <- round(100 * pm_row$Estimate, 3)
      ci_lower <- round(100 * pm_row$CI_Lower, 3)
      ci_upper <- round(100 * pm_row$CI_Upper, 3)
      pval <- pm_row$Pvalue
      pm_text <- paste0(pm_percent, "% (95% CI: ", ci_lower, ", ", ci_upper, "), p = ", pval)
      
      # Generate interpretation
      interpretation <- generate_interpretation_text(
        effect_table = effect_tbl,
        outcome = input$outcome_sf,
        mediator = input$mediator_sf,
        basec_vars = input$basec_sf,
        postc_vars = input$postc_sf,
        yreg_type = input$yreg_sf, 
        html_output = FALSE
      )
      
      # Create temp Rmd path
      tempReport <- file.path(tempdir(), "report_template_sf.Rmd")
      file.copy("report_template_sf.Rmd", tempReport, overwrite = TRUE)
      
      # Pass to render
      rmarkdown::render(
        input = tempReport,
        output_file = file,
        params = list(
          exposure = input$exposure_sf,
          mediator = input$mediator_sf,
          outcome = input$outcome_sf,
          basec_vars = input$basec_sf,
          postc_vars = input$postc_sf,
          yreg_type = input$yreg_sf,
          model_summary = paste(model_output, collapse = "\n"),
          path_table = effect_tbl,
          dag_path = dag_file_path,
          path_plot_path = path_plot_file_path,
          proportion_mediated = pm_text,
          interpretation_text = interpretation,
          mreg_type = input$mreg_sf,
          postcreg_type = postcreg_type,
          interaction = input$Emint_sf,
          missing_data_method = if (!has_missing_in_selected_sf()) {
            "No missing data"
          } else {
            if (input$mi_handling_choice_sf == "imputation") "Multiple Imputation" else "Complete Case Analysis"
          }
        ),
        envir = new.env(parent = globalenv())
      )
    }
  )
  
  ### Example interpretations text ----------------------------------------------------------------------------------
  output$sample_interpretation_sf <- renderUI({
    req(cmest_results_sf())
    
    HTML(generate_interpretation_text(
      effect_table = estimates(cmest_results_sf())$table, 
      outcome = input$outcome_sf,
      mediator = input$mediator_sf,
      basec_vars = input$basec_sf, 
      postc_vars = input$postc_sf, 
      yreg_type = input$yreg_sf, 
      html_output = TRUE
    ))
  })
  
  output$pm_warning_note_sf <- renderUI({
    req(cmest_results_sf())
    
    # Get the path table
    path_tbl <- estimates(cmest_results_sf())$table
    
    # Extract direct and indirect effect estimates
    direct <- path_tbl$Estimate[path_tbl$Path == "Direct Effect"]
    indirect <- path_tbl$Estimate[path_tbl$Path == "Indirect Effect"]
    
    if (length(direct) > 0 && length(indirect) > 0 && sign(direct) != sign(indirect)) {
      div(
        style = "margin-top: 10px; font-size: 14px; color: #b60000; font-style: italic;",
        HTML("Note: The direct and indirect effects have opposite signs so the proportion mediated may be unstable or difficult to interpret in this case. 
             Consider focusing on direct and indirect effects separately (VanderWeele, 2015). Additionally, you may want to revisit the current model and consider adjusting for additional variables.")
      )
    }
  })
  
  ### Output proportion mediated ---------------------------------------------------------------------------------
  output$pm_sf <- renderUI({
    req(cmest_results_sf(), input$yreg_sf)
    
    path_tbl <- estimates(cmest_results_sf())$table
    
    pm_row <- path_tbl[path_tbl$Path == "Proportion Mediated", ]
    pm_percent <- round(100 * pm_row$Estimate, 3)
    ci_lower <- round(100 * pm_row$CI_Lower, 3)
    ci_upper <- round(100 * pm_row$CI_Upper, 3)
    pval <- pm_row$Pvalue
    
    mediator_label <- input$mediator_sf
    yreg_type <- last_yreg_sf()
    if (is.null(yreg_type)) yreg_type <- input$yreg_sf  
    is_ratio <- identical(yreg_type, "logistic")        
    
    
    # Italic note in #D40639 with spacing
    note_text <- if (is_ratio) {
      paste0(
        "<div style='color: #5582B1; font-size: 14px; font-weight: bold; margin-top: 10px;'>
      <span>Note:&nbsp; On the ratio scale (multiplicative outcome),&nbsp;PM =&nbsp;</span>
      <span style='display:inline-block; vertical-align:middle;'>
        <span style='border-bottom:1px solid; display:block; text-align:center;'>Direct × (Indirect − 1)</span>
        <span style='display:block; text-align:center;'>Total Effect − 1</span>
      </span>
    </div>"
      )
    } else {
      paste0(
        "<div style='color: #5582B1; font-size: 14px; font-weight: bold; margin-top: 10px;'>
      <span>Note:&nbsp; On the additive scale (continuous outcome),&nbsp;PM =&nbsp;</span>
      <span style='display:inline-block; vertical-align:middle;'>
        <span style='border-bottom:1px solid; display:block; text-align:center;'>Indirect Effect</span>
        <span style='display:block; text-align:center;'>Total Effect</span>
      </span>
    </div>"
      )
    }
    
    HTML(
      paste0(
        "<div style='text-align: center;'>",
        
        "<div style='font-size: 52px; color: #3c3c3c; margin-bottom: 4px;'>", pm_percent, "%</div>",
        
        "<div style='font-size: 18px; color: #555; margin-bottom: 4px;'>of the total effect was mediated by ",
        "<b style='font-size: 22px;'>", mediator_label, "</b>.</div>",
        
        "<div style='font-size: 16px; color: #777; margin-bottom: 6px;'>95% CI: (", ci_lower, ", ", ci_upper, ") | p = ", pval, "</div>",
        
        note_text,
        
        "</div>"
      )
    )
  })
  
  # Multiple mediator fixed time server page ---------------------------------------------------------------------------------
  dag_results_mf <- reactiveVal(NULL)
  
  ### Tab naming purposes ---------------------------------------------------------------------------------
  joint_model_name <- reactive({
    paste(input$mediator_mf, collapse = " + ")
  })
  
  
  ### Rendering one selectInput for each mediator regression type ---------------------------------------------------------------------------------
  output$mreg_ui_mf <- renderUI({
    req(input$mediator_mf)
    
    lapply(seq_along(input$mediator_mf), function(i) {
      selectInput(
        inputId = paste0("mreg_", i),
        label = paste("Model for", input$mediator_mf[i]),
        choices = mediator_reg_types,
        selected = "linear"
      )
    })
  })
  
  # Imputation missing amount if missing data is TRUE ---------------------------------------------------------------------------------
  output$mi_number_input_mf <- renderUI({
    req(input$missing_handling_mf == "impute")
    
    tagList(
      tags$div(
        tags$label("Number of Multiple Imputations"),
        tags$div(
          "Note: Analysis may take a while to run.",
          style = "font-style: italic; font-weight: 500; font-size: 13px; color: #de7073; margin-top: 2px; margin-bottom: 5px;"
        )
      ),
      numericInput(
        inputId = "mi_number_mf",
        label = NULL,  # Already included above
        value = 2,
        min = 2
      )
    )
  })
  
  ### Rendering one selectInput for each postc confouner regression type ---------------------------------------------------------------------------------
  output$postcreg_ui_mf <- renderUI({
    req(input$postc_mf)
    
    lapply(seq_along(input$postc_mf), function(i) {
      selectInput(
        inputId = paste0("postcreg_", i),
        label = paste("Model for", input$postc_mf[i]),
        choices = mediator_reg_types,
        selected = "linear"
      )
    })
  })
  
  ### Event input if outcome type is time to event ----
  # output$eventvar_ui_mf <- renderUI({
  #   req(input$yreg_mf)
  #   if (input$yreg_mf %in% c("coxph", "aft_exp", "aft_weibull")) {
  #     selectizeInput(
  #       inputId = "eventvar_mf",
  #       label = "Event Variable Name (1 = Event, 0 = No Event)",
  #       choices = names(uploaded_data_mf()),
  #       selected = NULL
  #     )
  #   }
  # })
  
  # Missing data handling UI ---------------------------------------------------------------------------------
  output$missing_handling_ui_mf <- renderUI({
    req(has_missing_in_selected_mf())
    percent_missing <- missing_percent_mf()
    
    radioButtons(
      inputId = "missing_handling_mf",
      label = strong(
        paste0(
          percent_missing, "% of your selected data is missing. ",
          "How would you like to handle it?"
        )
      ),
      choices = c(
        "Use complete data (remove rows with missing values)" = "omit", 
        "Use Multiple Imputation" = "impute"
      ),
      selected = "omit"
    )
  })
  
  output$show_missing_ui_mf <- reactive({
    has_missing_in_selected_mf()
  })
  
  outputOptions(output, "show_missing_ui_mf", suspendWhenHidden = FALSE)
  
  # Percentage of rows with any missing values in selected data (multiple mediator)
  missing_percent_mf <- reactive({
    data <- selected_data_mf()
    n_total <- nrow(data)
    n_missing <- sum(!complete.cases(data))
    round(n_missing / n_total, 3) * 100
  })
  
  ### Read in uploaded data file ---------------------------------------------------------------------------------
  uploaded_data_mf <- reactive({
    req(input$multiple_fixed_file)
    
    ext <- tools::file_ext(input$multiple_fixed_file$name)
    
    if (ext != "csv") {
      showModal(modalDialog(
        title = "❌ Invalid File Type",
        HTML("Please upload a <b>.csv</b> file only."),
        easyClose = TRUE,
        footer = modalButton("OK")
      ))
      return(NULL)
    }
    
    read.csv(input$multiple_fixed_file$datapath)
  })
  
  # Subset data to selected variables
  selected_data_mf <- reactive({
    req(uploaded_data_mf())
    req(input$exposure_mf, input$mediator_mf, input$outcome_mf)
    
    vars <- c(
      input$exposure_mf,
      input$mediator_mf,
      input$outcome_mf,
      input$basec_mf,
      input$postc_mf
    )
    
    uploaded_data_mf()[, vars, drop = FALSE]
  })
  
  # Chheck if uploaded multiple mediator dataset has missing values
  has_missing_in_selected_mf <- reactive({
    anyNA(selected_data_mf())
  })
  
  ### Observe the data input to generate model input choices ---------------------------------------------------------------------------------
  observe({
    data <- uploaded_data_mf()
    
    choices <- names(data)
    
    updateSelectizeInput(inputId = "exposure_mf",
                         choices = choices,
                         server = TRUE)
    updateSelectizeInput(inputId = "mediator_mf",
                         choices = choices,
                         server = TRUE)
    updateSelectizeInput(inputId = "outcome_mf",
                         choices = choices,
                         server = TRUE)
    updateSelectizeInput(inputId = "basec_mf",
                         choices = choices,
                         server = TRUE)
    updateSelectizeInput(inputId = "postc_mf",
                         choices = choices,
                         server = TRUE)
  })
  
  ### Reactive value to store all model results for multiple mediators ---------------------------------------------------------------------------------
  all_mediator_results <- reactiveVal()
  
  observeEvent(all_mediator_results(), {
    results <- all_mediator_results()
    if (is.null(results) || length(results) == 0) return()
    
    dag_list <- lapply(names(results), function(name) {
      effect_table <- results[[name]]$table
      
      mediator_label <- if (name == joint_model_name()) {
        paste(input$mediator_mf, collapse = " + ")
      } else {
        name
      }
      
      plot <- generate_dag_plot(
        effect_table = effect_table,
        exposure_var = input$exposure_mf,
        mediator_var = mediator_label,
        outcome_var = input$outcome_mf,
        basec_vars = input$basec_mf,
        postc_vars = input$postc_mf
      )
      
      list(plot = plot, effect_table = effect_table)
    }) |> setNames(names(results))
    
    dag_results_mf(dag_list)  # ✅ Only update when valid results exist
  })
  
  # Using user input to fit multiple mediation analysis for joint and marginal models
  observeEvent(input$run_multiple_fixed, {
    
    # Check number of mediators
    if (length(input$mediator_mf) < 2) {
      showModal(modalDialog(
        title = div(style = "color: black; background-color: #EFD5E1; padding: 10px; border-radius: 4px; text-align: center;",
                    "⚠️ At Least Two Mediators Required ⚠️ "),
        div(style = "padding: 10px; font-size: 16px;",
            HTML("Please select at least <b>two</b> mediators before running the analysis.
                 Check out the Single Mediator tab if you want to run a single mediator analysis!")
        ),
        easyClose = TRUE,
        footer = modalButton("OK")
      ))
      
      return(NULL)
    }
    
    # Check for duplicate variable selections
    all_vars_selected <- c(
      input$exposure_mf,
      input$mediator_mf,
      input$outcome_mf,
      input$basec_mf,
      input$postc_mf
    )
    
    # Making sure duplicated variables are not chosen
    all_vars_flat <- unlist(all_vars_selected)
    
    # Detect duplicates
    duplicate_vars <- all_vars_flat[duplicated(all_vars_flat)]
    
    if (length(duplicate_vars) > 0) {
      showModal(modalDialog(
        title = div(style = "color: black; background-color: #EFD5E1; padding: 10px; border-radius: 4px; text-align: center;",
                    "❌ Input Error: Duplicate Variable Selected ❌"), 
        div(style = "padding: 10px; font-size: 16px;",
            HTML(paste0(
              "The following variable(s) are selected in multiple input fields:<br><br>",
              "<b>", paste(unique(duplicate_vars), collapse = ", "), "</b><br><br>",
              "Please revise your selections so that each variable is assigned to only one field, then re-run the analysis."
            ))
        ),
        easyClose = TRUE,
        footer = modalButton("OK")
      ))
      return(NULL)
    }
    
    # Show loading screen
    waiter_show(html = tagList(
      spin_flower(),
      # Now uses custom color/size
      br(),
      h4(
        "Calculating mediation estimates...this may take a while... 🧑‍💻👩‍💻📊",
        style =  "color: black; font-size: 22px;"
      )
    ),
    color = "#E3E3EE")
    
    # Run in isolate so UI doesn't freeze during blocking
    isolate({
      # Validation: if post-exposure confounders are selected, user must choose gformula or msm
      if (!is.null(input$postc_mf) && !(input$model_mf %in% c("gformula", "msm"))) {
        waiter_hide()
        
        showModal(modalDialog(
          title = div(style = "color: black; background-color: #EFD5E1; padding: 10px; border-radius: 4px; text-align: center;",
                      "❌ Model Mismatch ❌"), 
          div(style = "padding: 10px; font-size: 16px;",
              HTML("You've included <b>post-exposure confounders</b>, so you must select <b>gformula</b> or <b>msm</b> as the model type.")),
          easyClose = TRUE,
          footer = modalButton("OK")
        ))
        return(NULL)
      }
      
      # Determine missing data strategy
      use_mi <- if (!has_missing_in_selected_mf()) {
        FALSE
      } else {
        req(input$missing_handling_mf)
        input$missing_handling_mf == "impute"
      }
      
      num_mi <- if (use_mi) input$mi_number_mf else NULL
      
      # Determine which dataset to use
      data_for_model <- if (use_mi) uploaded_data_mf() else na.omit(selected_data_mf())
      
      # Collect model types
      mreg_models <- lapply(seq_along(input$mediator_mf), function(i) {
        input[[paste0("mreg_", i)]]
      })
      
      postcreg_models <- lapply(seq_along(input$postc_mf), function(i) {
        input[[paste0("postcreg_", i)]]
      })
      
      # Run model with defensive check if model fitting has error
      results_all_models <- tryCatch({
        run_multiple_mediator_models(
          data = data_for_model,
          model = input$model_mf,
          outcome = input$outcome_mf,
          yreg = input$yreg_mf,
          # event = if (input$yreg_mf %in% c("coxph", "aft_exp", "aft_weibull")) input$eventvar_mf else NULL,
          mediator_list = input$mediator_mf,
          exposure = input$exposure_mf,
          basec = input$basec_mf,
          postc = input$postc_mf,
          mreg_models = mreg_models,
          postcreg_models = postcreg_models,
          EMint = as.logical(input$Emint_mf),
          estimation = "imputation",
          inference = "bootstrap",
          nboot = input$nboot_mf,
          seed = input$seed_mf,
          multimp = use_mi,
          m = num_mi
        )
      }, error = function(e) {
        waiter_hide()
        showModal(modalDialog(
          title = div(
            style = "color: black; background-color: #EFD5E1; padding: 10px; border-radius: 4px; text-align: center;",
            "❌ Model Fitting Error"
          ),
          size = "l",
          easyClose = TRUE,
          footer = modalButton("OK"),
          div(
            style = "padding: 10px; font-size: 16px; line-height: 1.5;",
            HTML(paste0(
              "<b>What happened?</b><br/>",
              "There is an error with the model fitting process.<br/> This commonly occurs when a <b>logistic</b> model is used with a <b>non-binary</b> variable, ",
              "but it can also result from other specification issues. Please check the raw error for debugging.<br/><br/>",
              "<b>Raw error:</b>"
            )),
            tags$div(
              style = paste(
                "margin-top: 8px;",
                "background-color: #f9f9f9;",
                "border: 1px solid #ddd;",
                "border-radius: 6px;",
                "padding: 10px;",
                "font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, 'Liberation Mono', 'Courier New', monospace;",
                "white-space: pre-wrap;",
                "word-break: break-word;"
              ),
              paste(capture.output(print(e)), collapse = "\n")
            )
          )
        ))
        return(NULL)
      })
      
      if (is.null(results_all_models)) return(NULL)
      all_mediator_results(results_all_models)
      last_yreg_mf(input$yreg_mf)
      mediators_snapshot_mf(input$mediator_mf)
    })
    
    # Save p-value note based on selected yreg at time of run
    yreg_type <- input$yreg_mf
    
    if (yreg_type == "logistic") {
      pval_note_mf(HTML("<div style='color: #5582B1;'>
    <b>Note:</b> <i>For logistic regression, p-value is calculated as </i>
    <code>2 * (1 - pnorm(log(estimate) / (SE / estimate), lower.tail = FALSE))</code>
  </div>"))
    } else if (yreg_type == "linear") {
      pval_note_mf(HTML("<div style='color: #5582B1;'>
    <b>Note:</b> <i>For linear regression, p-value is calculated as </i>
    <code>2 * (1 - pnorm(estimate / SE, lower.tail = FALSE))</code>
  </div>"))
    } else {
      pval_note_mf(NULL)
    }
    
    # Hide loading screen once complete
    waiter_hide()
  })
  
  # Building the tab box output for table estimates ---------------------------------------------------------------------------------
  output$all_model_table_mf <- renderUI({
    req(all_mediator_results())
    
    results <- all_mediator_results()
    
    # Reorder so "Joint Mediator Model" is first
    ordered_names <- c(joint_model_name(), setdiff(names(results), joint_model_name()))
    
    tabs <- lapply(ordered_names, function(name) {
      tab_title <- if (name == joint_model_name()) "Joint Model" else name
      table_tabs <- paste0("table_", gsub("[^A-Za-z0-9_]", "_", name))
      tabPanel(
        title = tab_title,
        tagList(
          DTOutput(outputId = table_tabs),
          br(),
          uiOutput(paste0("pval_note_", gsub("[^A-Za-z0-9_]", "_", name))),
          HTML("<i>*For a full list of all path/regression effect estimates, download the Excel file below.</i>")
        )
      )
    })
    
    do.call(tabBox, c(width = 12, tabs))
  })
  
  # Building the tab box output for estimation plots ---------------------------------------------------------------------------------
  output$combined_plot_mf <- renderPlot({
    req(all_mediator_results())
    generate_stacked_estimate_plots(all_mediator_results(), joint_name = joint_model_name(), yreg_type = input$yreg_mf)
  }, height = function() {
    req(all_mediator_results())
    250 * length(all_mediator_results())
  })
  
  # Raw model tab box ---------------------------------------------------------------------------------
  output$all_model_summary_mf <- renderUI({
    req(all_mediator_results())
    
    results <- all_mediator_results()
    
    # Reorder so "Joint Mediator Model" is first
    ordered_names <- c(joint_model_name(), setdiff(names(results), joint_model_name()))
    
    tabs <- lapply(ordered_names, function(name) {
      tab_title <- if (name == joint_model_name()) "Joint Model" else name
      summary_tabs <- paste0("summary_", gsub("[^A-Za-z0-9_]", "_", name))
      tabPanel(title = tab_title, verbatimTextOutput(outputId = summary_tabs))
    })
    
    do.call(tabBox, c(width = 12, tabs))
  })
  
  # Download all estimates tab box -----------------------------------------------------------------------------
  output$all_model_download_mf <- renderUI({
    req(all_mediator_results())
    results <- all_mediator_results()
    
    # Reorder names
    ordered_names <- c(joint_model_name(), setdiff(names(results), joint_model_name()))
    
    tabs <- lapply(ordered_names, function(name) {
      is_joint <- name == joint_model_name()
      tab_title <- if (is_joint) "Joint Model" else name
      download_id <- paste0("download_", gsub("[^A-Za-z0-9_]", "_", name))
      
      label_text <- if (is_joint) {
        "Download Joint Model file here!"
      } else {
        paste("Download", name, "file here!")
      }
      
      tabPanel(title = tab_title, fluidRow(column(
        width = 6,
        downloadButton(
          outputId = download_id,
          label = label_text
        )
      )))
    })
    
    do.call(tabBox, c(width = 12, tabs))
  })
  
  # Proportion mediated tab box ---------------------------------------------------------------------------------
  output$all_model_pm_mf <- renderUI({
    req(all_mediator_results())
    results <- all_mediator_results()
    
    ordered_names <- c(joint_model_name(), setdiff(names(results), joint_model_name()))
    
    tabs <- lapply(ordered_names, function(name) {
      tab_title <- if (name == joint_model_name()) "Joint Model" else name
      pm_id <- paste0("pm_", gsub("[^A-Za-z0-9_]", "_", name))
      note_id <- paste0("pm_note_", gsub("[^A-Za-z0-9_]", "_", name))
      
      tabPanel(
        title = tab_title,
        tagList(
          uiOutput(pm_id),
          uiOutput(note_id)
        )
      )
    })
    
    do.call(tabBox, c(width = 12, tabs))
  })
  
  # Interpretation tab box ---------------------------------------------------------------------------------
  output$all_model_interpretation_mf <- renderUI({
    req(all_mediator_results())
    results <- all_mediator_results()
    
    ordered_names <- c(joint_model_name(), setdiff(names(results), joint_model_name()))
    
    tabs <- lapply(ordered_names, function(name) {
      tab_title <- if (name == joint_model_name()) "Joint Model" else name
      interp_id <- paste0("interpret_", gsub("[^A-Za-z0-9_]", "_", name))
      tabPanel(title = tab_title, uiOutput(interp_id))
    })
    
    do.call(tabBox, c(width = 12, tabs))
  })
  
  ### Generating DAG plot ---------------------------------------------------------------------------------
  output$all_model_dag_mf <- renderUI({
    req(all_mediator_results())
    results <- all_mediator_results()
    
    ordered_names <- c(joint_model_name(), setdiff(names(results), joint_model_name()))
    
    tabs <- lapply(ordered_names, function(name) {
      tab_title <- if (name == joint_model_name()) "Joint Model" else name
      dag_tabs <- paste0("dag_", gsub("[^A-Za-z0-9_]", "_", name))
      ann_id   <- paste0("dag_annotation_", gsub("[^A-Za-z0-9_]", "_", name))
      tabPanel(
        title = tab_title,
        withSpinner(
          tagList(
            plotOutput(dag_tabs, height = "400px"),
            div(
              style = "margin-top: 5px; margin-bottom: 0px;",
              uiOutput(ann_id)
            )
          ),
          type = 7,
          color = "#b3ccd1"
        )
      )
    })
    
    do.call(tabBox, c(width = 12, tabs))
  })
  
  # Missing data detection reactive for Conditional Panel -----------------------------------------------------------------------------
  output$show_missing_ui_mf <- reactive({
    has_missing_in_selected_mf()
  })
  outputOptions(output, "show_missing_ui_mf", suspendWhenHidden = FALSE)
  
  # Tab box renderings-----------------------------------------------------------------------------
  observe({
    req(all_mediator_results())
    
    results <- all_mediator_results()
    
    # Various boxes tab names
    lapply(names(results), function(name) {
      table_tabs <- paste0("table_", gsub("[^A-Za-z0-9_]", "_", name))
      summary_tabs <- paste0("summary_", gsub("[^A-Za-z0-9_]", "_", name))
      plot_tabs <- paste0("plot_", gsub("[^A-Za-z0-9_]", "_", name))
      download_tabs <- paste0("download_", gsub("[^A-Za-z0-9_]", "_", name))
      pm_tabs <- paste0("pm_", gsub("[^A-Za-z0-9_]", "_", name))
      interpret_tabs <- paste0("interpret_", gsub("[^A-Za-z0-9_]", "_", name))
      dag_tabs <- paste0("dag_", gsub("[^A-Za-z0-9_]", "_", name))
      ann_id   <- paste0("dag_annotation_", gsub("[^A-Za-z0-9_]", "_", name)) 
      
      ### Render DT table -----------------------------------------------------------------------------
      output[[table_tabs]] <- renderDT({
        results[[name]]$table
      })
      
      ### Render table note -----------------------------------------------------------------------------
      output[[paste0("pval_note_", gsub("[^A-Za-z0-9_]", "_", name))]] <- renderUI({
        pval_note_mf()
      })
      
      ### Render estimate plots -----------------------------------------------------------------------------
      output[[plot_tabs]] <- renderPlot({
        results[[name]]$plot()
      })
      
      ### Render summary print output -----------------------------------------------------------------------------
      output[[summary_tabs]] <- renderPrint({
        results[[name]]$summary
      })
      
      ### Render downloads -----------------------------------------------------------------------------
      output[[download_tabs]] <- downloadHandler(
        filename = function() {
          paste0("mediation_results_",
                 gsub("[^A-Za-z0-9_]", "_", name),
                 ".xlsx")
        },
        content = function(file) {
          outcome <- input$outcome_mf
          if (name == joint_model_name()) {
            mreg_name <- input$mediator_mf
          } else {
            mreg_name <- name
          }
          postcreg_name <- input$postc_mf
          
          file_of_estimates(
            model = results[[name]]$summary,
            mreg_name = mreg_name,
            postcreg_name = postcreg_name,
            outcome = outcome,
            multimp = input$missing_handling_mf == "impute",  
            path = file
          )
        }
      )
      
      ### Render proportion mediated -----------------------------------------------------------------------------
      output[[pm_tabs]] <- renderUI({
        result <- results[[name]]
        
        # PM %
        pm_value <- round(result$pm, 3) * 100
        
        # Extract CI + p-value
        pm_row <- result$table[result$table$Path == "Proportion Mediated", ]
        ci_lower <- round(100 * pm_row$CI_Lower, 3)
        ci_upper <- round(100 * pm_row$CI_Upper, 3)
        pval <- pm_row$Pvalue
        
        # Mediator label (FROZEN at last Run for the Joint tab)
        mediator_label <- if (name == joint_model_name()) {
          paste0("{", paste(if (is.null(mediators_snapshot_mf())) input$mediator_mf else mediators_snapshot_mf(), collapse = ", "), "}")
        } else {
          name
        }
        
        # Outcome model type (FROZEN at last Run)
        yreg_type <- last_yreg_mf()
        if (is.null(yreg_type)) yreg_type <- input$yreg_mf   # fallback before first run
        is_ratio <- identical(yreg_type, "logistic")         # ONLY distinguish logistic vs linear
        
        # Styled note with formula
        note_text <- if (is_ratio) {
          paste0(
            "<div style='color: #5582B1; font-size: 14px; font-weight: bold; margin-top: 10px;'>",
            "Note:&nbsp;on the ratio scale (multiplicative outcome),&nbsp;PM =&nbsp;",
            "<span style='display:inline-block; vertical-align:middle;'>",
            "<span style='border-bottom:1px solid; display:block; text-align:center;'>Direct × (Indirect − 1)</span>",
            "<span style='display:block; text-align:center;'>Total Effect − 1</span>",
            "</span>",
            "</div>"
          )
        } else {
          paste0(
            "<div style='color: #5582B1; font-size: 14px; font-weight: bold; margin-top: 10px;'>",
            "Note:&nbsp;on the additive scale (continuous outcome),&nbsp;PM =&nbsp;",
            "<span style='display:inline-block; vertical-align:middle;'>",
            "<span style='border-bottom:1px solid; display:block; text-align:center;'>Indirect Effect</span>",
            "<span style='display:block; text-align:center;'>Total Effect</span>",
            "</span>",
            "</div>"
          )
        }
        HTML(
          paste0(
            "<div style='text-align: center;'>",
            
            "<div style='font-size: 52px; color: #3c3c3c;'>", pm_value, "%</div>",
            
            "<div style='font-size: 18px; color: #555;'>of the total effect was mediated by ",
            "<b style='font-size: 22px;'>", mediator_label, "</b>.</div>",
            
            "<div style='font-size: 18px; color: #777;'>95% CI: (",
            ci_lower, ", ", ci_upper, ") | p = ", pval, "</div>",
            
            note_text,
            
            "</div>"
          )
        )
      })
      
      ### Render sample interpretations -----------------------------------------------------------------------------
      output[[interpret_tabs]] <- renderUI({
        result <- results[[name]]
        effect_table <- result$table
        
        # Mediator label formatting
        mediator_label <- if (name == joint_model_name()) {
          paste(input$mediator_mf, collapse = " + ")
        } else {
          name
        }
        
        outcome_label <- input$outcome_mf
        
        # Generate interpretation 
        interpretation <- generate_interpretation_text(
          effect_table = effect_table,
          outcome = outcome_label,
          mediator = mediator_label,
          is_joint_model = (name == joint_model_name()),
          basec_vars = input$basec_mf,
          postc_vars = input$postc_mf, 
          yreg_type = input$yreg_mf, 
        )
        
        tagList(
          HTML(interpretation)
        )
        # )
      })
      
      # Output note if indirect and direct are of different directions
      output[[paste0("pm_note_", gsub("[^A-Za-z0-9_]", "_", name))]] <- renderUI({
        result <- results[[name]]
        tbl <- result$table
        
        direct <- tbl$Estimate[tbl$Path == "Direct Effect"]
        indirect <- tbl$Estimate[tbl$Path == "Indirect Effect"]
        
        if (length(direct) > 0 && length(indirect) > 0 && sign(direct) != sign(indirect)) {
          div(
            style = "margin-top: 10px; font-size: 14px; color: #b60000; font-style: italic;",
            HTML("Note: The direct and indirect effects have opposite signs so the proportion mediated may be unstable or difficult to interpret in this case. 
             Consider focusing on direct and indirect effects separately (VanderWeele, 2015). Additionally, you may want to revisit the current model and consider adjusting for additional variables.")
          )
        }
      })
      
      ### Render DAG plots -----------------------------------------------------------------------------
      output[[dag_tabs]] <- renderPlot({
        req(dag_results_mf())
        dag_results_mf()[[name]]$plot
      })
      # Render Dag Plot Caption
      output[[ann_id]] <- renderUI({
        req(dag_results_mf())
        result <- dag_results_mf()[[name]]
        effect_table <- result$effect_table
        
        total <- round(effect_table$Estimate[effect_table$Path == "Total Effect"], 3)
        pm    <- round(100 * effect_table$Estimate[effect_table$Path == "Proportion Mediated"], 1)
        
        joint_text <- if (name == joint_model_name()) {
          paste0("• Joint Mediators: {", paste(input$mediator_mf, collapse = ", "), "}<br/>")
        } else {
          ""
        }
        
        HTML(paste0(
          "<div style='font-size: 16px; margin-top: 5px;'>",
          "<br/>",
          joint_text,
          "• Total Effect: ", total, " | Proportion Mediated: ", pm, "%</div>"
        ))
      })
    })
  })
  
  ### PDF Report Download Handler for Multiple Mediators ---------------------------------------------------------------------------------
  output$pdf_report_mf <- downloadHandler(
    filename = function() {
      paste0("mediation_report_multiple_mediators.docx")
    },
    content = function(file) {
      req(all_mediator_results())
      
      temp_dir   <- tempdir()
      all_models <- all_mediator_results()
      model_list <- list()
      
      # Build the combined plot ONCE for the joint model (same as output$combined_plot_mf)
      joint_nm <- joint_model_name()
      combined_plot <- generate_stacked_estimate_plots(
        results_list = all_models,
        joint_name   = joint_nm,
        html_output  = FALSE,
        yreg_type    = input$yreg_mf
      )
      
      for (model_name in names(all_models)) {
        model <- all_models[[model_name]]
        
        # Create safe filenames
        dag_filename       <- paste0("dag_", gsub("[^A-Za-z0-9]", "_", model_name), ".png")
        path_plot_filename <- paste0("path_plot_", gsub("[^A-Za-z0-9]", "_", model_name), ".png")
        
        dag_path       <- file.path(temp_dir, dag_filename)
        path_plot_path <- file.path(temp_dir, path_plot_filename)
        
        # Save DAG
        ggsave(dag_path, plot = dag_results_mf()[[model_name]]$plot, width = 14, height = 6)
        
        # Save the correct plot:
        # - Joint model -> combined stacked plot
        # - Marginal models -> per-model estimates plot
        if (model_name == joint_nm) {
          ggsave(path_plot_path, plot = combined_plot, width = 14, height = 10)
        } else {
          ggsave(
            path_plot_path,
            plot = estimates(model$summary, html_output = FALSE, yreg_type = input$yreg_mf)$plot(),
            width = 14, height = 6
          )
        }
        
        # Use relative paths
        dag_rel_path       <- basename(dag_path)
        path_plot_rel_path <- basename(path_plot_path)
        
        # Generate interpretation
        interpretation_text <- generate_interpretation_text(
          effect_table  = model$table,
          outcome       = input$outcome_mf,
          mediator      = model_name,
          is_joint_model = (model_name == joint_nm),
          basec_vars    = input$basec_mf,
          postc_vars    = input$postc_mf,
          yreg_type     = input$yreg_mf,
          html_output   = FALSE
        )
        
        # Store info with relative paths
        model_list[[model_name]] <- list(
          table               = model$table,
          dag_path            = dag_rel_path,
          path_plot_path      = path_plot_rel_path,
          interpretation_text = interpretation_text,
          is_joint            = (model_name == joint_nm),
          mediator            = model_name
        )
      }
      
      # Gather model types
      postcreg_type <- if (!is.null(input$postc_mf) && length(input$postc_mf) > 0) {
        lapply(seq_along(input$postc_mf), function(i) {
          paste0(input$postc_mf[i], ": ", input[[paste0("postcreg_", i)]])
        }) |> unlist()
      } else {
        NULL
      }
      
      mreg_type <- lapply(seq_along(input$mediator_mf), function(i) {
        input[[paste0("mreg_", i)]]
      })
      names(mreg_type) <- input$mediator_mf
      
      # Copy Rmd template to temp dir
      tempReport <- file.path(temp_dir, "report_template_mf.Rmd")
      file.copy("report_template_mf.Rmd", tempReport, overwrite = TRUE)
      
      # Define path to output inside tempdir
      temp_output <- file.path(temp_dir, "final_report.docx")
      
      # Render inside temp_dir
      rmarkdown::render(
        input       = tempReport,
        output_file = temp_output,
        output_dir  = temp_dir,
        params = list(
          exposure = input$exposure_mf,
          outcome = input$outcome_mf,
          mediators = input$mediator_mf,
          basec_vars = input$basec_mf,
          postc_vars = input$postc_mf,
          yreg_type = input$yreg_mf,
          mreg_type = mreg_type,
          postcreg_type = postcreg_type,
          interaction = input$Emint_mf,
          missing_data_method = if (!has_missing_in_selected_mf()) {
            "No missing data"
          } else {
            if (input$missing_handling_mf == "impute") "Multiple Imputation" else "Complete Case Analysis"
          },
          all_models          = model_list
        ),
        envir = new.env(parent = globalenv())
      )
      
      # Copy final Word doc to output path
      file.copy(temp_output, file, overwrite = TRUE)
    }
  )
  
  ### PDF Report Button UI Render ---------------------------------------------------------------------------------
  output$pdf_report_button_mf <- renderUI({
    req(all_mediator_results())
    downloadButton("pdf_report_mf", "Download Mediation Report")
  })
}

# Output App ----
shinyApp(ui = ui, server = server)