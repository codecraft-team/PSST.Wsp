@{
    RootModule = '.\PSST.Wsp.psm1'
    ModuleVersion = '1.0.0.0'
    GUID = 'b2257dee-1612-5a75-b823-50821e27f227'
    Author = 'CodeCraft.Team'
    CompanyName = 'CodeCraft.Team'
    Copyright = '(c) 2018 CodeCraft.Team. All rights reserved.'
    Description = 'A collection of SharePoint related PowerShell developer tools.'
    FunctionsToExport = @("Invoke-WspUnpackage","Remove-WspFeature","Invoke-WspPackage")
    CmdletsToExport = @("*-*")
    VariablesToExport = '*'
}