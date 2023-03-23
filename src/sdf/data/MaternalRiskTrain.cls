Class sdf.data.MaternalRiskTrain [ ClassType = view, CompileAfter = (sdf.data.Observation, sdf.data.Patient), DdlAllowed, Owner = {SuperUser}, Not ProcedureBlock, SqlTableName = MaternalRiskTrain, ViewQuery = { select
 	Age,
	AdministrativeSex,
 	(select ValueNM from sdf_data.Observation where Patient=p.ID and Code='SystolicBP') as SystolicBP,
 	(select ValueNM from sdf_data.Observation where Patient=p.ID and Code='DiastolicBP') as DiastolicBP,
 	(select ValueNM from sdf_data.Observation where Patient=p.ID and Code='BloodGlucose') as BloodGlucose,
 	(select ValueNM from sdf_data.Observation where Patient=p.ID and Code='HeartRate') as HeartRate,
 	(select ValueNM from sdf_data.Observation where Patient=p.ID and Code='BodyTemp') as BodyTemp,
 	(select ValueST from sdf_data.Observation where Patient=p.ID and Code='RiskLevel') as RiskLevel
 	from sdf_data.Patient p
 	where (select ValueST from sdf_data.Observation where Patient=p.ID and Code='RiskLevel') is not null
	and ID < 550  /*#OPTIONS {"DynamicSQL":1} */} ]
{

}
