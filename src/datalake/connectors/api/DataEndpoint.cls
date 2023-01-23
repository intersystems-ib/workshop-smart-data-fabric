Class datalake.connectors.api.DataEndpoint Extends %CSP.REST
{

XData UrlMap
{
<Routes>
    <Route Url="/patient" Method="GET" Call="GetPatients"/>
    <Route Url="/patient/:id" Method="GET" Call="GetPatientById"/>
</Routes>
}

/// Common config
ClassMethod OnPreDispatch(pUrl As %String, pMethod As %String, ByRef pContinue As %Boolean) As %Status
{
    set %response.ContentType = "application/json"
    Quit $$$OK
}

ClassMethod GetPatients() As %Status
{
    set ret = $$$OK
    try {
        set sql="select Id, Identifier, FirstName, LastName from datalake_data.Patient ORDER BY Id"
		set statement = ##class(%SQL.Statement).%New()
		$$$ThrowOnError(statement.%Prepare(sql))
        
        set rs = statement.%Execute()
        set array = []
        while rs.%Next() {
            do array.%Push({
                    "Id": (rs.%Get("ID")),
                    "Identifier": (rs.%Get("Identifier")),
                    "FirstName": (rs.%Get("FirstName")),
                    "LastName": (rs.%Get("LastName"))
                })
        }
        set %response.Status = "200"
        write array.%ToJSON()

    } catch ex {
        set ret = ex.AsStatus()
    }
    quit ret
}

ClassMethod GetPatientById(id As %String) As %Status
{
    set ret = $$$OK
    try {
        set obj = ##class(datalake.data.Patient).%OpenId(id)
        set %response.Status = "200"
        do obj.%JSONExport()

    } catch ex {
        set ret = ex.AsStatus()
    }
    quit ret
}

}
