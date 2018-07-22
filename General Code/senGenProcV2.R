## senGenProcV2.R
#  Version 2
#  Generates the committee-state network for general Senate elections
#  Input: trans and cn .rda files and year
#  Output: senGenTransXXXX.rda and elSenGenXXXX.txt

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

#primDate <- readline(prompt = "Please enter the primary cutoff date in the format MMDDYYYY:")
#primDate <- as.Date(primDate, '%m%d%Y')

senGenTrans <- subset(senGenTrans, elType == 'G' | elType == paste('G', year, sep = "", collaspe = NULL))
#t1 <- subset(senGenTrans, elType != 'G' & elType != 'P' & elType != paste('G', year, sep = "", collapse = NULL) & elType != paste('P', year, sep = "", collapse = NULL))
#t1 <- subset(t1, date > primDate)
#senGenTrans <- rbind(t, t1)
#rm(list = c('t', 't1', 'primDate'))

pcc <- subset(senGenTrans, recID %in% sen$pccID)
pccState <- sen[match(pcc$recID, sen$pccID),]$canState
pcc$state = pccState
can <- subset(senGenTrans, recID %in% sen$canID)
canState <- sen[match(can$recID, sen$canID),]$canState
can$state = canState

senGenTrans <- rbind(pcc, can)
save(senGenTrans, file = paste('senGenTrans', year, 'v2', '.rda', sep = "", collapse = NULL))
rm(list = c('pcc', 'pccState', 'can', 'canState'))

temp <- data.frame(senGenTrans$sendID, senGenTrans$amount, senGenTrans$state)
names(temp) = c("sendID", "amount", "state")

elSenGen <- aggregate(amount ~ sendID + state, temp, sum)
write.table(elSenGen, file = paste('elSenGen', year, 'v2', '.txt', sep = "", collapse = NULL), row.names = FALSE, col.names = TRUE, quote = FALSE)
rm(list = c('temp', 'elSenGen', 'senGenTrans'))