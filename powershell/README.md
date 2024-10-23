# Setup

1. Run the script `install.ps1` with PowerShell running as administrator.
2. Set `ssh-agent` to run on startup. Run the following command in PowerShell running as administrator:

```powershell
Get-Service ssh-agent | Set-Service -StartupType Automatic -PassThru | Start-Service
```

3. Create symlink to WSL2 `id_ed25519` command:

```powershell
New-Item -ItemType SymbolicLink -Path $env:USERPROFILE\.ssh\id_ed25519 -Value \\wsl$\Ubuntu-20.04\home\$(whoami)\.ssh\id_ed25519
```
