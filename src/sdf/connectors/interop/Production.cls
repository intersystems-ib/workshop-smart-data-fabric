Class sdf.connectors.interop.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="sdf.connectors.interop.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Setting Target="Adapter" Name="ShutdownTimeout">5</Setting>
  <Setting Target="Adapter" Name="UpdateTimeout">5</Setting>
  <Item Name="HL7 In" Category="Ingestion" ClassName="EnsLib.HL7.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="ArchivePath"></Setting>
    <Setting Target="Adapter" Name="FilePath">/app/data/hl7in</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.hl7</Setting>
    <Setting Target="Host" Name="TargetConfigNames">HL7 Ingestion</Setting>
    <Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
  </Item>
  <Item Name="HL7 Staging" Category="Staging" ClassName="DataPipe.Staging.BP.StagingManager" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">HL7 Oper</Setting>
  </Item>
  <Item Name="HL7 Oper" Category="Oper" ClassName="DataPipe.Oper.BP.OperManager" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="R01 Operation" Category="Oper" ClassName="DataPipe.Oper.BO.OperationHandler" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HL7 Ingestion" Category="Ingestion" ClassName="sdf.connectors.interop.datapipe.bp.HL7Ingestion" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="TelegramSendMessage" Category="" ClassName="sdf.connectors.interop.bo.TelegramSendMessage" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="HTTPPort">443</Setting>
    <Setting Target="Adapter" Name="HTTPServer">api.telegram.org</Setting>
    <Setting Target="Adapter" Name="SSLConfig">ssl</Setting>
    <Setting Target="Host" Name="TelegramCredentials">TelegramBotToken</Setting>
    <Setting Target="Host" Name="DefaultTelegramChatId">your-chatId</Setting>
  </Item>
  <Item Name="TelegramFromService" Category="" ClassName="sdf.connectors.interop.bs.TelegramFromService" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
