year <- readline(prompt = 'Please enter the year: ')

load(file = paste('trans', year, '.rda', sep = "", collapse = NULL))
load(file = paste('cn', year, '.rda', sep = "", collapse = NULL))

prez <- subset(cn, office == 'P')
rm(list = 'cn')
prez <- subset(prez, elYear == year)

prezTrans <- trans
rm(list = 'trans')

prezTrans <- subset(prezTrans, recID != "")
prezTrans <- subset(prezTrans, amount > 0)
prezTrans <- subset(prezTrans, recID %in% prez$pccID | recID %in% prez$canID)

primCut <- readline(prompt = 'Please enter the last day of the primaries in the format of MMDDYYY:')
primCut <- as.Date(primCut, '%m%d%Y')

prezPrimTrans <- subset(prezTrans, elType == 'P' | elType == paste('P', year, sep ="", collapse = NULL))
prezGenTrans <- subset(prezTrans, elType == 'G' | elType == paste('G', year, sep = "", collapse = NULL))

t <- subset(prezTrans, elType != 'P' & elType != 'G' & elType != paste('P', year, sep = "", collapse = NULL) & elType != paste('G', year, sep = "", collapse = NULL))
tG <- subset(t, date > primCut)
tP <- subset(t, date <= primCut)

prezPrimTrans <- rbind(prezPrimTrans, tP)
prezGenTrans <- rbind(prezGenTrans, tG)
rm(list = c('t', 'tG', 'tP', 'primCut', 'prezTrans'))

t1 <- data.frame(prezPrimTrans$sendID, prezPrimTrans$recID, prezPrimTrans$amount)
t2 <- data.frame(prezGenTrans$sendID, prezGenTrans$recID, prezGenTrans$amount)
names(t1) = c('sendID', 'recID', 'amount')
names(t2) = c('sendID', 'recID', 'amount')

rm(list = c('prezPrimTrans', 'prezGenTrans'))

elPrezPrim <- aggregate(amount ~ sendID + recID, t1, sum)
elPrezGen <- aggregate(amount ~ sendID + recID, t2, sum)

write.table(elPrezPrim, file = paste('elPrezPrim', year, '.txt', sep = "", collapse = NULL), row.names = FALSE, col.names = TRUE, quote = FALSE)
write.table(elPrezGen, file = paste('elPrezGen', year, '.txt', sep = "", collapse = NULL), row.names = FALSE, col.names = TRUE, quote = FALSE)
rm(list = c('t1', 't2', 'elPrezPrim', 'elPrezGen'))