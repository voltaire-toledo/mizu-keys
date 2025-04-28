#region Configuration
$ShortcutName = "Mizu Keys.lnk"
$ShortcutDisplayName = "Mizu Keys"
$AHKExecutableName = "AutoHotkey32.exe"
$AHKBinPath = Join-Path -Path $PSScriptRoot -ChildPath "ahkbin"
$Arguments = Join-Path -Path $PSScriptRoot -ChildPath "mizu-keys.ahk"
$Description = "Start Mizu Keys"
$IconPath = Join-Path -Path $PSScriptRoot -ChildPath "media\icons\mizu-leaf.ico"
$StartMenuFolderName = "Mizu"
$AHKZipUrl = "https://www.autohotkey.com/download/2.0/AutoHotkey_2.0.19.zip"
$AHKZipPath = Join-Path -Path $PSScriptRoot -ChildPath "AutoHotkey.zip"
#endregion

# ╭───────────────────────────────────────────────────────╮
# │ Function: Ensure-Directory                            │
# | General Create-Directory function with error handling │
# ╰───────────────────────────────────────────────────────╯
#region Helper Functions
function Ensure-Directory {
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
    if (!(Ensure-Directory -Path $AHKBinPath)) {
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

    #Rename
    $objShell = New-Object -ComObject Shell.Application
    $objFolder = $objShell.Namespace((Split-Path -Path $ShortcutPath -Parent))
    $objItem = $objFolder.ParseName((Split-Path -Path $ShortcutPath -Leaf))
    $objItem.Name = $ShortcutDisplayName

    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($Shell)
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($objShell)
    Remove-Variable -Name Shell, objShell
}
#endregion


# ╭─────────────╮
# │ Main Script │
# ╰─────────────╯
# Get the path to the Start Menu Programs folder.
$StartMenuPath = [Environment]::GetFolderPath("StartMenu")
$StartMenuFolderPath = Join-Path -Path (Join-Path -Path $StartMenuPath -ChildPath "Programs") -ChildPath $StartMenuFolderName

# Check for AutoHotkey and download if not found.
if (!(Test-Path -Path $AHKBinPath)) {
    if (!(Get-AutoHotkey)) {
        exit # Stop if AHK download/extraction fails
    }
}

# Create the Start Menu folder if it does not exist.
if (!(Ensure-Directory -Path $StartMenuFolderPath)) {
    $StartMenuFolderPath = $StartMenuPath # Use the root if creating the folder fails
}

$ShortcutPath = Join-Path -Path $StartMenuFolderPath -ChildPath "$ShortcutName"
$TargetPath = Join-Path -Path $AHKBinPath -ChildPath $AHKExecutableName

# Create the shortcut
$WorkingDirectory = Split-Path -Path $PSScriptRoot -Parent
New-Shortcut -ShortcutPath $ShortcutPath -TargetPath $TargetPath -Arguments $Arguments -Description $Description -WorkingDirectory $PSScriptRoot -IconPath $IconPath -ShortcutDisplayName $ShortcutDisplayName -Force
write-host "Shortcut created at $ShortcutPath"

# Start the shortcut without waiting for it to finish.
Start-Process -FilePath $ShortcutPath

Write-Output "Shortcut '$ShortcutDisplayName' created and started."
#endregion
