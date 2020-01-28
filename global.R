########Global
library(tidyverse)
library(readxl)
library(plotly)
library(maps)
#Read all excel files
TemfFires = read_excel("TCC-TemfFires.csv")
AgriFires = read_excel("TCC-AgriFires.csv")
DefoFires = read_excel("TCC-DefoFires.csv")
SavaFires = read_excel("TCC-SavaFires.csv")
BorfFires = read_excel("TCC-BorfFires.csv")
AllFires = read_excel("TCC-AllFires.csv")
BurntArea = read_excel("TTB.csv")

#Generate the usable files for all types of fires 
Temf.long = TemfFires %>% 
  gather(key = "Year", value = "Temf", -1:-4)
Agri.long = AgriFires %>% 
  gather(key = "Year", value = "Agri", -1:-4)
Defo.long = DefoFires %>% 
  gather(key = "Year", value = "Defo", -1:-4)
Sava.long = SavaFires %>% 
  gather(key = "Year", value = "Sava", -1:-4)
Borf.long = BorfFires %>% 
  gather(key = "Year", value = "Borf", -1:-4)
AllFires.long = AllFires %>% 
  gather(key = "Year", value = "All", -1:-5)

#Change the name for Morocco
AllFires.long$COUNTRY[AllFires.long$COUNTRY == "MoroTCo"] = gsub("T","c", AllFires.long$COUNTRY[AllFires.long$COUNTRY == "MoroTCo"])
AllFires.long$COUNTRY[AllFires.long$COUNTRY == "MorocCo"] = gsub("C","c", AllFires.long$COUNTRY[AllFires.long$COUNTRY == "MorocCo"])

#Total burned data for each country 
Burnt.long = BurntArea %>% 
  gather(key = "Year", value = "Burnt", -1:-5)
Burnt.long$Year = gsub("[a-z]", "", Burnt.long$Year)
Burnt.long$Year = gsub("_", "TCC", Burnt.long$Year)

#Combine all the data
full_data = Burnt.long %>% 
  full_join(AllFires.long, by = c("ISOCODE", "COUNTRY", "CIESINCODE", "Year")) %>%
  full_join(Borf.long, by = c("ISOCODE", "COUNTRY", "CIESINCODE", "Year")) %>%
  full_join(Sava.long, by = c("ISOCODE", "COUNTRY", "CIESINCODE", "Year")) %>%
  full_join(Defo.long, by = c("ISOCODE", "COUNTRY", "CIESINCODE", "Year")) %>%
  full_join(Agri.long, by = c("ISOCODE", "COUNTRY", "CIESINCODE", "Year")) %>%
  full_join(Temf.long, by = c("ISOCODE", "COUNTRY", "CIESINCODE", "Year"))  %>%
  select(-UNSDCODE,-UNSDCODE.x, -UNSDCODE.y, -UNSDCODE.x.x, -UNSDCODE.y.y, -UNSDCODE.x.x.x, -UNSDCODE.y.y.y)

#Remove the average and add the burn percent
full_data = full_data[full_data$Year != "AVERAGE",]
full_data$Year = gsub("[A-Z]", "", full_data$Year)
full_data$burnperc = full_data$Burnt/full_data$Area_sqkm
full_data$Year = as.numeric(full_data$Year)



#since no name match
worldmap = map_data("world")
names(worldmap)[5] = "COUNTRY"

