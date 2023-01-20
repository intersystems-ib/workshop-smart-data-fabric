Class datalake.connectors.interop.datapipe.dt.R01Normalize Extends Ens.DataTransformDTL [ DependsOn = datalake.connectors.interop.datapipe.model.R01Model ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='datalake.connectors.interop.datapipe.model.R01Model' targetClass='datalake.connectors.interop.datapipe.model.R01Model' create='copy' language='objectscript' >
<assign value='(source.BodyTemp-32)*(5/9)' property='target.BodyTemp' action='set' >
<annotation>Normalize Fahrenheit to Celsius</annotation>
</assign>
</transform>
}

}
