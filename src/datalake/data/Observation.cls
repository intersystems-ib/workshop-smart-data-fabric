Class datalake.data.Observation Extends (%Persistent, %JSON.Adaptor)
{

Property Id As %String(%JSONINCLUDE = "OUTPUTONLY") [ Calculated ];

Property Identifier As %String;

Property Code As %String;

Property Status As %String;

Property Units As %String;

Property Value As %String;

Property TimeStamp As %TimeStamp;

/// referenced Patient
Relationship Patient As Patient [ Cardinality = one, Inverse = Observations ];

Index PatientIdx On Patient;

Method IdGet() As %String
{
	quit ..%Id()
}

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
<Value>TimeStamp</Value>
</Value>
<Value name="8">
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
