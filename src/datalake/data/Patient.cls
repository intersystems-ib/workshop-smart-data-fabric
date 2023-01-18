Class datalake.data.Patient Extends %Persistent
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
<DataLocation>^datalake.data.PatientD</DataLocation>
<DefaultData>PatientDefaultData</DefaultData>
<IdLocation>^datalake.data.PatientD</IdLocation>
<IndexLocation>^datalake.data.PatientI</IndexLocation>
<StreamLocation>^datalake.data.PatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
