Class datalake.connectors.api.DataEndpoint Extends %CSP.REST
{

Parameter HandleCorsRequest As %Integer = 1;

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

    <!-- summary -->
    <Route Url="/summary" Method="GET" Call="GetSummary"/>
</Routes>
}

/// Common config
ClassMethod OnPreDispatch(pUrl As %String, pMethod As %String, ByRef pContinue As %Boolean) As %Status
{
    set %response.ContentType = "application/json"
    Quit $$$OK
}

/// This is the CORS request handler. User should override this method.
ClassMethod OnHandleCorsRequest(url As %String) As %Status
{
	set url = %request.GetCgiEnv("HTTP_REFERER")
    set origin = $p(url,"/",1,3) // origin = "http(s)://origin.com:port"

    // here you can check specific origins
    // otherway, it will allow all origins (useful while developing only)

	do %response.SetHeader("Access-Control-Allow-Credentials","true")
	do %response.SetHeader("Access-Control-Allow-Methods","GET,POST,PUT,DELETE,OPTIONS")
	do %response.SetHeader("Access-Control-Allow-Origin",origin)
	do %response.SetHeader("Access-Control-Allow-Headers","Access-Control-Allow-Origin, Origin, X-Requested-With, Content-Type, Accept, Authorization, Cache-Control")
	quit $$$OK
}

/// Return patients and implement a simple pagination
/// See: https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GSQL_dynsql#GSQL_dynsql_stmtresults_page
ClassMethod GetPatients() As %Status
{
    set ret = $$$OK
    try {
        // retrieve page and pageSize
        set page = $get(%request.Data("page",1))
        set pageSize = $get(%request.Data("pageSize",1))

        // default values
        if page="" set page=1
        if pageSize="" set pageSize=100

        // calculate %vid window (pagination)
        set vidStart = ((page-1)*pageSize)+1
        set vidEnd = (page*pageSize)
        
        set sql = 
            "SELECT %VID AS RSRow,* FROM "_
            "(select Id, Identifier, FirstName, LastName from datalake_data.Patient) "_
            "WHERE %VID BETWEEN ? AND ?"
		set statement = ##class(%SQL.Statement).%New()
		$$$ThrowOnError(statement.%Prepare(sql))
        set rs = statement.%Execute(vidStart, vidEnd)

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
        set sql="select Id, Identifier, Code, Status, Units, ValueNM, ValueST, TimeStamp from datalake_data.Observation WHERE Patient=? ORDER BY Id"
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
                    "ValueNM": (rs.%Get("ValueNM")),
                    "ValueST": (rs.%Get("ValueST")),
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
        set sql="select Id, Identifier, Code, Status, Units, ValueNM, ValueST, TimeStamp from datalake_data.Observation WHERE Patient=? ORDER BY Id"
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

ClassMethod GetSummary() As %Status
{
    set ret = $$$OK
    try {
        set totalPatients = 0, totalObservations = 0

        set sql="select count(*) as total from datalake_data.Patient"
		set statement = ##class(%SQL.Statement).%New()
		$$$ThrowOnError(statement.%Prepare(sql))
        set rs = statement.%Execute()
        if rs.%Next() {
            set totalPatients = rs.%Get("total")
        }

        set sql="select count(*) as total from datalake_data.Observation"
		set statement = ##class(%SQL.Statement).%New()
		$$$ThrowOnError(statement.%Prepare(sql))
        set rs = statement.%Execute()
        if rs.%Next() {
            set totalObservations = rs.%Get("total")
        }

        set msg = "Your datalake summary: Total Patients = "_totalPatients_", Total Observations = "_totalObservations
        set %response.Status = "200"
        write { "msg": (msg) }.%ToJSON()

        // invoke interoperability context, instatiate your business service
        $$$ThrowOnError(##class(Ens.Director).CreateBusinessService("TelegramFromService",.service))
        $$$ThrowOnError(service.OnProcessInput(msg))

    } catch ex {
        set ret = ex.AsStatus()
    }
    quit ret
}

}
