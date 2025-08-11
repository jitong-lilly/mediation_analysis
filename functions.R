# This is the R script for all functions the mediation analysis shiny app uses
library(CMAverse)
library(tidyverse)
library(shiny)
library(shinydashboard)
library(DT)
library(shinycssloaders)
library(readxl)
library(gridExtra)
library(writexl)
library(knitr)
library(ggraph)
library(igraph)
library(ggrepel)
library(waiter)
library(grid)

############################## Generic Function for using cmest #####################################################
# add additional args for multiple imputation
my_cmest = function(data, model = "rb", outcome = outcome, yreg = "TRUE", yval = NULL, 
                    mediator = mediator, mreg = mreg, mval = NULL, event = NULL,
                    exposure = exposure, astar = 0, a = 1, 
                    basec = NULL, basecval = NULL, postc = NULL, postcreg = NULL, 
                    EMint = TRUE, estimation = NULL, inference = NULL, nboot = NULL, 
                    multimp = FALSE, m = NULL, seed = seed) {
  
  # fitting mediation analysis
  set.seed(seed)
  fit = cmest(data = data, model = model, outcome = outcome, yreg = yreg, yval = yval, event = event,
              mediator = mediator, mreg = mreg, mval = mval, exposure = exposure, astar = astar, a = a, 
              basec = basec, basecval = basecval, post = postc, postcreg = postcreg, 
              EMint = EMint, estimation = estimation, inference = inference, nboot = nboot, 
              multimp = multimp, args_mice = list(m = m)
              )
  return(summary(fit))
}

#################################### Path Estimates Table/ Plot Function ######################## ########################

