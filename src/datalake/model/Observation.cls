Class datalake.model.Observation Extends %Persistent
{

/// TODO: multiple identifiers?
Property Identifier As %String;

/// TODO: code, description
Property Code As %String;

/// TODO: restrict status
Property Status As %String;

Property Units As %String;

/// referenced Patient
Relationship Patient As Patient [ Cardinality = one, Inverse = Observations ];

Index PatientIdx On Patient;

/// TODO: value ranges?
Property Value As %String;

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
<Value>Patient</Value>
</Value>
<Value name="5">
<Value>Value</Value>
</Value>
<Value name="6">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^datalake.model.ObservationD</DataLocation>
<DefaultData>ObservationDefaultData</DefaultData>
<IdLocation>^datalake.model.ObservationD</IdLocation>
<IndexLocation>^datalake.model.ObservationI</IndexLocation>
<StreamLocation>^datalake.model.ObservationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
