Class datalake.model.Patient Extends (%Persistent, %JSON.Adaptor)
{

/// TODO: PK on Identifier
Property Identifier As %String;

Property FirstName As %String(MAXLEN = 250);

Property LastName As %String(MAXLEN = 500);

Property Sex As %String;

Property BirthDate As %Date;

Relationship Observations As Observation [ Cardinality = many, Inverse = Patient ];

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
<Value>Sex</Value>
</Value>
<Value name="6">
<Value>BirthDate</Value>
</Value>
</Data>
<DataLocation>^datalake.model.PatientD</DataLocation>
<DefaultData>PatientDefaultData</DefaultData>
<IdLocation>^datalake.model.PatientD</IdLocation>
<IndexLocation>^datalake.model.PatientI</IndexLocation>
<StreamLocation>^datalake.model.PatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