estimates <- function(model, html_output = TRUE) {
  # Estimate table
  path_est_tbl <- data.frame(
    "Path" = tolower(names(model$effect.pe)),
    "Estimate" = model$effect.pe,
    "SE" = model$effect.se,
    "CI_Lower" = model$effect.ci.low,
    "CI_Upper" = model$effect.ci.high,
    "Pvalue" = model$effect.pval
  ) %>%
    filter(Path %in% c("pnde", "tnie", "te", "rpnde", "rtnie", "rte", "rrpnde", "rrtnie", "rpm", "pm")) %>%
    mutate(across(where(is.numeric), ~round(.x, 3))) %>%
    mutate(Label = case_when(
      grepl("pnde$", Path) ~ "Direct Effect",
      grepl("tnie$", Path) ~ "Indirect Effect",
      grepl("te$", Path)   ~ "Total Effect",
      grepl("pm$", Path)   ~ "Proportion Mediated"
    )) %>%
    select(Label, Estimate, SE, CI_Lower, CI_Upper, Pvalue)
  
  path_est_tbl$Pvalue <- ifelse(path_est_tbl$Pvalue < 0.001, "< 0.001", path_est_tbl$Pvalue)
  rownames(path_est_tbl) <- NULL
  colnames(path_est_tbl) <- c("Path", "Estimate", "SE", "CI_Lower", "CI_Upper", "Pvalue")
  
  # Forest plot
  plot1 <- path_est_tbl %>%
    filter(Path %in% c("Total Effect", "Indirect Effect", "Direct Effect")) %>%
    mutate(Path = factor(Path, levels = c("Total Effect", "Indirect Effect", "Direct Effect"))) %>%
    ggplot(aes(x = Estimate, y = Path)) +
    geom_vline(xintercept = 0, linetype = "dashed", color = "#EF3B7B", linewidth = 1) +
    geom_vline(xintercept = 1, linetype = "dotted", color = "#FF9B2B", linewidth = 2) +
    geom_point(size = 5, color = "#438BFF") +
    geom_errorbarh(aes(xmin = CI_Lower, xmax = CI_Upper, height = 0.13), color = "#438BFF", linewidth = 0.6) +
    geom_hline(yintercept = 0) +
    scale_x_continuous(
      breaks = function(x) {
        pretty_ticks <- scales::pretty_breaks(n = 5)(x)
        extra_ticks <- c(0, 1)
        combined <- sort(unique(c(pretty_ticks, extra_ticks)))
        return(combined)
      },
      expand = expansion(mult = c(0.05, 0.05))
    ) +
    labs(y = NULL) +
    ggtitle("Path Effect Estimates") +
    theme_minimal() +
    theme(
      axis.line.x = element_line(color = "black"),
      axis.ticks.x = element_line(color = "black"),
      axis.text.y = element_text(size = 13),
      axis.text.x = element_text(size = 11),
      axis.title.x = element_text(size = 10),
      axis.title.y = element_blank(),
      plot.title = element_text(hjust = 0.5, size = 16), 
      plot.margin = unit(c(0, 1.2, 0, 1), "cm")
    )
  
  # Text label plot
  plot2 <- path_est_tbl %>%
    filter(Path %in% c("Total Effect", "Indirect Effect", "Direct Effect")) %>%
    mutate(
      Path = factor(Path, levels = c("Total Effect", "Indirect Effect", "Direct Effect")),
      label = sprintf("%.3f (%.3f, %.3f)", Estimate, CI_Lower, CI_Upper)
    ) %>%
    ggplot() +
    geom_text(aes(y = Path, x = 2, label = label), vjust = 0, size = 5) +
    ggtitle("Estimate (95% CI)") +
    theme_classic(base_size = 14) +
    theme(
      axis.title.x = element_blank(),
      axis.line.y = element_blank(),
      axis.line.x = element_line(color = "white"),
      axis.text.y = element_blank(),
      axis.ticks.y = element_blank(),
      axis.ticks.x = element_line(color = "white"),
      axis.ticks.length = unit(0.3, "cm"),
      axis.title.y = element_blank(),
      axis.text.x = element_text(color = "white"),
      plot.title = element_text(hjust = 0.5, size = 16)
    )
  
  # Caption for non-HTML output (one-line, left-aligned)
  caption_text <- "Note: Pink dashed line (0) = reference for additive scale; orange dotted line (1) = reference for odds ratio scale."
  
  # Define plot function depending on output type
  if (html_output) {
    estimate_plot <- function() {
      grid.arrange(
        plot1, plot2, widths = c(6, 3),
        bottom = gridtext::richtext_grob(
          "<span style='color:#EF3B7B;'><b>Pink dashed line (0)</b></span> is the reference for <b>continuous outcomes</b>. 
       <span style='color:#FF8700;'><b>Orange dotted line (1)</b></span> is for <b>ratio-scale outcomes</b>.",
          gp = gpar(fontsize = 12),
          hjust = 0.5,  # Center horizontally
          x = 0.5       # Centered on the x-axis
        )
      )
    }
  } else {
    estimate_plot <- function() {
      grid.arrange(
        plot1, plot2, widths = c(6, 3),
        bottom = textGrob(caption_text, gp = gpar(fontsize = 11), hjust = 0.5, x = 0.5)
      )
    }
  }
  
  # Extract proportion mediated
  pm_index <- which(tolower(names(model$effect.pe)) %in% c("pm", "rpm"))
  pm_value <- if (length(pm_index) > 0) model$effect.pe[pm_index[1]] else NA
  
  list(
    table = path_est_tbl,
    plot = estimate_plot,
    pm = pm_value,
    summary = model
  )
}

#################################### Multiple Mediator Estimation Plot ################################################

