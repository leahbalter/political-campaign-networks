# whole bunch of packages i use for this
library('readxl')
library('dplyr')
library('ggplot2')
#library('ggmap')
library('maps')
library('mapdata')
library('gridExtra')
library('fiftystater')

# useful file locations stored for later
# git_file = root of location of where github files are stored on my computer
# pdf_file = root fo the location where i'm going to store the pdf on my computer
# margin_file = root of location for where i stored the fec excel files for election results

git_file <- 'C:/Users/leahm/Documents/GitHub/political-campaign-networks/Data and Results/'
pdf_file <- '~/Coding/political campaign project/RStuff/RStuff/results/'
margin_file <- 'C:/Users/leahm/Documents/Coding/political campaign project/RStuff/RStuff/data/resultsFEC/'
year <- 2016
sheet_name <- '2016 US Senate Results by State'

# election result data for the fec is in an excel file; 2016 is a .xlsx; earlier years are .xls
# also i ran into a problem where the fec only has the excel files for election results from i think 2000 on (maybe it was 1998, i don't remember)
if (year == '2016') {
    ext <- '.xlsx'
} else {
    ext <- '.xls'
}

# getting the network metrics .csv as computed in matlab for that year and converting it into a dataframe and converting it into named columns
network_file <- 'C:/Users/leahm/Documents/Coding/political campaign project/matlabStuff/results/'
net_res <- read.csv(paste(network_file, year, '/stateNodes', year, '.csv', sep = "", collapse = NULL))
names(net_res) <- c('state', 'wdeg', 'deg', 'wpr', 'pr', 'weig', 'eig')

# getting the election results .xls (or .xlsx) and converting it into a dataframe with named columns
# states are labeled as id because this dataframe is going to be merged with the dataframe that holds the long/lat info for the states and 
# geoegraphic regions in the mapdata dataframes are known as 'id' 
sen_res <- read_excel(paste(margin_file, '/federalelections', year, ext, sep = "", collapse = NULL), sheet = sheet_name)
sen_res <- sen_res[c(2, 3, 5, 6, 9, 11, 16)]
names(sen_res) <- c('abv', 'id', 'fecID', 'inc', 'canName', 'party', 'votes')

# in the maps dataframe the state names are lowercase so i convert it them to lowercase too 
# also only selecting the rows of the senatorial results dataframes for candidates in the general election +
# the total number of votes iirc
sen_res$id <- tolower(sen_res$id)
sen_res <- sen_res %>%
    filter(votes != 'NA' & id != 'NA')

# adding the lowercase statenames to the dataframe of metric data
net_res$id <- NA
net_res$id = sen_res[match(net_res$state, sen_res$abv),]$id

# making a new dataframe to hold: 
# state, margin of victory, party of the victory, indicator for whether the incumbent ran
# and another to indicate if there was a signifcant third party ('significant' here defined as the two major candidates got less than 90% of the vote)
s <- unique(sen_res$id)
a <- data.frame(id = s)
a$diff <- NA
a$party <- NA
a$inc <- NA
a$third <- NA

# populating the dataframe with a for loop
i = 1
for (val in s) {
    temp <- subset(sen_res, id == val)
    row <- temp[nrow(temp),]
    temp <- temp[-nrow(temp),]
    temp <- temp[order(-temp$votes),]
    temp <- rbind(temp, row)
    temp$percent <- NA

    for (j in 1:nrow(temp)) {
        total_votes <- sum(temp[which(temp$canName == temp[j,]$canName),]$votes) 
        temp[j,]$percent <- total_votes / temp[nrow(temp),]$votes

        if (j == nrow(temp)) {
            temp[j,]$percent <- 1.0
        }
    }
    round(temp$percent, digits =6)

    a[i,]$diff = temp[1,]$percent - temp[2,]$percent
    a[i,]$party = temp[1,]$party

    if ('(I)' %in% temp$inc) {
        a[i,]$inc = 'Y'
    } else {
        a[i,]$inc = 'N'
    }

    if ( (temp[1, ]$percent + temp[2, ]$percent) > .9) {
        a[i,]$third = 'N'
    } else {
        a[i,]$third = 'Y'
    }
    i = i + 1
}

# merging the new 'a' dataframe that holds margin of victory info with the dataframe taht holds state geographic data
states <- fifty_states
temp <- inner_join(states, a, by = 'id')
temp1 <- inner_join(states, net_res, by = 'id')


# i don't remember what each line here does but it craetes the base of the map
map_base <- ggplot(data = states, mapping = aes(x = long, y = lat, group = group)) +
    coord_fixed(1.3) +
    geom_polygon(color = 'black', fill = 'gray')

# this is some formatting for the map but i don't know what each line does
ditch_the_axes <- theme(
    axis.text = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank(),
    panel.border = element_blank(),
    panel.grid = element_blank(),
    axis.title = element_blank()
)

# once i have the map base i add the shading by margin of victory + formatting 
g <- map_base +
    geom_polygon(data = temp, aes(fill = diff), color = 'white') +
    geom_polygon(color = 'black', fill = NA) +
    theme_bw() +
    ditch_the_axes +
    ggtitle('Margin of Victory in the 2016 US Senatorial Elections') +
    scale_fill_gradient(trans = 'sqrt', low = '#206020', high = '#b3e6b3',
        guide = guide_colorbar(title = 'Margin', title.position = 'bottom'))
    
# and on the same map base i make a new map that has shading by wPR and then formatting
# i might have to fiddle with the exact formatting for each year; i'm not sure
g1 <- map_base +
     geom_polygon(data = temp1, aes(fill = wpr), color = 'white',) +
     geom_polygon(color = 'black', fill = NA) +
     theme_bw() +
     ditch_the_axes +
     ggtitle('Weighted PageRank of States in the 2016 Senatorial Elections') +
     scale_fill_gradient(trans = 'log', low = '#b3e6b3', high = '#206020',
                         guide = guide_colorbar(title ='wPR', title.position = 'bottom'))

# putting both maps on top of each other
a <- grid.arrange(g, g1, nrow = 2)

# saving as a pdf in my R-code folder
pdf(paste(pdf_file, year, '/yearComp', '.pdf', sep = "", collapse = NULL))
plot(a)
dev.off()

# saving as a pdf in my github-files folder
pdf(paste(git_file, year, '/yearComp', '.pdf', sep = "", collapse = NULL))
plot(a)
dev.off()

# things to change/check each time:
# 1. year
# 2. name of sheet
# 3. columns and column names

# assorted notes:
# 1. manually fixed louisiana margin in 2016: runoff made the FEC sheet formatted differently
#####: a[which(a$id == 'louisiana'),]$diff <- (536191-347816)/(536191 + 347816) (fec spreadsheet vote values)

# 2. 2016: g <- 
