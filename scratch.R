# *** TO DO
# - export each layer from google map individually
# -- for the where we stayed layer, remove the line from it prior to exporting


# read the coordinates from the klm file
library(maptools)

cc <- maptools::getKMLcoordinates('data/doc.kml')

# library(rgdal)
# *** rgdal doesn't seem to work because each of the layers has a combination of points and lines
# cc <- rgdal::readOGR('data/doc.kml', layer = 'Driving Route (part 4)')

pp <- rbind(cc[[1]], cc[[2]])
pp <- as.data.frame(pp)
names(pp) <- c('long', 'lat', 'z')


library(ggplot2)
library(maps)

zz <- c()
for(i in 1:length(cc)){
  if(nrow(cc[[i]]) == 1){
    zz <- rbind(zz, cc[[i]])
  }
}

zz <- as.data.frame(zz)
names(zz) <- c('long','lat','z')

usamap <- ggplot2::map_data("world")
gg <- ggplot() + geom_polygon(data = usamap, aes(x = long, y = lat, group = group)) +
  coord_cartesian(xlim = c(-70,-125), ylim = c(5,40))

gg <- gg + geom_point(data = zz, aes(x = long, y = lat), color = 'red', size = 3)