generate_stacked_estimate_plots <- function(results_list, joint_name = NULL, html_output = TRUE) {
  
  if (is.null(joint_name)) {
    joint_name <- names(results_list)[which.max(grepl("\\+", names(results_list)))]
  }
  
  # Reorder: joint model last
  model_names <- c(setdiff(names(results_list), joint_name), joint_name)
  
  # Combine results
  all_df <- bind_rows(lapply(model_names, function(name) {
    result <- results_list[[name]]$table %>%
      select(-Pvalue)
    result %>%
      filter(Path %in% c("Total Effect", "Indirect Effect", "Direct Effect")) %>%
      mutate(
        Path = factor(Path, levels = c("Indirect Effect", "Direct Effect", "Total Effect")), 
        Model = ifelse(name == joint_name, "Joint Model", name)
      )
  }))
  
  all_df$Model <- factor(all_df$Model, levels = rev(unique(all_df$Model)))
  all_df <- all_df %>%
    mutate(Label = sprintf("%.3f (%.3f, %.3f)", Estimate, CI_Lower, CI_Upper))
  
  # Forest plot
  p1 <- ggplot(all_df, aes(x = Estimate, y = Model)) +
    geom_vline(xintercept = 0, linetype = "dashed", color = "#EF3B7B", linewidth = 1) +
    geom_vline(xintercept = 1, linetype = "dotted", color = "#FF9B2B", linewidth = 2) +
    geom_point(size = 3.5, color = "#438BFF") +
    geom_errorbarh(aes(xmin = CI_Lower, xmax = CI_Upper), height = 0.25, color = "#438BFF", linewidth = 0.6) +
    facet_wrap(~Path, ncol = 1, scales = "free_y") +
    scale_x_continuous(
      breaks = function(x) {
        pretty_ticks <- scales::pretty_breaks(n = 5)(x)
        extra_ticks <- c(0, 1)
        combined <- sort(unique(c(pretty_ticks, extra_ticks)))
        return(combined)
      },
      expand = expansion(mult = c(0.05, 0.05))) +
    labs(x = NULL, y = NULL, title = "Path Effect Estimates") +
    theme_minimal(base_size = 13) +
    theme(
      axis.text.y = element_text(size = 12),
      axis.text.x = element_text(size = 10),
      plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
      strip.text = element_text(size = 13, face = "plain"),
      panel.spacing = unit(0.9, "lines"),
      axis.line.x = element_line(color = "black"),
      axis.ticks.x = element_line(color = "black"),
      panel.border = element_blank(),
      plot.margin = unit(c(0, 1.2, 0, 1), "cm")
    )
  
  # Label text plot
  p2 <- ggplot(all_df, aes(y = Model, x = 1, label = Label)) +
    geom_text(size = 4.9) +
    facet_wrap(~Path, ncol = 1, scales = "free_y") +
    labs(title = "Estimate (95% CI)") +
    theme_void(base_size = 13) +
    theme(
      plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
      strip.text = element_blank(),
      plot.background = element_blank(),
      panel.background = element_blank()
    )
  
  # Combine plots
  combined_row <- arrangeGrob(p1, p2, widths = c(7, 2))
  
  # Caption: HTML vs Non-HTML output
  if (html_output) {
    caption_note <- gridtext::richtext_grob(
      "<span style='color:#EF3B7B;'><b>Pink dashed line (0)</b></span> is the reference for <b>continuous outcomes</b>. 
       <span style='color:#FF8700;'><b>Orange dotted line (1)</b></span> is for <b>ratio-scale outcomes</b>.",
      gp = gpar(fontsize = 12),
      hjust = 0.5,
      x = 0.5
    )
  } else {
    caption_note <- textGrob(
      "Note: Pink dashed line (0) = reference for additive scale; orange dotted line (1) = reference for odds ratio scale.",
      gp = gpar(fontsize = 11),
      hjust = 0.5,
      x = 0.5
    )
  }
  
  # Final layout
  grid.arrange(combined_row, caption_note, nrow = 2, heights = c(10, 1))
}

#################################### Excel File of All Estimates ################################################