full_data = full_data %>%
  mutate(COUNTRY = dplyr::recode(COUNTRY,
                          "Bolivia (Plurinational State of)" = "Bolivia",
                          "Brunei Darussalam" = "Brunei",
                          "Congo" = "Republic of Congo",
                          "Falkland Islands (Malvinas)" = "Falkland Islands",
                          "State of Palestine" = "Palestine",
                          "Iran (Islamic Republic of)" = "Iran",
                          "Côte d'Ivoire" = "Ivory Islands",
                          "Democratic People's Republic of Korea" = "North Korea",
                          "Republic of Korea" = "South Korea",
                          "Lao People's Democratic Republic" = "Laos",
                          "Republic of Moldova" = "Moldova",
                          "Curaçao" = "Curacao",
                          "Sint Maarten (Dutch part)" = "Sint Maarten",
                          "Micronesia (Federated States of)" = "Micronesia",
                          "Pitcairn" = "Pitcairn Islands",
                          "Saint-Barthelemy" = "Saint Barthelemy",
                          "Viet Nam" = "Vietnam",
                          "Syrian Arab Republic" = "Syria",
                          "The former Yugoslav Republic of Macedonia" = "Macedonia",
                          "United Kingdom of Great Britain and Northern Ireland" = "UK",
                          "United Republic of Tanzania" = "Tanzania",
                          "United States of America" = "USA",
                          "Venezuela (Bolivarian Republic of)" = "Venezuela",
                          "Wallis and Futuna Islands" = "Wallis and Futuna",
                          "Western Samoa" = "Samoa"))

#Change the country name in world map
worldmap = worldmap %>%
  mutate(COUNTRY=dplyr::recode(COUNTRY,
         "Antigua" = "Antigua and Barbuda",
         "Barbuda" = "Antigua and Barbuda",
         "Nevis" = "Saint Kitts and Nevis",
         "Saint Kitts" = "Saint Kitts and Nevis",
         "Grenadines" = "Saint Vincent and the Grenadines",
         "Saint Vincent" = "Saint Vincent and the Grenadines",
         "Trinidad" = "Trinidad and Tobago",
         "Tobago" = "Trinidad and Tobago"))

full_data.long = full_data %>%
  gather(key = "Variable", value = "Value", c(-1:-5,-7))

#input selections from the ui:
variablename = c("Total Area Burnt (sqkm)", "Percent Area Burnt", "Carbon Contents from All Fires (metric tons)", "Carbon Contents from Boreal Forest Fires (metric tons)", 
                 "Carbon Contents from Savanna Fires (metric tons)", "Carbon Contents from Tropical Deforestation & Degrdation (metric tons)",
                 "Carbon Contents from Temperate Forest Fire (metric tons)", "Carbon Contents from Agricultural Waste Burning (metric tons)")

theyear = unique(full_data$Year)

countryname = unique(full_data$COUNTRY)

#a function to change the selected variable to the actual var name of the data
identifyvar = function(varname){
  var = rep(NA, length(varname))
  for (i in 1:length(varname)) {
    if (varname[i] == "Total Area Burnt (sqkm)") {var[i] = "Burnt"}
    else if(varname[i] == "Percent Area Burnt") {var[i] = "burnperc"}
    else if (varname[i] == "Carbon Contents from All Fires (metric tons)") {var[i] = "All"}
    else if (varname[i] == "Carbon Contents from Boreal Forest Fires (metric tons)") {var[i] = "Borf"}
    else if (varname[i] == "Carbon Contents from Savanna Fires (metric tons)") {var[i] = "Sava"}
    else if (varname[i] == "Carbon Contents from Tropical Deforestation & Degrdation (metric tons)") {var[i] = "Defo"}
    else if (varname[i] == "Carbon Contents from Temperate Forest Fire (metric tons)") {var[i] = "Temf"}
    else {var[i] = "Agri"}
  }
  return(var)
}


#a function to set the title for the time series plot 
titlename = function(varvector){
  titlets = ""
  titlets = varvector[1]
  if(length(varvector)==2){
    titlets = paste(titlets, "and\n", varvector[2])
  }
  else if(length(varvector) > 2){
    for(i in 2:(length(varvector)-1)){
      titlets = paste(titlets, ",\n", varvector[i], sep = "")
    }
    titlets = paste(titlets, ", and\n", varvector[length(varvector)], sep = "")
  }
  return(titlets)
}

