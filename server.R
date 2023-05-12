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
    
    phi=seq(from = 0,to = 1,length.out = 101);
    
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
    
    sseqsp <- reactive({ss()[which.min(abs(ss()-sp()))]
                       })
    
    output$plot1 <- renderPlot({
        ggplot(selectedData(),aes(x=1-specificity,y=sensitivity))+
            geom_line(show.legend=FALSE,color=rgb(21/255,147/255,154/255,1))+
            geom_point(aes(x=1-input$spec,y=input$sens),shape=15,color=rgb(255/255,108/255,95/255,1))+
            geom_point(aes(x=1-sseqsp(),y=sseqsp()),shape=15,color='black')+
            {if ((!is.na(input$osens))&(!is.na(input$osens)))
                 geom_point(aes(x=1-input$ospec,y=input$osens),shape=15,color=rgb(21/255,147/255,154/255,1))}+
            theme_minimal(base_size = 14)+
            theme(aspect.ratio = 1)+
            coord_cartesian(xlim=c(0,1), ylim=c(0,1))+
            xlab("1-Specificity")+
            ylab("Sensitivity")
    })
    
    output$equalpoint <- renderText({
        paste("The black dot represents the point where specificity equals sensitivity at ",
              signif(sseqsp(),2))
    })
    
    output$maxss <- renderText({
        paste("Supposing interrater reliability was perfect (Cohen's kappa = 1) we would expect the maximum observed sensitivity to be ",
              signif(maxperfun(phi_exp(),sgfun(phi_exp(),input$kappa),input$osens,input$ospec)[1],2))
    })
    
    output$maxsp <- renderText({
        paste("Likewise, we would expect the maximum observed specificity to be:",
              signif(maxperfun(phi_exp(),sgfun(phi_exp(),input$kappa),input$osens,input$ospec)[2],2))
    })
    
    
})
