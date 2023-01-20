Class datalake.data.Observation Extends %Persistent
{

Property Identifier As %String;

Property Code As %String;

Property Status As %String;

Property Units As %String;

Property Value As %String;

/// referenced Patient
Relationship Patient As Patient [ Cardinality = one, Inverse = Observations ];

ClassMethod GetByIdentifier(identifier As %String, Output obj As Observation) As %Status
{
	set ret = $$$OK
	try {
		set obj="", objId=""

		set sql = "select %id from datalake_data.Observation where Identifier=?"
		set statement = ##class(%SQL.Statement).%New()
		$$$ThrowOnError(statement.%Prepare(sql))

		set result = statement.%Execute(identifier)
		if result.%Next() {
			set objId = result.%GetData(1)
			set obj = ..%OpenId(objId)
		}
		
	} catch ex {
		set ret = ex.AsStatus()
	}
	quit ret
}

Index PatientIdx On Patient;

Storage Default
{
<Data name="ObservationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Identifier</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Status</Value>
</Value>
<Value name="5">
<Value>Units</Value>
</Value>
<Value name="6">
<Value>Value</Value>
</Value>
<Value name="7">
<Value>Patient</Value>
</Value>
</Data>
<DataLocation>^datalake.data.ObservationD</DataLocation>
<DefaultData>ObservationDefaultData</DefaultData>
<IdLocation>^datalake.data.ObservationD</IdLocation>
<IndexLocation>^datalake.data.ObservationI</IndexLocation>
<StreamLocation>^datalake.data.ObservationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
