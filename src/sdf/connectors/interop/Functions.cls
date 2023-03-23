Include Ensemble

Class sdf.connectors.interop.Functions Extends %RegisteredObject
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

/// Convert HL7 DateTime to %TimeStamp
ClassMethod HL7DateToTimeStamp(value) As %Date
{
    if value="" quit ""
	set ret = ""
	try {
		set d = $e(value, 1, 4)_"-"_$e(value, 5, 6)_"-"_$e(value, 7, 8)
		set t = $e(value, 9, 10)_":"_$e(value, 11, 12)_":"_$e(value, 13, 14)
		set ret = d_" "_t
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
