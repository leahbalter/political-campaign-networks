# this version has a more robust way of checking if a transaction pertains to a general election or a primary election

year <- readline(prompt = "Please enter the year")

load(file = paste('cn', year, '.rda', sep = "", collapse = NULL))
load(file = paste('trans', year, '.rda', sep = "", collapse = NULL))

sen <- subset(cn, office == "S")
sen <- subset(sen, elYear == year)
rm (list = 'cn')

senGenTrans <- trans
rm(list = 'trans')

date <- as.Date(sprintf('%08d', senGenTrans$date), '%m%d%Y')
senGenTrans$date <- date
rm(list = 'date')

senGenTrans <- subset(senGenTrans, recID %in% sen$canID | recID %in% sen$pccID)
senGenTrans <- subset(senGenTrans, recID != "")
senGenTrans <- subset(senGenTrans, amount > 0)

primDate <- readline(prompt = "Please enter the primary cutoff date in the format MMDDYYYY:")
primDate <- as.Date(primDate, '%m%d%Y')

t <- subset(senGenTrans, elType == 'G' | elType == paste('G', year, sep = "", collaspe = NULL))
t1 <- subset(senGenTrans, elType != 'G' & elType != 'P' & elType != paste('G', year, sep = "", collapse = NULL) & elType != paste('P', year, sep = "", collapse = NULL))
t1 <- subset(t1, date > primDate)
senGenTrans <- rbind(t, t1)
rm(list = c('t', 't1', 'primDate'))

state <- data.frame("state", stringsAsFactors = FALSE)
names(state) = c("state")

# this bit is really slow so i'm going to continue trying to figure out how to do this better
# for each recipient committee in the senGenTrans dataframe
# i'm going back to the cn dataframe to pull the state associated with that committee
# and creating a new dataframe with all those states
# which gets attached to the senGenTrans dataframe as a new column
# there's gotta be a better way to do this though
# the rest of this script works; this works too but is super slow and clunky since it handles it line-by-line
# so i'm going to try to figure it out
for (i in 1:nrow(senGenTrans)) {
    if (senGenTrans[i, ]$recID %in% sen$pccID) {
        state[i,] <- c(as.character(sen[which(as.character(sen$pccID) == as.character(senGenTrans[i,]$recID)),]$canState))

    }
    else {
        state[i,] <- c(as.character(sen[which(as.character(sen$canID) == as.character(senGenTrans[i,]$recID)),]$canState))

    }

}

senGenTrans$state = NA
senGenTrans$state = state
rm(list = 'state')
save(senGenTrans, paste('senGenTrans', year, 'v2', '.rda', sep = "", collapse = NULL))

temp <- data.frame(senGenTrans$sendID, senGenTrans$amount, senGenTrans$state)
names(temp) = c("sendID", "amount", "state")

elSenGen <- aggregate(amount ~ sendID + state, temp, sum)
write.table(elSenGen, file = paste('elSenGen', year, 'v2', '.txt', sep = "", collapse = NULL), row.names = FALSE, col.names = TRUE, quote = FALSE)
rm(list = c('temp', 'elSenGen'))