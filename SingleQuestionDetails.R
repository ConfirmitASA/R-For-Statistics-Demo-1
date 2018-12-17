confirmit.getQuestionLabels <- function(questionId){
  library("httr")
  library(XML)
  library(htmltools)
  
  key <- confirmit.login(myusername, mypassword, environment)

  url = paste("https://ws.",environment,".confirmit.com/confirmit/webservices/current/Authoring.asmx", sep="")
  action = "http://firmglobal.com/Confirmit/webservices/GetFormByName"
  body = paste('<soap:Envelope ',soapSchemas, confirmitSchema, '>
                <soap:Header/>
                <soap:Body>
                  <GetFormByName>
                    <key>',key,'</key>
                    <projectId>',surveyid, '</projectId>
                    <name>',questionId,'</name>
                    <readFilterSimple>
                    <IncludeAllLanguages>true</IncludeAllLanguages>
                    <ExpandAnswers>true</ExpandAnswers>
                    <ExpandLoopReferenceAnswers>true</ExpandLoopReferenceAnswers>
                    <ProjectSpecific>true</ProjectSpecific>
                    </readFilterSimple>
                    <schemaSource>Design</schemaSource>
                  </GetFormByName>
                </soap:Body>
                </soap:Envelope>'
               , sep="")
    
  capture.output(
  #  with_verbose(
      xmlResponse <- POST(url = url, 
                          body = body, content_type("text/xml"),
                          add_headers(SoapAction = action)
      )
   # )
  )
  surveyXml <- content(xmlResponse)

  doc = xmlInternalTreeParse(surveyXml)
  answers = getNodeSet(doc, "//env:Envelope/env:Body/c:GetFormByNameResponse/c:GetFormByNameResult/c:Root/c:Nodes/c:Single/c:Answers/c:Answer/c:Texts", namespaces = c("env" = "http://schemas.xmlsoap.org/soap/envelope/", "c" = "http://firmglobal.com/Confirmit/webservices/"))
  df = xmlToDataFrame(answers, stringsAsFactors = FALSE)
  codes = xpathSApply(doc, "//env:Envelope/env:Body/c:GetFormByNameResponse/c:GetFormByNameResult/c:Root/c:Nodes/c:Single/c:Answers/c:Answer/@Precode", namespaces = c("env" = "http://schemas.xmlsoap.org/soap/envelope/", "c" = "http://firmglobal.com/Confirmit/webservices/"))
  df$Code = codes

  colnames(df) = c(paste(questionId, "text", sep = "_"), paste(questionId, "code", sep = "_"))
  
  return(df)
}