file_of_estimates <- function(model, mreg_name, postcreg_name, outcome, multimp = FALSE, path = NULL) {
  
  # Set default path if none provided
  if (is.null(path)) {
    path <- paste0("mediation_results_", outcome, ".xlsx")
  }
  
  # Estimand table
  estimand <- model$summarydf %>% as_tibble(rownames = "Estimand")
  
  if (!multimp) {
    # NON-imputation case
    # yreg
    yreg <- summary(model$reg.output$yreg)$coefficients %>%
      as_tibble(rownames = "Coefficient")
    
    # mreg
    mreg_list <- model$reg.output$mreg %>%
      lapply(function(x) {
        summary(x)$coefficients %>% as_tibble(rownames = "Coefficient")
      })
    
    mreg_stacked <- bind_rows(
      lapply(seq_along(mreg_list), function(i) {
        mreg_list[[i]] %>% mutate(Mediator = mreg_name[i])
      })
    ) %>% relocate(Mediator, .before = 1)
    
    # postcreg if present
    if (length(model$reg.output$postcreg) > 0 && length(postcreg_name) > 0) {
      postcreg_list <- model$reg.output$postcreg %>%
        lapply(function(x) {
          summary(x)$coefficients %>% as_tibble(rownames = "Coefficient")
        })
      
      postcreg_stacked <- bind_rows(
        lapply(seq_along(postcreg_list), function(i) {
          postcreg_list[[i]] %>% mutate(Confounder = postcreg_name[i])
        })
      ) %>% relocate(Confounder, .before = 1)
    } else {
      postcreg_stacked <- NULL
    }
    
    # Result list
    model_results <- list(
      "estimand" = estimand,
      "yreg" = yreg,
      "mreg" = mreg_stacked
    )
    
    if (!is.null(postcreg_stacked)) {
      model_results$postcreg <- postcreg_stacked
    }
    
  } else {
    
    # Multiple Imputation Case
    # yreg
    yreg <- model$reg.output.summary %>%
      lapply(function(x) {
        x$yreg$coefficients %>%
          as_tibble(rownames = "Coefficient")
      }) %>%
      bind_rows(.id = "Imputation") %>%
      relocate(Imputation, .before = 1)
    
    # mreg
    mreg <- bind_rows(
      lapply(seq_along(model$reg.output.summary), function(i) {
        imp_mreg_list <- model$reg.output.summary[[i]]$mreg
        
        bind_rows(
          lapply(seq_along(imp_mreg_list), function(j) {
            imp_mreg_list[[j]]$coefficients %>%
              as_tibble(rownames = "Coefficient") %>%
              mutate(Mediator = mreg_name[j])
          })
        ) %>%
          mutate(Imputation = i) %>%
          relocate(Imputation, Mediator, .before = 1) 
      })
    )
    
    # postcreg — if present
    if (length(postcreg_name) > 0 &&
        length(model$reg.output.summary[[1]]$postcreg) > 0) {
      
      postcreg <- bind_rows(
        lapply(seq_along(model$reg.output.summary), function(i) {
          imp_postcreg_list <- model$reg.output.summary[[i]]$postcreg
          
          bind_rows(
            lapply(seq_along(imp_postcreg_list), function(j) {
              imp_postcreg_list[[j]]$coefficients %>%
                as_tibble(rownames = "Coefficient") %>%
                mutate(Confounder = postcreg_name[j])
            })
          ) %>%
            mutate(Imputation = i) %>%
            relocate(Imputation, Confounder, .before = 1)
        })
      )
    } else {
      postcreg <- NULL
    }
    
    # Result list
    model_results <- list(
      "estimand" = estimand,
      "yreg_all_imputations" = yreg,
      "mreg_all_imputations" = mreg
    )
    
    if (!is.null(postcreg)) {
      model_results$postcreg_all_imputations <- postcreg
    }
  }
  
  # Save to Excel
  write_xlsx(model_results, path = path)
}

############################# Running Multiple Mediator Models ##########################################

