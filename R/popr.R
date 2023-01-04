################################## load data function

load_popr <- function()
{

library(readr)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)


world_population <- read_csv("https://raw.githubusercontent.com/adamclarke6/data/main/world_population.csv")

world_map <- ne_countries(scale = 50, returnclass = 'sf')


world_map$gu_a3[186] <- "ESH"
world_map$gu_a3[189] <- "SSD"


popr <- merge(world_population, world_map[, c("gu_a3", "geometry")], by.x = "CCA3", by.y = "gu_a3")


names(popr)[names(popr) == "2022 Population"] <- "Population_2022"
names(popr)[names(popr) == "2020 Population"] <- "Population_2020"
names(popr)[names(popr) == "2015 Population"] <- "Population_2015"
names(popr)[names(popr) == "2010 Population"] <- "Population_2010"
names(popr)[names(popr) == "2000 Population"] <- "Population_2000"
names(popr)[names(popr) == "1990 Population"] <- "Population_1990"
names(popr)[names(popr) == "1980 Population"] <- "Population_1980"
names(popr)[names(popr) == "1970 Population"] <- "Population_1970"


return(popr)

}




################################################# fit function


fit_popr <- function(continent = "World", year1, year2, popr = load_popr())
{
  if(continent == "World")
  {
    map <- popr
    xlim <- c(-180,180)
    ylim <- c(-90, 90)
  }

  else if(continent == "Europe")
  {
    map <- popr[popr$Continent == "Europe",]

    xlim <- c(-25, 180)
    ylim <- c(30, 85)
  }

  else if(continent == "Africa")
  {
    map <- popr[popr$Continent == "Africa",]

    xlim <- c(-30, 60)
    ylim <- c(-40, 40)
  }

  else if(continent == "Asia")
  {
    map <- popr[popr$Continent == "Asia",]

    xlim <- c(20, 150)
    ylim <- c(-20, 60)
  }

  else if(continent == "Oceania")
  {
    map <- popr[popr$Continent == "Oceania",]

    xlim <- c(100, 180)
    ylim <- c(-60, 20)
  }

  else if(continent == "North America")
  {
    map <- popr[popr$Continent == "North America",]

    xlim <- c(-180,0)
    ylim <- c(0, 90)
  }

  else if(continent == "South America")
  {
    map <- popr[popr$Continent == "South America",]

    xlim <- c(-100,-30)
    ylim <- c(-60, 20)
  }

  else
  {
    stop("Not a continent")
  }




  if(year1 == "2022")
  {
    map$y1 <- map$Population_2022
  }

  else if(year1 == "2020")
  {
    map$y1 <- map$Population_2020
  }

  else if(year1 == "2015")
  {
    map$y1 <- map$Population_2015
  }

  else if(year1 == "2010")
  {
    map$y1 <- map$Population_2010
  }

  else if(year1 == "2000")
  {
    map$y1 <- map$Population_2000
  }

  else if(year1 == "1990")
  {
    map$y1 <- map$Population_1990
  }

  else if(year1 == "1980")
  {
    map$y1 <- map$Population_1980
  }

  else if(year1 == "1970")
  {
    map$y1 <- map$Population_1970
  }

  else
  {
    stop("Not a valid year")
  }



  if(year2 == "2022")
  {
    map$y2 <- map$Population_2022
  }

  else if(year2 == "2020")
  {
    map$y2 <- map$Population_2020
  }

  else if(year2 == "2015")
  {
    map$y2 <- map$Population_2015
  }

  else if(year2 == "2010")
  {
    map$y2 <- map$Population_2010
  }

  else if(year2 == "2000")
  {
    map$y2 <- map$Population_2000
  }

  else if(year2 == "1990")
  {
    map$y2 <- map$Population_1990
  }

  else if(year2 == "1980")
  {
    map$y2 <- map$Population_1980
  }

  else if(year2 == "1970")
  {
    map$y2 <- map$Population_1970
  }

  else
  {
    stop("Not a valid year")
  }


  output <- list("map" = map, "xlim" = xlim, "ylim" = ylim)

  return(output)
}



############################################### plot function




plot_popr <- function(model = model)
{



map <- model$map
xlim <- model$xlim
ylim <- model$ylim

pop_diff <- map$y1 - map$y2

col_pal <- colorRampPalette(c('purple','blue','green','yellow','orange','red'))

map$Col <- col_pal(20)[as.numeric(cut(pop_diff, breaks = 20))]

layout(t(1:2), widths = c(3,1))

plot(x = map$geometry, col = map$Col,
     main = paste("Population difference"),
     xlim = xlim, ylim = ylim)

legend_image <- as.raster(matrix(col_pal(20), ncol=1))

legend_image <- legend_image[ nrow(legend_image):1, ]

options(scipen=999) ####

plot(c(0,2),c(min(pop_diff), max(pop_diff)),type = 'n', axes = F,xlab = '', ylab = '')

text(x = 1.5, y = round(seq(from = min(pop_diff), to = max(pop_diff), length.out = 10), -5),
              labels = round(seq(from = min(pop_diff), to = max(pop_diff), length.out = 10), -5))

axis(4, at = round(seq(from = min(pop_diff), to = max(pop_diff), length.out = 10), -5),
                   pos = 0.9, labels = F, col = 0, col.ticks = 1, tck = -.1)

rasterImage(legend_image, 0, min(pop_diff), 1, max(pop_diff))

}




load_popr()
model <- fit_popr("Africa", "2022", "1970")
plot_popr(model)




















usethis::git_sitrep()



library(devtools)
library(knitr)
library(pkgbuild)
library(roxygen2)
library(testthat)


has_devel()
check_build_tools()

devtools::build()




