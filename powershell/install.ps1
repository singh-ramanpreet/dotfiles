# dotfiles dir path
$thisScriptPath = $MyInvocation.MyCommand.Path
$dotfilesPath = Split-Path (Split-Path $thisScriptPath -Parent) -Parent


# create profile
New-Item $PROFILE -ItemType Directory -Force -ErrorAction SilentlyContinue


# symlink to dotfile
Write-Host "Creating symbolic links to dotfiles"
Write-Host "  ... profile.ps1"
New-Item -Force -Path $PROFILE -ItemType SymbolicLink -Value $dotfilesPath\powershell\profile.ps1
Write-Host "  ... gitconfig"
New-Item -Force -Path $HOME\.gitconfig -ItemType SymbolicLink -Value $dotfilesPath\gitconfig
Write-Host "  ... wslconfig"
New-Item -Force -Path $HOME\.wslconfig -ItemType SymbolicLink -Value $dotfilesPath\wslconfig
Write-Host "  ... ssh config"
New-Item -Force -Path $HOME\.ssh\config -ItemType SymbolicLink -Value $dotfilesPath\ssh-config


# install starship
Write-Host "Installing starship"
winget install --id Starship.Starship
