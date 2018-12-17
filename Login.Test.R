library(htmltools)
source("Login.R")

key <- htmlEscape(confirmit.login(myusername, mypassword, environment))

!is.null(key)