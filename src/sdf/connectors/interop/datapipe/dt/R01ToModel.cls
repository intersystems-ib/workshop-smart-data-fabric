Class sdf.connectors.interop.datapipe.dt.R01ToModel Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.HL7.Message, sdf.connectors.interop.datapipe.model.R01Model) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HL7.Message' targetClass='sdf.connectors.interop.datapipe.model.R01Model' sourceDocType='2.5:ORU_R01' create='new' language='objectscript' >
<assign value='source.{MSH:MessageControlID}' property='target.MsgId' action='set' />
<assign value='source.{PIDgrpgrp(1).PIDgrp.PID:PatientID.IDNumber}' property='target.PatientId' action='set' />
<assign value='source.{PIDgrpgrp(1).PIDgrp.PID:PatientName(1).GivenName}' property='target.Name' action='set' />
<assign value='source.{PIDgrpgrp(1).PIDgrp.PID:PatientName(1).FamilyName.Surname}' property='target.Surname1' action='set' />
<assign value='source.{PIDgrpgrp(1).PIDgrp.PID:PatientName(1).SecondandFurtherGivenNamesor}' property='target.Surname2' action='set' />
<assign value='source.{PIDgrpgrp(1).PIDgrp.PID:AdministrativeSex}' property='target.AdministrativeSex' action='set' />
<assign value='source.{PIDgrpgrp(1).PIDgrp.PID:SSNNumberPatient}' property='target.SSN' action='set' />
<assign value='##class(sdf.connectors.interop.Functions).HL7DateToDate(source.{PIDgrpgrp(1).PIDgrp.PID:DateTimeofBirth.Time})' property='target.DOB' action='set' />
<foreach property='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp()}' key='k1' >
<if condition='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationIdentifier.Text}="SYSTOLIC_BLOODPRESSURE"' >
<true>
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationValue(1)}' property='target.ObxValues' action='set' key='"SystolicBP"' />
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:Units.Text}' property='target.ObxUnits' action='set' key='"SystolicBP"' />
<assign value='##class(sdf.connectors.interop.Functions).HL7DateToTimeStamp(source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:DateTimeoftheObservation.Time})' property='target.ObxDateTime' action='set' key='"SystolicBP"' />
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ValueType}' property='target.ObxDataType' action='set' key='"SystolicBP"' />
</true>
</if>
<if condition='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationIdentifier.Text}="DIASTOLIC_BLOODPRESSURE"' >
<true>
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationValue(1)}' property='target.ObxValues' action='set' key='"DiastolicBP"' />
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:Units.Text}' property='target.ObxUnits' action='set' key='"DiastolicBP"' />
<assign value='##class(sdf.connectors.interop.Functions).HL7DateToTimeStamp(source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:DateTimeoftheObservation.Time})' property='target.ObxDateTime' action='set' key='"DiastolicBP"' />
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ValueType}' property='target.ObxDataType' action='set' key='"DiastolicBP"' />
</true>
</if>
<if condition='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationIdentifier.Text}="BLOOD_GLUCOSE"' >
<true>
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationValue(1)}' property='target.ObxValues' action='set' key='"BloodGlucose"' />
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:Units.Text}' property='target.ObxUnits' action='set' key='"BloodGlucose"' />
<assign value='##class(sdf.connectors.interop.Functions).HL7DateToTimeStamp(source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:DateTimeoftheObservation.Time})' property='target.ObxDateTime' action='set' key='"BloodGlucose"' />
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ValueType}' property='target.ObxDataType' action='set' key='"BloodGlucose"' />
</true>
</if>
<if condition='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationIdentifier.Text}="BODY_TEMP"' >
<true>
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationValue(1)}' property='target.ObxValues' action='set' key='"BodyTemp"' />
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:Units.Text}' property='target.ObxUnits' action='set' key='"BodyTemp"' />
<assign value='##class(sdf.connectors.interop.Functions).HL7DateToTimeStamp(source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:DateTimeoftheObservation.Time})' property='target.ObxDateTime' action='set' key='"BodyTemp"' />
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ValueType}' property='target.ObxDataType' action='set' key='"BodyTemp"' />
</true>
</if>
<if condition='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationIdentifier.Text}="HEART_RATE"' >
<true>
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationValue(1)}' property='target.ObxValues' action='set' key='"HeartRate"' />
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:Units.Text}' property='target.ObxUnits' action='set' key='"HeartRate"' />
<assign value='##class(sdf.connectors.interop.Functions).HL7DateToTimeStamp(source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:DateTimeoftheObservation.Time})' property='target.ObxDateTime' action='set' key='"HeartRate"' />
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ValueType}' property='target.ObxDataType' action='set' key='"HeartRate"' />
</true>
</if>
<if condition='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationIdentifier.Text}="RISK_LEVEL"' >
<true>
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationValue(1)}' property='target.ObxValues' action='set' key='"RiskLevel"' />
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:Units.Text}' property='target.ObxUnits' action='set' key='"RiskLevel"' />
<assign value='##class(sdf.connectors.interop.Functions).HL7DateToTimeStamp(source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:DateTimeoftheObservation.Time})' property='target.ObxDateTime' action='set' key='"RiskLevel"' />
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ValueType}' property='target.ObxDataType' action='set' key='"RiskLevel"' />
</true>
</if>
</foreach>
</transform>
}

}