run_multiple_mediator_models <- function(data, model, outcome, yreg, mediator_list,
                                         exposure, basec = NULL, postc = NULL,
                                         mreg_models, postcreg_models = NULL,
                                         EMint = TRUE, estimation = "imputation",
                                         inference = "bootstrap", nboot = 200, seed = 2025,
                                         multimp = FALSE, m = NULL) {
  
  results_list <- list()
  
  # Individual models (one per mediator)
  for (i in seq_along(mediator_list)) {
    med_i <- mediator_list[i]
    mreg_i <- list(mreg_models[[i]])
    
    message("Fitting single mediator model for: ", med_i) # for logging purposes
    
    cmest_out <- my_cmest(
      data = data,
      model = model,
      outcome = outcome,
      yreg = yreg,
      mediator = med_i,
      mreg = mreg_i,
      mval = list(1),
      exposure = exposure,
      basec = basec,
      postc = postc,
      postcreg = postcreg_models,
      EMint = EMint,
      estimation = estimation,
      inference = inference,
      nboot = nboot,
      seed = seed,
      multimp = multimp,
      m = m
    )
    
    results_list[[med_i]] <- estimates(cmest_out)
  }
  
  # Joint model
  message("Fitting joint mediator model for: ", paste(mediator_list, collapse = ", "))
  
  cmest_joint <- my_cmest(
    data = data,
    model = model,
    outcome = outcome,
    yreg = yreg,
    mediator = mediator_list,
    mreg = mreg_models,
    mval = as.list(rep(1, length(mediator_list))),
    exposure = exposure,
    basec = basec,
    postc = postc,
    postcreg = postcreg_models,
    EMint = EMint,
    estimation = estimation,
    inference = inference,
    nboot = nboot,
    seed = seed,
    multimp = multimp,
    m = m
  )
  
  joint_name <- paste(mediator_list, collapse = " + ")
  results_list[[joint_name]] <- estimates(cmest_joint)
  
  return(results_list)
}

############################# Interpretations Function ##########################################

