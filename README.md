# Mizu-Keys
Automations that leverage AutoHotkey when while exploring capabilities of AutoHotkey.

## Installation
### Step 1: Install AutoHotkey
Install [AutoHotkey](https://www.autohotkey.com/), another open source project, using one of the following methods:

#### Option 1: Install AutoHotkey from the official website
Download the latest version of AutoHotkey from the [official website](https://www.autohotkey.com/) and run the installer.
3. Follow the prompts to install AutoHotkey.

#### Option 2: Install AutoHotkey using Chocolatey
Run the following [Chocolatey](https://chocolatey.org/install) command in an elevated command prompt:
```powershell
choco install autohotkey
```

#### Option 3: Install AutoHotkey using Scoop
Run the following [Scoop](https://scoop.sh/) command in an elevated command prompt:
```powershell
scoop install autohotkey
```
#### Option 4: Install AutoHotkey using Winget
Run the following [Winget](https://github.com/microsoft/winget-cli) that comes pre-installed with Windows 10/11:
```powershell
winget install autohotkey
```

### Step 2: Download and run Mizu-Keys for Windows 
Download the [Mizu-Keys for Windows](https://github.com/volatile-torpedo/FLOW-Stasis) release and extract the contents to a folder of your choice. The following command will install the latest release to a folder named `FLOW-Stasis-main` in your `%APPDATA%` folder, which will typically be `C:\Users\<username>\AppData\Roaming\FLOW-Stasis-main`
```powershell
Invoke-WebRequest 'https://github.com/volatile-torpedo/FLOW-Stasis/archive/refs/heads/main.zip' -OutFile .\FLOW-Stasis.zip; Expand-Archive .\FLOW-Stasis.zip -DestinationFolder $env:APPDATA -Force; Remove-Item .\FLOW-Stasis.zip; cd $env:APPDATA\FLOW-Stasis-main; Start-Process .\FLOW-Stasis.ahk
```

### Optional Step 3: Run FLOW Stasis for Windows at startup
To run FLOW Stasis for Windows at startup, click on the system tray icon and check `Run at Startup`.

