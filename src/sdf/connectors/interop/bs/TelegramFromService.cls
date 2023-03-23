Class sdf.connectors.interop.bs.TelegramFromService Extends Ens.BusinessService
{

Parameter SETTINGS = "GenerateSuperSessionID:Additional,AlertGracePeriod:Alerting";

/// Override this method to process incoming data. Do not call SendRequestSync/Async() from outside this method (e.g. in a SOAP Service or a CSP page).
Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject, ByRef pHint As %String) As %Status
{
	set ret = $$$OK
    try {
        set req = ##class(sdf.connectors.interop.msg.TelegramMsgReq).%New()
        set req.text = pInput
        $$$ThrowOnError(..SendRequestAsync("TelegramSendMessage", req))

    } catch ex {
        set ret = ex.AsStatus()
    }
    quit ret
}

}