generate_interpretation_text <- function(effect_table, outcome, mediator, is_joint_model = FALSE,
                                         basec_vars = NULL, postc_vars = NULL, yreg_type = NULL,
                                         html_output = TRUE) {
  # Ensure required rows are present
  direct_row   <- effect_table[effect_table$Path == "Direct Effect", ]
  indirect_row <- effect_table[effect_table$Path == "Indirect Effect", ]
  total_row    <- effect_table[effect_table$Path == "Total Effect", ]
  prop_row     <- effect_table[effect_table$Path == "Proportion Mediated", ]
  
  if (nrow(direct_row) == 0 || nrow(indirect_row) == 0 || nrow(total_row) == 0 || nrow(prop_row) == 0) {
    return("Interpretation could not be generated because one or more path estimates are missing.")
  }
  
  mediator_phrase <- if (is_joint_model) "the set of mediators collectively" else mediator
  
  # Format key terms
  format_term <- function(term) {
    if (html_output) {
      paste0("<b><span style='color:#1f4e79;'>", term, "</span></b>")
    } else {
      paste0("**", term, "**")
    }
  }
  
  # Line break
  br <- if (html_output) "<br><br>" else "\n\n"
  
  # Confounder sentence
  confounding_text <- NULL
  if (!is.null(basec_vars) && length(basec_vars) > 0 && !is.null(postc_vars) && length(postc_vars) > 0) {
    confounding_text <- " The models adjusted for both baseline covariates and post-exposure confounders to reduce bias in effect estimation."
  } else if (!is.null(basec_vars) && length(basec_vars) > 0) {
    confounding_text <- " The models adjusted for baseline covariates to reduce bias in effect estimation."
  } else if (!is.null(postc_vars) && length(postc_vars) > 0) {
    confounding_text <- " The models adjusted for post-exposure confounders to reduce bias in effect estimation."
  }
  
  # Format effect sentences
  format_effect <- function(row, yreg_type, effect_label) {
    if (yreg_type == "linear") {
      paste0("The ", effect_label, " was estimated at ", round(row$Estimate, 3), " units (95% CI: ",
             round(row$CI_Lower, 3), ", ", round(row$CI_Upper, 3), "), with a p-value of ", row$Pvalue, ".")
    } else if (yreg_type == "logistic") {
      paste0("The ", effect_label, " was estimated at an odds ratio of ", round(row$Estimate, 3),
             " (95% CI: ", round(row$CI_Lower, 3), ", ", round(row$CI_Upper, 3),
             "), with a p-value of ", row$Pvalue, ".")
    } else {
      paste0("The ", effect_label, " was estimated at ", round(row$Estimate, 3), 
             " (95% CI: ", round(row$CI_Lower, 3), ", ", round(row$CI_Upper, 3), "), p = ", row$Pvalue, ".")
    }
  }
  
  scale_text <- if (yreg_type == "logistic") {
    " using the odds ratio scale for logistic regression"
  } else if (yreg_type == "linear") {
    " using the additive scale for linear regression"
  } else {
    ""
  }
  
  interpretation <- paste0(
    "Mediation analysis (Valeri et al. 2013, VanderWeele et al. 2014) was conducted", scale_text,
    " to assess the extent to which the effect of the treatment on ", outcome, 
    " was mediated through ", mediator_phrase, ".", confounding_text, br,
    
    format_term("Indirect Effect"), ": ",
    format_effect(indirect_row, yreg_type, paste0("indirect effect of treatment through ", mediator_phrase)), br,
    
    format_term("Direct Effect"), ": ",
    format_effect(direct_row, yreg_type, paste0("direct effect of treatment on ", outcome, " independent of ", mediator_phrase)), br,
    
    format_term("Total Effect"), ": ",
    format_effect(total_row, yreg_type, paste0("total effect of treatment on ", outcome)), br,
    
    format_term("Proportion Mediated"), ": Approximately ", 
    round(100 * prop_row$Estimate, 1), "% of the total effect of treatment on ", 
    outcome, " was mediated through ", mediator_phrase, 
    " (p = ", prop_row$Pvalue, ")."
  )
  
  if (is_joint_model) {
    note <- if (html_output) {
      paste0(
        "<br><br><strong>Note:</strong> In the multiple mediator setting, the ", format_term("proportion mediated"),
        " from the joint model does not necessarily equal the sum of the individual proportions mediated by each mediator, ",
        "due to interactions, correlations, and overlapping causal pathways among mediators (VanderWeele 2015)."
      )
    } else {
      paste0(
        "\n\nNote: In the multiple mediator setting, the ", format_term("proportion mediated"),
        " from the joint model does not necessarily equal the sum of the individual proportions mediated by each mediator, ",
        "due to interactions, correlations, and overlapping causal pathways among mediators (VanderWeele 2015)."
      )
    }
    interpretation <- paste0(interpretation, note)
  }
  
  return(interpretation)
}



