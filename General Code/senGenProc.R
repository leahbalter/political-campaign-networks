transFileName <- readline(prompt = "Please enter the name of the trans .txt file")
year <- readline(prompt = "Please enter the year")

trans <- read.delim(transFileName, header = FALSE, sep = '|')
trans <- trans[, c(1, 4, 6, 7, 8, 9, 10, 11, 14, 15, 16)]
names(trans) <- c("sendID", "elType", "transCode", "recType", "recName", "recCity", "recState", "recZIP", "date", "amount", "recID")
trans <- subset(trans, transCode == "24K" | transCode == "24Z" | transCode == "24R" | transCode == "24E" | transCode == "24C" | transCode == "24H" | transCode == "24F")

save(trans, file = paste('rawTrans', year, '.rda', sep = "", collapse = NULL))

cn <- read.delim(paste('cn', year, '.txt', sep = "", collapse = NULL), header = FALSE, sep = '|', quote = "")
cn <- cn[, c(1, 2, 3, 4, 5, 6, 7, 8, 10, 13, 14, 15)]
names(cn) = c("canID", "canName", "party", "elYear", "canState", "office", "district", "incumbent", "pccID", "cityAdd", "stateAdd", "zipAdd")

save(cn, file = paste('cn', year, '.rda', sep = "", collapse = NULL))

sen <- subset(cn, office == "S")

state <- data.frame("state", stringsAsFactors = FALSE)
names(state) = c("state")

#ok, now to get just senatorial general election transactions
senGenTrans <- trans
senGenTrans <- subset(senGenTrans, recID != "")
senGenTrans <- subset(senGenTrans, amount > 0)
senGenTrans <- subset(senGenTrans, elType == "G")
senGenTrans <- subset(senGenTrans, recID %in% sen$canID | recID %in% sen$pccID)

# this makes sure we're using the correct state for each transaction, in case any of the mailing addresseses are in DC or something
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
save(senGenTrans, file = paste('senGenTrans', year, '.rda', sep = "", collapse = NULL))

temp <- data.frame(senGenTrans$sendID, senGenTrans$amount, senGenTrans$state)
names(temp) = c("sendID", "amount", "state")

elSenGen <- aggregate(amount ~ sendID + state, temp, sum)
write.table(elSenGen, file = paste('elSenGen',year,'.txt', sep = "", collapse = NULL), row.names = FALSE, col.names = TRUE, quote = FALSE)