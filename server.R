#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

#Load the equations used for calculating sensitivity and specificity:
source("kappaSensSpec.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    phi=seq(from = 0,to = 1,length.out = 100);
    
    # Combine the selected variables into a new data frame
    sg <- reactive({
        lapply(phi, sgfun, input$kappa)
    })
    
    sp <- reactive({
        mapply(specificityfun, phi, sg(), input$sens, input$spec);
    })
    
    ss <- reactive({
        mapply(sensitivityfun, phi, sg(), input$sens, input$spec);
    })
    
    selectedData <- reactive({
        data.frame(sensitivity=ss(),specificity=sp())
    })
    
    phi_exp <- reactive({input$cases/(input$cases+input$controls)
        })
    
    output$plot1 <- renderPlot({
        ggplot(selectedData(),aes(x=1-specificity,y=sensitivity))+
            geom_line(show.legend=FALSE,color=rgb(21/255,147/255,154/255,1))+
            geom_point(aes(x=1-input$sens,y=input$spec),shape=15,color=rgb(255/255,108/255,95/255,1))+
            {if ((!is.na(input$osens))&(!is.na(input$osens)))
                 geom_point(aes(x=1-input$osens,y=input$ospec),shape=15,color=rgb(21/255,147/255,154/255,1))}+
            theme_minimal(base_size = 14)+
            theme(aspect.ratio = 1)+
            coord_cartesian(xlim=c(0,1), ylim=c(0,1))+
            xlab("1-Specificity")+
            ylab("Sensitivity")
    })
    
    output$maxss <- renderText({
        paste("Maximum observed sensitivity for this kappa value is:",
              signif(maxperfun(phi_exp(),sgfun(phi_exp(),input$kappa),input$osens,input$ospec)[1],2))
    })
    
    output$maxsp <- renderText({
        paste("Maximum observed specificity for this kappa value is:",
              signif(maxperfun(phi_exp(),sgfun(phi_exp(),input$kappa),input$osens,input$ospec)[2],2))
    })
    
    
})
