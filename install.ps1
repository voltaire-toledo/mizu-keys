```powershell
# ...existing code...

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
# ...existing code...
```