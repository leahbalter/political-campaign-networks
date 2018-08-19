## senGenProcV3.R
#  Version 3 - even better sorting primary versus general election transactions
#  Generates the committee-state network for general Senate elections
#  Input: filpath to trans and cn .rda files
#  Output: senGenTransXXXX.rda (saved to the above filepath)
#          elSenGenXXXXv3.txt  (saved to the above filepath)
#          elSenGenXXXXV3.txt  (saved to the github related folder path, under a new v3 folder)

# this version has a more robust way of checking if a transaction pertains to a general election or a primary election
filepath <- readline(prompt = "Enter the filepath to trans and cn .rda files")
year = gsub("\\D+","",filepath)

load(file = paste(filepath ,'\\cn', year, '.rda', sep = "", collapse = NULL))
load(file = paste(filepath ,'\\trans', year, '.rda', sep = "", collapse = NULL))

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
save(senGenTrans, file = paste(filepath, '\\senGenTrans', year, 'v3', '.rda', sep = "", collapse = NULL))
rm(list = c('pcc', 'pccState', 'can', 'canState'))

temp <- data.frame(senGenTrans$sendID, senGenTrans$amount, senGenTrans$state)
names(temp) = c("sendID", "amount", "state")

elSenGen <- aggregate(amount ~ sendID + state, temp, sum)
write.table(elSenGen, file = paste(filepath, '\\elSenGen', year, 'v3', '.txt', sep = "", collapse = NULL), row.names = FALSE, col.names = TRUE, quote = FALSE)

dir.create(file.path(paste('..\\Data and Results\\', year, sep = "", collapse = NULL), 'SenV3'))
write.table(elSenGen, file = paste('..\\Data and Results\\', year, '\\SenV3\\elSenGen', year, 'v3', '.txt', sep = "", collapse = NULL), row.names = FALSE, col.names = TRUE, quote = FALSE)

