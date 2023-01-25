Class datalake.connectors.api.DataEndpoint Extends %CSP.REST
{

XData UrlMap
{
<Routes>
    <!-- patients -->
    <Route Url="/patient" Method="GET" Call="GetPatients"/>
    <Route Url="/patient/:id" Method="GET" Call="GetPatientById"/>
    <Route Url="/patient/:id/observations" Method="GET" Call="GetPatientObservations"/>
    <Route Url="/patient/:id/observations/xls" Method="GET" Call="GetPatientObservationsExcel"/>
    <Route Url="/patient/:id" Method="PUT" Call="UpdatePatient"/>
    <Route Url="/patient" Method="POST" Call="CreatePatient"/>
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

ClassMethod GetPatientObservations(patientId As %String) As %Status
{
    set ret = $$$OK
    try {
        set sql="select Id, Identifier, Code, Status, Units, Value, TimeStamp from datalake_data.Observation WHERE Patient=? ORDER BY Id"
		set statement = ##class(%SQL.Statement).%New()
		$$$ThrowOnError(statement.%Prepare(sql))
        
        set rs = statement.%Execute(patientId)
        set array = []
        while rs.%Next() {
            do array.%Push({
                    "Id": (rs.%Get("ID")),
                    "Identifier": (rs.%Get("Identifier")),
                    "Code": (rs.%Get("Code")),
                    "Status": (rs.%Get("Status")),
                    "Units": (rs.%Get("Units")),
                    "Value": (rs.%Get("Value")),
                    "TimeStamp": (rs.%Get("TimeStamp"))
                })
        }
        set %response.Status = "200"
        write array.%ToJSON()

    } catch ex {
        set ret = ex.AsStatus()
    }
    quit ret
}

ClassMethod GetPatientObservationsExcel(patientId As %String) As %Status
{
    set ret = $$$OK
    try {
        set sql="select Id, Identifier, Code, Status, Units, Value, TimeStamp from datalake_data.Observation WHERE Patient=? ORDER BY Id"
		set statement = ##class(%SQL.Statement).%New()
		$$$ThrowOnError(statement.%Prepare(sql))
        
        set rs = statement.%Execute(patientId)

        // export to xlsx
        set xlsFileName = "/app/"_$job_".xlsx"
        do ##class(datalake.Utils).ResultSetToXls(rs, xlsFileName)

        // return file as response
        set %response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        do %response.SetHeader("Content-Disposition","attachment;filename=""patient-"_patientId_"-observations.xlsx""")
        set stream=##class(%Stream.FileBinary).%New()
        set sc=stream.LinkToFile(xlsFileName)
        do stream.OutputToDevice()

        // delete temporary file
        do ##class(%File).Delete(xlsFileName)

    } catch ex {
        set ret = ex.AsStatus()
    }
    quit ret
}

ClassMethod UpdatePatient(id As %String) As %Status
{
    set ret = $$$OK
    try {
        set obj = ##class(datalake.data.Patient).%OpenId(id)
        set %response.Status = "200"
        set body = %request.Content
        $$$ThrowOnError(obj.%JSONImport(body))
        $$$ThrowOnError(obj.%Save())
        do obj.%JSONExport()

    } catch ex {
        set ret = ex.AsStatus()
    }
    quit ret
}

ClassMethod CreatePatient(id As %String) As %Status
{
    set ret = $$$OK
    try {
        set obj = ##class(datalake.data.Patient).%New()
        set %response.Status = "200"
        set body = %request.Content
        $$$ThrowOnError(obj.%JSONImport(body))
        $$$ThrowOnError(obj.%Save())
        do obj.%JSONExport()

    } catch ex {
        set ret = ex.AsStatus()
    }
    quit ret
}

}
