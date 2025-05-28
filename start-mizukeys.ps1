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
$isRunFromUrl = $false
#endregion

# ╭───────────────────────────────────────────────────────╮
# │ Function: Ensure-Directory                            │
# | General Create-Directory function with error handling │
# ╰───────────────────────────────────────────────────────╯
#region Helper Functions
function New-Directory {
    param([string] $Path)
    if (!(Test-Path -Path $Path -PathType Container)) {
        try {
            New-Item -ItemType Directory -Path $Path -Force | Out-Null
            Write-Output "Created directory: $Path"
        } catch {
            Write-Error "Failed to create directory ${Path}:  $($_.Exception.Message)"
            return $false
        }
    }
    return $true
}

# ╭─────────────────────────────────────────────────────╮
# │ Function: Get-AutoHotkey                            │
# | Download and extract an approved AutoHotkey version │
# ╰─────────────────────────────────────────────────────╯
function Get-AutoHotkey {
    if (!(New-Directory -Path $AHKBinPath)) {
        return $false
    }
    Write-Output "Downloading AutoHotkey..."
    try {
        Invoke-WebRequest -Uri $AHKZipUrl -OutFile $AHKZipPath -ErrorAction Stop
        Expand-Archive -Path $AHKZipPath -DestinationPath $AHKBinPath -Force
        Remove-Item -Path $AHKZipPath -Force
        Write-Output "AutoHotkey downloaded and extracted to '$AHKBinPath'."
        return $true
    } catch {
        Write-Error "Failed to download or extract AutoHotkey: $($_.Exception.Message)"
        return $false
    }
}

# ╭─────────────────────────────────────────────────╮
# │ Function: New-Shortcut                          │
# | Creates a shortcut to a target file or folder.  │
# ╰─────────────────────────────────────────────────╯
function New-Shortcut {
  param(
      [string] $ShortcutPath,
      [string] $TargetPath,
      [string] $Arguments,
      [string] $Description,
      [string] $WorkingDirectory,
      [string] $IconPath,
      [string] $ShortcutDisplayName
  )

  try {
      if (Test-Path $ShortcutPath) {
        Write-Warning "Shortcut '$ShortcutDisplayName' already exists at '$ShortcutPath'. Overwriting."
      }
      $Shell = New-Object -ComObject WScript.Shell
      $Shortcut = $Shell.CreateShortcut($ShortcutPath)
      $Shortcut.TargetPath = $TargetPath
      $Shortcut.Arguments = $Arguments
      $Shortcut.Description = $Description
      $Shortcut.WorkingDirectory = $WorkingDirectory
      $Shortcut.IconLocation = $IconPath
      $Shortcut.Save()

      # Rename the shortcut display name
      $objShell = New-Object -ComObject Shell.Application
      $objFolder = $objShell.Namespace((Split-Path -Path $ShortcutPath -Parent))
      $objItem = $objFolder.ParseName((Split-Path -Path $ShortcutPath -Leaf))
      $objItem.Name = $ShortcutDisplayName

      [System.Runtime.InteropServices.Marshal]::ReleaseComObject($Shell)
      [System.Runtime.InteropServices.Marshal]::ReleaseComObject($objShell)
      Remove-Variable -Name Shell, objShell
  } catch {
      Write-Error "Failed to create shortcut: $($_.Exception.Message)"
      return $false
  }

  Write-Output "Shortcut created at '$ShortcutPath'."
  return $true
}
#endregion


# ╭─────────────╮
# │ Main Script │
# ╰─────────────╯
#region Main()
# Determine if the script was invoked from a URL or from a file.
if ($null -eq $MyInvocation.MyCommand.Path -or $MyInvocation.MyCommand.Path -eq '-') {
    $isRunFromUrl = $true
}

if ($isRunfromURL) {
    # Download and extract zip to $InstallDir
    # ...existing code for downloading and extracting...
    & "$InstallDir\autohotkey32.exe" # Run after extraction
} else {
    $ahkPath = Join-Path -Path "." -ChildPath "ahkbin\autohotkey32.exe"
    if (Test-Path $ahkPath) {
        & $ahkPath # Run if present
    } else {
        Write-Error "AutoHotKey not found in ./ahkbin directory."
        exit 1
    }
}

# Ensure install directory exists and copy repo contents if needed
if (!(Test-Path -Path $InstallDir)) {
    if (!(New-Directory -Path $InstallDir)) {
        Write-Error "Failed to create install directory. Exiting script."
        exit 1
    }
    Write-Output "Copying files to $InstallDir..."
    try {
        # Download and extract the latest release from the main branch
        $RepoZipUrl = "https://github.com/voltaire-toledo/mizu-keys/archive/refs/heads/main.zip"
        $RepoZipPath = Join-Path $env:TEMP "mizu-keys-main.zip"
        try {
            Invoke-WebRequest -Uri $RepoZipUrl -OutFile $RepoZipPath -ErrorAction Stop
            $TempExtractPath = Join-Path $env:TEMP "mizu-keys-extract"
            if (Test-Path $TempExtractPath) { Remove-Item $TempExtractPath -Recurse -Force }
            Expand-Archive -Path $RepoZipPath -DestinationPath $TempExtractPath -Force
            $SourceFolder = Join-Path $TempExtractPath "mizu-keys-main\mizu-keys"
            Copy-Item -Path (Join-Path $SourceFolder '*') -Destination $InstallDir -Recurse -Force
            Remove-Item $RepoZipPath -Force
            Remove-Item $TempExtractPath -Recurse -Force
        } catch {
            Write-Error "Failed to download or extract Mizu Keys files: $($_.Exception.Message)"
            exit 1
        }
        Copy-Item -Path (Join-Path $PSScriptRoot '*') -Destination $InstallDir -Recurse -Force
        Write-Output "Files copied to $InstallDir."
    } catch {
        Write-Error "Failed to copy files: $($_.Exception.Message)"
        exit 1
    }
}

# Get the path to the Start Menu Programs folder.
$StartMenuPath = [Environment]::GetFolderPath("StartMenu")
$StartMenuFolderPath = Join-Path -Path (Join-Path -Path $StartMenuPath -ChildPath "Programs") -ChildPath $StartMenuFolderName

# Ensure AutoHotkey is downloaded and extracted.
if (!(Test-Path -Path $AHKBinPath)) {
    if (!(Get-AutoHotkey)) {
        Write-Error "Failed to set up AutoHotkey. Exiting script."
        exit 1
    }
}

# Ensure the Start Menu folder exists.
if (!(New-Directory -Path $StartMenuFolderPath)) {
    Write-Warning "Failed to create Start Menu folder. Using Start Menu root instead."
    $StartMenuFolderPath = $StartMenuPath
}

# Define the shortcut path and target.
$ShortcutPath = Join-Path -Path $StartMenuFolderPath -ChildPath $ShortcutName
$TargetPath = Join-Path -Path $AHKBinPath -ChildPath $AHKExecutableName

# Create the shortcut.
$WorkingDirectory = $InstallDir
if (!(New-Shortcut -ShortcutPath $ShortcutPath -TargetPath $TargetPath -Arguments $Arguments -Description $Description -WorkingDirectory $InstallDir -IconPath $IconPath -ShortcutDisplayName $ShortcutDisplayName)) {
    Write-Error "Failed to create the shortcut. Exiting script."
    exit 1
}

# Start the shortcut without waiting for it to finish.
try {
    Start-Process -FilePath $ShortcutPath
    Write-Output "Shortcut '$ShortcutDisplayName' created and started."
} catch {
    Write-Error "Failed to start the shortcut: $($_.Exception.Message)"
    exit 1
}
#endregion
