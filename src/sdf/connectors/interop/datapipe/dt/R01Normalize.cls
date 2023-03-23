Class sdf.connectors.interop.datapipe.dt.R01Normalize Extends Ens.DataTransformDTL [ DependsOn = sdf.connectors.interop.datapipe.model.R01Model ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='sdf.connectors.interop.datapipe.model.R01Model' targetClass='sdf.connectors.interop.datapipe.model.R01Model' create='copy' language='objectscript' >
<if condition='target.ObxValues.GetAt("BodyTemp")&apos;=""' >
<true>
<assign value='(source.ObxValues.GetAt("BodyTemp")-32)*(5/9)' property='target.ObxValues' action='set' key='"BodyTemp"' >
<annotation>Normalize Fahrenheit to Celsius</annotation>
</assign>
<assign value='"C"' property='target.ObxUnits' action='set' key='"BodyTemp"' >
<annotation>Normalize Fahrenheit to Celsius</annotation>
</assign>
</true>
</if>
</transform>
}

}
