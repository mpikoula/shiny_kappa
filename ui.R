#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyBS)

# Define UI for application.

    pageWithSidebar(
        headerPanel("Observed performance curve given Cohen's kappa"),
        sidebarPanel(
            numericInput('sens', 'True Biomarker sensitivity', 1, min = 0, max = 1, step=0.005), # step needs to be half of desired (?bug)
            bsTooltip(id = "sens", title = "hypothetical value of true biomarker sensitivity"),
            numericInput('spec', 'True Biomarker specificity', 1, min=0, max= 1, step=0.005),
            bsTooltip(id = "spec", title = "hypothetical value of true biomarker specificity"),
            numericInput('kappa', 'kappa value', 0.5, min = 0, max = 1, step=0.005),
            bsTooltip(id = "kappa", title = "Cohen's kappa value for given diagnosis"),
            h3("Observed performance for specific biomarker\n"),
            " ",
            numericInput('cases', 'Number of cases', NA, min = 0, step=1),
            bsTooltip(id = "cases", title = "number of cases in the study"),
            numericInput('controls', 'Number of controls', NA, min=0, step=1),
            bsTooltip(id = "controls", title = "number of controls in the study"),
            numericInput('osens', 'Experimental sensitivity', NA, min = 0, max = 1, step=0.005), # step needs to be half of desired (?bug)
            bsTooltip(id = "osens", title = "Experimentally observed sensitivity for the study"),
            numericInput('ospec', 'Experimental specificity', NA, min=0, max= 1, step=0.005),
            bsTooltip(id = "ospec", title = "Experimentally observed specificity for the study")
        ),
        
        mainPanel(tags$style(type="text/css",
                               ".shiny-output-error { visibility: hidden; }",
                               ".shiny-output-error:before { visibility: hidden; }"
                    ),
                    
                  plotOutput('plot1'),
                  
                  p("The blue line represents the observable performance curve (OPC), while the red dot represents the theoretical (unknown) true biomarker sensitivity and specificity"),
        
                  conditionalPanel(
                    condition =  "input.osens !==  null && input.ospec!== null &&
                    input.cases > 0 && input.controls > 0",
                    p("The observed performance of this biomarker is represented by the blue dot on the graph."),
                    textOutput("maxss"),
                    textOutput("maxsp")
                  )
        )
    )
