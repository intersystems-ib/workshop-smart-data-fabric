Include Ensemble

Class datalake.connectors.interop.Functions Extends %RegisteredObject
{

/// Convert HL7 Date to %Date
ClassMethod HL7DateToDate(value) As %Date
{
    if value="" quit ""
	set ret = ""
	try {
		set ret = $zdateh($e(value, 1, 8), 8)
	} catch ex {
		$$$LOGERROR(ex.DisplayString())
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
		$$$LOGERROR(ex.DisplayString())
	}
	quit ret
}

}
