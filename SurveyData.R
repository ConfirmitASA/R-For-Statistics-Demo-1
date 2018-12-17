confirmit.getData <- function(columns, filterExp){
  library("httr")
  library(XML)
  library(htmltools)
  
  key <- confirmit.login(myusername, mypassword, environment)

  url = paste("https://ws.",environment,".confirmit.com/confirmit/webservices/current/DataTransfer.asmx", sep="")  
  body = paste('<soap:Envelope ',soapSchemas, confirmitSchema85, '>
                     <soap:Header/>
                     <soap:Body>
                     <GetData>
                     <key>',key,'</key>
                     <dataTransferDef xsi:type="SurveyDataTransferDef">
                     <ProjectId>',surveyid, '</ProjectId>
                     <DbType>Production</DbType>
                     <VariableCollections>
                        <TransferVariableCollection>
                           <LoopId>responseid</LoopId>
                           <VariableNames>', columns,'</VariableNames>
                        </TransferVariableCollection>
                     </VariableCollections>
                     <FilterExpression>', filterExp, '</FilterExpression>
                     </dataTransferDef>
                     </GetData>
                     </soap:Body>
                     </soap:Envelope>'
                     , sep="")
  
  capture.output(
    #with_verbose(
      xmlResponse <- POST(url = url, 
                          body = body, content_type("text/xml"),
                          add_headers(SoapAction = url)
      )
    #)
  )

  surveyXml <- content(xmlResponse)
  doc <- xmlParse(surveyXml)
  df <- xmlToDataFrame(doc, nodes=getNodeSet(doc, "//diffgr:diffgram/NewDataSet/responseid",
                                               namespaces=c(diffgr="urn:schemas-microsoft-com:xml-diffgram-v1")))
  return(df)

}
