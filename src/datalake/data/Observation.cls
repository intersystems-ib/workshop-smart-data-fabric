Class datalake.data.Observation Extends (%Persistent, %JSON.Adaptor, datalake.fhirserver.FHIRFacade)
{

Property Id As %String(%JSONINCLUDE = "OUTPUTONLY") [ Calculated ];

Property Identifier As %String;

Property Code As %String;

Property Status As %String;

Property Units As %String;

Property ValueNM As %Numeric;

Property ValueST As %String;

Property TimeStamp As %TimeStamp;

/// referenced Patient
Relationship Patient As Patient(%JSONREFERENCE = "ID") [ Cardinality = one, Inverse = Observations ];

Index PatientIdx On Patient;

Method IdGet() As %String
{
	quit ..%Id()
}

/// Transform FHIR Facade to FHIR Resource
Method FacadeToResource() As %DynamicObject
{
	// do not include RiskLevel observations
	if ..Code="RiskLevel" {
		$$$ThrowFHIR($$$HSFHIRErrResourceNotFound, pResourceType, pResourceId, $$$OutcomeNotFound)
	}

	set resource = {
            "resourceType": "Observation",
			"id": (..Id),
            "status": "final",
            "code": {
                "coding": [
                ]
            },
            "subject": {
                "reference": ("Patient/"_..Patient.Id)
            },
            "effectiveDateTime": ($tr(..TimeStamp, " ", "T")),
            "valueQuantity": {
            }
    }

	if ..Code="BodyTemp" {
		set resource.code.coding."0" = { "system": "http://loinc.org", "code": "8310-5", "display": "Body temperature" }
		set resource.valueQuantity.unit = "C"
		set resource.valueQuantity.system = "http://unitsofmeasure.org"
		set resource.valueQuantity.code = "Cel"
		do resource.valueQuantity.%Set("value", ..ValueNM, "number")
	}
	elseif ..Code="HeartRate" {
		set resource.code.coding."0" = { "system": "http://loinc.org", "code": "8867-4", "display": "Heart rate" }
		set resource.valueQuantity.unit = "beats/minute"
		set resource.valueQuantity.system = "http://unitsofmeasure.org"
		set resource.valueQuantity.code = "/min"
		do resource.valueQuantity.%Set("value", ..ValueNM, "number")
	}
	elseif ..Code="DiastolicBP" {
		set resource.code.coding."0" = { "system": "http://loinc.org", "code": "8462-4", "display": "Diastolic blood pressure" }
		set resource.valueQuantity.unit = "mmHg"
		set resource.valueQuantity.system = "http://unitsofmeasure.org"
		set resource.valueQuantity.code = "mm[Hg]"
		do resource.valueQuantity.%Set("value", ..ValueNM, "number")
	}
	elseif ..Code="SystolicBP" {
		set resource.code.coding."0" = { "system": "http://loinc.org", "code": "8480-6", "display": "Systolic blood pressure" }
		set resource.valueQuantity.unit = "mmHg"
		set resource.valueQuantity.system = "http://unitsofmeasure.org"
		set resource.valueQuantity.code = "mm[Hg]"
		do resource.valueQuantity.%Set("value", ..ValueNM, "number")
	}
	elseif ..Code="BloodGlucose" {
		set resource.code.coding."0" = { "system": "http://loinc.org", "code": "15074-8", "display": "Glucose [Moles/volume] in Blood" }
		set resource.valueQuantity.unit = "mmol/l"
		set resource.valueQuantity.system = "http://unitsofmeasure.org"
		set resource.valueQuantity.code = "mmol/l"
		do resource.valueQuantity.%Set("value", ..ValueNM, "number")
	}

	return resource
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
<Value>ValueNM</Value>
</Value>
<Value name="7">
<Value>ValueST</Value>
</Value>
<Value name="8">
<Value>TimeStamp</Value>
</Value>
<Value name="9">
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
