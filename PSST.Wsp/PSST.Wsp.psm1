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

Function Remove-WspFeature {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true)]
    [System.IO.DirectoryInfo]$Directory,

    [Parameter(Mandatory=$true)]
    [string[]]$featureDescription
  )

  $DiskDirectory = Get-Item $Directory;

  $onetFileName = "$($DiskDirectory.FullName)\DACWebTemplate\DAC\ONet.xml";

  $onetContent = (Get-Content -Path "$onetFileName") -join "`r`n";

  $featureDescription | ForEach-Object { $onetContent = $onetContent -replace "[\s]*<!--$_.*-->[\s]*<Feature ID=.*", ""}

  Set-Content -Path $onetFileName -Value $onetContent;
}

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