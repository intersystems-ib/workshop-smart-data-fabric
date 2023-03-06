Include (HS.FHIRServer, HS.FHIRServer.Util.SearchResult)

Class datalake.fhirserver.Interactions Extends HS.FHIRServer.Storage.Json.Interactions
{

Method Read(pResourceType As %String, pResourceId As %String, pVersionId As %String = "") As %DynamicObject
{
    set facade = ##class(FHIRFacade).FacadeClass(pResourceType)
    set obj = $classmethod(facade, "%OpenId", pResourceId)
    if '$isobject(obj) {
        $$$ThrowFHIR($$$HSFHIRErrResourceNotFound, pResourceType, pResourceId, $$$OutcomeNotFound)
    }

    return obj.FacadeToResource()
}

Method Search(pResourceType As %String, pCompartment As %String, pCompartmentId As %String, pParameters As HS.FHIRServer.API.Data.QueryParameters = "", ByRef pSortKeys = "") As HS.FHIRServer.Util.SearchResult
{
    set facade = ##class(FHIRFacade).FacadeClass(pResourceType)
    return $classmethod(facade, "FacadeSearch", pResourceType, pCompartment, pCompartmentId, pParameters, .pSortKeys)
}

}
