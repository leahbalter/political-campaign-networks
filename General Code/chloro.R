library('readxl')
library('dplyr')
library('ggplot2')
library('ggmap')
library('maps')
library('mapdata')
library('gridExtra')

git_file <- 'C:/Users/leahm/Documents/GitHub/political-campaign-networks/Data and Results/'
pdf_file <- '~/Coding/political campaign project/RStuff/RStuff/results/'
margin_file <- 'C:/Users/leahm/Documents/Coding/political campaign project/RStuff/RStuff/data/resultsFEC/'
year <- readline(prompt = 'please enter the year: ')

if (year == '2016') {
    ext <- '.xlsx'
} else {
    ext <- '.xls'
}

network_file <- 'C:/Users/leahm/Documents/Coding/political campaign project/matlabStuff/results/'
net_res <- read.csv(paste(network_file, year, '/stateNodes', year, '.csv', sep = "", collapse = NULL))
names(net_res) <- c('state', 'wdeg', 'deg', 'wpr', 'pr', 'weig', 'eig')

sen_res <- read_excel(paste(margin_file, '/federalelections', year, ext, sep = "", collapse = NULL), sheet = '2016 US Senate Results by State')
sen_res <- sen_res[c(2, 3, 5, 6, 9, 11, 16, 17)]
names(sen_res) <- c('abv', 'region', 'fecID', 'inc', 'canName', 'party', 'votes', 'percent')

sen_res$region <- tolower(sen_res$region)
sen_res <- sen_res %>%
    filter(votes != 'NA' & region != 'NA')

net_res$region <- NA
net_res$region = sen_res[match(net_res$state, sen_res$abv),]$region

s <- unique(sen_res$region)
a <- data.frame(region = s)
a$diff <- NA
a$party <- NA
a$inc <- NA
a$third <- NA

i = 1
for (val in s) {
    temp <- subset(sen_res, region == val)
    temp <- temp[-nrow(temp),]
    temp <- temp[order(-temp$votes),]

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

states <- map_data('state')
temp <- inner_join(states, a, by = 'region')
temp1 <- inner_join(states, net_res, by = 'region')

map_base <- ggplot(data = states, mapping = aes(x = long, y = lat, group = group)) +
    coord_fixed(1.3) +
    geom_polygon(color = 'black', fill = 'gray')

ditch_the_axes <- theme(
    axis.text = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank(),
    panel.border = element_blank(),
    panel.grid = element_blank(),
    axis.title = element_blank()
)

g <- map_base +
    geom_polygon(data = temp, aes(fill = diff), color = 'white') +
    geom_polygon(color = 'black', fill = NA) +
    theme_bw() +
    ditch_the_axes +
    ggtitle('Margin of Victory in the 2016 US Senatorial Elections') +
    scale_fill_gradient(trans = 'sqrt', low = '#206020', high = '#b3e6b3', '')


g1 <- map_base +
     geom_polygon(data = temp1, aes(fill = wpr), color = 'white') +
     geom_polygon(color = 'black', fill = NA) +
     theme_bw() +
     ditch_the_axes +
     ggtitle('Weighted PageRank of states in the 2016 Senatorial Elections') +
     scale_fill_gradient(trans = 'sqrt', low = '#b3e6b3', high = '#206020', 'wPR')

a <- grid.arrange(g, g1, nrow = 2)

pdf(paste(pdf_file, year, '/yearComp', '.pdf', sep = "", collapse = NULL))
plot(a)
dev.off()

pdf(paste(git_file, year, '/yearComp', '.pdf', sep = "", collapse = NULL))
plot(a)
dev.off()
