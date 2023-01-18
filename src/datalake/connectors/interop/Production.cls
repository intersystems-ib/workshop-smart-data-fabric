Class datalake.connectors.interop.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="datalake.connectors.interop.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Setting Target="Adapter" Name="ShutdownTimeout">5</Setting>
  <Setting Target="Adapter" Name="UpdateTimeout">5</Setting>
  <Item Name="HL7 In" Category="Ingestion" ClassName="EnsLib.HL7.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="ArchivePath"></Setting>
    <Setting Target="Adapter" Name="FilePath">/app/data/input</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.hl7</Setting>
    <Setting Target="Host" Name="TargetConfigNames">HL7 Ingestion</Setting>
    <Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
  </Item>
  <Item Name="HL7 Staging" Category="Staging" ClassName="DataPipe.Staging.BP.StagingManager" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">HL7 Oper</Setting>
  </Item>
  <Item Name="HL7 Oper" Category="Oper" ClassName="DataPipe.Oper.BP.OperManager" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="A08 Operation" Category="Oper" ClassName="DataPipe.Oper.BO.OperationHandler" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HL7 Ingestion" Category="Ingestion" ClassName="DataPipe.Test.HL7.BP.HL7Ingestion" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="FIFO A08 Operation" Category="Oper" ClassName="DataPipe.Oper.BO.OperationHandler" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="FailureTimeout">-1</Setting>
    <Setting Target="Host" Name="ReplyCodeActions">E=R</Setting>
    <Setting Target="Host" Name="RetryInterval">3</Setting>
  </Item>
  <Item Name="Dummy" Category="" ClassName="EnsLib.File.PassthroughOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
