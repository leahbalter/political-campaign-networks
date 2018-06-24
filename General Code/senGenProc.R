year <- readline(prompt = "Please enter the year")

load(file = paste('cn', year, '.rda', sep = "", collapse = NULL))
load(file = paste('trans', year, '.rda', sep = "", collapse = NULL))

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
save(senGenTrans, paste('senGenTrans', year, '.rda', sep = "", collapse = NULL))

temp <- data.frame(senGenTrans$sendID, senGenTrans$amount, senGenTrans$state)
names(temp) = c("sendID", "amount", "state")

elSenGen <- aggregate(amount ~ sendID + state, temp, sum)
write.table(elSenGen, file = paste('elSenGen',year,'.txt', sep = "", collapse = NULL), row.names = FALSE, col.names = TRUE, quote = FALSE)