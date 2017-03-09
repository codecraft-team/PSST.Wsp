<#
.Synopsis
   Unpacks SharePoint WSP files into folders.
.EXAMPLE
   Unpacks the template.wsp to the template folder.
   Invoke-WspUnpackage -WspFile template.wsp -Destination .\template
.OUTPUTS
   None
.FUNCTIONALITY
   Uses Windows expand.exe to unpack WSP cabinet file.
   Requires Windows SDK to be installed.
#>
Function Invoke-WspUnpackage {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true)]
    [System.IO.FileInfo]$WspFile,

    [Parameter(Mandatory=$true)]
    [System.IO.DirectoryInfo]$Destination
  )

  $WspFile = Get-Item $WspFile;

  $DiskDirectory = New-Item $Destination -ItemType Directory -Force;

  expand $WspFile.FullName -F:* $DiskDirectory.FullName;
}

<#
.Synopsis
   Removes named SharePoint features from unpacked WSP folder (ONet.xml file).
.EXAMPLE
   Removes the named features.
   Remove-WspFeature -Directory .\template -FeatureDescritpion ShellControl,spouiremovalpublic
.OUTPUTS
   None
#>
Function Remove-WspFeature {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true)]
    [System.IO.DirectoryInfo]$Directory,

    [Parameter(Mandatory=$true)]
    [string[]]$FeatureDescription
  )

  $DiskDirectory = Get-Item $Directory;

  $onetFileName = "$($DiskDirectory.FullName)\DACWebTemplate\DAC\ONet.xml";

  $onetContent = (Get-Content -Path "$onetFileName") -join "`r`n";

  $FeatureDescription | ForEach-Object { $onetContent = $onetContent -replace "[\s]*<!--$_.*-->[\s]*<Feature ID=.*", ""}

  Set-Content -Path $onetFileName -Value $onetContent;
}

<#
.Synopsis
   Packs SharePoint unpacked WSP folder and files into a single WSP file.
.EXAMPLE
   Unpacks the template.wsp to the template folder.
   Invoke-WspPackage -WspFileName template.wsp -Directory .\template
.OUTPUTS
   None
.FUNCTIONALITY
   Uses Windows makecab.exe to pack WSP cabinet file.
   Requires Windows SDK to be installed.
#>
Function Invoke-WspPackage {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true)]
    $WspFileName,

    [Parameter(Mandatory=$true)]
    [System.IO.DirectoryInfo]$Directory
  )

  $DiskDirectory = Get-Item $Directory;

  $header = @"
  .OPTION EXPLICIT
  .Set CabinetNameTemplate=$WspFileName
  .Set DiskDirectoryTemplate=CDROM
  .Set CompressionType=MSZIP
  .Set MaxDiskSize=CDROM
  .Set Cabinet=on
  .Set Compress=on
  .Set DiskDirectory1=$($DiskDirectory)
"@;

  $ddfFileName = "$WspFileName.ddf";

  Set-Content -Path $ddfFileName -Value $header;

  Get-ChildItem $DiskDirectory -File -Recurse | ForEach-Object {Add-Content -Path $ddfFileName -Value "`"$($_.FullName)`" `"$($_.FullName.Replace($DiskDirectory.FullName, [string]::Empty))`""}

  makecab.exe -f $ddfFileName
}