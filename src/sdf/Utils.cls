Class sdf.Utils
{

/// Export a resultset to a XLS file
ClassMethod ResultSetToXls(resultSet As %SQL.StatementResult, fileName As %String) [ Language = python ]
{
    from openpyxl import Workbook
    from openpyxl.utils.dataframe import dataframe_to_rows
    
    wb = Workbook()
    ws = wb.active

    import iris
    pyResultSet = iris.cls('%SYS.Python.SQLResultSet')._New(resultSet)
    df = pyResultSet.dataframe()
    
    for r in dataframe_to_rows(df, index=True, header=True):
        ws.append(r)
    
    for cell in ws['A'] + ws[1]:
        cell.style = 'Pandas'
    
    wb.save(fileName)
}

}
