Class sdf.data.Patient Extends (%Persistent, %JSON.Adaptor, sdf.fhirserver.FHIRFacade)
{

Property Id As %String(%JSONINCLUDE = "OUTPUTONLY") [ Calculated ];

Property Identifier As %String [ Required ];

Property FirstName As %String(MAXLEN = 250);

Property LastName As %String(MAXLEN = 500);

Property AdministrativeSex As %String(VALUELIST = ",M,F");

Property BirthDate As %Date;

/// Age. Calculated column
Property Age As %Integer [ SqlComputeCode = { set {Age} = ..CalcAge({BirthDate})}, SqlComputed, SqlComputeOnChange = %%UPDATE ];

Relationship Observations As Observation(%JSONREFERENCE = "ID") [ Cardinality = many, Inverse = Patient ];

Index IdentifierIdx On Identifier [ Unique ];

Method IdGet() As %String
{
	quit ..%Id()
}

ClassMethod CalcAge(dob As %Date) As %Integer
{
	set age = ""
	if dob '= "" {
		set age = $number(($horolog-dob)/365,0) 
	}
	return age
}

ClassMethod GetByIdentifier(identifier As %String, Output obj As Patient) As %Status
{
	set ret = $$$OK
	try {
		set obj="", patientId=""

		set sql = "select %id from sdf_data.Patient where Identifier=?"
		set statement = ##class(%SQL.Statement).%New()
		$$$ThrowOnError(statement.%Prepare(sql))

		set result = statement.%Execute(identifier)
		if result.%Next() {
			set patientId = result.%GetData(1)
			set obj = ..%OpenId(patientId)
		}
		
	} catch ex {
		set ret = ex.AsStatus()
	}
	quit ret
}

/// Transform FHIR Facade to FHIR Resource
Method FacadeToResource() As %DynamicObject
{
	set resource = {
		"resourceType": "Patient",
		"id": (..Id),
		"identifier": [
			{
				"use": "usual",
				"value": (..Identifier),
				"assigner": {
        			"display": "SDF"
      			}
			}
		],
		"active": true,
		"name": [
			{
				"use": "usual",
				"family": (..LastName),
				"given": [
					(..FirstName)
				]
			}
		],
		"gender": ($case(..AdministrativeSex, "M":"male", "F": "female", "":"unknown"))
	}
	if ..BirthDate'="" {
		set resource.birthDate = $zdate(..BirthDate, 3)
	}
	return resource
}

/// FHIR Facade Search implementation
ClassMethod FacadeSearch(pResourceType As %String, pCompartment As %String, pCompartmentId As %String, pParameters As HS.FHIRServer.API.Data.QueryParameters = "", ByRef pSortKeys = "") As HS.FHIRServer.Util.SearchResult
{
	#dim tResultSet as HS.FHIRServer.Util.SearchResult = ##class(HS.FHIRServer.Util.SearchResult).Create()

    set sqlWhere = ""
    set sqlWhereAnd = ""

	// retrieve parameters
    set gender = pParameters.GetOneParameterValue("gender", .genderMod)
    
	// process parameters
    set args = 0
    if gender'="" {
        set args($i(args)) = $case(gender, "male":"M", "female":"F", :"")
        set sqlWhereAnd = sqlWhereAnd_$lb("AdministrativeSex=?")
    }

	// build sql
	set sql = "select Id from sdf_data.Patient"

	if $listlength(sqlWhereAnd)>0 {
		set sqlWhere = $listtostring(sqlWhereAnd, " AND ")
	}
	if sqlWhere'="" {
		set sql = sql_" WHERE "_sqlWhere
	}

	$$$FSLogSQL(sql)

	// execute sql
	set statement = ##class(%SQL.Statement).%New()
	$$$ThrowOnError(statement.%Prepare(sql))
	set rs = statement.%Execute(args...)

	// process resultset
	while rs.%Next() {
		set id = rs.%Get("ID")
		set obj = ##class(sdf.data.Patient).%OpenId(id)
		set resource = obj.FacadeToResource()
		do tResultSet.AddRow("", resource.resourceType,  "", "", "match",, resource.%ToJSON())
	}
    
    do tResultSet.%SetIterator(0)
    return tResultSet
}

Storage Default
{
<Data name="PatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Identifier</Value>
</Value>
<Value name="3">
<Value>FirstName</Value>
</Value>
<Value name="4">
<Value>LastName</Value>
</Value>
<Value name="5">
<Value>AdministrativeSex</Value>
</Value>
<Value name="6">
<Value>BirthDate</Value>
</Value>
<Value name="7">
<Value>Age</Value>
</Value>
</Data>
<DataLocation>^sdf.data.PatientD</DataLocation>
<DefaultData>PatientDefaultData</DefaultData>
<IdLocation>^sdf.data.PatientD</IdLocation>
<IndexLocation>^sdf.data.PatientI</IndexLocation>
<StreamLocation>^sdf.data.PatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
