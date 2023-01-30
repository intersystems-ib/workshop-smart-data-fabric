Class datalake.data.MaternalRiskTest [ ClassType = view, CompileAfter = (datalake.data.Observation, datalake.data.Patient), DdlAllowed, Owner = {SuperUser}, Not ProcedureBlock, SqlTableName = MaternalRiskTest, ViewQuery = { select
 	 	Age,
		AdministrativeSex,
 	 	(select ValueNM from datalake_data.Observation where Patient=p.ID and Code='SystolicBP') as SystolicBP,
 	 	(select ValueNM from datalake_data.Observation where Patient=p.ID and Code='DiastolicBP') as DiastolicBP,
 	 	(select ValueNM from datalake_data.Observation where Patient=p.ID and Code='BloodGlucose') as BloodGlucose,
 	 	(select ValueNM from datalake_data.Observation where Patient=p.ID and Code='HeartRate') as HeartRate,
 	 	(select ValueNM from datalake_data.Observation where Patient=p.ID and Code='BodyTemp') as BodyTemp,
 	 	(select ValueST from datalake_data.Observation where Patient=p.ID and Code='RiskLevel') as RiskLevel
 	 	from datalake_data.Patient p
 	 	where (select ValueST from datalake_data.Observation where Patient=p.ID and Code='RiskLevel') is not null
 	        and ID > 550  /*#OPTIONS {"DynamicSQL":1} */} ]
{

}
