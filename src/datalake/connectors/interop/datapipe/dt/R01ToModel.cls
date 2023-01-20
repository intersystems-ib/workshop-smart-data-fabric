Class datalake.connectors.interop.datapipe.dt.R01ToModel Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.HL7.Message, datalake.connectors.interop.datapipe.model.R01Model) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HL7.Message' targetClass='datalake.connectors.interop.datapipe.model.R01Model' sourceDocType='2.5:ORU_R01' create='new' language='objectscript' >
<assign value='source.{MSH:MessageControlID}' property='target.MsgId' action='set' />
<assign value='source.{PIDgrpgrp(1).PIDgrp.PID:PatientID.IDNumber}' property='target.PatientId' action='set' />
<assign value='source.{PIDgrpgrp(1).PIDgrp.PID:PatientName(1).GivenName}' property='target.Name' action='set' />
<assign value='source.{PIDgrpgrp(1).PIDgrp.PID:PatientName(1).FamilyName.Surname}' property='target.Surname1' action='set' />
<assign value='source.{PIDgrpgrp(1).PIDgrp.PID:PatientName(1).SecondandFurtherGivenNamesor}' property='target.Surname2' action='set' />
<assign value='source.{PIDgrpgrp(1).PIDgrp.PID:AdministrativeSex}' property='target.AdministrativeSex' action='set' />
<assign value='source.{PIDgrpgrp(1).PIDgrp.PID:SSNNumberPatient}' property='target.SSN' action='set' />
<assign value='##class(datalake.connectors.interop.Functions).HL7DateToDate(source.{PIDgrpgrp(1).PIDgrp.PID:DateTimeofBirth.Time})' property='target.DOB' action='set' />
<foreach property='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp()}' key='k1' >
<if condition='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationIdentifier.Text}="SYSTOLIC_BLOODPRESSURE"' >
<true>
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationValue(1)}' property='target.SystolicBP' action='set' />
</true>
</if>
<if condition='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationIdentifier.Text}="DIASTOLIC_BLOODPRESSURE"' >
<true>
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationValue(1)}' property='target.DiastolicBP' action='set' />
</true>
</if>
<if condition='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationIdentifier.Text}="BLOOD_GLUCOSE"' >
<true>
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationValue(1)}' property='target.BS' action='set' />
</true>
</if>
<if condition='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationIdentifier.Text}="BODY_TEMP"' >
<true>
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationValue(1)}' property='target.BodyTemp' action='set' />
</true>
</if>
<if condition='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationIdentifier.Text}="HEART_RATE"' >
<true>
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationValue(1)}' property='target.HeartRate' action='set' />
</true>
</if>
<if condition='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationIdentifier.Text}="RISK_LEVEL"' >
<true>
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationValue(1)}' property='target.RiskLevel' action='set' />
</true>
</if>
</foreach>
</transform>
}

}
