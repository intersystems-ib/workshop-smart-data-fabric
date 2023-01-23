Class datalake.data.Patient Extends (%Persistent, %JSON.Adaptor)
{

Property Id As %String(%JSONINCLUDE = "OUTPUTONLY") [ Calculated ];

Property Identifier As %String [ Required ];

Property FirstName As %String(MAXLEN = 250);

Property LastName As %String(MAXLEN = 500);

Property AdministrativeSex As %String(VALUELIST = ",M,F");

Property BirthDate As %Date;

Relationship Observations As Observation [ Cardinality = many, Inverse = Patient ];

Index IdentifierIdx On Identifier [ Unique ];

Method IdGet() As %String
{
	quit ..%Id()
}

ClassMethod GetByIdentifier(identifier As %String, Output obj As Patient) As %Status
{
	set ret = $$$OK
	try {
		set obj="", patientId=""

		set sql = "select %id from datalake_data.Patient where Identifier=?"
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
</Data>
<DataLocation>^datalake.data.PatientD</DataLocation>
<DefaultData>PatientDefaultData</DefaultData>
<IdLocation>^datalake.data.PatientD</IdLocation>
<IndexLocation>^datalake.data.PatientI</IndexLocation>
<StreamLocation>^datalake.data.PatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
