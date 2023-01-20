Class datalake.connectors.interop.datapipe.model.R01Model Extends (%RegisteredObject, %XML.Adaptor, %JSON.Adaptor, DataPipe.Model)
{

Property MsgId As %String;

Property PatientId As %String;

Property Name As %String;

Property Surname1 As %String;

Property Surname2 As %String;

Property DOB As %Date;

Property AdministrativeSex As %String;

Property SSN As %String;

Property ObxValues As %ArrayOfDataTypes;

Property ObxUnits As %ArrayOfDataTypes;

/// Serialize to json
Method Serialize(Output stream) As %Status
{
    set ret = $$$OK
    try {
        // serialize to json
        $$$ThrowOnError(..%JSONExportToStream(.tmpStream))
        
        // format json
        set formatter = ##class(%JSON.Formatter).%New()
        $$$ThrowOnError(formatter.FormatToStream(tmpStream, .stream))

    } catch ex {
        set ret = ex.AsStatus()
    }
    quit ret
}

ClassMethod Deserialize(stream As %Stream.Object, Output obj) As %Status
{
    set ret = $$$OK
    try {
        set obj = ..%New()
        $$$ThrowOnError(obj.%JSONImport(stream, .obj))

    } catch ex {
        set ret = ex.AsStatus()
    }
    quit ret
}

Method Normalize(Output obj As DataPipe.Model) As %Status
{
    set ret = $$$OK
    try {
        // call normalizaton data transform
        set sc = $classmethod("datalake.connectors.interop.datapipe.dt.R01Normalize", "Transform", $this, .obj)
        $$$ThrowOnError(sc)

    } catch ex {
        set ret = ex.AsStatus()
    }
    quit ret
}

/// Validate model
Method Validate(Output errorList As %List) As %Status
{
    #define AddError(%list, %code, %desc) set error = ##class(DataPipe.Data.ErrorInfo).%New() set error.Code=%code set error.Desc=%desc do %list.Insert(error)
	
    set ret = $$$OK
    try {
        set errorList = ##class(%ListOfObjects).%New()

        // administrative sex
        if ..AdministrativeSex="" $$$AddError(errorList, "VGEN", "AdministrativeSex required")

        // date of birth
        if ..DOB="" { 
            $$$AddError(errorList, "V001", "DOB required")
        }
        else {
            set yearDOB = $extract($zdate(..DOB,8),1,4)
            if (yearDOB < 1930) $$$AddError(errorList, "V002", "DOB must be greater than 1930")
            if (yearDOB < 1983) $$$AddError(errorList, "W083", "Warning! Older than 1983")
        }

        // model is invalid if errors (not warnings) found
        for i=1:1:errorList.Count() {
            set error = errorList.GetAt(i)
            set errorCode = error.Code

            // in this sample model, all warnings start with "W"
            if errorCode'["W" {
                $$$ThrowStatus($$$ERROR($$$GeneralError, "Invalid"))
            }
		}
       
    } catch ex {
        set ret = ex.AsStatus()
    }

    quit ret
}

/// Return the Business Operation name that will run the operation with the model
/// Each Business Operation can be used to hold different queues
Method GetOperation() As %Status
{
    quit "R01 Operation"
}

/// Run final operation with the model
/// This method can be used to persit data from the model to an operational data store
Method RunOperation(Output errorList As %List, Output log As %Stream.Object, bOperation As Ens.BusinessOperation = "") As %Status
{
    #define AddError(%list, %code, %desc) set error = ##class(DataPipe.Data.ErrorInfo).%New() set error.Code=%code set error.Desc=%desc do %list.Insert(error)
    #define AddLog(%log, %msg) do %log.WriteLine("["_$zdt($h,3)_"] "_%msg)
	
    set errorList = ##class(%ListOfObjects).%New()
    set log = ##class(%Stream.GlobalCharacter).%New()

    set ret = $$$OK
    try {
        TSTART
        $$$AddLog(log, "Transaction Started")

        // patient
        $$$ThrowOnError(##class(datalake.data.Patient).GetByIdentifier(..PatientId, .patientObj))
        if '$isobject(patientObj) {
            $$$AddLog(log, "Patient "_..PatientId_" does not exist. Creating patient")
            set patientObj = ##class(datalake.data.Patient).%New()
        }
        set patientObj.Identifier = ..PatientId
        set patientObj.FirstName = ..Name
        set patientObj.AdministrativeSex = ..AdministrativeSex
        set patientObj.LastName = ..Surname1
        set patientObj.BirthDate = ..DOB
        
        // observations
        set obxCode=""
        for  {
            set obxValue = ..ObxValues.GetNext(.obxCode) 
            quit:obxCode="" 
            set obxUnits = ..ObxUnits.GetAt(obxCode) 
            set obxObj = ##class(datalake.data.Observation).%New()
            set obxObj.Code = obxCode
            set obxObj.Status = "F"
            set obxObj.Units = obxUnits
            do patientObj.Observations.Insert(obxObj)
        }
        $$$ThrowOnError(patientObj.%Save(1))

        TCOMMIT
        $$$AddLog(log, "Transaction Commited")

    } catch ex {
        TROLLBACK 
        $$$AddLog(log, "Rollback!")

        set ret = ex.AsStatus()
        $$$AddLog(log, "Error catched: "_$system.Status.GetOneStatusText(ret))

        // include exception errors into errorList
        do $system.Status.DecomposeStatus(ret, .errors)
		for i=1:1:errors {
			$$$AddError(errorList, "Exception", errors(i))
		}
    }
    quit ret
}

}
