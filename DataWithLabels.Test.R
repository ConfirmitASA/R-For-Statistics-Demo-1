source("Login.R")
source("SingleQuestionDetails.R")
source("SurveyData.R")
source("DatabaseDesigner.R")

# LIST all columns you would like returned else set columns = "" to return all
columns = "<string>Rating</string>
           <string>Games</string>"

# You can optionally create a filter expression to restrict the number of records returned
filter = "NOT ISNULL(Games)"

# Get default survey data, according to columns and filter specified
surveyData <- confirmit.getData(columns, filter)

# Get label details of a SINGLE question type 
RatingDetails = confirmit.getQuestionLabels("Rating")

# Merge the resulting sets of data
dfWithLabels = merge(x = surveyData, y = RatingDetails, by.x = "Rating", 
                     by.y = "Rating_code", all.x = TRUE)

# Get Game list from Database Designer. This will create a table with the columns "Id" and "Game_Names"
gameNames <- databaseDesigner.getContent(gameNameTableId, "Game_Names", pageCount)

# Merge survey data with table above to get the database designer names of the games
dfWithLabels = merge(x = dfWithLabels, y = gameNames, by.x = "Games", 
                     by.y = "Id", all.x = TRUE)


dfWithLabels