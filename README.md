# ⌨️ MIZU Keys

Welcome to **MIZU Keys** – the all-in-one, supercharged AutoHotkey toolkit for Windows power users, keyboard tinkerers, and productivity wizards!  
Unleash a world of hotkeys, automations, and clever tricks, all wrapped up in a friendly, customizable package.

---

## 🚀 Features

- ⚡️ One-click setup for Windows
- 🪄 Powerful global hotkeys and automations (AutoHotkey v2)
- 🎛️ Easy tray menu for quick access
- 🔊 Fun sound effects and notifications
- 🧩 Modular library – add your own scripts!

Check out the [full list of hotkeys and](docs/README.md#hotkeys) and [features](docs/README.md#features) to see what MIZU Keys can do for you!

- 📜 [Documentation](docs/README.md) for all the nitty-gritty details

---

## 🛠️ Quick Install (The Magic Way)

**No downloads, no fuss!**  
Just open PowerShell as Administrator and run this single command:

```powershell
iex "& { $(irm 'https://raw.githubusercontent.com/voltaire-toledo/mizu-keys/main/start-mizukeys.ps1') }"
```

This will:

- Download the latest MIZU Keys release from GitHub  
- Set up AutoHotkey (portable, no admin install needed)
- Create a Start Menu shortcut
- Launch MIZU Keys for you!

> [!NOTE]  
> The script will automatically install it into your profile's %LOCALAPPDATA%\Mizu-Keys directory.

---

## 🧑‍💻 Manual Install

Prefer the classic way? No problem!

1. **Download the repo:**

   ```powershell
   Invoke-WebRequest 'https://github.com/voltaire-toledo/mizu-keys/archive/refs/heads/main.zip' -OutFile .\Mizu-Keys.zip
   Expand-Archive .\Mizu-Keys.zip -DestinationFolder $env:APPDATA -Force
   Remove-Item .\Mizu-Keys.zip
   cd $env:APPDATA\Mizu-Keys-main
   ```

2. **Run the script:**

   Double-click [mizu-keys.ahk](http://_vscodecontentref_/0) or run it with AutoHotkey v2.

---

## 🏁 Run at Startup

Want MIZU Keys to launch every time you log in?  
Just right-click the tray icon and select **"Run at Startup"**. Easy!

---

## 🗂️ Project Structure

```plaintext
mizu-keys/
├── mizu-keys.ahk         # Main script
├── start-mizukeys.ps1    # PowerShell installer
├── lib/                  # Modular AHK libraries
├── media/                # Icons & sounds
└── README.md
```

---

## 🤝 Contributing

Pull requests, ideas, and fun new hotkeys are always welcome!  
Open an [issue](https://github.com/voltaire-toledo/mizu-keys/issues) or submit a PR.

---

## 💬 Questions? Suggestions?

Ask away in the [issues](https://github.com/voltaire-toledo/mizu-keys/issues) or start a discussion.  
We love making Windows more fun and productive!

---

**Stay sharp, stay speedy, and enjoy your new keyboard superpowers!**

— Proventuras
