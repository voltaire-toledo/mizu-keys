<#
.SYNOPSIS
    Script to create a Start Menu shortcut for Mizu Keys and ensure AutoHotkey is downloaded and configured.

.DESCRIPTION
    This script downloads AutoHotkey, creates a Start Menu folder, and generates a shortcut to launch Mizu Keys.
    It includes error handling and modularized functions for better maintainability.

.NOTES
    Compatible with PowerShell 5.1 and later.
#>

#region Configuration
$InstallDir = Join-Path $env:LOCALAPPDATA 'Mizu-Keys'
$ShortcutName = "Mizu Keys.lnk"
$ShortcutDisplayName = "Mizu Keys"
$AHKExecutableName = "AutoHotkey32.exe"
$AHKBinPath = Join-Path -Path $InstallDir -ChildPath "ahkbin"
$Arguments = Join-Path -Path $InstallDir -ChildPath "mizu-keys.ahk"
$Description = "Start Mizu Keys"
$IconPath = Join-Path -Path $InstallDir -ChildPath "media\icons\mizu-leaf.ico"
$StartMenuFolderName = "Mizu"
$AHKZipUrl = "https://www.autohotkey.com/download/2.0/AutoHotkey_2.0.19.zip"
$AHKZipPath = Join-Path -Path $InstallDir -ChildPath "AutoHotkey.zip"
#endregion

Add-Type -AssemblyName PresentationFramework

$psHost = $Host.Name
$psVersion = $PSVersionTable.PSVersion.ToString()
$cwd = Get-Location | Select-Object -ExpandProperty Path
$scriptPath = $MyInvocation.MyCommand.Path
# Detect if script is being run via Invoke-RestMethod (i.e., not from a file on disk)
if ($null -eq $MyInvocation.MyCommand.Path -or $MyInvocation.MyCommand.Path -eq '-') {
    throw "This script appears to be run directly from Invoke-RestMethod or similar. Please download and run the script from disk."
}
if ([string]::IsNullOrEmpty($scriptPath)) {
    throw "Script path is null or empty. Cannot determine script directory."
}

$scriptDir = Split-Path -Path $scriptPath -Parent
$dirContents = Get-ChildItem -Path $scriptDir | Select-Object -ExpandProperty Name
$dirList = $dirContents -join "`n"

$msg = @"
PowerShell Host: $psHost
PowerShell Version: $psVersion
Current Directory: $cwd
Script Path: $MyInvocation.MyCommand.Path

Directory Contents:
$dirList
"@

[System.Windows.MessageBox]::Show($msg, "Script Environment Info", 'OK', 'Information')