############################################# DAG Plot ##########################################
generate_dag_plot <- function(effect_table, exposure_var, mediator_var, outcome_var, basec_vars, postc_vars) {
  
  # Ensure character vectors
  basec_vars <- if (is.null(basec_vars)) character(0) else basec_vars
  postc_vars <- if (is.null(postc_vars)) character(0) else postc_vars
  
  # Helper to wrap long variable lists
  wrap_covariates <- function(covs, per_line = 2) {
    if (length(covs) == 0) return(NULL)
    lines <- split(covs, ceiling(seq_along(covs) / per_line))
    wrapped <- paste(sapply(lines, paste, collapse = ", "), collapse = "\n")
    return(wrapped)
  }
  
  # Effect estimates
  direct_est   <- round(effect_table$Estimate[effect_table$Path == "Direct Effect"], 3)
  indirect_est <- round(effect_table$Estimate[effect_table$Path == "Indirect Effect"], 3)
  total_est    <- round(effect_table$Estimate[effect_table$Path == "Total Effect"], 3)
  pm_est       <- round(100 * effect_table$Estimate[effect_table$Path == "Proportion Mediated"], 1)
  
  # Start with full edge set
  edges <- tribble(
    ~from, ~to,  ~type,
    "A",   "M",  "indirect",
    "A",   "Y",  "direct",
    "M",   "Y",  "indirect"
  )
  
  if (length(basec_vars) > 0) {
    edges <- bind_rows(edges, tribble(
      ~from, ~to,  ~type,
      "C",   "A",  "other",
      "C",   "M",  "other",
      "C",   "Y",  "other"
    ))
  }
  
  if (length(postc_vars) > 0) {
    edges <- bind_rows(edges, tribble(
      ~from, ~to,  ~type,
      "A",   "L",  "other",
      "L",   "M",  "other",
      "L",   "Y",  "other"
    ))
  }
  
  dag_graph <- graph_from_data_frame(edges)
  
  # Define node layout
  node_positions <- tribble(
    ~name, ~x, ~y, ~var_label, ~nudge_x, ~nudge_y,
    "A",   0,  0.5, paste0("Exposure:\n", exposure_var), -0.15, 0.12,
    "M",   1,  1.5,
    if (grepl("\\+", mediator_var)) "* Joint Mediators" else paste0("Mediator:\n", mediator_var),
    0.27,  0.12,
    "Y",   2,  0.5, paste0("Outcome:\n", outcome_var), 0.15,  0.28
  )
  
  # Checking to see if the model include base and post confounders
  if (length(basec_vars) > 0) {
    node_positions <- add_row(node_positions,
                              name = "C", x = 1, y = 2.5,
                              var_label = paste0("Baseline Covariates:\n", wrap_covariates(basec_vars)),
                              nudge_x = -0.3, nudge_y = 0.05
    )
  }
  
  if (length(postc_vars) > 0) {
    node_positions <- add_row(node_positions,
                              name = "L", x = 1, y = -0.2,
                              var_label = paste0("Post-confounders:\n", wrap_covariates(postc_vars)),
                              nudge_x = 0.35, nudge_y = -0.02
    )
  }
  
  # Assign coordinates
  V(dag_graph)$x <- node_positions$x[match(V(dag_graph)$name, node_positions$name)]
  V(dag_graph)$y <- node_positions$y[match(V(dag_graph)$name, node_positions$name)]
  
  # Labels on edges
  edge_labels <- rep("", length(E(dag_graph)))
  edge_names <- paste0(ends(dag_graph, E(dag_graph))[,1], "→", ends(dag_graph, E(dag_graph))[,2])
  
  edge_labels[edge_names == "A→M"] <- paste0("\u2003Indirect Effect : ", indirect_est, " (pink path)")
  edge_labels[edge_names == "A→Y"] <- paste0("\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003\u2003Direct Effect : ", direct_est)
  
  E(dag_graph)$label <- edge_labels
  
  # Final plot
  p <- ggraph(dag_graph, layout = "manual", x = V(dag_graph)$x, y = V(dag_graph)$y) +
    geom_node_point(color = "#FFD591", size = 16) +
    geom_node_text(aes(label = name), color = "black", size = 6) +
    geom_edge_link(
      aes(label = label, colour = type),
      angle_calc = "along",
      label_dodge = unit(2.5, "mm"),
      label_size = 5,
      fontface = "plain",
      start_cap = circle(24, "pt"),
      end_cap = circle(24, "pt"),
      arrow = arrow(length = unit(3.8, "mm")),
      edge_width = 1,
      show.legend = FALSE
    ) +
    scale_edge_colour_manual(values = c(
      "indirect" = "#F00F8A",
      "direct"   = "#4795DE",
      "other"    = "#D0CDD2"
    )) +
    geom_text_repel(
      data = node_positions,
      aes(x = x, y = y, label = var_label),
      size = 4.8,
      min.segment.length = 0,
      box.padding = 0.2,
      point.padding = 1,
      segment.color = "grey60",
      segment.size = 0.4,
      segment.alpha = 0.7,
      max.overlaps = Inf,
      nudge_x = node_positions$nudge_x,
      nudge_y = node_positions$nudge_y
    ) +
    theme_void()
  return(p)
}