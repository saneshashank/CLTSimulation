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
library(plotly)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$distPlot <- renderPlotly({switch(input$dist,
                                          Exp = reExp(),
                                          Binom = reBinom()
  )
    
  })
  
  
  # reactive expression for evaluating exponential function
  reExp <- reactive({
    
    # read value from lambda input  
    lambda <- input$lambda
    
    nosim <- input$NumSim
    n <- input$NumSample
    
    # Generate random samples and store in matrix sim.mat
    sim.mat <- matrix(rexp(n*nosim,rate=lambda),nosim)
    
    # calculate the theoretical mean
    theory_mean <- 1/lambda
    
    # calculate the theoretical variance
    theory_variance <- (1/lambda)^2
    
    ## call to draw actual distribution
    drawActual(sim.mat)
    
    ## Call function to draw plot
    drawPlot(sim.mat,theory_mean,theory_variance)
    
  }
  )
  
  # function to draw actual distribution
  drawActual <- function(sim.mat)
  {
    
    dfsample <- as.data.frame(as.vector(sim.mat))
    names(dfsample)<- c("Values")
    
    # Draw histogram to view the sample draw distribution
    b <- ggplot(data=dfsample)+geom_histogram(mapping=aes(x=dfsample$Values,y=..density..),binwidth = 0.5,fill="blue",col="black")+xlab("sample draws")+ggtitle("sample distribution of simulation data")+ylab("density")
    output$ActPlot <- renderPlot(b)
    
    
  }
  
  # function to draw plot for sample mean distribution.
  drawPlot <- function(sim.mat,theory_mean,theory_variance)
  {
    # sample mean distribution list
    mean_dist <- apply(sim.mat,1,mean)
    
    # sample variance distribution list
    var_dist <- apply(sim.mat,1,var)
    
    # sample mean
    mean_sample <- mean(mean_dist)
    
    # sample variance
    var_sample <- mean(var_dist)
    
    # Convert mean_dist to dataframe so as to use in ggplot
    mean_dist <- as.data.frame(mean_dist)
    
    output$TheoryMean <- renderText(paste('Theorized mean of sample means =',theory_mean))
    output$ActualMean <- renderText(paste('Actual mean of sample means =',mean_sample))
    
    output$TheoryVar <- renderText(paste('Theorized variance of sameple means =',theory_variance))
    output$ActualVar <- renderText(paste('Actual variance of sameple means =',var_sample))
    
    # draw the plot for sample mean distribution
    a  <- ggplot(data=mean_dist)+geom_histogram(mapping=aes(x=mean_dist,y=..density..),binwidth = 0.15,col="white",fill="grey")
    
    # add density curve for normal distribution.
    a <- a + stat_function(fun=dnorm,args=list(mean=mean(mean_dist$mean_dist),sd=sd(mean_dist$mean_dist)),aes(col="Normal Distribution"),lwd=1)+xlab("sample means")+ylab("density")+ggtitle("Sample Mean Distribution for simulations")
    
    # add density curve for actual distribution and vertical lines for sample mean and theoretical mean
    a <- a + geom_density(aes(x=mean_dist,y=..density..,col="Actual Distribution"),size=1,lwd=3) + geom_vline(aes(xintercept = mean_sample, col="Mean of Sample Means"),lwd=1)+geom_vline(aes(xintercept = theory_mean, col="Theoretical Mean"),lwd=1)
    
    # add legend for the curves added
    a <- a + scale_color_manual(name="",breaks=c("Mean of Sample Means","Theoretical Mean","Actual Distribution","Normal Distribution"), 
                                values = c("blue","orange","black","red"))
    
    a <-  a+theme(legend.position="bottom")
    
    # convert ggplot to plotly
    ggplotly(a)
    
    
  }
  
  # reactive expression for generating graph for binomial distribution
  reBinom <- reactive({
    
    
    nosim <- input$NumSim
    n <- input$NumSample
    s <- input$size
    p <- input$Prob
    
    # calculate the theoretical mean
    theory_mean <-s*p
    
    # calculate the theoretical variance
    theory_variance <- s*p*(1-p)
    
    # Generate random samples and store in matrix sim.mat
    sim.mat <- matrix(rbinom(n*nosim,size=s,prob=p),nosim)
    
    ## call to draw actual distribution
    drawActual(sim.mat)
    
    ## Call function to draw plot
    drawPlot(sim.mat,theory_mean,theory_variance)
    
  }
  )
  
})
