# General Lookup Function
# Aviva Prins
# 10/3/2018
# Looks up a committee or candidate's information by ID
# @param IDs vector of IDs (strings) to look up
# @param year the associated year
# @param info the requested info, a vector of strings. Can be specific table values such as 'comName' or general terms such as 'name'. See below
# @param filepath the filepath to the dataset (without year subdirectory)
# @output data frame of the IDs and requested information. N/A if not applicable
# Warning: this function fails quietly. If it can't find the information, the data frame will have N/A

# Info List
# Note: if you know the column name, it is a valid input even if it is not listed below.
# simplified keyword: committee equivalent, candidate equivalent
# ^indicates current default
# ^name:         comName, canName
# organization:  connOrg                   only applicable for committees
# office:                                  only applicable for candidates (H/P/S)
# ^party:        comParty, party           may not be provided by the committee
# city:          city, cityAdd             the mailing address of the candidate, if given
# ^state:        state, canState           the state of the election*
# ^zip:          zip, zipAdd               from the mailing address
# district:                                only applicable for candidates
# designation:   comDes                    only applicable for committees
# type:          comType                   only applicable for committees
# interest:      interestGroup             only applicable for committees
# elYear:                                  only applicable for candidates
# incumbent:                               only applicable for candidates
# ^associatedID: canID, pccID              the ID of the associated account, if provided
# *the mailing address state of a candidate can be requested directly with 'stateAdd'
lookup <- function(IDs, year, info = c('name', 'party', 'state', 'zip', 'associatedID'), filepath = "D://Aviva//Documents//Political Donations Dataset//") {

    # 1. Load the dataframes
    # TODO: check if the IDs are committees or candidates rather than load both datasets by default
    load(file = paste(filepath, year, '\\cm', year, '.rda', sep = "", collapse = NULL))
    com_info <- info
    com_info[com_info == 'name'] <- 'comName'
    com_info[com_info == 'organization'] <- 'connOrg'
    com_info[com_info == 'party'] <- 'comParty'
    com_info[com_info == 'designation'] <- 'comDes'
    com_info[com_info == 'type'] <- 'comType'
    com_info[com_info == 'interestGroup'] <- 'interest'
    com_info[com_info == 'associatedID'] <- 'canID'
    load(file = paste(filepath, year, '\\cn', year, '.rda', sep = "", collapse = NULL))
    can_info <- info
    can_info[can_info == 'name'] <- 'canName'
    can_info[can_info == 'city'] <- 'cityAdd'
    can_info[can_info == 'state'] <- 'canState'
    can_info[can_info == 'zip'] <- 'zipAdd'
    can_info[can_info == 'associatedID'] <- 'pccID'

    # Empty output dataframe that will be filled in
    output <- data.frame(matrix(ncol = length(info) + 1, nrow = length(IDs)), stringsAsFactors = FALSE)
    colnames(output) <- c('ID', info)
    output$ID <- IDs
    # print(IDs)

    # 2. Go through each ID and retrieve the info
    for (ID in IDs) {
        # TODO: make more efficient by performing operations on the data frame
        if (startsWith(ID, 'C')) {
            for (entry in com_info) {
                loc <- match(entry, com_info) + 1
                output[, loc][output$ID == ID] <- toString(com[, entry][com$comID == ID])
                # print(com[,entry][com$comID==ID])
                # print(typeof(com[,entry][com$comID==ID]))
            }
        }
        else {
            for (entry in can_info) {
                loc <- match(entry, can_info) + 1
                output[, loc][output$ID == ID] <- toString(cn[, entry][cn$canID == ID])
            }
        }
    }
    # 3. return the data frame
    return(output)
}
