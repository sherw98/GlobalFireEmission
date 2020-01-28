library(shiny)


shinyUI(navbarPage(
  "Global Fire Emission",
 
   tabPanel(
    "About",
    mainPanel(
      br(),
      img(src="savanna-burning.jpg", style="display: block; margin-left: auto; margin-right: auto;"),
      width=12,
      
      h4(strong("Our Data")),
      p("We obtained our dataset from NASA's Socioeconomic Data and Application Center (SEDAC). 
        This dataset includes countries' total area, populations, total area burnt, 
        total carbon content, and different types of fires which cause emission."),
      p("Five fire types are included in our final data: Agricultural, Boreal, 
        Tropical Deforestation, Savanna, and Temperate forest fires."),
      br(),
      h4(strong("Our App")),
      p("Our Shiny App has three different types of analysis based on the dataset that we have."), 
      p("The", em("Summary Statistics"), "provide a holistic picture of each country's each fire 
        types in the form of histogram."),
      p("The", em("Choropleths"), "demonstrate the global fire emission situation for different 
        fire types in a specific year."),
      p("The", em("Time Series"), "show the general trends in different types of fire emission
        in different countries."),
      br(),
      h4(strong("Citation")),
      p("Center for International Earth Science Information Network - CIESIN - Columbia University. 
        2018. Global Fire Emissions Indicators, Country-Level Tabular Data: 1997-2015. Palisades, 
        NY: NASA Socioeconomic Data and Applications Center (SEDAC). https://doi.org/10.7927/H4V69GJ5. 
        Accessed 23/11/2019."),
      p("Savanna Burning. (2019, September 2). Retrieved December 12, 2019, 
        from https://dfat.gov.au/about-us/publications/trade-investment/business-envoy/Pages/august-2019/savanna-burning.aspx."),
      br(),
      br(),
      h4(strong("Yixuan (Sherry) Wu, Georgetown University, and Kelly Wu, Gerogetown University. \n
                For questions, please contact wy117@georgetown.edu or yw530@georgetown.edu"))
    )
  ),
  
  tabPanel(
    "Summary Statistics",
    sidebarPanel(
      radioButtons("SSChoice", "Summary Statistics by a Country or a Variable?", choices = c("Country", "Variable")),
      conditionalPanel(
        condition = "input.SSChoice == 'Country'",
        selectInput("SSCoun", "Select a Country", choices = countryname, selected = "USA", multiple = F),
        selectInput("SSVar", "Select a Variable", choices = variablename, selected = variablename[1], multiple = T),
        actionButton("plotSS", "Display the plot & table")
      ),
      conditionalPanel(
        condition = "input.SSChoice == 'Variable'",
        selectInput("SSCoun1", "Select a Country", choices = countryname, selected = "USA", multiple = T),
        selectInput("SSVar1", "Select a Variable", choices = variablename, selected = variablename[1], multiple = F),
        actionButton("plotSS1", "Display the plot & table")
      ),
      br(),
      br()
    ),
    mainPanel(
      helpText("Press the buttons on the side to generate the plots and to refresh the plot."),
      helpText("Note it may take a while for the plots to be displayed."),
      br(),
      br(),
      conditionalPanel(
        condition = "input.SSChoice == 'Country'",
        plotOutput("plotSS"),
        verbatimTextOutput("tableSS")
      ),
      conditionalPanel(
        condition = "input.SSChoice == 'Variable'",
        plotOutput("plotSS1"),
        verbatimTextOutput("tableSS1")
      )
      
    )
  ),
  
  tabPanel(
    "Choropleths",
    sidebarPanel(
      selectInput("ChoroplethVar1", "Select the First Variable", choices = variablename),
      selectInput("ChoroplethYear1", "Select a Year", choices = theyear, selected = 2010),
      actionButton("PlotChoropleth1", "Display the Plot"),
      br(),#add an empty line
      br(),
      br(),
      radioButtons("AddGraph1", "Want to add another choropleth for comparison?", 
                   choices = c("Yes", "No"), selected = "No"),
      conditionalPanel(
        condition = "input.AddGraph1 == 'Yes'", 
        selectInput("ChoroplethVar2", "Select the Second Variable", choices = variablename, selected = variablename[2]),
        selectInput("ChoroplethYear2", "Select a Year", choices = theyear, selected = 2010),
        actionButton("PlotChoropleth2", "Display the Plot")
      )
    ),
    mainPanel(
      helpText("Press the buttons on the side to generate the plots."),
      helpText("Note it may take a while for the plots to be displayed."),
      br(),
      br(),
      plotOutput("Choropleth1"),
      conditionalPanel(condition = "input.AddGraph1 == 'Yes'", 
                       plotOutput("Choropleth2"))
    )
  ),
  
  tabPanel(
    "Time Series",
    sidebarPanel(
      radioButtons("TSChoice", "Time Series by a Country or a Variable?", choices = c("Country", "Variable")),
      conditionalPanel(
        condition = "input.TSChoice == 'Country'",
        selectInput("TSbyCounCoun", "Select a Country", choices = countryname, selected = "USA"),
        selectInput("TSbyCounVar", "Select One or More Variables", 
                    choices = variablename, multiple = T, selected = variablename[1]),
        actionButton("plotTSbyCoun", "Display the Plot"),
        br(),
        br(),
        uiOutput("TSbyCounX"),
        uiOutput("TSbyCounY")
      ),
      conditionalPanel(
        condition = "input.TSChoice == 'Variable'",
        selectInput("TSbyVarVar", "Select a Variable", choices = variablename, selected = variablename[1]),
        selectInput("TSbyVarCoun", "Select One or More Countries", 
                    choices = countryname, multiple = T, selected = "USA"),
        actionButton("plotTSbyVar", "Display the Plot"),
        br(),
        br(),
        uiOutput("TSbyVarX"),
        uiOutput("TSbyVarY")
      )
    ),
    mainPanel(
      helpText("Press the buttons on the side to generate the plots and to refresh the plot."),
      helpText("Note it may take a while for the plots to be displayed."),
      br(),
      br(),
      conditionalPanel(
        condition = "input.TSChoice == 'Country'",
        plotOutput("TSbyCoun")
      ),
      conditionalPanel(
        condition = "input.TSChoice == 'Variable'",
        plotOutput("TSbyVar")
      )
    )
  ),
  tags$head(
    tags$style(type = 'text/css',
               HTML('.navbar { background-color: #003366;}
                          .navbar-default .navbar-brand{color: papayawhip;}
                          .tab-panel{ background-color: white; color: #003366}
                          .navbar-default .navbar-nav > .active > a,
                          .navbar-default .navbar-nav > .active > a:focus,
                          .navbar-default .navbar-nav > .active > a:hover {
                                color: #003366;
                                background-color: papayawhip;
                            }
                     .navbar-default .navbar-nav > li > a:focus,
                     .navbar-default .navbar-nav > li > a:hover{color: papayawhip}
                     
                    '),
               HTML('
                    .well{min-height:20px;padding:19px;margin-bottom:20px;
                    background-color:white;border:1px solid #papaywhip;border-radius:4px;
                    -webkit-box-shadow:inset 0 1px 1px rgba(0,0,0,.05);
                    box-shadow:inset 0 1px 1px rgba(0,0,0,.05)}'),
               HTML(' .nav-tabs > li.active > a, .nav-tabs > li.active > a:focus,
                      .nav-tabs > li.active > a:hover {
                      color: #003366; background-color: papayawhip;
                    }
                    a{color:#003366;text-decoration:none}'),
               HTML('pre{display:block;padding:9.5px;
                    margin:0 0 10px;font-size:13px;line-height:1.42857143;
                    color:#003366;word-break:break-all;word-wrap:break-word;
                    background-color:white;border:transparent;border-radius:4px}
                    '),
               HTML('.help-block{display:block;margin-top:5px;margin-bottom:10px;color:#003366}
                    '),
               #font color in sidebar and general, used to be black, ex: variable1, variable2
               HTML('body{font-family:"Helvetica Neue",Helvetica,Arial,sans-serif;font-size:14px;
                    line-height:1.42857143;color:#003366;background-color:#fff}'),
               #sliderbutton color
               HTML('.irs-slider {
                    top: 17px;
                    width: 22px; height: 22px;
                    border: 1px solid #AAA;
                    background: papayawhip;
                    border-radius: 27px;
                    -moz-border-radius: 27px;
                    box-shadow: 1px 1px 3px rgba(0,0,0,0.3);
                    cursor: pointer;
                    }'),
               HTML('.irs-from, .irs-to, .irs-single {
                    color: papayawhip;
                    font-size: 11px; line-height: 1.333;
                    text-shadow: none;
                    padding: 1px 3px;
                    background: #003366;
                    border-radius: 3px;
                    -moz-border-radius: 3px;
                    }
                    '),
               HTML('
                    .irs-min, .irs-max {
                    color: papayawhip;
                    font-size: 10px; line-height: 1.333;
                    text-shadow: none;
                    top: 0;
                    padding: 1px 3px;
                    background: #003366;
                    border-radius: 3px;
                    -moz-border-radius: 3px;
                    }
                    '),
               HTML('
                    .irs-bar {
                    height: 8px; top: 25px;
                    border-top: 1px solid #003366;
                    border-bottom: 1px solid #003366;
                    background: #003366;
                    }
                    .irs-bar-edge {
                    height: 8px; top: 25px;
                    width: 14px;
                    border: 1px solid #003366;
                    border-right: 0;
                    background: #003366;
                    border-radius: 16px 0 0 16px;
                    -moz-border-radius: 16px 0 0 16px;
                    }
                    '),
               HTML('.btn-default {
    color: papayawhip;
    background-color: #003366;
    border-color: papayawhip;
}
                    '),
               HTML('.btn:hover{
                                #border-color: papayawhip;
                    background-color: papayawhip; color: #003366;font-weight: bold;
                    }
                    '),
               HTML('
                    .selectize-control.multi .selectize-input > div {
    cursor: pointer;
                    margin: 0 3px 3px 0;
                    padding: 1px 3px;
                    background: papayawhip;
                    color: #003366;
                    border: 0 solid rgba(0, 0, 0, 0);
                    }'),
               HTML('.selectize-input {
    border: 1px solid #003366;
                    
                    }
                    '),
               HTML('
                    .selectize-dropdown, .selectize-input, .selectize-input input {
    color: #003366;}'),
               HTML('.irs-bar {
    height: 8px;
    top: 25px;
    border-top: 1px solid #003366;
    border-bottom: 1px solid #003366;
    background: #003366;
}')
               
    )
  ) 
  
)
)