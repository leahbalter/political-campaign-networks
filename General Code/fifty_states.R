library(ggplot2)
library(fiftystater)

# Input the year
year <- 1980
filepath <- paste('political-campaign-networks\\Data and Results\\', year, '\\statenodes', year, '.csv', sep='', collapse = NULL)

# Import the data
df <- read.csv(file=filepath, head=TRUE, sep=',')
df_states <- read.csv(file='R\\states.csv', head=TRUE, sep=',') # important for geom_map()
states <- df_states[(df_states$Abbreviation %in% df$Name),] 

# Plot
p <- ggplot(df, aes(map_id = tolower(states$State)), color='white') +
  geom_map(aes(fill = wPageRank), map = fifty_states) + 
  expand_limits(x = fifty_states$long, y = fifty_states$lat) +
  coord_map() +
  scale_x_continuous(breaks = NULL) + 
  scale_y_continuous(breaks = NULL) +
  labs(x = "", y = "") +
  theme(legend.position = "bottom", 
        panel.background = element_blank())
p
