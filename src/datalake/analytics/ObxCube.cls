/// 
Class datalake.analytics.ObxCube Extends %DeepSee.CubeDefinition [ DependsOn = datalake.data.Observation, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="ObxCube" displayName="Observations Cube" disabled="false" abstract="false" sourceClass="datalake.data.Observation" namedFactNums="true" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="Code" disabled="false" hasAll="false" allCaption="All Code" allDisplayName="Code" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Code" disabled="false" sourceProperty="Code" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="2">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="AdministrativeSex" disabled="false" hasAll="false" allCaption="All AdministrativeSex" allDisplayName="AdministrativeSex" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="AdministrativeSex" disabled="false" sourceProperty="Patient.AdministrativeSex" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="3">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="TimeStamp" disabled="false" hasAll="false" allCaption="All TimeStamp" allDisplayName="TimeStamp" sourceProperty="TimeStamp" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="TimeStamp" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="5">
      </level>
      <level name="TimeStamp1" disabled="false" timeFunction="MonthNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="6">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="ValueST" disabled="false" hasAll="false" allCaption="All ValueST" allDisplayName="ValueST" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="ValueST" disabled="false" sourceProperty="ValueST" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="7">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Age" disabled="false" hasAll="true" allCaption="All Age" allDisplayName="Age" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Age" disabled="false" sourceProperty="Patient.Age" list="false" rangeExpression="(,15]:0-15 Children;[16,22]:0-29 Young;[23,65]:0-65 Adults;[66,):66 Elder;" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="4">
      </level>
    </hierarchy>
  </dimension>
  <measure name="AvgValueNM" disabled="false" sourceProperty="ValueNM" aggregate="AVG" type="number" hidden="false" searchable="false" factNumber="1">
  </measure>
</cube>
}

Parameter DOMAIN;

}
