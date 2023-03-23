Include HS.FHIRServer

Class sdf.fhirserver.FHIRFacade
{

/// Return Facade Class that implements a FHIR Resource Type
ClassMethod FacadeClass(pResourceType As %String) As %String
{
    return $case(pResourceType, 
        "Patient": "sdf.data.Patient",
        "Observation": "sdf.data.Observation" 
    )
}

/// Transform FHIR Facade to FHIR Resource
Method FacadeToResource() As %DynamicObject
{
    Quit $$$ERROR($$$NotImplemented)
}

/// FHIR Facade Search implementation
ClassMethod FacadeSearch(pResourceType As %String, pCompartment As %String, pCompartmentId As %String, pParameters As HS.FHIRServer.API.Data.QueryParameters = "", ByRef pSortKeys = "") As HS.FHIRServer.Util.SearchResult
{
    Quit $$$ERROR($$$NotImplemented)
}

}
