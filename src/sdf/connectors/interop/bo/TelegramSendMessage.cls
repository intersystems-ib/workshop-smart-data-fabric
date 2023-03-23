Import sdf.connectors.interop.msg

Class sdf.connectors.interop.bo.TelegramSendMessage Extends EnsLib.REST.Operation
{

Parameter INVOCATION = "Queue";

/// Telegram Bot Credentials (Token)
Property TelegramCredentials As %String;

/// Telegram default Chat Id to use (if not specified in incoming message)
Property DefaultTelegramChatId As %String;

/// These are the production settings for this object
Parameter SETTINGS = "TelegramCredentials:Basic:credentialsSelector,DefaultTelegramChatId:Basic";

Method sendMessage(pRequest As TelegramMsgReq, Output pResponse As TelegramMsgRsp) As %Status
{
    set ret = $$$OK
    try {
        set pResponse = ##class(TelegramMsgRsp).%New()

        // retrieve credentials
        set sc = ##class(Ens.Config.Credentials).GetCredentialsObj(.credObj, $classname(), "Ens.Config.Credentials", ..TelegramCredentials)
        $$$ThrowOnError(sc)

        // chat id
        set chatId = ..DefaultTelegramChatId
        if pRequest.chatId '= "" {
            set chatId = pRequest.chatId
        }

        // request URL
        set url = ..Adapter.URL_"/bot"_credObj.Password_"/sendMessage?chat_id="_chatId_"&text="_$replace(pRequest.text, $char(10), "%0A")
        
        // send GET request
        set sc = ..Adapter.GetURL(url, .httpRsp, "", "")
        if $$$ISERR(sc),$isobject(httpRsp),$isobject(httpRsp.Data),httpRsp.Data.Size {
            return $$$ERROR($$$EnsErrGeneral,$$$StatusDisplayString(sc)_":"_httpRsp.Data.Read())
        }
        $$$ThrowOnError(sc)
        
        // handle response
        if $isobject(httpRsp) {
            set formatter = ##class(%JSON.Formatter).%New()
            do formatter.FormatToStream(httpRsp.Data, .formatted)
            set pResponse.raw = formatted

            // instantiate response in json dynamic object & grab some properties
            //set jsonRsp = {}.%FromJSON(httpRsp.Data.Read()) 
        }

   } catch ex {
       set ret = ex.AsStatus()
   }
   quit ret
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="sdf.connectors.interop.msg.TelegramMsgReq">
    <Method>sendMessage</Method>
  </MapItem>
</MapItems>
}

}
