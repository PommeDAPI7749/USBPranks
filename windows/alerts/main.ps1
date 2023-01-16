# Met le script en pause tant que la souris est imobile

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


echo "Your computer has been hacked."
sleep 5
echo "Your files have been encrypted by LesCrackitotistes."
sleep 5
echo "If you would like to have your files restored please contact this email." 
echo "lescrackitotistesresponseteam@mail.com"
sleep 60
echo "I can't believe you fell for that. This is a prank powershell script that says you have been hacked."
sleep 5
echo "Remember to Windows + L ;)"