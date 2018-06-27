transFileName <- readline(prompt = "Please enter the name of the trans .txt file")
year <- readline(prompt = "Please enter the year")

trans <- read.delim(transFileName, header = FALSE, sep = '|')
trans <- trans[, c(1, 4, 6, 7, 8, 9, 10, 11, 14, 15, 16)]
names(trans) <- c("sendID", "elType", "transCode", "recType", "recName", "recCity", "recState", "recZIP", "date", "amount", "recID")
trans <- subset(trans, transCode == "24K" | transCode == "24Z" | transCode == "24R" | transCode == "24E" | transCode == "24C" | transCode == "24H" | transCode == "24F")

date <- as.Date(sprintf('%08d', trans$date), '%m%d%Y')
trans$date <- date

save(trans, file = paste('trans', year, '.rda', sep = "", collapse = NULL))

cn <- read.delim(paste('cn', year, '.txt', sep = "", collapse = NULL), header = FALSE, sep = '|', quote = "")
cn <- cn[, c(1, 2, 3, 4, 5, 6, 7, 8, 10, 13, 14, 15)]
names(cn) = c("canID", "canName", "party", "elYear", "canState", "office", "district", "incumbent", "pccID", "cityAdd", "stateAdd", "zipAdd")

save(cn, file = paste('cn', year, '.rda', sep = "", collapse = NULL))

com <- read.delim(paste('cm', year, '.txt', sep = "", collapse = NULL), header = FALSE, sep = '|', quote = "")
com <- com[, c(1, 2, 3, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15)]
names(com) = c("comID", "comName", "treasName", "city", "state", "zip", "comDes", "comType", "comParty", "filingFreq", "interestGroup", "connOrg", "canID")
save(com, file = paste('cm', year, '.rda', sep = "", collapse = NULL))