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

/// Create an OAuth Authorization server configuration in IRIS
/// You can do the same thing in Management Portal: 
/// System Administration > Security > OAuth 2.0 > Server
///  
/// do ##class(sdf.Utils).CreateOAuth2Server()
ClassMethod CreateOAuth2Server() As %Status
{
    set ns = $namespace
    set $namespace = "%SYS"

    set server = ##class(OAuth2.Server.Configuration).%New()
    set server.Description = "AuthServer"

    set endpoint = ##class(OAuth2.Endpoint).%New()
    set endpoint.UseSSL = 1
    set endpoint.Host = "webserver"
    set endpoint.Prefix = "iris"
    set server.IssuerEndpoint = endpoint
    
    // supported grant types
    set server.SupportedGrantTypes = "AC"

    // use JWT tokens
    set server.GenerateTokenClass = "%OAuth2.Server.JWT"

    // support some specific scopes we can define
    set scopes = ##class(%ArrayOfDataTypes).%New()
    do scopes.SetAt("My own scope", "my/scope")
    set server.SupportedScopes = scopes

    // allow unsupported scopes (for testing different SMART on FHIR scopes)
    set server.AllowUnsupportedScope = 1

    // customize auth server as needed
    set server.AuthenticateClass = "sdf.auth.Authenticate"
    set server.ValidateUserClass = "sdf.auth.Validate"
    set server.CustomizationNamespace = "SDF"
    set server.CustomizationRoles = "%DB_IRISSYS,%Manager,%DB_SDF"

    set server.SSLConfiguration = "ssl"
    write server.Save()

    set $namespace = ns
}

}
