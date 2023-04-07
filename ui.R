#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application.

    pageWithSidebar(
        headerPanel("Upper bounds of sensitivity and specificity given Cohen's kappa"),
        sidebarPanel(
            numericInput('sens', 'True Biomarker sensitivity', 1, min = 0, max = 1, step=0.005), # step needs to be half of desired (?bug)
            numericInput('spec', 'True Biomarker specificity', 1, min=0, max= 1, step=0.005),
            numericInput('kappa', 'kappa value', 0.5, min = 0, max = 1, step=0.005),
            h3("Experimental values\n"),
            " ",
            numericInput('cases', 'Number of cases', NA, min = 0, step=1),
            numericInput('controls', 'Number of controls', NA, min=0, step=1),
            numericInput('osens', 'Experimental sensitivity', NA, min = 0, max = 1, step=0.005), # step needs to be half of desired (?bug)
            numericInput('ospec', 'Experimental specificity', NA, min=0, max= 1, step=0.005)
        ),
        
        mainPanel(tags$style(type="text/css",
                               ".shiny-output-error { visibility: hidden; }",
                               ".shiny-output-error:before { visibility: hidden; }"
                    ),
                    
                  plotOutput('plot1'),
                  
                  conditionalPanel(
                    condition =  "input.osens !==  null && input.ospec!== null &&
                    input.cases > 0 && input.controls > 0",
                    textOutput("maxss"),
                    textOutput("maxsp")
                  )
        )
    )
