databaseDesigner.getContent <- function(tableId, labelName, pagesize = 500){
  library("httr")
  library(XML)
  library(htmltools)
  
  key <- confirmit.login(myusername, mypassword, environment)
  
  url = paste("https://ws.",environment,".confirmit.com/confirmit/webservices/current/databasedesigner.asmx", sep="")  
  body = paste('<soap:Envelope ',soapSchemas, confirmitSchema, '>
               <soap:Body>
                 <GetContent>
                   <key>',key,'</key>
                   <tableId>',tableId, '</tableId>
                   <pageSize>',pagesize, '</pageSize>
                   <direction>Next</direction>
                   <getRunTimeContent>true</getRunTimeContent>
                 </GetContent>
                 </soap:Body>
               </soap:Envelope>'
               , sep="")
  
  capture.output(
  #  with_verbose(
    xmlResponse <- POST(url = url, 
                        body = body, content_type("text/xml"),
                        add_headers(SoapAction = url)
    )
 #   )
  )
  
  xmlContent <- content(xmlResponse)
  doc <- xmlInternalTreeParse(xmlContent)

  records = getNodeSet(doc, "//env:Envelope/env:Body/c:GetContentResponse/c:GetContentResult/c:Rows/c:DatabaseContentRow", namespaces = c("env" = "http://schemas.xmlsoap.org/soap/envelope/", "c" = "http://firmglobal.com/Confirmit/webservices/"))
  df = xmlToDataFrame(records, stringsAsFactors = FALSE)

  # Return only the required columns
  df = df[, c("Id", "LanguageTexts")]
  
  colnames(df)[colnames(df)=="LanguageTexts"] <- labelName
  
  return(df)
  
}
