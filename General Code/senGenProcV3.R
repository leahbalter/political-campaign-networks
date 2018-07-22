# this version has a more robust way of checking if a transaction pertains to a general election or a primary election
year <- readline(prompt = "Please enter the year")

load(file = paste('cn', year, '.rda', sep = "", collapse = NULL))
load(file = paste('trans', year, '.rda', sep = "", collapse = NULL))

sen <- subset(cn, office == "S")
sen <- subset(sen, elYear == year)
rm (list = 'cn')

senGenTrans <- trans
rm(list = 'trans')

senGenTrans <- subset(senGenTrans, recID %in% sen$canID | recID %in% sen$pccID)
senGenTrans <- subset(senGenTrans, recID != "")
senGenTrans <- subset(senGenTrans, amount > 0)


senGenTrans <- subset(senGenTrans, elType == 'G' | elType == paste('G', year, sep = "", collaspe = NULL))

pcc <- subset(senGenTrans, recID %in% sen$pccID)
pccState <- sen[match(pcc$recID, sen$pccID),]$canState
pcc$state = pccState
can <- subset(senGenTrans, recID %in% sen$canID)
canState <- sen[match(can$recID, sen$canID),]$canState
can$state = canState

senGenTrans <- rbind(pcc, can)
save(senGenTrans, file = paste('senGenTrans', year, 'v3', '.rda', sep = "", collapse = NULL))
rm(list = c('pcc', 'pccState', 'can', 'canState'))

temp <- data.frame(senGenTrans$sendID, senGenTrans$amount, senGenTrans$state)
names(temp) = c("sendID", "amount", "state")

elSenGen <- aggregate(amount ~ sendID + state, temp, sum)
write.table(elSenGen, file = paste('elSenGen', year, 'v3', '.txt', sep = "", collapse = NULL), row.names = FALSE, col.names = TRUE, quote = FALSE)

write.table(elSenGen, file = paste('C:/Users/leahm/Documents/GitHub/political-campaign-networks/Data and Results', '/', year, '/', 'SenV3', '/', 'elSenGen', year, 'v3', '.txt', sep = "", collapse = NULL),
            row.names = FALSE, col.names = TRUE, quote = FALSE)