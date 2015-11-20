library(ggplot2)
library(dplyr)
library(ggvis)

#*** need to get the zoo package and make into a time series; right now the TS is not in
#    the correct order

zz <- read.csv('data/Costs.csv')

# set any NA's to 0
zz$Cost[is.na(zz$Cost)] <- 0

# time series of costs
dayTot <- zz %>% group_by(Date) %>% summarise(Tot = sum(Cost))

g1 <- ggplot(dayTot, aes(Date, Tot,group = 'identity')) + geom_line() +
  geom_hline(yintercept = mean(dayTot$Tot)) 
g1 <- g1 + annotate('text', label = paste('Avg Daily Cost =',round(mean(dayTot$Tot)),2), 
            y = mean(dayTot$Tot) + diff(range(dayTot$Tot))*.05,
            x = mean(ggplot_build(g1)$panel$ranges[[1]]$x.range))

g1
g2 <- dayTot %>% mutate(Avg = mean(Tot)) %>%
  ggvis(~Date, ~Tot) %>% layer_lines() %>%
  layer_lines(y = ~Avg)

# try interactive plot

dayTot %>% ggvis(~Date, ~Tot) %>% layer_lines() %>%
  add_tooltip(all_values,'hover')
#%>% handle_hover(function(data,...) str(data))

mtcars %>% ggvis(~mpg, ~wt) %>% layer_points() %>%
  handle_hover(function(data, ...) str(data))

# costs by category
# make Breakfast, Lunch, Dinner, Snack all = Food
zz$Category <- as.character(zz$Category)
catCost <- zz %>% 
  dplyr::mutate(Category = replace(Category, Category %in% c('Breakfast', 'Lunch', 'Dinner','Snack'),'Food')) %>%
  dplyr::group_by(Category) %>% dplyr::summarize(Tot = sum(Cost))
zz$Category <- as.factor(zz$Category)

g2 <- ggplot(catCost, aes(x = Category, y = Tot, fill = Category)) + geom_bar(stat = 'identity')
g2

# costs by category in ggvis
g3 <- catCost %>% ggvis(~Category, ~Tot, fill = ~Category) %>% layer_bars(stack = F)
