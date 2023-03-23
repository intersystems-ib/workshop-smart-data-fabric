Class sdf.tools.HL7Generator
{

/// Generate multiple test ADT HL7 Files
/// do ##class(sdf.tools.HL7Generator).GenerateFilesHL7()
ClassMethod GenerateFilesHL7(outputDir As %String = "/app/data/maternalRisk/hl7gen/", template As %String = "/app/data/maternalRisk/ORUR01template.hl7", docType As %String = "2.5:ORU_R01") As %Status
{
    set ret = $$$OK

    try {
        set sql="select ID,Age,SystolicBP,DiastolicBP,BS,BodyTemp,HeartRate,RiskLevel FROM temp.MaternalHealthRisk ORDER BY ID ASC"
		set statement = ##class(%SQL.Statement).%New()
		$$$ThrowOnError(statement.%Prepare(sql))	
		#dim result As %SQL.StatementResult = statement.%Execute()
        while result.%Next() {
			set age = result.%GetData(2)
            set systolicBP = result.%GetData(3)
            set diastolicBP = result.%GetData(4)
            set bs = result.%GetData(5)
            set bodyTemp = result.%GetData(6)
            set heartRate = result.%GetData(7)
            set riskLevel = result.%GetData(8)

            // generate random hl7 test file from template
            set input = {
                "age": (age), 
                "systolicBP": (systolicBP),
                "diastolicBP": (diastolicBP),
                "bs": (bs),
                "bodyTemp": (bodyTemp),
                "heartRate": (heartRate),
                "riskLevel": (riskLevel)
            }
            $$$ThrowOnError(..GenerateHL7(input, template, docType, .hl7))

            // write hl7 file to test production input directory
            $$$ThrowOnError(hl7.OutputToFile(outputDir_"file"_$tr($zts,",.","")_".hl7"))
        }

    } catch ex {
        set ret = ex.AsStatus()
        do $system.Status.DisplayError(ret)
    }
    quit ret
}

/// Generate a test hl7 file based on input values
/// - input: DynamicObject which can, optionally, specify properties such as MsgId, PatientId, etc.
/// - fifoEnabled: randomly generate msgid containing "FIFO" (will be treated as FIFO on test production)
/// - template: template message
/// - doctype: document type to use 
ClassMethod GenerateHL7(input As %DynamicObject = {{}}, template As %String, docType As %String, Output hl7) As %Status
{
    set ret = $$$OK
    try {
        // default values for input
        if input.MsgId="" set input.MsgId = $zconvert(##class(%PopulateUtils).StringMin(3,3),"U")_##class(%PopulateUtils).Integer(99999,999999)
        if input.PatientId="" set input.PatientId = ##class(%PopulateUtils).Integer(99999,999999)
        if input.Name="" set input.Name = ##class(%PopulateUtils).FirstName(1)
        if input.Surname1="" set input.Surname1 = ##class(%PopulateUtils).FirstName()
        if input.Surname2="" set input.Surname2 = ##class(%PopulateUtils).LastName()
        if input.DOB="" set input.DOB = ..DateToHL7Date(##class(%PopulateUtils).Date($horolog-(365*40)))
        if input.AdministrativeSex="" set input.AdministrativeSex = ##class(%PopulateUtils).ValueList(",M,F,")
        if input.SSN="" set input.SSN = ##class(%PopulateUtils).SSN()
        if input.VisitNumber="" set input.VisitNumber = ##class(%PopulateUtils).ValueList(",O,I,E")_##class(%PopulateUtils).Integer(99999,999999)
        if input.DateTimeObservation="" {
            set input.DateTimeObservation = ##class(%PopulateUtils).TimeStamp($zdatetime($horolog-120,3), $zdatetime($horolog,3))
            set input.DateTimeObservation = $tr(input.DateTimeObservation, " -:", "")
        }

        if input.age'="" {
            set dob = $horolog-(input.age*365)
            // move around 2 months from current day
            set dob = dob - ##class(%PopulateUtils).Integer(1,60)
            set input.DOB = ..DateToHL7Date(dob)
        }

        // load template hl7 message
        set hl7 = ##class(EnsLib.HL7.Message).ImportFromFile(template,,.sc)
        $$$ThrowOnError(sc)
        set hl7.DocType = docType

        // set values into message
        do hl7.SetValueAt(input.MsgId, "MSH:10")
        do hl7.SetValueAt(input.PatientId, "PIDgrpgrp(1).PIDgrp.PID:2.1")
        do hl7.SetValueAt(input.Name, "PIDgrpgrp(1).PIDgrp.PID:5(1).2")
        do hl7.SetValueAt(input.Surname1, "PIDgrpgrp(1).PIDgrp.PID:5(1).1.1")
        do hl7.SetValueAt(input.Surname2, "PIDgrpgrp(1).PIDgrp.PID:5(1).3")
        do hl7.SetValueAt(input.DOB, "PIDgrpgrp(1).PIDgrp.PID:7.1")
        do hl7.SetValueAt(input.AdministrativeSex, "PIDgrpgrp(1).PIDgrp.PID:8")
        do hl7.SetValueAt(input.SSN, "PIDgrpgrp(1).PIDgrp.PID:19")
        do hl7.SetValueAt(input.VisitNumber, "PIDgrpgrp(1).PIDgrp.PV1:19")
        do hl7.SetValueAt(input.systolicBP, "PIDgrpgrp(1).ORCgrp(1).OBXgrp(1).OBX:5")
        do hl7.SetValueAt(input.diastolicBP, "PIDgrpgrp(1).ORCgrp(1).OBXgrp(2).OBX:5")
        do hl7.SetValueAt(input.bs, "PIDgrpgrp(1).ORCgrp(1).OBXgrp(3).OBX:5")
        do hl7.SetValueAt(input.bodyTemp, "PIDgrpgrp(1).ORCgrp(1).OBXgrp(4).OBX:5")
        do hl7.SetValueAt(input.heartRate, "PIDgrpgrp(1).ORCgrp(1).OBXgrp(5).OBX:5")
        do hl7.SetValueAt(input.riskLevel, "PIDgrpgrp(1).ORCgrp(1).OBXgrp(6).OBX:5")
        for i=1:1:6 {
            do hl7.SetValueAt(input.DateTimeObservation, "PIDgrpgrp(1).ORCgrp(1).OBXgrp("_i_").OBX:14.1")
        }
        
        if input.AdministrativeSex="M" {
            do hl7.RemoveSegmentAt("PIDgrpgrp(1).ORCgrp(1).OBXgrp(6).OBX")
        }
        

    } catch ex {
        set ret = ex.AsStatus()
    }
    quit ret
}

ClassMethod HL7DateToDate(value) As %Date
{
    if value="" quit ""
	set ret = ""
	try {
		set ret = $zdateh($e(value, 1, 8), 8)
	} catch ex {
        set ret = ex.AsStatus()
		do $system.Status.DisplayError(ret)
	}
	quit ret
}

/// Convert %Date to HL7 Date
ClassMethod DateToHL7Date(value) As %Date
{
    if value="" quit ""
	set ret = ""
	try {
		set ret = $zdate(value, 8)
	} catch ex {
        set ret = ex.AsStatus()
		do $system.Status.DisplayError(ret)
	}
	quit ret
}

ClassMethod AgeToDate(value) As %Date
{
    if value="" quit ""
	set ret = ""
	try {
		set ret = $zdate(value, 8)
	} catch ex {
        set ret = ex.AsStatus()
		do $system.Status.DisplayError(ret)
	}
	quit ret
}

}
