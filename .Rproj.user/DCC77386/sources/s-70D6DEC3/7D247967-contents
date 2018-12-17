source("COnfiguration.R")

confirmit.login <- function(username = myusername, password = mypassword, confirmitEnvironment="euro"){
  library("httr")
  library(XML)
  library(htmltools)
  
  url = paste("https://ws.",confirmitEnvironment,".confirmit.com/confirmit/webservices/current/logon.asmx", sep="")  
  body = paste('<?xml version="1.0" encoding="utf-8"?>
               <soap:Envelope ', soapSchemas,' >
               <soap:Body>
               <LogOnUser ', confirmitSchema, '>
               <username>',username,'</username>
               <password>',password,'</password>
               </LogOnUser>
               </soap:Body>
               </soap:Envelope>'
               , sep="")
  
  capture.output(
  #with_verbose(
  xmlResponse <- POST(url = url, 
                      body = body, content_type("text/xml"),
                      add_headers(SoapAction = url)
                      )
 # )
  )
  res <- content(xmlResponse)
  
  loginresult = xmlInternalTreeParse(res)
  key = xpathApply(loginresult, "//soap:Envelope/soap:Body", xmlValue)[[1]]
  
  return(htmlEscape(key))
}
