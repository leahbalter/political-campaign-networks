## initProcessing.R
#  Processes trans, cn, and cm files to only include the desired transactions
#  Current transaction codes filtered: 24K, 24Z, 24R, 24E, 24C, 24H, 24F, 24A, 24N
#  Input: filepath to trans, cn, and cm .txt files
#  Output: trans, cn, and cm .rda files (saved to same filepath as input)

# Read the location of the data
# Assumes the filepath contains the year
# An easy way to copy the filepath: 
# go to the folder, right click on the filepath bar
# copy the address
filepath <- readline(prompt = "Enter the filepath to trans, cn, and cm .txt files")
year = gsub("\\D+","",filepath)

filepath_trans <- paste(filepath, '\\trans', year, '.txt', sep='', collapse = NULL)
filepath_cn <- paste(filepath, '\\cn', year, '.txt', sep='', collapse = NULL)
filepath_cm <- paste(filepath, '\\cm', year, '.txt', sep='', collapse = NULL)

rawTrans <- read.delim(filepath_trans, header = FALSE, sep = '|')
save(rawTrans, file = paste(filepath, '\\rawTrans', year, '.rda', sep = "", collapse = NULL))
trans <- rawTrans
rm(list = 'rawTrans')

# Filter the transactions
trans <- trans[, c(1, 4, 6, 7, 8, 9, 10, 11, 14, 15, 16)]
names(trans) <- c("sendID", "elType", "transCode", "recType", "recName", "recCity", "recState", "recZIP", "date", "amount", "recID")
trans <- subset(trans, transCode == '24A' | transCode == '24N' | transCode == "24K" | transCode == "24Z" | transCode == "24R" | transCode == "24E" | transCode == "24C" | transCode == "24H" | transCode == "24F")

date <- as.Date(sprintf('%08d', trans$date), '%m%d%Y')
trans$date <- date

save(trans, file = paste(filepath ,'\\trans', year, '.rda', sep = "", collapse = NULL))

# Filter the candidates
cn <- read.delim(filepath_cn, header = FALSE, sep = '|', quote = "")
cn <- cn[, c(1, 2, 3, 4, 5, 6, 7, 8, 10, 13, 14, 15)]
names(cn) = c("canID", "canName", "party", "elYear", "canState", "office", "district", "incumbent", "pccID", "cityAdd", "stateAdd", "zipAdd")

save(cn, file = paste(filepath ,'\\cn', year, '.rda', sep = "", collapse = NULL))

# Filter the committees
com <- read.delim(filepath_cm, header = FALSE, sep = '|', quote = "")
com <- com[, c(1, 2, 3, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15)]
names(com) = c("comID", "comName", "treasName", "city", "state", "zip", "comDes", "comType", "comParty", "filingFreq", "interestGroup", "connOrg", "canID")
save(com, file = paste(filepath ,'\\cm', year, '.rda', sep = "", collapse = NULL))
