# Sratch area:

library(rgdal)
# *** can now import the points of where we stayed indiviually
wws <- rgdal::readOGR('data/WhereWeStayed.kml',layer = 'Where we stayed')
# *** stil can't get the driving route to import though
# *** it seems like this is because the path is contained in one area, and all of the
# *** points where the directions stop at, are contained in a different area.
d1 <- rgdal::readOGR('data/DrivingRoute1.kml', layer = 'Driving Route (part 1)')


# *** The reading using maptools works to draw the path
# read the coordinates from the klm file
library(maptools)
wws <- maptools::getKMLcoordinates('data/WhereWeStayed.kml',TRUE)
d1 <- maptools::getKMLcoordinates('data/DrivingRoute1.kml',TRUE)
d2 <- maptools::getKMLcoordinates('data/DrivingRoute2.kml',TRUE)

r1 <- as.data.frame(d1[[1]])
r2 <- as.data.frame(d2[[1]])
r1 <- rbind(r1,r2)
names(r1) <- c('long','lat')

library(ggplot2)
library(maps)

usamap <- ggplot2::map_data("world")
gg <- ggplot() + geom_polygon(data = usamap, aes(x = long, y = lat, group = group)) +
  coord_cartesian(xlim = c(-70,-125), ylim = c(5,40))

gg <- gg + geom_point(data = r1, aes(x = long, y = lat), color = 'red', size = 3)
