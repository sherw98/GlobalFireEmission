library(shiny)
shinyServer(function(input, output){
  observeEvent(input$PlotChoropleth1, {
    #get the input selection:
    var.choropleth = input$ChoroplethVar1
    #change the input selection to its corresponding var name since they are not the same 
    var.choropleth1 = identifyvar(var.choropleth)
    year.choropleth = input$ChoroplethYear1
    
    #select the right vars:
    choroplethdata = full_data.long %>%
      filter(Year %in% year.choropleth,
             Variable %in% var.choropleth1) %>%
      left_join(worldmap, by = "COUNTRY")
    
    choroplethplot1 = ggplot() +
      geom_polygon(data = choroplethdata, aes(x = long, y = lat, group = group, fill = Value), color = "white") +
      scale_fill_gradientn(colors = c("#041E42", "#356bb5", "#457bc4", "#618dc7", 
                                      "#729acf", "#7ea1cf", "#a2bbdb", "#d8e3f2")) +
      labs(title = paste(var.choropleth, "in Year", year.choropleth)) +
      theme_void() +
      theme(legend.title = element_blank())+
      theme(text = element_text(size = 15))
   
     output$Choropleth1 = renderPlot({
      choroplethplot1
    })
  })
  
  observeEvent(input$PlotChoropleth2, {
    var.choropleth = input$ChoroplethVar2
    var.choropleth1 = identifyvar(var.choropleth)
    year.choropleth = input$ChoroplethYear2
    
    choroplethdata = full_data.long %>%
      filter(Year %in% year.choropleth,
             Variable %in% var.choropleth1) %>%
      left_join(worldmap, by = "COUNTRY")
    
    choroplethplot2 = ggplot() +
      geom_polygon(data = choroplethdata, aes(x = long, y = lat, group = group, fill = Value), color = "white") +
      scale_fill_gradientn(colors = c("#041E42", "#356bb5", "#457bc4", "#618dc7", 
                                      "#729acf", "#7ea1cf", "#a2bbdb", "#d8e3f2")) +
      labs(title = paste(var.choropleth, "in Year", year.choropleth)) +
      theme_void()+
      theme(legend.title = element_blank())+
      theme(text = element_text(size = 15))
    
    output$Choropleth2 = renderPlot({
      choroplethplot2
      
    })
  })
  
  observeEvent(input$plotTSbyCoun, {
    var.ts = input$TSbyCounVar
    var.ts1 = identifyvar(var.ts)
    country.ts = input$TSbyCounCoun
    
    tsbycoundata = full_data.long %>%
      filter(Variable %in% var.ts1, 
             COUNTRY %in% country.ts) 
    
    output$TSbyCounX = renderUI({
      sliderInput("CounXInput", "X-axis Length", min = min(theyear), max = max(theyear), value = c(min(theyear), max = max(theyear)))
    })
    
    
    yslider = as.numeric(format(max(tsbycoundata$Value)), scientific = T)
    
    output$TSbyCounY = renderUI({
      sliderInput("CounYInput", "Y-axis Length", min = 0, max = yslider + 2000, value = c(0, yslider + 2000), round = T)
    })
    

    output$TSbyCoun = renderPlot({
      tsbycounplot = ggplot() +
        geom_line(data = tsbycoundata, aes(x = Year, y = Value, color = Variable)) +
        ylim(input$CounYInput) +
        xlim(input$CounXInput) +
        labs(title = paste(titlename(var.ts), "in", country.ts)) +
        theme_minimal()+
        theme(legend.title = element_blank())+
        theme(text = element_text(size = 15))
      tsbycounplot
    })
    
  })
  
  observeEvent(input$plotTSbyVar, {
    var.ts = input$TSbyVarVar
    var.ts1 = identifyvar(var.ts)
    country.ts = input$TSbyVarCoun
    
    tsbyvardata = full_data.long %>%
      filter(Variable %in% var.ts1, 
             COUNTRY %in% country.ts) 
    
    output$TSbyVarX = renderUI({
      sliderInput("VarXInput", "X-axis Length", min = min(theyear), max = max(theyear), value = c(min(theyear), max = max(theyear)))
    })
    
    
    yslider = as.numeric(format(max(tsbyvardata$Value)), scientific = T)
    
    output$TSbyVarY = renderUI({
      sliderInput("VarYInput", "Y-axis Length", min = 0, max = yslider + 2000, value = c(0, yslider + 2000), round = T)
    })
    

    output$TSbyVar = renderPlot({
      tsbyvarplot = ggplot() +
        geom_line(data = tsbyvardata, aes(x = Year, y = Value, color = COUNTRY)) +
        labs(title = paste(titlename(country.ts), "in", var.ts)) +
        ylim(input$VarYInput) +
        xlim(input$VarXInput) +
        theme_minimal()+
        theme(text = element_text(size = 15))
      tsbyvarplot
    })
    
  })
  
  observeEvent(input$plotSS,{
    var.ss = input$SSVar
    var.ss1 = identifyvar(var.ss)
    country.ss = input$SSCoun
    
    ssdata = full_data.long %>%
      filter(COUNTRY %in% country.ss,
             Variable %in% var.ss1)
          
    
    output$plotSS = renderPlot({
      histogram = ggplot(data=ssdata)+
        geom_histogram(aes(x=Value), fill = "#356bb5")+
        scale_fill_manual(labels = c("Sava" = "Savanna Fire",
                                                         "Burnt"="Total Area Burnt",
                                                         "burnperc" = "Percentage Burnt",
                                                         "All" = "All fire",
                                                         "Borf" = "Boreal Forest Fire",
                                                         "Defo" = "Deforestation",
                                                         "Temf" = "Temperate Fire",
                                                         "Agri" = "Agriculture Waste"))+
        facet_wrap(~Variable, scale = "free") +
        theme_minimal() +
        theme(text = element_text(size = 16))
      histogram
      
      
    })
    
    output$tableSS = renderPrint({
      sstabledata = full_data %>%
        dplyr::select(COUNTRY, var.ss1) %>%
        dplyr::filter(COUNTRY %in% country.ss)
      
      summary(sstabledata[,-1])
    })
    
  })
  
  
  observeEvent(input$plotSS1,{
    var.ss = input$SSVar1
    var.ss1 = identifyvar(var.ss)
    country.ss = input$SSCoun1
    
    ssdata = full_data.long %>%
      filter(Variable %in% var.ss1, 
             COUNTRY %in% country.ss) 
    
    
    output$plotSS1 = renderPlot({
      histogram = ggplot(data=ssdata)+
        geom_histogram(aes(x=Value), fill = "#356bb5")+
        scale_fill_manual(labels = c("Sava" = "Savanna Fire", 
                                     "Burnt"="Total Area Burnt", 
                                     "burnperc" = "Percentage Burnt",
                                     "All" = "All fire",
                                     "Borf" = "Boreal Forest Fire",
                                     "Defo" = "Deforestation",
                                     "Temf" = "Temperate Fire",
                                     "Agri" = "Agriculture Waste"))+
        facet_wrap(~COUNTRY, scale = "free") +
        theme_minimal() +
        theme(text = element_text(size = 16))
      histogram
  })
    
    output$tableSS1 = renderPrint({
      sstabledata = full_data %>%
        dplyr::select(Year, COUNTRY, var.ss1) %>%
        dplyr::filter(COUNTRY %in% country.ss) %>%
        spread(COUNTRY, var.ss1)
      
      
      summary(sstabledata[,-1])
    })
  })
})