year = readline(prompt = 'please enter a year')
load(file = paste('cn', year, '.rda', sep = "", collapse = NULL))
load(file = paste('senGenTrans', year, '.rda', sep = "", collapse = NULL))

sen <- subset(cn, office = "S")

recParty <- data.frame("recParty", stringsAsFactors = FALSE)
names(recParty) <- c("recParty")

for (i in 1:nrow(senGenTrans)) {
    if (senGenTrans[i, ]$recID %in% sen$pccID) {
        recParty[i,] <- c(as.character(sen[which(as.character(sen$pccID) == as.character(senGenTrans[i,]$recID)),]$party))
        
    }
    else
    recParty[i,] <- c(as.character(sen[which(as.character(sen$canID) == as.character(senGenTrans[i,]$recID)),]$party))
    
}

senGenTrans$recParty = recParty
temp <- data.frame(senGenTrans$sendID, senGenTrans$amount, recParty)
names(temp) <- c("sendID", "amount", "recParty")
temp <- aggregate(amount ~ sendID + recParty, temp, sum)

com <- as.data.frame(unique(temp$sendID))
com$recParty = NA
names(com) = c("com", "recParty")

for (i in 1:nrow(com)){ 
    t <- subset(temp, sendID == com[i, 1])
    com[i,2] = t[which.max(t$amount),]$recParty
}

save(senGenTrans, file = paste('senGenTrans', year, '.rda', sep = "", collapse = NULL))
save(com, file = paste('partySenGen', year, '.rda', sep = "", collapse = NULL))
write.table(com, file = paste('partySenGen', year, '.txt', sep = "", collapse = NULL), row.names = FALSE, col.names = TRUE, quote = FALSE)