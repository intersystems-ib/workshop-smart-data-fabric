Class sdf.connectors.interop.datapipe.dt.R01ToInboxAttributes Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.HL7.Message, DataPipe.Data.InboxAttributes) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HL7.Message' targetClass='DataPipe.Data.InboxAttributes' sourceDocType='2.5:ORU_R01' create='new' language='objectscript' >
<assign value='source.{MSH:MessageControlID}' property='target.MsgId' action='set' />
<assign value='source.{PIDgrpgrp(1).PIDgrp.PV1grp.PV1:VisitNumber.IDNumber}' property='target.Element' action='set' />
<assign value='source.{PIDgrpgrp(1).PIDgrp.PID:PatientID.IDNumber}' property='target.Subject' action='set' />
</transform>
}

}
