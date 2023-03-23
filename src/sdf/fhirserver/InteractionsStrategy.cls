Class sdf.fhirserver.InteractionsStrategy Extends HS.FHIRServer.Storage.Json.InteractionsStrategy
{

Parameter StrategyKey As STRING = "sdf.fhirserver.Json";

Parameter InteractionsClass As STRING = "sdf.fhirserver.Interactions";

/// @API<br>
/// Return a CapabilityStatement metadata resource. The returned content is derived from
/// a strategy-specific means of formulating a CapabilityStatement. An example use of the
/// output might be to store the CapabilityStatement for a given Service.<br>
/// This method should not be confused with the Interactions class LoadMetadata() method,
/// which retrieves the stored CapabilityStatement for the current Service.
/// 
/// IMPORTANT! after changing this method you should call:
///   do ##class(HS.FHIRServer.ConsoleSetup).UpdateCapabilityStatement()
/// 
Method GetMetadataResource() As %DynamicObject
{
    // default capability statement
    set metadata = ##super()
   
    set ObservationRes = {
        "type": "Observation",
        "versioning": "no-version",
        "readHistory": false,
        "updateCreate": false,
        "conditionalCreate": false,
        "conditionalRead": "not-supported",
        "conditionalUpdate": false,
        "conditionalDelete": "not-supported",
        "interaction": [
            {
                "code": "read"
            }
        ]
    }

    set PatientRes = { 
        "type": "Patient",
        "versioning": "no-version",
        "readHistory": false,
        "updateCreate": false,
        "conditionalCreate": false,
        "conditionalRead": "not-supported",
        "conditionalUpdate": false,
        "conditionalDelete": "not-supported",
        "interaction": [
            {
                "code": "read"
            },
            {
                "code": "search-type"
            }
        ],
        "searchParam": [
            {
                "name": "gender",
                "type": "token"
            }
        ]
    }

    set metadata.rest."0".resource = [ (ObservationRes), (PatientRes) ]

    return metadata
}

}
