# PSST.Wsp

[![Build status](https://ci.appveyor.com/api/projects/status/gycbsu2kpu4it4up/branch/master?svg=true&passingText=Build%20Passing&failingText=Build%20Failing&pendingText=Build%20Pending)](https://ci.appveyor.com/project/codecraftteam/PSST-Wsp)

PowerShell SharePoint Tools for working with WSP files.  

## Scenario

SharePoint revokes creating new Sites from an imported WSP solution if some features are missing. If these features are not required by the WSP template one can remove them.  
This module allows to remove the features alerted by SharePoint from the WSP solution file.  

1. Download the WSP file
1. Unpack the WSP file using Cmdlets of this module
1. Remove the features using Cmdlets of this module
1. Pack the WSP file using Cmdlets of this module
1. Upload and test the new WSP solution.

## DISCLAIMER

Use at your own risk.
