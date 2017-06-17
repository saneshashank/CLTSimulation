#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  tabsetPanel( 
    
    # add first tab
    tabPanel(title = "What is Central Limit Theorem",
             
             tags$body(
               h1(" Central Limit Theorem"),  
               # Add line break
               tags$br(),
               
               # div 1 start
               tags$div(class = "header", checked = NA,
                        
                        tags$p("The", tags$b("Central Limit Theorem (CLT)"), "establishes that, for the most commonly studied scenarios, 
                               when independent random variables are added, their sum tends toward a normal distribution (commonly known as a bell curve) even if the original variables themselves are not normally distributed. In more precise terms, given certain conditions, the arithmetic mean of a sufficiently large number of iterates of independent random variables, each with a well-defined (finite) expected value and finite variance, will be approximately normally distributed, regardless of the underlying distribution.The theorem is a key concept in probability theory because it implies that probabilistic and statistical methods that work 
                               or normal distributions can be applicable to many problems involving other types of distributions."),
                        tags$a(href = "https://en.wikipedia.org/wiki/Central_limit_theorem", "Courtesy: Wikipedia, click here for additional details"),
                        
                        
                        tags$br(),
                        tags$br(),
                        
                        tags$p(tags$b("BREAKING DOWN Central Limit Theorem - CLT : "),
                               "According to the central limit theorem,the mean of a sample of data will be closer to the mean of the overall population in question as the sample size increases, 
                               notwithstanding the actual distribution of the data, and whether it is normal or non-normal. As a general rule, 
                               sample sizes equal to or greater than 30 are considered sufficient for the central limit theorem to hold, 
                               meaning the distribution of the sample means is fairly normally distributed."
                        ),
                        tags$a(href = "http://www.investopedia.com/terms/c/central_limit_theorem.asp#ixzz4k30qA2IP",
                               "Read more: Central Limit Theorem (CLT)") 
                        
                        ), # div 1 end
               h1("About this Application"),
               
               tags$div(
                 tags$p("This application serves as an educational tool to aid understanding of the Central Limit.",
                        tags$b("Simulation tab:"), "the simulation tab of this application lets user choose among distributions
                        like - Exponential and Binomial Distribution and allows user to choose parameters applicable
                        to these distribution (example: probability and size for binomial distribution),
                        users can select the number of simulations and number of random samples to
                        be included in each distribution and can experience first hand how the simulated distribution
                        of sample means(illustrated with blue curve)  approaches that of Normal Distribution(illustrated by black curve)."
                        ,tags$b("How does actual distribution look like?:"),"this tab gives an idea about the actual distribution of sample
                        values."
                        ),
                 
                 tags$p(tags$b("How to use: "),"Select the required distribution using radio button,use the sliders to adjust the number of simulations and sample size. 
                        The visualization has been rendered in ggplot2 and Plotly, click on the black and blue curves and red and orange vertical lines 
                        to remove and add from the graph."  
                 ),
                 
                 tags$p("Notice how the mean of sample means (represented by orange vertical line)
                        approach closer and closer to the theorized mean (population mean) (represented by red vertical line) 
                        as the the number of simulations and sample sizes are increase. The values of population mean and sample mean
                        and population mean and population variance are printed below for comparison." 
                 )
                 ) # div 2 end
                 )# End of body tag
             
    ),
    
    
         
        
        # Add second tab
        tabPanel(title = "Simulation",
        # Application title
        titlePanel("Central Limit Theorem Simulation"),
        
        # Sidebar with a slider input for number of bins 
        sidebarLayout(
          sidebarPanel(
             sliderInput("NumSim",
                         "Number of Simulations:",
                         min = 10,
                         max = 100,
                         value = 20),
             
             sliderInput("NumSample",
                         "Number of Samples:",
                         min = 10,
                         max = 100,
                         value = 20),
             
             radioButtons("dist","Choose Distribution",choices=c("Exponential Distribution"="Exp","Binomial Distribution"="Binom")),
             
             # Add conditional Panel for exponential distribution parameter - lambda
             conditionalPanel(
               condition = "input.dist == 'Exp'",
               numericInput("lambda", "lambda",value=0.2,min=0.1,max=0.5,step = 0.1)
             ),
             
             # Add conditional Panel for binomial distribution parameter - Probability
             conditionalPanel(
               condition = "input.dist == 'Binom'",
               numericInput("Prob", "Probability",value=0.5,min=0.1,max=0.6,step = 0.1)
             ),
             
             # Add conditional Panel for binomial distribution parameter- size
             conditionalPanel(
               condition = "input.dist == 'Binom'",
               numericInput("size", "size",value=2,min=1,max=10,step = 1)
             )
             
          ),
          
          # Show a plot of the generated distribution
          mainPanel(
            plotlyOutput("distPlot"),
            verbatimTextOutput("TheoryMean"),
            verbatimTextOutput("ActualMean"),
            verbatimTextOutput("TheoryVar"),
            verbatimTextOutput("ActualVar")
            
          )
        )
        ),
        
        tabPanel(title = "How does actual distribution look like?",
                 plotOutput("ActPlot") 
                 )
        
  )
))
