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


# install powerline-go
Write-Host "Installing powerline-go"
if (Test-Path -Path $HOME\bin\powerline-go) {
  rm $HOME\bin\powerline-go
}
New-Item -ItemType Directory -Force -Path $HOME\bin
$repoName = "justjanne/powerline-go"
$assetPattern = "*-windows-amd64.exe"
$extractPath = "$HOME\bin\powerline-go"

$releasesUri = "https://api.github.com/repos/$repoName/releases/latest"
$asset = (Invoke-WebRequest $releasesUri | ConvertFrom-Json).assets | Where-Object name -like $assetPattern
$downloadUri = $asset.browser_download_url

Invoke-WebRequest -Uri $downloadUri -Out $extractPath
